/**
  \file         BatchSsf458UpdateAccountsTest.cls
  \brief        This class is written for code coverage.
  \details      SSF-448
  \author       Matt Thompson-Moltzen
  \version      1.0
  \date         24 August 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
*/
@isTest
public with sharing class BatchSsf458UpdateAccountsTest
{
  static testMethod void testBatchSsf458UpdateAccounts()
  {
    List<Account> accts = new List<Account>();

    Integer i = 0;

    for (i = 0; i < 10; i++) {
      Account acct = new Account();

      acct.Name              = 'Company-' + i;
      acct.User_Type__c      = 'Business User';
      acct.BillingCity       = 'Draper';
      acct.BillingState      = 'UT';
      acct.BillingPostalCode = '84020';
      acct.BillingCountry    = 'US';

      accts.add(acct);
    }

    AccountTriggerHandler.disableTrigger();

    insert accts;

    AccountTriggerHandler.enableTrigger();

    Test.startTest();

    BatchSsf458UpdateAccounts bsua = new BatchSsf458UpdateAccounts();

    DataBase.executeBatch(bsua);

    Test.stopTest();
  }
}