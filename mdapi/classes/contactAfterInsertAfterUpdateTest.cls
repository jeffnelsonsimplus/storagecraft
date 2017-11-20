@isTest
private class contactAfterInsertAfterUpdateTest {

	@isTest static void test_method_one() {
		// Totally Orphaned
		Contact c = new contact(lastname = 'lastname', email = 'email@website.com');
		insert c;
        c = [Select Id, AccountId, Status__c from Contact where Id = :c.Id];
        Account acct = [select id from account where name = 'DO NOT DELETE: ORPHAN ACCOUNT' limit 1];
        
        System.assertEquals(acct.Id, c.AccountId);
        System.assertEquals('Orphaned', c.Status__c);
	}
	@isTest static void test_method_two() {
		// Account
		account a = new account(name = 'name', website = 'website.com');
		insert a;
		Contact c = new contact(lastname = 'lastname', email = 'email@website.com');
		insert c;
        c = [Select Id, AccountId from Contact where Id = :c.Id];
        System.assertEquals(a.Id, c.AccountId);
	}

	@isTest static void test_method_three() {
		lead l = new lead(company = 'company', email = 'email@website.com', lastname = 'lastname', OwnerId = UserInfo.getUserId());
		insert l;
		Contact c = new contact(lastname = 'lastname', email = 'email@website.com');
		insert c;
        c = [Select Id, AccountId, OrphanedLead__c, LeadOwner__c from Contact where Id = :c.Id];
        Account acct = [select id from account where name = 'DO NOT DELETE: ORPHAN ACCOUNT' limit 1];
        
        System.assertEquals(acct.Id, c.AccountId);
        System.assertEquals(l.Id, c.OrphanedLead__c);
        System.assertEquals(UserInfo.getUserId(), c.LeadOwner__c);
	}

	@isTest static void test_method_blockemail() {
        List<Generic_Email_List__c> gel = new List<Generic_Email_List__c>();
        gel.add(new Generic_Email_List__c(Name = 'website.com'));
        Insert gel;
        
		account a = new account(name = 'name', website = 'website.com');
		insert a;
		
        Contact c = new contact(lastname = 'lastname', email = 'email@website.com');
		insert c;
        
        Account acct = [select id from account where name = 'DO NOT DELETE: ORPHAN ACCOUNT' limit 1];
        c = [Select Id, AccountId, Status__c from Contact where Id = :c.Id];
        System.assertEquals(acct.Id, c.AccountId);
	}

}