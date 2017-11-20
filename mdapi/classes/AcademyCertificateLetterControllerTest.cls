/**
  \file         AcademyCertificateLetterControllerTest.apxc
  \brief        Test the Academy Certificate sending to a contact
  \details      Tests for AcademyCertificateLetterControllerTest.apxc.
  \author       Loch MacLeod
  \version      1.1
  \date         
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.1       2017-10-15  Loch MacLeod            Add Sales Territory staff to email (SSF-85).
*/
@isTest
public class AcademyCertificateLetterControllerTest { 
    @testSetup static void setupTest() {        
        Stc.setTestSettings();
        
        Map<String, StcZone__c> zones = new Map<String, StcZone__c>();
        Profile p = [select Id from Profile where Name = 'System Administrator'];
        
        User user1 = new User(Username = 'john@test.zzz',
                         Email = 'john@test.zzz',
                         Alias = 'stczone1',
                         CommunityNickname = 'stczone1',
                         TimeZoneSidKey = 'GMT',
                         LocaleSidKey = 'en_US',
                         EmailEncodingKey = 'UTF-8',
                         LanguageLocaleKey = 'en_US',
                         FirstName = 'Test', 
                         LastName = 'User1',
                         ProfileId = p.Id);
        User user2 = new User(Username = 'jane@test.zzz',
                         Email = 'jane@test.zzz',
                         Alias = 'stczone2',
                         CommunityNickname = 'stczone2',
                         TimeZoneSidKey = 'GMT',
                         LocaleSidKey = 'en_US',
                         EmailEncodingKey = 'UTF-8',
                         LanguageLocaleKey = 'en_US',
                         FirstName = 'Test', 
                         LastName = 'User2',
                         ProfileId = p.Id);
        List<User> users = new List<User>();
        users.add(user1);
        users.add(user2);

        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert users;
        }
        
        zones.put('Big Apple',
                  new StcZone__c(Name = 'Big Apple',
                                 Region__c = 'US North',
                                 Global_Region__c = 'AMER', 
                                 Controlling_Office__c = 'Draper, Utah  US', 
                                 Active__c = true, 
                                 Territory__c = 'Big Apple',
                                 Assign_To__c = user1.Id,
                                 Assign_Accounts_To__c = user1.Id));
        zones.put('Unknown',
                  new StcZone__c(Name = 'Unknown',
                                 Region__c = 'US West',
                                 Global_Region__c = 'AMER', 
                                 Controlling_Office__c = 'Draper, Utah  US', 
                                 Active__c = true, 
                                 Territory__c = 'Unknown',
                                 Assign_To__c = user2.Id,
                                 Assign_Accounts_To__c = user2.Id));
               insert zones.values();
        
        List<StcZoneRule__c> zoneRules = new List<StcZoneRule__c>();
         
        zoneRules.add(new StcZoneRule__c(Order__c = 100,
                                         Active__c = true,
                                         Name = 'US - Big Apple',
                                         StcZone__c = zones.get('Big Apple').Id,
                                         Countries__c = 'US',
                                         States__c = 'NY,NJ',
                                         Postal_Codes__c = null,
                                         Works_On__c = 'Both Leads and Accounts',                                
                                         Lead_User_Types__c = null,
                                         Account_User_Types__c = null,
                                         High_Potential__c = false
                                         ));
        zoneRules.add(new StcZoneRule__c(Order__c = 200,
                                         Active__c = true,
                                         Name = 'Remaining',
                                         StcZone__c = zones.get('Unknown').Id,
                                         Countries__c = null,
                                         States__c = null,
                                         Postal_Codes__c = null,
                                         Works_On__c = 'Both Leads and Accounts',                                           
                                         Lead_User_Types__c = null,
                                         Account_User_Types__c = null,
                                         High_Potential__c = false
                                         ));
        insert zoneRules;
    }
    
    static private Academy_Certificate__c createCertificate(String certification, Boolean passed, Date expiration) {                
        Account acct = new Account(Name = 'Test Account', CurrencyIsoCode = 'USD');
        insert acct;
        
        Contact con = new Contact(FirstName = 'TestFirst', LastName = 'TestLast', Status__c ='Active', AccountId = acct.id, CurrencyIsoCode = 'USD', Email = 'test@yahoo.com');
        insert con;
        
        Academy_Certificate__c cert = new Academy_Certificate__c(
            Certified_Contact__c = con.Id,
            Contact_Account__c = acct.Id,
            Passed__c = passed,
            Certification__c = certification,
            Expiration_Date__c = expiration);
        insert cert;
        
        return cert;
    }
    
    static testMethod void certficateSCME() {
        Academy_Certificate__c acSCME = createCertificate('StorageCraft_Certified_Master_Engineer', true, System.today() + 30);
        
        System.AssertEquals(acSCME.Certification__c, 'StorageCraft_Certified_Master_Engineer');
        
        Test.setCurrentPage(Page.AcademyCertificate_Letter);
        AcademyCertificateLetterController controllerSCME = new AcademyCertificateLetterController(new ApexPages.StandardController(acSCME));
        controllerSCME.getBackgroundImage();
        controllerSCME.getDateColor();
        controllerSCME.getNameLeft();
        controllerSCME.getDateTop();
        controllerSCME.getDateLeft();
        controllerSCME.getNameColor();
        controllerSCME.getNameTop();
            
        controllerSCME.sendEmail();            
    }
    
    static testMethod void certficateSCE() {
        Academy_Certificate__c acSCE = createCertificate('StorageCraft_Certified_Engineer', false, Date.today() + 2);
        
        System.AssertEquals(acSCE.Certification__c, 'StorageCraft_Certified_Engineer');
        
        Test.setCurrentPage(Page.AcademyCertificate_Letter);
        AcademyCertificateLetterController controllerSCE = new AcademyCertificateLetterController(new ApexPages.StandardController(acSCE));
        controllerSCE.getBackgroundImage();
        controllerSCE.getDateColor();
        controllerSCE.getNameLeft();
        controllerSCE.getDateTop();
        controllerSCE.getDateLeft();
        controllerSCE.getNameColor();
        controllerSCE.getNameTop();
    }
    
    static testMethod void certficateSSP() {
        Academy_Certificate__c acSSP = createCertificate('StorageCraft_Sales_Professional', false, Date.today());
        
        System.AssertEquals(acSSP.Certification__c, 'StorageCraft_Sales_Professional');
        
        Test.setCurrentPage(Page.AcademyCertificate_Letter);
        AcademyCertificateLetterController controllerSSP = new AcademyCertificateLetterController(new ApexPages.StandardController(acSSP));
        controllerSSP.getBackgroundImage();
        controllerSSP.getDateColor();
        controllerSSP.getNameLeft();
        controllerSSP.getDateTop();
        controllerSSP.getDateLeft();
        controllerSSP.getNameColor();
        controllerSSP.getNameTop();
    }
    
    static testMethod void certficateNull() {
        Academy_Certificate__c acSCS = createCertificate('StorageCraft_Certified_Specialist', true, date.today() +1);

        System.AssertEquals(acSCS.Certification__c, 'StorageCraft_Certified_Specialist');
        
        Test.setCurrentPage(Page.AcademyCertificate_Letter);
        AcademyCertificateLetterController controllerNull = new AcademyCertificateLetterController(new ApexPages.StandardController(acSCS));
        controllerNull.getBackgroundImage();
        controllerNull.getDateColor();
        controllerNull.getNameLeft();
        controllerNull.getDateTop();
        controllerNull.getDateLeft();
        controllerNull.getNameColor();
        controllerNull.getNameTop();
        
        try{
            controllerNull.sendEmail();    
        } catch(DMLException e){
            System.assert(e.getMessage().contains('Unavailable certification type: SCP' ), 'message=' + e.getMessage());
        }
    }
    
    static testMethod void certNotCertified() {
       Academy_Certificate__c ac = createCertificate('StorageCraft_Certified_Specialist', true, Date.today() - 2);
       
       Test.setCurrentPage(Page.AcademyCertificate_PDF);
       AcademyCertificateLetterController controller = new AcademyCertificateLetterController(new ApexPages.StandardController(ac));
       controller.sendEmail();
    }
    
    static testMethod void certifiedPDF() {        
        Academy_Certificate__c ac = createCertificate('StorageCraft_Certified_Master_Engineer', true, Date.today() + 2);
        
        Test.setCurrentPage(Page.AcademyCertificate_PDF);
        AcademyCertificateLetterController controller = new AcademyCertificateLetterController(new ApexPages.StandardController(ac));
        controller.sendEmail(); 
    }
            
    static testMethod void certifiedPDFSCME() {
        Academy_Certificate__c ac = createCertificate('StorageCraft_Certified_Master_Engineer', true, Date.today() +12);
        
        AcademyCertificateLetterController controller = new AcademyCertificateLetterController(new ApexPages.StandardController(ac));
        
        controller.sendEmail();
        Test.setCurrentPage(Page.AcademyCertificate_PDF);
        PageReference pageCertificate = Page.AcademyCertificate_PDF;
    }
    
    static testMethod void certifiedEng() {
        String abbreviation = 'SCME';
        String emailTemplate =  'AcademyCertificate SCME Email';
        String resourcenameLogos = 'AcademyCertificate_SCME_Logos';
        Boolean emailMe = TRUE;
        
        Account acct2 = new Account(Name = 'Test Account', CurrencyIsoCode = 'USD');
        insert acct2;
        
        Contact con2 = new Contact(FirstName = 'Test First', LastName = 'Test Last',Status__c ='Active',  AccountId = acct2.id, CurrencyIsoCode = 'USD', Email = 'test@yahoo.com');
        insert con2;
        
        Academy_Certificate__c ac3 = new Academy_Certificate__c();
        ac3.Contact_Account__c = acct2.Id;
        ac3.Certified_Contact__c = con2.Id;
        ac3.Passed__c = true;
        ac3.Certification__c = 'StorageCraft_Certified_Engineer';
        //insert ac2;
        ac3.Expiration_Date__c = date.today() +12;
        ac3.Certificate_Sent__c = true;
        ac3.Certificate_Sent_On__c = Date.today();
        insert ac3;
        
        Academy_Certificate__c acCert = [SELECT Status__c, Certification__c, Certified_Contact__c, 
                                         Certified_Contact__r.Name, Certified_Date__c, Certificate_Sent__c, Certificate_Sent_On__c from Academy_Certificate__c where id=:ac3.id];
        //Test.setCurrentPage(Page.AcademyCertificate_PDF);
        /*ApexPages.StandardController standardCon = new ApexPages.StandardController(ac3);
AcademyCertificateLetterController controller = new AcademyCertificateLetterController(standardCon);
delete ac3;
*/
        AcademyCertificateLetterController controller = new AcademyCertificateLetterController(new ApexPages.StandardController(acCert));
        
        controller.sendEmail();
        Test.setCurrentPage(Page.AcademyCertificate_PDF);
    }
    
    static testMethod void certifiedSalesPro() {
        String abbreviation = 'SCME';
        String emailTemplate =  'AcademyCertificate SCME Email';
        String resourcenameLogos = 'AcademyCertificate_SCME_Logos';
        Boolean emailMe = TRUE;
        
        Account acct2 = new Account(Name = 'Test Account', CurrencyIsoCode = 'USD');
        insert acct2;
        
        Contact con2 = new Contact(FirstName = 'Test First', LastName = 'Test Last',Status__c ='Active',  AccountId = acct2.id, CurrencyIsoCode = 'USD', Email = 'test@yahoo.com');
        insert con2;
        
        Academy_Certificate__c ac3 = new Academy_Certificate__c();
        ac3.Contact_Account__c = acct2.Id;
        ac3.Certified_Contact__c = con2.Id;
        ac3.Passed__c = true;
        ac3.Certification__c = 'StorageCraft_Sales_Professional';
        //insert ac2;
        ac3.Expiration_Date__c = date.today() +12;
        ac3.Certificate_Sent__c = true;
        ac3.Certificate_Sent_On__c = Date.today();
        insert ac3;
        
        Academy_Certificate__c acCert = [SELECT Status__c, Certification__c, Certified_Contact__c, 
                                         Certified_Contact__r.Name, Certified_Date__c, Certificate_Sent__c, Certificate_Sent_On__c from Academy_Certificate__c where id=:ac3.id];
        //Test.setCurrentPage(Page.AcademyCertificate_PDF);
        /*ApexPages.StandardController standardCon = new ApexPages.StandardController(ac3);
AcademyCertificateLetterController controller = new AcademyCertificateLetterController(standardCon);
delete ac3;
*/
        APexPages.StandardController con = New ApexPages.standardController ( acCert );
        AcademyCertificateLetterController controller = new AcademyCertificateLetterController(con);
        controller.sendEmail();
        abbreviation = null;
        Test.setCurrentPage(Page.AcademyCertificate_PDF);
    }
}