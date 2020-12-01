@isTest()
public class LeadEnrichmentController_TC  {
    
    static testMethod void retrieveDBDataTest() {
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/search/dnb/', 
                            '[{"duns_no":52715540,"business_name":"Walgreen Co.","secondary_name":"Walgreens","second_trade_name":"Walgreens 10791","street_addr":"10110 Lyons Rd","street_addr2":null,"city":"Boynton Beach","state":"FL","postal_cd":"334734701","zip_code":"33473","longitude":-80.1884,"latitude":26.5263,"global_ultimate_duns":"079608595","global_ultimate_business_name":"Walgreens Boots Alliance, Inc.","ultimate_duns":"079608595","ultimate_name":"Walgreens Boots Alliance, Inc.","telephone_nbr":"5618801523","ceo_first_name":"Terry","ceo_last_name":"Collins","ceo_title":"President","subsidiary_ind":0,"small_business_ind":"N","minority_bus_ind":"N","public_private_ind":"N","parent_duns":null,"hqtr_duns":"008965063","hqtr_business_name":"Walgreen Co.","hierarchy_cd":"02","total_family_mem":15478,"lob":"Drug stores and proprietary stores","global_ultimate_duns_num":"79608595","site_employee_cnt":7,"global_ultimate_employee_cnt":34500,"employee_reliability_cd":4,"site_sales_amt":2381050.0,"global_ultimate_sales_amt":1182140000.0,"sales_reliability_cd":4,"du_us87sic3dig_cd":591,"gu_us87sic3dig_cd":591,"s23_companyname":"W42C00","s33_companyname":"W42C00000","zip":"33473","companykey_23":"334W42C00","companykey_33":"334W42C00000","datasource":"DNB","companykey_13":"334W42","score":0.635}]'
                             );
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/search/dnb/', 200);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        Lead ld = new Lead(LastName='ld1', Company='ld1', Zip__c='12345');
        insert ld;
        List < Org__c > result;
        Test.startTest();
        result = LeadEnrichmentController.retrieveDBData((String) ld.Id);
        Test.stopTest();
    }
    
    
}