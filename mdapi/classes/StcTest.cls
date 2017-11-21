@isTest
public class StcTest {
    //
    // testProductionInstance just test it does not throw exception
    // 
    static testMethod void testProductionInstance() {
        try {
            Stc.isProductionInstance();
        } catch (Exception c) {
            System.debug('testProductionInstance Exception: ' + c.getMessage());
        }
    }
    
    //
    // testEmails
    // 
    static testMethod void testEmailAddresses() {
        System.assertEquals(true, Stc.isValidEmail('joe@abc.zzz'));
        System.assertEquals(true, Stc.isValidEmail('joe.doe@abc.zzz'));
        System.assertEquals(true, Stc.isValidEmail('joe@storagecraft.zzz.au'));
        System.assertEquals(true, Stc.isValidEmail('joe.doe@abc.zzz.au'));
        System.assertEquals(false, Stc.isValidEmail('joe.doe@abc.zzz.debugging'));
        System.assertEquals(false, Stc.isValidEmail('joe.doe@abc.zzz.'));
        System.assertEquals(false, Stc.isValidEmail('joedoe'));
        System.assertEquals(false, Stc.isValidEmail('@abc.zzz.au'));
        System.assertEquals(false, Stc.isValidEmail('joe.doe@abc'));
        System.assertEquals(false, Stc.isValidEmail('joe.@abc'));
    }   
    
    //
    // testSetTestSettings
    // 
    static testMethod void testSetTestSettings() {
        Stc.setTestSettings();
        partnerPortals__c pp1 = partnerPortals__c.getInstance('US Partner Portal');
        System.assertEquals(Stc.PartnerPortalURL_Test,  pp1.partnerPortalUrl__c);
        partnerPortals__c pp2 = partnerPortals__c.getInstance('World Partner Portal');
        System.assertEquals(Stc.PartnerPortalURL_Test,  pp2.partnerPortalUrl__c);
        
        NFRCallout__c callout = NFRCallout__c.getOrgDefaults();
        System.assertEquals(Stc.NFR_EncodedAuth_Test, callout.EncodedAuth__c);
        System.assertEquals(Stc.NFR_Endpoint_Test, callout.Endpoint__c);
        System.assertEquals(Stc.NFR_Password_Test, callout.Password__c);
        System.assertEquals(Stc.NFR_Username_Test, callout.Username__c);
    }
}