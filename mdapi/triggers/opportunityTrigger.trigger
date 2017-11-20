/**
  \file         opportunityTrigger.tgr
  \brief        This trigger on the Opportunity object will initiate after an Opportunity is inserted/updated.
  \details      Sets the owner and territory for the Opportunity.
  \author       Loch MacLeod
  \version      1.6
  \date         25 July 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
*/
trigger opportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete)
{
    try {
        TriggerBulkInterface handler = new OpportunityTriggerHandler();
        TriggerFactory.invokeHandler(Opportunity.SObjectType, handler);
    }
    catch (TriggerException e) {
        System.debug(LoggingLevel.ERROR, e.getMessage());
    }
}