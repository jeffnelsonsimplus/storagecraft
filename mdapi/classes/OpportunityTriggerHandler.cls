/**
  \file         OpportunityTriggerHandler.cls
  \brief        Changes to Opportunities run through this code
  \details
  \author       Loch MacLeod
  \version      1.2
  \date         22 August 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.1       2017-08-08  Loch MacLeod            Corrections to each of the Opportunities Campaigns
  1.2       2017-08-22  Matt Thompson-Moltzen   Added disabled trigger functionality (SSF-528).
*/
public with sharing class OpportunityTriggerHandler implements TriggerBulkInterface
{
  //
  // variables
  //
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
  public OpportunityTriggerHandler()
  {
  }

  //
  // member functions/methods - define all methods from the interface even if not used
  //
  public Boolean isDisabled()
  {
    triggerDisablement__c td = triggerDisablement__c.getInstance('opportunityTrigger');

    if      (td == null)               { return isDisabled; }
    else if (td.isDisabled__c == true) { return true; }
    else                               { return isDisabled; }
  }

  public void preBeforeOperations()
  {
  }

  public void beforeInsert(List<SObject> newObjects)
  {
    StcZoneManager zoneManager = new StcZoneManager();

    zoneManager.setZone((List<Opportunity>) null, (List<Opportunity>)newObjects);

    CampaignManager.setOpportunitySourceCampaign((List<Opportunity>) null, (List<Opportunity>)newObjects);
  }

  public void beforeUpdate(List<SObject> oldObjects, List<SObject> newObjects)
  {
    StcZoneManager zoneManager = new StcZoneManager();

    zoneManager.setZone((List<Opportunity>)oldObjects, (List<Opportunity>)newObjects);

    CampaignManager.setOpportunitySourceCampaign((List<Opportunity>) oldObjects, (List<Opportunity>)newObjects);
  }

  public void beforeDelete(List<SObject> oldObjects)
  {
  }

  public void preAfterOperations()
  {
  }

  public void afterInsert(List<SObject> newObjects)
  {
  }

  public void afterUpdate(List<SObject> oldObjects, List<SObject> newObjects)
  {
  }

  public void afterDelete(List<SObject> oldObjects)
  {
  }

  public void postOperations()
  {
  }

}