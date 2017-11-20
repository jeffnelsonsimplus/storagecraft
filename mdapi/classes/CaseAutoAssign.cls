global class CaseAutoAssign {

    public enum AssignmentStatus {SUCCESS, FAILURE, OVERFLOW}
    
    Map<Id,Case> oldMap;
    Map<Id, Case> newMap;
    List<Case> newList;
    
    public CaseAutoAssign (
        Map<Id, Case> oldTrigger, 
        Map<Id, Case> newTrigger) {
            oldMap = oldTrigger;
            newMap = newTrigger;
            this.newList = newMap.values();
        }
    
    public CaseAutoAssign(List<Case> newList){
        this.newList = newList;
    }
    
    // The one method your master trigger will call
    public void AssignCases() {
        // Determine if auto-assignment logic is enabled in Custom Settings
        if(autoAssignEnabled() == false)
            return;
        
        // Get all Queue_Auto_Assign_Settings__c custom settings
        // Complete info for queues, ids and such, (lookup by name), log any invalid names but don't crash
        Map<Id, queue> queues = assembleQueueInfo();
        
        List<Queue> actvQueues = new List<Queue>();
        for(Queue q: queues.values())
            if(q.Active)
                actvQueues.add(q);
                
        actvQueues.sort();
        
        
        System.Debug(queues);
        // Get all cases owned by an active queue
        Map<Id, List<Case>> assignMe = new Map<Id, List<Case>>();
        
        List<Case> cList ;
        for(Case c: newList){
            if(queues.containsKey(c.OwnerId) && queues.get(c.OwnerId).Active == true){
                if(assignMe.containsKey(c.OwnerId))
                    cList = assignMe.get(c.OwnerId);
                else
                    cList  = new List<Case>();
                cList.add(c);
                assignMe.put(c.OwnerId,cList);
            }
        }
        
        // No cases that need our auto-assignment, we're done here
        if(assignMe.isEmpty())
            return;
        
        // If there are any cases to be auto-assigned then build up queue member availabilty (including fallback queues)
        Set<Id> queueMembers = new Set<Id>();
        for(queue q: actvQueues){
            for(GroupMember gm: q.members){
                queueMembers.add(gm.UserOrGroupId);
            }
        }
        
        System.Debug('Members of Active Queues:'+queueMembers);
        
        List<QueueMember> qms = getQueueMemberInformation(queueMembers);
        qms.sort();
        
        System.Debug('Populated Queue Members:'+qms);
        
        
        //////////////////////////////
        // Workflow for making actual assignments
        
        Case wrk;
        List<Case> tmpCase;
        while(haveCaseToAssign(assignMe)){
            for(Queue g: actvQueues){
                if(assignMe.containsKey(g.qID) && !assignMe.get(g.qID).isEmpty()){
                    tmpCase = assignMe.get(g.qID);
                    wrk = tmpCase.remove(0);
                    break;
                }
            }
            // work on the case and attempt assignment
            AssignmentStatus caStatus = findBestAssignment(wrk, queues.get(wrk.OwnerId), qms);
            
            // We did it!
            if(caStatus == AssignmentStatus.SUCCESS){
                System.debug('Assigned '+wrk.Id +', subject '+wrk.Subject+' to '+wrk.OwnerId);
                continue;
            }
                
            if(caStatus == AssignmentStatus.FAILURE && queues.get(wrk.OwnerId).fallbackQueueId != null){
                // Change the owner of the case
                wrk.OwnerId = queues.get(wrk.OwnerId).fallbackQueueId;
                
                // Determine if new owning queue has active assignment rules
                if(queues.containsKey(wrk.OwnerId) && queues.get(wrk.OwnerId).Active){
                    // If needed place case back in assignMe list to be processed
                    if(assignMe.containsKey(wrk.OwnerId))
                        tmpCase = assignMe.get(wrk.OwnerId);
                    else
                        tmpCase = new List<Case>();
                    tmpCase.add(wrk);
                    assignMe.put(wrk.OwnerId, tmpCase);
                }
            }
            
            if(caStatus == AssignmentStatus.OVERFLOW && queues.get(wrk.OwnerId).overflowQueueId != null){
                // Change the owner of the case
                wrk.OwnerId = queues.get(wrk.OwnerId).overflowQueueId;
                
                // Determine if new owning queue has active assignment rules
                if(queues.containsKey(wrk.OwnerId) && queues.get(wrk.OwnerId).Active){
                    // If needed place case back in assignMe list to be processed
                    if(assignMe.containsKey(wrk.OwnerId))
                        tmpCase = assignMe.get(wrk.OwnerId);
                    else
                        tmpCase = new List<Case>();
                    tmpCase.add(wrk);
                    assignMe.put(wrk.OwnerId, tmpCase);
                }
            }
            
            // if can't make assignment then change owner to fallback if present
            
            // if fallback is present in group list then put back in rotation for assignment
            
        }
    }
    
    
    
    // Loops through the group membership of the queue and find new assignments
    private AssignmentStatus findBestAssignment(Case c, Queue q, List<QueueMember> qms){
        AssignmentStatus ca = AssignmentStatus.FAILURE;
        List<GroupMember> gm = q.members;
        if(gm.isEmpty())
            return ca;
        // Build a set of IDs so we can go through the members and locate the most qualified user
        Set<Id> gmIds = new Set<Id>();
        for(GroupMember g: gm)
            gmIds.add(g.UserOrGroupId);
        
        // Loop through list of all queue members and determine qualifications for receiving the subject case
        // We loop through the mast list because we're able to sort it so the most qualified are on top
        qms.sort();
        System.Debug('QMS Sorted:'+qms);
        for(QueueMember qm: qms){
            // If user in unavailable the skip
            if(!qm.Available)
                continue;
            // TODO: test case status
            
            // if this user isn't in the membership for this queue then skip
            if(!gmIds.contains(qm.qmId))
                continue;
            // test for overflow
            System.debug('Load value:'+qm.loadValue());
            System.debug('Overflow Limit:'+q.overflowLimit);
            if(q.overflowLimit != null && qm.loadValue() >= q.overflowLimit){
                ca = AssignmentStatus.OVERFLOW;
                continue;
            }
            // We made it, looks like our most qualified candidate!
            c.OwnerId = qm.qmId;
            qm.recordAssignment();
            ca = AssignmentStatus.SUCCESS;
            break;
        }
        
        return ca;
    }
    
    // Test list of pending cases to see if we have any that still need assignment
    private Boolean haveCaseToAssign(Map<Id, List<Case>> assignMe){
        for(List<Case> cList: assignMe.values()){
            if(!cList.isEmpty())
                return true;
        }
        return false;
    }
    
    // Check custom setting to determine if auto-assignment is enabled
    // Entire process can be toggled on and off in Custom Settings in the setup menu
    // Can be modified organization wide or per-user
    // For more information lookup Hierarchy custom settings
    public Boolean autoAssignEnabled() {
        STC_Process_Controlls__c controls = STC_Process_Controlls__c.getInstance();
        System.Debug('Master Control: '+controls);
        return controls.Case_Auto_Assignment_Enabled__c;
    }
    
    // Get Queue management custom settings and assemble additional information
    public Map<Id, queue> assembleQueueInfo(){
        Map<Id, queue> qMap = new Map<Id, queue>();
        Map<String, Queue_Auto_Assign_Settings__c> qSett = Queue_Auto_Assign_Settings__c.getAll();
        Map<Id, Group> groups = new Map<Id, Group>([SELECT Id, DeveloperName, Type, (select UserOrGroupId from GroupMembers) FROM Group where Type = 'Queue']);
        Map<String, Id> groupByName = new Map<String, Id>();
        for(Group q: groups.values()){
            groupByName.put(q.DeveloperName, q.Id);
        }
        
        for(Queue_Auto_Assign_Settings__c qa: qSett.values()){
            if(!groupByName.containsKey(qa.Name)){
                System.Debug(LoggingLevel.WARN, 'Custom Setting referenced non-existent queue:'+qa.Name);
                continue;
            }    
            Id gId = groupByName.get(qa.Name);
            queue mQueue = new queue();
            mQueue.name = qa.Name;
            mQueue.priority = qa.Assignment_Priority__c;
            mQueue.qID = gId;
            mQueue.fallbackQueue = qa.Fallback_Queue_Name__c;
            mQueue.fallbackQueueId = groupByName.containsKey(qa.Fallback_Queue_Name__c) ? groupByName.get(qa.Fallback_Queue_Name__c) : null;
            mQueue.overflowQueue = qa.Overflow_Queue_Name__c;
            mQueue.overflowQueueId = groupByName.containsKey(qa.Overflow_Queue_Name__c) ? groupByName.get(qa.Overflow_Queue_Name__c) : null;
            mQueue.overflowLimit = qa.Overflow_Limit__c;
            mQueue.Active = qa.Active__c;
            mQueue.members = groups.get(gId).GroupMembers;
            qMap.put(gId,mQueue);
        }
        return qMap;
    }
    
    @TestVisible
    private List<QueueMember> getQueueMemberInformation(Set<Id> members){
        // eval id type, only proceed on users for now
        // TODO: build for Role
        // TODO: build for Role and Subordinates
        // TODO: build for Public Groups
        Map<Id, User> users = new Map<Id, User>([select Id, Case_Assign_Debt__c, Case_Assign_Debt_Date__c, 
                                                 Case_Assign_Load_Modifier__c, Case_Assign_Qualified_Priorities__c, TimeZoneSidKey
                                                 from User where Id in: members and IsActive = true]);
        Map<Id, QueueMember> qm = new Map<Id, QueueMember>();
        
        for(User u: users.values()){
            QueueMember m = new QueueMember();
            m.numAssignments = 0;
            m.groups = new Set<Id>();
            m.lastAssignment = null;
            m.loadModifier = u.Case_Assign_Load_Modifier__c == null? 100 : u.Case_Assign_Load_Modifier__c;
            m.debt = u.Case_Assign_Debt__c == null? 0 : u.Case_Assign_Debt__c;
            m.debtDate = u.Case_Assign_Debt_Date__c;
            m.qmId = u.Id;
            m.available = true;
            m.timeZoneSidKey = u.TimeZoneSidKey;
            m.qualCasePriorites = new Set<String>();
            // handle nulls
            if(u.Case_Assign_Qualified_Priorities__c != null)
            for(String s: u.Case_Assign_Qualified_Priorities__c.split(';')){
                m.qualCasePriorites.add(s);
            }
            System.Debug('**'+m.qualCasePriorites+'**');
            qm.put(u.Id, m);
        }
        
        // Get number of assignments in last 12 hours
        DateTime last12 = Datetime.Now();
        last12 = last12.addHours(-12);
        // Block list of cases
        List<AggregateResult> ars = [select Count(Id)cnt, OwnerId ownid from Case where OwnerId IN :qm.keySet() AND Assignment_Date_Time__c >= :last12 AND SystemModStamp >= :last12 AND CreatedDate >= LAST_N_DAYS:90 Group By OwnerId];
        for(AggregateResult ar: ars){
            qm.get((Id)ar.get('ownid')).numAssignments = (Integer)ar.get('cnt');
        }
        
        // Get last assignment        
        // *Possibly reduce SOQL query count by pulling more record back in previous query and pulling record count and last from a single case object query
        ars = [select Max(Assignment_Date_Time__c)lastassign, OwnerId ownid from Case where CreatedDate >= LAST_N_DAYS:7 AND OwnerId IN :qm.keySet() Group By OwnerId];
        for(AggregateResult ar: ars){
            qm.get((Id)ar.get('ownid')).lastAssignment = (DateTime)ar.get('lastassign');
        }
        
        // Check for any scheduled unavailability
        // get +-1 day so we can consider against user's timezone
        List<User_Time_Off__c> utis = [select OwnerId, Start_Date__c, End_Date__c from User_Time_Off__c 
                                       where Start_Date__c <= TOMORROW AND End_Date__c >= YESTERDAY AND OwnerId IN :qm.keySet()];
        
        for(User_Time_Off__c uti: utis){
            if(qm.get(uti.OwnerId).getLocalDate() >= uti.Start_Date__c && qm.get(uti.OwnerId).getLocalDate() <= uti.End_Date__c)
            	qm.get(uti.OwnerId).available = false;
        }
        
        return qm.values();
    }
    
    global class Queue implements Comparable {
        public String name;
        public Decimal priority;
        public Id qID;
        public String fallbackQueue;
        public Id fallbackQueueId;
        public String overflowQueue;
        public Id overflowQueueId;
        public Decimal overflowLimit;
        public Boolean Active;
        public List<GroupMember> members;
        
        // Compare opportunities based on the opportunity amount.
        global Integer compareTo(Object compareTo) {
            Queue cmpQ = (Queue)compareTo;
            if(this.priority > cmpQ.priority)
                return 1;
            if(this.priority < cmpQ.priority)
                return -1;
            // balanced
            return 0;
        }
    }
    
    global class QueueMember implements Comparable {
        public Integer numAssignments;
        public Set<Id> groups;
        public DateTime lastAssignment;
        public Decimal loadModifier;
        public Decimal debt;
        public Date debtDate;
        public Id qmId;
        public Boolean available;
        public Set<String> qualCasePriorites;
        public String timeZoneSidKey;

        // Compare opportunities based on the opportunity amount.
        global Integer compareTo(Object compareTo) {
            QueueMember cmpQM = (QueueMember)compareTo;
            // Compare number of cases assigned
            if(loadValue() > cmpQM.loadValue())
                return 1;
            if(loadValue() < cmpQM.loadValue())
                return -1;
            // Compare last assignment dates
            if(lastAssignment > cmpQM.lastAssignment)
                return 1;
            if(lastAssignment < cmpQM.lastAssignment)
                return -1;
            // balanced
            return 0;
        }
        
        public Decimal loadValue(){
            Decimal r = 0;
            // Count of assignments in the last 12 hours
            r = this.numAssignments;
            // Modify the assigned values by x (used for tech leads and new staff to lower assignment rate
            r = r / (loadModifier/100);
            // If debt was assigned for today then include debt (positive debt number lowers todays assign count AFTER load modification)
            if(this.debtDate == Datetime.Now().Date())
                r = r - this.debt;
            return r;
        }
        
        public void recordAssignment(){
            this.numAssignments++;
            this.lastAssignment = Datetime.Now();
        }
        
        public Date getLocalDate(DateTime dt){
            return getLocalTime(dt).date();
        }
        
        public Date getLocalDate(){
            return getLocalTime(Datetime.now()).date();
        }
        
        public Datetime getLocalTime(){
            return getLocalTime(Datetime.now());
        }
        
        public Datetime getLocalTime(DateTime dt){
            // use timezoneSID from user to adjust today's calendar date
            // Get subject user's TimeZone
            Timezone tz = TimeZone.getTimeZone(this.timeZoneSidKey);
            // get millisecond offset
            Double offset = tz.getOffset(dt);
            // adjust now to current user
            dt = dt.addSeconds((Integer)(offset / 1000));
            return dt;
        }
    }
}