@isTest
public class EmailExceptionToAdminTest {
 static testMethod void TestEmailExceptionToAdmin() {
         
        Lead MyBadLead;
         
        try {
            insert MyBadLead;
        } catch (exception e) {
            EmailExceptionToAdmin.notify('TestEmailExceptionToAdmin',e,'Test Method!');
        } // try & catch
         
    } // test EmailExceptionToAdmin
}