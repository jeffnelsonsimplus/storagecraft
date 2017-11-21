@isTest(SeeAllData=true)
private class AgentContributionArticleControllerTest {
    static testMethod void testAgentContributionArticleController() {
         String caseSubject = 'Test Subject';
         String caseDesc = 'Test Case Description';
         String caseProduct = 'ShadowControl';
         String caseProductVer = 'Previous Version';
         String ProductVer = '- All';
                
         Case c = new Case();
         c.subject= caseSubject;
         c.description = caseDesc;
         c.Product__c = caseProduct;
         c.Product_Version__c = caseProductVer;
         insert c;
         String caseId = c.id;
         System.debug('Created Case: ' + caseId);

         ApexPages.currentPage().getParameters().put('sourceId', caseId);
         ApexPages.currentPage().getParameters().put('sfdc.override', '1');
        
         ApexPages.KnowledgeArticleVersionStandardController ctl =
            new ApexPages.KnowledgeArticleVersionStandardController(new Troubleshooting__kav());

         new AgentContributionArticleController(ctl);
 
         System.assertEquals(caseId, ctl.getSourceId());
         System.assertEquals(caseSubject, ctl.getRecord().get('title'));
         System.assertEquals(caseDesc, ctl.getRecord().get('summary'));
         System.assertEquals(caseProduct + ' ' + caseProductVer, ctl.getRecord().get('Product_Versions__c'));
    }
    
        static testMethod void testAgentUserGuideType() {
         String caseSubject = 'Test Subject';
         String caseDesc = 'Test Case Description';
         String caseProduct = 'ShadowControl';
         String caseProductVer = 'Previous Version';
         String ProductVer = '- All';
//         Id gId = 'a0xc0000002E7Sl';
         Id gId = [SELECT id from Guide__c LIMIT 1].Id;

        
         Case c = new Case();
         c.subject= caseSubject;
         c.description = caseDesc;
         c.Product__c = caseProduct;
         c.Product_Version__c = caseProductVer;
         insert c;
         String caseId = c.id;
         System.debug('Created Case: ' + caseId);

         ApexPages.currentPage().getParameters().put('sourceId', caseId);
         ApexPages.currentPage().getParameters().put('sfdc.override', '1');
         ApexPages.currentPage().getParameters().put('guideId', gId);
        
         ApexPages.KnowledgeArticleVersionStandardController usr =
            new ApexPages.KnowledgeArticleVersionStandardController(new User_Guide__kav());

         new AgentContributionArticleController(usr);
 
         System.assertEquals(caseId, usr.getSourceId());
         //System.assertEquals(caseSubject, usr.getRecord().get('title'));
         //System.assertEquals(caseDesc, usr.getRecord().get('summary'));
         //System.assertEquals(caseProduct + ' ' + caseProductVer, usr.getRecord().get('Product_Versions__c'));
         System.assertEquals(gId, usr.getRecord().get('Guide__c'));
   }

}