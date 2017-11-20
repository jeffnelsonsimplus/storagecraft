@isTest
private class ContactsTest {

    public static Account accountTestData() {
        //Creating test Account Record
        List<SObject> lstCountry = Test.loadData(Country_ISO_Map__c.sObjectType, 'CPQ_Country_ISO_Map');

        Country_ISO_Map__c countryObj = [SELECT Id, Name, alpha2Code__c, alpha3Code__c FROM Country_ISO_Map__c
                                            WHERE alpha2Code__c='AF' AND Id IN : lstCountry LIMIT 1];

        System.debug('countryObj===>'+countryObj);
        Account acc= new Account();
        acc.Name = 'test Account';
        acc.User_Type__c = 'Business User';
        acc.BillingCountry = 'AF';
        acc.BillingState = 'UT';
        acc.BillingPostalCode='55555';
        //acc.MailingCountry = countryObj.alpha3Code__c;
        system.debug('acc===>'+acc);
        return acc;
    }

    public static Contact oldContactBlankTestData(Id accountId) {
            Contact contactRecord = new Contact();
            contactRecord.LastName = 'Test Contact';
            contactRecord.Title = 'test title';
            contactRecord.AccountId = accountId;
            contactRecord.Phone = '0225632012';
            contactRecord.MobilePhone = '0023485744';
            contactRecord.UserType__c = 'Business User';
            contactRecord.ContactRole__c = 'Primary';
            contactRecord.Form_Name__c = 'test Form';
            contactRecord.Department = 'test Department';
            contactRecord.ContactNo__c = 'test Contact';
            contactRecord.DoNotAllowBulkEmails__c = true;
            contactRecord.DoNotAllowEmails__c = true;
            contactRecord.DoNotAllowFaxes__c = true;
            contactRecord.SendMarketingMaterials__c = true;
            contactRecord.mkto2__Lead_Score__c = 20;
            contactRecord.VAR_Agreement_Accepted__c = true;
            contactRecord.leadFormName__c= 'Test form';
            contactRecord.WebSite__c = 'www.test.com';
            contactRecord.mkto71_Lead_Score__c = 60;
            contactRecord.OtherPhone = '8563254123';
            contactRecord.MailingCity = 'Test City';
            contactRecord.MailingState =  'NY';
            contactRecord.MailingStreet = 'Test Street';
            contactRecord.MailingCountry = 'US';
            contactRecord.MailingPostalCode = '10005';
            contactRecord.Address1City__c = null;
            contactRecord.Address1StateProvince__c =  null;
            contactRecord.Address1Street1__c = null;
            contactRecord.Address1Street2__c = null;
            contactRecord.Address1Street3__c = null;
            contactRecord.Address1CountryRegion__c = null;
            contactRecord.Address1ZIPPostalCode__c = null;
            contactRecord.mkto71_Acquisition_Program__c = 'test';
        return contactRecord;
    }

    public static Contact oldContactEmail(Id accountId) {
            Contact contactRecord = new Contact();
            contactRecord.LastName = 'Test Contact';
            contactRecord.Email = 'testcontact@test.com';
            contactRecord.Title = 'test title';
            contactRecord.AccountId = accountId;
            contactRecord.Phone = '0225632012';
            contactRecord.MobilePhone = '0023485744';
            contactRecord.UserType__c = 'Business User';
            contactRecord.ContactRole__c = 'Primary';
            contactRecord.Form_Name__c = 'test Form';
            contactRecord.Department = 'test Department';
            contactRecord.ContactNo__c = 'test Contact';
            contactRecord.DoNotAllowBulkEmails__c = true;
            contactRecord.DoNotAllowEmails__c = true;
            contactRecord.DoNotAllowFaxes__c = true;
            contactRecord.SendMarketingMaterials__c = true;
            contactRecord.mkto2__Lead_Score__c = 20;
            contactRecord.VAR_Agreement_Accepted__c = true;
            contactRecord.leadFormName__c= 'Test form';
            contactRecord.WebSite__c = 'www.test.com';
            contactRecord.mkto71_Lead_Score__c = 60;
            contactRecord.OtherPhone = '8563254123';
            contactRecord.MailingCity = 'Test City';
            contactRecord.MailingState =  'Test State';
            contactRecord.MailingStreet = 'Test Street';
            contactRecord.MailingCountry = 'AF';
            contactRecord.MailingPostalCode = '123456';
            contactRecord.Address1City__c = null;
            contactRecord.Address1StateProvince__c =  null;
            contactRecord.Address1Street1__c = null;
            contactRecord.Address1Street2__c = null;
            contactRecord.Address1Street3__c = null;
            contactRecord.Address1CountryRegion__c = null;
            contactRecord.Address1ZIPPostalCode__c = null;
            contactRecord.mkto71_Acquisition_Program__c = 'test';
        return contactRecord;
    }

    public static Contact oldContactNoAddress(Id accountId) {
            Contact contactRecord = new Contact();
            contactRecord.LastName = 'Test Contact';
            contactRecord.Email = 'testcontact@test.com';
            contactRecord.Title = 'test title';
            contactRecord.AccountId = accountId;
            contactRecord.Address1StateProvince__c = null;
            contactRecord.MailingCountry = 'AF';
        return contactRecord;
    }

    public static Contact oldContactAddress1(Id accountId) {
            Contact contactRecord = new Contact();
            contactRecord.LastName = 'Test Contact';
            contactRecord.Email = 'testcontact@test.com';
            contactRecord.Title = 'test title';
            contactRecord.AccountId = accountId;
            contactRecord.Address1StateProvince__c = null;
            contactRecord.MailingCountry = 'AF';
        return contactRecord;
    }

    public static Contact oldContactNoOther(Id accountId) {
            Contact contactRecord = new Contact();
            contactRecord.LastName = 'Test Contact';
            contactRecord.Email = 'testcontact@test.com';
            contactRecord.Title = 'test title';
            contactRecord.AccountId = accountId;
            contactRecord.Address1StateProvince__c = null;
            contactRecord.MailingCountry = 'AF';
            contactRecord.MailingPostalCode = '1234';
            contactRecord.DoNotAllowBulkEmails__c = false;
            contactRecord.DoNotAllowEmails__c = false;
            contactRecord.DoNotAllowFaxes__c = false;
            contactRecord.SendMarketingMaterials__c = false;
            contactRecord.VAR_Agreement_Accepted__c = false;
        return contactRecord;
    }

    public static Contact oldContactAddressGiven(Id accountId) {
            Contact contactRecord = new Contact();
            contactRecord.LastName = 'Test Contact';
            contactRecord.Email = 'testcontact@test.com';
            contactRecord.Title = 'test title';
            contactRecord.AccountId = accountId;
            contactRecord.Address1StateProvince__c = null;
            contactRecord.MailingCountry = 'AF';
            contactRecord.MailingPostalCode = '1234';
            contactRecord.OtherCity = 'Demo city';
            contactRecord.OtherState = 'Demo State';
            contactRecord.OtherStreet = 'Demo Street';
            contactRecord.OtherCountry = 'AF';
            contactRecord.OtherPostalCode = '1111111';
            contactRecord.Address1City__c = 'democity';
            contactRecord.Address1StateProvince__c = 'StateProvince';
            contactRecord.Address1Street1__c = 'Street1';
            contactRecord.Address1Street2__c = 'Street2';
            contactRecord.Address1Street3__c = 'Street3';
            contactRecord.Address1CountryRegion__c = 'CountryRegion';
            contactRecord.Address1ZIPPostalCode__c = '222222';
        return contactRecord;
    }

    public static Contact oldContactAddressNotGiven(Id accountId) {
            Contact contactRecord = new Contact();
            contactRecord.LastName = 'Test Contact';
            contactRecord.Email = 'testcontact@test.com';
            contactRecord.Title = 'test title';
            contactRecord.AccountId = accountId;
            //contactRecord.Address1StateProvince__c = null;
            contactRecord.MailingCountry = 'AF';
            contactRecord.MailingPostalCode = '789123';
            contactRecord.OtherPostalCode = '1111111';
        return contactRecord;
    }
    public static Contact newContactTestDataForMailing(Id accountId) {
                    Contact contactRecord = new Contact();
                    contactRecord.LastName = 'Demo Contact ';
                    contactRecord.Email = 'testcontact@test.com';
                    contactRecord.EmailAddress2__c = 'testcontact2@test.com';
                    contactRecord.EmailAddress3__c = 'testcontact3@test.com';
                    contactRecord.Title = 'test new title';
                    contactRecord.Phone = '000000000';
                    contactRecord.ContactNo__c = 'test new Contact';
                    contactRecord.DoNotAllowBulkEmails__c = false;
                    contactRecord.AccountId = accountId;
                    contactRecord.MailingCity = 'Demo City';
                    contactRecord.MailingState =  'Demo State';
                    contactRecord.MailingStreet = 'Demo Street';
                    contactRecord.MailingCountry = 'AF';
                    contactRecord.MailingPostalCode = '789123';
                    contactRecord.mkto71_Acquisition_Program__c = 'test prog';
                    contactRecord.VAR_Agreement_Accepted_Date__c = date.today();
                    contactRecord.VAR_Agreement_Version__c = 'test';
                return contactRecord;
    }




    public static Contact newContactTestDataForContFields(Id accountId) {
                Contact contactRecord = new Contact();
                contactRecord.LastName = 'Demo Contact ';
                contactRecord.Email = 'testcontact@test.com';
                contactRecord.EmailAddress2__c = 'testcontact2@test.com';
                contactRecord.EmailAddress3__c = 'testcontact3@test.com';
                contactRecord.Title = 'test new title';
                contactRecord.Phone = '000000000';
                contactRecord.ContactNo__c = 'test new Contact';
                contactRecord.DoNotAllowBulkEmails__c = false;
                contactRecord.AccountId = accountId;
                contactRecord.MailingCountry = 'AF';
                contactRecord.mkto71_Acquisition_Program__c = 'test prog';
                contactRecord.VAR_Agreement_Accepted_Date__c = date.today();
                contactRecord.VAR_Agreement_Version__c = 'test';
            return contactRecord;
        }

    public static Contact newContactTestDataForOtherAdd(Id accountId) {
            Contact contactRecord = new Contact();
            contactRecord.LastName = 'Demo Contact ';
            contactRecord.Email = 'testcontact@test.com';
            contactRecord.EmailAddress2__c = 'testcontact2@test.com';
            contactRecord.EmailAddress3__c = 'testcontact3@test.com';
            contactRecord.Title = 'test new title';
            contactRecord.Phone = '000000000';
            contactRecord.ContactNo__c = 'test new Contact';
            contactRecord.DoNotAllowBulkEmails__c = false;
            contactRecord.AccountId = accountId;
            contactRecord.MailingCountry = 'AF';
            contactRecord.Address1City__c = 'test';
            contactRecord.Address1StateProvince__c =  'StateProvince';
            contactRecord.Address1Street1__c = 'Street1';
            contactRecord.Address1Street2__c = 'Street2';
            contactRecord.Address1Street3__c = 'Street3';
            contactRecord.Address1CountryRegion__c = 'CountryRegion';
            contactRecord.Address1ZIPPostalCode__c = '222222';
            contactRecord.mkto71_Lead_Score__c=10;
            contactRecord.DoNotAllowBulkEmails__c = true;
            contactRecord.DoNotAllowEmails__c = true;
            contactRecord.DoNotAllowFaxes__c = true;
            contactRecord.SendMarketingMaterials__c = true;
            contactRecord.VAR_Agreement_Accepted__c = true;
        return contactRecord;
    }

    public static Contact newContactTestData(Id accountId) {
            Contact contactRecord = new Contact();
            contactRecord.LastName = 'Demo Contact ';
            contactRecord.Email = 'testcontact@test.com';
            contactRecord.EmailAddress2__c = 'testcontact2@test.com';
            contactRecord.EmailAddress3__c = 'testcontact3@test.com';
            contactRecord.Title = 'test new title';
            contactRecord.Phone = '000000000';
            contactRecord.MobilePhone = '00000000';
            contactRecord.Form_Name__c = 'test new Form';
            contactRecord.Department = 'test new Department';
            contactRecord.ContactNo__c = 'test new Contact';
            contactRecord.DoNotAllowBulkEmails__c = false;
            contactRecord.AccountId = accountId;
            contactRecord.FirstName = 'Test FirstName';
            contactRecord.MailingCity = 'Demo City';
            contactRecord.MailingState =  'Demo State';
            contactRecord.MailingStreet = 'Demo Street';
            contactRecord.MailingCountry = 'AF';
            contactRecord.MailingPostalCode = '789123';
            contactRecord.OtherCity = 'Demo city';
            contactRecord.OtherState = 'Demo State';
            contactRecord.OtherStreet = 'Demo Street';
            contactRecord.OtherCountry = 'AF';
            contactRecord.OtherPostalCode = '1111111';
            contactRecord.Address1StateProvince__c =  'StateProvince';
            contactRecord.Address1Street1__c = 'Street1';
            contactRecord.Address1Street2__c = 'Street2';
            contactRecord.Address1Street3__c = 'Street3';
            contactRecord.Address1CountryRegion__c = 'CountryRegion';
            contactRecord.Address1ZIPPostalCode__c = '222222';
            contactRecord.mkto71_Acquisition_Date__c = Date.today();
            contactRecord.mkto2__Acquisition_Date__c = Date.today();
            contactRecord.mkto71_Lead_Score__c=10;
        return contactRecord;
    }

    public static Contact newContactTestDataOtherAdd(Id accountId) {
        Contact contactRecord = new Contact();
            contactRecord.LastName = 'Demo Contact ';
            contactRecord.Email = 'testcontact@test.com';
            contactRecord.EmailAddress2__c = 'testcontact2@test.com';
            contactRecord.EmailAddress3__c = 'testcontact3@test.com';
            contactRecord.Title = 'test new title';
            contactRecord.Phone = '000000000';
            contactRecord.MobilePhone = '00000000';
            contactRecord.Form_Name__c = 'test new Form';
            contactRecord.Department = 'test new Department';
            contactRecord.ContactNo__c = 'test new Contact';
            contactRecord.DoNotAllowBulkEmails__c = false;
            contactRecord.AccountId = accountId;
            contactRecord.FirstName = 'Test FirstName';
            contactRecord.OtherCity = 'AF';
            contactRecord.OtherState = 'Demo State';
            contactRecord.OtherStreet = 'Demo Street';
            contactRecord.OtherCountry = 'AF';
            contactRecord.OtherPostalCode = '1111111';
            contactRecord.mkto71_Lead_Score__c=10;
            contactRecord.MailingCountry = 'AF';
            return contactRecord;
    }

    public static Contact newContactTestDataAddress1(Id accountId) {
        Contact contactRecord = new Contact();
            contactRecord.LastName = 'Demo Contact ';
            contactRecord.Email = 'testcontact@test.com';
            contactRecord.EmailAddress2__c = 'testcontact2@test.com';
            contactRecord.EmailAddress3__c = 'testcontact3@test.com';
            contactRecord.Title = 'test new title';
            contactRecord.Phone = '000000000';
            contactRecord.MobilePhone = '00000000';
            contactRecord.Form_Name__c = 'test new Form';
            contactRecord.Department = 'test new Department';
            contactRecord.ContactNo__c = 'test new Contact';
            contactRecord.DoNotAllowBulkEmails__c = false;
            contactRecord.AccountId = accountId;
            contactRecord.FirstName = 'Test FirstName';
            contactRecord.Address1StateProvince__c =  'StateProvince';
            contactRecord.Address1Street1__c = 'Street1';
            contactRecord.Address1Street2__c = 'Street2';
            contactRecord.Address1Street3__c = 'Street3';
            contactRecord.Address1CountryRegion__c = 'CountryRegion';
            contactRecord.Address1ZIPPostalCode__c = '222222';
            contactRecord.mkto71_Lead_Score__c=10;
            contactRecord.MailingCountry = 'AF';
            return contactRecord;
    }

    public static Lead leadTestData() {
        Lead leadObj = new Lead();
        leadObj.FirstName = 'Test F';
        leadObj.LastName = 'Test Lead';
        leadObj.Company = 'Test Company';
        leadObj.Email = 'testcontact@test.com';
        leadObj.Status = 'Calling';
        leadObj.UserType__c = 'Other';
        leadObj.LeadSource = 'Advertisement';
        leadObj.Street = 'test';
        leadObj.City = 'test';
        leadObj.Country  = 'AF';
        leadObj.PostalCode  = '11111';
        //leadObj.mkto2__Inferred_State_Region__c = 'test';
        leadObj.State = 'test';
        return leadObj;
    }

    public static Note noteTestData(Id leadId) {
              Note note = new Note();
              note.Title ='test';
              note.ParentId = leadId;
              return note;
    }

    public static Event eventTestData(Id leadId) {
          Event event = new Event();
          event.WhoId = leadId;
          event.DurationInMinutes = 52;
          event.ActivityDateTime = DateTime.parse('10/12/2017 11:46 AM');
        return event;
    }

    public static Task taskTestData(Id leadId) {
            Task taskRecord = new Task();
            taskRecord.WhoId = leadId;
            taskRecord.Subject = 'test Subject';
            taskRecord.ActivityDate = date.today();
            taskRecord.Status = 'Completed';
            return taskRecord;
    }

    /**
     *  Test method to test the merging of new and old contacts
     */

     @isTest static void testNewContactWhenOldEMailBlankl() {
         Account account = accountTestData();
         insert account;

         Contact oldContact = oldContactBlankTestData(account.Id);
         insert oldContact;

         Contact newContact = newContactTestData(account.Id);
         System.Test.startTest();
            insert newContact;
         System.Test.stopTest();

         List<Contact> conList = [SELECT Id, Title FROM COntact WHERE Title = 'test new title'];
         System.assertEquals(1, conList.size());
     }

     @isTest static void testNewContactWhenEmailMatch() {
         Account account = accountTestData();
         insert account;

         Contact oldContact = oldContactEmail(account.Id);
         insert oldContact;

         Contact newContact = newContactTestData(account.Id);
         System.Test.startTest();
            insert newContact;
         System.Test.stopTest();

         List<Contact> conList = [SELECT Id, Title,Email,EmailAddress2__c, EmailAddress3__c,Merge_Status__c FROM Contact
                                    WHERE Id =: oldContact.Id];

         System.assertEquals('testcontact2@test.com', conList[0].EmailAddress2__c);
         System.assertEquals('testcontact3@test.com', conList[0].EmailAddress3__c);
     }

     @isTest static void testNewContactWhenEmail2Match() {
         Account account = accountTestData();
         insert account;

         Contact oldContact = oldContactNoAddress(account.Id);
         insert oldContact;

         Contact newContact = newContactTestData(account.Id);
         System.Test.startTest();
            insert newContact;
         System.Test.stopTest();

         List<Contact> conList = [SELECT Id, Title,Email,EmailAddress2__c, EmailAddress3__c,Merge_Status__c,MailingAddress,
                                    MailingCity, MailingState, MailingStreet, MailingCountry ,MailingPostalCode,OtherCity,
                                    OtherState,OtherStreet,OtherCountry,OtherPostalCode,Address1StateProvince__c,Address1Street1__c,
                                    Address1Street2__c,Address1Street3__c,Address1CountryRegion__c,Address1ZIPPostalCode__c
                                    FROM Contact
                                    ];
        // system.debug('conList ======>>>'+conList[0]);
         System.assertEquals('testcontact3@test.com', conList[0].EmailAddress3__c);
     }

     @isTest static void testNewContactWhenOtherAddress() {
         Account account = accountTestData();
         insert account;

         Contact oldContact = oldContactNoAddress(account.Id);
         insert oldContact;

         Contact newContact = newContactTestDataOtherAdd(account.Id);
         System.Test.startTest();
            insert newContact;
         System.Test.stopTest();

         List<Contact> conList = [SELECT Id, Title,Email,EmailAddress2__c, EmailAddress3__c,Merge_Status__c,MailingAddress,
                                    MailingCity, MailingState, MailingStreet, MailingCountry ,MailingPostalCode,OtherCity,
                                    OtherState,OtherStreet,OtherCountry,OtherPostalCode,Address1StateProvince__c,Address1Street1__c,
                                    Address1Street2__c,Address1Street3__c,Address1CountryRegion__c,Address1ZIPPostalCode__c
                                    FROM Contact
                                    ];

        // for (Contact con : conList) {
        //     system.debug('CONTACT ##########' + con);
        // }
        // system.debug('conList ======>>>'+conList[0]);
         System.assertEquals('testcontact3@test.com', conList[0].EmailAddress3__c);
     }

     @isTest static void testNewContactWhenAddress1() {
         Account account = accountTestData();
         insert account;

         Contact oldContact = oldContactNoAddress(account.Id);
         insert oldContact;

         Contact newContact = newContactTestDataAddress1(account.Id);
         System.Test.startTest();
            insert newContact;
         System.Test.stopTest();

         List<Contact> conList = [SELECT Id, Title,Email,EmailAddress2__c, EmailAddress3__c,Merge_Status__c,MailingAddress,
                                    MailingCity, MailingState, MailingStreet, MailingCountry ,MailingPostalCode,OtherCity,
                                    OtherState,OtherStreet,OtherCountry,OtherPostalCode,Address1StateProvince__c,Address1Street1__c,
                                    Address1Street2__c,Address1Street3__c,Address1CountryRegion__c,Address1ZIPPostalCode__c
                                    FROM Contact
                                    ];

         System.assertEquals('testcontact3@test.com', conList[0].EmailAddress3__c);
     }

     @isTest static void testNewContactWhenLeadConvert() {
         Account account = accountTestData();
         insert account;

         Contact oldContact = oldContactEmail(account.Id);
         insert oldContact;

         Lead newLead = leadTestData();
         System.Test.startTest();
            insert newLead;
            Note noteobj = noteTestData(newLead.Id);
            insert noteobj;
            Event newEvent = eventTestData(newLead.Id);
            insert newEvent;
            Task newTask = taskTestData(newLead.Id);
            insert newTask;
            Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(newLead.id);

            LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
            lc.setConvertedStatus(convertStatus.MasterLabel);

            Database.LeadConvertResult lcr = Database.convertLead(lc);
         System.Test.stopTest();

         System.assert(lcr.isSuccess());

         List<Contact> conList = [SELECT Id, Title,Email,EmailAddress2__c, EmailAddress3__c,Merge_Status__c,MailingAddress
                                    FROM Contact
                                    ];
        system.debug('conList=========>'+conList[0]);
        system.debug('conList=========>'+conList[1]);
        system.debug('conList[0]'+conList[0].Id);
        system.debug('conList[1]'+conList[1].Id);
        Lead leadOBJ = [SELECT Id,Name, Status from Lead];
        system.debug('leadOBJ===>'+leadOBJ);

        list<Note> lstnoteobj = [SELECT Id, Title, ParentId FROM Note];

        for(Note noteo : lstnoteobj) {
            system.debug('noteo===>'+noteo);
            system.debug('noteo===>'+noteo.ParentId);
        }
        // System.assertEquals(2, conList.size());
        // system.debug('conList ======>>>'+conList[0]);
         System.assertEquals(3, lstnoteobj.size());
     }

     @isTest static void testNewContactWhenOldAddresss1Null() {
         Account account = accountTestData();
         insert account;

         Contact oldContact = oldContactAddress1(account.Id);
         insert oldContact;

         Contact newContact = newContactTestData(account.Id);
         System.Test.startTest();
            insert newContact;
         System.Test.stopTest();

         List<Contact> conList = [SELECT Id, Title,Email,EmailAddress2__c, EmailAddress3__c,Merge_Status__c FROM Contact
                                    WHERE Id =: oldContact.Id];

         System.assertEquals('testcontact2@test.com', conList[0].EmailAddress2__c);
         System.assertEquals('testcontact3@test.com', conList[0].EmailAddress3__c);
     }

     @isTest static void testNewContactWhenOldOther() {
         Account account = accountTestData();
         insert account;

         Contact oldContact = oldContactNoOther(account.Id);
         insert oldContact;

         Contact newContact = newContactTestDataForOtherAdd(account.Id);
         System.Test.startTest();
            insert newContact;
         System.Test.stopTest();

         List<Contact> conList = [SELECT Id, Title,Email,EmailAddress2__c, EmailAddress3__c,Merge_Status__c FROM Contact
                                    WHERE Id =: oldContact.Id];

         System.assertEquals('testcontact2@test.com', conList[0].EmailAddress2__c);
         System.assertEquals('testcontact3@test.com', conList[0].EmailAddress3__c);
     }

     @isTest static void testNewContactWhenOldAddGiven() {
         Account account = accountTestData();
         insert account;

         Contact oldContact = oldContactAddressGiven(account.Id);
         insert oldContact;

         Contact newContact = newContactTestDataForContFields(account.Id);
         System.Test.startTest();
            insert newContact;
         System.Test.stopTest();

         List<Contact> conList = [SELECT Id, Title,Email,EmailAddress2__c, EmailAddress3__c,Merge_Status__c FROM Contact
                                    WHERE Id =: oldContact.Id];

         System.assertEquals('testcontact2@test.com', conList[0].EmailAddress2__c);
         System.assertEquals('testcontact3@test.com', conList[0].EmailAddress3__c);
     }

     @isTest static void testNewContactWhenOldAddNotGiven() {
         Account account = accountTestData();
         insert account;

         Contact oldContact = oldContactAddressNotGiven(account.Id);
         insert oldContact;

         Contact newContact = newContactTestDataForMailing(account.Id);
         System.Test.startTest();
            insert newContact;
         System.Test.stopTest();

         List<Contact> conList = [SELECT Id, Title,Email,EmailAddress2__c, EmailAddress3__c,Merge_Status__c FROM Contact
                                    WHERE Id =: oldContact.Id];

         System.assertEquals('testcontact2@test.com', conList[0].EmailAddress2__c);
         System.assertEquals('testcontact3@test.com', conList[0].EmailAddress3__c);
     }
}