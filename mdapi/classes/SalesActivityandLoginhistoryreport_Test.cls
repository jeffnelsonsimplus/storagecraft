@isTest
private class SalesActivityandLoginhistoryreport_Test {
@isTest(SeeAllData=true)
    static void salesActlogrptTest() {
        SalesActivityandLoginhistoryreport salhr = new SalesActivityandLoginhistoryreport();
        String Reportresp = SalesActivityandLoginhistoryreport.getReportResponse('LAST_N_DAYS:7');
        String actdts = SalesActivityandLoginhistoryreport.getactivitydetails(UserInfo.getUserId(),'None','LAST_N_DAYS:7');
    }
    
    @isTest
    static void testSalesActLogdtlsTask() {
        SalesActivityandLoginhistoryreport.tabularReportResponse tabularResponse = new SalesActivityandLoginhistoryreport.tabularReportResponse();
        Profile p = [SELECT id, Name FROM Profile where name = 'System Administrator' ].get(0);  
        User u = new User(firstname= 'Samuel',
                  lastname='XXXX',
                  Alias='Samuel',
                  email = 'samuelXXXXX@sample.com',
                  username= 'samuelXXXXX@sample.com', 
                  profileId= p.id, 
                  emailencodingkey='UTF-8',
                  languagelocalekey='en_US',
                  localesidkey='en_US',
                  timezonesidkey='America/Los_Angeles',
                  IsActive=true,
                  SalesRep__c=true);
        insert u;   
        Campaign campaign = new Campaign(name='camp',currencyISOcode='USD',isActive=true);
        insert campaign;
        Lead lead = new Lead(Lastname='test',company='test',status='calling',usertype__c='other',email='c@c.com',leadsource='web',sourcecampaign__c=campaign.Id);
        insert lead;

        System.runAs(u) {
            Task task = new Task();
            task.whoId=lead.Id;
            task.Subject='Send Quote';
            task.type='call';
            task.OwnerId=u.Id;
            task.CurrencyISOCode='USD';
            task.description='test';
            insert task;
            test.setCreatedDate(task.Id,  DateTime.newInstance(2017,09,27));

            Task t = [select id,createdDate,CreatedBy.SalesRep__c,CreatedBy.name from Task limit 1];
            
            Test.startTest();
//                tabularResponse = SalesActivityandLoginhistoryreport.getSalesActLogdtls('LAST_N_DAYS:31');
            Test.stopTest();
//            System.assert(tabularResponse != null);
            List<String> reportFields = new List<String> {'Full Name', 'Call'};
//            System.assertEquals(1, tabularResponse.noactivityFields);
//            System.assertEquals(reportFields, tabularResponse.reportFields);            
        }            
    }

    @isTest
    static void testSalesActLogdtlsEvent() {
        SalesActivityandLoginhistoryreport.tabularReportResponse tabularResponse = new SalesActivityandLoginhistoryreport.tabularReportResponse();
        Profile p = [SELECT id, Name FROM Profile where name = 'System Administrator' ].get(0);  
        User u = new User(firstname= 'Samuel',
                  lastname='XXXX',
                  Alias='Samuel',
                  email = 'samuelXXXXX@sample.com',
                  username= 'samuelXXXXX@sample.com', 
                  profileId= p.id, 
                  emailencodingkey='UTF-8',
                  languagelocalekey='en_US',
                  localesidkey='en_US',
                  timezonesidkey='America/Los_Angeles',
                  IsActive=true,
                  SalesRep__c=true);
        insert u;   
        Campaign campaign = new Campaign(name='camp',currencyISOcode='USD',isActive=true);
        insert campaign;
        Lead lead = new Lead(Lastname='test',company='test',status='calling',usertype__c='other',email='c@c.com',leadsource='web',sourcecampaign__c=campaign.Id);
        insert lead;

        System.runAs(u) {
            Event event = new Event();
            event.whoId=lead.Id;
            event.Subject='Send Quote';
            event.type='call';
            event.OwnerId=u.Id;
            event.CurrencyISOCode='USD';
            event.description='test';
            event.DurationInMinutes = 30;
            event.ActivityDateTime = System.now();
            insert event;
            test.setCreatedDate(event.Id,  DateTime.newInstance(2017,09,27));
            
            Test.startTest();
//                tabularResponse = SalesActivityandLoginhistoryreport.getSalesActLogdtls('LAST_N_DAYS:31');
            Test.stopTest();
//            System.assert(tabularResponse != null);
            List<String> reportFields = new List<String> {'Full Name', 'Call'};
//            System.assertEquals(1, tabularResponse.noactivityFields);
//            System.assertEquals(reportFields, tabularResponse.reportFields);
        }
    }
 }