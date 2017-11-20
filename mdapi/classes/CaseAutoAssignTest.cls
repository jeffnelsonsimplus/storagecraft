// THESE TEST ARE FAILING WHEN RUN THROUGH DEV CONSOLE, RUN THROUGH TEST EXECUTION PAGE TO SEE SUCCESS
@isTest
public class CaseAutoAssignTest {
    @testSetup static void setupTest() {
        List<User> users = new List<User>();
        Id pId = [Select Id from Profile where name = 'System Administrator'].Id;
        String testemail = 'testing+test@test.com';
        for(Integer i = 1; i <= 5; i++){
            users.add(new User(profileId = pId, username = i+'_'+testemail, email = i+'_'+testemail, 
                               emailencodingkey = 'UTF-8', localesidkey = 'en_US', 
                               languagelocalekey = 'en_US', timezonesidkey = 'America/Los_Angeles',
                               Alias='usr'+i, lastname='user:'+i));
            
        }
        System.runAs(new User(Id = userInfo.getUserId())){
            Insert users; 
        }
        List<Group> groups = new List<Group>();
        groups.add(new Group(Name='Auto1', type='Queue'));
        groups.add(new Group(Name='Auto2', type='Queue'));
        groups.add(new Group(Name='Auto3', type='Queue'));
        groups.add(new Group(Name='Overflow1', type='Queue'));
        groups.add(new Group(Name='Neutral1', type='Queue'));
        groups.add(new Group(Name='Failover1', type='Queue'));
        
        System.runAs(new User(Id = userInfo.getUserId())){
            Insert groups;
        }
        List<QueueSobject> qo = new List<QueueSobject>();
        for(Group g: groups){
            qo.add(new QueueSObject(QueueId = g.Id, SobjectType = 'Case'));
        }
        System.runAs(new User(Id = userInfo.getUserId())){
            Insert qo;
        }
        List<GroupMember> gm = new List<GroupMember>();
        // Auto1
        gm.add(new GroupMember(GroupId = groups[0].Id, UserOrGroupId = users[0].Id));
        gm.add(new GroupMember(GroupId = groups[0].Id, UserOrGroupId = users[1].Id));
        
        // Auto2
        gm.add(new GroupMember(GroupId = groups[1].Id, UserOrGroupId = users[1].Id));
        gm.add(new GroupMember(GroupId = groups[1].Id, UserOrGroupId = users[2].Id));
        
        // Auto3
        gm.add(new GroupMember(GroupId = groups[2].Id, UserOrGroupId = users[0].Id));
        gm.add(new GroupMember(GroupId = groups[2].Id, UserOrGroupId = users[1].Id));
        gm.add(new GroupMember(GroupId = groups[2].Id, UserOrGroupId = users[2].Id));
        gm.add(new GroupMember(GroupId = groups[2].Id, UserOrGroupId = users[3].Id));
        gm.add(new GroupMember(GroupId = groups[2].Id, UserOrGroupId = users[4].Id));
        System.runAs(new User(Id = userInfo.getUserId())){
            Insert gm;
        }
        // Custom Settings
        
        // Master Control
        STC_Process_Controlls__c spc = STC_Process_Controlls__c.getInstance( UserInfo.getOrganizationId() );
        spc.Case_Auto_Assignment_Enabled__c = true;
        Insert spc;
        
        // Queue Settings
        List<Queue_Auto_Assign_Settings__c> qSettings = new List<Queue_Auto_Assign_Settings__c>();
        qSettings.add(new Queue_Auto_Assign_Settings__c(Name = 'Auto1', Active__c = true, Assignment_Priority__c = 10, 
                                                        Fallback_Queue_Name__c = 'Failover1' , Overflow_Limit__c = null, Overflow_Queue_Name__c = null));
        qSettings.add(new Queue_Auto_Assign_Settings__c(Name = 'Auto2', Active__c = true, Assignment_Priority__c = 9, 
                                                        Fallback_Queue_Name__c = 'Neutral1' , Overflow_Limit__c = null, Overflow_Queue_Name__c = 'Overflow1'));
        qSettings.add(new Queue_Auto_Assign_Settings__c(Name = 'Auto3', Active__c = true, Assignment_Priority__c = 8, 
                                                        Fallback_Queue_Name__c = 'Failover1' , Overflow_Limit__c = null, Overflow_Queue_Name__c = null));
        qSettings.add(new Queue_Auto_Assign_Settings__c(Name = 'Neutral1', Active__c = true, Assignment_Priority__c = 7, 
                                                        Fallback_Queue_Name__c = 'Failover1' , Overflow_Limit__c = null, Overflow_Queue_Name__c = null));
        Insert qSettings;
    }
    
    static testMethod void ensureBalancedLoad() {
        List<Case> c = new List<Case>();
        Group g = [select Id from Group where Name = 'Auto1'];
        for(Integer i = 0; i < 10; i++){
            c.add(new Case(OwnerId = g.Id, Subject='Test Case '+i));
        }
        Test.startTest();
        Insert c;
        Test.stopTest();
        List<Case> cse = [Select Id, OwnerId, Owner.Name from Case];
        System.Debug('Cases:'+cse);
        User u1 = [SELECT Id from user where LastName = 'user:1'];
        List<Case> cUpd = [select Id from Case where OwnerId = :u1.Id];
        System.assertEquals(5, cUpd.size());
        User u2 = [SELECT Id from user where LastName = 'user:2'];
        System.Debug(u2);
        cUpd = [select Id from Case where OwnerId = :u2.Id];
        System.assertEquals(5, cUpd.size());
    }
    
    // not using because it depends on a workflow rule
    /*
    static testMethod void ensureProperFirstAssignment() {
        User u2 = [SELECT Id from user where LastName = 'user:2'];
        Case c1 = new Case(OwnerId = u2.Id);
        Insert c1;
        c1 = new Case(Id = c1.Id, Assignment_Date_Time__c = Date.today().addDays(-2));
        Update c1;
        
        User u1 = [SELECT Id from user where LastName = 'user:1'];
        Case c2 = new Case(OwnerId = u1.Id);
        Insert c2;
        Group a1 = [SELECT Id from Group where Name = 'Auto1'];
        Case c3 = new Case(OwnerId = a1.Id);
        Insert c3;
        c3 = [SELECT Id, OwnerId from Case where Id =: c3.Id];
        System.AssertEquals(u1.Id, c3.OwnerId);
    }
    */
    
    static testMethod void ensureMasterControlFunctions() {
        STC_Process_Controlls__c controls = STC_Process_Controlls__c.getInstance(UserInfo.getOrganizationId());
        controls.Case_Auto_Assignment_Enabled__c = false;
        Update controls;
        
        
        Group a1 = [SELECT Id from Group where Name = 'Auto1'];
        Case c = new Case(OwnerId = a1.Id);
        Insert c;
        c = [SELECT Id, OwnerId from Case where Id =: c.Id];
        System.assertEquals(a1.Id, c.OwnerId);
    }
    
    static testMethod void testFailover(){
        Group n1 = [Select Id from Group where Name = 'Neutral1'];
        Group f1 = [Select Id from Group where Name = 'Failover1'];
        
        Case c = new Case(OwnerId = n1.Id);
        Insert c;
        
        c = [Select Id, OwnerId from Case where Id =: c.Id];
        System.assertEquals(f1.Id, c.OwnerId);
        
    }
    
    static testMethod void testAvailabilityBlocking(){
        List<User_Time_Off__c> uto = new List<User_Time_Off__c>();
        User u1 = [Select Id from User where LastName ='user:1'];
        User u2 = [Select Id from User where LastName ='user:2'];
        uto.add(new User_Time_Off__c(OwnerId = u1.Id, Start_Date__c = Date.today(), End_Date__c = Date.today()));
        Insert uto;
        
        Group a1 = [Select Id from Group where name = 'Auto1'];
        List<Case> cases = new List<Case>();
        
        for(Integer i = 0; i < 10; i++){
            cases.add(new Case(OwnerId = a1.Id));
        }
        Insert cases;
        cases = [select Id from Case where OwnerId =: u2.Id];
        System.assertEquals(10, cases.size());
    }
    
    static testMethod void testFailoverWithAssignment(){
        List<User_Time_Off__c> uto = new List<User_Time_Off__c>();
        User u1 = [Select Id from User where LastName ='user:1'];
        User u2 = [Select Id from User where LastName ='user:2'];
        User u4 = [Select Id from User where LastName ='user:4'];
        uto.add(new User_Time_Off__c(OwnerId = u1.Id, Start_Date__c = Date.today(), End_Date__c = Date.today()));
        uto.add(new User_Time_Off__c(OwnerId = u2.Id, Start_Date__c = Date.today(), End_Date__c = Date.today()));
        Insert uto;
        
        Group a1 = [Select Id, Name from Group where name = 'Auto1'];
        System.Debug(a1);
        Group f1 = [Select Id, Name from Group where name = 'Failover1'];
        System.Debug(f1);
        
        GroupMember gm = new GroupMember(GroupId = f1.Id, UserOrGroupId = u4.Id);
        System.runAs(new User(Id = userInfo.getUserId())){
            Insert gm;
        }
        
        List<Queue_Auto_Assign_Settings__c> qSettings = new List<Queue_Auto_Assign_Settings__c>();
        qSettings.add(new Queue_Auto_Assign_Settings__c(Name = 'Failover1', Active__c = true, Assignment_Priority__c = 1, 
                                                        Fallback_Queue_Name__c = null , Overflow_Limit__c = null, Overflow_Queue_Name__c = null));
        Insert qSettings;
        
        List<Case> cases = new List<Case>();
        
        for(Integer i = 0; i < 10; i++){
            cases.add(new Case(OwnerId = a1.Id));
        }
        Insert cases;
        List<Case> css = [select Id, OwnerId, Owner.LastName from Case];
        System.Debug(css);
        cases = [select Id from Case where OwnerId =: u4.Id];
        System.assertEquals(10, cases.size());
        
    }
    
    static testMethod void testDoubleFailoverWithAssignment(){
        List<User_Time_Off__c> uto = new List<User_Time_Off__c>();
        User u2 = [Select Id from User where LastName ='user:2'];
        User u3 = [Select Id from User where LastName ='user:3'];
        User u4 = [Select Id from User where LastName ='user:4'];
        uto.add(new User_Time_Off__c(OwnerId = u2.Id, Start_Date__c = Date.today(), End_Date__c = Date.today()));
        uto.add(new User_Time_Off__c(OwnerId = u3.Id, Start_Date__c = Date.today(), End_Date__c = Date.today()));
        Insert uto;
        
        Group a2 = [Select Id, Name from Group where name = 'Auto2'];
        System.Debug(a2);
        Group f1 = [Select Id, Name from Group where name = 'Failover1'];
        System.Debug(f1);
        
        GroupMember gm = new GroupMember(GroupId = f1.Id, UserOrGroupId = u4.Id);
        System.runAs(new User(Id = userInfo.getUserId())){
            Insert gm;
        }
        
        List<Queue_Auto_Assign_Settings__c> qSettings = new List<Queue_Auto_Assign_Settings__c>();
        qSettings.add(new Queue_Auto_Assign_Settings__c(Name = 'Failover1', Active__c = true, Assignment_Priority__c = 1, 
                                                        Fallback_Queue_Name__c = null , Overflow_Limit__c = null, Overflow_Queue_Name__c = null));
        Insert qSettings;
        
        List<Case> cases = new List<Case>();
        
        for(Integer i = 0; i < 10; i++){
            cases.add(new Case(OwnerId = a2.Id));
        }
        Insert cases;
        List<Case> css = [select Id, OwnerId, Owner.LastName from Case];
        System.Debug(css);
        cases = [select Id from Case where OwnerId =: u4.Id];
        System.assertEquals(10, cases.size());
        
    }
    
    static testMethod void testOverflow(){
        User u2 = [Select Id from User where LastName ='user:2'];
        User u3 = [Select Id from User where LastName ='user:3'];
        
        Group a2 = [Select Id, Name from Group where name = 'Auto2'];
        Group o1 = [Select Id, Name from Group where name = 'Overflow1'];
        
        Queue_Auto_Assign_Settings__c qSetting = [select Id from Queue_Auto_Assign_Settings__c where Name = 'Auto2'];
        qSetting.Overflow_Limit__c = 10;
        Update qSetting;
        
        List<Case> cases = new List<Case>();
        
        for(Integer i = 0; i < 10; i++){
            cases.add(new Case(OwnerId = u2.Id));
        }
        Insert cases;
        
        cases = new List<Case>();
        for(Integer i = 0; i < 20; i++){
            cases.add(new Case(OwnerId = a2.Id));
        }
        Insert cases;
        
        cases = [select Id from Case where OwnerId =: u2.Id];
        System.assertEquals(10, cases.size());
        cases = [select Id from Case where OwnerId =: u3.Id];
        System.assertEquals(10, cases.size());
        cases = [select Id from Case where OwnerId =: o1.Id];
        System.assertEquals(10, cases.size());
        
    }
    
    static testMethod void testDebt(){
        User u1 = [Select Id from User where LastName ='user:1'];
        User u2 = [Select Id from User where LastName ='user:2'];
        u1.Case_Assign_Debt__c = 5;
        u1.Case_Assign_Debt_Date__c = Date.today();
        Update u1;
        
        Group a1 = [Select Id, Name from Group where name = 'Auto1'];
        
        List<Case> cases = new List<Case>();
        for(Integer i = 0; i < 10; i++){
            cases.add(new Case(OwnerId = a1.Id));
        }
        Insert cases;
        
        cases = [select Id from Case where OwnerId =: u1.Id];
        System.assertEquals(8, cases.size());
        cases = [select Id from Case where OwnerId =: u2.Id];
        System.assertEquals(2, cases.size());
    }
    
    static testMethod void testOldDebt(){
        User u1 = [Select Id from User where LastName ='user:1'];
        User u2 = [Select Id from User where LastName ='user:2'];
        u1.Case_Assign_Debt__c = 5;
        u1.Case_Assign_Debt_Date__c = Date.today().addDays(-1);
        Update u1;
        
        Group a1 = [Select Id, Name from Group where name = 'Auto1'];
        
        List<Case> cases = new List<Case>();
        for(Integer i = 0; i < 10; i++){
            cases.add(new Case(OwnerId = a1.Id));
        }
        Insert cases;
        
        cases = [select Id from Case where OwnerId =: u1.Id];
        System.assertEquals(5, cases.size());
        cases = [select Id from Case where OwnerId =: u2.Id];
        System.assertEquals(5, cases.size());
    }
    
    static testMethod void testNegDebt(){
        User u1 = [Select Id from User where LastName ='user:1'];
        User u2 = [Select Id from User where LastName ='user:2'];
        u1.Case_Assign_Debt__c = -5;
        u1.Case_Assign_Debt_Date__c = Date.today();
        Update u1;
        
        Group a1 = [Select Id, Name from Group where name = 'Auto1'];
        
        List<Case> cases = new List<Case>();
        for(Integer i = 0; i < 10; i++){
            cases.add(new Case(OwnerId = a1.Id));
        }
        Insert cases;
        
        cases = [select Id from Case where OwnerId =: u1.Id];
        System.assertEquals(2, cases.size());
        cases = [select Id from Case where OwnerId =: u2.Id];
        System.assertEquals(8, cases.size());
    }
    
    static testMethod void testLoadModifier(){
        User u1 = [Select Id from User where LastName ='user:1'];
        User u2 = [Select Id from User where LastName ='user:2'];
        u1.Case_Assign_Load_Modifier__c = 50;
        Update u1;
        
        Group a1 = [Select Id, Name from Group where name = 'Auto1'];
        
        List<Case> cases = new List<Case>();
        for(Integer i = 0; i < 6; i++){
            cases.add(new Case(OwnerId = a1.Id));
        }
        Insert cases;
        
        cases = [select Id from Case where OwnerId =: u1.Id];
        System.assertEquals(2, cases.size());
        cases = [select Id from Case where OwnerId =: u2.Id];
        System.assertEquals(4, cases.size());
    }
    
    static testMethod void testInactiveSetting(){
        Queue_Auto_Assign_Settings__c qSetting = [select Id from Queue_Auto_Assign_Settings__c where Name = 'Auto1'];
        qSetting.Active__c = false;
        Update qSetting;
        Group a1 = [Select Id, Name from Group where name = 'Auto1'];
        
        List<Case> cases = new List<Case>();
        for(Integer i = 0; i < 10; i++){
            cases.add(new Case(OwnerId = a1.Id));
        }
        Insert cases;
        
        cases = [select Id from Case where OwnerId =: a1.Id];
        System.assertEquals(10, cases.size());
    }
    
    static testMethod void testUserTZRespect(){
        CaseAutoAssign.QueueMember m = new CaseAutoAssign.QueueMember();
        m.timeZoneSidKey = 'America/New_York';
        TimeZone tzDenv = TimeZone.getTimeZone('America/Denver');
        TimeZone tzNY = TimeZone.getTimeZone('America/New_York');
        Datetime now = Datetime.now();
        Integer denverOffset = tzDenv.getOffset(now);
        Integer newyorkOffset = tzNY.getOffset(now);
        System.debug('Denver Millis:'+denverOffset);
        System.debug('New York Millis:'+newyorkOffset);
        Datetime nowUser = m.getLocalTime(now);
        Integer denvOffSeconds = denverOffset/1000;
        Integer nyOffSeconds = newyorkOffset/1000;
        System.debug('Denver Offset:'+denvOffSeconds);
        System.debug('New York Offset:'+nyOffSeconds);
        Datetime nowDenv = now.addSeconds(denvOffSeconds);
        Datetime nowNY = now.addSeconds(nyOffSeconds);
        System.debug('Denver:'+nowDenv);
        System.debug('New York:'+nowNY);
        System.debug('New User:'+nowUser);
        System.assertEquals(nowNY, nowUser);
        System.assertEquals(nowDenv.addSeconds(nyOffSeconds - denvOffSeconds), nowUser);
    }
    
    static testMethod void testAvailabilityBlockingDiffTZ(){
        List<User_Time_Off__c> uto = new List<User_Time_Off__c>();
        User u1 = [Select Id from User where LastName ='user:1'];
        u1.timezonesidkey = 'Australia/Sydney';
        System.runAs(new User(Id = UserInfo.getUserId())){
        	Update u1;
        }
        
        TimeZone tz = TimeZone.getTimeZone('Australia/Sydney');
        Datetime now = Datetime.now();
        Integer auOffset = tz.getOffset(now);
        Datetime nowOffset = now.addSeconds(auOffset/1000);
        
        User u2 = [Select Id from User where LastName ='user:2'];
        uto.add(new User_Time_Off__c(OwnerId = u1.Id, Start_Date__c = nowOffset.date(), End_Date__c = nowOffset.date()));
        Insert uto;
        
        Group a1 = [Select Id from Group where name = 'Auto1'];
        List<Case> cases = new List<Case>();
        
        for(Integer i = 0; i < 10; i++){
            cases.add(new Case(OwnerId = a1.Id));
        }
        Insert cases;
        cases = [select Id from Case where OwnerId =: u2.Id];
        System.assertEquals(10, cases.size());
    }
}