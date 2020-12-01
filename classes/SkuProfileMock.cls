@IsTest
global class SkuProfileMock  implements HttpCalloutMock {
    final String good_results = '[{"sku":"255876", "sku_desc": "ROUND STICK,MEDIUM BLUE 60/BX", "final_response" : "Y"}]';
	final String bad_authorization_response = '{"detail": "Detail Not Found"}';
        
    String response_type = 'searchBySku';
    
    public SkuProfileMock(String type) {
        this.response_type = type;
    }
    
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        HttpResponse res = new HttpResponse();
        // Create a fake response
        if(this.response_type == 'searchBySku')
        {
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody(good_results);
            res.setStatusCode(200);
            return res;
        }
        else if(this.response_type == 'findAlternates')
        {
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody(good_results);
            res.setStatusCode(200);
            return res;
        }
        else if(this.response_type == 'getStockingStrategy')
        {
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody(good_results);
            res.setStatusCode(200);
            return res;
        }
        else if(this.response_type == 'getCompPricing')
        {
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody(good_results);
            res.setStatusCode(200);
            return res;
        }
        else
            return null;
             
    }
}