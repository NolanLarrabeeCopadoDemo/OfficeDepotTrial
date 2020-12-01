@isTest
global class FakeCalloutMock implements HttpCalloutMock{
  global HttpResponse respond(HTTPRequest req){
  
    //System.assertEquals('https://stage.officemaxcanada.com/sites/salesforce/fc/processSFfcApplication.aspx', req.getEndpoint());
    //System.assertEquals('POST', req.getMethod());
  
    HttpResponse res = new HttpResponse();
    res.setStatus('OK');
    res.setStatusCode(200);
   // res.setBody('@@@@<target_url>http://Officemaxcanada.com</target_url>@@@@');
   res.setBody('@@@@<target_url>http://grandandtoy.com</target_url>@@@@');
    return res;
  }
}