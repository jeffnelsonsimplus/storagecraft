/**
  \file         TriggerBulkInterface.cls
  \brief        Defines a bulkification Trigger interface.
  \details      This interface contains the method signatures each handler must implement to enforce best practices such
			     			as bulkification of triggers and avoiding multiple triggers over the same object.
     						JIRA ticket(s): SSF-330

  \author       Matt Thompson-Moltzen
  \version      1.1
  \date         22 August 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.1				2017-08-22	Matt Thompson-Moltzen		Added isDisabled() member function (SSF-528).
*/
public interface TriggerBulkInterface
{
  //
  // This method will determine if the trigger has been disabled.
  //
  Boolean isDisabled();

	//
  // This method will be called prior to the execution of a BEFORE trigger to cache any required data into lists/maps.
  // This so called trigger 'bulkification' is to avoid bad practices such as repetitive SOQL queries that can hit
  // governor limits.
  //
  void preBeforeOperations();

  //
  // This method will be called with an object list to be inserted during a BEFORE trigger.
  //
  void beforeInsert(List<SObject> newObjects);

  //
  // This method will be called with object lists to be updated during a BEFORE trigger.
  //
  void beforeUpdate(List<SObject> oldObjects, List<SObject> newObjects);

  //
  // This method will be called with an object list to be deleted during a BEFORE trigger.
  //
  void beforeDelete(List<SObject> oldObjects);

	//
  // This method will be called prior to the execution of an AFTER trigger to cache any required data into lists/maps.
  // This so called trigger 'bulkification' is to avoid bad practices such as repetitive SOQL queries that can hit
  // governor limits.
  //
  void preAfterOperations();

  //
  // This method will be called with an object list to be inserted during an AFTER trigger.
  //
  void afterInsert(List<SObject> newObjects);

  //
  // This method will be called with object lists to be updated during an AFTER trigger.
  //
  void afterUpdate(List<SObject> oldObjects, List<SObject> newObjects);

  //
  // This method will be called with an object list to be deleted during an AFTER trigger.
  //
  void afterDelete(List<SObject> oldObjects);

  //
  // This method will be called once all records have been processed by the trigger to perform any final operations
  // required such as the insertion or updating of other records.
  //
  void postOperations();
}