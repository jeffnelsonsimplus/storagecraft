/**
  \file
  \brief        Test Apex controller CommunitiesSelfRegController
  \details      JIRA ticket(s): SSF-615
  \author       Sean Oldoryd
  \version      1.0
  \date         13 Sept 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
 */
@IsTest(SeeAllData=true)
public class CommunitiesSelfRegControllerTest {

    static void setUpData(){
        Account a = new Account(Name = 'Support Community Account');
        Contact c = new Contact(LastName = 'tester');
        Contact c3 = new Contact(LastName = 'test1234444@test.com',Email = 'test@tester.com');
        Contact c1 = new Contact(LastName = 'tester1',EmailAddress2__c = 'test1@tester.com');
        Contact c2 = new Contact(LastName = 'tester2',EmailAddress3__c = 'test2@tester.com');
        List<Contact> testContacts = new List<Contact>();
        testContacts.add(c);
        testContacts.add(c1);
        testContacts.add(c2);
        testContacts.add(c3);
        insert a;
        insert testContacts;

        User u = new user();
        u.LastName = 'Test Code';
        u.Email = 'test@test.com';
        u.Alias = 'Tcode';
        u.Username = 'STCTestUser0894355@test.com';
        u.CommunityNickname = 'test12';
        u.LocaleSidKey = 'en_US';
        u.TimeZoneSidKey = 'GMT';
        u.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Operations'].id;
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        insert u;

    }

    @IsTest public static void testCommunitiesSelfRegController() {
        setUpData();

        CommunitiesSelfRegController controller = new CommunitiesSelfRegController();
        controller.firstName = 'FirstName';
        controller.lastName = 'LastName';
        controller.objContact.LastName = 'LastName';
        controller.objContact.email = 'test@force.com';
        controller.communityNickname = 'test';
        System.assert(controller.registerUser() != null);

        controller.password = 'abcd1234';
        controller.confirmPassword = 'abcd123';
        System.assert(controller.registerUser() == null);
        System.assert(controller.changeCountry() == null);


        controller.objContact = [SELECT Name, Email, EmailAddress2__c FROM Contact WHERE EmailAddress2__c = 'test1@tester.com' Limit 1];
        System.assert(controller.registerUser() == null);
        controller.objContact = [SELECT Name, Email, EmailAddress3__c FROM Contact WHERE EmailAddress3__c = 'test2@tester.com' Limit 1];
        System.assert(controller.registerUser() == null);
        controller.objContact = [SELECT Name, Email FROM Contact WHERE Email = 'test@tester.com' Limit 1];
        System.assert(controller.registerUser() == null);
        controller.objContact.id = null;
        system.debug('controller.id = ' + controller.objContact.id);
        System.assert(controller.registerUser() == null);

        controller.objContact.email = 'STCTestUser0894355@test.com';
        controller.registerUser();

        //does not increase coverage
        /*
        List<Contact> mdList = new List<Contact>();
        mdList.add(controller.objContact);
        Contacts.mergeDupContacts(mdList);
        */
    }
}