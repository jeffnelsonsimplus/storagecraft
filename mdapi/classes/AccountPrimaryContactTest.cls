@isTest
private class AccountPrimaryContactTest {   
    // Contact becomes "Inactive"
    @isTest static void testOne() {
        Account testAccount = new Account(
            Name = 'TestAccount',
        	User_Type__c = 'Both MSP and VAR',
            Type = 'Prospect',
        	BillingStreet = '123 Test Street',
        	BillingCity = 'Holladay',
        	BillingState =  'UT',
        	BillingCountry = 'US',
        	BillingPostalCode = '84117');
        system.debug('Account: ' + testAccount);      
        insert testAccount;

        Contact testContact = new Contact(
            AccountId = testAccount.Id,
            UserType__c = 'Both MSP and VAR',
            FirstName = 'Test',
            LastName = 'Test',
            Phone = '801 555-5555',
            Email = 'test@storagecraft.com',
        	MailingStreet = '123 Test Street',
        	MailingCity = 'Holladay',
        	MailingState =  'UT',
        	MailingCountry = 'US',
        	MailingPostalCode = '84117');       
        system.debug('Contact: ' + testContact);
        insert testContact;

        testAccount = [SELECT Id, Primary_Contact__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(testContact.Id, testAccount.Primary_Contact__c);

        testContact.Status__c = 'Inactive';
		update testContact;  

        testAccount = [SELECT Id, Primary_Contact__c FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(null, testAccount.Primary_Contact__c);
    } 
    
    // Contact switches Accounts
    @isTest static void testTwo() {
        Account testAccount1 = new Account(
            Name = 'TestAccount1',
        	User_Type__c = 'Both MSP and VAR',
            Type = 'Prospect',
        	BillingStreet = '123 Test Street',
        	BillingCity = 'Holladay',
        	BillingState =  'UT',
        	BillingCountry = 'US',
        	BillingPostalCode = '84117');
        system.debug('Account 1: ' + testAccount1);      
        insert testAccount1;
        
        Account testAccount2 = new Account(
            Name = 'TestAccount2',
        	User_Type__c = 'Both MSP and VAR',
            Type = 'Prospect',
        	BillingStreet = '123 Test Street',
        	BillingCity = 'Holladay',
        	BillingState =  'UT',
        	BillingCountry = 'US',
        	BillingPostalCode = '84117');
        system.debug('Account 2: ' + testAccount2);      
        insert testAccount2;

        Contact testContact = new Contact(
            AccountId = testAccount1.Id,
            UserType__c = 'Both MSP and VAR',
            FirstName = 'Test',
            LastName = 'Test',
            Phone = '801 555-5555',
            Email = 'test@storagecraft.com',
        	MailingStreet = '123 Test Street',
        	MailingCity = 'Holladay',
        	MailingState =  'UT',
        	MailingCountry = 'US',
        	MailingPostalCode = '84117');        
        system.debug('Contact: ' + testContact);
        insert testContact;

        testAccount1 = [SELECT Id, Primary_Contact__c FROM Account WHERE Id = :testAccount1.Id];
        System.assertEquals(testContact.Id, testAccount1.Primary_Contact__c);

        testContact.AccountId = testAccount2.Id;
		update testContact;  

        testAccount1 = [SELECT Id, Primary_Contact__c FROM Account WHERE Id = :testAccount1.Id];
        System.assertEquals(null, testAccount1.Primary_Contact__c);
    }
}