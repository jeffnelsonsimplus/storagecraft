// Used to receive "REST" inbound "Outbound Message" info from AU Salesforce for license updates
@RestResource(urlMapping='/LicenseUpdate/*')
global with sharing class InboundLicenseUpdate {
    // AU license status that are NOT valid for maintenance
    public static Set<String> ignore = new Set<String>{'Not Used','CANCELLED','Subscription Expired','Expired','Error-Used','Error-Renewed','Error- CANCELLED'};
        
    @HttpPost	
    global static void updateLicensesAndCases() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String bdy = req.requestBody.toString();
        System.debug(bdy);
        // Using regex to strip out the license key, exp date, and status updates that are sent from the AU SFDC instance
        // TODO: build up for multiple licenses
        Pattern MyPattern = Pattern.compile('Product_Key_v4__c>([\\w-]+)<\\/sf:Product_Key_v4__c>[\\s\\r\\n]*<sf:Renewal_Date__c>([\\w-]+)<\\/sf:Renewal_Date__c>[\\s\\r\\n]*<sf:Status__c>([\\w-]+)');
        
        Matcher MyMatcher = MyPattern.matcher(bdy);
        
        String license;
        Date lDate;
        String lStatus;
        
        // If we can find the values in the message
        if(MyMatcher.find()){
            // extract the values
            license = MyMatcher.group(1);
            lDate = Date.valueOf(MyMatcher.group(2));
            lStatus = MyMatcher.group(3);
            
            // Update license objects where they exist
            List<License__c> lics = [select Id from License__c where name = :license];
            if(!lics.isEmpty()){
                for(License__c l : lics ){
                    l.Expiration__c = lDate;
                    l.Status__c = lStatus;
                }
                Update lics;
            }
            
            
            // If this update makes the license valid then pull all of its cases forward and assign them out
            if(lDate >= Date.today() && !ignore.contains(lStatus)){
                // Update cases using this license and waiting
                List<Case> cases = [select id from Case where Serial_Number__c = :license AND Status = 'Waiting for Renewal'];
                System.debug(cases);
                if(!cases.isEmpty()){
                    Database.DMLOptions dmo = new Database.DMLOptions();
                    dmo.assignmentRuleHeader.useDefaultRule = True;
                    for(Case c : cases){
                        c.Serial_Number_Details__c = 'Renewed in AU';
                        c.Status = 'In Progress';
                        c.setOptions(dmo);
                    }
                    Update cases;
                }
            }
        }
        
        // Return ACK to SFDC letting them know we received the message correctly
        RestContext.response.responseBody = Blob.valueOf(getResponse());
    }
    
    private static string getResponse(){
        String s = '<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema"><soap:Body><notificationsResponse xmlns="http://soap.sforce.com/2005/09/outbound"><Ack>true</Ack></notificationsResponse></soap:Body></soap:Envelope>';
        return s;
    }
}