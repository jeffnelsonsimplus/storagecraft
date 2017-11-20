@isTest
private class ContactOrphanedHandlerTest {

    @isTest static void test_method_one() {
        // Totally Orphaned
        // List<SObject> lstCountry = Test.loadData(Country_ISO_Map__c.sObjectType, 'CPQ_Country_ISO_Map');

        
        Contact c = new contact(lastname = 'lastname', MailingCountry = 'US', MailingState = 'UT',MailingPostalCode='55555');
        insert c;
        c = [Select Id, AccountId, Status__c from Contact where Id = :c.Id];
        Account acct = [select id from account where name = 'DO NOT DELETE: ORPHAN ACCOUNT' limit 1];

        System.assertEquals(acct.Id, c.AccountId);
        System.assertEquals('Orphaned', c.Status__c);
    }

    @isTest static void test_method_two() {
        // Account
        // List<SObject> lstCountry = Test.loadData(Country_ISO_Map__c.sObjectType, 'CPQ_Country_ISO_Map');

        
        account a = new account(name = 'name', website = 'website.com', BillingCountry = 'US', BillingState = 'UT',BillingPostalCode='55555');
        insert a;
        Contact c = new contact(lastname = 'lastname', email = 'email@website.com', MailingCountry = 'US', MailingState = 'UT',MailingPostalCode='55555');
        insert c;
        c = [Select Id, AccountId from Contact where Id = :c.Id];
        System.assertEquals(a.Id, c.AccountId);
    }

    @isTest static void test_method_three() {
        // List<SObject> lstCountry = Test.loadData(Country_ISO_Map__c.sObjectType, 'CPQ_Country_ISO_Map');

        lead l = new lead(company = 'company', email = 'email@website.com', lastname = 'lastname', leadsource='Web', OwnerId = UserInfo.getUserId(),Country = 'AF');
        insert l;
        Contact c = new contact(lastname = 'lastname', email = 'email@website.com',  MailingCountry = 'US', MailingState = 'UT',MailingPostalCode='55555');
        insert c;
        c = [Select Id, AccountId, OrphanedLead__c, LeadOwner__c from Contact where Id = :c.Id];
        Account acct = [select id from account where name = 'DO NOT DELETE: ORPHAN ACCOUNT' limit 1];

        System.assertEquals(acct.Id, c.AccountId);
        System.assertEquals(l.Id, c.OrphanedLead__c);
        System.assertEquals(UserInfo.getUserId(), c.LeadOwner__c);
    }

    @isTest static void test_method_blockemail() {

        // List<SObject> lstCountry = Test.loadData(Country_ISO_Map__c.sObjectType, 'CPQ_Country_ISO_Map');

        
        List<Generic_Email_List__c> gel = new List<Generic_Email_List__c>();
        gel.add(new Generic_Email_List__c(Name = 'website.com'));
        Insert gel;

        account a = new account(name = 'name', website = 'website.com', BillingCountry = 'US', BillingState = 'UT',BillingPostalCode='55555');
        insert a;

        Contact c = new contact(lastname = 'lastname', email = 'email@website.com', MailingCountry = 'US', MailingState = 'UT',MailingPostalCode='55555');
        insert c;

        Account acct = [select id from account where name = 'DO NOT DELETE: ORPHAN ACCOUNT' limit 1];
        c = [Select Id, AccountId, Status__c from Contact where Id = :c.Id];
        System.assertEquals(acct.Id, c.AccountId);
    }

}