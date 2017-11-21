/**
  \file         accountTrigger.tgr
  \brief        This trigger on the Account object will initiate after an Account is inserted/updated.
  \details      Sets and updates Partner Level and types for changing accounts, and sets Domain for the account.
  \author       Loch MacLeod
  \version      1.6
  \date         7 July 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
*/
trigger accountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete)
{
	try {
		TriggerBulkInterface handler = new AccountTriggerHandler();
		
		TriggerFactory.invokeHandler(Account.SObjectType, handler);
	}
	catch (TriggerException e) {
		System.debug(LoggingLevel.ERROR, e.getMessage());
	}
}