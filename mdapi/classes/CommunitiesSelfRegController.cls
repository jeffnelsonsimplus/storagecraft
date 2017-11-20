/**
  \file
  \brief        An apex page controller that supports self registration of users in the community matching to existing contacts and accounts
  \details      JIRA ticket(s): SSF-615
  \author       Nephi Printy
  \version      1.1
  \date         20 Sept 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
*/

public class CommunitiesSelfRegController {

    public Contact objContact               {get;set;}
    public String zipErrorLabel {get;set;}
    public String selectedCountry           {
        get;
        set
        {
            this.selectedCountry = value;

            objContact.MailingCountry = this.selectedCountry;
            selectedCountryISO = CountryUtility.mapCountryByAll.get(this.selectedCountry);
            if(selectedCountryISO != null && selectedCountryISO.postalCodeExample__c != null){
                zipErrorLabel = String.format(Label.ERROR_INVALID_POSTAL_CODE, new List<String>{selectedCountryISO.postalCodeExample__c});
            } else {
                zipErrorLabel = '';
            }
        }
    }
    public Country_ISO_Map__c selectedCountryISO {get;set;}
    public List<SelectOption> lstStates {
        get{
            List<SelectOption> stateOptions = new List<SelectOption>();
            if(selectedCountryISO != null && selectedCountryISO.statesProvinces__c != null){
                for( String s : selectedCountryISO.statesProvinces__c.split(',') ){
                    stateOptions.add(new SelectOption(s,s));
                }
            }
            return stateOptions;
        }
        set;
    }

    public List<SelectOption> lstCountries  {get;set;}
    public String selectedLanguage { get; set; }

    public String firstName {get; set;}
    public String lastName {get; set;}
    public String password {get; set {password = value == null ? value : value.trim(); } }
    public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    public String companyname { get; set; }
    
    public CommunitiesSelfRegController() {

        objContact = new Contact();
        selectedCountry = ApexPages.currentPage().getParameters().containsKey('countryname') ?
                ApexPages.currentPage().getParameters().get('countryname') : 'US';
        
        selectedLanguage = ApexPages.currentPage().getParameters().containsKey('language') ?
                ApexPages.currentPage().getParameters().get('language') : 'en_US';
                
        lstCountries = new List<SelectOption>();
        for(Country_ISO_Map__c cim : CountryUtility.countries.values()){
            lstCountries.add(new SelectOption(cim.alpha2Code__c, cim.Name));
        }

    }

    public Pagereference changeCountry(){
        objContact.MailingCountry = selectedCountry;
        // return new Pagereference('/apex/CommunitiesSelfReg?countryname='+selectedCountry);
        return null;
    }

    private boolean isValidPassword() {
        return password == confirmPassword;
    }
    
    private boolean listFind(List<String> a, String b){
        Set<String> tempSet = new Set<String>();
        tempSet.addAll(a);
        return tempSet.contains(b);
        }

    public PageReference registerUser() {
           // it's okay if password is null - we'll send the user a random password in that case
        if (!isValidPassword()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, Label.site.passwords_dont_match);
            ApexPages.addMessage(msg);
            return null;
        }

        Id accountId = [SELECT Id FROM Account WHERE Name = 'Support Community Account' LIMIT 1].Id;
        String userName = objContact.email;
        User u = new User();
        list<User> ExistingUser = [SELECT Name FROM User WHERE username = :userName OR CommunityNickName = :communityNickname];

        if (Site.IsValidUsername(userName) == True && ExistingUser.size() == 0) {
            u.Username = userName;
        } else {
            String errMsg;
            errMsg = 'Registration Failure:  Username ' + userName + ' or Nickname ' + communityNickname + ' is invalid or reserved, please try again';
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, errMsg, '');
            ApexPages.addMessage(msg);
            return null;
        }
        
        List<Contact> existingContact = [SELECT Id, AccountId FROM Contact WHERE Email = :userName];
        if(existingContact.size() > 0)
        {
            objContact.id = existingContact[0].Id;
            accountId = existingContact[0].AccountId;
        }

        if(objContact.id == null)
        {
            existingContact = [SELECT Id, AccountId FROM Contact WHERE EmailAddress2__c = :userName];
            if(existingContact.size() > 0)
            {
                objContact.id = existingContact[0].Id;
                accountId = existingContact[0].AccountId;
            }
        }

        if(objContact.id == null)
        {
            existingContact = [SELECT Id, AccountId FROM Contact WHERE EmailAddress3__c = :userName];
            if(existingContact.size() > 0)
            {
                objContact.id = existingContact[0].Id;
                accountId = existingContact[0].AccountId;
            }
        }

        if(objContact.id == null)
        {
            String domain = userName.split('@').get(1);
            List<String> genEmailMap = new List<String>();
            List<Generic_Email_List__c> genEmail = [SELECT Name FROM Generic_Email_List__c];
            for(Generic_Email_List__c gen : genEmail){
                genEmailMap.add(String.valueof(gen.Name));
                }
            
            if(!listFind(genEmailMap,domain))
                { 
                List<Account> existingAccount = [SELECT Id FROM Account WHERE Domain__c = :domain];
                if(existingAccount.size() > 0)
                {
                    accountId = existingAccount[0].Id;
                }
            }
        }

        u.Email = objContact.email;
        u.FirstName = objContact.firstName;
        u.LastName = objContact.LastName;
        u.CommunityNickname = communityNickname;
        
        u.CompanyName = companyname;
        u.Phone = objContact.Phone;
        u.Country = objContact.MailingCountry;
        u.State = objContact.MailingState;
        u.City = objContact.MailingCity;
        u.PostalCode = objContact.MailingPostalCode;
		u.LanguageLocaleKey = selectedLanguage;
        
        if(accountId == null) 
        {
            List<Account> CommAccount = [SELECT Id FROM Account WHERE Name = 'Support Community Account'];
            accountId = CommAccount[0].Id;
        }

        u.ProfileId = [SELECT Id FROM Profile WHERE Name = 'Support Community Login User Standard'].id;

        if(objContact.id != null)
        {
            ContactTriggerHandler.isDisabled = true;
            u.ContactId = objContact.id;
        }
        else
        {
            if(ExistingUser.size() == 0){
                objContact.AccountId = accountId;
                ContactTriggerHandler.isDisabled = true;
                insert objContact;
                u.ContactId = objContact.id;
            }
        }

        String userId;
        String Failed;
        Boolean RegisterFail = False;

        try {
            userId = Site.createExternalUser(u, accountId);
        } catch(Site.ExternalUserCreateException ex) {
            RegisterFail = True;
            List<String> errors = ex.getDisplayMessages();
            for (String error : errors)  {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, error, ''));
            }
            System.debug(ex.getMessage());
            return null;
        }

        if (RegisterFail == False) {
            string envBaseUrl = Site.getBaseUrl();
            PageReference page = new PageReference(envBaseUrl + '/s/login/CheckPasswordResetEmail?language=' + selectedLanguage);
            page.setRedirect(true);
            return page;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'Registration Failed', ''));
            return null;
        }
    }
}