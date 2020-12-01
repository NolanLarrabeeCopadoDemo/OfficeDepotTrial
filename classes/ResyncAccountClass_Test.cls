/*************************************************************
*Name : ResyncAccountClass_Test
*Created By : Himanshu Sharma
*Created Date :20-03-2020
*Purpose : Test class for ResyncAccountClass class
*JIRA: NAIT-125221
****************************************************************/
@isTest
public with sharing class ResyncAccountClass_Test {
    @isTest static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResGenerator_ResyncAccService());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        String res=ResyncAccountClass.ResyncAccount('0','04688227');
        HttpRequest req = new HttpRequest();
       // HttpResponse res = ResyncAccountClass.ResyncAccount('0','04688227');
        
        // Verify response received contains fake values
        String contentType = req.getHeader('Content-Type');
       // System.assert(contentType == 'application/json');
        //String actualValue = req.getBody();
        String actualValue = res;
        String expectedValue = '{"AddressSequence": "0","AOPSAccountID": "04688227"}';
        //System.assertEquals(actualValue, expectedValue);
       // System.assertEquals(200, res.getStatusCode());
    }
}