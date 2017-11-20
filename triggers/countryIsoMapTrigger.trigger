/**
  \file         countryIsoMapTrigger.tgr
  \brief        This trigger on the Country ISO Map object will initiate before a country is inserted/updated.
  \details      JIRA ticket(s): SSF-62, SSF-65
  \author       Matt Thompson-Moltzen
  \version      1.3
  \date         5 July 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
*/

trigger countryIsoMapTrigger on Country_ISO_Map__c (before insert, before update, before delete, after insert, after update, after delete) {
	try {
		TriggerSingularInterface handler = new CountryIsoMapTriggerHandler();
		
		TriggerFactory.invokeHandler(Country_ISO_Map__c.SObjectType, handler);
	}
	catch (TriggerException e) {
		System.debug(LoggingLevel.ERROR, e.getMessage());
	}
}