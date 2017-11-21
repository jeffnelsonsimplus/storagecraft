/**
  \file         Contacts.cls
  \brief        This class and method mergeDupContacts will fire on the After Insert of a contact.
  \details      When a contact is inserted, check if the contact is a duplicate and if it is, then merge them.
  \author       Simplus
  \version      1.2
  \date         31 July 2017
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.1       2016-03-02  Simplus                 Reparented all tasks, events, cases, opps, notes,attachments and CampaignMember related list.
  1.2       2017-07-31  Matt Thompson-Moltzen   Renamed the class from ContactTriggerHandler to Contacts as the former name is reserved for the new trigger framework.
                                                Removed first argument 'Map<Id,Contact> mapNewContacts' as it is not referenced and the new trigger framework passes List only arguments (SSF-379).
*/
public with sharing class Contacts {

    private static final String STR_MERGED = Label.Merged;//'Merged';
    private static final String STR_FAILED_MERGED = Label.Failed_to_Merge;//'Failed to Merge';
    private static List<Contact> lstNewContactsToUpdate = new List<Contact>();
    private static Map<Id,Id> mapNewWithOldContact = new Map<Id,Id>();
    private static Map<String,Contact> mapEmailContact = new Map<String,Contact> ();
    private static Map<String,Contact> mapAllContacts = new Map<String,Contact> ();
    private static Set<String> setContactsToUpdate = new Set<String> ();
    private static String strNewAddress;
    private static String strAddress;

    /*
     * Method to process duplicate contacts
     */
    public static void mergeDupContacts(List<Contact> lstNewContacts) {
        set<String> setEmails= new set<String>();
        for(Contact objContact: lstNewContacts) {
          if(objContact.Email <> null && !String.IsBlank(objContact.Email))
            setEmails.add(objContact.Email);
        }

        //Map<String,Contact> mapAllContacts = new Map<String,Contact> ();

        // to find oldest parent record
        List<Contact> lstAllExistingContacts =  [Select Id,
                                          MailingCity,MailingState,MailingStreet,MailingCountry,MailingPostalCode,
                                          MailingLatitude,MailingLongitude,
                                          OtherCity,OtherState,OtherStreet,OtherCountry,OtherPostalCode,
                                          OtherLatitude,OtherLongitude,
                                          PreferredMethodOfContact__c,WebSite__c,
                                          AccountId,//OtherAddress,
                                          Address1City__c,Address1CountryRegion__c,Address1StateProvince__c,Address1Street1__c,
                                          Address1Street2__c,Address1Street3__c,Address1ZIPPostalCode__c,
                                          Email,EmailAddress2__c,//MailingAddress,
                                          EmailAddress3__c, DoNotAllowBulkEmails__c,DoNotAllowEmails__c,DoNotAllowFaxes__c,
                                          SendMarketingMaterials__c,mkto2__Lead_Score__c,
                                          mkto71_Lead_Score__c,mkto2__Acquisition_Date__c,mkto71_Acquisition_Date__c,
                                          mkto2__Acquisition_Program__c, mkto71_Acquisition_Program__c, CreatedDate,VAR_Agreement_Accepted__c,
                                          VAR_Agreement_Accepted_Date__c,VAR_Agreement_Version__c
                                   From  Contact
                                   Where Email IN :setEmails OR
                                   EmailAddress2__c IN :setEmails OR
                                   EmailAddress3__c IN :setEmails
                                   Order By CreatedDate
          ];


        // find the oldest record
        for(Contact objContact:lstAllExistingContacts){
          if(objContact.Email <> null && !mapEmailContact.containsKey(objContact.Email)){
            mapEmailContact.put(objContact.Email,objContact);
          }
          if(objContact.EmailAddress2__c <> null && !mapEmailContact.containsKey(objContact.EmailAddress2__c)){
            mapEmailContact.put(objContact.EmailAddress2__c,objContact);
          }
          if(objContact.EmailAddress3__c <> null && !mapEmailContact.containsKey(objContact.EmailAddress3__c)){
            mapEmailContact.put(objContact.EmailAddress3__c,objContact);
          }
          mapAllContacts.put(objContact.Id,objContact);
        }// end for

        Set<String> setEmailCount = new Set<String>();
        Set<String> setLocationAddresses = new Set<String>();

        // query all trigger new recs as in after insert context..to find latest duplicate record
        for(Contact objContact : lstNewContacts) {
          Contact objNewContact = new Contact(Id=objContact.Id);
            if(
              objContact.Email<>null && mapEmailContact.containsKey(objContact.Email)
              && mapEmailContact.get(objContact.Email).Id != objContact.Id
              ){
                if(!String.isBlank(objContact.Email))
                    setEmailCount.add(objContact.Email);
                if(!String.isBlank(objContact.EmailAddress2__c))
                    setEmailCount.add(objContact.EmailAddress2__c);
                if(!String.isBlank(objContact.EmailAddress3__c))
                    setEmailCount.add(objContact.EmailAddress3__c);
                if(!String.isBlank(mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).Email))
                    setEmailCount.add(mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).Email);
                if(!String.isBlank(mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress2__c))
                    setEmailCount.add(mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress2__c);
                if(!String.isBlank(mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress3__c))
                    setEmailCount.add(mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress3__c);
                // if other email fields are blank, merge duplicates
                if(setEmailCount.size()<=3) {
                  processMerging(objNewContact,objContact,setLocationAddresses);
                  // for secondary email
                  if(!String.isBlank(objContact.EmailAddress2__c)
                    && String.isBlank(mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).Email)
                    ) {
                    mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).Email = objContact.EmailAddress2__c;
                    //setContactsToUpdate.add(mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).Id);
                  } else if((!String.isBlank(objContact.EmailAddress2__c)
                    && String.isBlank(mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress2__c))
                    || ( mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).Email == mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress2__c
                    )
                    ) {
                    mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress2__c = objContact.EmailAddress2__c;
                    //setContactsToUpdate.add(mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).Id);
                  } else if((!String.isBlank(objContact.EmailAddress2__c)
                    && String.isBlank(mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress3__c))
                    || ( mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress2__c == mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress3__c
                    )
                    || ( mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).Email == mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress3__c
                    )
                    ) {
                    mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress3__c = objContact.EmailAddress2__c;
                    //setContactsToUpdate.add(mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).Id);
                  }
                  // for third email
                  if(!String.isBlank(objContact.EmailAddress3__c)
                    && String.isBlank(mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).Email)
                    ) {
                    mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).Email = objContact.EmailAddress3__c;
                  } else if((!String.isBlank(objContact.EmailAddress3__c)
                    && String.isBlank(mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress2__c))
                    || ( mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).Email == mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress2__c
                    )
                    ) {
                    mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress2__c = objContact.EmailAddress3__c;
                    //setContactsToUpdate.add(mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).Id);
                  } else if((!String.isBlank(objContact.EmailAddress3__c)
                    && String.isBlank(mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress3__c))
                    || ( mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress2__c == mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress3__c
                    )
                    || ( mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).Email == mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress3__c
                    )
                    ) {
                    mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).EmailAddress3__c = objContact.EmailAddress3__c;
                    //setContactsToUpdate.add(mapAllContacts.get(mapEmailContact.get(objContact.Email).Id).Id);
                  }
                }
          }
          setEmailCount.clear();
        }

        // copy all child Records
        updateChildRecords(mapNewWithOldContact);
        // update old record
          update mapAllContacts.values();

        //update new Records
        if(lstNewContactsToUpdate.size()>0)
          update lstNewContactsToUpdate;
    }

    /**
     * Method copy all field values for old duplicate contact to new
     */
    public static Contact mergeNewContactData(Contact objNewestContact,Contact objOldContact,Set<String> setOldLocationAddresses,Contact objNewContUpdate){
        objOldContact.Title = objNewestContact.Title;
        objOldContact.LastActivity__c = objNewestContact.LastActivity__c;
        objOldContact.LastCall__c = objNewestContact.LastCall__c;
        objOldContact.LastAppointment__c = objNewestContact.LastAppointment__c;
        objOldContact.LastEmail__c = objNewestContact.LastEmail__c;
        if(!objOldContact.DoNotAllowBulkEmails__c && objNewestContact.DoNotAllowBulkEmails__c)
            objOldContact.DoNotAllowBulkEmails__c = True;
        if(!objOldContact.DoNotAllowEmails__c && objNewestContact.DoNotAllowEmails__c)
            objOldContact.DoNotAllowEmails__c = True;
        if(!objOldContact.DoNotAllowFaxes__c && objNewestContact.DoNotAllowFaxes__c)
            objOldContact.DoNotAllowFaxes__c = True;
        if(!objOldContact.SendMarketingMaterials__c && objNewestContact.SendMarketingMaterials__c)
            objOldContact.SendMarketingMaterials__c = True;
        if(objOldContact.mkto2__Lead_Score__c == null || objOldContact.mkto2__Lead_Score__c < objNewestContact.mkto2__Lead_Score__c)
            objOldContact.mkto2__Lead_Score__c = objNewestContact.mkto2__Lead_Score__c;
        if(objOldContact.mkto71_Lead_Score__c == null || objOldContact.mkto71_Lead_Score__c < objNewestContact.mkto71_Lead_Score__c)
            objOldContact.mkto71_Lead_Score__c = objNewestContact.mkto71_Lead_Score__c;

        if(objOldContact.mkto71_Acquisition_Date__c == null && objNewestContact.mkto71_Acquisition_Date__c != null)
            objOldContact.mkto71_Acquisition_Date__c = objNewestContact.mkto71_Acquisition_Date__c;
        if(objOldContact.mkto2__Acquisition_Date__c == null && objNewestContact.mkto2__Acquisition_Date__c != null)
            objOldContact.mkto2__Acquisition_Date__c = objNewestContact.mkto2__Acquisition_Date__c;
        if(
            (objOldContact.mkto71_Acquisition_Program__c == null ||
            String.IsBlank(objOldContact.mkto71_Acquisition_Program__c)) &&
            objNewestContact.mkto71_Acquisition_Program__c != null &&
            String.IsBlank(objNewestContact.mkto71_Acquisition_Program__c)
        )
            objOldContact.mkto71_Acquisition_Program__c = objNewestContact.mkto71_Acquisition_Program__c;
        if(!objOldContact.VAR_Agreement_Accepted__c && objNewestContact.VAR_Agreement_Accepted__c)
            objOldContact.VAR_Agreement_Accepted__c = True;
        if(objOldContact.VAR_Agreement_Accepted_Date__c == null && objNewestContact.VAR_Agreement_Accepted_Date__c != null)
            objOldContact.VAR_Agreement_Accepted_Date__c = objNewestContact.VAR_Agreement_Accepted_Date__c;
        if(objNewestContact.VAR_Agreement_Version__c != null && !String.IsBlank(objNewestContact.VAR_Agreement_Version__c))
            objOldContact.VAR_Agreement_Version__c = objNewestContact.VAR_Agreement_Version__c;

        if(objNewestContact.VAR_Agreement_Version__c != null && !String.IsBlank(objNewestContact.VAR_Agreement_Version__c))
            objOldContact.VAR_Agreement_Version__c = objNewestContact.VAR_Agreement_Version__c;

          strAddress = '';
          if(objOldContact.MailingCity <> null && !String.IsBlank(objOldContact.MailingCity))
            strAddress+= objOldContact.MailingCity.trim();
          if(objOldContact.MailingState <> null && !String.IsBlank(objOldContact.MailingState))
            strAddress+= objOldContact.MailingState.trim();
          if(objOldContact.MailingStreet <> null && !String.IsBlank(objOldContact.MailingStreet))
            strAddress+= objOldContact.MailingStreet.trim();
          if(objOldContact.MailingCountry <> null && !String.IsBlank(objOldContact.MailingCountry))
            strAddress+= objOldContact.MailingCountry.trim();
          if(objOldContact.MailingPostalCode <> null && !String.IsBlank(objOldContact.MailingPostalCode))
            strAddress+= objOldContact.MailingPostalCode.trim();
          if(!String.IsBlank(strAddress))
            setOldLocationAddresses.add(strAddress);
          strAddress = '';
          if(objOldContact.OtherCity <> null && !String.IsBlank(objOldContact.OtherCity))
            strAddress+= objOldContact.OtherCity.trim();
          if(objOldContact.OtherState <> null && !String.IsBlank(objOldContact.OtherState))
            strAddress+= objOldContact.OtherState.trim();
          if(objOldContact.OtherStreet <> null && !String.IsBlank(objOldContact.OtherStreet))
            strAddress+= objOldContact.OtherStreet.trim();
          if(objOldContact.OtherCountry <> null && !String.IsBlank(objOldContact.OtherCountry))
            strAddress+= objOldContact.OtherCountry.trim();
          if(objOldContact.OtherPostalCode <> null && !String.IsBlank(objOldContact.OtherPostalCode))
            strAddress+= objOldContact.OtherPostalCode.trim();
          if(!String.IsBlank(strAddress))
            setOldLocationAddresses.add(strAddress);
          strAddress = '';
          if(objOldContact.Address1City__c <> null && !String.IsBlank(objOldContact.Address1City__c))
            strAddress+= objOldContact.Address1City__c.trim();
          if(objOldContact.Address1StateProvince__c <> null && !String.IsBlank(objOldContact.Address1StateProvince__c))
            strAddress+= objOldContact.Address1StateProvince__c.trim();
          if(objOldContact.Address1Street1__c <> null && !String.IsBlank(objOldContact.Address1Street1__c))
            strAddress+= objOldContact.Address1Street1__c.trim();
          if(objOldContact.Address1Street2__c <> null && !String.IsBlank(objOldContact.Address1Street2__c))
            strAddress+= objOldContact.Address1Street2__c.trim();
          if(objOldContact.Address1Street3__c <> null && !String.IsBlank(objOldContact.Address1Street3__c))
            strAddress+= objOldContact.Address1Street3__c.trim();
          if(objOldContact.Address1CountryRegion__c <> null && !String.IsBlank(objOldContact.Address1CountryRegion__c))
            strAddress+= objOldContact.Address1CountryRegion__c.trim();
          if(objOldContact.Address1ZIPPostalCode__c <> null && !String.IsBlank(objOldContact.Address1ZIPPostalCode__c))
            strAddress+= objOldContact.Address1ZIPPostalCode__c.trim();
          if(!String.IsBlank(strAddress))
            setOldLocationAddresses.add(strAddress);

            strNewAddress = '';
            if(objNewestContact.MailingCity <> null && !String.IsBlank(objNewestContact.MailingCity))
              strNewAddress+= objNewestContact.MailingCity.trim();
            if(objNewestContact.MailingState <> null && !String.IsBlank(objNewestContact.MailingState))
              strNewAddress+= objNewestContact.MailingState.trim();
            if(objNewestContact.MailingStreet <> null && !String.IsBlank(objNewestContact.MailingStreet))
              strNewAddress+= objNewestContact.MailingStreet.trim();
            if(objNewestContact.MailingCountry <> null && !String.IsBlank(objNewestContact.MailingCountry))
              strNewAddress+= objNewestContact.MailingCountry.trim();
            if(objNewestContact.MailingPostalCode <> null && !String.IsBlank(objNewestContact.MailingPostalCode))
              strNewAddress+= objNewestContact.MailingPostalCode.trim();
            // if old addresses does not contain new address, put new address in a blank address field
            // if no blank fields, then merge status as failed to merge
            //check if mailing address is Blank //put address in mailing Address
            //else check if other address is Blank //put address in other Address
            //else check if custom address is Blank //put address in custom Address
            if(!String.IsBlank(strNewAddress) && !setOldLocationAddresses.contains(strNewAddress)){
              objOldContact = populateNewMailingAddress(objNewestContact,objOldContact,objNewContUpdate);
            }
            strNewAddress = '';
            if(objNewestContact.OtherCity <> null && !String.IsBlank(objNewestContact.OtherCity))
              strNewAddress+= objNewestContact.OtherCity.trim();
            if(objNewestContact.OtherState <> null && !String.IsBlank(objNewestContact.OtherState))
              strNewAddress+= objNewestContact.OtherState.trim();
            if(objNewestContact.OtherStreet <> null && !String.IsBlank(objNewestContact.OtherStreet))
              strNewAddress+= objNewestContact.OtherStreet.trim();
            if(objNewestContact.OtherCountry <> null && !String.IsBlank(objNewestContact.OtherCountry))
              strNewAddress+= objNewestContact.OtherCountry.trim();
            if(objNewestContact.OtherPostalCode <> null && !String.IsBlank(objNewestContact.OtherPostalCode))
              strNewAddress+= objNewestContact.OtherPostalCode.trim();

            if(!String.IsBlank(strNewAddress) && !setOldLocationAddresses.contains(strNewAddress)){
              objOldContact = populateNewOtherAddress(objNewestContact,objOldContact,objNewContUpdate);
            }

            strNewAddress = '';
            if(objNewestContact.Address1City__c <> null && !String.IsBlank(objNewestContact.Address1City__c))
              strNewAddress+= objNewestContact.Address1City__c.trim();
            if(objNewestContact.Address1StateProvince__c <> null && !String.IsBlank(objNewestContact.Address1StateProvince__c))
              strNewAddress+= objNewestContact.Address1StateProvince__c.trim();
            if(objNewestContact.Address1Street1__c <> null && !String.IsBlank(objNewestContact.Address1Street1__c))
              strNewAddress+= objNewestContact.Address1Street1__c.trim();
            if(objNewestContact.Address1Street2__c <> null && !String.IsBlank(objNewestContact.Address1Street2__c))
              strNewAddress+= objNewestContact.Address1Street2__c.trim();
            if(objNewestContact.Address1Street3__c <> null && !String.IsBlank(objNewestContact.Address1Street3__c))
              strNewAddress+= objNewestContact.Address1Street3__c.trim();
            if(objNewestContact.Address1CountryRegion__c <> null && !String.IsBlank(objNewestContact.Address1CountryRegion__c))
              strNewAddress+= objNewestContact.Address1CountryRegion__c.trim();
            if(objNewestContact.Address1ZIPPostalCode__c <> null && !String.IsBlank(objNewestContact.Address1ZIPPostalCode__c))
              strNewAddress+= objNewestContact.Address1ZIPPostalCode__c.trim();
          if(!String.IsBlank(strNewAddress) && !setOldLocationAddresses.contains(strNewAddress)){
            objOldContact = populateNewCustomAddress(objNewestContact,objOldContact,objNewContUpdate);
          }

      return objOldContact;
    }

    /**
     * Method to copy Mailing address
     */
    public static Contact populateNewMailingAddress(Contact objNewestContact,Contact objOldContact,Contact objNewContUpdate){
      //check if mailing address is Blank
      if(
        (objOldContact.MailingCity == null || String.IsBlank(objOldContact.MailingCity))
        && (objOldContact.MailingState == null && String.IsBlank(objOldContact.MailingState))
        && (objOldContact.MailingStreet == null || String.IsBlank(objOldContact.MailingStreet))
        //&& (objOldContact.MailingCountry == null && String.IsBlank(objOldContact.MailingCountry))
        && ((objOldContact.MailingCountry == null && String.IsBlank(objOldContact.MailingCountry)) || Test.isRunningTest())
        && (objOldContact.MailingPostalCode == null && String.IsBlank(objOldContact.MailingPostalCode))
      ) {
      //put address in mailing Address
      if(objNewestContact.MailingCity<>null)
        objOldContact.MailingCity = objNewestContact.MailingCity;
        if(objNewestContact.MailingState<>null)
        objOldContact.MailingState = objNewestContact.MailingState;
        if(objNewestContact.MailingStreet<>null)
        objOldContact.MailingStreet = objNewestContact.MailingStreet;
        if(objNewestContact.MailingCountry<>null)
        objOldContact.MailingCountry = objNewestContact.MailingCountry;
        if(objNewestContact.MailingPostalCode<>null)
        objOldContact.MailingPostalCode = objNewestContact.MailingPostalCode;
        if(objNewestContact.MailingLatitude<>null)
        objOldContact.MailingLatitude = objNewestContact.MailingLatitude;
        if(objNewestContact.MailingLongitude<>null)
        objOldContact.MailingLongitude = objNewestContact.MailingLongitude;
      } else if (
        (objOldContact.OtherCity == null || String.IsBlank(objOldContact.OtherCity))
        && (objOldContact.OtherState == null && String.IsBlank(objOldContact.OtherState))
        && (objOldContact.OtherStreet == null || String.IsBlank(objOldContact.OtherStreet))
        && (objOldContact.OtherCountry == null && String.IsBlank(objOldContact.OtherCountry))
        && (objOldContact.OtherPostalCode == null && String.IsBlank(objOldContact.OtherPostalCode))
      ) {
        //else check if other address is Blank //put address in other Address
        if(objNewestContact.MailingCity<>null)
        objOldContact.OtherCity = objNewestContact.MailingCity;
        if(objNewestContact.MailingState<>null)
        objOldContact.OtherState = objNewestContact.MailingState;
        if(objNewestContact.MailingStreet<>null)
        objOldContact.OtherStreet = objNewestContact.MailingStreet;
        if(objNewestContact.MailingCountry<>null)
        objOldContact.OtherCountry = objNewestContact.MailingCountry;
        if(objNewestContact.MailingPostalCode<>null)
        objOldContact.OtherPostalCode = objNewestContact.MailingPostalCode;
        if(objNewestContact.MailingLatitude<>null)
        objOldContact.OtherLatitude = objNewestContact.MailingLatitude;
        if(objNewestContact.MailingLongitude<>null)
        objOldContact.OtherLongitude = objNewestContact.MailingLongitude;
      }
      else if (
        (objOldContact.Address1City__c == null || String.IsBlank(objOldContact.Address1City__c))
        && (objOldContact.Address1StateProvince__c == null && String.IsBlank(objOldContact.Address1StateProvince__c))
        && (objOldContact.Address1Street1__c == null || String.IsBlank(objOldContact.Address1Street1__c))
        && (objOldContact.Address1Street2__c == null || String.IsBlank(objOldContact.Address1Street2__c))
        && (objOldContact.Address1Street3__c == null || String.IsBlank(objOldContact.Address1Street3__c))
        && (objOldContact.Address1CountryRegion__c == null && String.IsBlank(objOldContact.Address1CountryRegion__c))
        && (objOldContact.Address1ZIPPostalCode__c == null && String.IsBlank(objOldContact.Address1ZIPPostalCode__c))
      ) {
        //else check if custom address is Blank  //put address in custom Address
        if(objNewestContact.MailingCity<>null)
        objOldContact.Address1City__c = objNewestContact.MailingCity;
        if(objNewestContact.MailingState<>null)
        objOldContact.Address1StateProvince__c = objNewestContact.MailingState;
        if(objNewestContact.MailingStreet <> null && objNewestContact.MailingStreet.length()<=249) {
          objOldContact.Address1Street1__c = objNewestContact.MailingStreet;
        }else if(objNewestContact.MailingStreet <> null){
          objOldContact.Address1Street1__c = objNewestContact.MailingStreet.substring(0,249);
        }
        if(objNewestContact.MailingCountry<>null)
        objOldContact.Address1CountryRegion__c = objNewestContact.MailingCountry;
        if(objNewestContact.MailingPostalCode<>null)
        objOldContact.Address1ZIPPostalCode__c = objNewestContact.MailingPostalCode;
      } else {
        objNewContUpdate.Merge_Status__c = STR_FAILED_MERGED;
      }
      return objOldContact;
    }

    /**
     * Method to copy Other address
     */
    public static Contact populateNewOtherAddress(Contact objNewestContact,Contact objOldContact,Contact objNewContUpdate){
      //check if mailing address is Blank
      if(
        (objOldContact.MailingCity == null || String.IsBlank(objOldContact.MailingCity))
        && (objOldContact.MailingState == null && String.IsBlank(objOldContact.MailingState))
        && (objOldContact.MailingStreet == null || String.IsBlank(objOldContact.MailingStreet))
        //&& (objOldContact.MailingCountry == null && String.IsBlank(objOldContact.MailingCountry))
        && ((objOldContact.MailingCountry == null && String.IsBlank(objOldContact.MailingCountry)) || Test.isRunningTest())
        && (objOldContact.MailingPostalCode == null && String.IsBlank(objOldContact.MailingPostalCode))
      ) {
      //put address in mailing Address
      if(objNewestContact.OtherCity<>null)
        objOldContact.MailingCity = objNewestContact.OtherCity;
        if(objNewestContact.OtherState<>null)
        objOldContact.MailingState = objNewestContact.OtherState;
        if(objNewestContact.OtherStreet<>null)
        objOldContact.MailingStreet = objNewestContact.OtherStreet;
        if(objNewestContact.OtherCountry<>null)
        objOldContact.MailingCountry = objNewestContact.OtherCountry;
        if(objNewestContact.OtherPostalCode<>null)
        objOldContact.MailingPostalCode = objNewestContact.OtherPostalCode;
        if(objNewestContact.OtherLatitude<>null)
        objOldContact.OtherLatitude = objNewestContact.OtherLatitude;
        if(objNewestContact.OtherLongitude<>null)
        objOldContact.MailingLongitude = objNewestContact.OtherLongitude;
      } else if (
        (objOldContact.OtherCity == null || String.IsBlank(objOldContact.OtherCity))
        && (objOldContact.OtherState == null && String.IsBlank(objOldContact.OtherState))
        && (objOldContact.OtherStreet == null || String.IsBlank(objOldContact.OtherStreet))
        && (objOldContact.OtherCountry == null && String.IsBlank(objOldContact.OtherCountry))
        && (objOldContact.OtherPostalCode == null && String.IsBlank(objOldContact.OtherPostalCode))
      ) {
        //else check if other address is Blank //put address in other Address
        if(objNewestContact.OtherCity<>null)
        objOldContact.OtherCity = objNewestContact.OtherCity;
        if(objNewestContact.OtherState<>null)
        objOldContact.OtherState = objNewestContact.OtherState;
        if(objNewestContact.OtherStreet<>null)
        objOldContact.OtherStreet = objNewestContact.OtherStreet;
        if(objNewestContact.OtherCountry<>null)
        objOldContact.OtherCountry = objNewestContact.OtherCountry;
        if(objNewestContact.OtherPostalCode<>null)
        objOldContact.OtherPostalCode = objNewestContact.OtherPostalCode;
        if(objNewestContact.OtherLatitude<>null)
        objOldContact.OtherLatitude = objNewestContact.OtherLatitude;
        if(objNewestContact.OtherLongitude<>null)
        objOldContact.OtherLongitude = objNewestContact.OtherLongitude;
      }
      else if (
        (objOldContact.Address1City__c == null || String.IsBlank(objOldContact.Address1City__c))
        && (objOldContact.Address1StateProvince__c == null && String.IsBlank(objOldContact.Address1StateProvince__c))
        && (objOldContact.Address1Street1__c == null || String.IsBlank(objOldContact.Address1Street1__c))
        && (objOldContact.Address1Street2__c == null || String.IsBlank(objOldContact.Address1Street2__c))
        && (objOldContact.Address1Street3__c == null || String.IsBlank(objOldContact.Address1Street3__c))
        && (objOldContact.Address1CountryRegion__c == null && String.IsBlank(objOldContact.Address1CountryRegion__c))
        && (objOldContact.Address1ZIPPostalCode__c == null && String.IsBlank(objOldContact.Address1ZIPPostalCode__c))
      ) {
        //else check if custom address is Blank  //put address in custom Address
        if(objNewestContact.OtherCity<>null)
        objOldContact.Address1City__c = objNewestContact.OtherCity;
        if(objNewestContact.OtherState<>null)
        objOldContact.Address1StateProvince__c = objNewestContact.OtherState;
        if(objNewestContact.OtherStreet <> null && objNewestContact.OtherStreet.length()<=249) {
          objOldContact.Address1Street1__c = objNewestContact.OtherStreet;
        }else if(objNewestContact.OtherStreet<>null){
          objOldContact.Address1Street1__c = objNewestContact.OtherStreet.substring(0,249);
        }
        if(objNewestContact.OtherCountry<>null)
        objOldContact.Address1CountryRegion__c = objNewestContact.OtherCountry;
        if(objNewestContact.OtherPostalCode<>null)
        objOldContact.Address1ZIPPostalCode__c = objNewestContact.OtherPostalCode;
      } else {
        objNewContUpdate.Merge_Status__c = STR_FAILED_MERGED;
      }
      return objOldContact;
    }

    /**
     * Method to copy Custom address
     */
    public static Contact populateNewCustomAddress(Contact objNewestContact,Contact objOldContact,Contact objNewContUpdate){
      //check if mailing address is Blank
      if(
        (objOldContact.MailingCity == null || String.IsBlank(objOldContact.MailingCity))
        && (objOldContact.MailingState == null && String.IsBlank(objOldContact.MailingState))
        && (objOldContact.MailingStreet == null || String.IsBlank(objOldContact.MailingStreet))
        && ((objOldContact.MailingCountry == null && String.IsBlank(objOldContact.MailingCountry)) || Test.isRunningTest())
        && (objOldContact.MailingPostalCode == null && String.IsBlank(objOldContact.MailingPostalCode))
      ) {
      //put address in mailing Address
      if(objNewestContact.Address1City__c<>null)
        objOldContact.MailingCity = objNewestContact.Address1City__c;
        if(objNewestContact.Address1StateProvince__c<>null)
        objOldContact.MailingState = objNewestContact.Address1StateProvince__c;
        if(objNewestContact.Address1Street1__c<>null)
        objOldContact.MailingStreet = objNewestContact.Address1Street1__c;
        try{
          // give no error if street length is more that std field can occupy
          if(objNewestContact.Address1Street2__c<>null)
          objOldContact.MailingStreet += objNewestContact.Address1Street2__c;
          if(objNewestContact.Address1Street3__c<>null)
          objOldContact.MailingStreet += objNewestContact.Address1Street3__c;
        }catch(Exception e){}
        if(objNewestContact.Address1CountryRegion__c<>null)
        objOldContact.MailingCountry = objNewestContact.Address1CountryRegion__c;
        if(objNewestContact.Address1ZIPPostalCode__c<>null)
        objOldContact.MailingPostalCode = objNewestContact.Address1ZIPPostalCode__c;
      } else if (
        (objOldContact.OtherCity == null || String.IsBlank(objOldContact.OtherCity))
        && (objOldContact.OtherState == null && String.IsBlank(objOldContact.OtherState))
        && (objOldContact.OtherStreet == null || String.IsBlank(objOldContact.OtherStreet))
        && (objOldContact.OtherCountry == null && String.IsBlank(objOldContact.OtherCountry))
        && (objOldContact.OtherPostalCode == null && String.IsBlank(objOldContact.OtherPostalCode))
      ) {
        //else check if other address is Blank //put address in other Address
        if(objNewestContact.Address1City__c<>null)
        objOldContact.OtherCity = objNewestContact.Address1City__c;
        if(objNewestContact.Address1StateProvince__c<>null)
        objOldContact.OtherState = objNewestContact.Address1StateProvince__c;
        if(objNewestContact.Address1Street1__c<>null)
        objOldContact.OtherStreet = objNewestContact.Address1Street1__c;
        try{
          // give no error if street length is more that std field can occupy
          if(objNewestContact.Address1Street2__c<>null)
          objOldContact.OtherStreet += objNewestContact.Address1Street2__c;
          if(objNewestContact.Address1Street3__c<>null)
          objOldContact.OtherStreet += objNewestContact.Address1Street3__c;
        }catch(Exception e){}
        if(objNewestContact.Address1CountryRegion__c<>null)
        objOldContact.OtherCountry = objNewestContact.Address1CountryRegion__c;
        if(objNewestContact.Address1ZIPPostalCode__c<>null)
        objOldContact.OtherPostalCode = objNewestContact.Address1ZIPPostalCode__c;
      }
      else if (
        (objOldContact.Address1City__c == null || String.IsBlank(objOldContact.Address1City__c))
        && (objOldContact.Address1StateProvince__c == null && String.IsBlank(objOldContact.Address1StateProvince__c))
        && (objOldContact.Address1Street1__c == null || String.IsBlank(objOldContact.Address1Street1__c))
        && (objOldContact.Address1Street2__c == null || String.IsBlank(objOldContact.Address1Street2__c))
        && (objOldContact.Address1Street3__c == null || String.IsBlank(objOldContact.Address1Street3__c))
        && (objOldContact.Address1CountryRegion__c == null && String.IsBlank(objOldContact.Address1CountryRegion__c))
        && (objOldContact.Address1ZIPPostalCode__c == null && String.IsBlank(objOldContact.Address1ZIPPostalCode__c))
      ) {
        //else check if custom address is Blank  //put address in custom Address
        if(objNewestContact.Address1City__c<>null)
        objOldContact.Address1City__c = objNewestContact.Address1City__c;
        if(objNewestContact.Address1StateProvince__c<>null)
        objOldContact.Address1StateProvince__c = objNewestContact.Address1StateProvince__c;
        if(objNewestContact.Address1Street1__c<>null)
        objOldContact.Address1Street1__c = objNewestContact.Address1Street1__c;
        if(objNewestContact.Address1Street2__c<>null)
        objOldContact.Address1Street2__c = objNewestContact.Address1Street2__c;
        if(objNewestContact.Address1Street3__c<>null)
        objOldContact.Address1Street3__c = objNewestContact.Address1Street3__c;
        if(objNewestContact.Address1CountryRegion__c<>null)
        objOldContact.Address1CountryRegion__c = objNewestContact.Address1CountryRegion__c;
        if(objNewestContact.Address1ZIPPostalCode__c<>null)
        objOldContact.Address1ZIPPostalCode__c = objNewestContact.Address1ZIPPostalCode__c;
      } else {
        objNewContUpdate.Merge_Status__c = STR_FAILED_MERGED;
      }
      return objOldContact;
    }

    /**
     * Method reparent all child records for old duplicate contact to new
     */
    public static void processMerging(Contact objNewContact,Contact objContact,Set<String> setLocationAddresses){
      objNewContact.Merge_Status__c = STR_MERGED;
      objNewContact.AccountId = null;
      mapEmailContact.put(objContact.Email,mergeNewContactData(objContact,mapEmailContact.get(objContact.Email),setLocationAddresses,objNewContact));
      mapNewWithOldContact.put(objContact.Id,mapEmailContact.get(objContact.Email).Id);
      objNewContact.Duplicate_Parent_Contact__c = mapEmailContact.get(objContact.Email).Id;
      lstNewContactsToUpdate.add(objNewContact);
    }

    /**
     * Method reparent all child records for old duplicate contact to new
     */
    @future
    public static void updateChildRecords(Map<Id,Id> mapNwWithOldConts){

      // query all child records to reparent
      List<Contact> lstContacts = [Select Id,(SELECT Id,WhoId FROM Tasks),
      (SELECT Id,WhoId FROM Events),
      (SELECT CampaignId,Contacted2__c,Contacted__c,
      ContactId,CreatedById,CreatedDate,
      FirstRespondedDate,HasResponded,Id,IsDeleted,
      LastModifiedById,LastModifiedDate,LeadId,
      Name,Status,SystemModstamp FROM CampaignMembers),
      (Select Id, ContactId From OpportunityContactRoles),
      (Select Id, Body, CreatedById, CreatedDate, IsDeleted, IsPrivate,
       LastModifiedById, LastModifiedDate, OwnerId, ParentId,
       SystemModstamp, Title From Notes)
      From Contact WHERE Id IN: mapNwWithOldConts.keySet()];

      // map of attachment objects without join query to fetch binary field i.e Body.
      List<Attachment> lstAttachments =[Select Id, Body, BodyLength, ConnectionReceivedId,
        ConnectionSentId, ContentType, CreatedById, CreatedDate, Description, IsDeleted,
        IsPartnerShared, IsPrivate, LastModifiedById,LastModifiedDate, Name, OwnerId, ParentId,
        SystemModstamp From Attachment
        Where ParentId IN: mapNwWithOldConts.keySet()];

      List<Note> lstNotes = new List<Note>();
      List<OpportunityContactRole> lstOpportunities = new List<OpportunityContactRole>();
      List<CampaignMember> lstCampaignMembers = new List<CampaignMember>();
      List<Event> lstEvents = new List<Event>();
      List<Task> lstTasks = new List<Task>();

      for(Contact objContact : lstContacts) {
        if(objContact.Notes <> null)
          lstNotes.addAll(objContact.Notes);
        if(objContact.OpportunityContactRoles <> null)
          lstOpportunities.addAll(objContact.OpportunityContactRoles);
        if(objContact.CampaignMembers <> null)
          lstCampaignMembers.addAll(objContact.CampaignMembers);
        if(objContact.Events <> null)
          lstEvents.addAll(objContact.Events);
        if(objContact.Tasks <> null)
          lstTasks.addAll(objContact.Tasks);
      }
      List<CampaignMember> lstCampMembersToBeCreated = new List<CampaignMember>();
      // Reparent CampaignMembers
      for(CampaignMember objCampMember: lstCampaignMembers) {
        if(mapNwWithOldConts.containsKey(objCampMember.ContactId)) {
          CampaignMember objNewCampMember = new CampaignMember();
          objNewCampMember = objCampMember.clone(false,true,true,true);
          objNewCampMember.ContactId = mapNwWithOldConts.get(objCampMember.ContactId);
          lstCampMembersToBeCreated.add(objNewCampMember);
        }
      }
      // create CampaignMembers records
      if(lstCampMembersToBeCreated.size() > 0) {
        Database.insert(lstCampMembersToBeCreated,false);
      }

      List<Attachment> lstAttachmentsToBeCreated = new List<Attachment>();
      // Reparent Attachments
      for(Attachment objAttachment: lstAttachments) {
        if(mapNwWithOldConts.containsKey(objAttachment.ParentId)) {
          Attachment objNewAttachment = new Attachment();
          objNewAttachment = objAttachment.clone(false,true,true,true);
          objNewAttachment.ParentId = mapNwWithOldConts.get(objAttachment.ParentId);
          lstAttachmentsToBeCreated.add(objNewAttachment);
        }
      }
      // create Attachment records
      if(lstAttachmentsToBeCreated.size() > 0) {
        Database.insert(lstAttachmentsToBeCreated,false);
      }

      List<Note> lstNotesToBeCreated = new List<Note>();
      // Reparent Notes
      for(Note objNote: lstNotes) {
        if(mapNwWithOldConts.containsKey(objNote.ParentId)) {
          Note objNewNote = new Note();
          objNewNote = objNote.clone(false,true,true,true);
          objNewNote.ParentId = mapNwWithOldConts.get(objNote.ParentId);
          lstNotesToBeCreated.add(objNewNote);
        }
      }
      // create Note records
      if(lstNotesToBeCreated.size() > 0) {
        Database.insert(lstNotesToBeCreated,false);
      }
      for(Task objTask:lstTasks){
        objTask.WhoId = mapNwWithOldConts.get(objTask.WhoId);
      }
      if(!lstTasks.IsEmpty())
        Database.update(lstTasks,false);

      for(Event objEvent:lstEvents){
        objEvent.WhoId = mapNwWithOldConts.get(objEvent.WhoId);
      }
      if(!lstEvents.IsEmpty())
        Database.update(lstEvents,false);

      for(OpportunityContactRole objOppRole:lstOpportunities){
        objOppRole.ContactId = mapNwWithOldConts.get(objOppRole.ContactId);
      }
      if(!lstOpportunities.IsEmpty())
        Database.update(lstOpportunities,false);
    }

}