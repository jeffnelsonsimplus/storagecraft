@isTest
public class dealRegistrationTest {
  static testMethod void testNoKey() {
    dealRegistration dr = new dealRegistration();
    dr.goPage();
  }
  static testMethod void testNoEmail() {
    ApexPages.currentPage().getParameters().put('key','6MspB43f4S5EkzpFvX9E6d9CVym4Z2FnGR9HhTVWW46zzxsvaD');
    dealRegistration dr = new dealRegistration();
    dr.goPage();
  }
  static testMethod void testBadEmail() {
    ApexPages.currentPage().getParameters().put('key','6MspB43f4S5EkzpFvX9E6d9CVym4Z2FnGR9HhTVWW46zzxsvaD');
    ApexPages.currentPage().getParameters().put('email','testemail');
    dealRegistration dr = new dealRegistration();
    dr.goPage();
    dr.submit();
  }
  static testMethod void testContactDoesNotExist() {
    ApexPages.currentPage().getParameters().put('key','6MspB43f4S5EkzpFvX9E6d9CVym4Z2FnGR9HhTVWW46zzxsvaD');
    ApexPages.currentPage().getParameters().put('email','testemail@testy.com');
    dealRegistration dr = new dealRegistration();
    dr.goPage();
    dr.submit();
    dr.c = new Contact(LastName = 'Tester', email = 'testemail@testy.com');
    dr.submit();
  }
  static testMethod void testContactDoesNotExistAccountDoes() {
    Account a = new Account(Name = 'Test', Website = 'www.testy.com');
    Insert a;
    ApexPages.currentPage().getParameters().put('key','6MspB43f4S5EkzpFvX9E6d9CVym4Z2FnGR9HhTVWW46zzxsvaD');
    ApexPages.currentPage().getParameters().put('email','testemail@testy.com');
    dealRegistration dr = new dealRegistration();
    dr.goPage();
    dr.submit();
    dr.c = new Contact(AccountId = a.Id, LastName = 'Tester', email = 'testemail@testy.com');
    dr.submit();
  }
  static testMethod void testContactExists() {
    ApexPages.currentPage().getParameters().put('key','6MspB43f4S5EkzpFvX9E6d9CVym4Z2FnGR9HhTVWW46zzxsvaD');
    Account a = new Account(Name = 'Test', Website = 'www.testy.com');
    Insert a;
    Contact c = new Contact(AccountId = a.Id, LastName = 'Tester', email = 'testemail@testy.com');
    Insert c;
    ApexPages.currentPage().getParameters().put('email','testemail@testy.com');
    dealRegistration dr = new dealRegistration();
    dr.goPage();
    dr.submit();
  }
}