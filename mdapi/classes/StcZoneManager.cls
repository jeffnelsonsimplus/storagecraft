/**
  \file         StcZoneManager.apxc
  \brief        Methods for the StcZone custom object
  \details      Finds territories and owners for Leads and Accounts
                SSF-227
  \author       Loch MacLeod
  \version      1.11
  \date         25 July 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.1                   Anthony Heber           Updated to set owner despite assignment rules and evaluate against new record instead of old
  1.2       2017-07-17  Loch MacLeod            SSF-383 - Added User Type tests for Leads and Accounts, Postal Code take Left 5 characters
  1.3       2017-07-19  Loch MacLeod            SSF-395, SSF-402 - Promote_Account__c and corrected Account assignment
  1.4       2017-07-24  Matt Thompson-Moltzen   Updated setZone() to accept only List-List arguments and not Map-List arguments (to be compatible with the new Trigger frameowrk)
  1.5       2017-07-25  Loch MacLeod            SSF-413  Opportunity territory and assignment
  1.6       2017-08-23  Loch MacLeod            SSF-559  Account User Type test should be OR'd with High Potential, not AND'd
  1.7       2017-08-23  Loch MacLeod            SSF-585  High Potential only allowed if Account User Type
  1.8       2017-08-30  Loch MacLeod            SSF-593  Change Account User Type calls to Transaction Types
  1.9       2017-08-30  Loch MacLeod            SSF-559  Fix assignment rules
  1.10      2017-09-27  Loch MacLeod            SSF-593  Transaction Types back in
  1.11      2017-09-28  Loch MacLeod            SSF-550  Lead Assignment error
*/
public class StcZoneManager {
    // Map of the Active zones
    Map<Id, StcZone__c> zones;
    
    // Ordered list of Active rules
    List<StcZoneRule__c> rules;   
    
    private static Boolean usingTransactionTypes = true;
    
    public StcZoneManager() {
        zones = new Map<Id, StcZone__c>([SELECT Id, Name, Global_Region__c, Region__c, Territory__c, Controlling_Office__c, Assign_To__c, Assign_Accounts_To__c
                 FROM StcZone__c
                 WHERE Active__c = true]);

        rules = [SELECT Id, Name, Countries__c, States__c, Postal_Codes__c, StcZone__c, Lead_User_Types__c, Account_User_Types__c, High_Potential__c, Works_On__c
                 FROM StcZoneRule__c
                 WHERE Active__c = true
                 ORDER BY Order__c];
    }
          
    //
    // Assign Leads to StcTerritories
    //
    public void setZone(List<Lead> leadsOld, List<Lead> leadsNew) {
        Integer i = 0;
        
        for (Lead l : leadsNew) {           
            if (leadsOld == null || changedLead(leadsOld.get(i), l)) {
                StcZone__c zone = findZone(true, l.State, l.Country, l.PostalCode, false, l.UserType__c); 
                if (zone != null) {
                    if (zone.Assign_To__c != null && leadsOld == null) {
                        // Only assign on lead insert
                        System.debug('Set Owner: ' + zone.Assign_To__c);
                        l.OwnerId = zone.Assign_To__c;
                    }
                    l.StcZone_Global_Region__c = zone.Global_Region__c;
                    l.StcZone_Region__c = zone.Region__c;
                    l.StcZone_Territory__c = zone.Territory__c;
                }
                
                i++;
            }
        }
    }
    
    private Boolean changedLead(Lead oldLead, Lead newLead) {
        if (oldLead == null ||
            newLead.StcZone_Territory__c == null ||
            newLead.State != oldLead.State ||
            newLead.Country != oldLead.Country ||
            newLead.PostalCode != oldLead.PostalCode ||
            newLead.UserType__c != oldLead.UserType__c) {
            return true;
        }
        return false;
    }
      
    //
    // Assign Accounts to StcTerritories
    //
    public void setZone(List<Account> accountsOld, List<Account> accountsNew) {
        Integer i = 0;
        
        for (Account a : accountsNew) {        
            if (accountsOld == null || changedAccount(accountsOld.get(i), a)) {
                String utype = a.User_Type__c;
                if (usingTransactionTypes) { utype = a.transactionTypesAsText__c; }
                
                StcZone__c zone = findZone(false, a.BillingState, a.BillingCountry, a.BillingPostalCode, hasPotential(a), utype);
                
                if (zone != null) {                    	
                    if (zone.Assign_Accounts_To__c != null) {
                        //System.debug('Set Owner:  zone.Assign_Accounts_To__c');
                     	a.OwnerId = zone.Assign_Accounts_To__c;
                    }
                    a.StcZone_Global_Region__c = zone.Global_Region__c;
                    a.StcZone_Region__c = zone.Region__c;
                    a.StcZone_Territory__c = zone.Territory__c;
                }
            }
            i++;
        }
    }
    
    private Boolean changedAccount(Account oldAccount, Account newAccount) {
        if (oldAccount == null) {
            return true;
        }
        
        Boolean changeType = (newAccount.User_Type__c != oldAccount.User_Type__c);
        String utype = newAccount.User_Type__c;
        if (usingTransactionTypes) { 
            changeType = (newAccount.transactionTypesAsText__c != oldAccount.transactionTypesAsText__c);
            utype = newAccount.transactionTypesAsText__c; 
        }
        
        if (changeType||
            newAccount.StcZone_Territory__c == null ||
            newAccount.High_Potential__c != oldAccount.High_Potential__c ||
            newAccount.Promote_Account__c != oldAccount.Promote_Account__c ||
            newAccount.Partner_Level_atQuarter__c != oldAccount.Partner_Level_atQuarter__c ||
            newAccount.BillingState != oldAccount.BillingState ||
            newAccount.BillingCountry != oldAccount.BillingCountry ||
            newAccount.BillingPostalCode != oldAccount.BillingPostalCode) {
            return true;
        }
        return false;                        
    }
      
    //
    //  Opportunities are assigned owner and territory based on Account Partner (Partner__c) 
    //  if it exists, otherwise by Account.
    // 
    public void setZone(List<Opportunity> oldOpportunity, List<Opportunity> newOpportunity) {
        Map<Id, Integer> updateToPartner = new Map<Id, Integer>();
        Map<Id, Integer> updateToAccount = new Map<Id, Integer>();
        
        //System.debug('Opportunity setZone');
        
        if (oldOpportunity == null) {                        
            for (Opportunity oNew : newOpportunity) {
                if (oNew.Partner__c != null) {
                    //System.debug('Insert Opp with Partner:  ' + oNew.Partner__c);
                    updateToPartner.put(oNew.Partner__c, 1);
                } 
                else {
                    if (oNew.AccountId != null) {
                        //System.debug('Insert Opp with Account:  ' + oNew.AccountId);
                        updateToAccount.put(oNew.AccountId, 1);
                    }
                    else {
                       //System.debug('FAILED Insert Opp with Account:  ' + oNew.Account);
                    }
                }
            }
        } 
        else {         
            Integer i = 0;
            for (Opportunity oNew : newOpportunity) {
                Opportunity oOld = oldOpportunity.get(i);
                if (oNew.Partner__c != null) {
                    if (oNew.Partner__c != oOld.Partner__c) {
                        //System.debug('Update Opp with Partner  ' + oNew.Partner__c);
                        updateToPartner.put(oNew.Partner__c, 1);
                    }
                } else if (oNew.AccountId != null) {
                    if (oNew.AccountId != oOld.AccountId) {
                        //System.debug('Update Opp with Account:  ' + oNew.AccountId);
                        updateToAccount.put(oNew.AccountId, 1);
                    }
                }
                i++;
            }
        }
        
        if (0 == updateToPartner.size() && 0 == updateToAccount.size()) {
            //System.debug('No account data');
            return;
        }
         
        Map<Id, Account> accountPartner = new Map<Id, Account>([SELECT Id, Name, OwnerId, StcZone_Territory__c FROM Account WHERE Id IN :updateToPartner.keySet()]);
        //System.debug('accountPartner size: ' + accountPartner.size());
        Map<Id, Account> accountAccount = new Map<Id, Account>([SELECT Id, Name, OwnerId, StcZone_Territory__c FROM Account WHERE Id IN :updateToAccount.keySet()]);
        //System.debug('accountAccount size: ' + accountAccount.size());
        
        Account workAcc;
        
        for (Opportunity oNew : newOpportunity) {
            if (accountPartner.containsKey(oNew.Partner__c)) {
                workAcc = accountPartner.get(oNew.Partner__c);
                if (workAcc!= null){ 
                    //System.debug('Set Opportuinity by Partner  OwnerId: ' + workAcc.OwnerId + '  Territory: ' + workAcc.StcZone_Territory__c);
                    if (workAcc.OwnerId != null) {
                        oNew.OwnerId = workAcc.OwnerId;
                    }
                	oNew.StcZone_Territory__c = workAcc.StcZone_Territory__c;
                }
            }
            else if (accountAccount.containsKey(oNew.AccountId)) {
                workAcc = accountAccount.get(oNew.AccountId);
                //System.debug('Set Opportuinity by Account  OwnerId: ' + workAcc.OwnerId + '  Territory: ' + workAcc.StcZone_Territory__c);
                if (workAcc.OwnerId != null) {
                    oNew.OwnerId = workAcc.OwnerId;
                }
                oNew.StcZone_Territory__c = workAcc.StcZone_Territory__c;
            }
            else {
                //System.debug('Did not find owning Account');
            }
        }
    }
    
    //
    // Determine the StcZone from the given parameters
    // NOTE: userType for Leads is a single value, but for accounts is a semicolon separated list (transactionType)
    //
    public StcZone__c findZone(Boolean isLead, String state, String country, String postalCode, Boolean hasPotential, String userType) {
        //System.debug('StcZoneManager.FindZone:  Country: ' + country + '  State: ' +  state + '  Postal Code: ' +  postalCode + '  Has Potential: ' +  hasPotential + '  User Type: ' +  userType); 
        
        if (String.isBlank(country)) { 
            country = '!'; 
        }
        else { 
            country = country.trim().toUpperCase(); 
        } 
        
        if (String.isBlank(state)) { 
            state = '!'; 
        }   
        else { 
            state = state.trim().toUpperCase(); 
        }
        
        if (String.isBlank(postalCode)) { 
            postalCode = '!'; 
        }
        else {
            postalCode = postalcode.trim().toUpperCase();
                
            if ('US'.equals(country) || 'DE'.equals(country)) {
                postalCode = postalCode.Left(5); 
            }
        } 
                
        for (StcZoneRule__c rule : rules) {
            //System.debug('Run Rule: ' + rule.Name);
            
            if (isLead) {
                if (!checkLeadUserType(rule, userType)) {
                    // Look at next rule
                    continue;
                }
            } 
            else {      
                if (!checkAccountUserType(rule, userType, hasPotential)) {
                    // Look at next rule
                    continue;
                }  
            }
            
            if (String.isBlank(rule.Countries__c) ||
                (checkCountry(rule, country) && checkState(rule, state) && checkPostalCode(rule, postalCode))) {
                if (zones.containsKey(rule.StcZone__c)) {
                    System.debug('StcZoneManager: Zone found by rule: ' + rule.Name); 
                    return zones.get(rule.StcZone__c);
                }
            }
        }
        
        //System.debug('StcZoneManager.FindZone: Zone not found');
        return null;
	}  
    
    //
    // If the Quarter Partner Level was Gold or Platinum OR the High Potential flag is set OR Promote Account flad is set, 
    // then account has potential!
    // 
    private Boolean hasPotential(Account a) {
        return ('Gold'.equals(a.Partner_Level_atQuarter__c)
             || 'Platinum'.equals(a.Partner_Level_atQuarter__c)
             || a.High_Potential__c
             || a.Promote_Account__c);
    }
    
    private Boolean checkLeadUserType(StcZoneRule__c rule, String userType) {
        if ('Leads Only'.equals(rule.Works_On__c) || 'Both Leads and Accounts'.equals(rule.Works_On__c) ) {
            if (String.IsBlank(rule.Lead_User_Types__c) || (!String.IsBlank(userType) && rule.Lead_User_Types__c.contains(userType))) {    
                return true;
            }        
        }
        
        //System.debug('User Type has Failed ' + userType + '      ' + rule.Account_User_Types__c);
        return false;
    }

    private Boolean checkAccountUserType(StcZoneRule__c rule, String userType, Boolean hasPotential) {
        if ('Accounts Only'.equals(rule.Works_On__c) || 'Both Leads and Accounts'.equals(rule.Works_On__c) ) {
            if (String.IsBlank(rule.Account_User_Types__c))  {
                return true;
            }
            
            if (!String.isBlank(userType)) {
                if (usingTransactionTypes) {
                    //System.debug('checkAccountUserType w/TT: ' + userType + ' in '+ rule.Account_User_Types__c);
                    String[] tTypes = userType.Split(';');
                    
                    for (String t : tTypes) {
                        if (rule.Account_User_Types__c.contains(t)) {
                            //System.debug('TRANSACTION TYPE FOUND');
                            return true;
                        } 
                    }
                }
                else {
                    //System.debug('checkAccountUserType: ' + userType + ' in '+ rule.Account_User_Types__c);
                    if (rule.Account_User_Types__c.contains(userType)) {
                        //System.debug('USER TYPE FOUND');
                        return true;
                    }
                }
            }
            
            // hasPotential is Partner Level is good enough or has been promoted
            if (rule.High_Potential__c && hasPotential) {
                //System.debug('Passed High Potential');
                return true;
            }
            else {                
                //System.debug('Failed High Potential');
            }
        }
        return false;
    }

    private Boolean checkCountry(StcZoneRule__c rule, String country) { 
        System.debug('checkCountry: Does ' + rule.Countries__c + ' contain ' + country + '?');
        return (!String.isBlank(rule.Countries__c) && rule.Countries__c.Contains(country));
    }
    
    private Boolean checkState(StcZoneRule__c rule, String state) {
        if (String.isBlank(rule.States__c) || rule.States__c.Contains(state)) {
            return true;
        }
        return false;
    }
    
    private Boolean checkPostalCode(StcZoneRule__c rule, String postalCode) {
        if (String.isBlank(rule.Postal_Codes__c)) {
            return true;
        }

        if (rule.Postal_Codes__c.StartsWith('BETWEEN')) {
            String bFrom = rule.Postal_Codes__c.SubstringAfter('BETWEEN').SubstringBefore(':').Trim();
            String bTo = rule.Postal_Codes__c.SubstringAfter(':').Trim();
            
            //System.debug('looking at ' + postalCode + '  BETWEEN' + bFrom + ' AND ' + bTo);
                
            if (0 <= postalCode.compareTo(bFrom) && postalCode.compareTo(bTo) <= 0) {
                //System.debug('Postal Found using BETWEEN ' + bFrom + ' AND ' + bTo); 
                return true;
            }                       
        }
        else if (rule.Postal_Codes__c.StartsWith('STARTSWITH')) {
            String[] splits = rule.Postal_Codes__c.SubstringAfter('STARTSWITH').Split(':');

            for (Integer i = 0; i < splits.size(); i++) {
                if (postalCode.startsWith(splits[i].Trim())) {
                    //System.debug('Postal Found using STARTSWITH: ' + rule.Postal_Codes__c);
                    return true;
                } 
            }                       
        }
        else {
            if (rule.Postal_Codes__c.Contains(postalCode)) {
                //System.debug('Postal Found: ' + postalCode + ' in List');
                return true;
            }   
        }
        
        return false;
    }
}