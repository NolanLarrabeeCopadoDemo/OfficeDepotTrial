@isTest
private class RetrieveCrossMatchResults_Test {
    @isTest
    static void getJSONDataTest() {
        Test.setMock(HttpCalloutMock.class, new RetrieveCrossMatchResultsMock('getResults'));
        Test.startTest();

        RetrieveCrossMatchResults.getJSONData('1','0','FirstPage');
        Test.stopTest();
    }
    
    @isTest
    static void addRecommTest() {
        Test.setMock(HttpCalloutMock.class, new RetrieveCrossMatchResultsMock('addRecomm'));
        Test.startTest();

        RetrieveCrossMatchResults.addRecommendations('1');
        Test.stopTest();
    }
    
    @isTest
    static void getFilteredRecordsDataTest() {
        Test.setMock(HttpCalloutMock.class, new RetrieveCrossMatchResultsMock('getResults'));
        Test.startTest();

        RetrieveCrossMatchResults.getFilteredRecordsData('1','0','FirstPage','All');
        Test.stopTest();
    }
    
    @isTest
    static void getHitRateTest() {
        Test.setMock(HttpCalloutMock.class, new RetrieveCrossMatchResultsMock('hitRate'));
        Test.startTest();

        RetrieveCrossMatchResults.getHitRateData('1');
        Test.stopTest();
    }
    
    @isTest
    static void updateRecommTest() {
        Test.setMock(HttpCalloutMock.class, new RetrieveCrossMatchResultsMock('updateRecomm'));
        Test.startTest();
		String PayLoad = '{"reference_id":"1", "competitor_product_id": "6330757", "competitor_description": "dell - precision 2-in-1 15.6", "competitor_uom": "bx", "customer_qpu": 1, "customer_usage": 1, "competitor_price":1, "competitor_source": "", "xref_type": "Functional", "od_sku": "2703976", "od_sku_description": "dell™ xps 15 9570 laptop", "od_sku_uom": " 15.6", "od_sku_vpn": " 8th gen intel® core™ i7", "od_sku_mfg": " 16gb memory", "Recommendations":"1" }';
        RetrieveCrossMatchResults.updateRecommendations(PayLoad,'1');
        Test.stopTest();
    }
    
    @isTest
    static void getStatusTest() {
        Test.setMock(HttpCalloutMock.class, new RetrieveCrossMatchResultsMock('getStatus'));
        Test.startTest();
		//String PayLoad = '{"reference_id":"1", "competitor_product_id": "6330757", "competitor_description": "dell - precision 2-in-1 15.6", "competitor_uom": "bx", "customer_qpu": 1, "customer_usage": 1, "competitor_price":1, "competitor_source": "", "xref_type": "Functional", "od_sku": "2703976", "od_sku_description": "dell™ xps 15 9570 laptop", "od_sku_uom": " 15.6", "od_sku_vpn": " 8th gen intel® core™ i7", "od_sku_mfg": " 16gb memory", "Recommendations":"1" }';
        RetrieveCrossMatchResults.getStatus('1');
        Test.stopTest();
    }
    
    @isTest
    static void getErrorMessageTest() {
        Test.setMock(HttpCalloutMock.class, new RetrieveCrossMatchResultsMock('getErrorMessage'));
        Test.startTest();
		//String PayLoad = '{"reference_id":"1", "competitor_product_id": "6330757", "competitor_description": "dell - precision 2-in-1 15.6", "competitor_uom": "bx", "customer_qpu": 1, "customer_usage": 1, "competitor_price":1, "competitor_source": "", "xref_type": "Functional", "od_sku": "2703976", "od_sku_description": "dell™ xps 15 9570 laptop", "od_sku_uom": " 15.6", "od_sku_vpn": " 8th gen intel® core™ i7", "od_sku_mfg": " 16gb memory", "Recommendations":"1" }';
        RetrieveCrossMatchResults.getErrorMessages('1');
        Test.stopTest();
    }
    
    @isTest
    private static void testWrapper(){
     
      RetrieveCrossMatchResults.WrapperClass record1 = new RetrieveCrossMatchResults.WrapperClass(); 
        
        	record1.reference_id = 1;
            record1.competitor_product_id = 'Test';
            record1.competitor_description = 'test';
            record1.competitor_uom = 'Test';
            record1.customer_qpu = '12';
            record1.customer_usage = 12;
            record1.competitor_price = 12;
            record1.competitor_source = 'compSource';
            record1.xref_type = 'xrefType';
            record1.od_sku = 'OdSku';
            record1.od_sku_description = 'ODSkuDesc';
            record1.od_sku_uom = 'ODSkuUom';
            record1.od_sku_vpn = 'ODSkuVpn';
            record1.od_sku_mfg = 'ODSkuMFG';
            record1.wtd_net_cost = 0;
            record1.wtd_tdc_cost = 0;
            record1.department_code = 0;
            record1.department_name = 'rec';
            record1.vendor_source = 'rec';
            record1.rownum = 0;
            record1.results_uid = 0;
            record1.sku_availability_flag = 'rec';
            record1.sku_availability_flag_reason = 'rec';
        	record1.stocking_strategy = 'rec';
			record1.od_sku_qpu = 'rec';
            //record1.uom_multiplier = 'rec';
            record1.sys_created_date = 'rec';
            record1.sys_modified_date = 'rec';
        
        RetrieveCrossMatchResults.ControlRecord record2 = new RetrieveCrossMatchResults.ControlRecord(); 
        
        	record2.quote_id = '1';
            record2.file_id = 'Test';
            record2.file_name = 'test';
            record2.file_source = 'Test';
            record2.status = '12';
            record2.created_by_id = '12';
            record2.sys_created_date = '12';
            record2.reference_id = 'xrefNotes';
            record2.resultLink = 'compSource';
            record2.last_update_id = 'xrefType';
            record2.statusLink = 'OdSku';
        
        RetrieveCrossMatchResults.ErrorMessageRecord record3 = new RetrieveCrossMatchResults.ErrorMessageRecord(); 
        
        	record3.reference_id = '1';
            record3.status = 'Test';
            record3.message = 'test';
        
        
        
        
     }
    
    @isTest
    private static void testWrapper1(){
     
      RetrieveCrossMatchResults.RecommendedWrapperClass record1 = new RetrieveCrossMatchResults.RecommendedWrapperClass(); 
        record1.sku_num = 'Test';
        record1.item_desc = 'Test'; 
        record1.corr_uom = 'Test';
        record1.mfg_vpn = 'Test';
        record1.corr_qpu = 0;
        record1.orig_item = 'Test';
        record1.recommendations = 'Test';
        	
        
        
        
        
     }
}