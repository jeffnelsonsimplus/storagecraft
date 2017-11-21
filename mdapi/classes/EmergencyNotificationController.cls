public class EmergencyNotificationController {
    public Map<Id, Integer> waitTime {get;set;}
    public Integer openEmergencies {get;set;}
    
    // Fields we MUST get from the case to build our basic data. Additional fields added by way of Field Set
    private Set<String> queryFields = new Set<String>{'Status', 'Description', 'Owner.Name', 
                'OwnerId', 'First_Owner_On__c', 'First_Owner__r.Name', 'CreatedDate'};
    
    // get fields from controlling field set
    private List<Schema.FieldSetMember> fieldsetmembers = SObjectType.Case.FieldSets.EmergencyFIeldset.getFields();
    // Build individual lists for api names and labels
    public List<String> queryFieldsFromFieldset {get{
        if(this.queryFieldsFromFieldSet != null)
            return this.queryFieldsFromFieldSet;
        
        this.queryFieldsFromFieldSet = new List<String>();
        
        for(Schema.FieldSetMember f2 : fieldsetmembers) {
            this.queryFieldsFromFieldset.add(f2.getFieldPath());
        }
        return this.queryFieldsFromFieldset;
    }private set;}
    
    public List<String> FieldLabelFromFieldset {get{
        if(this.FieldLabelFromFieldset != null)
            return this.FieldLabelFromFieldset;
        
        this.FieldLabelFromFieldset = new List<String>();
        
        for(Schema.FieldSetMember f2 : fieldsetmembers) {
            this.FieldLabelFromFieldset.add(f2.getLabel());
        }
        return this.FieldLabelFromFieldset;
    }private set;}
    
    public Set<String> fieldNames {get{
        
        Set<String>  combined = new Set<String>();
        combined.addAll(queryFieldsFromFieldset);
        combined.addAll(queryFields);
        
        return combined;
        
    } set;}
    
    public List<String> columnHeadersList{get{
        
        system.debug('fieldsetmembers inside columnHeaders getset ==== > ' + fieldsetmembers);
        List<String> temp_columnHeaders = new List<String>();
        
        for(Schema.FieldSetMember f2 : fieldsetmembers) {
            if(!queryFields.contains(f2.getFieldPath())) {
                temp_columnHeaders.add(f2.getLabel());
            }               
        } 
        
        return temp_columnHeaders;
    } set;} 
    
    public String getQueryString(){
        //create string variable to populate with the soql statement
        String queryStringLocal =  'SELECT Id';
        fieldNames.remove('Id'); // Already included in query, added to facilitate comma separations
        
        for(string s : fieldNames) {
            queryStringLocal += ', '+s;
        }      
        
        queryStringLocal += ' from Case  where Priority = \'Emergency\' AND CreatedDate = LAST_N_DAYS:2 ORDER BY CreatedDate DESC';      
        
        system.debug('queryStringLocal inside get/set queryString2 ===> ' + queryStringLocal);
        
        return queryStringLocal;
        
    }
    
     
    public List<Case> eCases {get{
      List<Case> cases = (List<Case>)Database.query(getQueryString()); 
 
        openEmergencies = 0;
        ownedByQueue = new Map<Id, Boolean>();
        waitTime = new Map<Id, Integer>();
        DateTime now = DateTime.now();
        
        for(Case c : cases){
            System.debug(c);
            if(c.First_Owner_On__c == null || (c.Owner.Name != null && c.Owner.Name.contains('Emergency'))){
                openEmergencies++;
                waitTime.put(c.Id, getElapsedMinutes(c.CreatedDate, now));
            } else {
                waitTime.put(c.Id, getElapsedMinutes(c.CreatedDate, c.First_Owner_On__c));
            }
            System.debug('Owner Type:'+c.OwnerId.getSObjectType().getDescribe().getName());
            if(c.OwnerId.getSObjectType().getDescribe().getName() == 'User')
                ownedByQueue.put(c.Id, false);
            else {
                ownedByQueue.put(c.Id, true);
            }
            
        }
        return cases;
    }set;}
    
    public Map<Id, Boolean> ownedByQueue {get;set;}
 
    public Id caseToAssign {get;set;}
    
    public void assignToMe(){
        // get case number
        System.debug(caseToAssign);
        Case c = [Select Id, OwnerId from Case where Id = :caseToAssign];
        if(c.OwnerId.getSObjectType().getDescribe().getName() == 'User')
            return;
        // set owner to me
        c.OwnerId = UserInfo.getUserId();
        Update c;
        // return null so we can rerender
        return;
    }
    
    public Integer getElapsedMinutes(DateTime start, DateTime stop){
        Long dt1Long = start.getTime();
        Long dt2Long = stop.getTime();
        Long milliseconds = dt2Long - dt1Long;
        Long seconds = milliseconds / 1000;
        Long minutes = seconds / 60;
        return (Integer)minutes;
    }
}