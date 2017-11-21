@isTest(SeeAllData=true)
public class NFRKeysTest {
	@isTest static void test_method_one() {
        System.debug('Start test_method_one');

		Account a = new Account(Name = 'AccountTest');
		a.BillingCity = 'Draper';
		a.BillingState = 'UT';
		a.BillingPostalCode = '84020';
		a.BillingCountry = 'US';
		insert a;

		NFRKeys nfrs = new NFRKeys();

        if (nfrs.createPartnerBaseKeys(a.Id, 'English')) {
            a = [SELECT Id,
                        NFR_ShadowProtect_Server_Serial__c,
                        NFR_ShadowProtect_Desktop_Serial__c,
                        NFR_ShadowProtect_SPX_Linux__c,
                        NFR_ShadowProtect_ImageManager_Serial__c
                 FROM Account
                 WHERE Id = :a.Id];

            System.assert(a.NFR_ShadowProtect_Server_Serial__c != null, 'Missing Server Serial');
            System.assert(a.NFR_ShadowProtect_Desktop_Serial__c != null, 'Missing Desktop');
            System.assert(a.NFR_ShadowProtect_SPX_Linux__c != null, 'Missing SPX Linux');
            System.assert(a.NFR_ShadowProtect_ImageManager_Serial__c != null, 'Missing Image Manager');

            List<License__c> licenses = [SELECT Id, Name FROM License__c WHERE Account__c = :a.Id];

            System.assert(4 <= licenses.size(), 'Not enough licenses');
        }
        else {
            System.assert(false, 'Failed to create keys.  ' + nfrs.Error);
        }
	}
}