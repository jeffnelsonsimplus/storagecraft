/**
  \file         AccountTriggerHandler.cls
  \brief        This class will implement a trigger handler for the Account standard object
  \details      JIRA ticket(s): SSF-330
  \author       Matt Thompson-Moltzen
  \version      1.6
  \date         26 September 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.1       2017-08-09  Matt Thompson-Moltzen   Call new Accounts class on insert and update (SSF-89, SSF-458).
  1.2       2017-08-17  Ken Ratzlaff (Simplus)  Not documented.
  1.3       2017-08-22  Matt Thompson-Moltzen   Added disabled trigger functionality (SSF-528).
  1.4       2017-08-30  Matt Thompson-Moltzen   Remove call to AccountAgreementManager (SSF-584).
  1.5       2017-09-12  Loch MacLeod            Added call to PartnerLevelManager (SSF-545/SSF-621).
  1.6       2017-09-26  Matt Thompson-Moltzen   Reverse the order of the setTypes() and setZone() calls (SSF-458).
*/
public with sharing class AccountTriggerHandler implements TriggerBulkInterface
{
  //
  // variables
  //
  private Accounts accts = new Accounts();                                      // base class for Account SObject

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
  public AccountTriggerHandler()
  {
  }

  //
  // member functions/methods - define all methods from the interface even if not used
  //
  public Boolean isDisabled()
  {
    triggerDisablement__c td = triggerDisablement__c.getInstance('accountTrigger');

    if      (td == null)               { return isDisabled; }
    else if (td.isDisabled__c == true) { return true; }
    else                               { return isDisabled; }
  }

  public void preBeforeOperations()
  {
  }

  public void beforeInsert(List<SObject> newObjects)
  {
    Addresses      addrs   = new Addresses();
    StcZoneManager manager = new StcZoneManager();

    accts.setTypes(null, (List<Account>)newObjects);

//     addrs.validateAccountAddress((List<Account>)newObjects, true);
    manager.setZone((List<Account>)null, (List<Account>)newObjects);

    PartnerLevelManager.setPartnerLevel((List<Account>)newObjects);
  }

  public void beforeUpdate(List<SObject> oldObjects, List<SObject> newObjects)
  {
    Addresses      addrs   = new Addresses();
    StcZoneManager manager = new StcZoneManager();

    accts.setTypes((List<Account>)oldObjects, (List<Account>)newObjects);

//     addrs.validateAccountAddress((List<Account>)newObjects, true);
    manager.setZone((List<Account>)oldObjects, (List<Account>)newObjects);

    PartnerLevelManager.setPartnerLevel((List<Account>)newObjects);
  }

  public void beforeDelete(List<SObject> oldObjects)
  {
  }

  public void preAfterOperations()
  {
  }

  public void afterInsert(List<SObject> newObjects)
  {
    accts.checkAccountNumber(null, (List<Account>)newObjects);

    DomainManager.AssignDomainToAccount((List<Account>)newObjects);
  }

  public void afterUpdate(List<SObject> oldObjects, List<SObject> newObjects)
  {
    accts.checkAccountNumber((List<Account>)oldObjects, (List<Account>)newObjects);
  }

  public void afterDelete(List<SObject> oldObjects)
  {
  }

  public void postOperations()
  {
  }

}