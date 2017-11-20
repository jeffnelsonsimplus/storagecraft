/**
  \file         PartnerPortalHttpCalloutMock.apxc
  \brief        Mocks the connection to the Partner Portal. Used for testing.
  \details      JIRA ticket(s): 
  \author       Loch MacLeod
  \version      1.2
  \date         2017-07-12
  \copyright    Copyright 2017 StorageCraft Technology Corporation
*/
@isTest
global class PartnerPortalHttpCalloutMock implements HttpCalloutMock{
    global static HttpResponse response;
    
    global static HTTPResponse respond(HTTPRequest request) {      
        return response;
    }
}