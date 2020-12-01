@isTest
global class GoogleMapsControllertestclass_T implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {       
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"example":"tesnt"}');
        res.setStatusCode(200);
        return res;
    }
}