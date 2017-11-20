/**
  \file
  \brief        This class will implement a test callout for Accounts class
  \details      JIRA ticket(s): SSF-447
  \author       Matt Thompson-Moltzen
  \version      1.0
  \date         4 September 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.0				2017-09-04	Matt Thompson-Moltzen		Original code.
*/
@isTest
public class AccountsHttpCalloutMock implements HttpCalloutMock
{
  public HTTPResponse respond(HTTPRequest request)
  {
    HttpResponse status = new HttpResponse();

    status.setHeader('Content-Type', 'application/json');
    status.setBody('{\"success\":true}');
    status.setStatus('OK');
    status.setStatusCode(200);

    return status;
  }

}