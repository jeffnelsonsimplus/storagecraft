public class GuideIndexController {
    // TODO: Build with field set
    @AuraEnabled
    public static List<User_Guide__kav> findAllLandingPages(String lang) {
        // get article's guide id, find other guides
        String query = 'SELECT id, Title, Section__c, Community_URL__c, Language, Guide__c FROM User_Guide__kav WHERE Landing_Page__c = true AND Language = \''+lang+'\' ORDER BY Title DESC';
        return Database.query(query);
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