global with sharing class NFRKeyCallout {
    String url {get;set;}
    String username {get;set;}
    String encodedAuth {get;set;}
    String passPhrase {get;set;}
    String result {get;set;}
    String response {get;set;}
    String serialNum {get;set;}
    String batchId {get;set;}
    String productKey {get;set;}
    String error {get;set;}
    String errorMessages {get;set;}
    String message {get;set;}
    String day {get;set;}
    String month {get;set;}
    Boolean linux {get;set;}
    Integer version {get;set;}
    Integer jobs {get;set;}
    public static final String ISSUED_TO = 'CRM NFR Welcome Kit';
    public static final String ISSUED_BY = 'CRM NFR Welcome Kit';

    public NFRKeyCallout()
    {
//erase before deployment
//username=STCWebstoreWSAccess
//url=https://msp.storagecraft.com:443/STCWebServices/STCSerialNumberManagementWS
//password=vk3423#kck.,*
//login=STCWebstoreWSAccess
//passphrase=Svdklk$#2345.dsfknL|~

		NFRCallout__c callout = NFRCallout__c.getOrgDefaults();
        System.debug('NFRCallout__c: ' + callout);

        if (Test.isRunningTest()){
            url = callout.Endpoint_Test__c;
            username = callout.Username_Test__c;
            encodedAuth = callout.EncodedAuth_Test__c;
        	passPhrase = callout.PassPhrase__c;
        }
        else {
            url = callout.Endpoint__c;
            username = callout.Username__c;
            encodedAuth = callout.EncodedAuth__c;
        	passPhrase = callout.PassPhrase__c;
        }
    }
    
    public String makeCall(String request,String license,Date expiration,Integer language,Integer productId,Boolean linux,String accId,String languageNam,String productNam)
    {
        Date startDate = Date.today();
        Integer numberDaysDue = startDate.daysBetween(expiration);
        system.debug(request+' '+license+' '+expiration+' '+language+' '+productId+' '+linux+' '+accId+' '+languageNam+' '+productNam);
        day = expiration.day().format();
        month = expiration.month().format();
        if(expiration.day()<10)day = '0'+ expiration.day().format();
        if(expiration.month()<10)month = '0'+ expiration.month().format();
        String formattedDate = expiration.year() +'-'+month +'-'+day;
        system.debug('formattedDate= '+formattedDate);
        version = 5;
        jobs =0;
        if(linux){version=6;jobs =1;}
        if(productId == 7){version=7;jobs =1;}
        error = null;

        Http h = new Http();
        HttpRequest req = new HttpRequest();

        req.setHeader('Authorization', encodedAuth);
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'text/xml');
        system.debug(request);
        If(request == 'New')
        {
            //system.debug('In New Call');
            req.setBody(
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.storagecraft.com/">'+
               '<soapenv:Header/>'+
               '<soapenv:Body>'+
                  '<ser:checkoutBatchOfSerialNumbers>'+
                     '<!--Optional:-->'+
                     '<passphrase>'+passPhrase+'</passphrase>'+
                     '<numberOfProductKeys>1</numberOfProductKeys>'+
                     '<productId>'+productId+'</productId>'+
                     '<languageId>'+language+'</languageId>'+
                     '<version>'+version+'</version>'+
                     '<packSize>1</packSize>'+
                     '<ITActivationDays>'+numberDaysDue+'</ITActivationDays>'+
                     '<V4Jobs>0</V4Jobs>'+
                     '<numFTPJobs>'+jobs+'</numFTPJobs>'+
                     '<numHSRJobs>'+jobs+'</numHSRJobs>'+
                     '<numSSTJobs>'+jobs+'</numSSTJobs>'+
                     '<productConfiguration>0</productConfiguration>'+
                     '<isVirtual>false</isVirtual>'+
                     '<isMSP>true</isMSP>'+
                     '<isNFR>true</isNFR>'+
                     '<!--Optional:-->'+
                     '<issuedTo>CRM NFR Welcome Kit</issuedTo>'+
                     '<!--Optional:-->'+
                     '<issuedBy>CRM NFR Welcome Kit</issuedBy>'+
                     '<vendorId>0</vendorId>'+
                     '<gre7ServerCount>0</gre7ServerCount>'+
                     '<virtualBundle>false</virtualBundle>'+
                     '<linux>'+linux+'</linux>'+
                  '</ser:checkoutBatchOfSerialNumbers>'+
               '</soapenv:Body>'+
            '</soapenv:Envelope>');
            system.debug('req='+req);
        }
        if(request == 'Replace')
        {
            req.setBody(
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.storagecraft.com/">'+
               '<soapenv:Header/>'+
               '<soapenv:Body>'+
                  '<ser:replaceNFRSerialNumber>'+
                     '<!--Optional:-->'+
                     '<passphrase>'+passPhrase+'</passphrase>'+
                     '<!--Optional:-->'+
                     '<serialNumber>'+license+'</serialNumber>'+
                  '</ser:replaceNFRSerialNumber>'+
               '</soapenv:Body>'+
            '</soapenv:Envelope>');
        }
        if(request == 'Terminate')
        {
            req.setBody(
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.storagecraft.com/">'+
               '<soapenv:Header/>'+
               '<soapenv:Body>'+
                  '<ser:terminateNFRSerialNumber>'+
                     '<!--Optional:-->'+
                     '<passphrase>'+passPhrase+'</passphrase>'+
                     '<!--Optional:-->'+
                     '<serialNumber>'+license+'</serialNumber>'+
                  '</ser:terminateNFRSerialNumber>'+
               '</soapenv:Body>'+
            '</soapenv:Envelope>');
        }
        if(request == 'Extend')
        {
            req.setBody(
            '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ser="http://service.storagecraft.com/">'+
               '<soapenv:Header/>'+
               '<soapenv:Body>'+
                  '<ser:extendNFRSerialNumber>'+
                     '<!--Optional:-->'+
                     '<passphrase>'+passPhrase+'</passphrase>'+
                     '<!--Optional:-->'+
                     '<serialNumber>'+license+'</serialNumber>'+
                     '<!--Optional:-->'+
                     '<expirationDate>'+formattedDate+'</expirationDate>'+
                  '</ser:extendNFRSerialNumber>'+
               '</soapenv:Body>'+
            '</soapenv:Envelope>');
        }
       if(request !=null)
        {
              try
                {
                                    HttpResponse res;
                    system.debug('in TRY statement');
                                    if(test.isrunningtest()){
                                        res = new HttpResponse();
                                res.setHeader('Content-Type', 'text/xml');
                                res.setBody('<?xml version=\'1.0\' encoding=\'UTF-8\'?><S:Envelope xmlns:S="http://schemas.xmlsoap.org/soap/envelope/"><S:Body><ns2:checkoutBatchOfSerialNumbersResponse xmlns:ns2="http://service.storagecraft.com/"><return><error>false</error><batchId>20160806US00030</batchId><productKeys>7204-A252-0C39-BE02</productKeys><serialNumbers>11189036</serialNumbers></return></ns2:checkoutBatchOfSerialNumbersResponse></S:Body></S:Envelope>');
                                res.setStatus('OK');
                                res.setStatusCode(200);
                                        res.getXmlStreamReader();
                                    }
                                    else{
                                        res = h.send(req);
                                    }
                system.debug('after initial request');
                 // Log the XML content
                                 System.debug('response:'+res);
                System.debug('responseBody:'+res.getBody());

                // Generate the HTTP response as an XML stream
                                XmlStreamReader reader = res.getXmlStreamReader();
                system.debug('after XmlStreamReader');
                // Read through the XML
                while (reader.hasNext())
                {
                    if(reader.getEventType() == XmlTag.END_DOCUMENT)
                    {
                        break;
                    }
                    else if(reader.getEventType() == XmlTag.START_ELEMENT)
                    {
                        if(reader.getLocalName() == 'productKeys' || reader.getLocalName() == 'serialNumber')
                        {
                            while(reader.hasNext())
                            {
                                if (reader.getEventType() == XmlTag.END_ELEMENT)
                                {
                                    break;
                                }
                                else if (reader.getEventType() == XmlTag.CHARACTERS)
                                {
                                    //System.debug('productKey: ' + reader.getText());
                                    productKey = reader.getText();
                                }
                                reader.next();
                            }
                        }
                        if(reader.getLocalName() == 'errorMessages')
                        {
                            while(reader.hasNext())
                            {
                                if (reader.getEventType() == XmlTag.END_ELEMENT)
                                {
                                    break;
                                }
                                else if (reader.getEventType() == XmlTag.CHARACTERS)
                                {
                                    //System.debug('errorMessages: ' + reader.getText());
                                    errorMessages = reader.getText();
                                    return errorMessages;
                                }
                                reader.next();
                            }
                        }
                    }
                    reader.next();
                }

                if(productKey != null && request == 'New')return productKey;
                if(productKey != null && request == 'Replace')return productKey;
                if(request == 'Extend')return 'Extend:successful';
                if(request == 'Terminate')return 'Terminate:successful';

                return response;
            }
            catch(System.CalloutException e)
            {
                            system.debug('Catch:'+e);
                return 'Exeption:Failed to Parse Response';
            }

        }
        return 'Failure';
    }
}