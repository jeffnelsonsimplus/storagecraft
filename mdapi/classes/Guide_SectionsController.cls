public class Guide_SectionsController {
    // TODO: Build with field set
    @AuraEnabled
    public static List<User_Guide__kav> findAllForGuide(String guideId, String lang) {
        // get article's guide id, find other guides
        User_Guide__kav u = [select Id, Guide__c from User_Guide__kav where Id = :guideId];
        if(u.Guide__c == null){
            return new List<User_Guide__kav>();
        }
        
        // return GuideSectionUtility.sortGuideSections([SELECT id, Title, Section__c, Community_URL__c FROM User_Guide__kav 
        //                                              WHERE Guide__c = :u.Guide__c AND Language = 'en_US']);
        
        Id parentId = u.Guide__c;
        String query = 'SELECT id, Title, Section__c, Community_URL__c FROM User_Guide__kav WHERE Guide__c = :parentId AND Language = \''+lang+'\'';
        System.debug(query);
        return GuideSectionUtility.sortGuideSections((List<User_Guide__kav>)Database.query(query));
        
    }
    
    private static Map<String, Schema.SObjectField> mapUGFields {get;set;}
    
    // Retrieve the field label for a specific api field
    @AuraEnabled
    public static Map<String, String> getFieldLabels(){
        if(mapUGFields == null){
            mapUGFields = Schema.SobjectType.User_Guide__kav.Fields.getMap();
        }
        
        Map<String, String> fieldLabels = new Map<String, String>();
        for(String field : mapUGFields.keySet()){
            fieldLabels.put(field, mapUGFields.get(field).getDescribe().getLabel());
        }
        return fieldLabels;
    }
    
}