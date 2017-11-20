/**
  \file
  \brief        This class will implement Agreements related functions
  \details      JIRA ticket(s): SSF-115
  \author       Matt Thompson-Moltzen
  \version      1.6
  \date         27 September 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.5       2017-08-30  Matt Thompson-Moltzen   Changed references to User_Type__c to transactionTypesAsText__c (SSF-458).
  1.6       2017-09-27  Matt Thompson-Moltzen   Removed references to transactionTypesAsText__c as Portal does not use User Type (SSF-458).
*/

public class Agreements
{
  //
  // variables
  //
  private String toAddress;
  private List<OrgWideEmailAddress> owea;
  private URL url;

  //
  // constructor
  //
  public Agreements()
  {
    if (Stc.isProductionInstance()) { toAddress = 'DL-OrderDesk@storagecraft.com'; }
    else                            { toAddress = 'matt.tm@storagecraft.com.au'; }

    owea = [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress WHERE Address = 'crm@storagecraft.com'];
    url  = System.URL.getSalesforceBaseUrl();
  }

  //
  // member functions
  //
  public Boolean createCase(Agreement__c agreement)
  {
    Boolean hasFailures = false;

    Account account = [SELECT Name, BillingCountry, transactionTypesAsText__c FROM Account WHERE (Id = :agreement.Account__c)];
    Group   queue   = [SELECT Id, DeveloperName FROM Group WHERE (Type = 'Queue' AND DeveloperName = 'OrderDesk')];

    System.assert(account != null, 'Agreements::createCase(): unable to retrieve specified Account object details for: ' + agreement.Account__c);
    System.assert(queue != null, 'Agreements::createCase(): unable to retrieve specified Queue object details for: ' + 'OrderDesk');

    String body = agreement.Type__c + ' agreement ' + agreement.Name + ' for ' + account.Name + ' awaiting review and setup.\r\n\r\n';

    body += 'Status:          ' + agreement.Status__c + '\r\n';
    body += 'Acceptance Date: ' + agreement.Acceptance_Date__c.format() + '\r\n\r\n';

    body += 'Link: ' + url.toExternalForm() + '/' +  + agreement.Id + '\r\n\r\n';

    List <Case> cases = new List<Case>();

    Case c = new Case();

    c.OwnerId             = queue.Id;

    c.AccountId           = agreement.Account__c;

    if (account.BillingCountry != null) {
      Addresses addrs = new Addresses();

      c.Country__c = addrs.getCountryName(account.BillingCountry);
    }

    //
    // Since Transaction Types on Account is a Multi-Picklist, only the last value will be set
    //
//    List<String> typs = account.transactionTypesAsText__c.split(';');
//
//    for (String t : typs) {
//      c.Select_User_Type__c = t;
//    }

    c.Origin              = 'Customer Setup';
    c.Status              = 'New';
    c.Priority            = 'Medium';
    c.Type                = 'Order Entry';
    c.Subject             = agreement.Type__c + ' agreement ' + agreement.Name + ' awaiting review';
    c.Description         = body;

    cases.add(c);

    try {
      insert cases;
    }
    catch (DMLException e) {
      System.debug(LoggingLevel.ERROR, 'Agreements::createCase() exception: ' + e.getMessage());
    }

    return (hasFailures) ? false : true;
  }

  public Boolean sendEmail(Agreement__c agreement)
  {
    Boolean hasFailures = false;

    Account account = [SELECT Name FROM Account WHERE (Id = :agreement.Account__c)];

    List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();

    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

    List<String> toAddresses = new List<String>();

    toAddresses.add(toAddress);

    String subject = 'ACTION: ' + agreement.Type__c + ' agreement ' + agreement.Name + ' awaiting review';
    String body    = agreement.Type__c + ' agreement ' + agreement.Name + ' for ' + account.Name + ' awaiting review and setup.\r\n\r\n';

    body += 'Status:          ' + agreement.Status__c + '\r\n';
    body += 'Acceptance Date: ' + agreement.Acceptance_Date__c.format() + '\r\n\r\n';

    body += 'Link: ' + url.toExternalForm() + '/' +  + agreement.Id + '\r\n\r\n';

    if (owea.size() > 0) { message.setOrgWideEmailAddressId(owea.get(0).Id); }

    message.setToAddresses(toAddresses);
    message.setSubject(subject);
    message.setPlainTextBody(body);

    messages.add(message);

    if (messages.size() > 0) {
      List<Messaging.SendEmailResult> results = new List<Messaging.SendEmailResult>();

      try {
        results = Messaging.sendEmail(messages);
      }
      catch (Exception e) {
        System.debug(LoggingLevel.ERROR, 'Agreements::sendEmail() exception: ' + e.getMessage());

        return false;
      }

      Integer i = 0;

      for (i = 0; i < results.size(); i++) {
        if (results[i].isSuccess() == false) {
          hasFailures = true;
          System.debug(LoggingLevel.ERROR, 'Agreements::sendEmail() failed: ' + results[i].errors[0].message);
        }
      }
    }

    return (hasFailures) ? false : true;
  }

}