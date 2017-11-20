/**
  \file         LeadTriggerHandler.cls
  \brief        This class will implement a trigger handler for the Lead standard object
  \details      JIRA ticket(s): SSF-287, SSF-330
  \author       Matt Thompson-Moltzen
  \version      1.4
  \date         22 August 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.1       2017-07-24  Matt Thompson-Moltzen   Updated for new StcZoneManager processing.
  1.2       2017-08-08  Loch MacLeod            SSF-105 Corrections to each of the Lead Campaigns.
  1.3       2017-08-22  Matt Thompson-Moltzen   Added disabled trigger functionality (SSF-528).
  1.4       2017-09-28  Loch MacLeod            SSF-550  Lead Assignment error
  1.5       2017-10-27  Klarizze Masanque       Commented line 55 in relation to SSF 573,572 and 618 Clean issue
*/
public with sharing class LeadTriggerHandler implements TriggerBulkInterface
{
  //
  //variables
  //
  private List<Lead> leadstoAssignDomain      = new List<Lead>();
  private List<Lead> leadsToConvertToContacts = new List<Lead>();
  private List<Lead> checkForExistingContacts = new List<Lead>();

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
  // constructor
  //
  public LeadTriggerHandler()
  {
  }

  public Boolean isDisabled()
  {
    triggerDisablement__c td = triggerDisablement__c.getInstance('leadTrigger');

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
    CampaignManager.setLastCampaign((List<Lead>)null, (List<Lead>)newObjects);

    Addresses addrs = new Addresses();
//    addrs.validateLeadAddress((List<Lead>)newObjects, true);

    StcZoneManager manager = new StcZoneManager();
    manager.setZone((List<Lead>)null, (List<Lead>)newObjects);

    for (Lead l : (List<Lead>)newObjects) {
      if (l.email != null && l.Additional_Domain__c == null) {
        leadsToAssignDomain.add(l);
      }
    }
  }

  public void beforeUpdate(List<SObject> oldObjects, List<SObject> newObjects)
  {
    CampaignManager.setLastCampaign((List<Lead>)oldObjects, (List<Lead>)newObjects);
    //LeadConvertUtility.confirmCleaned(oldObjects, newObjects);
    //Klarizze commented line 55 in relation to SSF 573,572 and 618 Clean issue 10272018

    Addresses addrs = new Addresses();
//    addrs.validateLeadAddress((List<Lead>)newObjects, true);

    StcZoneManager manager = new StcZoneManager();
    manager.setZone((List<Lead>)oldObjects, (List<Lead>)newObjects);
      
    Integer i = 0;
    for (Lead l : (List<Lead>)newObjects) {
      String oldEmail = (String)oldObjects.get(i).get('email');

      if (l.email != null && (l.Additional_Domain__c == null || l.email != oldEmail)) {
        leadsToAssignDomain.add(l);
      }
      i++;
    }
  }

  public void beforeDelete(List<SObject> oldObjects)
  {
  }

  public void preAfterOperations() {
  }
  public void afterInsert(List<SObject> newObjects)
  {
    Map<Id, Lead> leads = new Map<Id, Lead>();

    for (Lead l : (List<Lead>)newObjects) {
      if (l.DomainAutoConvertToContact__c && l.leadsource != 'Deal Registration') {
        leadsToConvertToContacts.add(l);
      }
      else {
        checkForExistingContacts.add(l);
      }

      leads.put(l.Id, l);   // populate the map
    }

    LeadS2SHandler handlerInstance = new LeadS2SHandler();
    handlerInstance.insertedLeads(leads);
  }

  public void afterUpdate(List<SObject> oldObjects, List<SObject> newObjects)
  {
    for (Lead l : (List<Lead>)newObjects) {
      if (l.DomainAutoConvertToContact__c && l.leadsource != 'Deal Registration') {
        leadsToConvertToContacts.add(l);
      }
    }
  }

  public void afterDelete(List<SObject> oldObjects)
  {
  }

  public void postOperations()
  {
    if (leadsToAssignDomain.isEmpty() == false) {
      DomainManager.assignDomainToLead(leadsToAssignDomain);
    }

    if (leadsToConvertToContacts.isEmpty() == false) {
      DomainManager.convertLeadsToContacts(leadsToConvertToContacts);
    }

    if (checkForExistingContacts.isEmpty() == false) {
      Map<String, Id> emailToLeadIdMap = new Map<String, Id>();

      for (Lead l : checkForExistingContacts) {
        if (l.email != null && !emailToLeadIdMap.containsKey(l.email)) {
          emailToLeadIdMap.put(l.email, l.Id);
        }
      }

      if (!emailToLeadIdMap.isEmpty()) {
        List<Task>    tasks    = new List<Task>();
        List<Contact> contacts = [SELECT Id, email FROM Contact WHERE email in : emailToLeadIdMap.keyset()];

        for (Contact c : contacts) {
          Task t = new Task();

          t.WhoId = c.Id;
          t.Subject = 'Lead submitted with email: ' + c.email + 'id: ' + emailToLeadIdMap.get(c.email);
          t.NotifyAccountOwner__c = true;
          tasks.add(t);
        }

        if (!tasks.isEmpty()) {
          insert tasks;
        }
      }
    }
  }

}