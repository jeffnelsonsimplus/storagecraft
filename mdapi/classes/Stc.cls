/**
  \file         Stc.apxc
  \brief        This class will implement global functions
  \details      JIRA ticket(s): SSF-226
  \author       Matt Thompson-Moltzen
  \version      1.4
  \date         22 June 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  Version   Date        Author                  Description
  1.1       2017-09-22  Loch MacLeod            Created the method testSettings() and added test values
  1.2       2017-09-26  Loch MacLeod            Added NFR service to setTestSettings()
  1.3       2017-10-09  Loch MacLeod            Added isValid Email()
  1.4       2017-10-10  Loch MacLeod            SSF-697 Correction to isProductionInstance() to use query, the hardcoded value can changes.
*/

public class Stc
{
  //
  // variables
  //
  private static String patternEmail = '([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5})';

  public static String PartnerPortalURL_Test = 'https://198.135.233.37:8100/partnersqa';
    
  public static String NFR_EncodedAuth_Test = 'Basic U1RDV2Vic3RvcmVXU0FjY2Vzczp2azM0MjMja2NrLiwq';
  public static String NFR_Endpoint_Test = 'https://msp.storagecraft.com:443/STCWebServicesTest/STCSerialNumberManagementWS';
  public static String NFR_Password_Test = 'vk3423#kck.,*TEST';
  public static String NFR_SN_Endpoint_Test = 'https://msp.storagecraft.com:443/STCWebServicesTest/STCSerialNumberWS?wsdl';
  public static String NFR_Username_Test = 'STCWebstoreWSAccessTEST'; 
  
  //
  // constructor
  //
  private Stc()
  {
  }
  
  //
  // member functions
  //

  //
  // isProductionInstance determines if the current running instance is the Production instance
  // Returns    true if Production instance is running
  //
  public static Boolean isProductionInstance()
  {
    Organization org = [SELECT Name, OrganizationType, InstanceName, IsSandbox, UiSkin FROM Organization];
    //System.debug('ORGANIZATION  NAME: ' + org.name + '  TYPE: ' + org.OrganizationType + '  INSTANCE NAME: ' +  org.InstanceName + '  IS SANDBOX: ' +  org.IsSandbox + '  UI SKIN: ' + org.UiSkin);
    return (org.IsSandbox ? false : true);
  }

  //
  // isValidEmail determines if the given string is formatted as a valid email address.
  // Parameters email - value being tested
  // Returns    true if the given string is an email address
  //
  public static Boolean isValidEmail(String email)
  {
    return (email != null && Pattern.matches(patternEmail, email));
  }
    
  //
  // testSettings should be used with tests that create Accounts and NFR keys.
  // This method should be called in each test, or in the testSetup() instead
  // of using (SeeAllData = true) in the test classes.  This will ensure when
  // running tests, even in Production, the test settings are being used.
  //     
  @testVisible
  public static void setTestSettings() 
  {
    List<partnerPortals__c> ppSettings = new List<partnerPortals__c>();        
    ppSettings.add( new partnerPortals__c( Name = 'US Partner Portal', partnerPortalUrl__c = Stc.PartnerPortalURL_Test ) );
    ppSettings.add( new partnerPortals__c( Name = 'World Partner Portal', partnerPortalUrl__c = Stc.PartnerPortalURL_Test ) );
    insert ppSettings;
      
    NFRCallout__c nfrSettings = new NFRCallout__c(        
        EncodedAuth__c = Stc.NFR_EncodedAuth_Test,
        Endpoint__c = Stc.NFR_Endpoint_Test,
        Password__c = Stc.NFR_Password_Test,
        SN_Endpoint__c = Stc.NFR_SN_Endpoint_Test,
        Username__c = Stc.NFR_Username_Test       
    );
    insert nfrSettings;      
  }
}