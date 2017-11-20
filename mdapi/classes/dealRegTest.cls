@isTest
public class dealRegTest {
    static testmethod void contactNotFound(){
        Test.startTest();
        System.currentPageReference().getParameters().put('key', '6MspB43f4S5EkzpFvX9E6d9CVym4Z2FnGR9HhTVWW46zzxsvaD');
        System.currentPageReference().getParameters().put('email', 'testEmail@test.com');
        dealReg dr = new dealReg();
        Test.stopTest();
    }
    static testmethod void keyNotFound(){
        Test.startTest();
        //System.currentPageReference().getParameters().put('key', '6MspB43f4S5EkzpFvX9E6d9CVym4Z2FnGR9HhTVWW46zzxsvaD');
        System.currentPageReference().getParameters().put('email', 'testEmail@test.com');
        dealReg dr = new dealReg();
        Test.stopTest();
    }
    static testmethod void contactFound(){
        Test.startTest();
        Contact con = new Contact( LastName='my name', email='testEmail@test.com');
        insert con;
        System.currentPageReference().getParameters().put('key', '6MspB43f4S5EkzpFvX9E6d9CVym4Z2FnGR9HhTVWW46zzxsvaD');
        System.currentPageReference().getParameters().put('email', 'testEmail@test.com');
        dealReg dr = new dealReg();
        Test.stopTest();
    }
    static testmethod void contactNotFoundAccFound(){
        Test.startTest();
        Contact con = new Contact( LastName='my name', email='testEmail@test.com');
        insert con;
        Account acc = new Account(Name='myAcc', Website = 'www.test.com', Primary_Contact__c = con.id);
        insert acc;
        System.currentPageReference().getParameters().put('key', '6MspB43f4S5EkzpFvX9E6d9CVym4Z2FnGR9HhTVWW46zzxsvaD');
        System.currentPageReference().getParameters().put('email', 'test1Email@test.com');
        dealReg dr = new dealReg();
        Test.stopTest();
    }
    static testmethod void withoutEmail(){
        Test.startTest();
        Contact con = new Contact( LastName='my name', email='testEmail@test.com');
        insert con;
        Account acc = new Account(Name='myAcc', Website = 'www.test.com', Primary_Contact__c = con.id);
        insert acc;
        System.currentPageReference().getParameters().put('key', '6MspB43f4S5EkzpFvX9E6d9CVym4Z2FnGR9HhTVWW46zzxsvaD');
        //System.currentPageReference().getParameters().put('email', 'test1Email@test.com');
        dealReg dr = new dealReg();
        dr.email = 'test1Email@test.com';
        dr.checkEmailDomainForAccount();
        Test.stopTest();
    }
    static testmethod void contactAndAccountFound(){
        Test.startTest();
        Contact con = new Contact( LastName='my name', email='testEmail@test.com');
        insert con;
        Account acc = new Account(Name='myAcc', Website = 'www.test.com', Primary_Contact__c = con.id);
        insert acc;
        System.currentPageReference().getParameters().put('key', '6MspB43f4S5EkzpFvX9E6d9CVym4Z2FnGR9HhTVWW46zzxsvaD');
        System.currentPageReference().getParameters().put('email', 'testEmail@test.com');
        dealReg dr = new dealReg();
        Lead myL = new Lead(LastName='myL',Company='myC');
        dr.lead = myL;
        dr.continueAction();
        Test.stopTest();
    }
}