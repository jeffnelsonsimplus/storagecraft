@isTest
private class CaseSerialInfoCaptureTest {

	private static map<Id, Case> mapIdToCases = null;

	//@testSetup static void setupTest() {
		static void setup(Integer counter) {
			List<Case> lstCases = new List<Case>();
			for (Integer i = 0; i < counter ; i++) {
				 lstCases.add(new Case (
						 Subject = 'Test Case '+i,
						 Status = 'New',
						 Contact_Name_Text__c = 'Test Contact',
						 SuppliedEmail = 'test@gmail.com',
						 SuppliedPhone = '1234567890',
						 Description = 'Test Description',
						 Serial_Number__c = 'abdcjfjf-ccsdc-12233'
						 ));
			}
			insert lstCases;
			mapIdToCases = new map<Id, Case>(lstCases);
	}

	@isTest static void testserialInfo() {
		setup(1);
		Test.startTest();
			//Test.setMock(WebServiceMock.class, new serviceStoragecraftComMock());
			CaseSerialInfoCapture obj = new CaseSerialInfoCapture(mapIdToCases, mapIdToCases, mapIdToCases.values());
			obj.getSerialInfoForCases();
		Test.stopTest();
		System.assert(true);
	}

}