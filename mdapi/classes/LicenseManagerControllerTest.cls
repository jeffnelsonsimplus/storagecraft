@isTest
private class LicenseManagerControllerTest {

	@isTest static void test_method_one() {
		account a = new account(name = 'AccountTest');
		insert a;
		NFRCallout__c n = new NFRCallout__c(Endpoint__c = 'string', Username__c = 'string', EncodedAuth__c = 'string', PassPhrase__c = 'string');
		insert n;
		Test.setCurrentPageReference(new PageReference('Page.LicenseManager'));
		licenseManagerController lmc = new licenseManagerController();
		System.currentPageReference().getParameters().put('id', a.id);
		lmc.gopage();
		lmc.issueLicenses();
		lmc.addToRequest();
		lmc.confirmRequest();
		lmc.gopage();
		lmc.modifyLicenses();
		lmc.als[0].edit__c = true;
		lmc.extend();
		lmc.als[0].edit__c = true;
		lmc.replace();
		lmc.als[0].edit__c = true;
		lmc.terminate();
		lmc.returnToAccount();
	}
}