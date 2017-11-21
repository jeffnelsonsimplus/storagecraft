@isTest
private class NFRKeyAutomatedCreationTest {

	@isTest static void test_method_one() {
		account a = new account(name = 'AccountTest');
		insert a;
		NFRCallout__c n = new NFRCallout__c(Endpoint__c = 'string', Username__c = 'string', EncodedAuth__c = 'string', PassPhrase__c = 'string');
		insert n;
		list<string> thisList = new list<string>();
		thisList.add(a.id+';English');
		NFRKeyAutomatedCreation.createNewKeys(thisList);
	}
}