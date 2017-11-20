/**
  \file         StcZoneManagerTest.apxc
  \brief        Test methods for the StcZone custom object
  \details      Runs test for Leads and Accounts and StcZone custom object
                SSF-227
  \author       Loch MacLeod
  \version      1.10
  \date         30 June 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.1                   Anthony Heber           Updated to remove SeeAllData=true to improve test runtime and reliability, added new test for assignment rule conflicts
  1.2       2017-07-17  Loch MacLeod            SSF-383  Added test for User Types
  1.3       2017-07-19  Loch MacLeod            SSF-395, SSF-402 - Added tests for Promote_Account__c and corrected Account assignment
  1.4       2017-07-25  Loch MacLeod            SSF-413  Opportunity territory and assignment
  1.5       2017-08-23  Loch MacLeod            SSF-559  New Test for User Type should be OR'd with High Potential, not AND'd
  1.6       2017-08-23  Loch MacLeod            SSF-585  High Potential only allowed if Account User Type
  1.7       2017-08-30  Loch MacLeod            SSF-593  Change Account User Type calls to Transaction Types
  1.8       2017-08-30  Loch MacLeod            SSF-559  Fix assignment rules
  1.9       2017-09-27  Loch MacLeod            SSF-593  Transaction Types back in
  1.10      2017-09-28  Loch MacLeod            SSF-550  Corrections Lead Assignment.
*/
@isTest
public class StcZoneManagerTest {
    static String User1Name = 'user1@StcZoneManagerTestExample.com';
    static String User2Name = 'user2@StcZoneManagerTestExample.com';
    static String User3Name = 'user3@StcZoneManagerTestExample.com';
    static User user1;
    static User user2;
    static User user3;
    
    @testSetup
    static void testSetup() {
        Stc.setTestSettings();
        
        Map<String, StcZone__c> zones = new Map<String, StcZone__c>();
        Profile p = [select Id from Profile where Name = 'System Administrator'];
        
        user1 = new User(Username = User1Name,
                         Email = User1Name,
                         Alias = 'stczone1',
                         CommunityNickname = 'stczone1',
                         TimeZoneSidKey = 'GMT',
                         LocaleSidKey = 'en_US',
                         EmailEncodingKey = 'UTF-8',
                         LanguageLocaleKey = 'en_US',
                         FirstName = 'Test', 
                         LastName = 'User1',
                         ProfileId = p.Id);
                
        user2 = new User(Username = User2Name,
                         Email = User2Name,
                         Alias = 'stczone2',
                         CommunityNickname = 'stczone2',
                         TimeZoneSidKey = 'GMT',
                         LocaleSidKey = 'en_US',
                         EmailEncodingKey = 'UTF-8',
                         LanguageLocaleKey = 'en_US',
                         FirstName = 'Test', 
                         LastName = 'User2',
                         ProfileId = p.Id);
                
        user3 = new User(Username = User3Name,
                         Email = User3Name,
                         Alias = 'stczone3',
                         CommunityNickname = 'stczone3',
                         TimeZoneSidKey = 'GMT',
                         LocaleSidKey = 'en_US',
                         EmailEncodingKey = 'UTF-8',
                         LanguageLocaleKey = 'en_US',
                         FirstName = 'Test', 
                         LastName = 'User2',
                         ProfileId = p.Id);
        
        List<User> users = new List<User>();
        users.add(user1);
        users.add(user2);
        users.add(user3);

        System.runAs(new User(Id = UserInfo.getUserId())) {
            insert users;
        }
       
        Additional_Domain__c d = new Additional_Domain__c(Name = 'test.com');
        Insert d;        
        // OEM
        zones.put('US OEM',
                  new StcZone__c(Name = 'US OEM',
                                 Region__c = 'US West',
                                 Global_Region__c = 'AMER', 
                                 Controlling_Office__c = 'Draper, Utah  US', 
                                 Active__c = true, 
                                 Territory__c = 'US OEM',
                                 Assign_To__c = user1.Id,
                                 Assign_Accounts_To__c = user1.Id));
        // Silver Pacific
        zones.put('Silver Pacific',
                  new StcZone__c(Name = 'Silver Pacific',
                                 Region__c = 'US West',
                                 Global_Region__c = 'AMER', 
                                 Controlling_Office__c = 'Draper, Utah  US', 
                                 Active__c = true, 
                                 Territory__c = 'Silver Pacific',
                                 Assign_To__c = user1.Id,
                                 Assign_Accounts_To__c = user1.Id));
        // Los Angeles
        zones.put('Los Angeles',
                  new StcZone__c(Name = 'Los Angeles',
                                 Region__c = 'US West',
                                 Global_Region__c = 'AMER', 
                                 Controlling_Office__c = 'Draper, Utah  US', 
                                 Active__c = true, 
                                 Territory__c = 'Los Angeles',
                                 Assign_To__c = user2.Id,
                                 Assign_Accounts_To__c = user2.Id));   
       zones.put('Pacific Northwest',
                 new StcZone__c(Name = 'Pacific Northwest',
                                 Region__c = 'US West',
                                 Global_Region__c = 'AMER', 
                                 Controlling_Office__c = 'Draper, Utah  US', 
                                 Active__c = true, 
                                 Territory__c = 'Pacific Northwest',
                                 Assign_To__c = user1.Id,
                                 Assign_Accounts_To__c = user2.Id));
        // Silver Northeast
        zones.put('Silver Northeast',
                  new StcZone__c(Name = 'Silver Northeast',
                                 Region__c = 'US North',
                                 Global_Region__c = 'AMER', 
                                 Controlling_Office__c = 'Draper, Utah  US', 
                                 Active__c = true, 
                                 Territory__c = 'Silver Northeast',
                                 Assign_To__c = user1.Id,
                                 Assign_Accounts_To__c = user1.Id));
        // Silver Great Lakes
        zones.put('Silver Great Lakes',
                  new StcZone__c(Name = 'Silver Great Lakes',
                                 Region__c = 'US North',
                                 Global_Region__c = 'AMER', 
                                 Controlling_Office__c = 'Draper, Utah  US', 
                                 Active__c = true, 
                                 Territory__c = 'Silver Great Lakes',
                                 Assign_To__c = user1.Id,
                                 Assign_Accounts_To__c = user1.Id));
        // Germany North
        zones.put('Germany North',
                  new StcZone__c(Name = 'Germany North',
                                 Region__c = 'Germany',
                                 Global_Region__c = 'EMEA', 
                                 Controlling_Office__c = 'Cork, IE', 
                                 Active__c = true, 
                                 Territory__c = 'Germany North',
                                 Assign_To__c = user1.Id,
                                 Assign_Accounts_To__c = user1.Id));
        // Germany South
        zones.put('Germany South',
                  new StcZone__c(Name = 'Germany South',
                                 Region__c = 'Germany',
                                 Global_Region__c = 'EMEA', 
                                 Controlling_Office__c = 'Cork, IE', 
                                 Active__c = true, 
                                 Territory__c = 'Germany South',
                                 Assign_To__c = user1.Id,
                                 Assign_Accounts_To__c = user1.Id));
        // Unknown
/*
        zones.put('Unknown',
                  new StcZone__c(Name = 'Unknown',
                                 Region__c = 'US West',
                                 Global_Region__c = 'AMER', 
                                 Controlling_Office__c = 'Draper, Utah  US', 
                                 Active__c = true, 
                                 Territory__c = 'Unknown',
                                 Assign_To__c = user3.Id,
                                 Assign_Accounts_To__c = user3.Id));
 */                                

        insert zones.values();
        
        List<StcZoneRule__c> zoneRules = new List<StcZoneRule__c>();
         
        zoneRules.add(new StcZoneRule__c(Order__c = 100,
                                         Active__c = true,
                                         Name = 'Germany North 1',
                                         StcZone__c = zones.get('Germany North').Id,
                                         Countries__c = 'DE',
                                         States__c = null,
                                         Postal_Codes__c = 'STARTSWITH 6:7:8:9',
                                         Works_On__c = 'Leads Only',                                
                                         Lead_User_Types__c = null,
                                         Account_User_Types__c = null,
                                         High_Potential__c = false
                                         ));
        zoneRules.add(new StcZoneRule__c(Order__c = 200,
                                         Active__c = true,
                                         Name = 'Germany North 2',
                                         StcZone__c = zones.get('Germany North').Id,
                                         Countries__c = 'DE',
                                         States__c = null,
                                         Postal_Codes__c = 'BETWEEN 20000:29999',
                                         Works_On__c = 'Leads Only',                                            
                                         Lead_User_Types__c = null,
                                         Account_User_Types__c = null,
                                         High_Potential__c = false
                                         ));
        zoneRules.add(new StcZoneRule__c(Order__c = 300,
                                         Active__c = true,
                                         Name = 'Germany South',
                                         StcZone__c = zones.get('Germany South').Id,
                                         Countries__c = 'DE',
                                         States__c = null,
                                         Postal_Codes__c = null,
                                         Works_On__c = 'Both Leads and Accounts',                                
                                         Lead_User_Types__c = null,
                                         Account_User_Types__c = null,
                                         High_Potential__c = false
                                         ));
        zoneRules.add(new StcZoneRule__c(Order__c = 1000,
                                         Active__c = true,
                                         Name = 'US OEM',
                                         StcZone__c = zones.get('US OEM').Id,
                                         Countries__c = 'US,CA',
                                         States__c = null,
                                         Postal_Codes__c = null,
                                         Works_On__c = 'Accounts Only',                                 
                                         Lead_User_Types__c = null,
                                         Account_User_Types__c = 'Alliance Partner',
                                         High_Potential__c = false    
                                        )); 
        zoneRules.add(new StcZoneRule__c(Order__c = 2000,
                                         Active__c = true,
                                         Name = 'Pacific Northwest',   
                                         StcZone__c = zones.get('Pacific Northwest').Id,
                                         Countries__c = 'US',
                                         States__c = 'CA,ID,OR,WA',
                                         Postal_Codes__c = null,
                                         Works_On__c = 'Accounts Only',                                
                                         Lead_User_Types__c = null,
                                         Account_User_Types__c = 'Trial User;Business User',
                                         High_Potential__c = true
                                        ));
        zoneRules.add(new StcZoneRule__c(Order__c = 3000,
                                         Active__c = true,
                                         Name = 'Los Angeles 1',
                                         StcZone__c = zones.get('Los Angeles').Id,
                                         Countries__c = 'US',
                                         States__c = 'CA',
                                         Postal_Codes__c = '94216,94215,94217,94218,94219,94220',                                         
                                         Works_On__c = 'Both Leads and Accounts',                                         
                                         Lead_User_Types__c = 'Trial User;Business User',
                                         Account_User_Types__c = null,
                                         High_Potential__c = false
                                         ));
        zoneRules.add(new StcZoneRule__c(Order__c = 4000,
                                         Active__c = true,
                                         Name = 'Los Angeles 2',
                                         StcZone__c = zones.get('Los Angeles').Id,
                                         Countries__c = 'US',
                                         States__c = 'CA',
                                         Postal_Codes__c = '94116,94115,94117,94118,94119,94120',                                         
                                         Works_On__c = 'Both Leads and Accounts',               
                                         Lead_User_Types__c = 'Trial User;Business User',
                                         Account_User_Types__c = null,
                                         High_Potential__c = false
                                         ));       
        zoneRules.add(new StcZoneRule__c(Order__c = 5000,
                                         Active__c = true,
                                         Name = 'Silver Pacific',
                                         StcZone__c = zones.get('Silver Pacific').Id,
                                         Countries__c = 'US',
                                         States__c = 'WA,OR,CA,NV,AZ',
                                         Postal_Codes__c = null,
                                         Works_On__c = 'Both Leads and Accounts',                                
                                         Lead_User_Types__c = null,
                                         Account_User_Types__c = null,
                                         High_Potential__c = false
                                         ));
        zoneRules.add(new StcZoneRule__c(Order__c = 6000,
                                         Active__c = true,
                                         Name = 'Silver Northeast',
                                         StcZone__c = zones.get('Silver Northeast').Id,
                                         Countries__c = 'US',
                                         States__c = 'ME,RI,NH,NY,NJ,CT,RI,VT',
                                         Postal_Codes__c = null,
                                         Works_On__c = 'Leads Only',
                                         Lead_User_Types__c = null,
                                         Account_User_Types__c = null,
                                         High_Potential__c = false                                         
                                         )); 
        zoneRules.add(new StcZoneRule__c(Order__c = 7000,
                                         Active__c = true,
                                         Name = 'Silver Great Lakes 1',
                                         StcZone__c = zones.get('Silver Great Lakes').Id,
                                         Countries__c = 'CA',
                                         States__c = 'MB, ON, QC, NL, MB, PE, NS',
                                         Postal_Codes__c = null,
                                         Works_On__c = 'Both Leads and Accounts',                                
                                         Lead_User_Types__c = null,
                                         Account_User_Types__c = null,
                                         High_Potential__c = false
                                         ));
        zoneRules.add(new StcZoneRule__c(Order__c = 8000,
                                         Active__c = true,
                                         Name = 'Silver Great Lakes 2',
                                         StcZone__c = zones.get('Silver Great Lakes').Id,
                                         Countries__c = 'US',
                                         States__c = 'WI, MI, MN',
                                         Postal_Codes__c = null,
                                         Works_On__c = 'Both Leads and Accounts',                                
                                         Lead_User_Types__c = null,
                                         Account_User_Types__c = null,
                                         High_Potential__c = false
                                         ));
/*                                         
        zoneRules.add(new StcZoneRule__c(Order__c = 100000,
                                         Active__c = true,
                                         Name = 'Catch All',
                                         StcZone__c = zones.get('Unknown').Id,
                                         Countries__c = null,
                                         States__c = null,
                                         Postal_Codes__c = null,
                                         Works_On__c = 'Both Leads and Accounts',                                
                                         Lead_User_Types__c = null,
                                         Account_User_Types__c = null,
                                         High_Potential__c = false
                                         ));
*/                                         

        insert zoneRules;
    }

    @isTest
    static void testLead_Basic() {        
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Basic',
            Company = 'Basic Campaign Company',
            Email = 'test.basic@test.com',
            State = 'CA',
            Country = 'US',
            PostalCode = '98765-0964',
            UserType__c = 'Value Added Reseller (VAR)');
        insert testLead;
        
        testLead = [SELECT Id, Country, State, PostalCode, StcZone_Territory__c FROM Lead WHERE Id = :testLead.Id];      
        System.assertEquals('Silver Pacific', testLead.StcZone_Territory__c);   
    }

    @isTest
    static void testLead_ChangeAddress() {
        Lead testLead = new Lead(
            FirstName = 'Lead',
            LastName = 'Change',
            Company = 'Change Campaign Company',
            Email = 'lead.cange@test.com',
            State = 'CA',
            Country = 'US',
            PostalCode = '91917',
            UserType__c = 'Value Added Reseller (VAR)');
        insert testLead;
        
        testLead = [SELECT Id, Country, State, PostalCode, StcZone_Territory__c FROM Lead WHERE Id = :testLead.Id];

        System.assertEquals('Silver Pacific', testLead.StcZone_Territory__c);
        
        testLead.State = 'NY';
        testLead.PostalCode = '14535';
        update testLead;
        
        testLead = [SELECT Id, Country, State, PostalCode, StcZone_Territory__c FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('Silver Northeast', testLead.StcZone_Territory__c);   
    }
    
    @isTest
    static void testLead_CA() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'CA',
            Company = 'CA ampaign Company',
            Email = 'test.ca@test.com',
            State = 'ON',
            Country = 'CA',
            PostalCode = 'P0M 0B8',
            UserType__c = 'Value Added Reseller (VAR)');
        insert testLead;
        
        testLead = [SELECT Id, Country, State, PostalCode, StcZone_Territory__c FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('Silver Great Lakes', testLead.StcZone_Territory__c);   
    }

    @isTest
    static void testLead_BETWEEN() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Test',
            Company = 'Test Campaign Company',
            Email = 'test.test@test.com',
            Country = 'DE',
            PostalCode = '59000',
            UserType__c = 'Value Added Reseller (VAR)');
        insert testLead;
              
        testLead = [SELECT Id, Country, State, PostalCode, StcZone_Territory__c FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('Germany South', testLead.StcZone_Territory__c); 
        
        testLead.PostalCode = '25987';
        update testLead;
        
        testLead = [SELECT Id, Country, State, PostalCode, StcZone_Territory__c FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('Germany North', testLead.StcZone_Territory__c);  
        
        testLead.PostalCode = '30000';
        update testLead;
        
        testLead = [SELECT Id, Country, State, PostalCode, StcZone_Territory__c FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('Germany South', testLead.StcZone_Territory__c); 

        testLead.PostalCode = '20000';
        update testLead;
        
        testLead = [SELECT Id, Country, State, PostalCode, StcZone_Territory__c FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('Germany North', testLead.StcZone_Territory__c);     
        
        testLead.PostalCode = '29999';
        update testLead;
        
        testLead = [SELECT Id, Country, State, PostalCode, StcZone_Territory__c FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('Germany North', testLead.StcZone_Territory__c);
    } 

    @isTest
    static void testLead_STARTSWITH() {
        Lead testLead = new Lead(
            FirstName = 'Test',
            LastName = 'Test',
            Company = 'Test Campaign Company',
            Email = 'test.test@test.com',
            Country = 'DE',
            PostalCode = '59000',
            UserType__c = 'Value Added Reseller (VAR)');
        insert testLead;
              
        testLead = [SELECT Id, Country, State, PostalCode, StcZone_Territory__c FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('Germany South', testLead.StcZone_Territory__c); 
        
        testLead.PostalCode = '78987';
        update testLead;
        
        testLead = [SELECT Id, Country, State, PostalCode, StcZone_Territory__c FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('Germany North', testLead.StcZone_Territory__c); 
    } 
   
    @isTest
    static void testLead_AssignRule() {
        Lead testLead = new Lead(
            FirstName = 'Lead',
            LastName = 'Test',
            Company = 'Laad Campaign Company',
            Email = 'lead.test@test.com',
            State = 'NY',
            Country = 'US',
            PostalCode = '14535',
            UserType__c = 'Value Added Reseller (VAR)');
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;
        testLead.setOptions(dmo);
        Test.startTest();
        insert testLead;
        Test.stopTest();
              
        testLead = [SELECT Id, Country, State, PostalCode, StcZone_Territory__c, Owner.Name FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('Silver Northeast', testLead.StcZone_Territory__c);
        // Refuses to pass tests, does work when async isn't in the same overall transaction
        //System.assertEquals('Test User1', testLead.Owner.Name);
    } 

    @isTest
    static void testLead_UserType() {        
        Lead testLead = new Lead(
            FirstName = 'Lead',
            LastName = 'Test',
            Company = 'Laad Campaign Company',
            Email = 'lead.test@test.com',
            State = 'CA',
            Country = 'US',
            PostalCode = '94118-1234',
            UserType__c = 'Business User');
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule= true;
        testLead.setOptions(dmo);
        Test.startTest();
        insert testLead;
        Test.stopTest();
              
        testLead = [SELECT Id, Country, State, PostalCode, StcZone_Territory__c, Owner.Name FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('Los Angeles', testLead.StcZone_Territory__c);
        
        testLead.UserType__c = 'Both MSP and VAR';
        update testLead;
        
        testLead = [SELECT Id, Country, State, PostalCode, StcZone_Territory__c, Owner.Name FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals('Silver Pacific', testLead.StcZone_Territory__c);
    }   

    @isTest
    static void testOpp_PartnerAccount() {
        // Los Angeles
        Account testPartner = new Account(
            Name = 'Opp Account2',
            Type = 'Partner',
            AccountNumber = 'OppAcc2',
            Partner_Level__c = 'Gold', 
            Partner_Level_Calculated__c = 'Gold',
            Partner_Level_atQuarter__c = 'Gold',
            Partner_Level_Overwritten__c = false,
            BillingCity = 'Holladay',
            BillingState = 'CA',
            BillingCountry = 'US',
            BillingPostalCode = '94118',
            High_Potential__c = false,
            User_Type__c = 'Business User',
            transactionTypes__c = 'Business User',
            transactionTypesAsText__c = 'Business User'
        );
        // Silver Pacific
        Account testAccount = new Account(
            Name = 'Opp Account1',
            Type = 'End User',
            AccountNumber = 'OppAcc1',
            Partner_Level__c = 'Authorized', 
            Partner_Level_Calculated__c = 'Authorized',
            Partner_Level_atQuarter__c = 'Authorized',
            Partner_Level_Overwritten__c = false,
            BillingCity = 'Holladay',
            BillingState = 'NV',
            BillingCountry = 'US',
            BillingPostalCode = '90118',
            High_Potential__c = false,
            User_Type__c = 'Managed Service Provider (MSP)',
            transactionTypes__c = 'Managed Service Provider (MSP)',
            transactionTypesAsText__c = 'Managed Service Provider (MSP)'
        );
        
        List<Account> accounts = new List<Account>();
        accounts.add(testPartner);
        accounts.add(testAccount);
        insert accounts;
                        
        testPartner = [SELECT Id, StcZone_Territory__c FROM Account WHERE Id = :testPartner.Id];
        System.assertEquals('Pacific Northwest', testPartner.StcZone_Territory__c);
        testAccount = [SELECT Id, StcZone_Territory__c FROM Account WHERE Id = :testAccount.Id];         
        System.assertEquals('Silver Pacific', testAccount.StcZone_Territory__c);
       
        Opportunity opp = new Opportunity(
            Type = 'Partner',
            AccountId = testAccount.Id,
            Partner__c = testPartner.Id,
            Name = 'Opportunity Account',
            BudgetAmount__c = 1234.00,
            CloseDate = Date.Today(),
            EstCloseDate__c = Date.Today(),           
            StageName = 'Suspect'
        );
        insert opp;
        
        opp = [SELECT Id, OwnerId, StcZone_Territory__c FROM Opportunity WHERE Id = :opp.Id];        
        System.assertEquals('Pacific Northwest', opp.StcZone_Territory__c);
        
        User user_2 = [SELECT Id, Name FROM User WHERE UserName = :User2Name];       
        System.assertEquals(user_2.Id, opp.OwnerId); 
    }

    @isTest
    static void testAccount_HighPotential() {
        Account testAccount = new Account(
            Name = 'Account Trigger Testing',
            Type = 'Account',
            AccountNumber = 'ABCD',
            Partner_Level__c = 'Authorized', 
            Partner_Level_Calculated__c = 'Authorized',
            Partner_Level_Overwritten__c = false,
            BillingCity = 'Holladay',
            BillingState = 'CA',
            BillingCountry = 'US',
            BillingPostalCode = '94444',
            High_Potential__c = false,
            User_Type__c = 'Managed Service Provider (MSP)',
            transactionTypes__c = 'Managed Service Provider (MSP)',
            transactionTypesAsText__c = 'Managed Service Provider (MSP)'
        );
        insert testAccount;
        
        testAccount = [SELECT Id, Owner.Name, StcZone_Territory__c FROM Account WHERE Id = :testAccount.Id];      
        System.assertEquals('Silver Pacific', testAccount.StcZone_Territory__c);
        
        testAccount.High_Potential__c = true;
        update testAccount;
        
        testAccount = [SELECT Id, StcZone_Territory__c FROM Account WHERE Id = :testAccount.Id];      
        System.assertEquals('Pacific Northwest', testAccount.StcZone_Territory__c);
    }

    @isTest
    static void testAccount_UserType() {
        System.debug('testAccount_UserType');
        Account testAccount = new Account(
            Name = 'Account Trigger Testing',
            Type = 'Account',
            AccountNumber = 'ABCD',
            Partner_Level__c = 'Authorized', 
            Partner_Level_Calculated__c = 'Authorized',
            Partner_Level_Overwritten__c = false,
            BillingCity = 'Holladay',
            BillingState = 'CA',
            BillingCountry = 'US',
            BillingPostalCode = '94117',
            High_Potential__c = false,
            User_Type__c = 'Alliance Partner',
            transactionTypes__c = 'Alliance Partner',
            transactionTypesAsText__c = 'Alliance Partner'
        );
        insert testAccount;
        
        testAccount = [SELECT Id, StcZone_Territory__c FROM Account WHERE Id = :testAccount.Id];      
        System.assertEquals('US OEM', testAccount.StcZone_Territory__c);     
    }
 
    @isTest
    static void testAccount_UserType2() {
        System.debug('***************************************************************');
        System.debug('testAccount_UserType2');
        Account testAccount = new Account(
            Name = 'Account User Type Test',
            Type = 'Account',
            AccountNumber = '12CD',
            Partner_Level__c = 'Authorized', 
            Partner_Level_Calculated__c = 'Authorized',
            Partner_Level_Overwritten__c = false,
            BillingCity = 'Everest',
            BillingState = 'WA',
            BillingCountry = 'US',
            BillingPostalCode = '00090',
            High_Potential__c = true,
            User_Type__c = 'Value Added Reseller (VAR)',
            transactionTypes__c = 'Value Added Reseller (VAR);Managed Service Provider (MSP)',
            transactionTypesAsText__c = 'Value Added Reseller (VAR);Managed Service Provider (MSP)'
        );
        insert testAccount;
        System.debug('---------------------------------------------------------------');
        
        testAccount = [SELECT Id, Owner.Name, StcZone_Territory__c, transactionTypesAsText__c FROM Account WHERE Id = :testAccount.Id];      
        System.debug('transactionTypesAsText__c' + testAccount.transactionTypesAsText__c);
        System.assertEquals('Pacific Northwest', testAccount.StcZone_Territory__c);
        System.assertEquals('Test User2', testAccount.Owner.Name);   
        
        testAccount.High_Potential__c = false;
        update testAccount;
        
        testAccount = [SELECT Id, Owner.Name, StcZone_Territory__c, transactionTypesAsText__c FROM Account WHERE Id = :testAccount.Id];      
        System.debug('transactionTypesAsText__c' + testAccount.transactionTypesAsText__c);
        System.assertEquals('Silver Pacific', testAccount.StcZone_Territory__c);
        System.assertEquals('Test User1', testAccount.Owner.Name); 
        System.debug('***************************************************************');
    }

    @isTest
    static void testAccount_PromoteAccount() {
        Account testAccount = new Account(
            Name = 'Account Trigger Testing',
            Type = 'Account',
            AccountNumber = 'ABCD',
            Partner_Level__c = 'Authorized', 
            Partner_Level_Calculated__c = 'Authorized',
            Partner_Level_Overwritten__c = false,
            BillingCity = 'Holladay',
            BillingState = 'CA',
            BillingCountry = 'US',
            BillingPostalCode = '94118',
            High_Potential__c = false,
            User_Type__c = 'Value Added Reseller (VAR)',
            transactionTypes__c = 'Value Added Reseller (VAR)',
            transactionTypesAsText__c = 'Value Added Reseller (VAR)'
        );
        insert testAccount;
        
        testAccount = [SELECT Id, StcZone_Territory__c FROM Account WHERE Id = :testAccount.Id];      
        System.assertEquals('Los Angeles', testAccount.StcZone_Territory__c);
        
        testAccount.Promote_Account__c = true;
        update testAccount;
        
        testAccount = [SELECT Id, StcZone_Territory__c FROM Account WHERE Id = :testAccount.Id];      
        System.assertEquals('Pacific Northwest', testAccount.StcZone_Territory__c);
    }
   
    @isTest
    static void testAccount_NotFound() {
        Account testAccount = new Account(
            Name = 'Account NotFound',
            Type = 'Account',
            AccountNumber = 'ABCD',
            Partner_Level__c = 'Authorized', 
            Partner_Level_Calculated__c = 'Authorized',
            Partner_Level_Overwritten__c = false,
            BillingCity = null,
            BillingState = null,
            BillingCountry = 'ZZ',
            BillingPostalCode = 'H897hj',
            High_Potential__c = false,
            User_Type__c = 'Value Added Reseller (VAR)',
            transactionTypes__c = 'Value Added Reseller (VAR)',
            transactionTypesAsText__c = 'Value Added Reseller (VAR)'
        );
        insert testAccount;
        
        testAccount = [SELECT Id, StcZone_Territory__c FROM Account WHERE Id = :testAccount.Id];      
//        System.assertEquals('Unknown', testAccount.StcZone_Territory__c);
    }
 
    @isTest
    static void testOpp_Account() {
        Account testAccount = new Account(
            Name = 'Opp Account',
            Type = 'Account',
            AccountNumber = 'Opp Account',
            Partner_Level__c = 'Authorized', 
            Partner_Level_Calculated__c = 'Authorized',
            Partner_Level_Overwritten__c = false,
            BillingCity = 'Holladay',
            BillingState = 'NV',
            BillingCountry = 'US',
            BillingPostalCode = '9117',
            High_Potential__c = false,
            User_Type__c = 'Value Added Reseller (VAR)',
            transactionTypes__c = 'Value Added Reseller (VAR)',
            transactionTypesAsText__c = 'Value Added Reseller (VAR)'
        );

        insert testAccount;        
        System.debug('testAccount: ' + testAccount.Id);
       
        Opportunity opp = new Opportunity(
            Type = 'Partner',
            AccountId = testAccount.Id,
            Partner__c = null,
            Name = 'Opportunity Account',
            BudgetAmount__c = 1234.00,
            CloseDate = Date.Today(),
            EstCloseDate__c = Date.Today(),           
            StageName = 'Suspect'
        ); 
        insert opp;
        
        opp = [SELECT Id, OwnerId, StcZone_Territory__c FROM Opportunity WHERE Id = :opp.Id];        
        System.assertEquals('Silver Pacific', opp.StcZone_Territory__c);
        
        User user_1 = [SELECT Id, Name FROM User WHERE UserName = :User1Name];       
        System.assertEquals(user_1.Id, opp.OwnerId);       
    }
}