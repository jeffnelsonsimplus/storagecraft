@isTest
public class CaseReviewCaptureTest {
    static testMethod void test1() {
        Case c = new Case(Case_Review_Serial__c = true);
        Insert c;
        List<Case_Review__c> crs = [select Id from Case_Review__C where Case__c = :c.Id];
        System.assertEquals(1, crs.size());
    }
}