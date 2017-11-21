public class dealreg {
    public String email {get;set;}
    public Contact contact {get;set;}
    public Account account {get;set;}
    public Lead lead {get;set;}
    public String companyName {get;set;}
    public Boolean renderForm {get;set;}
    public Boolean contactFound {get;set;}
    public Boolean contactNotFound {get;set;}
    public Boolean accountFound {get;set;}
    public Boolean accountNotFound {get;set;}
    String key = '6MspB43f4S5EkzpFvX9E6d9CVym4Z2FnGR9HhTVWW46zzxsvaD';
    public dealreg(){
        if(Apexpages.currentPage().getParameters().get('key') == key){
            renderForm = true;
            contactNotFound = true;
            accountFound = false;
            accountNotFound = true;
            if(Apexpages.currentPage().getParameters().get('email') != null){
                email = Apexpages.currentPage().getParameters().get('email');
                String leadEndUserRecTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('End User').getRecordTypeId();
                lead = new Lead(RecordTypeId=leadEndUserRecTypeId);
                //contactFound = findContactFromEmail(email);
                checkEmailDomainForAccount();
                System.debug('contactFound === '+contactFound);
                if(contactFound == true){
                    contactNotFound = false;
                    accountFound = true;
                    accountNotFound = false;
                }

                if(accountFound = true){
                    accountNotFound = false;
                }

            }
            else{
                account = new Account();
                contact = new Contact(AccountId= account.Id);
            }
        }
        else{

        }
    }

    public Boolean findContactFromEmail(String e){
        List <Contact> lstContact = [Select id,Account.Name,Account.Website,JobTitle__c, Name,
                                     Account.Id,Account.Phone,UserType__c,Email,FirstName,LastName,
                                     Account.BillingCity, Account.BillingState, Account.BillingCountry,
                                     Account.BillingStreet, Phone,AccountId,
                                     Account.BillingPostalCode, Company__c, MailingCity, MailingStreet,MailingCountry,
                                     MailingPostalCode, MailingState
                                     from Contact where Email=:e];
        if(lstContact.size()>0){
            contact = lstContact[0];
            account = new Account();
            account.id = contact.AccountId;
            return true;
        }
        else{
            account = new Account();
            contact = new Contact(AccountId= account.Id);
            return false;
        }
    }

    public void checkEmailDomainForAccount(){
        System.debug('email === ' +email);
        contactFound = false;
        contactNotFound = true;
        accountFound = false;
        accountNotFound = true;
        account = new Account();
        contact = new Contact(AccountId= account.Id);
        if(email != null){
            if(email.contains('@')){
                contactFound = findContactFromEmail(email);
                if(contactFound == false){
                  contact.email = email;
                    if(email.split('@').size() > 1){
                        System.debug('email.split(@).size() === '+ email.split('@').size());
                        System.debug('email.split(@).get(0) === '+ email.split('@').get(0));
                        System.debug('email.split(@).get(1) === '+ email.split('@').get(1));
                        String emailDomain = email.split('@').get(1);
                        System.debug('emailDomain === '+emailDomain);
                        if(emailDomain != null){
                            List<SObject> obj = Database.query('SELECT Id,Name,Website,Phone,BillingCity, BillingState, BillingCountry, BillingStreet, BillingPostalCode FROM Account WHERE Website LIKE \'%' + emailDomain + '%\'');
                            if(obj.size()>0){
                              system.debug('1');
                                account = (Account)obj[0];
                                contact.Account = account;
                                accountFound = true;
                                accountNotFound = false;
                            }
                            else{
                                accountFound = false;
                                accountNotFound = true;
                            }
                        }
                    }
                }
                else if (contactFound == true){
                    contactNotFound = false;
                    accountFound = true;
                    accountNotFound = false;
                }
            }
        }
    }

    public void continueAction(){
        if(account.id == null){
            try{
                insert account;
            }
            catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unable to create new Partner.'));
            }
        }
        if(contact.id == null){
            contact.AccountID = account.id;
            try{
                insert contact;
                String PartnerUserRecTypeId = Schema.SObjectType.User.getRecordTypeInfosByName().get('End User').getRecordTypeId();
                //User u = new User();
            }
            catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unable to create new Partner Contact.'));
            }
        }
        try{
            if(account.id != null){
                lead.Partner_Account__c = account.id;
            }
            if(contact.id != null){
                lead.Partner_Contact__c = contact.id;
            }
            lead.LeadSource = 'Deal Registration';
            insert lead;
            lead = new Lead();
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unable to create new Lead/deal.'));
        }
    }
}