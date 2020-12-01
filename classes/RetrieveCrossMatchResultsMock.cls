@IsTest
global class RetrieveCrossMatchResultsMock implements HttpCalloutMock {
	final String good_Results_Found = '[{"reference_id":"1", "competitor_product_id": "6330757", "competitor_description": "dell - precision 2-in-1 15.6", "competitor_uom": "bx", "customer_qpu": 1, "customer_usage": 1, "competitor_price":1, "competitor_source": "", "xref_type": "Functional", "od_sku": "2703976", "od_sku_description": "dell™ xps 15 9570 laptop", "od_sku_uom": " 15.6", "od_sku_vpn": " 8th gen intel® core™ i7", "od_sku_mfg": " 16gb memory", "Recommendations":"1" }]';
	final String bad_authorization_response = '{"detail": "Detail Not Found"}';
    
    final String good_authorization_response = '{"access_token": "some_big_token____.........", "token_type": "bearer"}';
    final String bad_authorizationToken_response = '{"detail": "Incorrect email or password"}';

	final String good_recom_response = '1';
    final String bad_recom_response = 'duplicate key value violates unique constraint';
    
    final String good_status_result = '[ { "reference_id": 1, "quote_id": "string", "file_id": "string", "file_name": "string", "file_source": "string", "status": "string", "created_by_id": "89", "last_update_id": null, "sys_revision": 2, "sys_created_date": "2020-04-09T14:51:26.721998+00:00", "sys_modified_date": "2020-04-14T16:32:09.075945+00:00" } ]';
    final String erro_Message_result = '[ { "reference_id": 10, "status": "Failed", "message": "Error Occured" } ]';
    
    final String good_hit_rate_response = '[{ "noOfMatches": 25, "noOfNoMatches": 5, "hitrate": 83.33 }]';    
    String response_type = 'getResults';
    
    public RetrieveCrossMatchResultsMock(String type) {
        this.response_type = type;
    }
    
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        HttpResponse res = new HttpResponse();
        // Create a fake response
        if(this.response_type == 'getResults')
        {
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody(good_Results_Found);
            res.setStatusCode(200);
            return res;
        }
        else if(this.response_type == 'getToken')
        {
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody(good_authorization_response);
            res.setStatusCode(200);
            return res;
        }
        else if(this.response_type == 'addRecomm')
        {
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody(good_recom_response);
            res.setStatusCode(200);
            return res;
        }
        else if(this.response_type == 'hitRate')
        {
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody(good_hit_rate_response);
            res.setStatusCode(200);
            return res;
        }
        else if(this.response_type == 'updateRecomm')
        {
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody(good_recom_response);
            res.setStatusCode(200);
            return res;
        }
        else if(this.response_type == 'getStatus')
        {
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody(good_status_result);
            res.setStatusCode(200);
            return res;
        }
        else if(this.response_type == 'getErrorMessage')
        {
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody(erro_Message_result);
            res.setStatusCode(200);
            return res;
        }
        else
            return null;
        
       
        
    }
}