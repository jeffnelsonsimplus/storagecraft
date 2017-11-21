/**
  \file         CountryIsoMapTriggerHandlerTest.cls
  \brief        Test class for the CountryIsoMapTriggerHandler class
  \details
  \author       Matt Thompson-Moltzen
  \version      1.2
  \date         21 July 2017
  \LastUpdated  08 August 2017 - smo
  \copyright    Copyright 2017 StorageCraft Technology Corporation
*/
@isTest (SeeAllData = true)
private class CountryIsoMapTriggerHandlerTest
{

	static testMethod void countryIsoMapTriggerHandlerTest1()
	{
	  Country_ISO_Map__c c = new Country_ISO_Map__c();

	  c.Name           = 'Mordor';
	  c.alpha2Code__c  = 'XX';

	  insert c;

	  List<Country_ISO_Map__c> countries = [SELECT Id, Name, alpha2Code__c FROM Country_ISO_Map__c WHERE (Id = :c.Id)];

	  System.debug('countries.size(): ' + countries.size());
	  System.assertEquals(1, countries.size());
	}

	static testMethod void testBeforeInsertIF()
	{

		Country_ISO_Map__c cmsGetTelFormat = [SELECT telephoneFormats__c FROM Country_ISO_Map__c ORDER BY CreatedDate DESC LIMIT 1];
		string telephoneFormat = cmsGetTelFormat.telephoneFormats__c;

		Country_ISO_Map__c cif = new Country_ISO_Map__c();

		cif.postalCodeRegex__c = null ;
		cif.alpha2Code__c  = 'XX';
		cif.countryCode__c = '+123';
		cif.telephoneFormats__c = telephoneFormat;

		insert cif;

		Country_ISO_Map__c cmsInsertedIf = [SELECT Id, postalCodeRegex__c, countryCode__c, telephoneFormats__c FROM Country_ISO_Map__c WHERE (Id = :cif.Id)];

		string postalcodeIf = cmsInsertedIf.postalCodeRegex__c;
		string countryCodeIf = cmsInsertedIf.countryCode__c;
		string telFormatIf = cmsInsertedIf.telephoneFormats__c;

		System.assertEquals(null, postalcodeIf);
		System.assertEquals(cif.countryCode__c, countryCodeIf);
		System.assertEquals(cif.telephoneFormats__c, telFormatIf);

		cif.countryCode__c = '+124';
		update cif;
	}

	static testMethod void testBeforeInsertELSE()
	{
		Country_ISO_Map__c cmsGetTelFormat = [SELECT telephoneFormats__c FROM Country_ISO_Map__c WHERE postalCodeRegex__c != null ORDER BY CreatedDate DESC LIMIT 1];
		string telephoneFormat = cmsGetTelFormat.telephoneFormats__c;

		Country_ISO_Map__c cifElse = new Country_ISO_Map__c();

		cifElse.postalCodeRegex__c = '^[1-9][0-9]{3}\\s?([a-zA-Z]{2})?$' ;
		cifElse.alpha2Code__c  = 'XX';
		cifElse.countryCode__c = '+123';
		cifElse.telephoneFormats__c = telephoneFormat;
		System.debug('**** + ' + telephoneFormat);

		insert cifElse;

		Country_ISO_Map__c cmsInsertedElse = [SELECT Id, postalCodeRegex__c, countryCode__c, telephoneFormats__c FROM Country_ISO_Map__c WHERE (Id = :cifElse.Id)];

		string countryCodeElse = cmsInsertedElse.countryCode__c;
		string telFormatElse = cmsInsertedElse.telephoneFormats__c;
		string postalcodeElse = cmsInsertedElse.postalCodeRegex__c;

		System.assertEquals(cifElse.postalCodeRegex__c, postalcodeElse);
		System.assertEquals(cifElse.countryCode__c, countryCodeElse);
		System.assertEquals(cifElse.telephoneFormats__c, telFormatElse);

		cifElse.countryCode__c = '+124';
		update  cifElse;
	}

/*
	static testMethod void testBeforeUpdateIF()
	{

		Country_ISO_Map__c cmsGetTelFormat = [SELECT telephoneFormats__c FROM Country_ISO_Map__c ORDER BY CreatedDate DESC LIMIT 1];
		string telephoneFormat = cmsGetTelFormat.telephoneFormats__c;

		Country_ISO_Map__c cif = new Country_ISO_Map__c();

		cif.postalCodeRegex__c = null ;
		cif.alpha2Code__c  = 'XX';
		cif.countryCode__c = '+123';
		cif.telephoneFormats__c = telephoneFormat;

		insert cif;

		Country_ISO_Map__c cmsInsertedIf = [SELECT Id, postalCodeRegex__c, countryCode__c, telephoneFormats__c FROM Country_ISO_Map__c WHERE (Id = :cif.Id)];

		string postalcodeIf = cmsInsertedIf.postalCodeRegex__c;
		string countryCodeIf = cmsInsertedIf.countryCode__c;
		string telFormatIf = cmsInsertedIf.telephoneFormats__c;

		System.assertEquals(null, postalcodeIf);
		System.assertEquals(cif.countryCode__c, countryCodeIf);
		System.assertEquals(cif.telephoneFormats__c, telFormatIf);
	}


	static testMethod void testBeforeUpdateELSE()
	{
		Country_ISO_Map__c cmsGetTelFormat = [SELECT telephoneFormats__c FROM Country_ISO_Map__c WHERE postalCodeRegex__c != null ORDER BY CreatedDate DESC LIMIT 1];
		string telephoneFormat = cmsGetTelFormat.telephoneFormats__c;

		Country_ISO_Map__c cifElse = new Country_ISO_Map__c();

		cifElse.postalCodeRegex__c = '^[1-9][0-9]{3}\\s?([a-zA-Z]{2})?$' ;
		cifElse.alpha2Code__c  = 'XX';
		cifElse.countryCode__c = '+123';
		cifElse.telephoneFormats__c = telephoneFormat;
		System.debug('**** + ' + telephoneFormat);

		insert cifElse;

		Country_ISO_Map__c cmsInsertedElse = [SELECT Id, postalCodeRegex__c, countryCode__c, telephoneFormats__c FROM Country_ISO_Map__c WHERE (Id = :cifElse.Id)];

		string countryCodeElse = cmsInsertedElse.countryCode__c;
		string telFormatElse = cmsInsertedElse.telephoneFormats__c;
		string postalcodeElse = cmsInsertedElse.postalCodeRegex__c;

		System.assertEquals(cifElse.postalCodeRegex__c, postalcodeElse);
		System.assertEquals(cifElse.countryCode__c, countryCodeElse);
		System.assertEquals(cifElse.telephoneFormats__c, telFormatElse);
	}
*/
}