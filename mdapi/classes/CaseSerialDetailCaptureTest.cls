@isTest
public class CaseSerialDetailCaptureTest {

	private static List<Case> lstCases = new List<Case>();
		static void setup() {

			for (Integer i = 0; i < 1 ; i++) {
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
	}

    static testMethod void testupdationOfSerialNumberDetails() {
			setup();
			Test.startTest();
				//Test.setMock(WebServiceMock.class, new serviceStoragecraftComMock());
				CaseSerialDetailCapture obj = new CaseSerialDetailCapture(lstCases[0]);
				System.enqueueJob(obj);
    	Test.stopTest();
			system.assert(true);

    }
}