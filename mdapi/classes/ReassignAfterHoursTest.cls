@isTest
public class ReassignAfterHoursTest {
    @testSetup static void setupTest() {
        Group g = [select id from group where DeveloperName = 'US_Afterhours'];
		Case c = new Case(OwnerId = g.Id);
        Insert c;
        c.OwnerId = g.Id;
        Update c;
	}
    
    static testMethod void testSchedule() {
        ReassignAfterHours.scheduleMe();
        List<CronTrigger> crons = [select CronJobDetail.Name from CronTrigger where CronJobDetail.Name LIKE :ReassignAfterHours.prefix];
        System.assertEquals(1, crons.size());
    }
    
    static testMethod void testExecute() {
        Case c = [Select Id, OwnerId, Owner.Name from Case];
        System.debug(c);
        ReassignAfterHours ces = new ReassignAfterHours();
        ces.execute(null);
        Case nC = [Select Id, OwnerId from Case];
        //System.assertEquals(c.Id, nC.Id);
        //System.assertNotEquals(c.OwnerId, nC.OwnerId);
    }
    
    static testMethod void testDirect() {
        Case c = [Select Id, OwnerId from Case];
        ReassignAfterHoursImpl rahi = new ReassignAfterHoursImpl();
        rahi.execute(null);
        Case nC = [Select Id, OwnerId from Case];
        //System.assertEquals(c.Id, nC.Id);
        //System.assertNotEquals(c.OwnerId, nC.OwnerId);
    }
}