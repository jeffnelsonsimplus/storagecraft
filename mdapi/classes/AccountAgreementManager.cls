/**
  \file         AccountAgreementManager.cls
  \brief        Sets the account agreements and types
  \details
  \author       Loch MacLeod
  \version      1.7
  \date         30 August 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.5       2017-07-31  Loch MacLeod            Set RecordType with the Type change
  1.6       2017-08-09  Matt Thompson-Moltzen   Removed setting the Account Type field - this is now done in the Accounts class (SSF-458)
                                                Corrected the setting of the RecordType field
  1.7       2017-08-30  Matt Thompson-Moltzen   Changed references to User_Type__c to transactionTypesAsText__c (SSF-458).
*/
public class AccountAgreementManager {
    /*
    public static void convertToProspect(List<Account> listNew) {
        for (Integer i = 0; i < listNew.size(); i++) {
            if (listNew[i].VAR_Agreement_Accepted__c == false && !'End User'.equals(listNew[i])) {
                System.debug('Change to Prospect');
                listNew[i].Type = 'Prospect';
            }
        }
    }

    public static void convertToAccount(List<Account> listOld, List<Account> listNew) {
        for (Integer i = 0; i < listNew.size(); i++) {
            if (listNew[i].VAR_Agreement_Accepted__c == true && 'Prospect'.equals(listNew[i].Type)) {
                System.debug('Change Prospect to Account');
                listNew[i].Type = 'Account';
            }
        }
    }
    */

    public static void setType(List<Account> listNew) {
        setType(null, listNew);
    }

    public static void setType(List<Account> listOld, List<Account> listNew) {
        RecordType rtPartner = null;
        RecordType rtEndUser = null;
        List<RecordType> rTypes = [Select Id, Name from RecordType where sObjectType = 'Account'];

        for (RecordType rType : rTypes) {
            if (rType.Name.Equals('Partner')) {
                rtPartner = rType;
            }
            else if (rType.Name.Equals('End User')) {
                rtEndUser = rType;
            }
        }

        for (Integer i = 0; i < listNew.size(); i++) {
            if (listNew[i].AccountNumber != null || listNew[i].VAR_Agreement_Accepted__c == true) {
                System.debug('RecordType to Partner');
//                listNew[i].Type = 'Account';
                listNew[i].RecordTypeId = rtPartner.Id;
            }
            else {
//                System.debug('Change the Type to Prospect. Has no Account or Agreement');
//                listNew[i].Type = 'Prospect';

                if (listNew[i].transactionTypesAsText__c.contains('Business User') || listNew[i].transactionTypesAsText__c.contains('Home User')) {
//                if ('Business User'.equals(listNew[i].User_Type__c) ||
//                    'Home User'.equals(listNew[i].User_Type__c)) {
                    System.debug('Business User or Home User.  Set RecordType to End User');
                    listNew[i].RecordTypeId = rtEndUser.Id;
                }
                else {
                    System.debug('Set RecordType to Partner');
                    listNew[i].RecordTypeId = rtPartner.Id;
                }

                if (listOld != null && listOld[i].AccountNumber != null && listNew[i].AccountNumber == null) {
                    // AccountNumber has been cleared
                    System.debug('Lost AccountNumber');
                    listNew[i].VAR_Agreement_Accepted__c = false;
                }
            }
        }
    }
}