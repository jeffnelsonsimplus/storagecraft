public with sharing class dealRegistration {
    public account a {get;set;}
    public contact c {get;set;}
    public lead l {get;set;}

    Public string email {get;set;}
    public boolean ready {get;set;}
    public boolean cOk {get;set;}
    public boolean aOk {get;set;}
    public void goPage(){
      cOk = false;
      aOk = false;
      if(Apexpages.currentPage().getParameters().get('key') != null && Apexpages.currentPage().getParameters().get('key') == '6MspB43f4S5EkzpFvX9E6d9CVym4Z2FnGR9HhTVWW46zzxsvaD'){
        ready = true;
        if(email == null && Apexpages.currentPage().getParameters().get('email') != null && Apexpages.currentPage().getParameters().get('email').contains('@') && Apexpages.currentPage().getParameters().get('email').contains('.')){
          email = Apexpages.currentPage().getParameters().get('email');
        }
        if(email != null){
          checkForContact();
        }
        else{
          cOk = false;
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please provide your email.'));
        }
        checkForAccount();
        if(!aOk){
          a = new account();
        }
        if(!cOk){
          c = new contact();
        }
        if(email != null && (!cOk || !aOk)){
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Please provide your contact information and press submit and you will be prompted to provide your deal registration information.'));
        }
        else{
          l = new lead();
        }
      }
      else{
        ready = false;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'There was an error loading this page. Please refresh. If the problem persists please contact your StorageCraft rep for assistance.'));
      }
    }
    public void submit(){
      if(email == null){
        checkForContact();
        goPage();
      }
      else{
        if(!aOk || !cOk){
          checkForContact();
          checkForAccount();
          try{
            if(!aOk){
              insert a;
            }
            if(!cOk){
                upsert c;
                email = c.email;
            }
            goPage();
          }
          catch(Exception badContact){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'There was a problem updating your contact information. Please contact your StorageCraft rep for assistance.'));
          }
        }
        else{
            try{
                Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;
            l.setOptions(dmo);
                l.Partner_Account__c = a.id;
                l.Partner_Contact__c = c.id;
                l.LeadSource = 'Deal Registration';
                list<recordtype> enduserlead = [select id from recordtype where sobjecttype = 'Lead' and name = 'End User' limit 1];
                if(enduserlead != null  && enduserlead.size() > 0){
                    l.recordtypeID = enduserlead[0].id;
                }
                insert l;
                ready = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Thank you for your deal registration submission. Your StorageCraft representative will be contacting you soon. Please refresh this page to submit another deal registration.'));
            }
            catch(Exception badLead){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'There was a problem submitting your deal reg. Please contact your StorageCraft rep for assistance.'));
            }
        }
      }
    }
    public void checkForContact(){
      if(c != null && c.email != null){
        email = c.email;
      }
      try{
          c = [select accountid, name,firstname,lastname,email,jobtitle__c,phone, MailingStreet, MailingCity, MailingState, MailingCountry, MailingPostalCode  from contact where email = : email order by createddate ASC limit 1];
          cOk = true;
      }
      catch(exception noContact){
          cOk = false;
      }
    }
    public void checkForAccount(){
      try{
          if(c != null && c.accountID != null){
              a = [select name from account where id = :c.accountID];
          }
          else{
              list<string>splitEmail = email.split('@',2);
              a = [select name from account where domain__c = :splitEmail[1]];
          }
          aOk = true;
      }
      catch(exception noAccount){
          aOk = false;
      }
    }
}