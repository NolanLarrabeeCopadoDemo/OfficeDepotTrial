/*
 * Created by Adam on 9/3/2018.
* @group Avention
* @group-content /ApexDocContent/Index.htm
*
* @description This class is used to make an external request to the avention service
*/
@IsTest
public with sharing class AventionService_Test {
	@IsTest
	static void coverageSearchAvention(){
		Test.setMock(HttpCalloutMock.class, new AventionService_Mock());
		Test.startTest();
			System.debug(AventionService.searchAvention('Office Depot', '6600 N Military Trl', '', 'Boca Raton', 'FL', '33496'));
		Test.stopTest();
	}

	@IsTest
	static void coverageCompanySearchRequest(){
		Test.setMock(HttpCalloutMock.class, new AventionService_Mock());
		Test.startTest();
			System.debug(AventionService.companySearchRequest('d0da30db-a720-3754-9f67-fc77a4d38744'));
		Test.stopTest();
	}

}