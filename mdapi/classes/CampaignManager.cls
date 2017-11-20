/**
  \file         CampaignManager.cls
  \brief        Set and update the Campaign information
  \details      SSF-105 Update Lead and Opportunity source campaigns
  \author       Loch MacLeod
  \version      1.0
  \date         07 August 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  Version   Date        Author                  Description
  1.1       2017-08-08  Loch MacLeod            Corrections to each of the Leads, Contacts Opportunities
*/
public class CampaignManager {
    private static String taskSubjectFormat = 'Call {0} for the {1} Campaign';
    private static String taskDescription = 'Automated task created by system. Please add your own comments to this section when working on this task.';
    private static String taskPriority = 'Normal';
    
    public static void setLastCampaign(List<Lead> oldLeads, List<Lead> newLeads) {
        //System.debug('CampaignManager.onChangeLastCampaign for Lead');

        for (Lead l : newLeads) {
            if (l.SourceCampaign__c != null && l.First_Touch_Campaign__c == null) {
                l.First_Touch_Campaign__c = l.SourceCampaign__c;
                //System.debug('  Set First Touch Campaign to ' + l.SourceCampaign__c);
            }
        }
        System.debug('****** before oldleads if');
        if (oldLeads != null) {
            System.debug('****** afteroldleads if');
            //System.debug('  Update');      
            Map<Id, Lead> leadIds = new Map<Id, Lead>();
            Map<Id, Integer> campaignIds = new Map<Id, Integer>();

            System.debug('****** newLeads.size = ' + newLeads.size());
            for (integer i = 0; i < newLeads.size(); i++) {
//                if (oldLeads[i].SourceCampaign__c != newLeads[i].SourceCampaign__c) {
                if (oldLeads[i].SourceCampaign__c == newLeads[i].SourceCampaign__c) {
                    System.debug('****  Change of Last Touch Campaing');
                    leadIds.put(newLeads[i].Id, newLeads[i]);
                    campaignIds.put(newLeads[i].SourceCampaign__c, 1);
                }            
            }

            System.debug('**** before !leads');
            if (!leadIds.isEmpty()) {
                //System.debug('  Have Leads to create Campaign Task');
                System.debug('****** inside !leads.isEmpty() if');
                List<Campaign> campaigns = [SELECT Id, Name FROM Campaign WHERE Id IN :campaignIds.keySet()];            
                List<Task> tasks = new List<Task>(); 
                
                for (Lead l : leadIds.values()) {
                    for (Campaign c : campaigns) {
//                        if (c.Id == l.SourceCampaign__c) {
                        if (c.Id == l.SourceCampaign__c) {
                            //System.debug('  Create Task for Lead in new Campaign');
                            System.debug('****** l.Email = ' + l.Email);
                            System.debug('****** l.Name = ' + l.Name);
                            System.debug('****** l.id = ' + l.id);
//                            tasks.add( new Task(Type = 'Call',                        
//                                                Subject = String.format(taskSubjectFormat, new String[] { l.Name, c.Name }),
//                                                Description = taskDescription,
//                                                ActivityDate = Date.today(),
//                                                Priority = taskPriority,
//                                                Campaign__c = c.Id,                
//                                                OwnerId = l.OwnerId) );
                            break;
                        }
                    }
                }
            
                if (!tasks.isEmpty()) {
                    insert tasks;
                }
            }
        }            
    }
        
    public static void onChangeLastCampaign(List<Contact> oldContact, List<Contact> newContact) {
        System.debug('onChangeLastCampaign for Contacts');
 /***       
        Map<Id, Integer> contactIds = new Map<Id, Integer>();
		Map<Id, Integer> campaignIds = new Map<Id, Integer>();
        
        for (integer i = 0; i < newContact.size(); i++) {
            if (oldContact != null &&
				oldContact[i].leadSourceCampaign__c != newContact[i].leadSourceCampaign__c) {
                System.debug('-- leadSourceCampaign__c changed');
               	contactIds.put(newContact[i].Id, 1);
                campaignIds.put(newContact[i].leadSourceCampaign__c, 1);
            }            
        }
        
        if (!contactIds.isEmpty()) {
            System.debug('-- Add Task');
            List<Campaign> campaigns = [SELECT Id, Name FROM Campaign WHERE Id IN :campaignIds.keySet()];            
            List<Contact> contacts = [SELECT Id, Name, leadSourceCampaign__c, Account.Name, Account.Id, OwnerId FROM Contact WHERE Id IN :contactIds.keySet()];
            List<Task> tasks = new List<Task>(); 
            Id campaignId;
            String campaignName;
            
            for (Contact cn : contacts) {
                for (Campaign c : campaigns) {
                    if (c.Name.Equals(cn.leadSourceCampaign__c)) {
                        campaignId = c.Id;
                        campaignName = c.Name;
                        tasks.add(
                            new Task(
                                Type = 'Call',                        
                                 Subject = String.format('Call {0} with {1} for the {2} Campaign', new String[] { cn.Name, cn.Account.Name, campaignName }),
                                 Description = 'Automated task created by system. Please add your own comments to this section when working on this task.',
                                 ActivityDate = Date.today(),
                                 Priority = 'Normal',
                                 Campaign__c = campaignId,                
                                 OwnerId = cn.OwnerId) );
                        break;
                    }
                } 
            }
        
            if (!tasks.isEmpty()) {
                insert tasks;
            }
        }  
***/
    }

    // Set the Source Campaign on an Opportunity when created
    public static void setOpportunitySourceCampaign(List<Opportunity> oldOpportunity, List<Opportunity> newOpportunity) {
        System.debug('CampaignManager.setSourceCampaign for Opportunity');
        
        Map<String, Integer> sources = new Map<String, Integer>();
      
        for (integer i = 0; i < newOpportunity.size(); i++) {
            if (oldOpportunity == null || oldOpportunity[i].leadSourceCampaign__c != newOpportunity[i].leadSourceCampaign__c) {
                System.debug('  update Campaign.  leadSourceCampaign = ' + newOpportunity[i].leadSourceCampaign__c);
               	sources.put(newOpportunity[i].leadSourceCampaign__c, 1);
            }            
        }
        
        if (!sources.isEmpty()) {
            List<Campaign> campaigns = [SELECT Id, Name FROM Campaign WHERE Name IN :sources.keySet()];            
            
            for (Opportunity newOpp : newOpportunity) {
                for (Campaign c : campaigns) {
                    if (c.Name.Equals(newOpp.leadSourceCampaign__c)) {
                        System.debug('  Campaign = ' + c.Name);
                        newOpp.CampaignId = c.Id;
                        break;
                    }
                }                              
            }
        }            
    }
}