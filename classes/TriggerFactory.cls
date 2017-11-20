/**
  \file         TriggerFactory.cls
  \brief        This class will implement a trigger factory that will select the correct handler for an object and execute the methods defined by the interface
  \details      JIRA ticket(s): SSF-330
  \author       Matt Thompson-Moltzen
  \version      1.1
  \date         22 August 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.1               2017-08-22  Matt Thompson-Moltzen       Added check for disabled trigger (SSF-528).
*/
public with sharing class TriggerFactory
{
  //
  // constructor
  //
  public TriggerFactory()
  {
  }

  //
  // member functions/methods
  //
  public static void invokeHandler(Schema.SObjectType soType, TriggerBulkInterface handler)
  {
    if (handler == null) {
      throw new TriggerException('no trigger handler registered for the SObject type: ' + soType);
    }

    if (handler.isDisabled() == true) {
      System.debug(LoggingLevel.WARN, 'trigger handler has been disabled for the SObject type: ' + soType);

      return;
    }

    executeBulk(handler);
  }

  public static void invokeHandler(Schema.SObjectType soType, TriggerSingularInterface handler)
  {
    if (handler == null) {
      throw new TriggerException('no trigger handler registered for the SObject type: ' + soType);
    }

    if (handler.isDisabled() == true) {
      System.debug(LoggingLevel.WARN, 'trigger handler has been disabled for the SObject type: ' + soType);

      return;
    }

    executeSingular(handler);
  }

  private static void executeBulk(TriggerBulkInterface handler)
  {
    if (Trigger.IsBefore) {
      handler.preBeforeOperations();

      if      (Trigger.isInsert) { handler.beforeInsert(Trigger.new); }
      else if (Trigger.isUpdate) { handler.beforeUpdate(Trigger.old, Trigger.new); }
      else if (Trigger.isDelete) { handler.beforeDelete(Trigger.old); }
    }
    else {
      handler.preAfterOperations();

      if      (Trigger.isInsert) { handler.afterInsert(Trigger.new); }
      else if (Trigger.isUpdate) { handler.afterUpdate(Trigger.old, Trigger.new); }
      else if (Trigger.isDelete) { handler.afterDelete(Trigger.old); }
    }

    handler.postOperations();
  }

  private static void executeSingular(TriggerSingularInterface handler)
  {
    if (Trigger.IsBefore) {
      handler.preBeforeOperations();

      if      (Trigger.isInsert) {
        for (SObject obj : Trigger.new) {
          handler.beforeInsert(obj);
        }
      }
      else if (Trigger.isUpdate) {
        for (SObject obj : Trigger.new) {
          handler.beforeUpdate(Trigger.oldMap.get(obj.Id), obj);
        }
      }
      else if (Trigger.isDelete) {
        for (SObject obj : Trigger.old) {
          handler.beforeDelete(obj);
        }
      }
    }
    else {
      handler.preAfterOperations();

      if      (Trigger.isInsert) {
        for (SObject obj : Trigger.new) {
          handler.afterInsert(obj);
        }
      }
      else if (Trigger.isUpdate) {
        for (SObject obj : Trigger.new) {
          handler.afterUpdate(Trigger.oldMap.get(obj.Id), obj);
        }
      }
      else if (Trigger.isDelete) {
        for (SObject obj : Trigger.old) {
          handler.afterDelete(obj);
        }
      }
    }

    handler.postOperations();
  }

}