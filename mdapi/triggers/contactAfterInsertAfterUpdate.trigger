trigger contactAfterInsertAfterUpdate on contact (after insert, after update) {
  /* if(checkRecursive.runOnce()){
    List<Contact> orphanedContacts = new List<Contact>();
    
    // Set scope of work, only process those that need processing
    for(contact c:trigger.new){
        if(c.accountID == null && c.Merge_Status__c != Label.Merged && c.Merge_Status__c != Label.Failed_to_Merge){
            orphanedContacts.add(c);
        }
    }
    
    if(orphanedContacts.isEmpty())
        return;
    
    Account newOrphanAccount;
    try{
        newOrphanAccount = [select id from account where name = 'DO NOT DELETE: ORPHAN ACCOUNT' limit 1];
    }
    catch(exception noOrphanAcccount){
        newOrphanAccount = new Account(name = 'DO NOT DELETE: ORPHAN ACCOUNT');
        Insert newOrphanAccount;
    }
    
    List<Contact> updContacts = new List<Contact>();
    Set<String> emails = new Set<String>();
    for(contact c : orphanedContacts){
        
        // TODO: What to do about blank emails? Just set to orphaned and don't continue processing?
        if(c.email != null)
            emails.add(c.Email);
        updContacts.add(new Contact(Id = c.Id, Email = c.Email, Status__c = 'Orphaned'));
    }
    if(updContacts.isEmpty())
        return;
    
    List<Contact> stillOrphaned = new List<Contact>();
    // Get domain matching from account using DomainManager
    // Create new instance of contact
    // Set Orphaned Status
    // if possible link to account
    //
    Map<String, Account> accountDomainLookup = DomainManager.findAccountByEmailDomains(emails);
    emails.clear();
    for(Contact c : updContacts){
        if(c.Email != null && 
           accountDomainLookup.containsKey(c.Email) && 
           accountDomainLookup.get(c.Email) != null){
            // found a matching account
            c.AccountId = accountDomainLookup.get(c.Email).Id;
            //set status Active
            c.Status__c = 'Active';
        } else {
            // no matching account
            c.AccountId = newOrphanAccount.Id;
            if(c.Email != null){
                stillOrphaned.add(c);
                emails.add(c.Email);
            }
        }
    }
    // if still have contacts not linked to account then link to lead
    // set status to Orphaned
    // set account to OrphanedAccount
    // get leads matched on email, set value to Orphaned Lead, set Lead Owner to ownerId from lead
    if(!stillOrphaned.isEmpty()){
        // For those where we couldn't find accounts possibly match against existing leads
        list<lead> leads = [select id, email, ownerid from lead where IsConverted = false AND email in:emails ORDER BY CreatedDate DESC limit 5000 ];
        if(!leads.isEmpty()){
            Map<String,Lead> leadEmailMap = new map<String,Lead>();
            for(lead l :leads){
                if(!leadEmailMap.containsKey(l.Email))
                    leadEmailMap.put(l.email, l);
            }
            for(contact c:stillOrphaned){
                if(leadEmailMap.containsKey(c.email)){
                    c.OrphanedLead__c = leadEmailMap.get(c.email).id;
                    c.LeadOwner__c = leadEmailMap.get(c.email).ownerid;
                }
            }
        }
    }
    
    // Don't act on stillOrphaned because those records are still held in updContacts
    
    if(!updContacts.isEmpty())
        Update updContacts;
    }
    */
}