/**
  \file
  \brief        This class will implement address/telephone number related functions
  \details      JIRA ticket(s): SSF-62, SSF-65, SSF-447
  \author       Matt Thompson-Moltzen
  \version      1.12
  \date         2 August 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.11      2017-08-02  Matt Thompson-Moltzen   Addressed a reference to a null pointer on Account ShippingCountry.
  1.12      2017-08-09  Matt Thompson-Moltzen   Added a member function getIsoCode() (SSF-447).
*/
public with sharing class Addresses
{
  //
  // variables
  //
  public enum NumberType { LANDLINE, MOBILE, EITHER }

  private addressValidation__c av;

  private List<Country_ISO_Map__c> countryIsoMaps;

  //
  // constructor
  //
  public Addresses()
  {
    av = addressValidation__c.getInstance();

    countryIsoMaps = [SELECT Id, Name, otherName__c, alpha2Code__c, alpha3Code__c, statesProvinces__c,
                             postalCodeRegex__c, postalCodeExample__c, countryCode__c, telephoneFormats__c
                      FROM Country_ISO_Map__c];
  }

  //
  // member functions
  //
  public String getCountryName(String country)
  {
    if (countryIsoMaps.isEmpty()) { return country; }

    String countryName = '';

    for (Country_ISO_Map__c countryMap : countryIsoMaps) {
      if      (country.length() == 2) {
        if (country == countryMap.alpha2Code__c) {
          countryName = countryMap.Name;
          break;
        }
      }
      else if (country.length() == 3) {
        if (country == countryMap.alpha3Code__c) {
          countryName = countryMap.Name;
          break;
        }
      }
      else {
        if (country == countryMap.Name || country == countryMap.otherName__c) {
          countryName = countryMap.Name;
          break;
        }
      }
    }

    return countryName;
  }

  public String getIsoCode(String country)
  {
    if (countryIsoMaps.isEmpty()) { return ''; }

    String isoCode = '';

    for (Country_ISO_Map__c countryMap : countryIsoMaps) {
      if      (country.length() == 2) {
        if (country == countryMap.alpha2Code__c) {
          isoCode = countryMap.alpha2Code__c;
          break;
        }
      }
      else if (country.length() == 3) {
        if (country == countryMap.alpha3Code__c) {
          isoCode = countryMap.alpha2Code__c;
          break;
        }
      }
      else {
        if (country == countryMap.Name || country == countryMap.otherName__c) {
          isoCode = countryMap.alpha2Code__c;
          break;
        }
      }
    }

    return isoCode;
  }

  public void validateAccountAddress(Account a, Boolean shouldSetIsoCode)
  {
    if (countryIsoMaps.isEmpty()) { return; }

    if (av.canBypassAddressValidationOnAccount__c == true) { return; }

    if (a.BillingCountry != null) {
      String country           = a.BillingCountry;
      String statesProvinces   = '';
      String postalCodeRegex   = '';
      String postalCodeExample = '';
      String telephoneFormats  = '';

      if (country.length() == 2) {
        Boolean isValid = false;

        for (Country_ISO_Map__c countryMap : countryIsoMaps) {
          if (country == countryMap.alpha2Code__c) {
            isValid = true;

            if (shouldSetIsoCode) { a.BillingCountry = countryMap.alpha2Code__c; }
            else                  { a.BillingCountry = countryMap.Name; }

            if (countryMap.statesProvinces__c != null) { statesProvinces = countryMap.statesProvinces__c; }
            if (countryMap.postalCodeRegex__c != null) {
              postalCodeRegex   = countryMap.postalCodeRegex__c;
              postalCodeExample = countryMap.postalCodeExample__c;
            }
            if (countryMap.telephoneFormats__c != null) { telephoneFormats = countryMap.telephoneFormats__c; }
            break;
          }
        }

        if (isValid == false) {
          List<String> args = new String[] {'alpha-2'};
          String       s    = String.format(System.Label.ERROR_INVALID_COUNTRY_ISO, args);

          a.BillingCountry.addError(s);
        }
      }
      else if (country.length() == 3) {
        Boolean isValid = false;

        for (Country_ISO_Map__c countryMap : countryIsoMaps) {
          if (country == countryMap.alpha3Code__c) {
            isValid = true;

            if (shouldSetIsoCode) { a.BillingCountry = countryMap.alpha2Code__c; }
            else                  { a.BillingCountry = countryMap.Name; }

            if (countryMap.statesProvinces__c != null) { statesProvinces   = countryMap.statesProvinces__c; }
            if (countryMap.postalCodeRegex__c != null) {
              postalCodeRegex   = countryMap.postalCodeRegex__c;
              postalCodeExample = countryMap.postalCodeExample__c;
            }
            if (countryMap.telephoneFormats__c != null) { telephoneFormats = countryMap.telephoneFormats__c; }
            break;
          }
        }

        if (isValid == false) {
          List<String> args = new String[] {'alpha-3'};
          String       s    = String.format(System.Label.ERROR_INVALID_COUNTRY_ISO, args);

          a.BillingCountry.addError(s);
        }
      }
      else {
        Boolean isValid = false;

        for (Country_ISO_Map__c countryMap : countryIsoMaps) {
          if (country == countryMap.Name || country == countryMap.otherName__c) {
            isValid = true;

            if (shouldSetIsoCode) { a.BillingCountry = countryMap.alpha2Code__c; }
            else                  { a.BillingCountry = countryMap.Name; }

            if (countryMap.statesProvinces__c != null) { statesProvinces   = countryMap.statesProvinces__c; }
            if (countryMap.postalCodeRegex__c != null) {
              postalCodeRegex   = countryMap.postalCodeRegex__c;
              postalCodeExample = countryMap.postalCodeExample__c;
            }
            if (countryMap.telephoneFormats__c != null) { telephoneFormats = countryMap.telephoneFormats__c; }
            break;
          }
        }

        if (isValid == false) { a.BillingCountry.addError(System.Label.ERROR_INVALID_COUNTRY); }
      }

      //
      // validate the State/Province (if applicable)
      //
      if (statesProvinces.length() > 0) {
        List<String> states = statesProvinces.split(',');

        Boolean isValid = false;

        for (String s : states) {
          if (a.BillingState == s) {
            isValid = true;

            a.BillingState = s;
            break;
          }
        }

        if (isValid == false) {
          List<String> args = new String[] {states[0], states[1]};
          String       s    = String.format(System.Label.ERROR_INVALID_STATE_PROVINCE, args);

          a.BillingState.addError(s);
        }
      }

      //
      // validate the ZIP/Postal code (if applicable)
      //
      if (postalCodeRegex.length() > 0) {
        if (a.BillingPostalCode != null) {
          String postalCode = a.BillingPostalCode;

          Matcher m = Pattern.compile(postalCodeRegex).matcher(postalCode);

          if (m.matches() == false) {
            List<String> args = new String[] {postalCodeExample};
            String       s    = String.format(System.Label.ERROR_INVALID_POSTAL_CODE, args);

            a.BillingPostalCode.addError(s);
          }
        }
        else {
          a.BillingPostalCode.addError(System.Label.ERROR_NO_POSTAL_CODE);
        }
      }

      //
      // validate the telephone number (if applicable)
      //
      if (telephoneFormats.length() > 0) {
        if (a.Phone != null) { validateTelephoneNumber(a, Account.SObjectType, NumberType.LANDLINE, telephoneFormats, false); }
      }

    }
    else {
      a.BillingCountry.addError(System.Label.ERROR_NO_COUNTRY);
    }

    //
    // Shipping address is optional
    //
    if (a.ShippingCountry != null) {
      String country           = a.ShippingCountry;
      String statesProvinces   = '';
      String postalCodeRegex   = '';
      String postalCodeExample = '';

      if (country.length() == 2) {
        Boolean isValid = false;

        for (Country_ISO_Map__c countryMap : countryIsoMaps) {
          if (country == countryMap.alpha2Code__c) {
            isValid = true;

            if (shouldSetIsoCode) { a.ShippingCountry = countryMap.alpha2Code__c; }
            else                  { a.ShippingCountry = countryMap.Name; }

            if (countryMap.statesProvinces__c != null) { statesProvinces = countryMap.statesProvinces__c; }
            if (countryMap.postalCodeRegex__c != null) {
              postalCodeRegex   = countryMap.postalCodeRegex__c;
              postalCodeExample = countryMap.postalCodeExample__c;
            }
            break;
          }
        }

        if (isValid == false) {
          List<String> args = new String[] {'alpha-2'};
          String       s    = String.format(System.Label.ERROR_INVALID_COUNTRY_ISO, args);

          a.ShippingCountry.addError(s);
        }
      }
      else if (country.length() == 3) {
        Boolean isValid = false;

        for (Country_ISO_Map__c countryMap : countryIsoMaps) {
          if (country == countryMap.alpha3Code__c) {
            isValid = true;

            if (shouldSetIsoCode) { a.ShippingCountry = countryMap.alpha2Code__c; }
            else                  { a.ShippingCountry = countryMap.Name; }

            if (countryMap.statesProvinces__c != null) { statesProvinces = countryMap.statesProvinces__c; }
            if (countryMap.postalCodeRegex__c != null) {
              postalCodeRegex   = countryMap.postalCodeRegex__c;
              postalCodeExample = countryMap.postalCodeExample__c;
            }
            break;
          }
        }

        if (isValid == false) {
          List<String> args = new String[] {'alpha-3'};
          String       s    = String.format(System.Label.ERROR_INVALID_COUNTRY_ISO, args);

          a.ShippingCountry.addError(s);
        }
      }
      else {
        Boolean isValid = false;

        for (Country_ISO_Map__c countryMap : countryIsoMaps) {
          if (country == countryMap.Name || country == countryMap.otherName__c) {
            isValid = true;

            if (shouldSetIsoCode) { a.ShippingCountry = countryMap.alpha2Code__c; }
            else                  { a.ShippingCountry = countryMap.Name; }

            if (countryMap.statesProvinces__c != null) { statesProvinces = countryMap.statesProvinces__c; }
            if (countryMap.postalCodeRegex__c != null) {
              postalCodeRegex   = countryMap.postalCodeRegex__c;
              postalCodeExample = countryMap.postalCodeExample__c;
            }
            break;
          }
        }

        if (isValid == false) { a.ShippingCountry.addError(System.Label.ERROR_INVALID_COUNTRY); }
      }

      //
      // validate the State/Province (if applicable)
      //
      if (statesProvinces.length() > 0) {
        List<String> states = statesProvinces.split(',');

        Boolean isValid = false;

        for (String s : states) {
          if (a.ShippingState == s) {
            isValid = true;

            a.ShippingState = s;
            break;
          }
        }

        if (isValid == false) {
          List<String> args = new String[] {states[0], states[1]};
          String       s    = String.format(System.Label.ERROR_INVALID_STATE_PROVINCE, args);

          a.ShippingState.addError(s);
        }
      }

      //
      // validate the ZIP/Postal code (if applicable)
      //
      if (postalCodeRegex.length() > 0) {
        if (a.ShippingPostalCode != null) {
          String postalCode = a.ShippingPostalCode;

          Matcher m = Pattern.compile(postalCodeRegex).matcher(postalCode);

          if (m.matches() == false) {
            List<String> args = new String[] {postalCodeExample};
            String       s    = String.format(System.Label.ERROR_INVALID_POSTAL_CODE, args);

            a.ShippingPostalCode.addError(s);
          }
        }
        else {
          a.ShippingPostalCode.addError(System.Label.ERROR_NO_POSTAL_CODE);
        }
      }
    }

  }

  public void validateAccountAddress(List<Account> accounts, Boolean shouldSetIsoCode)
  {
    if (countryIsoMaps.isEmpty()) { return; }

    if (av.canBypassAddressValidationOnAccount__c == true) { return; }

    for (Account a : accounts) {
        validateAccountAddress(a, shouldSetIsoCode);
    }
  }

  public void validateContactAddress(Contact c, Boolean shouldSetIsoCode)
  {
    if (countryIsoMaps.isEmpty()) { return; }

    if (av.canBypassAddressValidationOnContact__c == true) { return; }

    if (c.MailingCountry != null) {
      String country           = c.MailingCountry;
      String statesProvinces   = '';
      String postalCodeRegex   = '';
      String postalCodeExample = '';
      String telephoneFormats  = '';

      if (country.length() == 2) {
        Boolean isValid = false;

        for (Country_ISO_Map__c countryMap : countryIsoMaps) {
          if (country == countryMap.alpha2Code__c) {
            isValid = true;

            if (shouldSetIsoCode) { c.MailingCountry = countryMap.alpha2Code__c; }
            else                  { c.MailingCountry = countryMap.Name; }

            if (countryMap.statesProvinces__c != null) { statesProvinces = countryMap.statesProvinces__c; }
            if (countryMap.postalCodeRegex__c != null) {
              postalCodeRegex   = countryMap.postalCodeRegex__c;
              postalCodeExample = countryMap.postalCodeExample__c;
            }
            if (countryMap.telephoneFormats__c != null) { telephoneFormats = countryMap.telephoneFormats__c; }
            break;
          }
        }

        if (isValid == false) {
          List<String> args = new String[] {'alpha-2'};
          String       s    = String.format(System.Label.ERROR_INVALID_COUNTRY_ISO, args);

          c.MailingCountry.addError(s);
        }
      }
      else if (country.length() == 3) {
        Boolean isValid = false;

        for (Country_ISO_Map__c countryMap : countryIsoMaps) {
          if (country == countryMap.alpha3Code__c) {
            isValid = true;

            if (shouldSetIsoCode) { c.MailingCountry = countryMap.alpha2Code__c; }
            else                  { c.MailingCountry = countryMap.Name; }

            if (countryMap.statesProvinces__c != null) { statesProvinces = countryMap.statesProvinces__c; }
            if (countryMap.postalCodeRegex__c != null) {
              postalCodeRegex   = countryMap.postalCodeRegex__c;
              postalCodeExample = countryMap.postalCodeExample__c;
            }
            if (countryMap.telephoneFormats__c != null) { telephoneFormats = countryMap.telephoneFormats__c; }
            break;
          }
        }

        if (isValid == false) {
          List<String> args = new String[] {'alpha-3'};
          String       s    = String.format(System.Label.ERROR_INVALID_COUNTRY_ISO, args);

          c.MailingCountry.addError(s);
        }

      }
      else {
        Boolean isValid = false;

        for (Country_ISO_Map__c countryMap : countryIsoMaps) {
          if (country == countryMap.Name || country == countryMap.otherName__c) {
            isValid = true;

            if (shouldSetIsoCode) { c.MailingCountry = countryMap.alpha2Code__c; }
            else                  { c.MailingCountry = countryMap.Name; }

            if (countryMap.statesProvinces__c != null) { statesProvinces = countryMap.statesProvinces__c; }
            if (countryMap.postalCodeRegex__c != null) {
              postalCodeRegex   = countryMap.postalCodeRegex__c;
              postalCodeExample = countryMap.postalCodeExample__c;
            }
            if (countryMap.telephoneFormats__c != null) { telephoneFormats = countryMap.telephoneFormats__c; }
            break;
          }
        }

        if (isValid == false) { c.MailingCountry.addError(System.Label.ERROR_INVALID_COUNTRY); }
      }

      //
      // validate the State/Province (if applicable)
      //
      if (statesProvinces.length() > 0) {
        List<String> states = statesProvinces.split(',');

        Boolean isValid = false;

        for (String s : states) {
          if (c.MailingState == s) {
            isValid = true;

            c.MailingState = s;
            break;
          }
        }

        if (isValid == false) {
          List<String> args = new String[] {states[0], states[1]};
          String       s    = String.format(System.Label.ERROR_INVALID_STATE_PROVINCE, args);

          c.MailingState.addError(s);
        }
      }

      //
      // validate the ZIP/Postal code (if applicable)
      //
      if (postalCodeRegex.length() > 0) {
        if (c.MailingPostalCode != null) {
          String postalCode = c.MailingPostalCode;

          Matcher m = Pattern.compile(postalCodeRegex).matcher(postalCode);

          if (m.matches() == false) {
            List<String> args = new String[] {postalCodeExample};
            String       s    = String.format(System.Label.ERROR_INVALID_POSTAL_CODE, args);

            c.MailingPostalCode.addError(s);
          }
        }
        else {
          c.MailingPostalCode.addError(System.Label.ERROR_NO_POSTAL_CODE);
        }
      }

      //
      // validate the telephone numbers (if applicable)
      //
      if (telephoneFormats.length() > 0) {
        if (c.Phone != null)        { validateTelephoneNumber(c, Contact.SObjectType, NumberType.LANDLINE, telephoneFormats, false); }
        if (c.MobilePhone != null) { validateTelephoneNumber(c, Contact.SObjectType, NumberType.MOBILE, telephoneFormats, false); }
        if (c.OtherPhone != null)  { validateTelephoneNumber(c, Contact.SObjectType, NumberType.EITHER, telephoneFormats, true); }
      }

    }
    else {
      c.MailingCountry.addError(System.Label.ERROR_NO_COUNTRY);
    }

  }

  public void validateContactAddress(List<Contact> contacts, Boolean shouldSetIsoCode)
  {
    if (countryIsoMaps.isEmpty()) { return; }

    if (av.canBypassAddressValidationOnContact__c == true) { return; }

    for (Contact c : contacts) {
        validateContactAddress(c, shouldSetIsoCode);
    }
  }

  public void validateLeadAddress(Lead l, Boolean shouldSetIsoCode)
  {
    if (countryIsoMaps.isEmpty()) { return; }

    if (av.canBypassAddressValidationOnLead__c == true) { return; }

    if (l.Country != null) {
      String country           = l.Country;
      String statesProvinces   = '';
      String postalCodeRegex   = '';
      String postalCodeExample = '';
      String telephoneFormats  = '';

      if (country.length() == 2) {
        Boolean isValid = false;

        for (Country_ISO_Map__c countryMap : countryIsoMaps) {
          if (country == countryMap.alpha2Code__c) {
            isValid = true;

            if (shouldSetIsoCode) { l.Country = countryMap.alpha2Code__c; }
            else                  { l.Country = countryMap.Name; }

            if (countryMap.statesProvinces__c != null) { statesProvinces = countryMap.statesProvinces__c; }
            if (countryMap.postalCodeRegex__c != null) {
              postalCodeRegex   = countryMap.postalCodeRegex__c;
              postalCodeExample = countryMap.postalCodeExample__c;
            }
            if (countryMap.telephoneFormats__c != null) { telephoneFormats = countryMap.telephoneFormats__c; }
            break;
          }
        }

        if (isValid == false) {
          List<String> args = new String[] {'alpha-2'};
          String       s    = String.format(System.Label.ERROR_INVALID_COUNTRY_ISO, args);

          l.Country.addError(s);
        }
      }
      else if (country.length() == 3) {
        Boolean isValid = false;

        for (Country_ISO_Map__c countryMap : countryIsoMaps) {
          if (country == countryMap.alpha3Code__c) {
            isValid = true;

            if (shouldSetIsoCode) { l.Country = countryMap.alpha2Code__c; }
            else                  { l.Country = countryMap.Name; }

            if (countryMap.statesProvinces__c != null) { statesProvinces = countryMap.statesProvinces__c; }
            if (countryMap.postalCodeRegex__c != null) {
              postalCodeRegex   = countryMap.postalCodeRegex__c;
              postalCodeExample = countryMap.postalCodeExample__c;
            }
            if (countryMap.telephoneFormats__c != null) { telephoneFormats = countryMap.telephoneFormats__c; }
            break;
          }
        }

        if (isValid == false) {
          List<String> args = new String[] {'alpha-3'};
          String       s    = String.format(System.Label.ERROR_INVALID_COUNTRY_ISO, args);

          l.Country.addError(s);
        }
      }
      else {
        Boolean isValid = false;

        for (Country_ISO_Map__c countryMap : countryIsoMaps) {
          if (country == countryMap.Name || country == countryMap.otherName__c) {
            isValid = true;

            if (shouldSetIsoCode) { l.Country = countryMap.alpha2Code__c; }
            else                  { l.Country = countryMap.Name; }

            if (countryMap.statesProvinces__c != null) { statesProvinces = countryMap.statesProvinces__c; }
            if (countryMap.postalCodeRegex__c != null) {
              postalCodeRegex   = countryMap.postalCodeRegex__c;
              postalCodeExample = countryMap.postalCodeExample__c;
            }
            if (countryMap.telephoneFormats__c != null) { telephoneFormats = countryMap.telephoneFormats__c; }
            break;
          }
        }

        if (isValid == false) { l.Country.addError(System.Label.ERROR_INVALID_COUNTRY); }
      }

      //
      // validate the State (if applicable)
      //
      if (statesProvinces.length() > 0) {
        List<String> states = statesProvinces.split(',');

        Boolean isValid = false;

        for (String s : states) {
          if (l.State == s) {
            isValid = true;

            l.State = s;
            break;
          }
        }

        if (isValid == false) {
          List<String> args = new String[] {states[0], states[1]};
          String       s    = String.format(System.Label.ERROR_INVALID_STATE_PROVINCE, args);

          l.State.addError(s);
        }
      }

      //
      // validate the ZIP/Postal code (if applicable)
      //
      if (postalCodeRegex.length() > 0) {
        if (l.PostalCode != null) {
          String postalCode = l.PostalCode;

          Matcher m = Pattern.compile(postalCodeRegex).matcher(postalCode);

          if (m.matches() == false) {
            List<String> args = new String[] {postalCodeExample};
            String       s    = String.format(System.Label.ERROR_INVALID_POSTAL_CODE, args);

            l.PostalCode.addError(s);
          }
        }
        else {
          l.PostalCode.addError(System.Label.ERROR_NO_POSTAL_CODE);
        }
      }

      //
      // validate the telephone number (if applicable)
      //
      if (telephoneFormats.length() > 0) {
        if (l.Phone != null)        { validateTelephoneNumber(l, Lead.SObjectType, NumberType.LANDLINE, telephoneFormats, false); }
        if (l.MobilePhone != null) { validateTelephoneNumber(l, Lead.SObjectType, NumberType.MOBILE, telephoneFormats, false); }
      }

    }
    else {
      l.Country.addError(System.Label.ERROR_NO_COUNTRY);
    }

  }

  public void validateLeadAddress(List<Lead> leads, Boolean shouldSetIsoCode)
  {
    if (countryIsoMaps.isEmpty()) { return; }

    if (av.canBypassAddressValidationOnLead__c == true) { return; }

    for (Lead l : leads) {
       validateLeadAddress(l, shouldSetIsoCode);
    }
  }

  public void setErrorMessage(SObject obj, Schema.SObjectType soType, NumberType type, String message)
  {
      if       (soType == Account.SObjectType) {
        Account a = (Account)obj;

        if       (type == NumberType.LANDLINE) { a.Phone.addError(message); }
      }
      else if (soType == Contact.SObjectType) {
        Contact c = (Contact)obj;

        if       (type == NumberType.LANDLINE) { c.Phone.addError(message); }
        else if (type == NumberType.MOBILE)    { c.MobilePhone.addError(message); }
        else                                  { c.OtherPhone.addError(message); }
      }
      else if (soType == Lead.SObjectType) {
        Lead l = (Lead)obj;

        if       (type == NumberType.LANDLINE) { l.Phone.addError(message); }
        else if (type == NumberType.MOBILE)    { l.MobilePhone.addError(message); }
      }
  }

  private Boolean validateTelephoneNumber(SObject obj, Schema.SObjectType soType, NumberType type, String telephoneFormats, Boolean canChangeCountry)
  {
    String telephoneNumber = '';

    if       (type == NumberType.LANDLINE) { telephoneNumber = (String)obj.get('Phone'); }
     else if (type == NumberType.MOBILE)    { telephoneNumber = (String)obj.get('MobilePhone'); }
     else                                  { telephoneNumber = (String)obj.get('OtherPhone'); }

    if (telephoneNumber.left(1) == '!') {                                       // we want to bypass the validation checks
      if       (type == NumberType.LANDLINE) { obj.put('Phone', telephoneNumber.substring(1)); }
      else if (type == NumberType.MOBILE)    { obj.put('MobilePhone', telephoneNumber.substring(1)); }
      else                                  { obj.put('OtherPhone', telephoneNumber.substring(1)); }

      System.debug(LoggingLevel.WARN, 'user: ' + UserInfo.getName() + ' bypassed the validation of the telephone number: ' + telephoneNumber);

      return true;
    }

    JsonTelephone jt = null;

    try {
      jt = JsonTelephone.parse(telephoneFormats);
    }
    catch (exception e) {
      String s = 'JsonTelephone::parse() failed: ' + e.getMessage();

      setErrorMessage(obj, soType, type, s);

      return false;
    }

    Integer nFormats = jt.formats.size();

    String extension = '';

    Integer pos = telephoneNumber.indexOf('ext');

    if (pos == -1) { pos       = telephoneNumber.indexOf('x'); }
    if (pos != -1) { extension = telephoneNumber.substring(pos); }

    if (extension.length() > 0) { telephoneNumber = telephoneNumber.left(pos - 1); }

    Integer nCountryCode = jt.countryCode.length();
    Integer nTrunkPrefix = jt.trunkPrefix.length();

    Boolean isValid = false;

    if (telephoneNumber.left(1) == '+') {
      if (telephoneNumber.left(nCountryCode) != jt.countryCode) {
        if (canChangeCountry == false) {
           List<String> args = null;

           if      (type == NumberType.LANDLINE) { args = new String[] {jt.exampleLandLine}; }
           else if (type == NumberType.MOBILE)   { args = new String[] {jt.exampleMobile}; }
           else                                  { args = new String[] {jt.exampleLandLine + '/' + jt.exampleMobile}; }

          String s = String.format(System.Label.ERROR_INVALID_TELEPHONE_NUMBER, args);

           setErrorMessage(obj, soType, type, s);

           return false;
         }

         pos = telephoneNumber.indexOf(' ');                                     // we need a space after the country code to delimit otherwise we will just error...

         if (pos == -1) {
           List<String> args = null;

           if      (type == NumberType.LANDLINE) { args = new String[] {jt.exampleLandLine}; }
           else if (type == NumberType.MOBILE)   { args = new String[] {jt.exampleMobile}; }
           else                                  { args = new String[] {jt.exampleLandLine + '/' + jt.exampleMobile}; }

          String s = String.format(System.Label.ERROR_INVALID_TELEPHONE_NUMBER, args);

           setErrorMessage(obj, soType, type, s);

           return false;
         }

         String s1 = telephoneNumber.left(pos);

         //
         // enumerate the map
         //
        isValid = false;

        for (Country_ISO_Map__c countryMap : countryIsoMaps) {
          if (countryMap.countryCode__c != null) {
             List<String> codes = countryMap.countryCode__c.split(',');

             for (String s2 : codes) {
               if (s1 == s2) {
                 if (countryMap.telephoneFormats__c == null) { return true; }    // no formats so just return

                isValid = true;

                telephoneFormats = countryMap.telephoneFormats__c;

                try {
                   jt = JsonTelephone.parse(telephoneFormats);
                }
                catch (exception e) {
                   obj.addError('JsonTelephone::parse() failed: ' + e.getMessage());  // page error not field error so we can do this way

                   return false;
                }

                nFormats     = jt.formats.size();
                nCountryCode = jt.countryCode.length();
                nTrunkPrefix = jt.trunkPrefix.length();

                break;
              }
            }
          }
        }

        if (isValid == false) { return true; }                                  // we could not find the country calling code so just return
      }
    }

    //
    // remove the country code and trunk prefix if present, and all non-digits
    //
    String e = '\\D*\\' + jt.countryCode + '?';

    telephoneNumber = telephoneNumber.replaceFirst(e, '');                      // remove country code
    telephoneNumber = telephoneNumber.replaceAll('\\D+', '');                    // remove non-digits

    if (nTrunkPrefix > 0) {
      if (telephoneNumber.left(nTrunkPrefix) == jt.trunkPrefix) { telephoneNumber = telephoneNumber.substring(nTrunkPrefix); }
    }

    Integer i = 0;

    for (i = 0; i < nFormats; i++) {
      Boolean canProcess = false;

      if      (type == NumberType.LANDLINE && jt.formats[i].isLandLine == true) { canProcess = true; }
      else if (type == NumberType.MOBILE   && jt.formats[i].isMobile == true)   { canProcess = true; }
      else if (type == NumberType.EITHER)                                       { canProcess = true; }  // numberType.EITHER signifies the number can be either a landline or mobile

      if (canProcess) {
        if (telephoneNumber.length() < jt.formats[i].minLength || telephoneNumber.length() > jt.formats[i].maxLength) { canProcess = false; }
      }

      if (canProcess) {
        Pattern p = Pattern.compile(jt.formats[i].deconstructor);
        Matcher m = p.matcher(telephoneNumber);

         if (m.matches() == true) {
          isValid = true;

          List<String> ls = new List<String>();

          ls.add(jt.countryCode);

          Integer j = 0;

          for (j = 1; j <= m.groupCount(); j++) {
             ls.add(m.group(j));
          }

          telephoneNumber = '';

          if (extension.length() == 0) { telephoneNumber = String.format(jt.formats[i].constructor, ls); }
          else                         { telephoneNumber = String.format(jt.formats[i].constructor, ls) + ' x' + extension.replaceAll('[^0-9]', ''); }

          if       (type == NumberType.LANDLINE) { obj.put('Phone', telephoneNumber); }
          else if (type == NumberType.MOBILE)    { obj.put('MobilePhone', telephoneNumber); }
          else                                  { obj.put('OtherPhone', telephoneNumber); }

          break;
        }
      }
    }

    if (isValid == false) {
      List<String> args = null;

      if      (type == NumberType.LANDLINE) { args = new String[] {jt.exampleLandLine}; }
      else if (type == NumberType.MOBILE)   { args = new String[] {jt.exampleMobile}; }
      else                                  { args = new String[] {jt.exampleLandLine + '/' + jt.exampleMobile}; }

      String s = String.format(System.Label.ERROR_INVALID_TELEPHONE_NUMBER, args);

      setErrorMessage(obj, soType, type, s);

      return false;
    }

    return true;
  }

}