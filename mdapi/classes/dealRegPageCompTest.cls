@isTest
private class dealRegPageCompTest {

  /**
    * Method to submit lead for conversion and check deal registration number update
    */
    public static  testMethod  void submitApprovalOfLeadConvertFailed() {
        List<SObject> lstCountry = Test.loadData(Country_ISO_Map__c.sObjectType, 'CPQ_Country_ISO_Map');

        Account accObj = new Account(Name='test Account',BillingCountry='US',BillingState='NY',BillingPostalCode='10005');
        insert accObj;

        Additional_Domain__c domainObj = new Additional_Domain__c(Name='test domain',Account__c = accObj.ID);
        insert domainObj;


        Lead lead = new Lead(LastName='US',
                             FirstName='Convert',
                             Email='us.convert@storagecraft.com',
                             Company='Lead Convert Test',
                             Status='Inquiry',
                             Country='US',
                             State='NY',
                             PostalCode='10005',
                             LeadSource = 'Deal Registration',
                             Additional_Domain__c = domainObj.ID,
                             RecordType = [SELECT Id FROM RecordType WHERE SObjectType='Lead' AND Name=:'Partner' LIMIT 1]
                             );
        insert lead;

        DealRegistration__c getInsertedDeal = [Select ID from DealRegistration__c];

        System.Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(getInsertedDeal);
        dealRegPageCompClass controller = new dealRegPageCompClass(sc);
        controller.approveDR();
        controller.submitApproval();
        controller.cancel();
        System.Test.stopTest();
    }

    public static  testMethod  void submitApprovalOfDeal() {
        List<SObject> lstCountry = Test.loadData(Country_ISO_Map__c.sObjectType, 'CPQ_Country_ISO_Map');

        Account accObj = new Account(Name='test Account',BillingCountry='US',BillingState='NY',BillingPostalCode='10005');
        insert accObj;

        Additional_Domain__c domainObj = new Additional_Domain__c(Name='test domain',Account__c = accObj.ID);
        insert domainObj;

        Lead lead = new Lead(LastName='US',
                             FirstName='Convert',
                             Email='us.convert@storagecraft.com',
                             Company='Lead Convert Test',
                             Status='Inquiry',
                             Country='US',
                             State='NY',
                             PostalCode='10005',
                             LeadSource = 'Deal Registration',
                             Additional_Domain__c = domainObj.ID,
                             RecordType = [SELECT Id FROM RecordType WHERE SObjectType='Lead' AND Name=:'Partner' LIMIT 1]
                             );
        insert lead;

        Lead lead1 = new Lead(LastName='US',
                             FirstName='test',
                             Email='us@storagecraft.com',
                             Company='Lead Test',
                             Status='Inquiry',
                             Country='US',
                             State='NY',
                             PostalCode='10005',
                             LeadSource = 'Other',
                             Additional_Domain__c = domainObj.ID,
                             UserType__c = 'Other',
                             RecordType = [SELECT Id FROM RecordType WHERE SObjectType='Lead' AND Name=:'Partner' LIMIT 1]
                             );
        insert lead1;
        DealRegistration__c getInsertedDeal = [Select ID from DealRegistration__c];

        System.Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(getInsertedDeal);
        dealRegPageCompClass controller = new dealRegPageCompClass(sc);
        controller.approveDR();
        controller.drl =lead1;
        controller.submitApproval();
        controller.cancel();
        List<LeadStatus> leadList = [SELECT Id,IsConverted , MasterLabel FROM LeadStatus ];
        System.Test.stopTest();
        System.assertEquals(true,leadList[0].IsConverted);
    }

 /**
   * Method to submit lead for conversion and check failed to fetch lead ,cover catch block
   */
    public static  testMethod  void submitApprovalOfDealFailedFetchLead() {
        List<SObject> lstCountry = Test.loadData(Country_ISO_Map__c.sObjectType, 'CPQ_Country_ISO_Map');
        Lead lead = new Lead(LastName='US',
                             Email='us.convert@storagecraft.com',
                             Company='Lead Convert Test',
                             Status='Inquiry',
                             Country='US',
                             State='NY',
                             PostalCode='10005',
                             LeadSource = 'Deal Registration',
                             RecordType = [SELECT Id FROM RecordType WHERE SObjectType='Lead' AND Name=:'Partner' LIMIT 1]
                             );
        insert lead;
        DealRegistration__c getInsertedDeal = [Select ID from DealRegistration__c];
        DealRegistration__c dealInstance = new DealRegistration__c(Name = 'test deal');
        insert dealInstance;

        System.Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(dealInstance);
        dealRegPageCompClass controller = new dealRegPageCompClass(sc);
        controller.approveDR();
        System.Test.stopTest();

        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());
        System.assertEquals(true,pageMessages[0].getDetail().contains('error'));
    }

  /**
    * Method to submit lead for conversion and reject on approval asked
    */
    public static  testMethod  void submitRejectionOfDeal() {
        List<SObject> lstCountry = Test.loadData(Country_ISO_Map__c.sObjectType, 'CPQ_Country_ISO_Map');
        Lead lead = new Lead(LastName='US',
                             FirstName='Convert',
                             Email='us.convert@storagecraft.com',
                             Company='Lead Convert Test',
                             Status='Inquiry',
                             Country='US',
                             State='NY',
                             PostalCode='10005',
                             LeadSource = 'Deal Registration',
                             RecordType = [SELECT Id FROM RecordType WHERE SObjectType='Lead' AND Name=:'Partner' LIMIT 1]
                             );
        insert lead;
        DealRegistration__c getInsertedDeal = [Select ID from DealRegistration__c];

        System.Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(getInsertedDeal);
        dealRegPageCompClass controller = new dealRegPageCompClass(sc);
        controller.rejectDR();
        controller.submitRejection();
        List<Lead> getInsertedDeal1 = [Select ID,Status from Lead];
        System.Test.stopTest();

        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());
        System.assertEquals(true,pageMessages[0].getDetail().contains('reject'));
        System.assertEquals('Rejected',getInsertedDeal1[0].Status);
    }

  /**
    * Method to submit lead for conversion and reject approval when asked and cover catch block
    */
    public static  testMethod  void rejectApprovalOfDealFailedFetchLead() {
        List<SObject> lstCountry = Test.loadData(Country_ISO_Map__c.sObjectType, 'CPQ_Country_ISO_Map');
        Lead lead = new Lead(LastName='US',
                             Email='us.convert@storagecraft.com',
                             Company='Lead Convert Test',
                             Status='Inquiry',
                             Country='US',
                             State='NY',
                             PostalCode='10005',
                             LeadSource = 'Deal Registration',
                             RecordType = [SELECT Id FROM RecordType WHERE SObjectType='Lead' AND Name=:'Partner' LIMIT 1]
                             );
        insert lead;
        DealRegistration__c getInsertedDeal = [Select ID from DealRegistration__c];
        DealRegistration__c dealInstance = new DealRegistration__c(Name = 'test deal');
        insert dealInstance;

        System.Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(dealInstance);
        dealRegPageCompClass controller = new dealRegPageCompClass(sc);
        controller.rejectDR();
        System.Test.stopTest();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());
        System.assertEquals(true,pageMessages[0].getDetail().contains('error'));

    }
}