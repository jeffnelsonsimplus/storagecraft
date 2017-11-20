/**
  \file         LeadTrigger.tgr
  \brief        This trigger on the Lead object will initiate after a Lead is inserted/updated.
  \details      Implements Lead related processes on insertion and updates.
  \author       Loch MacLeod
  \version      1.2
  \date         10 July 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
*/
trigger leadTrigger on Lead (before insert, before update, before delete, after insert, after update, after delete)
{
	try {
		TriggerBulkInterface handler = new LeadTriggerHandler();
		
		TriggerFactory.invokeHandler(Lead.SObjectType, handler);
	}
	catch (TriggerException e) {
		System.debug(LoggingLevel.ERROR, e.getMessage());
	}
}