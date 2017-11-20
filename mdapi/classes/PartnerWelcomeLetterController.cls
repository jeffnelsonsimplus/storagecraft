/**
  \file         PartnerWelcomeLetterController.apxc
  \brief        Requests a new user on Partner Portal then sends Welcome letter.
  \details      JIRA ticket(s):
  \author       Loch MacLeod
  \version      1.5
  \date         11 September 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.3       2017-08-30  Matt Thompson-Moltzen   Changed references to User_Type__c to transactionTypesAsText__c (SSF-458).
  1.4       2017-09-11  Matt Thompson-Moltzen   Create a case and send an email upon Partner Portal invitation (SSF-610).
                                                Regress SSF-458 temporarily.
  1.5       2017-09-26  Loch MacLeod            SSF-529 Added better error handling
*/
public with sharing class PartnerWelcomeLetterController {
    public Id accountId {get; set;}
    public Id primaryContactId {get; set;}
    public String accountType {get; set;}
    public String languageNFRs {get; set;}
    public String language {get; set;}
    public Boolean emailMe {get; set;}
    public Boolean createNRFs {get; set;}
    public Boolean showDone {get; set;}
    public Boolean sentEmail {get; set;}
    public String message {get; set;}

    private Account workAccount;
    private Contact primaryContact;
    private PageReference pg;

    public PartnerWelcomeLetterController(ApexPages.StandardController controller) {
        showDone = false;
        emailMe = true;
        sentEmail = false;
        message = '';
        pg = (PageReference)controller.view();

        workAccount = (Account)controller.getRecord();
        accountId = workAccount.Id;
        accountType = workAccount.Type;

        createNRFs = (null == workAccount.NFR_ShadowProtect_Server_Serial__c ||
                      null == workAccount.NFR_ShadowProtect_Desktop_Serial__c ||
                      null == workAccount.NFR_ShadowProtect_SPX_Linux__c ||
                      null == workAccount.NFR_ShadowProtect_ImageManager_Serial__c);
        
        if (String.isBlank(workAccount.BillingCountry)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Account is missing address information.'));
            showDone = true;
        }

        if (workAccount.Primary_Contact__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Account needs a Primary Contact.'));
            showDone = true;
        } 
        else {
            primaryContact = (Contact)[
                SELECT Id, Email, FirstName, LastName, PartnerUserName__c, PartnerPassword__c
                FROM Contact
                WHERE id = :workAccount.Primary_Contact__c];
            
            if (String.isBlank(primaryContact.Email)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Primary Contact needs an email address.'));
                showDone = true;
            }
            
            if (!String.isBlank(primaryContact.PartnerUserName__c)) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Primary Contact already has a Partner Portal account.'));
            }
        }
    }

	public List<SelectOption> getLanguageOptions() {
        return Languages.selectOptions(false);
    }

  	public PageReference cancel() {
        return pg;
    }

    public PageReference createNFRKeys() {
        NFRKeys nfr = new NFRKeys();
        if (nfr.createPartnerBaseKeys(accountId, languageNFRs)) {
            createNRFs = false;
        }
        
        return null;
    }

  	public PageReference sendEmail() {
        try {
            PartnerPortal portal = new PartnerPortal();
            
            portal.newContact(primaryContact.Email, primaryContact.FirstName, primaryContact.LastName, 
                              workAccount.Name, workAccount.BillingCountry, workAccount.BillingState,
                              workAccount.BillingPostalCode, '', '', workAccount.Id);
            if (portal.Success) {
                if (portal.Error.startsWith('Contact already has Partner Portal access with given email address.')) {
                    message = portal.Error;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                } else {
                    message = 'Partner Portal access given to contact ' + primaryContact.FirstName + ' ' + primaryContact.LastName;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                }
                
                primaryContact.PartnerUserName__c = portal.UserName;
                primaryContact.PartnerPassword__c = portal.Password;
                update primaryContact;

                if ('US'.Equals(workAccount.BillingCountry) || 'CA'.Equals(workAccount.BillingCountry)) {
                    workAccount.Partner_Portal__c = 'https://partners.storagecraft.com';
                }
                else {
                    workAccount.Partner_Portal__c = 'https://partners.storagecraft.eu';
                }
                update workAccount;

                workAccount = (Account) [SELECT Id, Name, BillingCountry, AccountNumber, VAR_Agreement_Accepted__c, User_Type__c, Partner_Portal__c, transactionTypesAsText__c, StcZone_Global_Region__c FROM Account WHERE Id = :workAccount.Id];

                String template = findTemplate(language, workAccount.StcZone_Global_Region__c);
                
        System.debug('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
        System.debug('LANUGAGE: ' + language);
        System.debug('GLOBAL REGION: ' + workAccount.StcZone_Global_Region__c);
        System.debug('TEMPLATE: ' + template);
                
                EmailTemplate et = [SELECT id FROM EmailTemplate WHERE DeveloperName=:template];

                if (et != null) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTemplateId(et.id);
                    mail.setTargetObjectId(primaryContact.id);
                    mail.setWhatId(workAccount.Id);
                    mail.setUseSignature(false);
                    mail.setSaveAsActivity(true);
                    mail.setToAddresses(new String[] { primaryContact.Email });
                    if (emailMe) {
                        mail.setCcAddresses(new String[] { UserInfo.getUserEmail() });
                    }
                    
                    if (Stc.isProductionInstance()) {
                        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
                    }
                    else {
                        message = 'Did not send email. Testing.';
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                    }
                    
                    //
                    // SSF-610
                    //
                    System.debug('PartnerWelcomeLetterController::sendEmail(): create a case for OrderDesk');
                    Accounts accts = new Accounts();
                                       
                    accts.sendEmail(workAccount);      
                    accts.createCase(workAccount);

                    System.debug('sendEmail - Success');
                    sentEmail = true;
                    message = 'Email has been sent.';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, message));
                }
                else {
                    message = 'Did not send email.  Failed to create email template.';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
                }
            } 
            else {
                message = 'Did not send email.  Error: ' + portal.Error;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
            }
        } catch (Exception e) {
            message = 'Did not send email.  Error: ' + e.getMessage();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
        }
            
        showDone = true;
        return null;
  	}
    
    private String findTemplate(String language, String globalRegion) {        
        if ('French'.Equals(language)) {
            return 'Partner_Welcome_Letter_French';
        }
        if ('German'.Equals(language)) {
            return 'Partner_Welcome_Letter_German';
        }
        if ('Italian'.Equals(language)) {
            return 'Partner_Welcome_Letter_Italian';
        }
        if ('Japanese'.Equals(language)) {
            return 'Partner_Welcome_Letter_Japanese';
        }
        if ('Portuguese'.Equals(language)) {
            return 'Partner_Welcome_Letter_Portuguese';
        }
        
        if ('EMEA'.equals(globalRegion)){
            return 'Partner_Welcome_Letter_English_EMEA';
        }
           
        return 'Partner_Welcome_Letter_English';
    }
}