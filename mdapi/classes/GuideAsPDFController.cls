public class GuideAsPDFController {
    
    @AuraEnabled
    public static User_Guide__kav getNextArticle(String articleId) {
        User_Guide__kav u = [select Id, Guide__c from User_Guide__kav where Id = :articleId];
        return u;
    }
}