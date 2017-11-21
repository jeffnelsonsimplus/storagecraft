public class GuidePDFExtension {
    public List<User_Guide__kav> sections {get;set;}
    public GuidePDFExtension(ApexPages.StandardController cont){
        Guide__c g = (Guide__c)cont.getRecord();
        Id gId = g.Id;
        String lang = ApexPages.currentPage().getParameters().get('language');
        if(String.isBlank(lang)){
            lang = 'en_US';
        }
        List<User_Guide__kav> userGuides = Database.query('select Id, Section__c, Title, ArticleBody__c from User_Guide__kav where Guide__c = :gId AND Language = \''+lang+'\'');
        sections = GuideSectionUtility.sortGuideSections(userGuides);
        /* not working correctly
        sections = g.User_Guides__r;
        if(sections == null){
            // sections = new List<User_Guide__kav>();
            return;
        }
        sections = GuideSectionUtility.sortGuideSections(sections);
        g.User_Guides__r.clear();
        g.User_Guides__r.addAll(sections);
		*/
    }
}