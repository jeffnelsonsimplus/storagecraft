/**
  \file         AcademyCertificateLetterController.apxc
  \brief        Send the Academy Certificate to a contact
  \details      With the Visualforce Page Academy Certificate Letter, send the certificate
                information to the contact and other related Salesforce users.  The page
                allows selection of users.
  \author       Loch MacLeod
  \version      1.1
  \date         
  \copyright    Copyright 2017 StorageCraft Technology Corporation
  \par Change Log
  Version   Date        Author                  Description
  1.1       2017-10-15  Loch MacLeod            Add Sales Territory staff to email (SSF-85).
*/
public class AcademyCertificateLetterController { 
    private final Academy_Certificate__c certificate;
    private PageReference pg;
    
    public boolean emailContact {get; set;}
    public boolean emailMe {get; set;}
    public boolean emailAcademy {get; set;}
    public boolean emailOwner {get; set;}
    public boolean emailTerritory {get; set;}
    public String message {get; set;}
    public String accountName {get; set;}
    public String accountOwner {get; set;}
    public String accountOwnerEmail {get; set;}
    public String contactId {get; set;}
    public String contactName {get; set;}
    public String contactEmail {get; set;}
    public String territoryTeam {get; set;}
    
    private List<User> team = new List<User>();
       
    public AcademyCertificateLetterController(ApexPages.StandardController controller) {
       if (!Test.isRunningTest()) { 
        controller.addFields(new List<String> {
            'Status__c',
            'Certification__c', 
            'Certified_Contact__c', 
            'Certified_Contact__r', 
            'Certified_Contact__r.Name', 
            'Certified_Date__c', 
            'Certificate_Sent__c', 
            'Certificate_Sent_On__c'});
       } 
        certificate = (Academy_Certificate__c)controller.getRecord();
        
        pg = (PageReference)controller.view();
        
        emailContact = true;
        emailMe = true;
        emailAcademy = true;
        emailOwner = true;
        emailTerritory = true;
        message = '';
        
        contactId = certificate.Certified_Contact__c;
        Contact c = 
            [SELECT Id, Name, Email, Account.Name, Account.Owner.Name, Account.Owner.Email, Account.StcZone_Territory__c
             FROM Contact 
             WHERE Id = :contactId
             LIMIT 1];
        contactName = c.Name;
        contactEmail = c.Email;
        territoryTeam = '';
        
        if (String.isBlank(c.Account.Name)) {
            accountName = '';
            accountOwner = '';
            accountOwnerEmail = '';
        } 
        else {
            accountName = c.Account.Name;
            accountOwner = c.Account.Owner.Name;
            accountOwnerEmail = c.Account.Owner.Email;
        }
        
        if (!String.isBlank(c.Account.StcZone_Territory__c)) {
            List<StcZone__c> zones = 
                [SELECT Id, Assign_Accounts_To__c, Assign_To__c
                 FROM StcZone__c 
                 WHERE Active__c = true AND Territory__c = :c.Account.StcZone_Territory__c];
            
            if (zones.size() > 0) {
                Map<Id, Id> userIds = new Map<Id, Id>();
                
                for (StcZone__c z : zones) {
                    userIds.put(z.Assign_Accounts_To__c, z.Assign_Accounts_To__c);
                    userIds.put(z.Assign_To__c, z.Assign_To__c);
                }
                
                team = [SELECT Id, Name, Email FROM User WHERE Id IN :userIds.keySet()];
                String teamMembers = '';
                for (User u : team) {
                    teamMembers = teamMembers + u.Name + ', ';
                }
                
                territoryTeam = teamMembers.Left(teamMembers.length() - 2);
            }
        }
    }
        
    public PageReference sendEmail() {
        String error;
        
        try {
            if (certificate == null) {
                error = 'Invalid Cerification.  No email sent.';
            }
            else if (!'Certified'.Equals(certificate.Status__c)) {
                error = 'Status is ' + certificate.Status__c + '.  No email sent';
            }
            else {
                String abbreviation = null;
                String emailTemplate = null;
                String resourcenameLogos = null;
                PageReference pageCertificate = Page.AcademyCertificate_PDF; 
                                       
                if ('StorageCraft_Certified_Master_Engineer'.Equals(certificate.Certification__c)) {
                    abbreviation = 'SCME';
                    emailTemplate = 'AcademyCertificate SCME Email';
                    resourcenameLogos = 'AcademyCertificate_SCME_Logos';            
                }        
                else if ('StorageCraft_Certified_Engineer'.Equals(certificate.Certification__c)) {
                    abbreviation = 'SCE';
                    emailTemplate = 'AcademyCertificate SCE Email';
                    resourcenameLogos = 'AcademyCertificate_SCE_Logos';            
                }       
                else if ('StorageCraft_Sales_Professional'.Equals(certificate.Certification__c)) {
                    abbreviation = 'SSP';
                    emailTemplate = 'AcademyCertificate SSP Email';
                    resourcenameLogos = 'AcademyCertificate_SSP_Logos';
                }
               
                if (abbreviation == null) {
                    error = 'Unavailable certification type: ' + certificate.Certification__c;
                }  
                else {
                    Map<String, String> emailTo = new Map<String, String>();
                    Map<String, String> carbonCopy = new Map<String, String>();
                    
                    if (emailMe) {
                        carbonCopy.put(UserInfo.getUserEmail(), UserInfo.getUserEmail());
                    }
                    if (emailAcademy) {
                        carbonCopy.put('academy@storagecraft.com', 'academy@storagecraft.com');
                    }
                    if (emailOwner) {
                        carbonCopy.put(accountOwnerEmail, accountOwnerEmail);
                    }
                    if (emailTerritory) {
                        for (User u : team) {
                            carbonCopy.put(u.Email, u.Email);
                        }
                    }
                    
                    if (emailContact) {
                        emailTo.put(contactEmail, contactEmail);
                    }
                    else {
                        emailTo = carbonCopy;
                        carbonCopy = new Map<String, String>(); 
                    }
                    
                    if (emailTo.size() > 0 ) {                    
                        Id idTemplate = [SELECT Id, Name FROM EmailTemplate WHERE Name = :emailTemplate].Id;
                         
                        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
                        pageCertificate.getParameters().put('id', certificate.Id);  
                        Blob blobCertificate;
                        if (!Test.isRunningTest()){
                            blobCertificate = pageCertificate.getContent(); 
                        }
                        else{
                            blobCertificate=Blob.valueOf('Unit Test Attachment Body'); 
                        }
                            Messaging.EmailFileAttachment pdfCertificate = new Messaging.EmailFileAttachment();
                            pdfCertificate.setInline(false);
                            pdfCertificate.setContentType('application/pdf');
                            pdfCertificate.setFileName('StorageCraft_Certificate_' + abbreviation + '.pdf');
                            pdfCertificate.setBody( blobCertificate );
                            attachments.Add(pdfCertificate);
                        
                        if (!String.isBlank(resourcenameLogos)) {
                            Blob blogLogos = null;
                            StaticResource sr = [Select s.Name, s.Id, s.Body From StaticResource s where s.Name = :resourcenameLogos];    
                            blogLogos = (Blob) sr.Body;  
    
                            Messaging.EmailFileAttachment zipLogos = new Messaging.EmailFileAttachment();
                            zipLogos.setInline(false);
                            zipLogos.setContentType('application/zip');
                            zipLogos.setFileName('StorageCraft_Certificate_Logos_' + abbreviation + '.zip');
                            zipLogos.setBody( blogLogos );
                            attachments.Add(zipLogos);
                        }
                       
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        mail.setUseSignature(false);                                            
                        mail.setFileAttachments(attachments);
                        mail.setTargetObjectId(contactId);
                        mail.setTemplateID(idTemplate); 
                        mail.setToAddresses(emailTo.values());
                        if (carbonCopy.size() > 0 ) {
                            mail.setCcAddresses(carbonCopy.values());
                        }                   
                        OrgWideEmailAddress owea = (OrgWideEmailAddress) [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'Academy'];
                        if (owea != null) {
                            mail.setOrgWideEmailAddressId(owea.Id);
                        }
                        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                        
                        certificate.Certificate_Sent__c = true;
                        certificate.Certificate_Sent_On__c = Date.today();
                        update certificate;
                        
                        return pg;
                    }
                    else {
                       error = 'No receiving email.';
                    }
                }
            }
        } catch (Exception e) {
            error = e.getMessage();
        }
        
        message = 'Failed to Send.  ' +  error;

        return null;
    }

    
    public String getBackgroundImage() {
        string resourceName;
        
        if ('StorageCraft_Certified_Master_Engineer'.Equals(certificate.Certification__c)) {
            resourceName = 'AcademyCertificate_SCME';
        }        
        else if ('StorageCraft_Certified_Engineer'.Equals(certificate.Certification__c)) {
            resourceName = 'AcademyCertificate_SCE';
        }       
        else if ('StorageCraft_Sales_Professional'.Equals(certificate.Certification__c)) {
            resourceName = 'AcademyCertificate_SSP';
        }
        else {
            return '';
        }
                             
        List<StaticResource> resourceList = [
            SELECT Name, NamespacePrefix, SystemModStamp 
            FROM StaticResource 
            WHERE Name = :resourceName];
        
        if (resourceList.size() == 1) { 
           String namespace = resourceList[0].NamespacePrefix;        
           return '/resource/'        
              + resourceList[0].SystemModStamp.getTime() + '/'        
              + (namespace != null && namespace != '' ? namespace + '__' : '')        
              + resourceName;
        }
        
        return '';
    }
    
    public String getNameColor() {
        return '#E9622E';
    }
    
    public String getDateColor() {        
        if ('StorageCraft_Certified_Master_Engineer'.Equals(certificate.Certification__c)) {
            return '#FFFFFF';
        }           
        else if ('StorageCraft_Certified_Engineer'.Equals(certificate.Certification__c)) {
            return '#004463';
        }
                
        return '#004463';
    }
    
    public String getNameTop() {        
        if ('StorageCraft_Certified_Master_Engineer'.Equals(certificate.Certification__c)) {
            return '340px';
        }          
        else if ('StorageCraft_Certified_Engineer'.Equals(certificate.Certification__c)) {
            return '340px';
        } 
                
        return '340px';
    }
    
    public String getNameLeft() {        
        if ('StorageCraft_Certified_Master_Engineer'.Equals(certificate.Certification__c)) {
            return '70px';
        }          
        else if ('StorageCraft_Certified_Engineer'.Equals(certificate.Certification__c)) {
            return '70px';
        } 
                
        return '70px';
    }
    
    public String getDateTop() {        
        if ('StorageCraft_Certified_Master_Engineer'.Equals(certificate.Certification__c)) {
            return '685px';
        }         
        else if ('StorageCraft_Certified_Engineer'.Equals(certificate.Certification__c)) {
            return '670px';
        }         
        else if ('StorageCraft_Sales_Professional'.Equals(certificate.Certification__c)) {
            return '690px';
        } 
                
        return '670px';
    }
    
    public String getDateLeft() {        
        if ('StorageCraft_Certified_Master_Engineer'.Equals(certificate.Certification__c)) {
            return '660px';
        }         
        else if ('StorageCraft_Certified_Engineer'.Equals(certificate.Certification__c)) {
            return '660px';
        } 
                
        return '660px';
    }
}