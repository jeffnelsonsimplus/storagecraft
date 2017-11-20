public class AccountPrimaryContact {
    public static void confirmStillActive(List<Contact> oldContacts, List<Contact> newContacts) {
        Map<Id, Id> accountIds = new Map<Id, Id>();
        
        for (integer i = 0; i < oldContacts.size(); i++) {
            if ((newContacts[i].status__c.equals('Left The Company') && !oldContacts[i].status__c.equals('Left The Company'))
                || (newContacts[i].status__c.equals('Inactive') && !oldContacts[i].status__c.equals('Inactive'))
                || (newContacts[i].AccountId != oldContacts[i].AccountId)){
                accountIds.put(oldContacts[i].AccountId, oldContacts[i].AccountId);
            }
        } 
        
        if (accountIds.size() != 0) {
        	List<Account> accounts = [SELECT id, Primary_Contact__c FROM Account WHERE Id IN :accountIds.KeySet()];

            for (Contact c : oldContacts) {
                for (Account a : accounts) {
                    if (a.Primary_Contact__c == c.Id) {
                        a.Primary_Contact__c = null;
                        break;
                    }
                }
            }            
            
            update accounts;
        }
    }
    
    public static void setValue(List<Contact> newContacts) {
        List<Account> updateAccounts = new List<Account>();
        
        Map<Id, Id> accountIds = new Map<Id, Id>();

        for (Contact c : newContacts) {
            accountIds.put(c.AccountId, c.AccountId);
        }

        List<Account> accounts = [SELECT id, Primary_Contact__c FROM Account WHERE Id IN :accountIds.KeySet()];
        
        for (Account a : accounts) {
            if (a.Primary_Contact__c == null) {        	
                for (Contact c : newContacts) {
                    if (a.Id == c.AccountId) {
                        a.Primary_Contact__c = c.Id;
                        updateAccounts.add(a);
                        break;
                    }
                }
            }            
        }  
        
        update updateAccounts;
    }
}