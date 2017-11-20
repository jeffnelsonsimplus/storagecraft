@isTest
public class EmergencyNotificationControllerTest {
	@testSetup static void setupTest() {
	}
    
    static testMethod void test1() {
		List<Case> cases = new List<Case>();
        cases.add(new Case(Priority='Emergency', OwnerId = UserInfo.getUserId(), First_Owner_On__c = Datetime.now()));
        Insert cases;
        
        EmergencyNotificationController enc = new EmergencyNotificationController();
        System.assertEquals(1, enc.eCases.size());
        System.assertEquals(0, enc.openEmergencies);
        System.assertEquals(false, enc.ownedByQueue.values()[0]);
        enc.caseToAssign = enc.eCases[0].Id;    
        enc.assignToMe();
    }
    
    
    static testMethod void test2() {
		List<Case> cases = new List<Case>();
        Group g = [Select Id from Group where Name = 'Emergency'];
        cases.add(new Case(Priority='Emergency', OwnerId = g.Id));
        Insert cases;
        
        EmergencyNotificationController enc = new EmergencyNotificationController();
        System.assertEquals(1, enc.eCases.size());
        System.assertEquals(1, enc.openEmergencies);
        System.assertEquals(true, enc.ownedByQueue.values()[0]);
        enc.caseToAssign = enc.eCases[0].Id;    
        enc.assignToMe();
    }
}