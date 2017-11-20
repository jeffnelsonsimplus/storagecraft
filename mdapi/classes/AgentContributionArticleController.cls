public class AgentContributionArticleController {
    // The constructor must take a ApexPages.KnowledgeArticleVersionStandardController as an argument
    public AgentContributionArticleController(ApexPages.KnowledgeArticleVersionStandardController ctl) {
        SObject article = ctl.getRecord();   //this is the SObject for the new article. 
                                             //It can optionally be cast to the proper article type, e.g. FAQ__kav article = (FAQ__kav) ctl.getRecord();
        // System.debug(ApexPages.currentPage().getParameters());
        if (article instanceof User_Guide__kav ){
            User_Guide__kav userguide = (User_Guide__kav)article;
            String guideId = ApexPages.currentPage().getParameters().get('guideId');
            userguide.Guide__c = guideId;
            userguide.title = '';           
            List<Guide__c> DataQuery = [select Default_Data_Category__c from Guide__c where Id=:guideId];
            ctl.selectDataCategory('Products',DataQuery[0].Default_Data_Category__c);
            return;
        }
        
        String sourceId = ctl.getSourceId(); //this returns the id of the case that was closed.
        Case c = [select subject, description, Cause__c, Resolution__c, Product__c, Product_Version__c from Case where id=:sourceId];
        
        article.put('title',c.subject);  //this overrides the default behavior of pre-filling the title of the article with the subject of the closed case. 
        article.put('summary',c.description);
        String Product = c.Product__c;
        String ProductVer = c.Product_Version__c;
        if(String.isBlank(ProductVer)){
        ProductVer = '- All';
        }
        String ProductName = Product.replace('_', ' ');
        String ProductVersions = ProductName + ' ' + ProductVer;
        article.put('Product_Versions__c',ProductVersions);
        Product = Product.replace(' ', '_');
        ctl.selectDataCategory('Products',Product);  //Only one category per category group can be specified.

        if (article instanceof Troubleshooting__kav){
        article.put('Problem__c',c.description);  
        article.put('Cause__c',c.Cause__c);  
        article.put('Resolution__c',c.Resolution__c);  
        }

    }
  }