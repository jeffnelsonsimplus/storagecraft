/**
  \file         ContactTrigger.tgr
  \brief        This trigger on the Contact object will initiate after a Contact is inserted/updated.
  \details      Implements Contact related processes on insertion and updates.
  \author       Loch MacLeod
  \version      1.3
  \date         31 July 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.1       2017-07-04  Matt Thompson-Moltzen   Added address validation to before insert
  1.2       2017-07-19  Matt Thompson-Moltzen   Regressed code to match production
  1.3       2017-07-31  Matt Thompson-Moltzen   Changed call to ContactTriggerHandler.mergeDupContacts() to Contacts.mergeDupContacts().
                                                Removed first argument 'Trigger.newMap' from call to Contacts.mergeDupContacts().
                                                Updated for new trigger framework (SSF-379).
*/
trigger contactTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete)
{

  try {
    TriggerBulkInterface handler = new ContactTriggerHandler();

    TriggerFactory.invokeHandler(Contact.SObjectType, handler);
  }
  catch (TriggerException e) {
    System.debug(LoggingLevel.ERROR, e.getMessage());
  }
}