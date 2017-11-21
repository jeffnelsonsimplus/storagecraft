/**
  \file         JsonTelephoneTest.cls
  \brief        Test class for the JsonTelephone class
  \details
  \author       Matt Thompson-Moltzen
  \version      1.0
  \date         21 July 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
*/
@isTest (SeeAllData = true)
private class JsonTelephoneTest
{
	static testMethod void jsonTelephoneTest1() {
  	String telephoneFormats = '{"isoCode": "AU", "countryCode": "+61", "trunkPrefix": "0", "exampleLandLine": "+61 2 8061 4414", "exampleMobile": "+61 414 890 206", "formats": [{"isLandLine": true, "isMobile": false, "minLength": 9, "maxLength": 9, "deconstructor": "^([2378])(\\\\d{4})(\\\\d{4}).*$", "constructor": "{0} {1} {2} {3}" }, {"isLandLine": false, "isMobile": true, "minLength": 9, "maxLength": 9, "deconstructor": "^([4]\\\\d{2})(\\\\d{3})(\\\\d{3}).*$", "constructor": "{0} {1} {2} {3}"}]}';

    JsonTelephone jt = null;

		try {
			jt = JsonTelephone.parse(telephoneFormats);

			System.debug('JsonTelephone: ' + jt);
		}
		catch (exception e) {
			System.debug('JsonTelephone::parse() failed: ' + e.getMessage());
		}

    System.assertNotEquals(null, jt);

  }

	static testMethod void jsonTelephoneTest2() {
		String telephoneFormats = '{"isoCode": "AU", "countryCode": "+61", "trunkPrefix": "0", "exampleLandLine": "+61 2 8061 4414", "exampleMobile": "+61 414 890 206", "formats": [{"isLandLine": true, "isMobile": false, "minLength": 9, "maxLength": 9, "deconstructor": "^([2378])(\\\\d{4})(\\\\d{4}).*$", "constructor": "{0} {1} {2} {3}" }  {"isLandLine": false, "isMobile": true, "minLength": 9, "maxLength": 9, "deconstructor": "^([4]\\\\d{2})(\\\\d{3})(\\\\d{3}).*$", "constructor": "{0} {1} {2} {3}"}]}';

		JsonTelephone jt = null;

		try {
			jt = JsonTelephone.parse(telephoneFormats);

			System.debug('JsonTelephone: ' + jt);
		}
		catch (exception e) {
			System.debug('JsonTelephone::parse() failed: ' + e.getMessage());
		}

		System.assertEquals(null, jt);

	}
}