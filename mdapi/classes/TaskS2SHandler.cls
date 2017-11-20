/**
* ===============================================================================================
*   Version     Date              Comment
* ===============================================================================================
*   Initial     8-Mar-2017        - Trigger handler to insert Task records in connected orgs
*
*/
public with sharing class TaskS2SHandler {

    public static final String STR_EXABLOX_CONNECTION = Label.Exablox_Connection_Name;
    public static final String STR_AU_CONNECTION = Label.AU_Connection_Name;

    public void insertedTasks(Map<ID,Task> newTaskMap){
        // Define connection id
        Set<ID> networkIDsSet = new Set<ID>{ConnectionHelper.getConnectionId(STR_EXABLOX_CONNECTION),
                                            ConnectionHelper.getConnectionId(STR_AU_CONNECTION)};

        // only share records created in this org, do not add tasks received from another org.
        Set<Id> localTaskLeadIDsSet = new Set<Id>();
        List<Task> localTasksList = new List<Task>();
        for(Task objTask : newTaskMap.values()) {

            if (objTask.ConnectionReceivedId == null && objTask.whoId != null && !objTask.IsRecurrence) {
                String parentLeadId = objTask.whoId;
                if(parentLeadId.startsWith('00Q')) {
                    localTaskLeadIDsSet.add(objTask.whoId);
                    localTasksList.add(objTask);
                }
            }
        }

        Map<Id, list<PartnerNetworkRecordConnection>> sharedLeadMap = new Map<Id, list<PartnerNetworkRecordConnection>>();
        if (!localTaskLeadIDsSet.isEmpty()) {
            // Get the task lead's partner network record connections
            for (PartnerNetworkRecordConnection leadSharingRecord : [SELECT Status, LocalRecordId, ConnectionId
                                                                     FROM PartnerNetworkRecordConnection
                                                                     WHERE LocalRecordId IN :localTaskLeadIDsSet
            ]) {
            // for each partner connection record for task's Lead, check if it is active
            if ((leadSharingRecord.status.equalsignorecase('Sent')
            || leadSharingRecord.status.equalsignorecase('Received')
            || (Test.isRunningTest() && leadSharingRecord.status.equalsignorecase('Invite')))
            && (networkIDsSet.contains(leadSharingRecord.ConnectionId))) {
                if(sharedLeadMap.containskey(leadSharingRecord.LocalRecordId))
                    sharedLeadMap.get(leadSharingRecord.LocalRecordId).add(leadSharingRecord);
                else
                    sharedLeadMap.put(leadSharingRecord.LocalRecordId, new list<PartnerNetworkRecordConnection>{leadSharingRecord});
                }
            }

            if(!sharedLeadMap.isEmpty() && sharedLeadMap.size() > 0) {
                List<PartnerNetworkRecordConnection> taskConnections =  new  List<PartnerNetworkRecordConnection>();
                for(Task newTask : localTasksList) {
                    if(sharedLeadMap.containskey(newTask.whoId)) {
                        for(PartnerNetworkRecordConnection leadId : sharedLeadMap.get(newTask.whoId)) {
                            taskConnections.add(new PartnerNetworkRecordConnection(ConnectionId = leadId.ConnectionId,
                                                                                   LocalRecordId = newTask.Id,
                                                                                   SendClosedTasks = false,
                                                                                   SendOpenTasks = false,
                                                                                   SendEmails = false,
                                                                                   ParentRecordId = newTask.whoId
                            ));
                        }
                    }
                }
                if (!taskConnections.isEmpty()) {
                    try{
                        insert taskConnections;
                    }
                    catch(DmlException e) {
                        // @Developer : Add Error Handling Logic Here.
                    }
                }
            }
        }
    }
}