/**
  \file         AgreementTriggerHandler.cls
  \brief        This class will implement a trigger handler for the Agreement__c custom object
  \details      JIRA ticket(s): SSF-115
  \author       Matt Thompson-Moltzen
  \version      1.5
  \date         30 August 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.1     2017-07-28  Matt Thompson-Moltzen     Update the user type on adding/deleting an agreement (SF-399).
  1.2     2017-08-14  Matt Thompson-Moltzen     Call the Accounts class setTransactionTypes() member function after inserting/updating/deleting an agreement (SSF-399).
  1.3     2017-08-22  Matt Thompson-Moltzen     Added disabled trigger functionality (SSF-528).
  1.4     2017-08-24  Matt Thompson-Moltzen     Agreement type 'VAR' is now deprecated and replaced by 'Reseller' (SSF-533).
  1.5     2017-08-30  Matt Thompson-Moltzen     Changed references to User_Type__c to transactionTypesAsText__c (SSF-458).
  1.6     2017-09-11  Matt Thompson-Moltzen     Stop generating cases when a contract (agreement) is signed (SSF-609).
*/
public with sharing class AgreementTriggerHandler implements TriggerSingularInterface
{
  //
  // variables
  //
  private Set<Id> acctIds = new Set<Id>();

  private static Boolean isDisabled = false;

  public static void disableTrigger()
  {
    isDisabled = true;
  }

  public static void enableTrigger()
  {
    isDisabled = false;
  }

	//
  // constructor
  //
  public AgreementTriggerHandler()
  {
  }

  public Boolean isDisabled()
  {
    triggerDisablement__c td = triggerDisablement__c.getInstance('agreementTrigger');

    if      (td == null)               { return isDisabled; }
    else if (td.isDisabled__c == true) { return true; }
    else                               { return isDisabled; }
  }

  //
 	// member functions/methods - define all methods from the interface even if not used
  //
  public void preBeforeOperations()
  {
  }

  public void beforeInsert(SObject newObject)
  {
  }

  public void beforeUpdate(SObject oldObject, SObject newObject)
  {
  }

  public void beforeDelete(SObject oldObject)
  {
  }

  public void preAfterOperations()
  {
  }

  public void afterInsert(SObject newObject)
  {
  	Agreement__c agt = (Agreement__c)newObject;
/*
  	Integer nAgreements = [SELECT COUNT() FROM Agreement__c WHERE (Account__c = :agt.Account__c) AND (Type__c IN ('Cloud', 'MSP', 'Reseller', 'VAR'))];

    if (nAgreements == 1) {                                                     // this is the first agreement
      Agreements agts = new Agreements();

      agts.sendEmail(agt);
      agts.createCase(agt);
    }
*/
    acctIds.add(agt.Account__c);
  }

  public void afterUpdate(SObject oldObject, SObject newObject)
  {
    Agreement__c agt = (Agreement__c)newObject;

    acctIds.add(agt.Account__c);
  }

  public void afterDelete(SObject oldObject)
  {
    Agreement__c agt = (Agreement__c)oldObject;

    acctIds.add(agt.Account__c);
  }

  public void postOperations()
  {
    //
    // update all Account objects that had an Agreement inserted/updated/deleted
    //
    List<Account> accts = [SELECT Id, transactionTypes__c FROM Account WHERE (Id IN :acctIds)];

    if (accts.isEmpty() == false) {
      try {
        update accts;
      }
      catch (DMLException e) {
        System.debug(LoggingLevel.ERROR, 'AgreementTriggerHandler::postOperations() failed: unable to update Account objects: '  + e.getMessage());
      }
    }
  }

}