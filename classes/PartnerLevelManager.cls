/**
  \file         PartnerLevelManagerTest.apcx
  \brief        Set and Account's Partner Level based on account values.
  \details      JIRA ticket(s): SSF-545, SSF-621
                Code has changed from previous version because the "End User" account Type
                no longer exists and just eliminating that would have all Accounts have 
                a mimimum of 'Authorized'.  In ticket 545, Matt Harding asks for the User Types
                to have a minimum of 'Authorized'.
  \author       Loch MacLeod
  \version      1.0
  \date         22 September 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
*/
public class PartnerLevelManager {  
    private static String AccountUserTypes = 'Both MSP and VAR;Direct Market Reseller (DMR);Managed Service Provider (MSP);Value Added Reseller (VAR);Alliance Partner;Original Equipment Manufacturer (OEM);';
    
    //
    // setPartnerLevel sets an Account's Partner Level.
    //             
    // For an Account to have a minimum Partner Level of 'Authorized' 
    // it must have at least ONE of the following:
    //     * Be in the list of User Types
    //     * An Account Number (NavId)
    //     * VAR_Agreement_Accepted__c set to true
    //     * An active Agreement
    // 
    public static void setPartnerLevel(List<Account> listNew) {
        List<Id> accountIds = new List<Id>();
        
        for (Account a : listNew) {
            accountIds.add(a.Id);
        }
        
        // ??? Should it be certain types of agreements ???        
        Map<Id, Account> accountAgreements = new Map<Id, Account>([SELECT Id, (SELECT Id FROM Agreements__r WHERE Status__c = 'Active') FROM Account WHERE Id IN :accountIds]);
        
        Boolean isPartner = false;
        for (Account a : listNew) {
            System.debug('User Type      ' + a.User_Type__c);
            System.debug('AccountNumber  ' + a.AccountNumber);
            System.debug('VAR Agreement  ' + a.VAR_Agreement_Accepted__c);

            if ((!String.isBlank(a.User_Type__c) && AccountUserTypes.contains(a.User_Type__c)) ||
                !String.isBlank(a.AccountNumber) ||                
                a.VAR_Agreement_Accepted__c ||
                (accountAgreements.get(a.Id) != null && 
                accountAgreements.get(a.Id).Agreements__r != null &&
                0 < accountAgreements.get(a.Id).Agreements__r.size())) {
                if (String.isBlank(a.Partner_Level_Calculated__c) || 'None'.equals(a.Partner_Level_Calculated__c)) {
                    // Minimum Partner Level of "Authorized"
                    a.Partner_Level_Calculated__c = 'Authorized';
                }
            } 
            else {
                // Account is not a Partner
                a.Partner_Level_Calculated__c = 'None';
            }

            if (!a.Partner_Level_Overwritten__c) {
                // If Partner Level has not been overwritten it must be the same as Calculated
                a.Partner_Level__c = a.Partner_Level_Calculated__c;
            }
            
            System.debug('Partner_Level_Calculated__c  ' + a.Partner_Level_Calculated__c);
            System.debug('Partner_Level__c             ' + a.Partner_Level__c);
        }
    }
}