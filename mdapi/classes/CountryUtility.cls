/**
 * ===============================================================================================
 *   Version        Date                                            Comment
 * ===============================================================================================
 *   Initial     8-Dec-2016     Utility class to fetch Country and Language names and codes.
 */

public class CountryUtility {
    public static Map<Id, Country_ISO_Map__c> countries {get {
        if(countries != null){
            return countries;
        }
        countries = new Map<Id, Country_ISO_Map__c>([Select Id, Name, alpha2Code__c, alpha3Code__c, statesProvinces__c, postalCodeRegex__c, postalCodeExample__c 
                    FROM Country_ISO_Map__c ORDER BY Name]);
        return countries;
    } set;}
    
    public static Map<String, Country_ISO_Map__c> mapCountryByName {get {
        if(mapCountryByName != null){
            return mapCountryByName;
        }
        mapCountryByName = new Map<String, Country_ISO_Map__c>();
        for(Country_ISO_Map__c c : countries.values()){
            mapCountryByName.put(c.Name, c);
        }
        return mapCountryByName;
    } set;}
    
    public static Map<String, Country_ISO_Map__c> mapCountryByISO2 {get {
        if(mapCountryByISO2 != null){
            return mapCountryByISO2;
        }
        mapCountryByISO2 = new Map<String, Country_ISO_Map__c>();
        for(Country_ISO_Map__c c : countries.values()){
            mapCountryByISO2.put(c.alpha2Code__c, c);
        }
        return mapCountryByISO2;
    } set;}
    
    public static Map<String, Country_ISO_Map__c> mapCountryByISO3 {get {
        if(mapCountryByISO3 != null){
            return mapCountryByISO3;
        }
        mapCountryByISO3 = new Map<String, Country_ISO_Map__c>();
        for(Country_ISO_Map__c c : countries.values()){
            mapCountryByISO3.put(c.alpha3Code__c, c);
        }
        return mapCountryByISO3;
    } set;}
    
    // Build overall lookup map by all three lookup keys
    public static Map<String, Country_ISO_Map__c> mapCountryByAll {get {
        if(mapCountryByAll != null){
            return mapCountryByAll;
        }
        mapCountryByAll = new Map<String, Country_ISO_Map__c>();
        mapCountryByAll.putAll(mapCountryByName);
        mapCountryByAll.putAll(mapCountryByISO2);
        mapCountryByAll.putAll(mapCountryByISO3);
        return mapCountryByAll;
    } set;}
    
    public List<String> getStates(String country){
        List<String> retStates = new List<String>();
        String allStates = mapCountryByAll.get(country).statesProvinces__c;
        if(allStates != null && allStates.length() > 0){
            for(String s : allStates.split(',')){
                retStates.add(s.trim());
            }
        }
        
        return retStates;
    }
    
    public static String getZipRegEx(String country){
        return mapCountryByAll.get(country).postalCodeRegex__c ;
    }
    
    public static String getZipRegExLabel(String country){
        return string.format(System.LABEL.ERROR_INVALID_POSTAL_CODE, new string[] {mapCountryByAll.get(country).postalCodeExample__c});
    }

    /**
     * method to fetch selected country name
     */
    public static String getSelectedCountry(String selectedCountryCode) {
        if(mapCountryByISO2.containsKey(selectedCountryCode)){
            return mapCountryByISO2.get(selectedCountryCode).Name;
        } else if(mapCountryByISO3.containsKey(selectedCountryCode)){
            return mapCountryByISO3.get(selectedCountryCode).Name;
        }
        // else
        return null;
    }

    /**
     * method to fetch selected country code
     */
    public static String getSelectedCountryCode(String selectedCountry) {
        if(mapCountryByAll.containsKey(selectedCountry)){
            return mapCountryByAll.get(selectedCountry).alpha2Code__c;
        }
        return null;
    }
    
    public static String getCountryRegion(String selectedCountry) {
//        if(mapCountryByAll.containsKey(selectedCountry)){
//            return mapCountryByAll.get(selectedCountry).Region__c;
//        }
        return null;
    }
    
    public static Boolean isValidPostal(Country_ISO_Map__c cim, String zip){
        if(String.isBlank(cim.postalCodeRegex__c)){
            return true;
        }
        Matcher m = Pattern.compile(cim.postalCodeRegex__c).matcher(zip);
        return m.matches();
    }
}