/**
  \file         AddressesTest.cls
  \brief        Test class for the Addresses class
  \details
  \author       Matt Thompson-Moltzen
  \version      1.0
  \date         3 July 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
*/

@isTest
private class AddressesTest{


    //Klarizze added for alpha2code
    static testMethod void addresseslength2(){
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = TRUE;
        addVal.canBypassAddressValidationOnContact__c = TRUE;
        addVal.canBypassAddressValidationOnLead__c = TRUE;
        insert addVal;
        
        Country_ISO_Map__c c = new Country_ISO_Map__c();
        c.Name           = 'CA';
        c.alpha2Code__c  = 'CA';
        insert c;
        
        System.assertEquals('CA', c.alpha2Code__c);
        Addresses controller = new Addresses();
        controller.getCountryName(c.Name);
        controller.getIsoCode(c.alpha2Code__c);
    }
    //Klarizze added for alpha3code
    static testMethod void addresseslength3(){
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = TRUE;
        addVal.canBypassAddressValidationOnContact__c = TRUE;
        addVal.canBypassAddressValidationOnLead__c = TRUE;
        insert addVal;
        
        Country_ISO_Map__c c = new Country_ISO_Map__c();
        c.Name          = 'CAN';
        c.alpha2Code__c = 'CA';
        insert c;
        c.alpha3Code__c = 'CAN';
        update c;
        
        System.assertEquals('CAN', c.alpha3Code__c);
        Addresses controller = new Addresses();
        controller.getCountryName(c.Name);
        controller.getIsoCode(c.alpha3Code__c);
    }
    //Klarizze added for otherName
    static testMethod void addressesOtherName(){
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = TRUE;
        addVal.canBypassAddressValidationOnContact__c = TRUE;
        addVal.canBypassAddressValidationOnLead__c = TRUE;
        insert addVal;
        
        Country_ISO_Map__c c = new Country_ISO_Map__c();
        c.Name           = 'Canada';
        c.otherName__c   = 'Canada';
        c.alpha2Code__c  = 'CA';
        insert c;
        
        System.assertEquals('Canada', c.otherName__c);
        Addresses controller = new Addresses();
        controller.getCountryName(c.Name);
        controller.getIsoCode(c.otherName__c);
        
    }
    
    //Assign Country for BillingCountry in Account
    static testMethod void validateAA1(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'AU';
        acct.CurrencyIsoCode = 'AUD';
        acct.recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        insert acct;

        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        insert co;
        
        System.assertEquals('AU', acct.BillingCountry);
        Addresses controller1 = new Addresses();
        controller1.validateAccountAddress(acct, TRUE);
    }
    
    //BilingCountry having 2 character
    static testMethod void validateAA2(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'US';
        acct.CurrencyIsoCode = 'AUD';
        acct.recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        insert acct;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.statesProvinces__c = 'Pagasa';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        System.assertEquals('US', acct.BillingCountry);
        System.assertEquals('AU', co.alpha2Code__c);
        Addresses controller1 = new Addresses();
        controller1.validateAccountAddress(acct, TRUE);
    }
    
    static testMethod void validateAA3(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'AUD';
        acct.BillingPostalCode = '1004';
        acct.CurrencyIsoCode = 'AUD';
        acct.ShippingCountry = 'st';
        acct.recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        insert acct;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        System.assertEquals('AUD', acct.BillingCountry);
        System.assertEquals('AUD', co.alpha3Code__c);
        Addresses controller1 = new Addresses();
        controller1.validateAccountAddress(acct, TRUE);
    }
    
    static testMethod void validateAA4(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'SUD';
        acct.CurrencyIsoCode = 'AUD';
        acct.recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        insert acct;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'Pagasa';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        System.assertEquals('SUD', acct.BillingCountry);
        System.assertEquals('AUD', co.alpha3Code__c);
        Addresses controller1 = new Addresses();
        controller1.validateAccountAddress(acct, TRUE);
    }

    static testMethod void validateAA5(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'Test';
        acct.CurrencyIsoCode = 'AUD';
        acct.recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        insert acct;

        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'Test';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        insert co;
        
        System.assertEquals('Test', acct.BillingCountry);
        System.assertEquals('Test', co.otherName__c);
        Addresses controller1 = new Addresses();
        controller1.validateAccountAddress(acct, TRUE);
    }
    
    static testMethod void validateAA6(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'AUD';
        acct.BillingPostalCode = '1004';
        acct.CurrencyIsoCode = 'AUD';
        acct.ShippingCountry = 'AU';
        acct.recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        insert acct;

        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        System.assertEquals('AU', acct.ShippingCountry);
        System.assertEquals('AU', co.otherName__c);
        Addresses controller1 = new Addresses();
        controller1.validateAccountAddress(acct, TRUE);
    }
    
    static testMethod void validateAA7(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'AUD';
        acct.BillingPostalCode = '1004';
        acct.CurrencyIsoCode = 'AUD';
        acct.ShippingCountry = 'AUD';
        acct.recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        insert acct;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.validateAccountAddress(acct, TRUE);
    }
    
    static testMethod void validateAA8(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'AUD';
        acct.BillingPostalCode = '1004';
        acct.CurrencyIsoCode = 'AUD';
        acct.ShippingCountry = 'Test';
        acct.ShippingPostalCode = '1004';
        acct.recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        insert acct;

        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'Test';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        co.postalCodeExample__c = '1004';
        co.countryCode__c = '+632';
        insert co;
        
        List<Account> ac = new List<Account>();
        ac.add(acct);
        
        Addresses controller1 = new Addresses();
        controller1.validateAccountAddress(ac, TRUE);
        controller1.validateAccountAddress(acct, TRUE);
    }
    
    static testMethod void validateAA9(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'AU';
        acct.CurrencyIsoCode = 'AUD';
        acct.recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
  
        insert acct;
        

        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.postalCodeRegex__c = '1004';
        co.postalCodeExample__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateAccountAddress(acct, FALSE);
    }
    
    static testMethod void validateAA10(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'AUD';
        acct.BillingPostalCode = '1004';
        acct.CurrencyIsoCode = 'AUD';
        acct.ShippingCountry = 'AU';
        acct.recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();

        insert acct;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateAccountAddress(acct, FALSE);
    }
    
    static testMethod void validateAA11(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'test';
        acct.BillingPostalCode = '1004';
        acct.BillingState = 'on';
        acct.CurrencyIsoCode = 'AUD';
        acct.ShippingCountry = 'AU';
        acct.recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();

        insert acct;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'test';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateAccountAddress(acct, FALSE);
    }
    
    static testMethod void validateAA12(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'test';
        acct.BillingPostalCode = '1004';
        acct.BillingState = 'YON';
        acct.CurrencyIsoCode = 'AUD';
        acct.ShippingCountry = 'AU';
        acct.recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();

        insert acct;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'test';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        try{
        controller1.validateAccountAddress(acct, FALSE);
        }
        catch(DMLException e){
            System.assert(e.getMessage().contains('invalid State/Province specified - enter one of {0}, {1},...'), 'message=' + e.getMessage());
        }
    }
    
    static testMethod void validateAA13(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'test';
        acct.BillingPostalCode = '1004';
        acct.BillingState = 'ON';
        acct.CurrencyIsoCode = 'AUD';
        acct.ShippingCountry = 'AU';
        acct.recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();

        insert acct;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'test';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '10-04';
        //co.postalCodeExample__c = '10';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        try{
        controller1.validateAccountAddress(acct, FALSE);
        }
        catch(DMLException e){
            System.assert(e.getMessage().contains('format of the ZIP/Postal Code is invalid - a valid example is {0}'), 'message=' + e.getMessage());
        }
    }
    
    static testMethod void validateAA14(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        insert acct;
        
        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'test';
        co.alpha2Code__c  = 'AU';
        
        insert co;
        
        Addresses controller1 = new Addresses();
        
        try{
        controller1.validateAccountAddress(acct, FALSE);
        }
        catch(DMLException e){
            System.assert(e.getMessage().contains('please specify a Country - enter the full country name or the valid ISO alpha-2/alpha-3 code'), 'message=' + e.getMessage());
        }
    }
    
    static testMethod void validateAA15(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'AUD';
        acct.BillingPostalCode = '1004';
        acct.CurrencyIsoCode = 'AUD';
        acct.ShippingCountry = 'sty';
        insert acct;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        try{
            controller1.validateAccountAddress(acct, FALSE);
        }
        catch(DMLException e){
            System.assert(e.getMessage().contains('invalid ISO {0} code specified - enter the full country name or the valid ISO alpha-2/alpha-3 code'), 'message=' + e.getMessage());
        }
    }
    
    static testMethod void validateAA16(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'AUD';
        acct.BillingPostalCode = '1004';
        acct.CurrencyIsoCode = 'AUD';
        acct.ShippingCountry = 'stys';
        insert acct;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        try{
            controller1.validateAccountAddress(acct, FALSE);
        }
        catch(DMLException e){
            System.assert(e.getMessage().contains('invalid Country specified - enter the full country name or the valid ISO alpha-2/alpha-3 code'), 'message=' + e.getMessage());
        }
    }
    
    static testMethod void validateAA17(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'AUD';
        acct.BillingPostalCode = '1004';
        acct.CurrencyIsoCode = 'AUD';
        acct.ShippingCountry = 'stys';
        insert acct;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'stys';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        
        controller1.validateAccountAddress(acct, FALSE);
        
    }
    
    static testMethod void validateAA19(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'AUD';
        acct.BillingPostalCode = '1004';
        acct.CurrencyIsoCode = 'AUD';
        acct.ShippingCountry = 'stys';
        acct.Shippingstate = 'AB';
        insert acct;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'stys';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        
        controller1.validateAccountAddress(acct, FALSE);
        
    }
    
    static testMethod void validateAA18(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'AUD';
        acct.BillingPostalCode = '1004';
        acct.CurrencyIsoCode = 'AUD';
        acct.ShippingCountry = 'AUD';
        acct.recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();

        insert acct;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.validateAccountAddress(acct, FALSE);
    }
    
    static testMethod void validateAA20(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = FALSE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'AUD';
        acct.BillingPostalCode = '1004';
        acct.CurrencyIsoCode = 'AUD';
        acct.ShippingCountry = 'stys';
        acct.ShippingPostalCode = '1004';
        insert acct;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'stys';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '10-04';
        insert co;
        
        Addresses controller1 = new Addresses();
        
        controller1.validateAccountAddress(acct, FALSE);
        
    }
    // **********Account need continuation******
    
    static testMethod void validateCC1(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnContact__c = FALSE;
        insert addVal;
        
        Contact con = new Contact();
        con.LastName = 'Choi';
        con.MailingCountry = 'AU';
        con.CurrencyIsoCode = 'AUD';
        insert con;

        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateContactAddress(con, TRUE);
    }
    
    static testMethod void validateCC2(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnContact__c = FALSE;
        insert addVal;
        
        Contact con = new Contact();
        con.LastName = 'Choi';
        con.MailingCountry = 'US';
        con.CurrencyIsoCode = 'AUD';
        insert con;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.statesProvinces__c = 'Pagasa';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateContactAddress(con, TRUE);
    }
    
    static testMethod void validateCC3(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnContact__c = FALSE;
        insert addVal;

        Contact con = new Contact();
        con.LastName = 'Choi';
        con.MailingCountry = 'AUD';
        con.MailingPostalCode = '1004';
        con.MailingState = 'st';
        con.CurrencyIsoCode = 'AUD';
        insert con;

        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateContactAddress(con, TRUE);
    }
    
    static testMethod void validateCC4(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnContact__c = FALSE;
        insert addVal;
        

        Contact con = new Contact();
        con.LastName = 'Choi';
        con.MailingCountry = 'SUD';
        con.CurrencyIsoCode = 'AUD';
        insert con;

        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'Pagasa';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateContactAddress(con, TRUE);
    }

    static testMethod void validateCC5(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnContact__c = FALSE;
        insert addVal;
    
        Contact con = new Contact();
        con.LastName = 'Choi';
        con.MailingCountry = 'Test';
        con.CurrencyIsoCode = 'AUD';
        insert con;

        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'Test';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateContactAddress(con, TRUE);
    }
    
    static testMethod void validateCC6(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnContact__c = FALSE;
        insert addVal;
        
        
        Contact con = new Contact();
        con.LastName = 'Choi';
        con.MailingCountry = 'AUD';
        con.MailingPostalCode = '1004';
        con.MailingState = 'AU';
        con.CurrencyIsoCode = 'AUD';
        insert con;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateContactAddress(con, TRUE);
    }
    
    static testMethod void validateCC7(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnContact__c = FALSE;
        insert addVal;
        
        
        Contact con = new Contact();
        con.LastName = 'Choi';
        con.MailingCountry = 'AUD';
        con.MailingPostalCode = '1004';
        con.MailingState = 'AUD';
        con.CurrencyIsoCode = 'AUD';
        insert con;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateContactAddress(con, TRUE);
    }
    
    static testMethod void validateCC8(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnContact__c = FALSE;
        insert addVal;
        
        
        Contact con = new Contact();
        con.LastName = 'Choi';
        con.MailingCountry = 'AUD';
        con.MailingPostalCode = '1004';
        con.MailingState = 'st';
        con.CurrencyIsoCode = 'AUD';
        insert con;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'Test';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        co.postalCodeExample__c = '1004';
        insert co;
        
        List<Contact> cons = new List<Contact>();
        cons.add(con); 
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateContactAddress(cons, TRUE);
        controller1.validateContactAddress(con, TRUE);
    }    
    
    static testMethod void validateCC9(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnContact__c = FALSE;
        insert addVal;
        
        
        Contact con = new Contact();
        con.LastName = 'Choi';
        con.MailingCountry = 'AUD';
        con.MailingPostalCode = '1004';
        con.MailingState = 'st';
        con.CurrencyIsoCode = 'AUD';
        insert con;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'Test';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        co.postalCodeExample__c = '1004';
        insert co; 
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateContactAddress(con, FALSE);
    }    
    static testMethod void validateCC10(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnContact__c = FALSE;
        insert addVal;
        
        Contact con = new Contact();
        con.LastName = 'Choi';
        con.MailingCountry = 'AU';
        con.MailingPostalCode = '1004';
        con.MailingState = 'st';
        con.CurrencyIsoCode = 'AUD';
        insert con;

        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'Test';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        co.postalCodeExample__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateContactAddress(con, FALSE);
    } 
    
    static testMethod void validateCC11(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnContact__c = FALSE;
        insert addVal;
    
        Contact con = new Contact();
        con.LastName = 'Choi';
        con.MailingCountry = 'Test';
        con.MailingState = 'ON';
        con.CurrencyIsoCode = 'AUD';
        insert con;

        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'Test';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.postalCodeRegex__c = '1004';
        co.postalCodeExample__c = '1004';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateContactAddress(con, FALSE);
    }
    
    static testMethod void validateCC12(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnContact__c = FALSE;
        insert addVal;
    
        Contact con = new Contact();
        con.LastName = 'Choi';
        con.MailingCountry = 'Test';
        con.MailingState = 'ON';
        con.MailingPostalCode = '11';
        con.CurrencyIsoCode = 'AUD';
        insert con;

        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'Test';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.postalCodeRegex__c = '1004';
        co.postalCodeExample__c = '104';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        
        insert co;
        
        Addresses controller1 = new Addresses();
        try{
            controller1.validateContactAddress(con, FALSE);
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('format of the ZIP/Postal Code is invalid - a valid example is {0}'), 'message=' + e.getMessage());
        }
    }
    
    static testMethod void validateCC13(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnContact__c = FALSE;
        insert addVal;
        
        Contact con = new Contact();
        con.LastName = 'Choi';
        insert con;

        
        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'test';
        co.alpha2Code__c  = 'AU';
        
        insert co;
        
        Addresses controller1 = new Addresses();
        
        try{
        controller1.validateContactAddress(con, FALSE);
        }
        catch(DMLException e){
            System.assert(e.getMessage().contains('please specify a Country - enter the full country name or the valid ISO alpha-2/alpha-3 code'), 'message=' + e.getMessage());
        }
    }
    
    static testMethod void validateLL1(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnLead__c = FALSE;
        insert addVal;
        
        Lead ld = new Lead();
        ld.LastName = 'Choi';
        ld.Company = 'Simplus';
        ld.UserType__c = 'CP';
        ld.Email = 'kam@yahoo.com';
        ld.Status = 'Calling';
        ld.LeadSource = 'Other';
        ld.Country = 'AU';
        insert ld;

        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateLeadAddress(ld, TRUE);
    }
    
    

    static testMethod void validateLL2(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnLead__c = FALSE;
        insert addVal;
    
        Lead ld = new Lead();
        ld.LastName = 'Choi';
        ld.Company = 'Simplus';
        ld.UserType__c = 'CP';
        ld.Email = 'kam@yahoo.com';
        ld.Status = 'Calling';
        ld.LeadSource = 'Other';
        ld.Country = 'US';
        insert ld;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.statesProvinces__c = 'Pagasa';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateLeadAddress(ld, TRUE);
    }
    
    static testMethod void validateLL3(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnLead__c = FALSE;
        insert addVal;
        
        Lead ld = new Lead();
        ld.LastName = 'Choi';
        ld.Company = 'Simplus';
        ld.UserType__c = 'CP';
        ld.Email = 'kam@yahoo.com';
        ld.Status = 'Calling';
        ld.LeadSource = 'Other';
        ld.Country = 'AUD';
        ld.PostalCode = '1004';
        ld.State = 'st';
        insert ld;

        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateLeadAddress(ld, TRUE);
    }
    
    static testMethod void validateLL4(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnLead__c = FALSE;
        insert addVal;
        
        Lead ld = new Lead();
        ld.LastName = 'Choi';
        ld.Company = 'Simplus';
        ld.UserType__c = 'CP';
        ld.Email = 'kam@yahoo.com';
        ld.Status = 'Calling';
        ld.LeadSource = 'Other';
        ld.Country = 'SUD';
        insert ld;

        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'Pagasa';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateLeadAddress(ld, TRUE);
    }

    static testMethod void validateLL5(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnLead__c = FALSE;
        insert addVal;
        
        Lead ld = new Lead();
        ld.LastName = 'Choi';
        ld.Company = 'Simplus';
        ld.UserType__c = 'CP';
        ld.Email = 'kam@yahoo.com';
        ld.Status = 'Calling';
        ld.LeadSource = 'Other';
        ld.Country = 'Test';
        insert ld;

        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'Test';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateLeadAddress(ld, TRUE);
    }
    
    static testMethod void validateLL6(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnLead__c = FALSE;
        insert addVal;
        
        Lead ld = new Lead();
        ld.LastName = 'Choi';
        ld.Company = 'Simplus';
        ld.UserType__c = 'CP';
        ld.Email = 'kam@yahoo.com';
        ld.Status = 'Calling';
        ld.LeadSource = 'Other';
        ld.Country = 'AUD';
        ld.PostalCode = '1004';
        ld.State = 'AU';
        insert ld;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateLeadAddress(ld, TRUE);
    }
    
    static testMethod void validateLL7(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnLead__c = FALSE;
        insert addVal;
        
        Lead ld = new Lead();
        ld.LastName = 'Choi';
        ld.Company = 'Simplus';
        ld.UserType__c = 'CP';
        ld.Email = 'kam@yahoo.com';
        ld.Status = 'Calling';
        ld.LeadSource = 'Other';
        ld.Country = 'AUD';
        ld.PostalCode = '1004';
        ld.State = 'AUD';
        insert ld;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateLeadAddress(ld, TRUE);
    }
    
    static testMethod void validateLL8(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnLead__c = FALSE;
        insert addVal;

        Lead ld = new Lead();
        ld.LastName = 'Choi';
        ld.Company = 'Simplus';
        ld.UserType__c = 'CP';
        ld.Email = 'kam@yahoo.com';
        ld.Status = 'Calling';
        ld.LeadSource = 'Other';
        ld.Country = 'AUD';
        ld.PostalCode = '1004';
        ld.State = 'st';
        insert ld;

        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'Test';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        co.postalCodeExample__c = '1004';
        insert co;
        
        List<Lead> leadList = new List<Lead>();
        leadList.add(ld);
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateLeadAddress(leadList, TRUE);
        controller1.validateLeadAddress(ld, TRUE);
    }    
    
static testMethod void validateLL9(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnLead__c = FALSE;
        insert addVal;
        
        Lead ld = new Lead();
        ld.LastName = 'Choi';
        ld.Company = 'Simplus';
        ld.UserType__c = 'CP';
        ld.Email = 'kam@yahoo.com';
        ld.Status = 'Calling';
        ld.LeadSource = 'Other';
        ld.Country = 'AUD';
        ld.PostalCode = '1004';
        ld.State = 'stys';
        insert ld;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'stys';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '10-04';
        insert co;
        
        Addresses controller1 = new Addresses();
        
        controller1.validateLeadAddress(ld, FALSE);
    }
    
    static testMethod void validateLL10(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnLead__c = FALSE;
        insert addVal;
        
        Lead ld = new Lead();
        ld.LastName = 'Choi';
        ld.Company = 'Simplus';
        ld.UserType__c = 'CP';
        ld.Email = 'kam@yahoo.com';
        ld.Status = 'Calling';
        ld.LeadSource = 'Other';
        ld.Country = 'AU';
        ld.PostalCode = '1004';
        ld.State = 'on';
        insert ld;


        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'test';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.getCountryName(co.Name);
        controller1.validateLeadAddress(ld, FALSE);
    }
    
    static testMethod void validateLL11(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnLead__c = FALSE;
        insert addVal;
        
        Lead ld = new Lead();
        ld.LastName = 'Choi';
        ld.Company = 'Simplus';
        ld.UserType__c = 'CP';
        ld.Email = 'kam@yahoo.com';
        ld.Status = 'Calling';
        ld.LeadSource = 'Other';
        ld.Country = 'test';
        ld.PostalCode = '1004';
        ld.State = 'YON';
        insert ld;

        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'test';
        co.alpha2Code__c  = 'AU';
        co.alpha3Code__c  = 'AUD';
        co.statesProvinces__c = 'AB,BC,MB,NB,NL,NT,NS,NU,ON,PE,QC,SK,YT';
        co.postalCodeRegex__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        try{
        controller1.validateLeadAddress(ld, FALSE);
        }
        catch(DMLException e){
            System.assert(e.getMessage().contains('invalid State/Province specified - enter one of {0}, {1},...'), 'message=' + e.getMessage());
        }
    }
    static testMethod void validateLL12(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnLead__c = FALSE;
        insert addVal;
        
        Lead ld = new Lead();
        ld.LastName = 'Choi';
        ld.Company = 'Simplus';
        ld.UserType__c = 'CP';
        ld.Email = 'kam@yahoo.com';
        ld.Status = 'Calling';
        ld.LeadSource = 'Other';
        insert ld;
        
        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'test';
        co.alpha2Code__c  = 'AU';
        
        insert co;
        
        Addresses controller1 = new Addresses();
        
        try{
        controller1.validateLeadAddress(ld, FALSE);
        }
        catch(DMLException e){
            System.assert(e.getMessage().contains('please specify a Country - enter the full country name or the valid ISO alpha-2/alpha-3 code'), 'message=' + e.getMessage());
        }
    }
    
      static testMethod void validateLL13(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnLead__c = FALSE;
        insert addVal;
        
        Lead ld = new Lead();
        ld.LastName = 'Choi';
        ld.Company = 'Simplus';
        ld.UserType__c = 'CP';
        ld.Email = 'kam@yahoo.com';
        ld.Status = 'Calling';
        ld.LeadSource = 'Other';
        ld.Country = 'AU';
        insert ld;
        

        Country_ISO_Map__c co = new Country_ISO_Map__c();
        co.Name           = 'AU';
        co.otherName__c   = 'AU';
        co.alpha2Code__c  = 'AU';
        co.postalCodeRegex__c = '1004';
        co.postalCodeExample__c = '1004';
        insert co;
        
        Addresses controller1 = new Addresses();
        controller1.validateLeadAddress(ld, FALSE);
    }
    
    static testMethod void testEnum(){
        
        addressValidation__c addVal = new addressValidation__c();
        addVal.canBypassAddressValidationOnAccount__c = TRUE;
        addVal.canBypassAddressValidationOnContact__c = TRUE;
        addVal.canBypassAddressValidationOnLead__c = TRUE;
        insert addVal;
        
        Account acct = new Account();
        acct.Name             = 'Test Account1234';
        acct.BillingCountry   = 'test';
        acct.BillingPostalCode = '1004';
        acct.BillingState = 'YON';
        acct.CurrencyIsoCode = 'AUD';
        acct.ShippingCountry = 'AU';
        acct.recordtypeid = Schema.Sobjecttype.Account.getRecordTypeInfosByName().get('Distributor').getRecordTypeId();
        insert acct;
        
        Contact con = new Contact();
        con.LastName = 'Choi';
        con.MailingCountry = 'Test';
        con.MailingState = 'ON';
        con.MailingPostalCode = '11';
        con.CurrencyIsoCode = 'AUD';
        insert con;
        
        Lead ld = new Lead();
        ld.LastName = 'Choi';
        ld.Company = 'Simplus';
        ld.UserType__c = 'CP';
        ld.Email = 'kam@yahoo.com';
        ld.Status = 'Calling';
        ld.LeadSource = 'Other';
        ld.Country = 'AUD';
        ld.PostalCode = '1004';
        ld.State = 'stys';
        insert ld;
        
        Country_ISO_Map__c c = new Country_ISO_Map__c();
        c.Name           = 'CA';
        c.alpha2Code__c  = 'CA';
        insert c;
        
        Addresses controller = new Addresses();
        controller.setErrorMessage(acct, Account.SObjectType, Addresses.NumberType.LANDLINE, 'Test');
        controller.setErrorMessage(con, Contact.SObjectType, Addresses.NumberType.LANDLINE, 'Test');
        controller.setErrorMessage(ld, Lead.SObjectType, Addresses.NumberType.LANDLINE, 'Test');
        controller.setErrorMessage(con, Contact.SObjectType, Addresses.NumberType.MOBILE, 'Test');
        controller.setErrorMessage(ld, Lead.SObjectType, Addresses.NumberType.MOBILE, 'Test');
        controller.setErrorMessage(con, Contact.SObjectType, Addresses.NumberType.EITHER, 'Test');
    
    }
}