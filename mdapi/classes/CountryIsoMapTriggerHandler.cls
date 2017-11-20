/**
  \file         CountryIsoMapTriggerHandler.cls
  \brief        This class will implement a trigger handler for the Country_ISO_Map__c custom object
  \details      JIRA ticket(s): SSF-62, SSF-65
  \author       Matt Thompson-Moltzen
  \version      1.2
  \date         22 August 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.1       2017-08-16  Matt Thompson-Moltzen   Validate individual deconstructor regex in telephone formats (SSF-501).
  1.2       2017-08-22  Matt Thompson-Moltzen   Added disabled trigger functionality (SSF-528).
*/
public with sharing class CountryIsoMapTriggerHandler implements TriggerSingularInterface
{
  //
  // variables
  //
  private static Boolean isDisabled = false;


  public static void disableTrigger()
  {
    isDisabled = true;
  }

  public static void enableTrigger()
  {
    isDisabled = false;
  }

	//
  // constructor
  //
  public CountryIsoMapTriggerHandler()
  {
  }

  public Boolean isDisabled()
  {
    triggerDisablement__c td = triggerDisablement__c.getInstance('countryIsoMapTrigger');

    if      (td == null)               { return isDisabled; }
    else if (td.isDisabled__c == true) { return true; }
    else                               { return isDisabled; }
  }

	//
 	// member functions/methods - define all methods from the interface even if not used
	//
  public void preBeforeOperations()
  {
  }

  public void beforeInsert(SObject newObject)
  {
  	Country_ISO_Map__c cim = (Country_ISO_Map__c)newObject;

      if (cim.postalCodeRegex__c == null) {
          cim.postalCodeExample__c = '';
      }
      else {
        Pattern p = null;

        try {
          p = Pattern.compile(cim.postalCodeRegex__c);
        }
        catch (Exception e) {
          cim.postalCodeRegex__c.addError(e.getMessage());
        }
      }

      if (cim.countryCode__c != null) {
        List<String> codes = cim.countryCode__c.split(',');

        for (String s : codes) {
          Matcher m = Pattern.compile('^\\+(\\d{1,3})(\\-\\d{1,5})?$').matcher(s);

          if (m.matches() == false) { cim.countryCode__c.addError('invalid format for the Country Calling Code: examples are +1 (US), +1-441 (Bermuda)'); }
        }
      }

      if (cim.telephoneFormats__c != null) {
        if (cim.countryCode__c == null) { cim.countryCode__c.addError('specify the Country Calling Code (include \'+\' at the beginning)'); }

        JsonTelephone jt = null;

        try {
          jt = JsonTelephone.parse(cim.telephoneFormats__c);
        }
        catch (Exception e) {
          cim.telephoneFormats__c.addError('invalid JSON document format: ' + e.getMessage());
        }

        if (jt != null) {
          Integer nFormats = jt.formats.size();
          Integer i = 0;

          for (i = 0; i < nFormats; i++) {
            Pattern p = null;

            try {
              p = Pattern.compile(jt.formats[i].deconstructor);
            }
            catch (Exception e) {
              cim.telephoneFormats__c.addError('invalid deconstructor regex: ' + e.getMessage());
            }
          }
        }
      }
  	}

  	public void beforeUpdate(SObject oldObject, SObject newObject)
  	{
  		Country_ISO_Map__c cim = (Country_ISO_Map__c)newObject;

      if (cim.postalCodeRegex__c == null) {
        cim.postalCodeExample__c = '';
      }
      else {
        Pattern p = null;

        try {
          p = Pattern.compile(cim.postalCodeRegex__c);
        }
        catch (Exception e) {
          cim.postalCodeRegex__c.addError(e.getMessage());
        }
      }

      if (cim.countryCode__c != null) {
        List<String> codes = cim.countryCode__c.split(',');

        for (String s : codes) {
          Matcher m = Pattern.compile('^\\+(\\d{1,3})(\\-\\d{1,5})?$').matcher(s);

          if (m.matches() == false) { cim.countryCode__c.addError('invalid format for the Country Calling Code: examples are +1 (US), +1-441 (Bermuda)'); }
        }
      }

      if (cim.telephoneFormats__c != null) {
        if (cim.countryCode__c == null) { cim.countryCode__c.addError('specify the Country Calling Code (include \'+\' at the beginning)'); }

        JsonTelephone jt = null;

        try {
          jt = JsonTelephone.parse(cim.telephoneFormats__c);
        }
        catch (Exception e) {
          cim.telephoneFormats__c.addError('invalid JSON document format: ' + e.getMessage());
        }

        if (jt != null) {
          Integer nFormats = jt.formats.size();
          Integer i = 0;

          for (i = 0; i < nFormats; i++) {
            Pattern p = null;

            try {
              p = Pattern.compile(jt.formats[i].deconstructor);
            }
            catch (Exception e) {
              cim.telephoneFormats__c.addError('invalid deconstructor regex: ' + e.getMessage());
            }
          }
        }
      }
  	}

  	public void beforeDelete(SObject oldObject)
  	{
  	}

  	public void preAfterOperations()
  	{
  	}

  	public void afterInsert(SObject newObject)
  	{
  	}

  	public void afterUpdate(SObject oldObject, SObject newObject)
  	{
  	}

  	public void afterDelete(SObject oldObject)
  	{
  	}

  	public void postOperations()
  	{
  	}

}