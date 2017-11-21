/**
  \file         BatchUpdateAccountPartnerLevelsTest.cls
  \brief        This class is written for code coverage.
  \details      SSF-400
  \author       Sean Oldroyd
  \version      1.2
  \date         30 August 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.1       2017-08-24  Matt Thompson-Moltzen   Modified to process Accounts!
  1.2       2017-08-30  Matt Thompson-Moltzen   Changed references to User_Type__c to transactionTypesAsText__c (SSF-458).
*/
@isTest
public with sharing class BatchUpdateAccountPartnerLevelsTest
{
  static testMethod void testBatchUpdateAccountPartnerLevels()
  {
    List<Account> accts = new List<Account>();

    Integer i = 0;

    for (i = 0; i < 200; i++) {
      Account acct = new Account();

      acct.Name                = 'Company-' + i;
      acct.transactionTypes__c = 'Business User';
      acct.BillingCity         = 'Draper';
      acct.BillingState        = 'UT';
      acct.BillingPostalCode   = '84020';
      acct.BillingCountry      = 'US';

      accts.add(acct);
    }

    AccountTriggerHandler.disableTrigger();

    insert accts;

    AccountTriggerHandler.enableTrigger();

    Test.startTest();

    BatchUpdateAccountPartnerLevels buapl = new BatchUpdateAccountPartnerLevels();

    DataBase.executeBatch(buapl);

    Test.stopTest();
  }
}