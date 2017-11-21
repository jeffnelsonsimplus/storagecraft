@isTest
private class AcademyCertificateManagerTest {       
    static TestMethod void test_trigger1() {        
        Account testAccount = new Account(
            Name = 'Account Trigger Testing',
            Type = 'Account',
            Partner_Level__c = 'None', 
            Partner_Level_Calculated__c = 'None',
            Partner_Level_Overwritten__c = false,
            BillingCity = 'Holladay',
            BillingState = 'UT',
            BillingCountry = 'US',
            BillingPostalCode = '84117'
        );
        
        insert testAccount;
        
        System.debug('Account Id: ' + testAccount.id);
        
        Contact testContact = new Contact(FirstName = 'Test', 
                                          LastName = 'Dude',
                                          MailingState = 'UT',
                                          MailingCountry = 'US',
                                          MailingPostalCode = '84117',
                                          AccountId = testAccount.Id
                                         );
        insert testContact;
        
        System.debug('Test Contact: ' + testContact);
        
        Academy_Certificate__c cert = new Academy_Certificate__c( 
                                              Certified_Contact__c = testContact.Id,
                                              Certification__c = 'StorageCraft_Certified_Engineer'
                                         );
        insert cert;
                
        cert = [SELECT Id, Contact_Account__c FROM Academy_Certificate__c WHERE Id = :cert.Id];
        
        System.assert(cert.Contact_Account__c == testContact.AccountId);        
    }   
    
    static TestMethod void test_trigger2() {        
        Account testAccount = new Account(
            Name = 'Account Trigger Testing',
            Type = 'Account',
            Partner_Level__c = 'None', 
            Partner_Level_Calculated__c = 'None',
            Partner_Level_Overwritten__c = false,
            BillingCity = 'Holladay',
            BillingState = 'UT',
            BillingCountry = 'US',
            BillingPostalCode = '84117'
        );
        
        insert testAccount;
        
        System.debug('Account Id: ' + testAccount.id);
        
        Contact testContact = new Contact(FirstName = 'Test', 
                                          LastName = 'Dude',
                                          MailingState = 'UT',
                                          MailingCountry = 'US',
                                          MailingPostalCode = '84117',
                                          AccountId = testAccount.Id
                                         );
        insert testContact;
        
        System.debug('Test Contact: ' + testContact);       
        
        Academy_Certificate__c cert = new Academy_Certificate__c( 
                                              Certified_Contact__c = testContact.Id,
                                              Certification__c = 'StorageCraft_Certified_Engineer'
                                         );
        insert cert;
         
        Account newAccount = new Account(
                                      Name = 'Account Trigger Test 2', 
                                      Type = 'Account', 
                                      Partner_Level__c = 'None', 
                                      Partner_Level_Calculated__c = 'None',
                                      Partner_Level_Overwritten__c = false,
                                      BillingCity = 'New Haven',
                                      BillingState = 'CT',
                                      BillingCountry = 'US',
                                      BillingPostalCode = '02581'
                                  );
        insert newAccount;
        
        System.debug('newAccount Id: ' + newAccount.Id);
        
        testContact.AccountId = newAccount.Id;
        update testContact;
                
        cert = [SELECT Id, Contact_Account__c FROM Academy_Certificate__c WHERE Id = :cert.Id];
        
        System.debug(cert.Id + ' cert Account Id: ' + cert.Contact_Account__c);
        
        System.assert(cert.Contact_Account__c == newAccount.Id);        
    }    
}