public class AcademyCertificateManager {
    // Set the Academy Certificate's Account from the Contact
    public static void setAccount(List<Academy_Certificate__c> newCerts) { 
        List<Id> certIds = new List<Id>();
        
        for (Academy_Certificate__c ac : newCerts) {
            certIds.Add(ac.Certified_Contact__c);
        }
        
        List<Contact> contacts = [SELECT Id, AccountId FROM Contact WHERE Id IN :certIds];
        
        for (Academy_Certificate__c cert : newCerts) {
            for (Contact c : contacts) {
            	if (cert.Certified_Contact__c == c.Id) {                
                	cert.Contact_Account__c = c.AccountId;
                    break;
                }
            }
        }
    }

    // If the Contact's Account has changed, update any Academy Certificates
    public static void updateAccount(List<Contact> oldContacts, List<Contact> newContacts) {
        List<Id> contactIds = new List<Id>();
        
        for (Integer i = 0; i < newContacts.size(); i++) {
            if (newContacts[i].AccountId != oldContacts[i].AccountId) {
                contactIds.Add(newContacts[i].Id);
            }
        }
            
        if (contactIds.size() > 0) {
            List<Academy_Certificate__c> updateCerts = new List<Academy_Certificate__c>();
            List<Academy_Certificate__c> certs = 
                        [SELECT Id, Contact_Account__c, Certified_Contact__c FROM Academy_Certificate__c WHERE Certified_Contact__c IN :contactIds];
                                    
            for (Academy_Certificate__c ac : certs) {
                for (Contact c : newContacts) {
                    if (ac.Certified_Contact__c == c.Id) {
                    	ac.Contact_Account__c = c.AccountId;
                    	updateCerts.add(ac);
                        break;
                	}
                }
            }
            
            if (updateCerts.size() > 0) {
                update updateCerts;
            }
		}
    }
}