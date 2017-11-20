/**
  \file
  \brief        This class will perform post Sandbox deployment tasks
  \details      JIRA ticket(s): SSF-652
  \author       Matt Thompson-Moltzen
  \version      1.0
  \date         22 September 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.0       2017-09-22  Matt Thompson-Moltzen   Original code.
*/
global class InitSandbox implements SandboxPostCopy
{
  global void runApexClass(SandboxContext context)
  {
    System.debug('Commencing initialization of sandbox: ' + context.organizationId() + '/' + context.sandboxId() + '/' + context.sandboxName());

    setCustomSettingPartnerPortal();
    setCustomSettingNfrKeyCallout();
    abortCronJobs();
    processUsers(context.sandboxName());
    loadObjectCountryIsoMap();

    System.debug('Completed initialization of sandbox: ' + context.organizationId() + '/' + context.sandboxId() + '/' + context.sandboxName());
  }

  public void abortCronJobs()
  {
    System.debug(LoggingLevel.INFO, 'InitSandbox::abortCronJobs() called');

    List<CronTrigger> jobs = [SELECT Id, NextFireTime FROM CronTrigger WHERE State in ('WAITING', 'ACQUIRED', 'EXECUTING') OR NextFireTime != NULL];

    for (CronTrigger ct : jobs) {
    	System.abortJob(ct.Id);
    }

    System.debug(LoggingLevel.INFO, 'InitSandbox::abortCronJobs() returning');
  }

  public void loadObjectCountryIsoMap()
  {
    System.debug(LoggingLevel.INFO, 'InitSandbox::loadObjectCountryIsoMap() called');

    StaticResource csvDocument = [SELECT Id, Body FROM StaticResource WHERE Name = 'countryIsoMap_default'];

    //
    // convert the document from Blob format to a string and then separate into a List of strings
    //
    Blob data = csvDocument.Body;

    String s = data.toString();

    List<String> lines = s.split('\n');

    System.assertEquals(251, lines.size());                                     // header plus 250 countries

    //
    // process the List and create Country ISO Map objects from each line
    //
    List<Country_ISO_Map__c> cims = new List<Country_ISO_Map__c>();

    Integer i = 0;

    for (i = 1; i < lines.size(); i++) {
      List<String> columns = lines[i].split(';');

      Country_ISO_Map__c cim = new Country_ISO_Map__c();

      cim.Name                 = columns[0].mid(1, columns[0].length() - 2);
      cim.otherName__c         = columns[1].mid(1, columns[1].length() - 2);
      cim.alpha2Code__c        = columns[2].mid(1, columns[2].length() - 2);
      cim.alpha3Code__c        = columns[3].mid(1, columns[3].length() - 2);
      cim.statesProvinces__c   = columns[4].mid(1, columns[4].length() - 2);
      cim.postalCodeRegex__c   = columns[5].mid(1, columns[5].length() - 2);
      cim.postalCodeExample__c = columns[6].mid(1, columns[6].length() - 2);
      cim.countryCode__c       = columns[7].mid(1, columns[7].length() - 2);

      //
      // the telephone formats contain JSON data which has two double quotes from the export process so reduce to one double quote
      //
      columns[8] = columns[8].replace('\"\"', '\"');
      cim.telephoneFormats__c  = columns[8].mid(1, columns[8].length() - 2);

      cims.add(cim);
    }

    try {
      insert cims;
    }
    catch(DMLException e) {
      System.debug(LoggingLevel.ERROR, 'InitSandbox::loadObjectCountryIsoMap() exception: ' + e.getMessage());
    }

    System.debug(LoggingLevel.INFO, 'InitSandbox::loadObjectCountryIsoMap() returning');
  }

  public void processUsers(String sandboxName)
  {
    System.debug(LoggingLevel.INFO, 'InitSandbox::processUsers() called');

    //
    // get Profile Ids
    //
    List<Profile> profs = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];

    System.assertEquals(1, profs.size());

    //
    // get users based on username
    //

    Set<String> adminUsers = new Set<String>();

    adminUsers.add('loch.macleod@storagecraft.com' + '.' + sandboxName);
    adminUsers.add('sean.oldroyd+stc@simplus.com'  + '.' + sandboxName);
    adminUsers.add('nephi.printy@storagecraft.com' + '.' + sandboxName);
    adminUsers.add('john.stanley@storagecraft.com' + '.' + sandboxName);
    adminUsers.add('matt.tm@storagecraft.com.au'   + '.' + sandboxName);

    List<User> usrs = [SELECT Id, Username, ProfileId, Email FROM User WHERE UserName IN :adminUsers];

    for (User usr : usrs) {
      usr.ProfileId = profs[0].Id;

      String s = usr.Email;

      s = s.remove('@example.com');
      s = s.replace('=', '@');

      usr.Email = s;
    }

    try {
      update usrs;
    }
    catch(DMLException e) {
      System.debug(LoggingLevel.ERROR, 'InitSandbox::processUsers() exception: ' + e.getMessage());
    }

    System.debug(LoggingLevel.INFO, 'InitSandbox::processUsers() returning');
  }

  public void setCustomSettingNfrKeyCallout()
  {
    System.debug(LoggingLevel.INFO, 'InitSandbox::setCustomSettingNfrKeyCallout() called');

    NFRCallout__c nfrSettings = NFRCallout__c.getOrgDefaults();

    nfrSettings.EncodedAuth__c = 'Basic U1RDV2Vic3RvcmVXU0FjY2Vzczp2azM0MjMja2NrLiwq';
    nfrSettings.Endpoint__c    = 'https://msp.storagecraft.com:443/STCWebServicesTest/STCSerialNumberManagementWS';
    nfrSettings.Password__c    = 'vk3423#kck.,*TEST';
    nfrSettings.SN_Endpoint__c = 'https://msp.storagecraft.com:443/STCWebServicesTest/STCSerialNumberWS?wsdl';
    nfrSettings.Username__c    = 'STCWebstoreWSAccessTEST';

    try {
      update nfrSettings;
    }
    catch (DMLException e) {
      System.debug(LoggingLevel.ERROR, 'InitSandbox::setCustomSettingNfrKeyCallout() exception: ' + e.getMessage());
    }

    System.debug(LoggingLevel.INFO, 'InitSandbox::setCustomSettingNfrKeyCallout() returning');
  }

  public void setCustomSettingPartnerPortal()
  {
    System.debug(LoggingLevel.INFO, 'InitSandbox::setCustomSettingPartnerPortal() called');

    partnerPortals__c pp1 = partnerPortals__c.getInstance('US Partner Portal');
    partnerPortals__c pp2 = partnerPortals__c.getInstance('World Partner Portal');

    if (pp1 != null) {
      pp1.partnerPortalUrl__c = 'http://198.135.233.37:8100/partnersqa';

      try {
        upsert pp1;
      }
      catch (DMLException e) {
        System.debug(LoggingLevel.ERROR, 'InitSandbox::setCustomSettingPartnerPortal() exception: ' + e.getMessage());
      }
    }

    if (pp2 != null) {
      pp2.partnerPortalUrl__c = 'http://198.135.233.37:8100/partnersqa';

      try {
        upsert pp2;
      }
      catch (DMLException e) {
        System.debug(LoggingLevel.ERROR, 'InitSandbox::setCustomSettingPartnerPortal() exception: ' + e.getMessage());
      }
    }

    System.debug(LoggingLevel.INFO, 'InitSandbox::setCustomSettingPartnerPortal() returning');
  }

}