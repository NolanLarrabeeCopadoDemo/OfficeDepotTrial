@IsTest
global class ItemCrossRefMock implements HttpCalloutMock{
    
    final String bad_authorization_response = '{"detail": "Detail Not Found"}';
    final String good_controlRecord_result = '[ { "reference_id": 101, "quote_id": "abc1", "file_id": "2", "file_name": "testfile", "file_source": "testsource", "status": "teststatus", "created_by_id": "testuser", "last_update_id": null, "sys_revision": 2, "sys_created_date": "2020-04-09T14:51:26.721998+00:00", "resultLink": "testresult", "reason": "testreason" } ]';
    final String good_status_result = '[ { "reference_id": 1, "quote_id": "string", "file_id": "string", "file_name": "string", "file_source": "string", "status": "string", "created_by_id": "89", "last_update_id": null, "sys_revision": 2, "sys_created_date": "2020-04-09T14:51:26.721998+00:00", "sys_modified_date": "2020-04-14T16:32:09.075945+00:00" } ]';
    final String good_refID_response = '[ { "reference_id": 101}]';
        
    String response_type = 'getControlRecord';
    
    public ItemCrossRefMock(String type) {
        this.response_type = type;
    }
    global HTTPResponse respond(HTTPRequest req){
         HttpResponse res = new HttpResponse();
        if(this.response_type == 'saveFile'){
            res.setHeader('Content-Type', 'application/json');
            res.setBody(good_controlRecord_result);
            res.setStatusCode(200);
            return res;
            
        }
        else if(this.response_type == 'sendRefID')
        {
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody(good_refID_response);
            res.setStatusCode(200);
            return res;
        }
        else if(this.response_type == 'getResults')
        {
            
            res.setHeader('Content-Type', 'application/json');
            res.setBody(good_status_result);
            res.setStatusCode(200);
            return res;
        }
            return null;
    }

}