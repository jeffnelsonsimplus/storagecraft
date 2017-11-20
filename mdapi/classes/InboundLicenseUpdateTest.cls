@IsTest
private class InboundLicenseUpdateTest{

    private static final String TODAYS_DATE = String.valueOf(Date.today());
    private static final String VALID_KEY = '421D-D2E0-74AA-AB04';
    private static final String EXIRED_KEY = 'ABF9-CA32-8720-E1BA';
    private static final String CASE_STATUS_IN_PROGRESS = 'In Progress';
    private static final String CASE_STATUS_WAITING_RENEWAL = 'Waiting for Renewal';
    private static final String CASE_SERIAL_NUMBER_DETAILS = 'Renewed in AU';
    private static final String LICENSE_STATUS_ACTIVE = 'Active';
    private static final String BASE_URL = URL.getSalesforceBaseUrl().toExternalForm();

    @testSetup static void testDataSetup() {
        Account testAccount = new Account(Name = 'testAccount');
        insert testAccount;

        Contact testContact = new Contact(LastName = 'testContact');
        insert testContact;

        List<License__c> testLicenses = new List<License__c>();
        License__c validLicense = new License__c(Name = VALID_KEY,
                                                    Account__c = testAccount.Id);
        testLicenses.add(validLicense);
        License__c expiredLicense = new License__c(Name = EXIRED_KEY,
                                                    Account__c = testAccount.Id,
                                                    Status__c = 'Inactive');
        testLicenses.add(expiredLicense);
        insert testLicenses;

        List<Case> testCases = new List<Case>();
        Case validKeyCase = new Case(ContactId = testContact.Id,
                                 Time_Zone__c = 'Alaska Time (2 hours behind)',
                                 Select_User_Type__c = 'Home User',
                                 Assistance_Type__c = 'Licensing Assistance',
                                 Status = CASE_STATUS_WAITING_RENEWAL,
                                 Serial_Number__c = VALID_KEY);

         testCases.add(validKeyCase);
         Case invalidKeyCase = new Case(ContactId = testContact.Id,
                                  Time_Zone__c = 'Alaska Time (2 hours behind)',
                                  Select_User_Type__c = 'Home User',
                                  Assistance_Type__c = 'Licensing Assistance',
                                  Status = CASE_STATUS_WAITING_RENEWAL,
                                  Serial_Number__c = EXIRED_KEY);
        testCases.add(invalidKeyCase);
        insert testCases;
    }

    // Test with Valid License Key
    @isTest static void testValidLicense(){

            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();

            req.requestURI = BASE_URL+'/services/apexrest/LicenseUpdate';
            req.httpMethod = 'POST';
            req.requestBody  = Blob.valueof('<sf:Product_Key_v4__c>'+VALID_KEY+'</sf:Product_Key_v4__c> <sf:Renewal_Date__c>'+TODAYS_DATE+'</sf:Renewal_Date__c> <sf:Status__c>Active</sf:Status__c>');

            RestContext.request = req;
            RestContext.response = res;

            InboundLicenseUpdate.updateLicensesAndCases();

            List<License__c> assertLicenses = [SELECT Expiration__c,Status__c
                                                FROM License__c
                                                WHERE Name = :VALID_KEY];
            for(License__c objLicense : assertLicenses){
                System.assertEquals(LICENSE_STATUS_ACTIVE, objLicense.Status__c);
                System.assertEquals(Date.today() ,objLicense.Expiration__c);
            }

            List<Case> assertCases = [SELECT Serial_Number_Details__c,Status
                                        FROM Case
                                        WHERE Serial_Number__c = :VALID_KEY
                                        AND Status = :CASE_STATUS_WAITING_RENEWAL];
            for(Case objCase : assertCases){
                System.assertEquals(CASE_SERIAL_NUMBER_DETAILS ,objCase.Serial_Number_Details__c);
                System.assertEquals(CASE_STATUS_IN_PROGRESS ,objCase.Status);
            }
    }

    // Test with Invalid License Key
    @isTest static void testInvalidLicense(){

            RestRequest req = new RestRequest();
            RestResponse res = new RestResponse();

            req.requestURI = BASE_URL+'/services/apexrest/LicenseUpdate';
            req.httpMethod = 'POST';
            req.requestBody  = Blob.valueof('<sf:Product_Key_v4__c>'+EXIRED_KEY+'</sf:Product_Key_v4__c> <sf:Renewal_Date__c>'+TODAYS_DATE+'</sf:Renewal_Date__c> <sf:Status__c>Active</sf:Status__c>');

            RestContext.request = req;
            RestContext.response = res;

            InboundLicenseUpdate.updateLicensesAndCases();

            List<License__c> assertLicenses = [SELECT Expiration__c,Status__c
                                                FROM License__c
                                                WHERE Name = :EXIRED_KEY];
            for(License__c objLicense : assertLicenses){
                System.assertEquals(LICENSE_STATUS_ACTIVE, objLicense.Status__c);
                System.assertEquals(Date.today() ,objLicense.Expiration__c);
            }

            List<Case> assertCases = [SELECT Serial_Number_Details__c,Status
                                        FROM Case
                                        WHERE Serial_Number__c = :EXIRED_KEY
                                        AND Status = :CASE_STATUS_WAITING_RENEWAL];
            for(Case objCase : assertCases){
                System.assertEquals(CASE_SERIAL_NUMBER_DETAILS ,objCase.Serial_Number_Details__c);
                System.assertEquals(CASE_STATUS_IN_PROGRESS ,objCase.Status);
            }
    }
}