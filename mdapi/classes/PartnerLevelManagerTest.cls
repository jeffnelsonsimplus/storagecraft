@isTest
public class PartnerLevelManagerTest {
/** Replaced by FLOW
    static TestMethod void test_trigger1() {
        System.debug('TEST 1:  Override Gold to Silver');
        
        test.startTest();
        
        account acct = new account(Name = 'Account Trigger Test 1',  
                                   Type = 'Account',
                                   User_Type__c = 'Both MSP and VAR',
                                   Partner_Level__c = 'Authorized', 
                                   Partner_Level_Calculated__c = 'Gold',
                                   BillingState = 'US',
                                   BillingCountry = 'CA',
                                   BillingPostalCode = '94132'
                                  );
        insert acct;        
        
        acct.Partner_Level_Calculated__c = 'Silver';
        acct.Partner_Level_Overwritten__c = true;
        
        update acct;
        
        acct = (Account) [SELECT Type, Partner_Level__c, Partner_Level_Calculated__c, Partner_Level_Overwritten__c FROM Account WHERE Id = :acct.Id];
        
        System.debug('Type: ' + acct.Type + '  Partner Level Calculated: ' + acct.Partner_Level_Calculated__c + '  Partner Level: ' + acct.Partner_Level__c + '  Partner_Level_Overwritten__c: ' + acct.Partner_Level_Overwritten__c);
        System.assertEquals('Authorized', acct.Partner_Level__c);
        System.assertEquals('Silver', acct.Partner_Level_Calculated__c);  
        
        test.stopTest();      
    }  
    
    static TestMethod void test_trigger2(){
        System.debug('TEST 2:  Change the calculated level');
        
        account acct = new account(Name = 'Account Trigger Test 2', 
                                   Type = 'Account',
                                   User_Type__c = 'Both MSP and VAR',
                                   Partner_Level_Calculated__c = 'Gold',
                                   Partner_Level_Overwritten__c = false,
                                   BillingState = 'US',
                                   BillingCountry = 'CA',
                                   BillingPostalCode = '94132');
        insert acct;
        
        test.startTest();
        
        acct.Partner_Level_Calculated__c = 'Silver';
                
        update acct;
        
        acct = (Account) [SELECT Type, Partner_Level__c, Partner_Level_Calculated__c, Partner_Level_Overwritten__c FROM Account WHERE Id = :acct.Id];
        
        System.debug('Type: ' + acct.Type + '  Partner Level Calculated: ' + acct.Partner_Level_Calculated__c + '  Partner Level: ' + acct.Partner_Level__c + '  Partner_Level_Overwritten__c: ' + acct.Partner_Level_Overwritten__c);
        System.assertEquals('Silver', acct.Partner_Level__c);
        System.assertEquals('Silver', acct.Partner_Level_Calculated__c);        
        
        test.stopTest();
    }    
    
    static TestMethod void test_trigger4(){
        System.debug('TEST 4:  Try to change Partner Level');
        
        account acct = new account(Name = 'Account Trigger Test 4',
                                   Type = 'Account',
                                   Partner_Level__c = 'Platinum', 
                                   Partner_Level_Calculated__c = 'Gold',
                                   Partner_Level_Overwritten__c = true,
                                   BillingState = 'US',
                                   BillingCountry = 'CA',
                                   BillingPostalCode = '94312');
        insert acct;
        
        acct.Partner_Level__c = 'Silver';
        
        update acct;
        
        acct = (Account) [SELECT Type, Partner_Level__c, Partner_Level_Calculated__c, Partner_Level_Overwritten__c FROM Account WHERE Id = :acct.Id];
                
        System.debug('Type: ' + acct.Type + '  Partner Level Calculated: ' + acct.Partner_Level_Calculated__c + '  Partner Level: ' + acct.Partner_Level__c + '  Partner_Level_Overwritten__c: ' + acct.Partner_Level_Overwritten__c);
        System.assertEquals('Silver', acct.Partner_Level__c);     
    } 
   
    static TestMethod void test_trigger5(){
        System.debug('TEST 5:  Just try setting the value on an Account');
        
        account acct = new account(Name = 'Account Trigger Test 5',
                                   User_Type__c = 'Both MSP and VAR',  
                                   Type = 'Account',
                                   Partner_Level_Overwritten__c = false,
                                   BillingState = 'US',
                                   BillingCountry = 'CA',
                                   BillingPostalCode = '19432');
        insert acct;
        
        acct.Partner_Level__c = 'Silver';
        
        update acct;
        
        acct = (Account) [SELECT Type, Partner_Level__c, Partner_Level_Calculated__c, Partner_Level_Overwritten__c FROM Account WHERE Id = :acct.Id];
        
        System.debug('Type: ' + acct.Type + '  Partner Level Calculated: ' + acct.Partner_Level_Calculated__c + '  Partner Level: ' + acct.Partner_Level__c + '  Partner_Level_Overwritten__c: ' + acct.Partner_Level_Overwritten__c);
        System.assertEquals('Authorized', acct.Partner_Level__c);
        System.assertEquals('Authorized', acct.Partner_Level_Calculated__c);      
    }
   
    static TestMethod void test_trigger6(){
        System.debug('TEST 6: Uncheck Overwrite');
        
        account acct = new account(Name = 'Account Trigger Test 5',
                                   User_Type__c = 'Both MSP and VAR',  
                                   Type = 'Account',
                                   Partner_Level__c = 'Gold',
                                   Partner_Level_Calculated__c = 'Silver',
                                   Partner_Level_Overwritten__c = true,
                                   BillingState = 'US',
                                   BillingCountry = 'CA',
                                   BillingPostalCode = '19432');
        insert acct;
        
        acct.Partner_Level_Overwritten__c = false;
        
        update acct;
        
        acct = (Account) [SELECT Type, Partner_Level__c, Partner_Level_Calculated__c, Partner_Level_Overwritten__c FROM Account WHERE Id = :acct.Id];
               
        System.debug('Type: ' + acct.Type + '  Partner Level Calculated: ' + acct.Partner_Level_Calculated__c + '  Partner Level: ' + acct.Partner_Level__c + '  Partner_Level_Overwritten__c: ' + acct.Partner_Level_Overwritten__c);
        System.assertEquals('Silver', acct.Partner_Level__c);
        System.assertEquals('Silver', acct.Partner_Level_Calculated__c);      
    }
**/
}