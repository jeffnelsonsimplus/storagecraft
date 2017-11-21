@isTest(seeAllData=false)
private class ContactTriggerTest {
    static testMethod void ContactLeaves() {       
        Contact c = new Contact();
        c.LastName = 'Test'; 
        c.FirstName = 'Contact';                             
        c.Email = 'test.contact@storagecraft.com'; 
        c.Status__c = 'Active';
        c.DoNotAllowBulkEmails__c = true;
        insert c;
        
        Test.startTest();       
        c.Status__c = 'Left The Company';        
        update c;        
        Test.stopTest();
        
        System.assert(c.DoNotAllowBulkEmails__c == true, 'Bulk Emails are still allowed');
    }
    
    static testMethod void PrimaryContactLeaves() {
        Account a = new Account();
		a.Name = 'StorageCraft Test';
        insert a;
        
        Contact c = new Contact();
        c.LastName = 'Test'; 
        c.FirstName = 'Contact';                             
        c.Email = 'test.contact@storagecraft.com'; 
        c.Status__c = 'Active';
        c.DoNotAllowBulkEmails__c = true;
        c.AccountId = a.Id;
        insert c;
        
        Test.startTest();
        a.Primary_Contact__c = c.Id;
        update a;
        
        c.Status__c = 'Left The Company';        
        update c;
        
        a = [SELECT Primary_Contact__c FROM Account WHERE Id = :a.Id];
        Test.stopTest();
      
        System.assert(c.DoNotAllowBulkEmails__c == true, 'Bulk Emails are still allowed');
        System.assert(a.Primary_Contact__c == null, 'Primary Contact is still set');
    }
    
    static testMethod void ContactDoesNotLeave() {
        Contact c = new Contact();
        c.LastName = 'Test'; 
        c.FirstName = 'Contact';                             
        c.Email = 'test.contact@storagecraft.com'; 
        c.Status__c = 'Orphaned';
        c.DoNotAllowBulkEmails__c = false;
        insert c;
        
        Test.startTest();
        c.Status__c = 'Active';        
        update c;        
        Test.stopTest();
        
        System.assert(c.DoNotAllowBulkEmails__c == false, 'Bulk Emails is false');
    }
}