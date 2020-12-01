@isTest
global class JIRAWebserviceMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
         HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"id":"686436","key":"NAIT-120683","self":"https://officedepot.atlassian.net/rest/api/3/issue/686436"}');
        response.setStatusCode(200);
        return response;
    }
}