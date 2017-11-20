/**
  \file         
  \brief        This trigger on the Agreement object will initiate after an Agreement has been inserted
  \details      JIRA ticket(s): SSF-115
  \author       Matt Thompson-Moltzen
  \version      1.2
  \date         5 July 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
*/
trigger agreementTrigger on Agreement__c (before insert, before update, before delete, after insert, after update, after delete) {	
	try {
		TriggerSingularInterface handler = new AgreementTriggerHandler();
		
		TriggerFactory.invokeHandler(Agreement__c.SObjectType, handler);
	}
	catch (TriggerException e) {
		System.debug(LoggingLevel.ERROR, e.getMessage());
	}
}