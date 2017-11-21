/**
 * ===============================================================================================
 *   Version     	Date            								Comment
 * ===============================================================================================
 *   Initial     8-Dec-2016     Utility class to fetch Country and Language names and codes.
 */

public class CountryLanguageUtility {

	public Map<String, String> languageLookup = new Map<String, String>();

	/**
	 * constructor
	 */
	public CountryLanguageUtility() {
		languageLookup = inverseMap();
	}

	/**
	 * method to fetch selected country name
	 */
	public String getSelectedCountry(String selectedCountryCode) {
		String selectedCountry;
		for(CountryandLanguage__c country : CountryandLanguage__c.getall().values()){
				if(country.Short_Name__c == selectedCountryCode)
						selectedCountry = country.Name;
		}

		return selectedCountry;
	}

	/**
	 * method to fetch selected country code
	 */
	public String getSelectedCountryCode(String selectedCountry) {
		String selectedCountryCode;
		selectedCountryCode = CountryandLanguage__c.getall().get(selectedCountry).Short_Name__c;
		return selectedCountryCode;
	}

	/**
	 * method to fetch countries and languages
	 */
	public CountryWrapper fetchCountryLanguage(){
			Map<String, List<SelectOption>> mapCountry_Language = new Map<String, List<SelectOption>>();
			List<SelectOption> countries = new List<SelectOption>();

			for(CountryandLanguage__c country : CountryandLanguage__c.getall().values()){
					for(String language : country.Language_CSV__c.split(',')){
							String languageKey = language.trim().toLowerCase();
							if(mapLanguage_Code.containsKey(languageKey)){
									if(!mapCountry_Language.containsKey(country.Name)) mapCountry_Language.put(country.Name, new List<SelectOption>());
									mapCountry_Language.get(country.Name).add(new SelectOption(mapLanguage_Code.get(languageKey), language));
							}
					}
					countries.add(new SelectOption(country.Name, country.Name));
			}
			countries.sort();
			CountryWrapper objCountryWrapper = new CountryWrapper(mapCountry_Language,countries);
			return objCountryWrapper;
	}

	/**
	 * wrapper class to bind and return list of countries and map of languages
	 */
	public class CountryWrapper {
		public Map<String, List<SelectOption>> mapCountry_Language = new Map<String, List<SelectOption>>();
		public List<SelectOption> countries = new List<SelectOption>();

		CountryWrapper(Map<String, List<SelectOption>> mapCountry_Language, List<SelectOption> countries) {
			this.mapCountry_Language = mapCountry_Language;
			this.countries = countries;
		}
	}

	/**
	 * method to fill map 'languageLookup' i.e inverse of map 'mapLanguage_Code'
	 */
	public Map<String, String> inverseMap() {
		languageLookup = new Map<String, String>();
		for(String strKey: mapLanguage_Code.keySet()) {
			languageLookup.put(mapLanguage_Code.get(strKey),strKey);
		}
		return languageLookup;
	}

	public final Map<String, String> mapLanguage_Code = new Map<String, String>{'chinese (simplified)' => 'zh_CN','chinese (traditional)' => 'zh_TW',
			'danish' => 'da','dutch' => 'nl_NL', 'english' => 'en_US','finnish' => 'fi',
			'français' => 'fr','deutsch' => 'de','italiano' => 'it','日本語' => 'ja',
			'korean' => 'ko', 'norwegian' => 'no', 'portuguese (brazil)' => 'pt_BR',
			'português' => 'pt_BR', 'russian' => 'ru', 'español' => 'es','spanish (mexico)' => 'es_MX',
			'swedish' => 'sv', 'thai' => 'th'};

}