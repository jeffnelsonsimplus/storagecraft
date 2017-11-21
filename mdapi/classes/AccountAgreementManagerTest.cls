/**
  \file         AccountAgreementManagerTest.aoxc
  \brief        Runs tests against the AccountAgreementManager
  \details
  \author       Loch MacLeod
  \version      1.6
  \date         17 August 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  Version   Date        Author                  Description
  1.5       2017-07-31  Loch MacLeod            Set RecordType with the Type change
  1.6       2017-08-17  Matt Thompson-Moltzen   Modified test_SignsAgreement as will always be Prospect on update.
*/
@isTest (SeeAllData = true)
public class AccountAgreementManagerTest {
    // New account, No Agreement or AccountNumber
    static TestMethod void test_NewAccount() {
        account acct = new account(Name = 'Account1',
                                   Type = 'Prospect',
                                   User_Type__c = 'Both MSP and VAR',
                                   BillingCountry = 'US',
                                   BillingState = 'NY',
                                   BillingPostalCode = '01234',
                                   VAR_Agreement_Accepted__c = false);
        insert acct;

        acct = (Account) [SELECT Id, Type FROM Account WHERE Id = :acct.Id];

        System.assertEquals('Prospect', acct.Type);
    }

    // Business User Account signs agreement, no AccountNumber
    static TestMethod void test_SignsAgreement() {
        account acct = new account(Name = 'Account2',
                                   Type = 'Prospect',
                                   User_Type__c = 'Business User',
                                   BillingCountry = 'US',
                                   BillingState = 'NY',
                                   BillingPostalCode = '01234',
                                   VAR_Agreement_Accepted__c = false);
        insert acct;

        acct = (Account) [SELECT Id, Type FROM Account WHERE Id = :acct.Id];
        System.assertEquals('Prospect', acct.Type);

        acct.VAR_Agreement_Accepted__c = true;

        update acct;

        acct = (Account) [SELECT Id, Type FROM Account WHERE Id = :acct.Id];
        System.assertEquals('Prospect', acct.Type);
    }

    // Prospect Account starts with AccountNumber
    static TestMethod void test_AccountNumber() {
        account acct = new account(Name = 'Account3',
                                   Type = 'Prospect',
                                   User_Type__c = 'Business User',
                                   AccountNumber = '12345',
                                   BillingCountry = 'US',
                                   BillingState = 'NY',
                                   BillingPostalCode = '01234');
        insert acct;

        acct = (Account) [SELECT Id, Type FROM Account WHERE Id = :acct.Id];
        System.assertEquals('Account', acct.Type);
    }

    // Prospect Account given AccountNumbr
    static TestMethod void test_GivenAccountNumber(){
        account acct = new account(Name = 'Account4',
                                   Type = 'Account',
                                   BillingCountry = 'US',
                                   BillingState = 'NY',
                                   BillingPostalCode = '01234');
        insert acct;

        acct = (Account) [SELECT Id, Type FROM Account WHERE Id = :acct.Id];
        System.assertEquals('Prospect', acct.Type);

        acct.AccountNumber = '12345';

        update acct;

        acct = (Account) [SELECT Id, Type, VAR_Agreement_Accepted__c FROM Account WHERE Id = :acct.Id];
        System.assertEquals('Account', acct.Type);
    }

    // Account looses AccountNumber
    static TestMethod void test_LostAccountNumber() {
        account acct = new account(Name = 'Account4',
                                   Type = 'Account',
                                   User_Type__c = 'Business User',
                                   AccountNumber = '11111',
                                   BillingCountry = 'US',
                                   BillingState = 'NY',
                                   BillingPostalCode = '01234');
        insert acct;

        acct = (Account) [SELECT Id, Type FROM Account WHERE Id = :acct.Id];
        System.assertEquals('Account', acct.Type);

        acct.AccountNumber = null;

        update acct;

        acct = (Account) [SELECT Id, Type, VAR_Agreement_Accepted__c FROM Account WHERE Id = :acct.Id];
        System.assertEquals('Prospect', acct.Type);
    }
}