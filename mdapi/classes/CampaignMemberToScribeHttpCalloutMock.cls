@isTest
global class CampaignMemberToScribeHttpCalloutMock implements HttpCalloutMock {

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {

        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'text/xml; charset=utf-8');
        String responseBody = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
                                   '<notifications xmlns="http://soap.sforce.com/2005/09/outbound">'+
                                   '<Ack>Success</Ack>'+
                                   '</notifications>'+
                                   '</soapenv:Body>'+
                                   '</soapenv:Envelope>';
        response.setBody(responseBody);
        response.setStatusCode(200);
        response.setStatus('OK');
        return response;
    }

}