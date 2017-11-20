public class dealRegPageCompClass {

  public final dealregistration__c dealreg {get;set;}
  public  dealregistration__c dr {get;set;}
  public boolean approve {get;set;}
  public boolean reject {get;set;}
  public lead drl {get;set;}
  public opportunity dro {get;set;}

  public dealRegPageCompClass(ApexPages.StandardController controller) {
    this.dealreg = (dealregistration__c)controller.getRecord();
    fetchDealReg();
    if(dr.status__c != 'Pending Approval' && dr.status__c != 'Rejected'){
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'This Deal has been approved and is currently an opportunity'));
    }
    else if(dr.status__c == 'Rejected'){
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'This Deal has been rejected.'));
    }
    approve = false;
    reject = false;
  }
  public void approveDR(){
    fetchDealReg();
    if(dr.systemstatus__c == 'New'){
      try{
        drl = fetchlead();
        approve = true;
        confirmApprovalMessage();
      }
      catch(Exception leadqueryfailed){
        failedLeadQuery();
      }
    }
    else if(dr.systemstatus__c == 'Working'){
      try{
        dro = fetchOpp();
        approve = true;
        confirmApprovalMessage();
      }
      catch(Exception leadqueryfailed){
        failedOppQuery();
      }
    }
    else{
      somethingsAmiss();
    }
  }
  public void rejectDR(){
    try{
      drl = fetchlead();
      reject = true;
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Are you sure you want to reject this deal registration?'));
    }
    catch(Exception leadqueryfailed){
      failedLeadQuery();
    }
  }
  public void fetchDealReg(){
    dr = [select status__c,systemstatus__c,QualifiedBy__c,QualifiedDate__c,EndUserOpportunity__c,name from dealregistration__c where id = : dealreg.id];
  }
  public lead fetchLead(){
    return [select status,DomainAccountID__c,Company,Additional_Domain__r.Account__c,Additional_Domain__r.Account__r.Name from lead where dealregistration__c = : dr.id];
  }
  public opportunity fetchOpp(){
    return [select stagename,DealRegistration__c from opportunity where id = :dr.EndUserOpportunity__c];
  }
  public void failedLeadQuery(){
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There is an error with the deal registration lead. Please contact your system administrator.'));
  }
  public void failedOppQuery(){
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There is an error with the deal registration opportunity. Please contact your system administrator.'));
  }
  public void confirmApprovalMessage(){
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Are you sure you want to approve this deal registration?'));
  }
  public void somethingsAmiss(){
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Something went wrong. Please reload the page and try again. If you have seen this error more than once please contact your administrator.'));
  }
  public pagereference cancel(){
    PageReference ref = new PageReference('/apex/dealregpagecomp?id='+dr.id);
    ref.setredirect(true);
    return ref;
  }
  public pagereference submitApproval(){
    boolean success = false;
    if(dr.systemstatus__c == 'new'){
      success = convertDealReg();
    }
    else if(dr.systemstatus__c == 'working'){
      success = true;
    }
    else{
      somethingsAmiss();
    }
    if(success){
      string status = 'Working';
      setQualifier(status);
      PageReference ref = new PageReference('/apex/dealregpagecomp?id='+dr.id);
      ref.setredirect(true);
      return ref;
    }
    else{
      return null;
    }
  }
  public pagereference submitRejection(){
    drl.status = 'Rejected';
    update drl;
    string status = 'Rejected';
    setQualifier(status);
    PageReference ref = new PageReference('/apex/dealregpagecomp?id='+dr.id);
    ref.setredirect(true);
    return ref;
  }
  public void setQualifier(string status){
    dr.status__c = status;
    dr.QualifiedBy__c = UserInfo.getUserId();
    dr.QualifiedDate__c  = datetime.now();
    if(status == 'Working'){
      dr.ExpirationDate__c = date.today().adddays(60);
    }
    update dr;
  }
  public boolean convertDealReg(){
    List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
    LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
    Database.LeadConvert objLeadConvert = new Database.LeadConvert();
    //objLeadConvert.setDoNotCreateOpportunity(true);
    String convertedOppName = dr.name;
    objLeadConvert.setLeadId(drl.id);
    objLeadConvert.setConvertedStatus(convertStatus.MasterLabel);
    if(dr.EndUserOpportunity__c != null){
      objLeadConvert.setDoNotCreateOpportunity(true);
    }
    else{
      if(drl.DomainAccountID__c != null){
        objLeadConvert.setAccountId(drl.DomainAccountID__c);
      }
      if(drl.Additional_Domain__r.Account__r != null)
        convertedOppName = drl.Additional_Domain__r.Account__r.Name+' '+convertedOppName;
      else
        convertedOppName = drl.Company+' '+convertedOppName;
      objLeadConvert.setOpportunityName(convertedOppName);
    }
    leadsToConvert.add(objLeadConvert);
    List<Database.LeadConvertResult> leadConversionresult = convertLeads(leadsToConvert);
    if(leadConversionresult[0].isSuccess()){
      return true;
    }
    else{
      string errorMessage = 'Lead conversion failed due to error: '+(leadConversionresult[0].getErrors())[0].getMessage();
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
      return false;
    }
  }
  public static List<Database.LeadConvertResult> convertLeads(List<Database.LeadConvert> leadsToConvert){
    List<Database.LeadConvertResult> leadConversionResult = Database.convertLead(leadsToConvert, False);
    for (Database.LeadConvertResult lcr : leadConversionResult){
      System.Debug('@@@@@@@@-------------'+lcr);
    }
    return leadConversionResult;
  }
}
/*
Have conversion process update deal reg details? Perhaps hide conversion button and only allow through approval?
Set dr status on won or lost
*/