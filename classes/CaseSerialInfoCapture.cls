public class CaseSerialInfoCapture {

    // These variables store Trigger.oldMap and Trigger.newMap
    Map<Id, Case> oldMap;
    Map<Id, Case> newMap;
    List<Case> newList;

    // This is the constructor
    // A map of the old and new records is expected as inputs
    public CaseSerialInfoCapture(
        Map<Id, Case> oldTrigger,
        Map<Id, Case> newTrigger,
    	List<Case> newTriggerList) {
            oldMap = oldTrigger;
            newMap = newTrigger;
            newList = newTriggerList;
        }
    static Set<Id> queuedCases = new Set<Id>();
    // The one method your master trigger will call
    public void getSerialInfoForCases() {
        // Logic
        // TODO: Bulkify, will need to find out if web service can bulkify
        System.debug('---newList--'+newList);
        if(newList.size() > 1)
            return;
        for(Case c: newList){
            if(c.Serial_Number__c != null && c.Serial_Number_Details__c == null){
                if(!queuedCases.contains(c.Id)){
                    queuedCases.add(c.Id);
                    System.debug('queueing serial capture');
                    System.enqueueJob(new CaseSerialDetailCapture(c));
                }
            }
        }
    }
}