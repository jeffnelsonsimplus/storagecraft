public class UserGuideNextPrevController {

    @AuraEnabled
    public static User_Guide__kav getNextArticle(String articleId, String lang) {
        List<User_Guide__kav> guides = getSiblings(articleId, lang);
        Boolean found = false;
        for(User_Guide__kav ug : guides){
            // Find the article AFTER the current article
            if(found){
                return ug;
            }
            if(ug.Id == articleId){
                found = true;
            }
        }
        // No articles after our current article
        return new User_Guide__kav();

    }

    @AuraEnabled
    public static User_Guide__kav getPrevArticle(String articleId, String lang) {
        List<User_Guide__kav> guides = getSiblings(articleId, lang);
        Boolean found;
        User_Guide__kav prev = new User_Guide__kav();
        for(User_Guide__kav ug : guides){
            // Find the article BEFORE the current article
            if(ug.Id == articleId){
                return prev;
            }
            prev = ug;
        }
        // just as a catch
        return new User_Guide__kav();
    }

    private static List<User_Guide__kav> getSiblings(String articleId, String lang) {

        // get article's guide id, find other guides
        User_Guide__kav u = [select Id, Guide__c from User_Guide__kav where Id = :articleId];
        if(u.Guide__c == null){
            return new List<User_Guide__kav>();
        }

        Id parentId = u.Guide__c;
//        String query = 'SELECT id, Title, Section__c, Community_URL__c FROM User_Guide__kav WHERE Guide__c = :parentId AND Language = \''+lang+'\'';
        String query = 'SELECT id, Title, Section__c, Community_URL__c FROM User_Guide__kav WHERE Guide__c = \'' + parentId + '\' AND Language = \''+lang+'\'';
        System.debug(query);
        return GuideSectionUtility.sortGuideSections((List<User_Guide__kav>)Database.query(query));
    }
}