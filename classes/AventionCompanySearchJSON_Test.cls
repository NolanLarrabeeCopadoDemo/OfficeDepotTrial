/*
 * Created by Adam on 8/8/2018.
* @group Avention
* @group-content /ApexDocContent/Index.htm
*
* @description This class is used to test request pasring for the avention service
*/

@IsTest
public with sharing class AventionCompanySearchJSON_Test {
	public static String json = '{"size":1,"consumedCredits":0,"consumedBusinessContactCredits":0,"resultType":"company","result":[{"resultType":"company","id":"d0da30db-a720-3754-9f67-fc77a4d38744","keyId":21436,"companyName":"Office Depot, Inc.","primaryUrl":"http://www.officedepot.com","sales":1.024E10,"salesUsd":1.024E10,"salesEur":9.0698965E9,"salesGbp":7.9485015E9,"numEmployees":45000,"directMarketingStatus":"Has Not Opted Out of Direct Marketing","addresses":[{"addressType":"primary","city":"Boca Raton","state":{"id":"852a32f3-8afc-3e51-924f-132f42cc2de8","name":"Florida","abbreviation":"FL"},"country":{"id":"8f8578d9-7195-3d4d-a85f-65eadf168209","name":"United States","iso2":"US"}}],"primaryIndustry":{"id":"aaa58c95-f182-3d68-9a93-7aec72ff7164","shortDescription":"Miscellaneous Store Retailers"},"entityType":{"id":"b36a3fb2-660c-3d07-a365-2c5740f91db5","name":"Parent"},"ownershipType":{"id":"ad198725-c924-3c6c-86ec-788baeb5ad1d","name":"Public"},"matchDetails":{"matchScore":100,"nameMatchQuality":"STRICT","nameMatchConfidence":978,"addressMatchQuality":"STRICT","addressMatchConfidence":9880}}]}';

	static testMethod void testParse() {
		AventionCompanySearchJSON obj = AventionCompanySearchJSON.parse(json);
		System.assert(obj != null);
	}

	static testMethod void testBadParse() {
		AventionCompanySearchJSON obj = AventionCompanySearchJSON.parse('{balajkshjsjska:"""""""');
		System.assert(obj == null);
	}
}