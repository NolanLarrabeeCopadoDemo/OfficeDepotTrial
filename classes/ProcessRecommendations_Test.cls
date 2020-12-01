@isTest
private class ProcessRecommendations_Test {
    @isTest
    static void getRecommendations() {
        Test.setMock(HttpCalloutMock.class, new ProcessRecommendationsMock('getRecommendations'));
        Test.startTest();

        ProcessRecommendations.getAllRecommendations();
        Test.stopTest();
    }
    
    @isTest
    static void processRecommendations() {
        Test.setMock(HttpCalloutMock.class, new ProcessRecommendationsMock('processRecommendations'));
        Test.startTest();
		String PayLoad = '[{"reference_id":"1","recommendation_id":"1","competitor_product_id": "6330757", "competitor_description": "dell - precision 2-in-1 15.6", "competitor_uom": "bx", "customer_qpu": 1, "competitor_usage": 1, "competitor_price":1 , "xref_type": "Functional", "od_sku": "2703976", "od_sku_description": "dell™ xps 15 9570 laptop", "od_sku_uom": " 15.6", "od_sku_vpn": " 8th gen intel® core™ i7", "od_sku_mfg": " 16gb memory", "status":"1" }]';
        ProcessRecommendations.processRecommendations(PayLoad);
        Test.stopTest();
    }
    
    
     private static testMethod void testWrapper(){
     
      ProcessRecommendations.Recommendation record1 = new ProcessRecommendations.Recommendation(); 
        
        	record1.reference_id = '1';
         	record1.recommendation_id = '1';
            record1.competitor_product_id = 'Test';
            record1.competitor_description = 'test';
            record1.competitor_uom = 'Test';
            record1.customer_qpu = '12';
            record1.competitor_usage = '12';
            record1.competitor_price = '12';
            record1.xref_type = 'xrefType';
            record1.od_sku = 'OdSku';
            record1.od_sku_description = 'ODSkuDesc';
            record1.od_sku_uom = 'ODSkuUom';
            record1.od_sku_vpn = 'ODSkuVpn';
            record1.od_sku_mfg = 'ODSkuMFG';
            record1.status = 'rec';
         
         
         
        
        
        
        
        
     }
}