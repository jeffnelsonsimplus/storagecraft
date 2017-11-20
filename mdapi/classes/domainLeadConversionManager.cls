public class domainLeadConversionManager {
  public final additional_domain__c domain {get;set;}
  PageReference returnURL;
  public lead l {get;set;}

  public domainLeadConversionManager(ApexPages.StandardController controller) {
    this.domain = (additional_domain__c)controller.getRecord();
  }
  Public PageReference loadPage(){
    system.debug('A:');
    if(ApexPages.currentPage().getParameters().get('lID') != null){
      system.debug('B:');
      try{
        system.debug('C:');
        l = [select firstname, lastname, email, phone,additional_domain__r.name,additional_domain__r.account__r.name, convertedaccountID,convertedopportunityID from lead where id = : ApexPages.currentPage().getParameters().get('lID')];
        if(l.convertedopportunityID != null){
          returnURL = new PageReference('/'+l.convertedopportunityID);
        }
        else if(l.convertedaccountID != null){
          returnURL = new PageReference('/'+l.convertedaccountID);
        }
        else{
          returnURL = new PageReference('/'+ApexPages.currentPage().getParameters().get('lID'));
        }
        try{
          system.debug('D');
          string message = 'You converted the lead ';
          if(l.firstname != null){
            message = message+l.firstname+' ';
          }
          if(l.firstname != null){
            message = message+l.lastname+' ';
          }
          if(l.email != null){
            message = message+l.email+' ';
          }
          if(l.phone != null){
            message = message+l.phone+' ';
          }
          message = message+'. There are other leads associated to the domain "'+l.additional_domain__r.name+'". Please select the leads you would like to convert to contacts on the domain\'s account "'+l.additional_domain__r.account__r.name+'".';
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,message));
        }
        catch(exception messagefailure){system.debug('E:');}
      }
      catch(exception badquery){
        system.debug('F:');
        returnURL = new PageReference('/'+ApexPages.currentPage().getParameters().get('lID'));
      }
    }
    else if(ApexPages.currentPage().getParameters().get('ID') != null){
      system.debug('G:');
      returnURL = new PageReference('/'+ApexPages.currentPage().getParameters().get('id'));
    }
    else{
      system.debug('H:');
      returnURL = new PageReference(ApexPages.currentPage().getUrl());
      returnURL.setRedirect(true);
    }
    system.debug('I:');
    getLeads();
    if(wls.isempty() && ApexPages.currentPage().getParameters().get('lID') != null){
      system.debug('J:');
      return returnURL;
    }
    else{
      system.debug('K:');
      return null;
    }
  }
  public class wl{
    public lead l {get;set;}
    public boolean selected {get;set;}
    public wl(lead li){
      l = li;
      selected = false;
    }
  }
  public list<wl> wls {get;set;}

  Public list<wl> getLeads(){
    if(wls == null){
      wls = new list<wl>();
      for(lead l:[select name, firstname, lastname, email, phone, createddate, lastmodifieddate, description,DomainAccountID__c,conversionlog__c from lead where additional_domain__c = : domain.id and isconverted = false]){
        wls.add(new wl(l));
      }
    }
    return wls;
  }
  public pagereference convertSelectedLeads(){
    list<lead> selectedLeads = new list<lead>();
    for(wl wli:getLeads()){
      if(wli.selected){
        selectedLeads.add(wli.l);
      }
    }
    if(selectedleads.isempty()){
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select a lead to process'));
      return null;
    }
    else{
      List<Database.LeadConvertResult> lcrs = domainmanager.convertLeadsToContacts(selectedLeads);
      map<id,string> leadConversionLogMap = new map<id,string>();
      for(Database.LeadConvertResult lcr:lcrs){
        if(!lcr.Success){
          string thisError = 'Lead Conversion Failed | ';
          if(!lcr.errors.isempty()){
            for(Database.error e:lcr.errors){
              thisError += e.message +' | ';
            }
          }
          leadConversionLogMap.put(lcr.leadId, thisError);
        }
      }
      if(!leadConversionLogMap.isempty()){
        list<lead> failedToConvertLeads = new list<lead>();
        for(wl wli:wls){
          if(leadConversionLogMap.containskey(wli.l.id)){
            wli.l.conversionlog__c = leadConversionLogMap.get(wli.l.id);
            failedToConvertLeads.add(wli.l);
          }
        }
        update failedToConvertLeads;
      }
      return returnURL;
    }
  }
}