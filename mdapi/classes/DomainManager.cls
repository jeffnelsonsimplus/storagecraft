Global class DomainManager {
    /*
     * Given a list of accounts and an email address lookup the first matching based on domain
     */
    public static Id findAccountByDomain(List<Account> accounts, String email){
        // get map of email domains to accountids
        // get email domain from email
        // lookup account id, return match
        if(email == null || accounts == null)
            return null;

        String domain = getDomainFromEmail(email);
        if(domain == null)
            return null;
        return getDomainsForLookup(accounts).get(domain);
    }

    /*
     * Take a list of email addresses and lookup matching accounts based on Domain__c or child
     * Additional Domain object
     */
    public static Map<String, Account> findAccountByEmailDomains(List<String> emails){
        Set<String> domains = new Set<String>();
        Map<String, Account> emailAccountMap = new Map<String, Account>();
        Set<String> emailsToProcess = new Set<String>();
        for(String s : emails){
            // Default to null for all email addresses
            emailAccountMap.put(s, null);

            String domainraw = getDomainFromEmail(s.toLowerCase());
            if(domainraw == null || isOnBlacklist(domainraw))
                continue;

            emailsToProcess.add(s);
            domains.add(domainraw);
        }
        // for collection of domains, get additional_domain and account records

        Set<Id> accountIds = new Set<Id>();
        Set<Id> adIds = new Set<Id>();
        for(Additional_Domain__c ad : [select Id, Name, Account__c from Additional_Domain__c where Name = :domains]){
            accountIds.add(ad.Account__c);
            adIds.add(ad.Id);
        }

        List<Account> accounts = [select Id, Name, Website, (Select Name from Additional_Domains__r where Id IN :adIds)
                                  from account where Domain__c = :domains OR
                                  Id IN :accountIds ORDER BY CreatedDate DESC];
        for(String email : emailsToProcess){
            Id accountId = findAccountByDomain(accounts, email);
            if(accountId != null)
                emailAccountMap.put(email, new Account(Id = accountId));
        }
        return emailAccountMap;
    }


    public static Map<String, Account> findAccountByEmailDomains(Set<String> emails){
        List<String> sEmails = new List<String>();
        sEmails.addAll(emails);
        return findAccountByEmailDomains(sEmails);
    }

    private static Map<String, Generic_Email_List__c> domainBlacklist = Generic_Email_List__c.getAll();
    private static Boolean isOnBlacklist(String domain){
        return domainBlacklist.containsKey(domain);
    }

    public static Account findAccoutByEmailDomain(String email){
        return findAccountByEmailDomains(new List<String>{email}).get(email);
    }

    private static Map<String, Id> getDomainsForLookup(List<Account> accounts){
        // TODO: Break down all domains for account
        Map<String, Id> returnMap = new Map<String, Id>();
        for(Account a : accounts){
            returnMap.putAll(getDomainsFromAccount(a));
        }
        return returnMap;
    }

    private static Map<String, Id> getDomainsFromAccount(Account a){
        // get email, pass to parser, add to map
        List<String> emails = new List<String>();
        emails.add(getDomainFromEmail(a.Website));
        if(a.Additional_Domains__r != null){
            for(Additional_Domain__c ad : a.Additional_Domains__r){
                emails.add(ad.Name);
            }
        }
        Map<String, Id> returnMap = new Map<String, Id>();
        for(String e: emails){
            returnMap.put(e, a.Id);
        }
        return returnMap;
    }

    // Statically compile the pattern for performance
    // Strip off any leading protocol and www. Parse out any . separated strings
    private static Pattern mPattern = Pattern.compile(
        '(?:https?:\\/\\/)?(?:www\\.)?(?:.*@)?((?:[a-zA-Z0-9-]+\\.)+[a-zA-Z0-9]+)'
    );

    public static String getDomainFromEmail(String email) {
        if(email == null)
            return null;
        Matcher MyMatcher = mPattern.matcher(email);
        //System.debug(MyMatcher.find());
        System.debug('Group Count:'+MyMatcher.groupCount());

        String domain;
        while(domain == null && MyMatcher.find()){
            for(Integer i = 1; i <= MyMatcher.groupCount(); i ++){
                System.debug('Group '+i+':'+MyMatcher.group(i));
                domain = MyMatcher.group(i);
                break;
            }
        }
        return domain;
    }

    /**
     * Method to associate Account to Domain
     *Need to check on the fuctionality to convert existing leads that was in here prior.
     */
    public static void AssignDomainToAccount(List<Account> accounts){
      set<string> DomainsSet = new set<string>();
      for(account a: accounts){
        if(a.domain__c != null  && a.domain__c != ''){
          DomainsSet.add(a.domain__c);
        }
      }
      map<String, ID>  DomainsToDomainIDMap = new map<String, id>();
      list<Additional_Domain__c> domains = [Select Id, Name From Additional_Domain__c Where Name IN: DomainsSet];
      for(Additional_Domain__c d: domains) {
         DomainsToDomainIDMap.put(d.Name, d.id);
      }
      map<id,id> domainIDToAccountID = new map<id,id>();
      set<string> newDomainsSet = new set<string>();
      for(account a: accounts){
        if(DomainsToDomainIDMap.containsKey(a.domain__c)){
          domainIDToAccountID.put(DomainsToDomainIDMap.get(a.domain__c), a.id);
        }
        else if(!newDomainsSet.contains(a.domain__c)){
          newDomainsSet.add(a.domain__c);
        }
      }
      if(!newDomainsSet.isempty()){
        list<string> newDomains = new list<string>();
        newDomains.addall(newDomainsSet);
        list<Additional_Domain__c> theseDomains = createNewDomains(newDomains);
        domains.addall(theseDomains);
        for(Additional_Domain__c d : theseDomains){
          DomainsToDomainIDMap.put(d.Name, d.id);
        }
      }
      for(account a: accounts){
        if(DomainsToDomainIDMap.containsKey(a.domain__c) && !domainIDToAccountID.containsKey(DomainsToDomainIDMap.get(a.domain__c))){
          domainIDToAccountID.put(DomainsToDomainIDMap.get(a.domain__c), a.id);
        }
      }
      for(Additional_Domain__c d:domains){
        d.account__c = domainIDToAccountID.get(d.id);
      }
      update domains;
    }
    public static list<Additional_Domain__c> createNewDomains(list<string> newDomains){
      list<Additional_Domain__c> domains = new list<Additional_Domain__c>();
      for(string nd:newDomains){
        Additional_Domain__c d = new Additional_Domain__c(name = nd);
        domains.add(d);
      }
      insert domains;
      return domains;
    }
    /**
     * Method to assign domains to leads
     */
    public static void assignDomainToLead(List<Lead> leads){
      set<string> domainsSet = new set<string>();
      for(lead l:leads){
        domainsSet.add(l.domain__c);
      }
      map<String, ID>  DomainsToDomainIDMap = new map<String, id>();
      list<Additional_Domain__c> domains = [Select Id, Name From Additional_Domain__c Where Name IN: DomainsSet];
      for(Additional_Domain__c d: domains) {
         DomainsToDomainIDMap.put(d.Name, d.id);
      }
      set<string> newDomainsSet = new set<string>();
      for(lead l:leads){
        if(DomainsToDomainIDMap.containskey(l.domain__c)){
          l.Additional_Domain__c = DomainsToDomainIDMap.get(l.domain__c);
        }
        else if(!isOnBlacklist(l.domain__c)){
          newDomainsSet.add(l.domain__c);
        }
      }
      if(!newDomainsSet.isempty()){
        list<string> newDomains = new list<string>();
        newDomains.addall(newDomainsSet);
        list<Additional_Domain__c> theseDomains = createNewDomains(newDomains);
        domains.addall(theseDomains);
        for(Additional_Domain__c d : theseDomains){
          DomainsToDomainIDMap.put(d.Name, d.id);
        }
      }
      for(lead l:leads){
        if(DomainsToDomainIDMap.containskey(l.domain__c)){
          l.Additional_Domain__c = DomainsToDomainIDMap.get(l.domain__c);
        }
      }
  }
  public static List<Database.LeadConvertResult> convertLeadsToContacts(List<Lead> leads){
    List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
    LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
    for(Lead l: leads) {
      Database.LeadConvert objLeadConvert = new Database.LeadConvert();
      objLeadConvert.setDoNotCreateOpportunity(true);
      objLeadConvert.setLeadId(l.Id);
      objLeadConvert.setConvertedStatus(convertStatus.MasterLabel);
      objLeadConvert.setAccountId(l.DomainAccountID__c);
      leadsToConvert.add(objLeadConvert);
    }
    List<Database.LeadConvertResult> leadConversionresult = convertLeads(leadsToConvert);
    return leadConversionresult;
  }
  /**
   * Method to convert Lead into Contact on Button
   */
  WebService static String convertLeadsToConts(Id leadId,Id accId, Id domainId) {
    List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
    LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
    Database.LeadConvert objLeadConvert = new Database.LeadConvert();
    objLeadConvert.setDoNotCreateOpportunity(true);
    objLeadConvert.setLeadId(leadID);
    objLeadConvert.setConvertedStatus(convertStatus.MasterLabel);
    objLeadConvert.setAccountId(accId);
    leadsToConvert.add(objLeadConvert);
    List<Database.LeadConvertResult> leadConversionresult = convertLeads(leadsToConvert);
    String result;
    if(leadConversionresult[0].isSuccess()){
      result = 'Lead has successfully converted';
    }
    else{
      result = 'Lead conversion failed due to error: '+(leadConversionresult[0].getErrors())[0].getMessage();
    }
    return result;
  }
  /**
   * Method to convert leads
   */
  public static List<Database.LeadConvertResult> convertLeads(List<Database.LeadConvert> leadsToConvert){
    List<Database.LeadConvertResult> leadConversionResult = Database.convertLead(leadsToConvert, False);
    for (Database.LeadConvertResult lcr : leadConversionResult){
      System.Debug('@@@@@@@@-------------'+lcr);
    }
    return leadConversionResult;
  }
}