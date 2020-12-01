@IsTest
public with sharing class ExternalServices_Mock implements HttpCalloutMock{
	
        
    final String good_authorization_response = '{"access_token": "some_big_token____.........", "token_type": "bearer"}';
	final String bad_authorization_response = '{"detail": "Incorrect email or password"}';
    
    private Map<String, String> good_response_map = new Map<String, String>{
		'/health' => '{"status": "ok"}',
		'/api/v1/login/access-token' => good_authorization_response
	};

    private Map<String, String> job_response_map = new Map<String, String>{
		'/jobs/rms/rms_loader' => '{"msg":"RMS Loader Queued"}',
		'/api/v1/login/access-token' => good_authorization_response
	};

    
	private Map<String, String> bad_response_map = new Map<String, String>{
		'/health' => '{"status": "not okay"}',
		'/api/v1/login/access-token' => bad_authorization_response
	};

    String resonse_type = 'good';

    // Default
	public ExternalServices_Mock(String type) {
        this.resonse_type = type;
    }

	public HTTPResponse respond(HTTPRequest request) {
		HttpResponse response = new HttpResponse();
		System.debug(LoggingLevel.INFO, request.getEndpoint());
		String endpoint = request.getEndpoint();

		response.setHeader('Content-Type', 'application/json');

        if (this.resonse_type == 'bad'){
            response.setStatusCode(400); 
            // Set a default status code.
            // If the endpoint ends with one of the mapped URLs, set the status code.
            for(String url_endpoint : bad_response_map.keySet()) {
                if(endpoint.endsWith(url_endpoint)) {
                    response.setBody(bad_response_map.get(url_endpoint));
                    return response;
                }
            }
        }

        if (this.resonse_type == 'good'){
            response.setStatusCode(200); 
            // Set a default status code.
            // If the endpoint ends with one of the mapped URLs, set the status code.
            for(String url_endpoint : good_response_map.keySet()) {
                if(endpoint.endsWith(url_endpoint)) {
                    response.setBody(good_response_map.get(url_endpoint));
                    return response;
                }
            }
        }

        if (this.resonse_type == 'job'){
            response.setStatusCode(200); 
            // Set a default status code.
            // If the endpoint ends with one of the mapped URLs, set the status code.
            for(String url_endpoint : job_response_map.keySet()) {
                if(endpoint.endsWith(url_endpoint)) {
                    response.setBody(job_response_map.get(url_endpoint));
                    return response;
                }
            }
        }

        // The below code only runs if a URL mapping was not found for the response body.
		System.debug(LoggingLevel.INFO, 'Endpoint is ' + request.getEndpoint());
		response.setBody('{"error": "Resource not found"}');
		response.setStatusCode(404);
		return response;
	}



}