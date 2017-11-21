@isTest
public class PartnerCaseNotificationControllerTest {
    @testSetup static void setupTest() {
    }
    
    static testMethod void test1() {
        account acct = new account(Name = 'Partner Case Test', 
                                   User_Type__c = 'Both MSP and VAR', 
                                   Partner_Level__c = 'Platinum',
                                   Partner_Level_Overwritten__c = True,
                                   Partner_Level_Calculated__c = 'Platinum'
                                   );
        insert acct;
   
        List<Case> cases = new List<Case>();
        cases.add(new Case(
          AccountId = acct.id,
          OwnerId = UserInfo.getUserId(),
          First_Owner_On__c = Datetime.now(),
          Select_User_Type__c = 'Both MSP and VAR',
          Assistance_Type__c = 'Technical Assistance'));
        Insert cases;
        
        PartnerCaseNotificationController enc = new PartnerCaseNotificationController();
        System.assertEquals(1, enc.eCases.size());
        System.assertEquals(0, enc.openPCases);
        System.assertEquals(false, enc.ownedByQueue.values()[0]);
        enc.caseToAssign = enc.eCases[0].Id;    
        enc.assignToMe();
    }
    
    
    static testMethod void test2() {
        account acct = new account(Name = 'Partner Case Test 2', 
                                   User_Type__c = 'Both MSP and VAR', 
                                   Partner_Level__c = 'Platinum',
                                   Partner_Level_Overwritten__c = True,
                                   Partner_Level_Calculated__c = 'Platinum'
                                   );
        insert acct;

        List<Case> cases = new List<Case>();
        Group g = [Select Id from Group where Name = 'US Partner'];
        cases.add(new Case(
          AccountId = acct.id,
          OwnerId = g.Id,
          Select_User_Type__c = 'Both MSP and VAR',
          Assistance_Type__c = 'Technical Assistance'));
        Insert cases;
        
        PartnerCaseNotificationController enc = new PartnerCaseNotificationController();
        System.assertEquals(1, enc.eCases.size());
        System.assertEquals(1, enc.openPCases);
        System.assertEquals(true, enc.ownedByQueue.values()[0]);
        enc.caseToAssign = enc.eCases[0].Id;    
        enc.assignToMe();
    }
}