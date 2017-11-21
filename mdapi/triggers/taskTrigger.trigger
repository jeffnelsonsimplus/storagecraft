/**
  \file         
  \brief        This trigger on the Task object will initiate after a Task is inserted/updated.
  \details      JIRA ticket(s): refactored
  \author       Matt Thompson-Moltzen
  \version      1.0
  \date         11 July 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
*/
trigger taskTrigger on Task (before insert, before update, before delete, after insert, after update, after delete) {	
	try {
		TriggerSingularInterface handler = new TaskTriggerHandler();
		
		TriggerFactory.invokeHandler(Task.SObjectType, handler);
	}
	catch (TriggerException e) {
		System.debug(LoggingLevel.ERROR, e.getMessage());
	}
}