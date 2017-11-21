@isTest
global class RequestHelpControllerMockImpl implements HttpCalloutMock{
    global static String mockResponse = '{"no_serial":"no","expired":"no","is_NFR":"no","invalid":"no","error":"no","error_msg":"Function (isNFR) is not a valid method for this service"}';
    global static HTTPResponse respond(HTTPRequest req) {
        System.debug('All is Well');
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(mockResponse);
        res.setStatusCode(200);
        res.setStatus('OK');
        return res;
    }
}