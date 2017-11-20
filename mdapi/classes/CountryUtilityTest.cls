/**
  \file         CountryUtilityTest.cls
  \brief        Test class for the JsonTelephone class
  \details
  \author       Matt Thompson-Moltzen
  \version      1.0
  \date         21 July 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
*/
@isTest (SeeAllData = true)
private class CountryUtilityTest
{
	static testMethod void countryUtilityTest1() {

		CountryUtility cu = new CountryUtility();

  	List<String> states = cu.getStates('US');

    System.assertNotEquals(52, states.size());

	}

	static testMethod void countryUtilityTest2() {
		String regex = CountryUtility.getZipRegEx('US');

		System.assertNotEquals(null, regex);

  }
}