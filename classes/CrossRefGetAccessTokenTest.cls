@isTest
private class CrossRefGetAccessTokenTest {
    @isTest
    static void getAccessTokenTest() {
        Test.setMock(HttpCalloutMock.class, new RetrieveCrossMatchResultsMock('getToken'));
        Test.startTest();

        CrossRefGetAccessToken.getAccessToken();
        Test.stopTest();
    }
    
     @isTest
    private static void testWrapper(){
     
      CrossRefGetAccessToken.TokenResponse record1 = new CrossRefGetAccessToken.TokenResponse(); 
        
        	record1.access_token = '1';
            record1.token_type = 'Test';
    }
    
    
}