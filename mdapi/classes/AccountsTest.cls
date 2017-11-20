/**
  \file         AccountsTest.cls
  \brief        Test class for the Accounts class
  \details
  \author       Matt Thompson-Moltzen
  \version      1.1
  \date         7 September 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.1				2017-09-07	Matt Thompson-Moltzen		Specified a value for User_Type__c when creating Account.
*/
@isTest (SeeAllData = true)
private class AccountsTest
{
  static testMethod void accountsTest1()
  {
    Account a = new Account();

    a.Name              ='STC';
    a.Type              ='Prospect';
    a.BillingCity       ='Sydney';
    a.BillingState      ='NSW';
    a.BillingPostalCode ='2000';
    a.BillingCountry    ='AU';

    a.User_Type__c        = 'Business User';
//    a.transactionTypes__c = 'Business User';

    try {
      insert a;
    }
    catch (Exception e) {
      System.debug('Account::insert() failed: ' + e.getMessage());
    }

    a = [SELECT Id, Name, Type FROM Account WHERE (Id = :a.Id)];

    System.assertEquals('Prospect', a.Type);

    a.AccountNumber = '666444';

    try {
      update a;
    }
    catch (exception e) {
      System.debug('Account::update() failed: ' + e.getMessage());
    }

    a = [SELECT Id, Name, Type FROM Account WHERE (Id = :a.Id)];

    System.assertEquals('Account', a.Type);
  }

  static testMethod void accountsTest2()
  {
    Account a = new Account();

    a.Name              ='STC';
    a.AccountNumber     ='666444';
    a.Type              ='Prospect';
    a.BillingCity       ='Sydney';
    a.BillingState      ='NSW';
    a.BillingPostalCode ='2000';
    a.BillingCountry    ='AU';

    a.User_Type__c        = 'Business User';
//    a.transactionTypes__c = 'Business User';

    try {
      insert a;
    }
    catch (Exception e) {
      System.debug('Account::insert() failed: ' + e.getMessage());
    }

    a = [SELECT Id, Name, Type FROM Account WHERE (Id = :a.Id)];

    System.assertEquals('Account', a.Type);

    a.AccountNumber = null;

    try {
      update a;
    }
    catch (exception e) {
      System.debug('Account::update() failed: ' + e.getMessage());
    }

    a = [SELECT Id, Name, Type FROM Account WHERE (Id = :a.Id)];

    System.assertEquals('Prospect', a.Type);
  }


  static testMethod void testUpdatePartnerPortal()
  {

    String url      = 'http://api.salesforce.com/foo/bar';
    String body     = 'body: body of request';
    String username = 'foo';
    String password = 'bar';

    Accounts.updatePartnerPortal(url, body, username, password);
  }

}