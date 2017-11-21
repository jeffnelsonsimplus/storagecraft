/**
  \file         BatchSSf458UpdateAccounts.cls
  \brief        This class will initialise the transactionTypes__c from User_Types__c field.
  \details      SSF-458
  \author       Matt Thompson-Moltzen
  \version      1.0
  \date         24 August 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
*/
global class BatchSsf458UpdateAccounts implements Database.Batchable<SObject>
{
	global Database.QueryLocator start(Database.BatchableContext bc)
	{
		String query = 'SELECT Id, User_Type__c, transactionTypes__c, transactionTypesAsText__c, (SELECT Id, Account__c, Type__c, Status__c FROM Agreements__r) FROM Account';

		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext bc, List<Account> accts)
	{
    Set<String> agreementTypes = new Set<String>();

    agreementTypes.add('Distribution Partner');
    agreementTypes.add('Managed Service Provider (MSP)');
    agreementTypes.add('Original Equipment Manufacturer (OEM)');
    agreementTypes.add('Value Added Reseller (VAR)');

    Set<String> enterpriseTyps = new Set<String>();

    enterpriseTyps.add('Business User');
    enterpriseTyps.add('Trial User');

		for (Account acct : accts) {
      Set<String> typs = new Set<String>();

  		if (acct.transactionTypes__c == null) {
    		if 			(acct.User_Type__c == null)														{ typs.add('Other'); }
    		else if (acct.User_Type__c == 'Both MSP and VAR') 						{ typs.add('Channel Partner'); } // has one of the agreement types potentially
    		else if (agreementTypes.contains(acct.User_Type__c) == false) { typs.add(acct.User_Type__c); }
    		else 																													{ typs.add('Channel Partner'); } // has one of the agreement types potentially

        Integer nMsp 				 	= 0;
    		Integer nOem 				 	= 0;
    		Integer nVar 				 	= 0;
    		Integer nDistribution = 0;

        for (Agreement__c agt : acct.Agreements__r) {
          if (agt.Status__c != 'Inactive' && agt.Status__c != 'Terminated' && agt.Status__c != 'Expired') {
            if      (agt.Type__c == 'Cloud')        { nMsp++; }
            else if (agt.Type__c == 'MSP')          { nMsp++; }
            else if (agt.Type__c == 'Master MSP')   { nMsp++; }
            else if (agt.Type__c == 'OEM')          { nOem++; }
            else if (agt.Type__c == 'Reseller')     { nVar++; }                   // SSF-533
            else if (agt.Type__c == 'VAR')          { nVar++; }                   // deprecated in SSF-533
            else if (agt.Type__c == 'Distribution') { nDistribution++; }
          }
        }

    		if (nMsp > 0) 				 { typs.add('Channel Partner'); typs.add('Managed Service Provider (MSP)'); }
    		if (nOem > 0) 				 { typs.add('Channel Partner'); typs.add('Original Equipment Manufacturer (OEM)'); }
    		if (nVar > 0) 				 { typs.add('Channel Partner'); typs.add('Value Added Reseller (VAR)'); }
    		if (nDistribution > 0) { typs.add('Channel Partner'); typs.add('Distribution Partner'); }

        if (typs.contains('Channel Partner')) { typs.removeAll(enterpriseTyps); } // remove Enterprise types to avoid validation issues

        List<String> l = new List<String>(typs);

    		String s = String.join(l, ';');

    		acct.transactionTypes__c       = s;
        acct.transactionTypesAsText__c = s;
  		}
    }

    AccountTriggerHandler.disableTrigger();

		try {
			update accts;
		}
		catch (DmlException e) {
			System.debug(LoggingLevel.ERROR, 'BatchSsf458UpdateAccounts::execute() exception: ' + e.getMessage());
		}

    AccountTriggerHandler.enableTrigger();
	}

	global void finish(Database.BatchableContext bc)
	{
		AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :bc.getJobId()];

		System.debug(LoggingLevel.INFO, 'BatchSsf458UpdateAccounts::finish() Status=' + a.Status + ' TotalJobItems=' + a.TotalJobItems + ' JobItemsProcessed=' + a.JobItemsProcessed + ' NumberOfErrors= ' + a.NumberOfErrors);
	}

}