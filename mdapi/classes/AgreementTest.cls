/**
  \file         AgreementTest.cls
  \brief        Test class for the Agreement class
  \details
  \author       Matt Thompson-Moltzen
  \version      1.1
  \date         7 September 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.1				2017-09-07	Matt Thompson-Moltzen		Create an Account for the test rather than select 'StorgeCraft Technology Corporation' which will not exist in most sandboxes.
*/
@isTest (SeeAllData = true)
private class AgreementTest {
  static testMethod void agreementTest1() {
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

    Agreement__c agt = new Agreement__c();

    agt.Account__c            = a.Id;
    agt.Status__c             = 'Active';
    agt.Type__c               = 'Cloud';
    agt.Contracting_Entity__c = 'StorageCraft IE';

    try {
      insert agt;
    }
    catch (Exception e) {
      System.debug('Agreement__c::insert() failed: ' + e.getMessage());
      System.debug('Agreement__c: ' + agt);
    }

    List<Agreement__c> agts = [SELECT Id, Name, Type__c, Account__r.Name FROM Agreement__c WHERE (Account__c = :agt.Account__c) AND (Type__c IN ('Cloud', 'MSP', 'VAR', 'Reseller'))];

    System.assertNotEquals(0, agts.size());
  }
}