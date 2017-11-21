/**
 *  ============================================================================
 *   Version    Date             Comment
 *  ============================================================================
 *   v1.0       Dec-09-2016      Test class for CountryLanguageUtility class
 *                               Test if Country and Language names and codes are
 *                               fetched accurately.
 */
@isTest
private class CountryLanguageUtilityTest {

    /**
     * Common test data
     */
    @testSetup static void setupTestData() {
        createCountryLangCS('English','Afghanistan','AF');
        createCountryLangCS('Português,English','Brazil','BR');
        createCountryLangCS('English,Español','Jamaica','JM');
    }

    /**
     * Method to create test data of custom setting CountryandLanguage__c.
     */
    public static CountryandLanguage__c createCountryLangCS(String strLang,
      String strName, String strShortName) {
        CountryandLanguage__c objCountryLang = new CountryandLanguage__c();
        objCountryLang.Name = strName;
        objCountryLang.Language_CSV__c = strLang;
        objCountryLang.Short_Name__c = strShortName;
        insert objCountryLang;
        return objCountryLang;
    }

    /**
     * Method to test if selectedCountry is returned by passing Short Name
     */
    static testMethod void test_getSelectedCountry() {
        CountryLanguageUtility objUtility = new CountryLanguageUtility();
        Test.startTest();
            String strSelectedCountry = objUtility.getSelectedCountry('BR');
        Test.stopTest();
        system.AssertEquals(strSelectedCountry,'Brazil');
    }

    /**
     * Method to test if country short name is returned by passing selectedCountry Name
     */
    static testMethod void test_getSelectedCountryCode() {
        CountryLanguageUtility objUtility = new CountryLanguageUtility();
        Test.startTest();
            String strSelectedCountry = objUtility.getSelectedCountryCode('Brazil');
        Test.stopTest();
        system.AssertEquals(strSelectedCountry,'BR');
    }

    /**
     * Method to test if CountryWrapper is filled by countries and languages collection
     */
    static testMethod void test_fetchCountryLanguage() {
        /*Map<String, List<SelectOption>> mapCountry_Language = new Map<String, List<SelectOption>>();
        List<SelectOption> countries = new List<SelectOption>();
        Map<String, String> objMapLangCode = new Map<String, String> ();
        //new CountryLanguageUtility.mapLanguage_Code();


        for(CountryandLanguage__c country : CountryandLanguage__c.getall().values()){
             for(String language : country.Language_CSV__c.split(',')){
                 String languageKey = language.trim().toLowerCase();
                 if(objMapLangCode.containsKey(languageKey)){
                     if(!mapCountry_Language.containsKey(country.Name)) mapCountry_Language.put(country.Name, new List<SelectOption>());
                     mapCountry_Language.get(country.Name).add(new SelectOption(objMapLangCode.get(languageKey), language));
                 }
             }
             countries.add(new SelectOption(country.Name, country.Name));
         }
         countries.sort();
         system.debug('-----mapCountry_Language--------'+mapCountry_Language);
         system.debug('-----countries--------'+countries);*/

        CountryLanguageUtility objUtility = new CountryLanguageUtility();
        System.Test.startTest();
            CountryLanguageUtility.CountryWrapper objWrapper = objUtility.fetchCountryLanguage();
        System.Test.stopTest();
        
        System.assertNotEquals(null,objWrapper.mapCountry_Language);
        System.assertNotEquals(null,objWrapper.countries);
        
        //system.AssertEquals(mapCountry_Language,objWrapper.mapCountry_Language);
        //system.AssertEquals(countries,objWrapper.countries);
    }

}