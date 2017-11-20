/**
  \file         ContactTriggerHandler.cls
  \brief        This class will implement a trigger handler for the Contact standard object
  \details      JIRA ticket(s): SSF-379
  \author       Matt Thompson-Moltzen
  \version      1.2
  \date         22 August 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.1       2017-08-08  Loch MacLeod            SSF-105 Corrections to each of the Contact Campaigns
  1.2       2017-08-22  Matt Thompson-Moltzen   Added disabled trigger functionality (SSF-528).
*/
public with sharing class ContactTriggerHandler implements TriggerBulkInterface
{
  //
  // variables
  //
  public static Boolean isDisabled = false;


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
  public ContactTriggerHandler()
  {
  }

  public Boolean isDisabled()
  {
    triggerDisablement__c td = triggerDisablement__c.getInstance('contactTrigger');

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

  public void beforeInsert(List<SObject> newObjects)
  {
    Addresses addrs = new Addresses();

//    addrs.validateContactAddress((List<Contact>)newObjects, true);

    CampaignManager.onChangeLastCampaign((List<Contact>)null, (List<Contact>)newObjects);
  }

  public void beforeUpdate(List<SObject> oldObjects, List<SObject> newObjects)
  {
    Addresses addrs = new Addresses();

//    addrs.validateContactAddress((List<Contact>)newObjects, true);

    CampaignManager.onChangeLastCampaign((List<Contact>)oldObjects, (List<Contact>)newObjects);
  }

  public void beforeDelete(List<SObject> oldObjects)
  {
  }

  public void preAfterOperations()
  {
  }

  public void afterInsert(List<SObject> newObjects)
  {
    AccountPrimaryContact.setValue((List<Contact>)newObjects);
    Contacts.mergeDupContacts((List<Contact>)newObjects);
    ContactOrphanedHandler.orphanedContact((List<Contact>)newObjects);
  }

  public void afterUpdate(List<SObject> oldObjects, List<SObject> newObjects)
  {
    AccountPrimaryContact.confirmStillActive((List<Contact>)oldObjects, (List<Contact>)newObjects);
    AcademyCertificateManager.updateAccount((List<Contact>)oldObjects, (List<Contact>)newObjects);
    ContactOrphanedHandler.orphanedContact((List<Contact>)newObjects);
  }

  public void afterDelete(List<SObject> oldObjects)
  {
  }

  public void postOperations()
  {
  }

}