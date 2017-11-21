public class CaseEmergencyTriggerEmail implements CaseEmergencyScheduled.IScheduleDispatched {
    public void execute(SchedulableContext sc){
        List<Case> cases = [select id from case where Case_Owner_Name__c LIKE '%Emergency%' AND Needs_Emergency_Reminder__c = false AND IsClosed = false];
        for(Case c: cases){
            c.Needs_Emergency_Reminder__c = true;
        }
        Update cases;
    }
}