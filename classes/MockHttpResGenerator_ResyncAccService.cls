/*************************************************************
*Name : MockHttpResGenerator_ResyncAccService
*Created By : Himanshu Sharma
*Created Date :20-03-2020
*Purpose : Mock class for the testing of ResyncAccountClass class
*JIRA: NAIT-125221
****************************************************************/
@isTest
global class MockHttpResGenerator_ResyncAccService implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
       // System.assertEquals('https://staging.odplabs.com/eai/services/account-setup-resync-service/eaiapi/resyncAccount', req.getEndpoint());
        //System.assertEquals('REST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"AddressSequence": "0","AOPSAccountID": "04688227"}');
        res.setStatusCode(200);
        return res;
    }
}