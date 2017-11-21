@isTest
public class CaseEmergencyScheduledTest {
    static testMethod void testSchedule() {
        CaseEmergencyScheduled.scheduleMe();
        String srch = CaseEmergencyScheduled.prefix+':%';
        List<CronTrigger> crons = [select CronJobDetail.Name from CronTrigger where CronJobDetail.Name LIKE :srch];
        System.assertEquals(6, crons.size());
    }
    
    static testMethod void testExecute() {
        CaseEmergencyScheduled ces = new CaseEmergencyScheduled();
        ces.execute(null);
        // TODO: How to verify this??
    }
    
    static testMethod void testTrigger() {
        CaseEmergencyTriggerEmail cete = new CaseEmergencyTriggerEmail();
        cete.execute(null);
        // TODO: can't verify case changes because workflow rule will fire and unset the flag
    }
}