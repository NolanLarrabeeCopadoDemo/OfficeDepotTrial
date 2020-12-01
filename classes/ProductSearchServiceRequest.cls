public class ProductSearchServiceRequest {
    class ProductSearchException extends Exception{}

    public static String GetAuthorizationToken() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SFDC_PRODUCT_SEARCH/api/v1/login/access-token');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setBody('username={!$Credential.Username}&password={!$Credential.Password}');
        HTTPResponse response = http.send(request);
        if (response.getStatusCode() > 204){
            System.debug(LoggingLevel.ERROR, response.getStatusCode() + ' ' + response.getBody());
			throw new AuraHandledException('Could not authenticate against product search service! Please create a case with subject Product Search is not available.');
        } else {
			System.debug(LoggingLevel.INFO, response.getStatusCode());
		}
        TokenResponse restoken = (TokenResponse)JSON.deserialize(response.getBody(), TokenResponse.class);
        return restoken.access_token;
    }

    @AuraEnabled
    public static ProductSearchResult MainCallOut(Map<String, Object>  params)
	{

		if (params == null)
			return null;
		

		List<String> manufacturerlst = new List<String>();
		List<String> odSkuNumberlst = new List<String>();

		String auth_token 	= GetAuthorizationToken();
		String searchKey 	= params.containsKey('searchKey') ? (String)params.get('searchKey') : null;
		String[] arrTest 	= searchKey.split('=');
		String search_key 	= String.join(arrTest[1].split(' '), '%26');
		String query_offset	= params.containsKey('offset') ? (String)params.get('offset') : '0';
		String query_limit 	= params.containsKey('limit') ? (String)params.get('limit') : '500';
		String search_url 	= 'callout:SFDC_PRODUCT_SEARCH/api/v1/product_search/' + arrTest[0] + '/' + search_key + '?offset=' + query_offset + '&limit=' + query_limit;
		System.debug(search_url);

		Http http 			= new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint(search_url);
		request.setMethod('GET');
		request.setHeader('Authorization', 'Bearer ' + auth_token);
		request.setHeader('Content-Type', 'application/JSON');
		HTTPResponse response = http.send(request);

		if (response.getStatusCode() > 204){
			System.debug(LoggingLevel.ERROR, response.getStatusCode() + ' ' + response.getBody());
            throw new ProductSearchException('Response failed with status ' + response.getStatusCode() + '\n' + + response.getBody());
		} else {
			System.debug(LoggingLevel.INFO, response.getStatusCode());
		}

		ProductSearchResult resproduct = (ProductSearchResult) JSON.deserialize(response.getBody(), ProductSearchResult.class);

		if (resproduct.product_list.isEmpty()){
            if (Test.isRunningTest())
                System.debug(LoggingLevel.INFO, response.getBody());
            return null;
        }

		for (ProductDetailsResponse cust_res: resproduct.product_list)
		{
			odSkuNumberlst.addAll(cust_res.sku_list);
			manufacturerlst.addAll(cust_res.manufacturer_names);
		}

		resproduct.manufacturer_names =  manufacturerlst;
		resproduct.od_skus =  odSkuNumberlst;
		
		for(ProductDetailsResponse product_details: resproduct.product_list)
		{
			product_details.populate_singleton_fields();
			for(SupplierResponse sup_res: product_details.results)
			{
				sup_res.populate_singletons();
			}
		}
		return resproduct;
	}


    public virtual class ProductSearchResult {

        /**
        Used to Deserialize Oriduct Serach Requests the product search service. 
        {
            "count": 0,
            "query_limit": 0,
            "query_offset": 0,
            "search_query": "string",
            "search_criteria": "string",
            "query_time": 0,
            "results": [
                {
                "collection_id": "string",
                "vendor_product_numbers": [
                    "string"
                ],
                "sku_list": [
                    "string"
                ],
                "supplier_ids": [
                    0
                ],
                "supplier_names": [
                    "string"
                ],
                "supplier_vendor_product_numbers": [
                    "string"
                ],
                "od_vendor_product_numbers": [
                    "string"
                ],
                "manufacturer_ids": [
                    "string"
                ],
                "manufacturer_names": [
                    "string"
                ],
                "upc_list": [
                    "string"
                ],
                "short_description": "string",
                "item_description": "string",
                "min_supplier_id": "string",
                "min_list_price": 0,
                "max_list_price": 0,
                "avg_list_price": 0,
                "min_unit_cost": 0,
                "max_unit_cost": 0,
                "avg_unit_cost": 0,
                "sys_revision": 0,
                "sys_created_date": "2020-01-03T15:42:56.266Z",
                "sys_modified_date": "2020-01-03T15:42:56.266Z",
                "count": 0,
                "results": [
                            {
                            "collection_id": "string",
                            "sku": "string",
                            "ea_vendor_product_number": "string",
                            "catalog": "string",
                            "short_description": "string",
                            "item_description": "string",
                            "item_number_type": "string",
                            "manufacturer_id": "string",
                            "manufacturer_name": "string",
                            "stripped_od_vendor_product_number": "string",
                            "od_vendor_product_number": "string",
                            "upc": "string",
                            "list_price": 0,
                            "unit_cost": 0,
                            "web_availability_code": "string",
                            "department_code": 0,
                            "department_name": "string",
                            "class_code": 0,
                            "class_name": "string",
                            "subclass_code": 0,
                            "subclass_name": "string",
                            "supplier_id": 0,
                            "supplier_name": "string",
                            "product_category_code": "string",
                            "product_category_description": "string",
                            "stripped_supplier_vendor_product_number": "string",
                            "supplier_vendor_product_number": "string",
                            "increment_required_quantity": 0,
                            "min_order_required_quantity": 0,
                            "country_of_origin_code": "string",
                            "is_private_brand": true,
                            "package_units_of_measure": "string",
                            "package_size": 0,
                            "is_hazardous": true,
                            "is_carcinogenic": true,
                            "is_minority_business": true,
                            "drop_ship_code": "string",
                            "is_virtual_warehouse_item": true,
                            "rms_created_date": "2020-01-03",
                            "rms_last_modified_date": "2020-01-03",
                            "rms_last_sale_date": "2020-01-03",
                            "sys_revision": 0,
                            "sys_created_date": "2020-01-03T15:42:56.266Z",
                            "sys_modified_date": "2020-01-03T15:42:56.266Z"
                            }
                        ]
                    }
                ]
            }
        
         */

        @AuraEnabled
        public Integer count;

        @AuraEnabled
        public Integer query_limit;

        @AuraEnabled
        public Integer query_time;

        @AuraEnabled
        public Integer query_offset;

        @AuraEnabled
        public String search_query;

        @AuraEnabled
        public String search_criteria;

        @AuraEnabled
        public List<String> manufacturer_names;

        @AuraEnabled
        public List<String> od_skus;


        @AuraEnabled 
        public List<ProductDetailsResponse> product_list;
        

    }

    public virtual class ProductDetailsResponse {
        @AuraEnabled  public String collection_id;
        @AuraEnabled  public List<String> vendor_product_numbers;
        @AuraEnabled  public List<String> sku_list;
        @AuraEnabled  public List<String> supplier_names;
        @AuraEnabled  public List<String> supplier_vendor_product_numbers;
        @AuraEnabled  public List<String> od_vendor_product_numbers;
        @AuraEnabled  public List<String> manufacturer_ids;
        @AuraEnabled  public List<String> manufacturer_names;
        @AuraEnabled  public List<String> upc_list;
        @AuraEnabled  public String min_supplier_id;
        @AuraEnabled  public String short_description;
        @AuraEnabled  public String item_description;
        @AuraEnabled  public String package_units_of_measure;
        @AuraEnabled  public Decimal package_size;
        @AuraEnabled  public Double min_list_price;
        @AuraEnabled  public Double max_list_price;
        @AuraEnabled  public Double avg_list_price;
        @AuraEnabled  public Double min_unit_cost;
        @AuraEnabled  public Double max_unit_cost;
        @AuraEnabled  public Double avg_unit_cost;
        @AuraEnabled  public Integer sys_revision;
        @AuraEnabled  public DateTime sys_created_date;
        @AuraEnabled  public DateTime sys_modified_date;
        @AuraEnabled  public String search_String;
        @AuraEnabled  public Integer count;
        @AuraEnabled  public List<SupplierResponse> results;

        
        // Singleton Fields
        @AuraEnabled public String manufacturerName;
        @AuraEnabled public String odSkuNumber;
        @AuraEnabled public String listPrice;
        @AuraEnabled public String mfgPartNumber;
        @AuraEnabled public String vendorPartNumber;
        @AuraEnabled public String keyword;
        @AuraEnabled public String itemDescription;
        @AuraEnabled public String supplierCostPOCost;
        @AuraEnabled public String supplierName;
        @AuraEnabled public String price;
        @AuraEnabled public String manufacturer;
        @AuraEnabled public String upcCode;
        @AuraEnabled public String supplierPartNumber;

        public void populate_singleton_fields(){
            this.manufacturerName = (this.manufacturer_names.isEmpty() ? '' : this.manufacturer_names[0]);
            this.odSkuNumber = (this.sku_list.isEmpty() ? '' : this.sku_list[0]);
            this.listPrice = String.valueOf(this.avg_list_price);
            this.mfgPartNumber = (this.od_vendor_product_numbers.isEmpty() ? '' : this.od_vendor_product_numbers[0]);
            this.vendorPartNumber = (this.vendor_product_numbers.isEmpty() ? '' : this.vendor_product_numbers[0]);
            this.keyword = this.search_String;
            this.itemDescription = this.item_description;
            this.supplierCostPOCost = String.valueOf(this.avg_unit_cost);
            this.supplierName = (this.supplier_names.isEmpty() ? '' : this.supplier_names[0]);
            this.price = String.valueOf(this.avg_list_price);
            this.manufacturer = (this.manufacturer_ids.isEmpty() ? '' : this.manufacturer_ids[0]);
            this.upcCode = (this.upc_list.isEmpty() ? '' : this.upc_list[0]);
            this.supplierPartNumber = (this.supplier_vendor_product_numbers.isEmpty() ? '' : this.supplier_vendor_product_numbers[0]);
        }
    }

    
    public class SupplierResponse {
        @AuraEnabled
        public String collection_id;
        @AuraEnabled
        public String sku;
        @AuraEnabled
        public String ea_vendor_product_number;
        @AuraEnabled
        public String catalog;
        @AuraEnabled
        public String short_description;
        @AuraEnabled
        public String item_description;
        @AuraEnabled
        public String item_number_type;
        @AuraEnabled
        public String manufacturer_id;
        @AuraEnabled
        public String manufacturer_name;
        @AuraEnabled
        public String stripped_od_vendor_product_number;
        @AuraEnabled
        public String od_vendor_product_number;
        @AuraEnabled
        public String upc;
        @AuraEnabled
        public Double list_price;
        @AuraEnabled
        public Double unit_cost;
        @AuraEnabled
        public String web_availability_code;
        @AuraEnabled
        public String department_code;
        @AuraEnabled
        public String department_name;
        @AuraEnabled
        public Integer class_code;
        @AuraEnabled
        public String class_name;
        @AuraEnabled
        public Integer subclass_code;
        @AuraEnabled
        public String subclass_name;
        @AuraEnabled
        public Integer supplier_id;
        @AuraEnabled
        public String supplier_name;
        @AuraEnabled
        public String product_category_code;
        @AuraEnabled
        public String product_category_description;
        @AuraEnabled
        public String stripped_supplier_vendor_product_number;
        @AuraEnabled
        public String supplier_vendor_product_number;
        @AuraEnabled
        public Integer increment_required_quantity;
        @AuraEnabled
        public Integer min_order_required_quantity;
        @AuraEnabled
        public String country_of_origin_code;
        @AuraEnabled
        public Boolean is_private_brand;
        @AuraEnabled
        public String package_units_of_measure;
        @AuraEnabled
        public Decimal package_size;
        @AuraEnabled
        public Boolean is_hazardous;
        @AuraEnabled
        public Boolean is_carcinogenic;
        @AuraEnabled
        public Boolean is_minority_business;
        @AuraEnabled
        public String drop_ship_code;
        @AuraEnabled
        public Boolean is_virtual_warehouse_item;
        @AuraEnabled
        public Date rms_created_date;
        @AuraEnabled
        public Date rms_last_modified_date;
        @AuraEnabled
        public Integer sys_revision;
        @AuraEnabled
        public Datetime sys_created_date;
        @AuraEnabled
        public Datetime sys_modified_date;


        // Singleton_fields
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String Supplier;
        @AuraEnabled
        public String Description;
        @AuraEnabled
        public String SupplierPart;
        @AuraEnabled
        public Double Cost;
        @AuraEnabled
        public Double CustomerPrice;
        @AuraEnabled
        public Double AdjustedPrice;
        @AuraEnabled
        public Integer Quantity;
        @AuraEnabled
        public Integer Percentage;

        public void populate_singletons(){
            this.Id = String.valueOf(this.supplier_id);
            this.Supplier = String.valueOf(this.supplier_name);
            this.Description = this.item_description;
            this.SupplierPart = this.supplier_vendor_product_number;
            this.Cost = this.unit_cost;
            this.CustomerPrice = this.list_price;
            this.AdjustedPrice = this.unit_cost;
            this.Quantity = 1;
            this.Percentage = 0;
        }
    }
    public class TokenResponse {
        @AuraEnabled  public String access_token;
        @AuraEnabled  public String token_type;
    }
}