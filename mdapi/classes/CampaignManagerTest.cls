/**
  \file         CampaignManagerTest.apxc
  \brief        Tests for CampaignManagerTest.apxc
  \details      
  \author       Loch MacLeod
  \version      1.0
  \date         07 August 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  Version   Date        Author                  Description
  1.1       2017-08-08  Loch MacLeod            Corrections to each of the Leads, Contacts Opportunities
*/
@isTest
public class CampaignManagerTest {
    @testSetup 
    static void setupTestData() {
        SObject prof = [SELECT id FROM profile WHERE Name = 'System Administrator' ];
		User testUser = new User(
            Username= 'test.User@storagecraft.com',
            Email = 'test.User@storagecraft.com',
            Lastname = 'User',
            Firstname = 'Test',
            Alias = 'TestU',
            CommunityNickname = '12346',
            ProfileId = (ID) prof.get('ID'),
            CurrencyIsoCode = 'USD',
            TimeZoneSidKey = 'GMT',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US',
            UserPermissionsMobileUser = false );
        insert testUser;
        
        Account testAccount = new Account (
            Name = 'Test Account',
            OwnerId = testUser.Id,
            BillingState = 'UT',
            BillingCountry = 'US',
            BillingPostalCode = '84111');
        insert testAccount;
        
        Campaign testCampaign1 = new Campaign(
            Name = 'Campaign 1',
            IsActive = true,
            StartDate = Date.today(),
            EndDate = Date.today(),
            Description = 'Test Campaign 1');
        insert testCampaign1;

        insert new Campaign(
            Name = 'Campaign 2',
            IsActive = true,
            StartDate = Date.today(),
            EndDate = Date.today(),
            Description = 'Test Campaign 2');
        
        insert new Contact(
            OwnerId = testUser.Id,
            AccountId = testAccount.Id,
            FirstName = 'Test', 
            LastName = 'Test', 
            Email = 'Campaign.Manager@test.com',
            leadSourceCampaign__c = testCampaign1.Id);
    }   
    
    @isTest
    static void testOpportunity() {
        System.debug('CampaignManagerTest: testOpportunity');        
        Account testAccount = (Account) [SELECT Id, Name FROM Account WHERE Name = 'Test Account' LIMIT 1];
        Campaign testCampaign1 = (Campaign) [SELECT Id, Name FROM Campaign WHERE Name = 'Campaign 1' LIMIT 1];
     
        System.debug('  precreate');  
        Opportunity testOpp = new Opportunity(
            Name = 'Opp 1',
            AccountId = testAccount.Id,
            EstCloseDate__c = Date.Today(),
            CloseDate = Date.Today(),
            EstRevenue__c = 3000, 
            StageName = 'Suspect',
            leadSourceCampaign__c = testCampaign1.name);
        insert testOpp;
        System.debug('  postcreate'); 
        
        testOpp = (Opportunity) [SELECT Id, Name, CampaignId, leadSourceCampaign__c FROM Opportunity WHERE Id = :testOpp.Id LIMIT 1];
        
        System.assertEquals(testCampaign1.Name, testOpp.leadSourceCampaign__c);
        System.debug('  ' + testCampaign1.Id + ' =? ' + testOpp.CampaignId); 
        System.assertEquals(testCampaign1.Id, testOpp.CampaignId);
    }

    @isTest
    static void testLead() {
        System.debug('CampaignManagerTest: testLead');
        User testUser = (User) [SELECT Id, Name FROM User WHERE Username= 'test.User@storagecraft.com'LIMIT 1];
        Campaign testCampaign1 = (Campaign) [SELECT Id, Name FROM Campaign WHERE Name = 'Campaign 1' LIMIT 1];
        Campaign testCampaign2 = (Campaign) [SELECT Id, Name FROM Campaign WHERE Name = 'Campaign 2' LIMIT 1];
        
        Lead testLead = new Lead(
            OwnerId = testUser.Id,
            FirstName = 'Test',
            LastName = 'Test',
            Company = 'Test Campaign Company',
            Email = 'test.test@test.com',
            UserType__c = 'Value Added Reseller (VAR)',
            SourceCampaign__c = testCampaign1.Id);
        insert testLead;
        
        testLead = (Lead) [SELECT Id, Name, SourceCampaign__c, First_Touch_Campaign__c FROM Lead WHERE Id = :testLead.Id LIMIT 1];
        
        System.assertEquals(testCampaign1.Id, testLead.SourceCampaign__c, 'Last Touch Campaign not set');
        System.assertEquals(testCampaign1.Id, testLead.First_Touch_Campaign__c, 'First Touch Campaign not set correctly');
        
        testLead.SourceCampaign__c = testCampaign2.Id;
        update testLead;

        testLead = (Lead) [SELECT Id, Name, SourceCampaign__c, First_Touch_Campaign__c FROM Lead WHERE Id = :testLead.Id LIMIT 1];
        System.assertEquals(testCampaign2.Id, testLead.SourceCampaign__c, 'Last Touch Campaign not changed');
        System.assertEquals(testCampaign1.Id, testLead.First_Touch_Campaign__c, 'First Touch Campaign changed');
         
//        List<Task> tasks = [SELECT Id, Subject FROM Task WHERE OwnerId = :testUser.Id AND Type = 'Call'];
//        System.assert(!tasks.isEmpty());   
    }

    @isTest
    static void testContact() {
        System.debug('CampaignManagerTest: testContact');
        User testUser = (User) [SELECT Id, Name FROM User WHERE Username= 'test.User@storagecraft.com'LIMIT 1];
        Campaign testCampaign1 = (Campaign) [SELECT Id, Name FROM Campaign WHERE Name = 'Campaign 1' LIMIT 1];
        Campaign testCampaign2 = (Campaign) [SELECT Id, Name FROM Campaign WHERE Name = 'Campaign 2' LIMIT 1];
        Contact testContact = (Contact) [SELECT Id, Name, leadSourceCampaign__c FROM Contact WHERE Email = 'Campaign.Manager@test.com' LIMIT 1];
        
//        System.assertEquals(testCampaign1.Id, testContact.leadSourceCampaign__c, 'leadSourceCampaign__c not set correctly');
        
        testContact.leadSourceCampaign__c = testCampaign2.Name;
        update testContact;

        testContact = (Contact) [SELECT Id, Name, leadSourceCampaign__c FROM Contact WHERE Email = 'Campaign.Manager@test.com' LIMIT 1];

 //       System.assertEquals(testCampaign2.Name, testContact.leadSourceCampaign__c, 'leadSourceCampaign__c not set correctly');
    }
}