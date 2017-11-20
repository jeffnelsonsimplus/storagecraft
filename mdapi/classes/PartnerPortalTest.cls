/**
  \file         PartnerPortalTest.apxc
  \brief        Tests for the PartnerPortal class.
  \details      JIRA ticket(s): 
  \author       Loch MacLeod
  \version      1.2
  \date         2017-07-12
  \copyright    Copyright 2017 StorageCraft Technology Corporation
*/
@isTest
public class PartnerPortalTest {
    @testSetup static void setupTest() {
        Test.setMock(HttpCalloutMock.class, new PartnerPortalHttpCalloutMock());
    }
    
    static testMethod void TEST_1() {        
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setBody('{ "userName": "henry@nowhare.com", "type": "PARTNER", "success": true, "password": "*u8D5kUjhx" }');

        PartnerPortalHttpCalloutMock.response = res;
        Test.setMock(HttpCalloutMock.class, new PartnerPortalHttpCalloutMock());
        
        PartnerPortal portal = new PartnerPortal();
        portal.newContact('lochtab@aol.com', 'Loch', 'MacLeod', 'NoWhare', 'US', 'UT', '84117', '', 'Value Added Reseller (VAR)', '1234');
    }
}