@isTest
global class EndlessAisleScratchpad_Mock implements HttpCalloutMock {
	global HttpResponse respond(HTTPRequest req) {
		System.debug(LoggingLevel.INFO, req.getEndpoint());
		if (req.getEndpoint().contains('api/v1/login/access-token'))
		{
			HttpResponse res = new HttpResponse();
			res.setHeader('Content-Type', 'application/json');
			res.setBody('{"access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE1NzY4NjIwNDcsInN1YiI6ImFjY2VzcyJ9.geOT9RBoddte8FhcWo8TiI8un-nbC9TR7fBf51TGDX0","token_type":"bearer"}');
			res.setStatusCode(200);
			return res;
		}
		else if (req.getEndpoint().contains('api/v1/product_search/'))
		{
			HttpResponse res = new HttpResponse();
			res.setHeader('Content-Type', 'application/json');
			res.setBody('[{"collection_id":"07022","vendor_product_numbers":["5293999"],"sku_list":[],"supplier_ids":[7219],"supplier_names":["SYNNEX CORP"],"supplier_vendor_product_numbers":["5293999"],"od_vendor_product_numbers":["07022"],"manufacturer_ids":["51790"],"manufacturer_names":["INLAND PRODUCTS INC."],"upc_list":["012405070229"],"short_description":"USB GAMING MOUSE","item_description":"USB GAMING MOUSE","min_supplier_id":"994278","min_list_price":5.99,"max_list_price":5.99,"avg_list_price":5.99,"min_unit_cost":5.56,"max_unit_cost":5.56,"avg_unit_cost":5.56,"sys_revision":1,"sys_created_date":"2019-11-26T14:04:53.640978+00:00","sys_modified_date":"2019-11-26T14:04:53.640978+00:00","count":1,"search_string":"[\'5293999\']","results":[{"collection_id":"07022","sku":null,"ea_vendor_product_number":"5293999","catalog":"vendor","short_description":"USB GAMING MOUSE","item_description":"USB GAMING MOUSE","item_number_type":null,"manufacturer_id":"51790","manufacturer_name":"INLAND PRODUCTS INC.","stripped_od_vendor_product_number":"07022","od_vendor_product_number":"07022","upc":"012405070229","list_price":5.99,"unit_cost":5.56,"web_availability_code":null,"department_code":null,"department_name":null,"class_code":null,"class_name":null,"subclass_code":null,"subclass_name":null,"supplier_id":7219,"supplier_name":"SYNNEX CORP","product_category_code":"003","product_category_description":"DIGITAL CAMERAS / KEYBOARDS / INPUT DEVICE","stripped_supplier_vendor_product_number":"5293999","supplier_vendor_product_number":"5293999","increment_required_quantity":1,"min_order_required_quantity":1,"country_of_origin_code":"UNKNOWN","is_private_brand":null,"package_units_of_measure":"EA","package_size":1491,"is_hazardous":null,"is_carcinogenic":null,"is_minority_business":null,"drop_ship_code":null,"is_virtual_warehouse_item":null,"rms_created_date":null,"rms_last_modified_date":null,"rms_last_sale_date":null,"sys_revision":1,"sys_created_date":"2019-11-26T14:12:38.033034+00:00","sys_modified_date":"2019-11-26T14:12:38.033034+00:00"}]}]');
			res.setStatusCode(200);
			return res;
		}
		else
		{
			return new HttpResponse();
		}
	}
}