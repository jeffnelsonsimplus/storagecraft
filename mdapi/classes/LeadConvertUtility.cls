global class LeadConvertUtility {

  /**
   * Method to convert Lead into Contact on Button
   */
    WebService static String convertLeadsToConts(Id leadId,Id accId, Id domainId) {
        List<Lead> listLeadsToBeConverted = new List<Lead>{new Lead(Id=leadId,Additional_Domain__c=domainId)};
        Map<String,Additional_Domain__c> mapAdditionalDomain = new Map<String,Additional_Domain__c>();
        Additional_Domain__c objAdditionalDomain = new Additional_Domain__c(Id=DomainId,Account__c=accId);
        mapAdditionalDomain.put(domainId,objAdditionalDomain);
        List<Database.LeadConvertResult> lstLeadConverts = convertLeadsToConts(listLeadsToBeConverted,mapAdditionalDomain);
        String convertResult;
        if(lstLeadConverts[0].isSuccess())
            convertResult = 'Lead has successfully converted';
        else
            convertResult = 'Lead conversion failed due to error: '+(lstLeadConverts[0].getErrors())[0].getMessage();
            system.debug('convertResult----'+convertResult);
        return convertResult;
    }


  /**
   * Method to convert Leads into Contacts
   */
  public static List<Database.LeadConvertResult> convertLeadsToConts(List<Lead> listLeadsToBeConverted,Map<String,Additional_Domain__c> mapAdditionalDomain) {
     List<Database.LeadConvert> lstLeadConverts = new List<Database.LeadConvert>();
     LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
     for(Lead objLead: listLeadsToBeConverted) {
         Database.LeadConvert objLeadConvert = new Database.LeadConvert();
         if(mapAdditionalDomain.containsKey(objLead.Domain__c) && mapAdditionalDomain.get(objLead.Domain__c).Account__c<>null)
            objLeadConvert.setAccountId(mapAdditionalDomain.get(objLead.Domain__c).Account__c);
         else if(mapAdditionalDomain.containsKey(objLead.Additional_Domain__c) && mapAdditionalDomain.get(objLead.Additional_Domain__c).Account__c<>null)
            objLeadConvert.setAccountId(mapAdditionalDomain.get(objLead.Additional_Domain__c).Account__c);
        //
         objLeadConvert.setDoNotCreateOpportunity(true);
         objLeadConvert.setLeadId(objLead.Id);
         objLeadConvert.setConvertedStatus(convertStatus.MasterLabel);
         lstLeadConverts.add(objLeadConvert);
     }
     List<Database.LeadConvertResult> lstLeadConvResult = Database.convertLead(lstLeadConverts, False);
     for (Database.LeadConvertResult lcr : lstLeadConvResult)
       {
           System.Debug('@@@@@@@@-------------'+lcr);
       }
     return lstLeadConvResult;
  }

    public static void confirmCleaned(List<Lead> oldLeads, List<Lead> newLeads) {
        System.debug('LeadConvertUtility.confirmCleaned()');
        
        Integer i = -1;
        for (lead l : newLeads) {
            System.debug('+    Name: ' + l.Name + '  Country: ' + l.Country);
            
            i++;
            Lead oldLead = oldLeads[i];

            if (oldLead.IsConverted != l.IsConverted && l.IsConverted) {  
                System.debug('+   CleanStatus: old: ' + oldLead.CleanStatus + '   new: ' + l.CleanStatus);
                
                if ('Pending'.Equals(oldLead.CleanStatus)) {                  
                    if ('US:CA'.Contains(l.Country)) {
                        System.debug('+   Clean has not been run.');
                        l.CleanStatus.addError('You must run Clean before you are allowed to convert a Lead.');
                    }
                    else {
                        System.debug('+   Country not US or CA');
                    }
                }
                else {
                    System.debug('+   CleanStatus not Pending');
                }
            }
            else {
                System.debug('+   Not Convert(ing)');
            }
        }
    }
}