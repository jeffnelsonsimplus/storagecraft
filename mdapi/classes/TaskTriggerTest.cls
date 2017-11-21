/**
  \file         TaskTriggerHandler.cls
  \brief        This class will implement a trigger handler for the Task object
  \details      JIRA ticket(s): SSF-102
  \author       Matt Thompson-Moltzen
  \version      1.2
  \date         22 August 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.1       2017-09-13  Loch MacLeod            SSF-577 First Completed task on a Leads sets the First_Touch_On__c Field
  1.2       2017-09-29  Loch MacLeod            SSF-668 Fix for when Competed_On__c is null
*/
@isTest
private class TaskTriggerTest {   
    @testSetup
    public static void setup() {   
        Account acc = new Account(Name = 'Task Trigger Account');
        insert acc;
    
        Contact testContact = new Contact(
            FirstName = 'Contact',
            LastName = 'TriggerTest',
            AccountId = acc.Id,
            Title = 'Test Title',
            MobilePhone = '1111111111');
        insert testContact;
        
        Lead testLead = new Lead(
            FirstName = 'Lead',
            LastName = 'TaskTriggerTest',
            Company = 'Task Company',
            MobilePhone = '111 111-1111');
        insert testLead;     
        
        Lead testLead2 = new Lead(
            FirstName = 'Lead',
            LastName = 'TaskTriggerTest2',
            Company = 'Task Company',
            MobilePhone = '111 111-1111');
        insert testLead2;
    
        List<Task> tasks = new List<Task>();
        tasks.add(new Task(
            ownerId = UserInfo.getUserId(), 
            whoId = testContact.Id, 
            Subject = 'Run Test Trigger 7777-7777-7777',
            Status = 'Open',
            Priority = 'Normal',
            Type = 'Email',
            Description = 'Body:123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-(Over 100)'));
        
        tasks.add(new Task(
            ownerId = UserInfo.getUserId(), 
            whoId = testLead.Id, 
            Subject = 'Lead Task Trigger Test',
            Status = 'Open',
            Priority = 'Normal'));
        insert tasks;
    }

    static testmethod void insertTask() { 
        for (Task t : [SELECT Id, Completed_On__c, Description, Comments_Start__c FROM Task WHERE Subject = 'Run Test Trigger 7777-7777-7777']) {
            
            System.assert(t.Completed_On__c == null);
            System.assert(t.Comments_Start__c == '123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-1234567...');

            t.Description = 'Body:ABCDEFGHIJ-ABCDEFGHIJ-ABCDEFGHIJ-ABCDEFGHIJ-ABCDEFGHIJ-ABCDEFGHIJ-ABCDEFGHIJ-ABCDEFGHIJ-ABCDEFGHIJ-ABCDEFGHIJ-(Over 100)';
            update t;
            break;
        }            
        
        for (Task t : [SELECT Id, Completed_On__c, Description, Comments_Start__c FROM Task WHERE Subject = 'Run Test Trigger 7777-7777-7777']) {
            System.assert(t.Comments_Start__c == 'ABCDEFGHIJ-ABCDEFGHIJ-ABCDEFGHIJ-ABCDEFGHIJ-ABCDEFGHIJ-ABCDEFGHIJ-ABCDEFGHIJ-ABCDEFGHIJ-ABCDEFGHI...');
            break;
        }    
    }

    static testmethod void completeTask() {    
        Task u = [SELECT Id, Completed_On__c FROM Task WHERE Subject = 'Run Test Trigger 7777-7777-7777'];
        u.Status = 'Completed';
        update u;
    
        for (Task t : [SELECT Id, Completed_On__c FROM Task WHERE Subject = 'Run Test Trigger 7777-7777-7777']) {
            System.assert(t.Completed_On__c != null);
        }
    } 

    static testmethod void completeTaskNoCompleteDate() {
        Lead l = (Lead)[SELECT id FROM Lead WHERE LastName = 'TaskTriggerTest2'];
        
        Task t = new Task(
            ownerId = UserInfo.getUserId(), 
            whoId = l.Id, 
            Subject = 'Run Test Trigger',
            Status = 'Completed',
            Priority = 'Normal',
            Type = 'Email',
            Description = 'Body:123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-123456789-(Over 100)');
        insert t;

        t.Completed_On__c = null;
        update t;
 
        l = (Lead)[SELECT id FROM Lead WHERE LastName = 'TaskTriggerTest2'];
        l.Time_to_First_Touch__c = null;
        update l;
        
        l = (Lead)[SELECT Id, Time_to_First_Touch__c FROM Lead WHERE Id = :l.Id];

        System.debug('Time to First Touch: ' + l.Time_to_First_Touch__c);
        System.assert(String.isBlank(l.Time_to_First_Touch__c));
    }   
   
    static testmethod void completeTaskOnLead() {    
        Task t2 = [SELECT Id, WhoId, Completed_On__c FROM Task WHERE Subject = 'Lead Task Trigger Test'];
        t2.Status = 'Completed';
        update t2;
    
        for (Task t : [SELECT Id, Completed_On__c FROM Task WHERE Subject = 'Lead Task Trigger Test']) {
            System.assert(t.Completed_On__c != null);
            
            Lead l = [SELECT Id, Time_to_First_Touch__c FROM Lead WHERE Id = :t2.WhoId];
            System.assert(l.Time_to_First_Touch__c.contains('Day'));
        }
    }   
    
    static testmethod void completeCreatedTaskOnLead() { 
        Lead l = (Lead)[SELECT Id, Time_to_First_Touch__c FROM Lead WHERE LastName = 'TaskTriggerTest'];
        
        System.assert(l.Time_to_First_Touch__c == null);
        
        Task t = new Task(
            ownerId = UserInfo.getUserId(), 
            whoId = l.Id, 
            Subject = 'Called Stew',
            Status = 'Completed',
            Priority = 'Normal',
            Type = 'Email',
            Description = 'Description');
        
        insert t;
        l = (Lead)[SELECT Id, Time_to_First_Touch__c FROM Lead WHERE Id = :l.Id];

        System.assert(l.Time_to_First_Touch__c.contains('Day'));
    }
}