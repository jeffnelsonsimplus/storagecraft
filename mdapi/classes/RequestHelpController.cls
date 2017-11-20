public with sharing class RequestHelpController
{
    public Contact objContact               {get;set;}
    public Case objCase                     {get;set;}
    public String zipErrorLabel {get;set;}
    public String selectedCountry           {
        get;
        set
        {
            this.selectedCountry = value;
            
            objContact.MailingCountry = this.selectedCountry;
            selectedCountryISO = CountryUtility.mapCountryByAll.get(this.selectedCountry);
            if(selectedCountryISO != null && selectedCountryISO.postalCodeExample__c != null){
                zipErrorLabel = String.format(Label.ERROR_INVALID_POSTAL_CODE, new List<String>{selectedCountryISO.postalCodeExample__c});
            } else {
                zipErrorLabel = '';
            }
        }
    }
    public Country_ISO_Map__c selectedCountryISO {get;set;}
    public List<SelectOption> lstStates {
        get{
            List<SelectOption> stateOptions = new List<SelectOption>();
            if(selectedCountryISO != null && selectedCountryISO.statesProvinces__c != null){
                for( String s : selectedCountryISO.statesProvinces__c.split(',') ){
                    stateOptions.add(new SelectOption(s,s));
                }
            }
            return stateOptions;
    	}
        set;
    }
    public String selectedLanguage          {get;set;}
    public Attachment objAttachment         {get;set;}
    public Blob attachmentBody              {get;set;}
    public String fileName                  {get;set;}
    public String erroMSG                   {get;set;}
    public String successMSG                {get;set;}
    public List<SelectOption> lstCountries  {get;set;}
    public Boolean popWebStore              {get;set;}
    public Boolean lock                     {get;set;}
    public Utility.LicenceResponce rMsg     {get;set;}
    public String msgJSON                   {get{
            return JSON.serialize(rMsg);
        } private set;   }
    public String licenseInputNumber        {get;set;}
    public String activationIdNum           {get;set;}
    public Boolean selectedRecord           {get;set;}
    public Boolean licensesFound            {get;set;}
    public Boolean deactivateChosen         {get;set;}
    public Boolean deactivateChosen2         {get;set;}
    public Boolean displayTooManyActivationsError {get;set;}
    public HelpResult helpRes               {get;set;}
    
    public List<SelectOption> states        {get;set;}
    public String zipRegex {get;set;}
    public String zipLabel {get;set;}
    public String chosenLicense         {
        get;
        // *** setter is NOT being called ***
        set {
            chosenLicense = value;
            System.debug('chosenLicense: '+chosenLicense);
        }
    }
    public  String actId                    {get;set;}

    public RequestHelpController(ApexPages.StandardController controller){
        lock = false;
        displayTooManyActivationsError = false;
        actId = null;
        objContact = new Contact();
        licenseInputNumber = null;
        licensesFound = false;
        activationIdNum = null;
        selectedRecord = false;
        deactivateChosen = false;
        deactivateChosen2 = false;

        objCase = (Case)controller.getRecord();
        objCase.Origin = 'Web';
        objCase.Language__c = selectedLanguage;
        objCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('WebForm').getRecordTypeId();

        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = True;
        objCase.setOptions(dmo);

        objAttachment = new Attachment();
        erroMSG = successMSG = '';
        
        selectedCountry = ApexPages.currentPage().getParameters().containsKey('countryname') ?
            ApexPages.currentPage().getParameters().get('countryname') : 'US';
        selectedLanguage = ApexPages.currentPage().getParameters().containsKey('language') ?
            ApexPages.currentPage().getParameters().get('language') : 'en_US';

        lstCountries = new List<SelectOption>();
        for(Country_ISO_Map__c cim : CountryUtility.countries.values()){
            lstCountries.add(new SelectOption(cim.alpha2Code__c, cim.Name));
        }
    }
    
    public List<SelectOption> getLanguages() {
        List<SelectOption> soList = new List<SelectOption>();
        for(Language__c l : Language__c.getAll().values()){
            soList.add(new SelectOption(l.ISO_Code__c, l.Name));
        }
        return soList;   
    }
    
    public Map<String, Language__c> getLanguageMapByISO(){
        Map<String, Language__c> retMap = new Map<String, Language__c>();
        for(Language__c l : Language__c.getAll().values()){
            retMap.put(l.ISO_Code__c, l);
        }
        return retMap;
    }

    public Pagereference changeLanguage(){
        objAttachment = new Attachment();
        return new Pagereference('/apex/RequestHelp?countryname='+selectedCountry+'&language='+selectedLanguage);
    }

    public Pagereference changeCountry(){
        objAttachment = new Attachment();
        objContact.MailingCountry = selectedCountry;
        return new Pagereference('/apex/RequestHelp?countryname='+selectedCountry+'&language='+selectedLanguage);
    }

    public void deactivateLicense(){
        try{
            if(lock== true)return;
            Integer selected = 0;
            Integer index1 = 0;
            Integer index2 = 0;
            Integer count=0;

            system.debug('chosenLicense '+chosenLicense);
            if(!Test.isRunningTest())actId = chosenLicense;
            String url = 'https://www.storagecraft.com/support/sites/all/modules/request_help_form/deactivate.php';
            String body = 'serialNumber='+EncodingUtil.urlEncode(objCase.Product_Key__c, 'UTF-8');
            body += '&activationId='+EncodingUtil.urlEncode(actId, 'UTF-8');
            makeCall(body,url);
            count++;

            // TODO: Still needed if we're not doing checkboxes?
            if(count > 2)
            {
                licensesFound = false;
                lock = true;
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.Case_Too_Many_Deactivation));
                return;
            }
        } catch (Exception e){
           EmailExceptionToAdmin.notify('deactivateLicense',e,'Chosen Lics:'+chosenLicense);
            erroMSG = e.getMessage();
        }
    }

    public PageReference checkDeactivate()
    {
        // hard error if email address is blank
        if(String.isBlank(objContact.Email)){
            erroMSG = Label.WF_Email_Required;
            return null;
        }

        try {
            deactivateChosen = deactivateChosen2;
            // TODO: only allow for specific regions, maybe controlled by the Country custom setting...
            if(objCase.Product_Key__c != null)
                objCase.Product_Key__c = cleanSerial(objCase.Product_Key__c);
            if(deactivateChosen){
                queryLicense(); //return to page and rereder
            } else {
                return saveCase();
            }
        } catch (Exception e){
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            System.debug(e.getLineNumber());
            EmailExceptionToAdmin.notify('checkDeactivate',e,'Product Key:'+objCase.Product_Key__c);
            erroMSG = e.getMessage();
        }
        return null;
    }

    public void queryLicense(){
        try{
            system.debug('objCase.Product_Key__c: '+objCase.Product_Key__c);
            if(objCase.Product_Key__c != null)
                objCase.Product_Key__c = cleanSerial(objCase.Product_Key__c);
            if(objCase.Product_Key__c.length() < 19)
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter a valid 16-digit serial number'));
                objAttachment = new Attachment();
                return;
            }
            
            String body = 'serialNumber='+EncodingUtil.urlEncode(objCase.Product_Key__c, 'UTF-8');
            String url = 'https://www.storagecraft.com/support/sites/all/modules/request_help_form/get_deactivate_info.php';
            makeCall(body,url);
        } catch (Exception e){
            EmailExceptionToAdmin.notify('queryLicense',e,'Chosen Lics:'+objCase.Product_Key__c);
            erroMSG = e.getMessage();
        }
    }

    public void makeCall(String jsonString,String url){
        HttpRequest req = new HttpRequest();
        Http http = new Http();
        // Set the timeout to 30 seconds so we don't fail getting key data
        req.setTimeout(30 * 1000);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setMethod('POST');
        req.setBody(jsonString);
        req.setEndpoint(url);

        String mspMessage = Label.Case_MSP_Deactivate;
        String maxMessage = Label.Case_Max_Deactivate;
        try
        {
            HTTPResponse response = http.send(req);
            system.debug(response.getBody());
            String jsonReplacedString = response.getBody().replace('"date":', '"activationDate":');
            helpRes = (HelpResult)JSON.deserializeStrict(jsonReplacedString, HelpResult.class);

            if(helpRes.deactivated == 'true'){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,Label.Case_Success_Deactivate));
                // TODO: Submit case for tracking manual deactivation
                saveDeactivationCase();
            }
            else if(helpRes.legacyActivations.size()==0 && helpRes.spxActivations.size()==0 && helpRes.activations.size()==0 && helpRes.errorMessage != mspMessage && helpRes.errorMessage != maxMessage)
            {
                licensesFound = false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.Case_None_To_Deactivate));
                objAttachment = new Attachment();
                return;
            }
            else if(helpRes.errorMessage == maxMessage)
            {
                licensesFound = false;
                lock = true;
                displayTooManyActivationsError = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,helpRes.errorMessage));
            }
             else if(helpRes.errorMessage ==mspMessage)
            {
                licensesFound = false;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,helpRes.errorMessage));
            }
            else if(helpRes.error == 'true')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,helpRes.errorMessage));
                objAttachment = new Attachment();
                return;
            }

            else{licensesFound = true;}
        } catch (System.JSONException e) {
            EmailExceptionToAdmin.notify('makeCall',e,'Chosen Lics:'+objCase.Product_Key__c);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Error with json parsing: '+e));
            system.debug( 'Error with json parsing: '+e);
            objAttachment = new Attachment();
        } catch (Exception e){
            EmailExceptionToAdmin.notify('makeCall',e,'Chosen Lics:'+objCase.Product_Key__c);
            erroMSG = e.getMessage();
        }

    }
    public void gotoCase()
    {
        //go to new case page
    }

    public PageReference saveCase(){
        //if checked return to page and show deactibvation
        //when called again save
        System.debug('Saving Case');

        // hard error if email address is blank
        if(String.isBlank(objContact.Email)){
            erroMSG = Label.WF_Email_Required;
            EmailExceptionToAdmin.notify('saveCaseWithoutEmail',null,'Key:'+objCase.Product_Key__c);
            objAttachment = new Attachment();
            return null;
        }

        
        objCase.SuppliedEmail = objContact.Email;
        objCase.SuppliedPhone = objContact.Phone;
        objCase.Country__c = selectedCountry;
        objCase.Subject = objCase.Category__c;
        if(!getLanguageMapByISO().isEmpty())
        	objCase.Language__c = getLanguageMapByISO().get(selectedLanguage).Name;
        objCase.Priority = 'Medium';
        objCase.Priority = setPriority(objCase);
        objCase.Serial_Number__c = objCase.Product_Key__c;
        // Find a suggested OEM partner based on the domain of the email address
        // supporting the additional domains object

        // if contact already exists and is attached to an OEM then it is all good
        List<Contact> lstContact = [SELECT Id, Account.Is_OEM__c FROM Contact WHERE Email = :objContact.Email AND Merge_Status__c != :Label.Merged LIMIT 1];
        Boolean isOEM = false;
        if(!lstContact.isEmpty() && lstContact[0].Account.Is_OEM__c){
            isOEM = true;
        } else {
            Id OEMId = DomainManager.findAccountByDomain([select id, website, (select Name from Additional_Domains__r) from account where Is_OEM__c = true AND Website != null], objCase.SuppliedEmail);
            System.debug('OEMID:'+OEMId);
        	objContact.AccountId = OEMId;
            if(OEMId != null)
                isOEM = true;
        }
        System.debug('IS OEM:'+isOEM);
        objCase.recalculateFormulas();
        
        try{
            erroMSG = successMSG = '';
            if(isOEM == false && objCase.Supress_License_Check__c == false){
                   // Try and get an AU license first before checking CPP
                   Set<String> ignore = new Set<String>{'Not Used','CANCELLED','Subscription Expired','Expired','Error-Used','Error-Renewed','Error- CANCELLED'};
                   List<License__c> lics = [select Id, Status__c, Expiration__c from License__c where Name = :objCase.Serial_Number__c AND Data_Migration_Source__c = 'AU' AND Type__c != 'MSP'];
                   if(!lics.isEmpty()){
                       Boolean valid = false;
                       for(License__c l : lics ){
                           if(!ignore.contains(l.Status__c) && l.Expiration__c > Date.today()){
                               valid = true;
                               break;
                           }
                       }
                       if(valid)
                           objCase.Serial_Number_Details__c = 'Valided by AU License';
                       else
                           objCase.Serial_Number_Details__c = 'Expired AU Maintenance';

                   } else {

                       // No AU licenses found, go ahead and check the CPP
                       rMsg = Utility.validateProductKey(objCase.Serial_Number__c, objCase.SuppliedEmail, objCase.Web_Form_Incident_Pack__c, objCase.Product__c);
                       if(rMsg.message != 'success')
                       {
                           erroMSG = rMsg.message;
                           System.debug('erroMSG--->'+rMsg.message);
                           objAttachment = new Attachment();
                           return null;
                       }
                       System.debug(rMsg);
                   }
            }

            if(!lstContact.isEmpty()){
                objCase.ContactId = lstContact[0].Id;
            } else{
                insert objContact;
                Contact newContact = [select Id, Duplicate_Parent_Contact__c from Contact where Id = :objContact.Id];
                if(newContact.Duplicate_Parent_Contact__c != null){
                    delete objContact;
                    objContact.Id = newContact.Duplicate_Parent_Contact__c;
                }
                objCase.ContactId = objContact.Id;
            }

            Insert objCase;
            if(objAttachment != null && objAttachment.body != null){
                objAttachment.ParentID = objCase.Id;
                insert objAttachment;
            }
            String caseNum = [select CaseNumber from Case where Id = :objCase.Id].CaseNumber;
            PageReference pr = Page.CaseSuccess;
            pr.getParameters().put('CaseNumber',caseNum);
            pr.getParameters().put('l',selectedLanguage);
            objContact = new Contact();
            objCase = new Case();
            objAttachment = new Attachment();
            fileName = '';

            return pr;
        }
        catch(Exception ex){
            EmailExceptionToAdmin.notify('saveCase',ex,'Key:'+objCase.Product_Key__c);
            System.debug('=========ex======'+ex.getlinenumber());
            System.debug(ex.getStackTraceString());
            erroMSG = ex.getMessage();
            System.debug(erroMSG);
        }
        objAttachment = new Attachment();
        return null;
    }

    private String setPriority(Case objCase){
        if(objCase.Category__c == null)
            return objCase.Priority;
        if(objCase.Category__c.contains('(Emergency)'))
            return 'Emergency';
        if(objCase.Category__c.contains('(High)'))
            return 'High';
        if(objCase.Category__c.contains('(Low)'))
            return 'Low';
        return objCase.Priority;
    }

    @testVisible
    private class HelpResult{
        public String error                             {get;set;}
        public String errorMessage                      {get;set;}
        public List<Activations> activations  	        {get;set;}
        public List<Activations> legacyActivations  	{get;set;}
        public List<Activations> spxActivations  	    {get;set;}
        public String deactivated                       {get;set;}
    }

    @testVisible
    private class Activations{
        public String keyVersion                {get;set;}
        public String versionNumber             {get;set;}
        public String activationId              {get;set;}
        public String machineId                 {get;set;}
        public String name                      {get;set;}
        public Boolean selectedRecord           {get;set;}
        public Date activationDate              {get;set;}
    }

    private void saveDeactivationCase(){
        Case c = objCase.clone(false, true, false, false);
        
        c.Status = 'Resolved : Manual Deactivation';
        c.SuppliedEmail = objContact.Email;
        c.SuppliedPhone = objContact.Phone;
        c.Country__c = selectedCountry;
        c.Subject = objCase.Category__c;
        if(!getLanguageMapByISO().isEmpty())
        	objCase.Language__c = getLanguageMapByISO().get(selectedLanguage).Name;
        c.Priority = 'Medium';
        c.Priority = setPriority(objCase);
        c.Serial_Number__c = objCase.Product_Key__c;

        try{
            List<Contact> lstContact = [SELECT Id FROM Contact WHERE Email = :objContact.Email AND Merge_Status__c != :Label.Merged LIMIT 1];
            if(!lstContact.isEmpty()){
                c.ContactId = lstContact[0].Id;
            }
            else{
                insert objContact;
                
                Contact newContact = [select Id, Duplicate_Parent_Contact__c from Contact where Id = :objContact.Id];
                if(newContact.Duplicate_Parent_Contact__c != null){
                    delete objContact;
                    objContact.Id = newContact.Duplicate_Parent_Contact__c;
                }
                c.ContactId = objContact.Id;
            }

            Insert c;
        } catch (Exception ex){
            EmailExceptionToAdmin.notify('saveCase',ex,'Key:'+objCase.Product_Key__c);
            System.debug('DeactivationCase:=========ex======'+ex.getlinenumber());
            System.debug(ex.getStackTraceString());
            System.debug(ex.getMessage());
        }
    }

    private String cleanSerial(String serialNumber){
        serialNumber = serialNumber.replaceAll('-','');
        serialNumber = serialNumber.toUpperCase();
        serialNumber = serialNumber.mid(0, 4)+'-'+serialNumber.mid(4, 4)+'-'+serialNumber.mid(8, 4)+'-'+serialNumber.mid(12, 4);
        return serialNumber;
    }
    
    public static String getLabelString(String labelName ){
        Component.Apex.OutputText output = new Component.Apex.OutputText();
        output.expressions.value = '{!$Label.' + labelName + '}';
        return String.valueOf(output.value);
    }

}