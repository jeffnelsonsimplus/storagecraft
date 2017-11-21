/**
  \file         TaskTriggerHandler.cls
  \brief        This class will implement a trigger handler for the Task object
  \details      JIRA ticket(s): SSF-102
  \author       Matt Thompson-Moltzen
  \version      1.3
  \date         22 August 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.1       2017-08-22  Matt Thompson-Moltzen   Added disabled trigger functionality (SSF-528).
  1.2       2017-09-11  Loch MacLeod            SSF-577 First Completed task on a Leads sets the First_Touch_On__c Field
  1.3       2017-09-29  Loch MacLeod            SSF-668 Fix for when Competed_On__c is null
*/
public with sharing class TaskTriggerHandler implements TriggerSingularInterface
{
  //
  // variables
  //
  private Map<Id, Task> tasks = new Map<Id, Task>();

  private static Boolean isDisabled = false;
  // Leads with completed Tasks
  private Map<Id, DateTime> taskCompletedLeads = new Map<Id, DateTime>();
    
  private Id idMarketo = null;

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
  public TaskTriggerHandler()
  {
  }

  public Boolean isDisabled()
  {
    triggerDisablement__c td = triggerDisablement__c.getInstance('taskTrigger');

    if      (td == null)               { return isDisabled; }
    else if (td.isDisabled__c == true) { return true; }
    else                               { return isDisabled; }
  }

  //
 	// member functions/methods - define all methods from the interface even if not used
  //
  public void preBeforeOperations()
  {
  }

  public void beforeInsert(SObject newObject)
  {
  	Task t = (Task)newObject;

    String description = '';

    if (t.Description != null) { description = t.Description; }

    if ('Email'.equals(t.Type)) {
      Integer pos = description.indexOf('Body:');

      if (pos != -1) {
      	description = description.substring(pos + 5);
        description = description.trim();
      }
    }

    if (description.length() > 100) { t.Comments_Start__c = description.left(97) + '...'; }
    else                            { t.Comments_Start__c = description; }

    if ('Completed'.equals(t.Status)) { t.Completed_On__c = System.now(); }
    else                              { t.Completed_On__c = null; }
  }

  public void beforeUpdate(SObject oldObject, SObject newObject)
  {
  	Task t = (Task)newObject;
  	Task o = (Task)oldObject;

    String description = '';

    if (t.Description != null) { description = t.Description; }

    if ('Email'.equals(t.Type)) {
    	Integer pos = description.indexOf('Body:');

      if (pos != -1) {
      	description = description.substring(pos + 5);
        description = description.trim();
      }
    }

    if (description.length() > 100) { t.Comments_Start__c = description.left(97) + '...'; }
    else                            { t.Comments_Start__c = description; }

    if (t.Status != o.Status) {
   	  if ('Completed'.equals(t.Status)) { t.Completed_On__c = System.now(); }
      else                              { t.Completed_On__c = null; }
    }
  }

  public void beforeDelete(SObject oldObject)
  {
  }

  public void preAfterOperations()
  {
  }

  public void afterInsert(SObject newObject)
  {
  	Task t = (Task)newObject;

  	tasks.put(t.Id, t);
      
    if ('Completed'.equals(t.Status) && t.WhoId != null && String.valueOf(t.WhoId).startsWith('00Q') && !'Marketo Sync'.equals(UserInfo.getName())) {
      // Task completed on a Lead, not by Marketo
      taskCompletedLeads.put(t.WhoId, t.Completed_On__c);
    }
  }

  public void afterUpdate(SObject oldObject, SObject newObject)
  {
    Task t = (Task)newObject;
  	Task o = (Task)oldObject;

    if (t.WhoId != null) {
      if (t.WhoId != null && String.valueOf(t.WhoId).startsWith('00Q')) {
        tasks.put(t.Id, t);
      }
                
      if (o.Status != t.Status && 'Completed'.equals(t.Status) && t.WhoId != null && String.valueOf(t.WhoId).startsWith('00Q') && !'Marketo Sync'.equals(UserInfo.getName())) {
        // Task completed on a Lead, not by Marketo
        taskCompletedLeads.put(t.WhoId, t.Completed_On__c);
      }
    }
  }

  public void afterDelete(SObject oldObject)
  {
  }

  public void postOperations()
  {
    if (tasks.isEmpty() == false) {
	  TaskS2SHandler handlerInstance = new TaskS2SHandler();

      handlerInstance.insertedTasks(tasks);
    }    
      
    if (!taskCompletedLeads.isEmpty()) {
      System.debug('Updating leads in TaskTriggerHandler.postOperations');
        
      List<Lead> updateLeads = [SELECT Id, CreatedDate, (SELECT Id, Completed_On__c FROM Tasks WHERE Status='Completed' AND IsDeleted = false AND Completed_On__c != null ORDER BY Id LIMIT 1)
                                FROM Lead 
                                WHERE ID in :taskCompletedLeads.keySet() AND (Time_to_First_Touch__c = null OR Time_to_First_Touch__c = '')];
      for (Lead l : updateLeads) {
          for (Task t : l.Tasks) {
            Long timespan = (t.Completed_On__c.getTime() - l.CreatedDate.getTime()) / (60*1000);
              Long temp = timespan;
              
            System.debug('timespan = ' + timespan);
              
            Integer days = (timespan/(24*60)).intValue();
            timespan = timespan - (days*(24*60));
            Integer hours = (timespan/60).intValue();
            Integer minutes = (timespan - (60*hours)).intValue();

            l.Time_to_First_Touch__c = String.valueOf(days) + ' Day(s) ' + String.valueOf(hours) + ' Hour(s) ' + String.valueOf(minutes) + ' Minute(s)  - ' + String.valueOf(temp);
          }
      }
      update updateLeads;
    }
  }
}