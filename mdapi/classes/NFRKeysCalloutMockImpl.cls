@isTest()
global class NFRKeysCalloutMockImpl implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        System.debug('MOCK CALLOUT');
        
        HttpResponse response = new HttpResponse();
         
        if (request.getBody().Contains('checkoutBatchOfSerialNumbers')) {
            response.setHeader('Content-Type', 'application/json');
            response.setBody('<html><productKeys>1234-5678-1234-5678</productKeys></html>');
            response.setStatusCode(200);
        }
        else if (request.getBody().Contains('extendNFRSerialNumber')) {
            response.setHeader('Content-Type', 'application/json');
            response.setBody('<html></html>');
            response.setStatusCode(200);
        }
        else if (request.getBody().Contains('replaceNFRSerialNumber')) {
            response.setHeader('Content-Type', 'application/json');
            response.setBody('<html><productKeys>ABCD-EF01-ABCD-EF01</productKeys></html>');
            response.setStatusCode(200);
        }
        else if (request.getBody().Contains('terminateNFRSerialNumber')) {
            response.setHeader('Content-Type', 'application/json');
            response.setBody('<html></html>');
            response.setStatusCode(200);
        }
        else {
            response.setStatusCode(405); 
        }
        
        System.debug('response: ' + response);
        System.debug('response.Body: ' + response.getBody());
        
        return response;
    }
}