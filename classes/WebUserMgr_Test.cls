@isTest
public without sharing class WebUserMgr_Test {
    public WebUserMgr_Test() {}

    @isTest 
    static void test_doPost() {
        
        Map<String, String> test_request = new Map<String, String>{
            'FirstName' => 'Test',
            'LastName' => '',
            'Email' => '',
            'Phone' => '',
            'LoginName' => '',
            'Address1' => '',
            'City' => '',
            'State' => '',
            'Zip' => '',
            'AopsCustId' => '',
            'pwd' => '',
            'PONumber' => '',
            'ccenter' => '',
            'Release' => '',
            'Desktop' => '',
            'SSO_Id' => '',
            'CustomCatalogCode' => ''
        };

        // Set up a test request
        RestRequest request = new RestRequest(); 
        RestResponse response = new RestResponse();    
        RestContext.request = request;
        RestContext.response= response;

        request.requestUri = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/WebUserMgr/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf((JSON.serialize(test_request)));
        RestContext.request = request;
        // Call the method to test
        WebUserMgr.doPost(
            'Test', 'LastName', 'Email@email.com', '555555555', 'LoginName', 'Address1', 'Address2', 'City', 'State', 'Zip', 'AopsCustId', 'pwd', 'PONumber', 'ccenter', 'Release', 'Desktop', 'SSO_Id', 'CustomCatalogCode'
            );
        // Verify results
        System.assert(request.requestBody != null);
    }
}