@isTest(SeeAllData=true)
private class GPOUserReg_TC 
{

    static testMethod void myUnitTest(){
        
         // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new SingleRequestMock());
        User testUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        
        System.runAs(testUser){
        //GPO_Community_Setup__c cs = new GPO_Community_Setup__c(Name = 'com2Settings' , SOA_EndPoint__c = 'test.com',soa_connection__c = 'developer:developer');
        //insert cs;
        //system.assertNotEquals(cs.Id , null);
        
        GPOUserReg reg = new GPOUserReg ();
        GPOUserReg.GPOUserRefRequest req = new GPOUserReg.GPOUserRefRequest ();
        reg.executeUserReg(req);
        
        }
    }
    
   /* @isTest static void testCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator1());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res = CalloutClass.getInfoFromExternalService();
        
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"example":"test"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
    }*/
   
}