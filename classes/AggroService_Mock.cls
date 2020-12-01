/*
 * Created by Adam on 8/8/2018.
 *
 * @description This class is used to test the Aggro Service Callouts
 *
 * @group Aggro
 *
 * @group-content /ApexDocContent/Index.htm
 */
@IsTest
public with sharing class AggroService_Mock implements HttpCalloutMock {

	final String request_body = '{"record":{"duns_number": "079829711","street_1": "6503 N Military Trl","street_2": "Ste 123","name": "Office Depot","city": "Boca Raton","state": "FL","zip_code": "33496"}}';

	final String token_response = '{"refresh":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTU0NTI0NDc3NSwianRpIjoiZDUzZWY5MmFjZWM3NGI2ZmJjZDRhMDRmODE1ZjJhOWQiLCJ1c2VyX2lkIjozfQ.ypLOeYT2-xF8wgGMqZXdjr38IEcx-45gjoREH0SHQEk","access":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNTQwMDYwNzc1LCJqdGkiOiI5OWNjYjQ3MzQ1YTI0Y2M1OTNmMjZkMjBjNjA0OTc1NSIsInVzZXJfaWQiOjN9.Q0hqWCmfVOKWnhc-y2lxHEUn-I5wWqzp9nOkaHQWOOw"}';

	final String alternate_lookup_response = '{"module": "dnb_lookup", "data": {"operational": [{"site_duns_id": "153531108", "alt_linkage_type_code": "F", "case_country_code": "805", "franchise_type_code": "59438001", "linkage_structure_code": "C", "ult_duns_id": "153531108", "ult_name": "OFFICE DEPOT, INC.", "ult_street_1": "6600 N MILITARY TRL", "ult_street_2": null, "ult_city": "BOCA RATON", "ult_state": "FL", "ult_employee_count": 2052, "ult_sales": "1190221.00", "opt_duns_id": "153531108", "opt_name": "OFFICE DEPOT, INC.", "opt_street_1": "6600 N MILITARY TRL", "opt_street_2": null, "opt_city": "BOCA RATON", "opt_state": "FL", "opt_employee_count": 2052, "opt_sales": "1190221.00", "u_opt_duns_id": "153531108", "u_opt_name": "OFFICE DEPOT, INC.", "u_opt_street_1": "6600 N MILITARY TRL", "u_opt_street_2": null, "u_opt_city": "BOCA RATON", "u_opt_state": "FL", "u_opt_employee_count": 2052, "u_opt_sales": "1190221.00"}], "minority_ownership": [{"site_duns_id": "153531108", "linkage_structure_code": "C", "case_country_code": "805", "case_sic_code": "59430000", "minority_ownership_code": "M", "percent_ownership_amount": "10.490", "owner_duns_id": "786987052", "owner_name": "BLACKROCK, INC.", "owner_street_1": "55 E 52ND ST", "owner_street_2": null, "owner_city": "NEW YORK", "owner_state": "NY", "owner_site_employee_count": 612, "owner_site_sales": "230385714.00"}, {"site_duns_id": "153531108", "linkage_structure_code": "C", "case_country_code": "805", "case_sic_code": "59430000", "minority_ownership_code": "M", "percent_ownership_amount": "8.980", "owner_duns_id": "037182961", "owner_name": "Hotchkis and Wiley Capital Management LLC", "owner_street_1": "725 S Figueroa St", "owner_street_2": "# 3900", "owner_city": "Los Angeles", "owner_state": "CA", "owner_site_employee_count": 126, "owner_site_sales": "9010862.00"}, {"site_duns_id": "153531108", "linkage_structure_code": "C", "case_country_code": "805", "case_sic_code": "59430000", "minority_ownership_code": "M", "percent_ownership_amount": "7.920", "owner_duns_id": "060074812", "owner_name": "VANGUARD GROUP, INC., THE", "owner_street_1": "100 VANGUARD BLVD", "owner_street_2": null, "owner_city": "MALVERN", "owner_state": "PA", "owner_site_employee_count": 6097, "owner_site_sales": "134152931.00"}, {"site_duns_id": "153531108", "linkage_structure_code": "C", "case_country_code": "805", "case_sic_code": "59430000", "minority_ownership_code": "M", "percent_ownership_amount": "6.370", "owner_duns_id": null, "owner_name": null, "owner_street_1": null, "owner_street_2": null, "owner_city": null, "owner_state": null, "owner_site_employee_count": null, "owner_site_sales": null}, {"site_duns_id": "153531108", "linkage_structure_code": "C", "case_country_code": "805", "case_sic_code": "59430000", "minority_ownership_code": "M", "percent_ownership_amount": "5.810", "owner_duns_id": "051550713", "owner_name": "The Bank of New York Mellon Corporation", "owner_street_1": "225 Liberty St", "owner_street_2": null, "owner_city": "New York", "owner_state": "NY", "owner_site_employee_count": 403, "owner_site_sales": "1.00"}]}}';

	final String not_authorized = '{"detail":"Authentication credentials were not provided."}';

	final String health_check = '{"status": "ok"}';

	private Map<String, String> responseMapping = new Map<String, String>{
		'/health'=>'{"status": "ok"}',
		'/lookup/full_alternate/'=>alternate_lookup_response
	};
    
    private Map<String, Integer> statusCodeMapping = new Map<String, Integer>();

	Aggro_Service__mdt aggro_token = [SELECT Aggro_Access_Token__c FROM Aggro_Service__mdt WHERE DeveloperName='Dev_Token'];
	String aggro_endpoint = Label.Aggro_Service_Endpoint;

	public AggroService_Mock() {}

	public AggroService_Mock(Map<String, String> responseMapping) {
		this.responseMapping.putAll(responseMapping);
	}
    
    public AggroService_Mock(Map<String, String> responseMapping, Map<String, Integer> statusCodeMapping) {
        this.responseMapping.putAll(responseMapping);
        this.statusCodeMapping.putAll(statusCodeMapping);
    }

	public HTTPResponse respond(HTTPRequest request) {
		HttpResponse response = new HttpResponse();
		System.debug(LoggingLevel.INFO, request.getEndpoint());
		String endpoint = request.getEndpoint();

		response.setHeader('Content-Type', 'application/json');
        
        response.setStatusCode(200); // Set a default status code.
        // If the endpoint ends with one of the mapped URLs, set the status code.
        for(String url_endpoint : statusCodeMapping.keySet()) {
            if(endpoint.endsWith(url_endpoint)) {
                response.setStatusCode(statusCodeMapping.get(url_endpoint));
            }
        }

		// If the endpoint ends with one of the mapped URLs, return the associated response.  
		for(String url_endpoint: responseMapping.keySet()){
			if (endpoint.endsWith(url_endpoint)){
				response.setBody(responseMapping.get(url_endpoint));
				return response;
			}
		}

        // The below code only runs if a URL mapping was not found for the response body.
		System.debug(LoggingLevel.INFO, 'Endpoint is ' + request.getEndpoint());
		response.setBody('{"error": "Resource not found"}');
		response.setStatusCode(404);
		return response;
	}
}