trigger AdditionalDomainTrigger on Additional_Domain__c (before insert, before update, after update) {
  map<id,Additional_Domain__c> domainMap = new map<id,Additional_Domain__c>();
  if(trigger.isbefore){
    set<string> domainsSet = new set<string>();
    for(Additional_Domain__c d:trigger.new){
      if(d.name != null && d.name != '' && (trigger.isInsert || (trigger.isupdate && d.name != trigger.oldmap.get(d.id).name))){
        domainsSet.add(d.name);
      }
    }
    if(!domainsSet.isempty()){
      list<Additional_Domain__c> duplicateDomains = [select name from additional_domain__c where name in: domainsSet];
      if(!duplicateDomains.isempty()){
        set<string> duplicatedomainsSet = new set<string>();
        for(additional_domain__c d: duplicateDomains){
          duplicatedomainsSet.add(d.name);
        }
        for(Additional_Domain__c d:trigger.new){
          if(duplicatedomainsSet.contains(d.name)){
            Additional_Domain__c domain = d;
            domain.adderror('You Cannot Add A Duplicate Domain Record');
          }
        }
      }
    }
  }
  if(Trigger.isAfter && Trigger.isUpdate){
    for(Additional_Domain__c d:trigger.new){
      if(d.Auto_convert_leads_into_account_contacts__c && trigger.oldmap.get(d.id).Auto_convert_leads_into_account_contacts__c == false){
        domainMap.put(d.id,d);
      }
    }
  }
  if(!domainMap.isempty()){
    list<lead> leads = [select id, DomainAccountID__c from lead where Additional_Domain__c in : domainmap.keyset()];
    if(!leads.isempty()){
      DomainManager.convertLeadsToContacts(leads);
    }
  }

}