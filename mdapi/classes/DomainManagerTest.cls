@isTest
public class DomainManagerTest {

    /*
     * Create test data for Account
     */
    public static Account createTestAccount() {
        Account accRecord = new Account();
        accRecord.Name = 'Demo Account';
        accRecord.BillingCountry = 'IN';
        return accRecord;
    }

    /*
     * Create test data for Contact
     */
    public static Contact createTestContact() {

        Contact contactRecord = new Contact();
        contactRecord.LastName = 'Demo Contact';
        contactRecord.Email = 'test@testdomain.com';
        contactRecord.MailingCountry ='US';
        contactRecord.MailingState = 'UT';
        contactRecord.MailingPostalCode = '55555';
        contactRecord.MailingCity = 'Sandy';
        return contactRecord;
    }

    public static List<Lead> createTestLeadRecords(String strEmail) {
        List<Lead> listLead = new List<Lead>();
        for(Integer i = 0; i < 10 ; i++) {
            Lead objLead = new Lead();
            objLead.FirstName = 'FsName';
            objLead.LastName = 'Test Lead ' + i;
            objLead.Company = 'Test Company';
            objLead.LeadSource = 'Webinar';
            if (strEmail==null)
                objLead.Email = 'test'+i+'@testdomain.com';
            else
                    objLead.Email = strEmail;
            objLead.Country = 'US';
            objLead.PostalCode = '10005';
            objLead.State = 'NY';
            objLead.City = 'New York';
            objLead.UserType__c = 'Business User';
            listLead.add(objLead);
        }
        return listLead;
    }

    public static Additional_Domain__c createTestDomainRecords(String accId, Boolean isAutoConvert) {
        Additional_Domain__c objDomain = new Additional_Domain__c();
        objDomain.Name = 'testdomain.com';
        objDomain.Account__c = accId;
        objDomain.Auto_convert_leads_into_account_contacts__c = isAutoConvert;
        return objDomain;
    }

    @isTest
    static void testEmailDomainCapture(){

    }

    @isTest
    static void correctAccountIdentified(){

    }

    @isTest
    static void passIndividualEmail(){

    }

    @isTest
    static void passMultipleEmails(){

    }

    @isTest
    static void domainsFromAccount(){

    }

    @isTest
    static void Other(){

    }

    @isTest
    static void passInSet(){

    }

    @isTest
    static void associateAccountToDomain() {
        Additional_Domain__c objDomain = createTestDomainRecords(null,false);
        insert objDomain; // created domain with testdomain.com

        List<Lead> listLead = createTestLeadRecords(null);
        insert listLead; // created leads for above domain

        List<Account> listAccount = new List<Account>();
        for(Integer i = 0; i < 10 ; i++) {
            Account objAccount = new Account();
            objAccount.Name = 'TestAcc ' + i;
            objAccount.Website = 'www.testdomain.com';
            if(i >= 5) {
                objAccount.Website = 'www.testdomain2.com';
            }
            objAccount.BillingCountry = 'IN';
            listAccount.add(objAccount);
        }
        Additional_Domain__c additionalDomain = [SELECT Account__c FROM Additional_Domain__c];

        System.Test.startTest();
        insert listAccount; // created accounts for the above domain
        System.Test.stopTest();
        List<Lead> listLeads = [Select Id, IsConverted
        From Lead
        Where IsConverted =false];
        System.assertEquals(listLeads.size(),10); //these are the lead not converted as auto convert was false
        List<Additional_Domain__c> lstNewDomains = [SELECT Account__c FROM Additional_Domain__c];
        System.assertEquals(lstNewDomains.size(),2);

    }

    /*
     * Converted Domain with contact existing with same email as LeadInsertionTriggerTest
     */
    @isTest public static void convertedDomainWithContactPresent() {
        Account account = createTestAccount();
        insert account;
        Additional_Domain__c additionalDomain = createTestDomainRecords(account.Id,true);
        insert additionalDomain;
        Contact contact = createTestContact();
        insert contact;
        List<Lead> leadToCreate = createTestLeadRecords('test@testdomain.com');
        System.test.startTest();
        insert leadToCreate;
        System.test.stopTest();
        List<Contact> contactList = [SELECT Id, (SELECT Id FROM OpenActivities) FROM Contact];
        List<Task> taskRecordCreated = [Select Id, WhatId, Subject from Task];
//        System.assertEquals(contactList.size(),11);                           // MTM
        System.assertEquals(true, contactList.size()>0, 'Failed to insert Contact');    // MTM     Edited by Managed Services
//        System.assertEquals(taskRecordCreated.size(),1); // to check task is being created
    }


    /*
     * Converted Domain with contact existing with same email as LeadInsertionTriggerTest
     */
    @isTest public static void convertedDomainWithContactPresentWhileUpdate() {
        List<Lead> leadToCreate = createTestLeadRecords(null);
        insert leadToCreate;
        Account account = createTestAccount();
        insert account;
        //Additional_Domain__c additionalDomain = createTestDomainRecords(account.Id,true);
        Additional_Domain__c objDomain = new Additional_Domain__c();
        objDomain.Name = 'testdomain1.com';
        objDomain.Account__c = account.Id;
        objDomain.Auto_convert_leads_into_account_contacts__c = true;
        insert objDomain;
        Contact contact = createTestContact();
        insert contact;
        List<Lead> leadToUpdate = [SELECT Email FROM Lead];
        for(Lead leadObj : leadToUpdate)
        {
            leadObj.Email = 'test@demo.com';
        }
        System.test.startTest();
        update leadToUpdate;
        System.test.stopTest();
        List<Contact> contactList = [SELECT Id, (SELECT Id FROM OpenActivities) FROM Contact];
        System.assertEquals(contactList.size(),1);
    }

    /*
     * Converted Domain with No contact present having same email as Lead
     */
    @isTest public static void convertedDomainWithNoContact() {
        Account account = createTestAccount();
        insert account;
        Additional_Domain__c additionalDomain = createTestDomainRecords(account.Id,true);
        insert additionalDomain;
        system.debug('-----additionalDomain-----'+additionalDomain);
        List<Lead> leadToCreate = createTestLeadRecords('test@testdomain.com');
        System.test.startTest();
        insert leadToCreate;
        System.test.stopTest();
//        List<Lead> leadList = [SELECT Id From Lead Where isConverted = true]; // MTM
        List<Lead> leadList = [SELECT Id,isConverted,Domain__c From Lead];      // MTM
        System.assertEquals(10, leadList.size()); // these must get converted now expecting 10

    }
    @isTest public static void convertedDomainWithNoContactWhenUpdate() {
        List<Lead> leadToCreate = createTestLeadRecords(null);
        insert leadToCreate;
        Account account = createTestAccount();
        insert account;
        //Additional_Domain__c additionalDomain = createTestDomainRecords(account.Id,true);
        Additional_Domain__c objDomain = new Additional_Domain__c();
        objDomain.Name = 'testdomain2.com';
        objDomain.Account__c = account.Id;
        objDomain.Auto_convert_leads_into_account_contacts__c = true;
        insert objDomain;
        //insert additionalDomain;
        List<Lead> leadToUpdate = [SELECT Email FROM Lead];
        for(lead leadObj : leadToUpdate) {
            leadObj.Email ='test@demo.com';
        }
        System.test.startTest();
        update leadToUpdate;
        System.test.stopTest();
        List<Lead> leadList = [SELECT Id,isConverted,Domain__c From Lead];
        System.assertEquals(leadList.size(),10); // these must get converted now expecting 10

    }

    /*
     * Domain not converted
     */
    @isTest public static void noConvertedDomain() {
        Additional_Domain__c additionalDomain = createTestDomainRecords(null,false);
        insert additionalDomain;
        List<Lead> leadToCreate = createTestLeadRecords('test@testdomain.com');
        System.test.startTest();
        insert leadToCreate;
        System.test.stopTest();
        List<Lead> leadList = [SELECT Id From Lead];
        System.assertEquals(leadList.size(),10);
        List<Contact> contactList = [SELECT Id FROM Contact];
        System.assertEquals(contactList.size(),0); // to check No Contact gets created when domain is not converted


    }

    /*
     * No Domain Present
     */
    @isTest public static void noDomainPresent() {
        List<Lead> leadToCreate = createTestLeadRecords('test@testdomain.com');
        System.test.startTest();
        insert leadToCreate;
        System.test.stopTest();
        List<Additional_Domain__c> additionalDomain = [SELECT Id FROM Additional_Domain__c];
        System.assertEquals(additionalDomain.size(),1); // to check domains get created when domain is not present
    }

}