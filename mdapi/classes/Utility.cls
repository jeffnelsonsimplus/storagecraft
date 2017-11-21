public class Utility{
    private static final String endpointURL = 'https://www.storagecraft.com/support/sites/all/modules/request_help_form/testAjax.php';
    public static Utility.LicenceResponce validateProductKey(String serialNumber, String email, String incident, String product_name){
        if(serialNumber == null){
            Utility.LicenceResponce lr = new Utility.LicenceResponce();
            lr.message = 'serial number is blank';
            return lr;
        }
        Http h = new Http();
        HTTPRequest req = new HTTPRequest();
        req.setEndpoint(endpointURL);
        // Set the timeout to 30 seconds so we don't fail getting key data
        req.setTimeout(30 * 1000);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setMethod('POST');
        // format serial number as xxxx-xxxx-xxxx-xxxx
        // TODO: better error handling for pre-checks before sending to licensing server
        serialNumber = serialNumber.replaceAll('-','');
        serialNumber = serialNumber.capitalize();
        serialNumber = serialNumber.mid(0, 4)+'-'+serialNumber.mid(4, 4)+'-'+serialNumber.mid(8, 4)+'-'+serialNumber.mid(12, 4);
        String body = 'serialNumber='+EncodingUtil.urlEncode(serialNumber, 'UTF-8');
        body += '&email=' + (email == null ? null : EncodingUtil.urlEncode(email, 'UTF-8'));
        body += '&incident=' + (incident == null ? null : EncodingUtil.urlEncode(incident, 'UTF-8'));
        body += '&product_name=' + (product_name == null ? null : EncodingUtil.urlEncode(product_name, 'UTF-8'));
        req.setBody(body);
        HttpResponse res;
        try{
            System.debug('Before Entering');
            res = !Test.isRunningTest() ? h.send(req) : RequestHelpControllerMockImpl.respond(new HTTPRequest());
            if(res.getStatusCode() == 200){
                LicenceResponce objLR = Utility.parse(res.getBody());
                String msg = 'success';
                msg = objLR.expired == 'yes' ? 'Product Key Expired on '+ objLR.expire_date : msg;
                msg = objLR.invalid == 'yes' ? 'Incorrect Serial Number' : msg; 
                msg = objLR.no_maintenance == 'yes'? 'This Product Key doesn\'t have support' : msg;
                // Override that NRF should pass
                msg = objLR.is_NFR == 'yes' ? 'success' : msg;
                objLR.message = msg;
                return objLR;
            }
            return null;
        }catch(Exception e) {
            System.debug('Callout Error:' + e.getMessage());
            
            Utility.LicenceResponce lr = new Utility.LicenceResponce();
            lr.message = e.getMessage();
            return lr;
        }
    }
    
    public class LicenceResponce{
        public String no_serial;	//no
        public String expired;	//yes
        public String is_NFR;	//no
        public String invalid;	//no
        public String expire_date;	//2015-04-29
        public String error;	//no
        public String error_msg;
        public String both_empty; //no
        public String no_incident; //yes
        public String in_grace; //no
        public String is_oem; //no
        public String is_msp; //no
        public String no_maintenance; //no
        public String product_mismatch; //no
        public String incident_attempt; //no
        public String message;
    }
    
    public static LicenceResponce parse(String json){
        return (LicenceResponce) System.JSON.deserialize(json, LicenceResponce.class);
    }
}