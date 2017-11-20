/**
  \file
  \brief        This class will implement Account related functions
  \details      JIRA ticket(s): SSF-89, SSF-399, SSF-458, SSF-447
  \author       Matt Thompson-Moltzen
  \version      1.9
  \date         26 September 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.0				2017-08-09	Matt Thompson-Moltzen		Original code.
  1.1       2017-08-22  Matt Thompson-Moltzen   Re-enabled SSF-447 code.
  1.2       2017-08-24  Matt Thompson-Moltzen   Agreement type 'VAR' is now deprecated and replaced by 'Reseller' (SSF-533).
                                                Re-ordered the logic in setType() and setTransactionTypes() functions to reduce SOQL calls.
  1.3       2017-08-30  Matt Thompson-Moltzen   Logic from retired AccountAgreementManager class moved to here (SSF-584).
  1.4       2017-08-31  Loch MacLeod            Fixes for tests which create accounts:  AccountAgreementManager, AcademyCertificateManagerTest, AccountPrimaryContactTest, etc.
                                                Null test on pp1 and pp2, isBlank used on old/new AccountNumber, no HTTP call during testing
  1.5       2017-09-04  Matt Thompson-Moltzen   Added call to Test.setMock() in updatePartnerPortal().
  1.6       2017-09-11  Matt Thompson-Moltzen   Create a case and send an email upon Partner Portal invitation (SSF-610).
  1.7       2017-09-12  Matt Thompson-Moltzen   Set the Distributor record type previously set in a Workflow Rule (SSF-583).
  1.8       2017-09-26  Matt Thompson-Moltzen   Re-enable processing of the Transaction Type field (SSF-458).
  1.9       2017-10-03  Loch MacLeod            SSF-458 "Other" only shows when it is the only Transaction Type
*/
public with sharing class Accounts
{
	//
	// variables
	//
	private String usPartnerPortal;
	private String worldPartnerPortal;

  private Set<String> agreementTypes;
	private Set<String> usPortalCountries;

  private RecordType typeDistributor;
  private RecordType typeEndUser;
  private RecordType typePartner;

	//
	// constructor
	//
	public Accounts()
	{
		partnerPortals__c pp1 = partnerPortals__c.getInstance('US Partner Portal');
		partnerPortals__c pp2 = partnerPortals__c.getInstance('World Partner Portal');

		if (pp1 != null) { usPartnerPortal 	  = pp1.partnerPortalUrl__c; }
		if (pp2 != null) { worldPartnerPortal = pp2.partnerPortalUrl__c; }

		//System.debug('Accounts::constructor() US Partner Portal URL:' + usPartnerPortal);
		//System.debug('Accounts::constructor() World Partner Portal URL:' + worldPartnerPortal);

		usPortalCountries = new Set<String>();

		usPortalCountries.add('US');
		usPortalCountries.add('CA');
		usPortalCountries.add('AU');
		usPortalCountries.add('NZ');

		System.assertEquals(4, usPortalCountries.size());

		agreementTypes = new Set<String>();
		agreementTypes.add('Distribution Partner');
		agreementTypes.add('Managed Service Provider (MSP)');
		agreementTypes.add('Original Equipment Manufacturer (OEM)');
		agreementTypes.add('Value Added Reseller (VAR)');

		System.assertEquals(4, agreementTypes.size());

    //
    // SSF-584
    //
    typeDistributor = null;
    typeEndUser     = null;
    typePartner     = null;

    List<RecordType> typs = [SELECT Id, Name FROM RecordType WHERE sObjectType = 'Account'];

    for (RecordType t : typs) {
        if      (t.Name == 'Distributor') { typeDistributor = t; }
        else if (t.Name == 'End User')    { typeEndUser     = t; }
        else if (t.Name == 'Partner')     { typePartner     = t; }
    }

    System.assert(typeDistributor != null);
    System.assert(typeEndUser != null);
    System.assert(typePartner != null);
	}

	//
	// member functions
	//
	public void checkAccountNumber(List<Account> oldAccounts, List<Account> newAccounts)
	{
		Addresses addrs = new Addresses();

		Integer i = 0;

		for (Account a : newAccounts) {
			String country = '';

			if (a.BillingCountry != null) {
				if (a.BillingCountry.length() == 2) { country = a.BillingCountry; }
				else 																{ country = addrs.getIsoCode(a.BillingCountry); }
			}

			if (oldAccounts == null) {																																				// is an insert
				if (a.AccountNumber != null) {
					String url  	 = '';

					if (usPortalCountries.contains(country)) { url = usPartnerPortal + '/services/createUser'; }
					else 													    			 { url = worldPartnerPortal + '/services/createUser'; }

					JSONGenerator document = JSON.createGenerator(false);

					document.writeStartObject();
					document.writeStringField('requestType', 'UPDATE_NAV_ID');
					document.writeFieldName('userInfo');

					document.writeStartObject();
					document.writeStringField('salesforceAccountId', a.id);
					document.writeStringField('accountNumber', a.AccountNumber);
					document.writeEndObject();

					document.writeEndObject();

					String body = document.getAsString();

					document.close();

					updatePartnerPortal(url, body, 'salesforce', 'password');
				}
			}
			else {
				String oldAccountNumber = (String)oldAccounts.get(i).get('AccountNumber');

				if (String.isBlank(oldAccountNumber)) { oldAccountNumber = '0'; }

				String newAccountNumber = '';

				if (String.isBlank(a.AccountNumber)) { newAccountNumber = '0'; }												// must return the number zero
				else 												         { newAccountNumber = a.AccountNumber; }

				if (newAccountNumber != oldAccountNumber) {
					String url  	 = '';

					if (usPortalCountries.contains(country)) { url = usPartnerPortal + '/services/createUser'; }
					else 													 				   { url = worldPartnerPortal + '/services/createUser'; }

					JSONGenerator document = JSON.createGenerator(false);

					document.writeStartObject();
					document.writeStringField('requestType', 'UPDATE_NAV_ID');
					document.writeFieldName('userInfo');

					document.writeStartObject();
					document.writeStringField('salesforceAccountId', a.id);
					document.writeStringField('accountNumber', newAccountNumber);
					document.writeEndObject();

					document.writeEndObject();

					String body = document.getAsString();

					document.close();

					updatePartnerPortal(url, body, 'salesforce', 'password');
				}
			}

			i++;
		}
	}

  public Boolean createCase(Account acct)
  {
    Boolean hasFailures = false;

    Group queue   = [SELECT Id, DeveloperName FROM Group WHERE (Type = 'Queue' AND DeveloperName = 'OrderDesk')];

    System.assert(queue != null, 'Accounts::createCase(): unable to retrieve specified Queue object details for: ' + 'OrderDesk');

    String body = 'A Partner Portal invite has been sent to the account ' + acct.Name + '. Please review and process the account setup.\r\n\r\n';

    body += 'User Type:       ' + acct.transactionTypesAsText__c + '\r\n';
    body += 'Billing Country: ' + acct.BillingCountry + '\r\n';
    body += 'Assigned Portal: ' + acct.Partner_Portal__c + '\r\n\r\n';

    List <Case> cases = new List<Case>();

    Case c = new Case();

    c.OwnerId             = queue.Id;

    c.AccountId           = acct.Id;

    if (acct.BillingCountry != null) {
      Addresses addrs = new Addresses();

      c.Country__c = addrs.getCountryName(acct.BillingCountry);
    }

    //
    // Since Transaction Types on Account is a Multi-Picklist, only the last value will be set excluding agreement types (as 'Channel Partner' encompases these types)
    //
    c.Select_User_Type__c ='Other';                                             // set as a default - ok to be overwritten

    List<String> typs = acct.transactionTypesAsText__c.split(';');

    for (String t : typs) {
      if (agreementTypes.contains(t) == false) { c.Select_User_Type__c = t; }
    }

    c.Origin              = 'Customer Setup';
    c.Status              = 'New';
    c.Priority            = 'Medium';
    c.Type                = 'Order Entry';
    c.Subject             = 'New Account setup: ' + acct.Name;
    c.Description         = body;

    cases.add(c);

    try {
      insert cases;
    }
    catch (DMLException e) {
      System.debug(LoggingLevel.ERROR, 'Accounts::createCase() exception: ' + e.getMessage());
    }

    return (hasFailures) ? false : true;
  }

  public Boolean sendEmail(Account acct)
  {
    Boolean hasFailures = false;

    String toAddress = '';

    if (Stc.isProductionInstance()) { toAddress = 'DL-OrderDesk@storagecraft.com'; }
    else                            { toAddress = 'matt.tm@storagecraft.com.au'; }

    List<OrgWideEmailAddress> owea = [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress WHERE Address = 'crm@storagecraft.com'];

    List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();

    Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

    List<String> toAddresses = new List<String>();

    toAddresses.add(toAddress);

    String subject = 'ACTION: New Account setup ' + acct.Name;
    String body    = 'A Partner Portal invite has been sent to the account ' + acct.Name + '. Please review and process the account setup.\r\n\r\n';

    body += 'User Type:       ' + acct.User_Type__c + '\r\n';
    body += 'Billing Country: ' + acct.BillingCountry + '\r\n';
    body += 'Assigned Portal: ' + acct.Partner_Portal__c + '\r\n\r\n';

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
        System.debug(LoggingLevel.ERROR, 'Accounts::sendEmail() exception: ' + e.getMessage());

        return false;
      }

      Integer i = 0;

      for (i = 0; i < results.size(); i++) {
        if (results[i].isSuccess() == false) {
          hasFailures = true;
          System.debug(LoggingLevel.ERROR, 'Accounts::sendEmail() failed: ' + results[i].errors[0].message);
        }
      }
    }

    return (hasFailures) ? false : true;
  }

  private void setRecordType(Account acct)
  {
    if      (acct.AccountNumber != null ||
             acct.VAR_Agreement_Accepted__c == true)                                      { acct.RecordTypeId = typePartner.Id; }
    else if (acct.transactionTypesAsText__c == null)                                      { acct.RecordTypeId = typePartner.Id; }
    else if (acct.transactionTypesAsText__c.contains('Distribution Partner') ||
             acct.transactionTypesAsText__c.contains('Distributors Partner Reseller') ||
             acct.transactionTypesAsText__c.contains('International Master Distributor')) { acct.RecordTypeId = typeDistributor.Id; }
    else if (acct.transactionTypesAsText__c.contains('Business User') ||
             acct.transactionTypesAsText__c.contains('Home User'))                        { acct.RecordTypeId = typeEndUser.Id; }
    else                                                                                  { acct.RecordTypeId = typePartner.Id; }
  }

  //
  // setTransactionTypes
  //
  private void setTransactionTypes(Account acct, List<Agreement__c> agts)
  {
    System.debug('Accounts.setTransactionTypes');

    // load the transactionTypes__c picklist values and create sets for Enterprise and SMB types
    Schema.DescribeFieldResult dfr = Account.transactionTypes__c.getDescribe();
    List<Schema.PicklistEntry> pes = dfr.getPicklistValues();

    Set<String> enterpriseTyps = new Set<String>();
    Set<String> smbTyps        = new Set<String>();

    for (Schema.PicklistEntry pe : pes) {
      if (pe.getValue() == 'Business User' || pe.getValue() == 'Trial User')  { enterpriseTyps.add(pe.getValue()); }
      else if (pe.getValue() == 'Other')                                      { }
      else                                                                    { smbTyps.add(pe.getValue()); }
    }
        
    System.debug('TRANSACTION TYPE: *' + acct.transactionTypesAsText__c + '*');
    if (String.isBlank(acct.transactionTypesAsText__c) || 'Other'.equals(acct.transactionTypesAsText__c)) { 
        System.debug('User_Type__c: ' + acct.User_Type__c);
        
        if (acct.User_Type__c != null) {
        // Either new account or Transaction Types are to be reinitialized
        String t = '';
        if (acct.User_Type__c == 'Other')                    { }                        // Do not include "Other"
        else if (acct.User_Type__c == 'Both MSP and VAR')    { t = 'Channel Partner'; } // has one of the agreement types potentially
        else if (agreementTypes.contains(acct.User_Type__c)) { t = 'Channel Partner'; } // has one of the agreement types potentially
        else                                                 { t = acct.User_Type__c; }

        System.debug('TRANSACTION TYPE: ' + t);
        acct.transactionTypes__c       = t;
        acct.transactionTypesAsText__c = t;
      }
    }

    List<String> types;
    if (String.isBlank(acct.transactionTypes__c))  { types = new List<String>(); }
    else                                           { types = acct.transactionTypes__c.split(';'); }
    
    for (Integer i = types.size() - 1; i >= 0; i--) {
        if ('Other'.equals(types[i])) {
            types.remove(i);
        }
    }

    Set<String> typs = new Set<String>();
    typs.addAll(types);

    // remove all agreement types as these will be determined
    if (typs.removeAll(agreementTypes)) { typs.add('Channel Partner'); }

    if (acct.Id != null) {                                                      // pointless on an INSERT
      Integer nMsp          = 0;
      Integer nOem          = 0;
      Integer nVar          = 0;
      Integer nDistribution = 0;

        System.debug('Number Agreements: ' + agts.size());
      for (Agreement__c agt : agts) {
        if      (agt.Type__c == 'Cloud')        { nMsp++; }
        else if (agt.Type__c == 'MSP')          { nMsp++; }
        else if (agt.Type__c == 'Master MSP')   { nMsp++; }
        else if (agt.Type__c == 'OEM')          { nOem++; }
        else if (agt.Type__c == 'Reseller')     { nVar++; }                     // SSF-533
        else if (agt.Type__c == 'VAR')          { nVar++; }                     // deprecated in SSF-533
        else if (agt.Type__c == 'Distribution') { nDistribution++; }
      }

      if (nMsp > 0)          { typs.add('Channel Partner'); typs.add('Managed Service Provider (MSP)'); }
      if (nOem > 0)          { typs.add('Channel Partner'); typs.add('Original Equipment Manufacturer (OEM)'); }
      if (nVar > 0)          { typs.add('Channel Partner'); typs.add('Value Added Reseller (VAR)'); }
      if (nDistribution > 0) { typs.add('Channel Partner'); typs.add('Distribution Partner'); }
    }

    types.clear();
    types.addAll(typs);

    //
    // ensure that types selected are either Enterprise or SMB but not both
    //
    Boolean hasEnterpriseTypes = false;
    Boolean hasSmbTypes        = false;

    for (String s : types) {
        if (enterpriseTyps.contains(s)) { hasEnterpriseTypes = true; }
        if (smbTyps.contains(s))        { hasSmbTypes = true; }
    }

    if (hasEnterpriseTypes && hasSmbTypes) {
      acct.transactionTypes__c.addError(System.Label.ERROR_CONFLICTING_TRANSACTION_TYPES);

      return;
    }

    if (types.size() == 0) {
      types.add('Other');
    }

    String s = String.join(types, ';');

    acct.transactionTypes__c       = s;
    acct.transactionTypesAsText__c = s;
  }


	public void setTypes(List<Account> oldAccounts, List<Account> newAccounts)
	{
    if (oldAccounts == null) {                                                  // is an INSERT so this is simple; no Opportunities or Agreements will exist
      for (Account acct : newAccounts) {
        //
        // SSF-89, SSF-399
        //
        if (acct.AccountNumber != null) { acct.Type = 'Account'; }
        else                            { acct.Type = 'Prospect'; }

        setTransactionTypes(acct, null);
        setRecordType(acct);
      }
    }
    else {
      Map<Id, Account> mapAccts = new Map<Id, Account>(newAccounts);
      Set<Id>          acctIds  = new Set<Id>(mapAccts.keySet());

      Map<Id, Account> mapOldAccts = new Map<Id, Account>(oldAccounts);

      //
      // The list that will be returned is a copy of newAccounts with added sub-query lists, so we cannot operate on it (i.e. it is pointless updating fields).
      // It is used to overcome governer limits by placing all in the one SELECT statement. Additionally note that we cannot rely on the order returned matching
      // the newAccounts order, hence we must use the mapAccts to operate on the actual Account object that is the subject of the UPDATE.
      //
      List<Account> accts = [SELECT Id,
                            (SELECT Id, StageName FROM Opportunities WHERE (StageName = 'Closed Won')),
                            (SELECT Id, Type__c, Status__c FROM Agreements__r WHERE (Status__c NOT IN ('Inactive', 'Terminated', 'Expired')))
                            FROM Account WHERE Id IN :acctIds];

  		for (Account a : accts) {
//  System.debug('Accounts::setTypes() Account: ' + a);
//  System.debug('Accounts::setTypes() a.Opportunities: ' + a.Opportunities);
//  System.debug('Accounts::setTypes() a.Agreements__r: ' + a.Agreements__r);

        //
        // operate on the newAccounts object only!
        //
        Account acct = mapAccts.get(a.Id);

  			//
  			// SSF-89, SSF-399
  			//
  			if      (acct.AccountNumber != null) { acct.Type = 'Account'; }
        else if (a.Opportunities.size() > 0) { acct.Type = 'Transacting Account'; }
        else                                 { acct.Type = 'Prospect'; }

  			setTransactionTypes(acct, a.Agreements__r);

        //
        // SSF-584
        //
        Account oldAcct = mapOldAccts.get(a.Id);

        if (acct.AccountNumber == null && oldAcct.AccountNumber != null) {
          System.debug('Accounts::setTypes() AccountNumber cleared');
          acct.VAR_Agreement_Accepted__c = false;
        }

        setRecordType(acct);
      }
    }
	}

	@future (callout=true)
	@TestVisible
	private static void updatePartnerPortal(String url, String body, String username, String password)
	{
		System.debug('url: ' + url);
		System.debug('body: ' + body);

		HttpRequest request = new HttpRequest();

		request.setEndPoint(url);
		request.setMethod('POST');

    if (username != null) {
      Blob usernamePassword = Blob.valueOf(username + ':' + password);

      request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(usernamePassword));
    }

    request.setHeader('Cache-Control', 'no-cache');
    request.setHeader('Connection', 'keep-alive');

    Integer n = body.length();

    request.setHeader('Content-Length', String.valueOf(n));

		request.setHeader('Content-Type', 'application/json');

    DateTime dt = Datetime.now();

		request.setHeader('Date', dt.formatGmt('EEE, d MMM yyyy HH:mm:ss \'GMT\''));  // Tue, 15 Nov 1994 08:12:31 GMT

    Url u = new Url(url);

    if (u.getPort() > 0) { request.setHeader('Host', u.getHost() + ':' + u.getPort()); }
    else                 { request.setHeader('Host', u.getHost()); }

    request.setBody(body);

		Http http = new Http();

    if (Test.isRunningTest()) { Test.setMock(HttpCalloutMock.class, new AccountsHttpCalloutMock()); }

		try {
			HttpResponse status = http.send(request);

      if (status.getStatusCode() == 200) {
        System.debug(LoggingLevel.INFO, 'Accounts::updatePartnerPortal() call to Http::send() successful: (' + status.getStatusCode() + ') ' + status.getStatus());
        System.debug(LoggingLevel.INFO, 'Accounts::updatePartnerPortal() response: ' + status.getBody());
      }
      else {
        System.debug(LoggingLevel.ERROR, 'Accounts::updatePartnerPortal() call to Http::send() failed: (' + status.getStatusCode() + ') ' + status.getStatus());
      }
		}
		catch (System.CalloutException e) {
			System.debug(LoggingLevel.ERROR, 'Accounts::updatePartnerPortal() exception: ' + e.getMessage());
		}
	}

}