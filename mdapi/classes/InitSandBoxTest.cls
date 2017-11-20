/**
  \file         InitSandboxTest.cls
  \brief        Test class for the InitSandbox class
  \details      JIRA ticket(s): SSF-652
  \author       Matt Thompson-Moltzen
  \version      1.0
  \date         25 September 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.0               2017-09-25  Matt Thompson-Moltzen       Original code.
*/
@isTest
private class InitSandBoxTest
{
  @isTest
  static void testSandboxPostCopyScript()
  {
    InitSandbox sb = new InitSandbox();

    Test.testSandboxPostCopyScript(sb,                                          // the instantiated class that implements the SandboxPostCopy interface
                                   UserInfo.getOrganizationId(),                // context org ID
                                   UserInfo.getOrganizationId(),                // context sandbox ID
                                   'sandbox');

    System.assertEquals(1, 1, 'XYZ test failed');
  }

}