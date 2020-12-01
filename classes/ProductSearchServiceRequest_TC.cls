@isTest
public class ProductSearchServiceRequest_TC {


    public class ProductSearchServiceMock implements HttpCalloutMock {
        final String good_authorization_response = '{"access_token": "some_big_token____.........", "token_type": "bearer"}';
        final String bad_authorization_response = '{"detail": "Incorrect email or password"}';

        final String recieved_search_results = '{"count":270,"query_limit":1,"query_offset":0,"search_query":"dell & laptop","search_criteria":"keyword","query_time":0,"product_list":[{"collection_id":"09CKY","vendor_product_numbers":["09CKY"],"sku_list":["8467401"],"supplier_ids":[949100],"supplier_names":["DELL MARKETING LP"],"supplier_vendor_product_numbers":["OD-09CKYFX"],"od_vendor_product_numbers":["09CKY"],"manufacturer_ids":["11652"],"manufacturer_names":["DELL"],"upc_list":["884116293804"],"short_description":"LPTP DELL 9570 I5","item_description":"LAPTOP DELL 9570 I5 8GB 256SSD","min_supplier_id":"994278","min_list_price":1649.0,"max_list_price":1649.0,"avg_list_price":1649.0,"min_unit_cost":1550.0,"max_unit_cost":1550.0,"avg_unit_cost":1550.0,"sys_revision":1,"sys_created_date":"2019-12-05T22:30:23.152647+00:00","sys_modified_date":"2019-12-05T22:30:23.152647+00:00","count":1,"results":[{"collection_id":"09CKY","sku":"8467401","ea_vendor_product_number":"09CKY","catalog":"od","short_description":"LPTP DELL 9570 I5","item_description":"LAPTOP DELL 9570 I5 8GB 256SSD","item_number_type":"ITEM6","manufacturer_id":"11652","manufacturer_name":"DELL","stripped_od_vendor_product_number":"09CKY","od_vendor_product_number":"09CKY","upc":"884116293804","list_price":1649.0,"unit_cost":1550.0,"web_availability_code":"A","department_code":63,"department_name":"PORTABLE COMPUTERS","class_code":902,"class_name":"LAPTOP COMPUTERS","subclass_code":1570,"subclass_name":"DELL MARKETING LP","supplier_id":949100,"supplier_name":"DELL MARKETING LP","product_category_code":null,"product_category_description":null,"stripped_supplier_vendor_product_number":"OD09CKYFX","supplier_vendor_product_number":"OD-09CKYFX","increment_required_quantity":1,"min_order_required_quantity":1,"country_of_origin_code":"CN","is_private_brand":false,"package_units_of_measure":"EA","package_size":1,"is_hazardous":false,"is_carcinogenic":false,"is_minority_business":false,"drop_ship_code":"N","is_virtual_warehouse_item":true,"rms_created_date":"2019-01-02","rms_last_modified_date":"2019-03-25","rms_last_sale_date":null,"sys_revision":1,"sys_created_date":"2019-12-05T22:36:48.909701+00:00","sys_modified_date":"2019-12-05T22:36:48.909701+00:00"}]}]}';
        final String recieved_supplier_vpn_results = '{"count":2,"query_limit":1,"query_offset":0,"search_query":"649776","search_criteria":"sku","query_time":0,"product_list":[{"collection_id":"12135296","vendor_product_numbers":["12135296"],"sku_list":["649776"],"supplier_ids":[994289],"supplier_names":["TECH DATA CORP"],"supplier_vendor_product_numbers":["12135296"],"od_vendor_product_numbers":[],"manufacturer_ids":["UNKNOWN"],"manufacturer_names":[],"upc_list":["190576402749"],"short_description":"LAPTOP FLEX 4 14 L","item_description":"LAPTOP FLEX 4 14 LENOVO","min_supplier_id":"994278","min_list_price":729.99,"max_list_price":729.99,"avg_list_price":729.99,"min_unit_cost":677.31,"max_unit_cost":677.31,"avg_unit_cost":677.31,"sys_revision":1,"sys_created_date":"2019-11-26T14:04:53.640978+00:00","sys_modified_date":"2019-11-26T14:04:53.640978+00:00","count":1,"results":[{"collection_id":"12135296","sku":"649776","ea_vendor_product_number":"12135296","catalog":"od","short_description":"LAPTOP FLEX 4 14 L","item_description":"LAPTOP FLEX 4 14 LENOVO","item_number_type":"ITEM6","manufacturer_id":"UNKNOWN","manufacturer_name":null,"stripped_od_vendor_product_number":null,"od_vendor_product_number":null,"upc":"190576402749","list_price":729.99,"unit_cost":677.31,"web_availability_code":"A","department_code":63,"department_name":"PORTABLE COMPUTERS","class_code":902,"class_name":"LAPTOP COMPUTERS","subclass_code":901,"subclass_name":"TECH DATA CORP","supplier_id":994289,"supplier_name":"TECH DATA CORP","product_category_code":null,"product_category_description":null,"stripped_supplier_vendor_product_number":"12135296","supplier_vendor_product_number":"12135296","increment_required_quantity":1,"min_order_required_quantity":1,"country_of_origin_code":"US","is_private_brand":false,"package_units_of_measure":"EA","package_size":1,"is_hazardous":false,"is_carcinogenic":false,"is_minority_business":false,"drop_ship_code":"N","is_virtual_warehouse_item":false,"rms_created_date":"2016-05-05","rms_last_modified_date":"2017-01-26","rms_last_sale_date":"2019-01-19","sys_revision":1,"sys_created_date":"2019-11-26T14:12:38.033034+00:00","sys_modified_date":"2019-11-26T14:12:38.033034+00:00"}]}]}';
        final String product_search_result = '{ "count": 0, "query_limit": 0, "query_offset": 0, "search_query": "string", "search_criteria": "string", "query_time": 0, "product_list": [ { "collection_id": "string", "vendor_product_numbers": [ "string" ], "sku_list": [ "string" ], "supplier_ids": [ 0 ], "supplier_names": [ "string" ], "supplier_vendor_product_numbers": [ "string" ], "od_vendor_product_numbers": [ "string" ], "manufacturer_ids": [ "string" ], "manufacturer_names": [ "string" ], "upc_list": [ "string" ], "short_description": "string", "item_description": "string", "min_supplier_id": "string", "min_list_price": 0, "max_list_price": 0, "avg_list_price": 0, "min_unit_cost": 0, "max_unit_cost": 0, "avg_unit_cost": 0, "sys_revision": 0, "sys_created_date": "2020-01-03T15:42:56.266Z", "sys_modified_date": "2020-01-03T15:42:56.266Z", "count": 0, "results": [ { "collection_id": "string", "sku": "string", "ea_vendor_product_number": "string", "catalog": "string", "short_description": "string", "item_description": "string", "item_number_type": "string", "manufacturer_id": "string", "manufacturer_name": "string", "stripped_od_vendor_product_number": "string", "od_vendor_product_number": "string", "upc": "string", "list_price": 0, "unit_cost": 0, "web_availability_code": "string", "department_code": 0, "department_name": "string", "class_code": 0, "class_name": "string", "subclass_code": 0, "subclass_name": "string", "supplier_id": 0, "supplier_name": "string", "product_category_code": "string", "product_category_description": "string", "stripped_supplier_vendor_product_number": "string", "supplier_vendor_product_number": "string", "increment_required_quantity": 0, "min_order_required_quantity": 0, "country_of_origin_code": "string", "is_private_brand": true, "package_units_of_measure": "string", "package_size": 0, "is_hazardous": true, "is_carcinogenic": true, "is_minority_business": true, "drop_ship_code": "string", "is_virtual_warehouse_item": true, "rms_created_date": "2020-01-03", "rms_last_modified_date": "2020-01-03", "rms_last_sale_date": "2020-01-03", "sys_revision": 0, "sys_created_date": "2020-01-03T15:42:56.266Z", "sys_modified_date": "2020-01-03T15:42:56.266Z" } ] } ] }';
        final String recieved_no_search_results = '{"count":0,"query_limit":1,"query_offset":0,"search_query":"dell & computer & bla","search_criteria":"keyword","query_time":0,"product_list":[]}';

        private Map<String, String> good_response_map = new Map<String, String>{
            '/health' => '{"status": "ok"}',
            '/api/v1/login/access-token' => good_authorization_response
        };

        private Map<String, String> bad_response_map = new Map<String, String>{
            '/health' => '{"status": "not okay"}',
            '/api/v1/login/access-token' => bad_authorization_response
        };

        private Map<String, String> search_result_map = new Map<String, String>{
            '/product_search/keyword/dell%26laptop' => recieved_search_results,
            'product_search/keyword/dell%26laptops%26bla' => recieved_no_search_results,
            '/product_search/supplier_vpn/' => recieved_supplier_vpn_results,
            '/api/v1/login/access-token' => good_authorization_response
        };

        private Map<String, Integer> status_code_mapping = new Map<String, Integer>();

        String resonse_type = 'good';

        // Default
        public ProductSearchServiceMock(String type) {
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
                    if(endpoint.contains(url_endpoint)) {
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
                    if(endpoint.contains(url_endpoint)) {
                        response.setBody(good_response_map.get(url_endpoint));
                        return response;
                    }
                }
            }

            if (this.resonse_type == 'search'){
                response.setStatusCode(200); 
                // Set a default status code.
                // If the endpoint ends with one of the mapped URLs, set the status code.
                for(String url_endpoint : search_result_map.keySet()) {
                    if(endpoint.contains(url_endpoint)) {
                        response.setBody(search_result_map.get(url_endpoint));
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


    @isTest
    static void test_request_fails_with_bad_auth() {
        Test.setMock(HttpCalloutMock.class, new ProductSearchServiceMock('bad'));
        Test.startTest();
        try {
            ProductSearchServiceRequest.GetAuthorizationToken();
        } catch (AuraHandledException e){
            System.debug('Exception Recieved: ' + e);
        }
        Test.stopTest();
    }


    @isTest
    static void test_request_runs_with_good_auth() {
        Test.setMock(HttpCalloutMock.class, new ProductSearchServiceMock('good'));
        Test.startTest();
        ProductSearchServiceRequest.GetAuthorizationToken();
        Test.stopTest();
    }


    @isTest
    static void test_search_request_runs_with_good_auth_and_results() {
        Test.setMock(HttpCalloutMock.class, new ProductSearchServiceMock('search'));
        Test.startTest();
        Map<String, Object> search_req = new Map<String, Object>{'searchKey'=> 'keyword=dell%26laptop'};

        ProductSearchServiceRequest.MainCallOut(search_req);
        Test.stopTest();
    }


    @isTest
    static void test_search_request_runs_with_good_auth_and_no_results() {
        Test.setMock(HttpCalloutMock.class, new ProductSearchServiceMock('search'));
        Test.startTest();

        Map<String, Object> search_req = new Map<String, Object>{'searchKey'=> 'keyword=dell%26laptop%26bla'};
        ProductSearchServiceRequest.MainCallOut(search_req);
        Test.stopTest();
    }


}