/**
  \file         PartnerWelcomeLetterControllerTest.apxc
  \brief        Tests for the PartnerWelcomeLetterController class.
  \details      JIRA ticket(s): 
  \author       Loch MacLeod
  \version      1.3
  \date         2017-07-12
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.3       2017-09-26  Loch MacLeod            SSF-529 Added better error handling tests
*/
@IsTest 
public with sharing  class PartnerWelcomeLetterControllerTest {
    @testSetup static void setup() {   
        Stc.setTestSettings();
    }
    
    @IsTest public static void testWelcomeLetter1() {
        system.debug('TEST: **** testWelcomeLetter1 ****');
        
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{ "userName": "henry@nowhare.com", "type": "PARTNER", "success": true, "password": "*u8D5kUjhx" }');

        PartnerPortalHttpCalloutMock.response = res;
        Test.setMock(HttpCalloutMock.class, new PartnerPortalHttpCalloutMock());
        
               
        Contact c = new Contact(LastName = 'Test', 
                                FirstName = 'Contact',                             
                                Email = 'loch.macleod@storagecraft.com', 
                                Status__c = 'Active',
                                DoNotAllowBulkEmails__c = true);
        insert c;
        
        Account acct = new account(Name = 'Account Trigger Test 1',
                                   Primary_Contact__c = c.Id,
                                   BillingCountry = 'US',
                                   BillingState = 'UT',
                                   BillingPostalCode = '84117',
                                   Partner_Level__c = 'Gold',
                                   Partner_Level_Calculated__c = 'Gold',
                                   NFR_ShadowProtect_Server_Serial__c = 'Test',
                                   NFR_ShadowProtect_Desktop_Serial__c = 'Test',
                                   NFR_ShadowProtect_SPX_Linux__c = 'Test',
                                   NFR_ShadowProtect_ImageManager_Serial__c = 'Test');
        insert acct;
        
        c.AccountId = acct.Id;                                
        update c;
        
        PageReference pageRef = Page.Partner_Welcome_Letter;
        Test.setCurrentPage(pageRef);
        pageRef.getparameters().put('Id', acct.Id);
        pageRef.getparameters().put('emailMe', 'false');
        pageRef.getparameters().put('language', 'French');
        pageRef.getparameters().put('accountType', 'Prospect');
        ApexPages.StandardController sc = new ApexPages.standardController(acct);
        PartnerWelcomeLetterController controller = new PartnerWelcomeLetterController(sc);
        controller.sendEmail();
        System.debug(controller.message);
    }
   
    @IsTest public static void testWelcomeLetter2() {
        system.debug('TEST: testWelcomeLetter2');
        
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{ "userName": "gerold@nowhare.com", "type": "CONTACT", "success": true, "password": "*u8D5kUjhx" }');

        PartnerPortalHttpCalloutMock.response = res;
        Test.setMock(HttpCalloutMock.class, new PartnerPortalHttpCalloutMock());
        
        Account acct = new account(Name = 'Account Trigger Test 2',
                                   BillingCountry = 'DE',
                                   BillingPostalCode = '84117',
                                   VAR_Agreement_Accepted__c = true,
                                   Partner_Level__c = 'Gold',
                                   Partner_Level_Calculated__c = 'Gold',
                                   NFR_ShadowProtect_Server_Serial__c = 'Test',
                                   NFR_ShadowProtect_Desktop_Serial__c = 'Test',
                                   NFR_ShadowProtect_SPX_Linux__c = 'Test',
                                   NFR_ShadowProtect_ImageManager_Serial__c = 'Test');
        insert acct;
               
        Contact c = new Contact(AccountId = acct.Id,
                                LastName = 'Test', 
                                FirstName = 'Contact',                             
                                Email = 'loch.macleod@storagecraft.com', 
                                Status__c = 'Active',
                                DoNotAllowBulkEmails__c = true);
        insert c;
        
        acct.Primary_Contact__c = c.Id;
        update acct;
        
        PageReference pageRef = Page.Partner_Welcome_Letter;
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController sc = new ApexPages.standardController(acct);        
        ApexPages.CurrentPage().getparameters().put('Id', acct.id);
        ApexPages.CurrentPage().getparameters().put('emailMe', 'false');
        ApexPages.CurrentPage().getparameters().put('language', 'German');
        PartnerWelcomeLetterController controller = new PartnerWelcomeLetterController(sc);
        
        System.debug('Before PartnerWelcomeLetterController call');
        controller.sendEmail();
        
        System.debug(controller.message);
        System.assertEquals('Email has been sent.', controller.message);
    }
    
    @IsTest public static void testWelcomeLetter3() {
        system.debug('TEST: testWelcomeLetter3');
        
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{ "error": "LOGIN_IN_USE", "success": false }');

        PartnerPortalHttpCalloutMock.response = res;
        Test.setMock(HttpCalloutMock.class, new PartnerPortalHttpCalloutMock());
        
        Account acct = new account(Name = 'Account Trigger Test 3',
                                   BillingCountry = 'US',
                                   BillingState = 'UT',
                                   BillingPostalCode = '84117',
                                   VAR_Agreement_Accepted__c = true,
                                   Partner_Level__c = 'Gold',
                                   Partner_Level_Calculated__c = 'Gold',
                                   NFR_ShadowProtect_Server_Serial__c = 'Test',
                                   NFR_ShadowProtect_Desktop_Serial__c = 'Test',
                                   NFR_ShadowProtect_SPX_Linux__c = 'Test',
                                   NFR_ShadowProtect_ImageManager_Serial__c = 'Test');
        insert acct;
               
        Contact c = new Contact(AccountId = acct.Id,
                                LastName = 'Test', 
                                FirstName = 'Contact',                             
                                Email = 'loch.macleod@storagecraft.com', 
                                Status__c = 'Active',
                                DoNotAllowBulkEmails__c = true);
        insert c;
        
        acct.Primary_Contact__c = c.Id;
        update acct;
                       
        PageReference pageRef = Page.Partner_Welcome_Letter;
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController sc = new ApexPages.standardController(acct);
        ApexPages.CurrentPage().getparameters().put('Id', acct.id);
        ApexPages.CurrentPage().getparameters().put('emailMe', 'false');
        ApexPages.CurrentPage().getparameters().put('language', 'Italian');
        PartnerWelcomeLetterController controller = new PartnerWelcomeLetterController(sc);
        
        System.debug('Before PartnerWelcomeLetterController call');
        controller.sendEmail(); 

        System.debug(controller.message);
        System.assertEquals('Email has been sent.', controller.message);
    }
    
    @IsTest public static void testWelcomeLetter4() {
        system.debug('TEST: testWelcomeLetter4');
        
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{ "error": ["LOGIN_IN_USE", "FAILED_USER"], "success": false }');

        PartnerPortalHttpCalloutMock.response = res;
        Test.setMock(HttpCalloutMock.class, new PartnerPortalHttpCalloutMock());
        
        Account acct = new account(Name = 'Account Trigger Test 4',
                                   BillingCountry = 'DE',
                                   BillingState = 'UT',
                                   BillingPostalCode = '84117',
                                   VAR_Agreement_Accepted__c = true,
                                   Partner_Level__c = 'Gold',
                                   Partner_Level_Calculated__c = 'Gold',
                                   StcZone_Global_Region__c ='EMEA',
                                   NFR_ShadowProtect_Server_Serial__c = 'Test',
                                   NFR_ShadowProtect_Desktop_Serial__c = 'Test',
                                   NFR_ShadowProtect_SPX_Linux__c = 'Test',
                                   NFR_ShadowProtect_ImageManager_Serial__c = 'Test');
        insert acct;
               
        Contact c = new Contact(AccountId = acct.Id,
                                LastName = 'Test', 
                                FirstName = 'Contact',                             
                                Email = 'loch.macleod@storagecraft.com', 
                                Status__c = 'Active',
                                DoNotAllowBulkEmails__c = true);
        insert c;
        
        acct.Primary_Contact__c = c.Id;
        update acct;

        PageReference pageRef = Page.Partner_Welcome_Letter;
        Test.setCurrentPage(pageRef);        
        ApexPages.StandardController sc = new ApexPages.standardController(acct);        
        ApexPages.CurrentPage().getparameters().put('Id', acct.id);
        ApexPages.CurrentPage().getparameters().put('emailMe', 'false');
        ApexPages.CurrentPage().getparameters().put('language', 'English');
        PartnerWelcomeLetterController controller = new PartnerWelcomeLetterController(sc);
        
        System.debug('Before PartnerWelcomeLetterController call');
        controller.sendEmail(); 

        System.debug(controller.message);
        System.assertEquals('Did not send email.  Error: Contact is assigned to a different account in the Partner Portal.', controller.message);
    }    

    @IsTest public static void testWelcomeLetter5() {
        system.debug('TEST: testWelcomeLetter5');
        
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{ "error":"FAILED_PARTNER", "success":false }');

        PartnerPortalHttpCalloutMock.response = res;
        Test.setMock(HttpCalloutMock.class, new PartnerPortalHttpCalloutMock());
        
        Account acct = new account(Name = 'Account Trigger Test 5',
                                   BillingCountry = 'US',
                                   BillingState = 'UT',
                                   BillingPostalCode = '84117',
                                   VAR_Agreement_Accepted__c = true,
                                   Partner_Level__c = 'Gold',
                                   Partner_Level_Calculated__c = 'Gold',
                                   NFR_ShadowProtect_Server_Serial__c = 'Test',
                                   NFR_ShadowProtect_Desktop_Serial__c = 'Test',
                                   NFR_ShadowProtect_SPX_Linux__c = 'Test',
                                   NFR_ShadowProtect_ImageManager_Serial__c = 'Test');
        insert acct;
               
        Contact c = new Contact(AccountId = acct.Id,
                                LastName = 'Test', 
                                FirstName = 'Contact',                             
                                Email = 'loch.macleod@storagecraft.com', 
                                Status__c = 'Active',
                                DoNotAllowBulkEmails__c = true);
        insert c;
        
        acct.Primary_Contact__c = c.Id;
        update acct;
              
        PageReference pageRef = Page.Partner_Welcome_Letter;
        Test.setCurrentPage(pageRef); 
        ApexPages.StandardController sc = new ApexPages.standardController(acct);
        ApexPages.CurrentPage().getparameters().put('Id', acct.id);
        ApexPages.CurrentPage().getparameters().put('emailMe', 'false');
        ApexPages.CurrentPage().getparameters().put('language', 'Italian');
        PartnerWelcomeLetterController controller = new PartnerWelcomeLetterController(sc);

        System.debug('Before PartnerWelcomeLetterController call');
        controller.sendEmail(); 

        System.debug(controller.message);
        System.assertEquals('Did not send email.  Error: Partner Portal failed to create account and contact access.', controller.message);
    }
}