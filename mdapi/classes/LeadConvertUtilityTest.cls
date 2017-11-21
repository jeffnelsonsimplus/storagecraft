@isTest
public class LeadConvertUtilityTest {

    @testSetup static void createCountryCodeTestData(){
        List<SObject> lstCountry = Test.loadData(Country_ISO_Map__c.sObjectType, 'CPQ_Country_ISO_Map');
    }
    
    /*
     * Create test data for Account
     */
    public static Account createTestAccount() {
        Account accRecord = new Account();
        accRecord.Name = 'Demo Account';
        accRecord.BillingCity = 'Canberra';
        accRecord.BillingState = 'ACT';
        accRecord.BillingPostalCode = '2609';
        accRecord.BillingCountry = 'AU';
        return accRecord;
    }

    /*
     * Create test data for Lead
     */
    public static Lead createTestLeadRecords(String strEmail) {

        Lead objLead = new Lead();
        objLead.FirstName = 'Test Hello';
        objLead.LastName = 'Test Lead';
        objLead.Company = 'Test Company';
        objLead.LeadSource = 'Webinar';
        objLead.Email = strEmail;
        objLead.Country = 'AU';
        objLead.PostalCode = '2609';
        objLead.State = 'ACT';
        objLead.City = 'Canberra';
        objLead.UserType__c = 'Business User';
        objLead.CleanStatus = 'NotFound';
        return objLead;
    }

    @isTest
    static void testButton_convertLeadsToConts() {
        // create 2 leads, 2 domains would be created
        List<Lead> lstLeads = new List<Lead>{createTestLeadRecords('test@abc.com'),createTestLeadRecords('testDomain@xyz.com')};
        insert lstLeads;
        List<Lead> lstLeadsInserted = [Select Id,Additional_Domain__c,Additional_Domain__r.Name,Domain__c From Lead];
        System.assertEquals(lstLeadsInserted.size(),2);
        for(Lead objLead:lstLeadsInserted) {
            System.assertNotEquals(objLead.Additional_Domain__c,null);
            System.assert(objLead.Additional_Domain__r.Name=='abc.com'||objLead.Additional_Domain__r.Name=='xyz.com');
        }
        List<Additional_Domain__c> lstDomainsCreated = [Select Id,Name,Account__c From Additional_Domain__c];
        System.assertEquals(lstDomainsCreated.size(),2);

        Account objAccount = createTestAccount();
        for(Additional_Domain__c objDomain:lstDomainsCreated) {
            objDomain.Account__c = objAccount.Id;
        }
        update lstDomainsCreated;
        Test.startTest();
            String strResult = LeadConvertUtility.convertLeadsToConts(lstLeads[0].Id,objAccount.Id,lstLeads[0].Additional_Domain__c);
        Test.stopTest();

        System.assert(strResult.contains('converted'));

        List<Lead> lstConvertedLeads = [Select Id From Lead Where IsConverted = True];
        System.assertEquals(1,lstConvertedLeads.size());

    }

    @isTest
    static void test_convertLeadsToConts() {
        // create 2 leads, 2 domains would be created
        List<Lead> lstLeads = new List<Lead>{createTestLeadRecords('test@test.com'),createTestLeadRecords('testDomain@testDomain.com')};
        insert lstLeads;
        List<Lead> lstLeadsInserted = [Select Id,Additional_Domain__c,Additional_Domain__r.Name,Domain__c From Lead];
        System.assertEquals(2, lstLeadsInserted.size());
        for(Lead objLead:lstLeadsInserted) {
            System.assertNotEquals(objLead.Additional_Domain__c,null);
            System.assert(objLead.Additional_Domain__r.Name=='test.com'||objLead.Additional_Domain__r.Name=='testDomain.com');
        }
        List<Additional_Domain__c> lstDomainsCreated = [Select Id,Name,Account__c From Additional_Domain__c];
        Map<String,Additional_Domain__c> mapDomainsParameter = new Map<String,Additional_Domain__c> ();
        System.assertEquals(2, lstDomainsCreated.size());
        for(Additional_Domain__c objDomain:lstDomainsCreated) {
            mapDomainsParameter.put(objDomain.Id,objDomain);
        }

        Test.startTest();
            LeadConvertUtility.convertLeadsToConts(lstLeadsInserted,mapDomainsParameter);
        Test.stopTest();

        List<Lead> lstConvertedLeads = [Select Id From Lead Where IsConverted = True];
        System.assertEquals(lstConvertedLeads.size(),2);

    }

    public static testMethod void test_MustCleanBeforeConvert() {
        System.debug('LeadConvertUtilityTest.test_MustCleanBeforeConvert()');
        RecordType rtPartner; 
        List<RecordType> leadRecordTypes = [SELECT id, Name FROM RecordType WHERE SObjectType='Lead'];
        for (RecordType rt : leadRecordTypes) {
            if ('Partner'.Equals(rt.Name)) {
                rtPartner = rt;
                System.debug('Partner: '+ rtPartner.Name);
                break;
            }
        }
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead_Convert',
            Company = 'TestCompany_Convert',
            Email = 'Test.LeadConvert@TestCompanyConvert.com',
            Status = 'Untouched',
            UserType__c = 'Both MSP and VAR',
            LeadSource = 'Web Trial',
            State = 'OR',
            Country = 'US',
            PostalCode = '97479',
            RecordTypeId = rtPartner.Id,
            CleanStatus = 'Pending'
        );

        System.debug('+  rtPartner' + rtPartner);

        LeadStatus convertStatus = [SELECT MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];

        try {
            insert testLead;

            testLead = [SELECT Id, Name, RecordTypeId FROM Lead WHERE Id = :testLead.Id];
            System.debug('+   (' + testLead.Name + ') Inserted Record Type: ' + testLead.RecordTypeId);

            List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();

            Database.LeadConvert lc = new Database.LeadConvert();

            lc.setLeadId(testLead.Id);
            lc.setOpportunityName(testLead.Name);
            lc.setConvertedStatus(convertStatus.MasterLabel);

            leadConverts.add(lc);
            List<Database.LeadConvertResult> lcr = Database.convertLead(leadConverts);
            System.assertEquals(true, lcr.size()>0, 'Error: Failed to convert');        // Edited by Managed Services
        } catch (Exception e) {
            System.debug('test_CleanBeforeConvert: ' + e.getMessage());
            Boolean startsCorrect = e.getMessage().startsWith('ConvertLead failed.');
            System.assert(startsCorrect,  'Incorrect Exception:  ' + e.getMessage());
        }
    }

    public static testMethod void test_CleanedBeforeConvert() {
        RecordType rtPartner;
        List<RecordType> leadRecordTypes = [SELECT id, Name FROM RecordType WHERE SObjectType='Lead'];
        for (RecordType rt : leadRecordTypes) {
            if ('Partner'.Equals(rt.Name)) {
                rtPartner = rt;
                System.debug('Partner: '+ rtPartner.Name);
                break;
            }
        }
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Lead_Convert',
            Company = 'TestCompany_Convert',
            Email = 'Test.LeadConvert@TestCompanyConvert.com',
            Status = 'Untouched',
            UserType__c = 'Both MSP and VAR',
            LeadSource = 'Web Trial',
            State = 'OR',
            Country = 'US',
            PostalCode = '97479',
            RecordType = rtPartner,
            CleanStatus = 'Different'
        );

        LeadStatus convertStatus = [SELECT MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];

        Test.startTest();
        try {
            insert testLead;
            
            List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
            
            Database.LeadConvert lc = new Database.LeadConvert();

            lc.setLeadId(testLead.Id);
            lc.setOpportunityName(testLead.Name);
            lc.setConvertedStatus(convertStatus.MasterLabel);
            
            leadConverts.add(lc);
            List<Database.LeadConvertResult> lcr = Database.convertLead(leadConverts);
            System.assertEquals(1, lcr.size());
            System.assertEquals(0, lcr.get(0).errors.size());
        } catch (Exception e) {
            System.assert(false,  e.getMessage());
        }
        Test.stopTest();
    }
}