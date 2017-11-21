global with sharing class NFRKeys {     
    public String Error = ''; 
    
    public NFRKeys() {
    }
    
    public Boolean createPartnerBaseKeys(Id accountId, String language) {
        System.debug('NFRKeys.createPartnerBaseKeys ' + accountId + ', ' + language);
        Error = '';
        License__c license;
        Account a = null;                
        String Server = null;
        String Desktop = null;
        String SPX_Linux = null;
        String ImageManager = null;
        List<License__c> Licenses = new List<License__c>();
        
        try {
            a = [SELECT Id,
                 NFR_ShadowProtect_Desktop_Serial__c, 
                 NFR_ShadowProtect_Server_Serial__c, 
                 NFR_ShadowProtect_SPX_Linux__c, 
                 NFR_ShadowProtect_ImageManager_Serial__c
                 FROM Account
                 WHERE Id = :accountId];
            
            Desktop = a.NFR_ShadowProtect_Desktop_Serial__c;
            Server = a.NFR_ShadowProtect_Server_Serial__c;
            SPX_Linux = a.NFR_ShadowProtect_SPX_Linux__c;
            ImageManager = a.NFR_ShadowProtect_ImageManager_Serial__c;
            
            Date expires = Date.today().addYears(1);
                   
            if (String.isBlank(Desktop)) {           
                license = create(accountId, 'Desktop', 1, false, expires, language, 'Onboarding');
                if (license != null) {
                    licenses.Add(license);
                    Desktop = license.Name;
                }
            }
    
            if (String.isBlank(Server)) {
                license = create(accountId, 'Server', 2, false, expires, language, 'Onboarding');
                if (license != null) {
                    licenses.Add(license);
                    Server = license.Name;
                }
            }     
    
            if (String.isBlank(SPX_Linux)) {            
                license = create(accountId, 'SPX Linux', 2, true, expires, language, 'Onboarding');
                if (license != null) {
                    licenses.Add(license);
                    SPX_Linux = license.Name;
                }
            }         
    
            if (String.isBlank(ImageManager)) {            
                license = create(accountId, 'Image Manager', 7, false, expires, language, 'Onboarding');
                if (license != null) {
                    licenses.Add(license);
                    ImageManager = license.Name;
                }
            }       
        } catch (Exception e) {
            Error = 'Exception: ' + e.getMessage() + '\r\n ' + e.getStackTraceString();
            System.debug(Error);
        }
        
        if (a != null && licenses.size() > 0) {
            insert licenses;
            
            System.debug('Keys:\r\n  Desktop:       ' + Desktop + '\r\n  Server:        ' + Server + '\r\n  SPX Linux:     ' + SPX_Linux + '\r\n  Image Manager: ' + ImageManager);

            a.NFR_ShadowProtect_Desktop_Serial__c = Desktop;
            a.NFR_ShadowProtect_Server_Serial__c = Server;
            a.NFR_ShadowProtect_SPX_Linux__c = SPX_Linux;
            a.NFR_ShadowProtect_ImageManager_Serial__c = ImageManager;
            
          	update a;
        }
        
        return (null != Desktop && null != Server && null != SPX_Linux && null != ImageManager);
    }
    
    public License__c create(ID accountId, String product, Integer productId, Boolean isLinux, Date expires, String language, String origin) {         
    	NFRKeyCallout callout = new NFRKeyCallout();
        String key = callout.makeCall('New', '', expires, Languages.determineNumber(language), productId, isLinux, accountId, language, product);
        
        if (Pattern.matches('[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}-[A-Z0-9]{4}', key)) {
            License__c license = new License__c(
                Name = key,
                Status__c = 'Active',
                Class__c = 'NFR',
                Expiration__c = expires,
                Language__c = language,
                Type__c = product,
                Linux__c = islinux,
                Activation__c = Date.today(),
                Account__c = accountId,
                Origin__c = origin);            
            return license;
        }
        return null;
    }
}