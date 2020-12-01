/*
 * Created by Adam on 8/8/2018.
 *
 * @description This class is used to make an external request to the aggro for the token
 *
 * @group Aggro
 *
 * @group-content /ApexDocContent/Index.htm
 */
@IsTest
public with sharing class AggroService_Test {
	@IsTest
	static void checkAggroServiceHealth() {
		Test.setMock(HttpCalloutMock.class, new AggroService_Mock());
		test.startTest();
		System.debug(AggroService.checkAggroServiceHealth());
		test.stopTest();
	}

	@IsTest
	static void checkAggroService_getAccountsWithToken() {
		Test.setMock(HttpCalloutMock.class, new AggroService_Mock());
		test.startTest();
		System.debug(AggroService.getAccountsWithToken('Office Depot', '6600 N Military Trl', '', 'Boca Raton', 'FL',
				'33496'));
		test.stopTest();
	}

	@IsTest
	static void checkAggroService_getSiteAndUltimate() {
		Test.setMock(HttpCalloutMock.class, new AggroService_Mock());
		test.startTest();
		System.debug(AggroService.getSiteAndUltimate('079829711'));
		test.stopTest();
	}

	@IsTest
	static void checkAggroService_getAlternateLinkage() {
		Test.setMock(HttpCalloutMock.class, new AggroService_Mock());
		test.startTest();
		System.debug(AggroService.getAlternateLinkage('079829711'));
		test.stopTest();
	}

    @IsTest
    static void aggroSearchV2TestGoodResponse() {
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/search/dnb/', '{"test": "test"}');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/search/dnb/', 200);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        String response;
        
        Test.startTest();
        response = AggroService.aggroSearchV2('name', 'street', 'city', 'state', 'zip');
        Test.stopTest();
        
        System.assertEquals('{"test": "test"}', response);
    }
    
    @IsTest
    static void aggroSearchV2TestBadResponse() {
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/search/dnb/', '{"test": "test"}');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/search/dnb/', 400);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        String response;
        
        Test.startTest();
        response = AggroService.aggroSearchV2('name', 'street', 'city', 'state', 'zip');
        Test.stopTest();
        
        System.assertEquals(null, response);
    }
    
    @isTest
    static void aggroAccountSearchTestGoodResponse() {
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/search/account/', '[{"test": "test"}]');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/search/account/', 200);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        String response;
        
        Test.startTest();
        response = AggroService.aggroAccountSearch('name', 'street', 'city', 'state', 'zip');
        Test.stopTest();
        
        System.assertEquals('[{"test": "test"}]', response);
    }
    
    @isTest
    static void aggroAccountSearchTestBadResponse() {
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/search/account/', '[{"test": "test"}]');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/search/account/', 400);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        String response;
        
        Test.startTest();
        response = AggroService.aggroAccountSearch('name', 'street', 'city', 'state', 'zip');
        Test.stopTest();
        
        System.assertEquals(null, response);
    }
    
    @isTest
    static void aggroBulkSearchV2FutureTestGoodResponse() {
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/bulk/', '[{"test": "test"}]');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/bulk/', 200);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        Test.startTest();
        AggroService.aggroBulkSearchV2('{"test": "test"}');
        Test.stopTest();
        
        // No response body to test.
    }
    
    @isTest
    static void aggroBulkSearchV2FutureTestBadResponse() {
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/bulk/', '[{"test": "test"}]');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/bulk/', 400);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        Test.startTest();
        AggroService.aggroBulkSearchV2('{"test": "test"}');
        Test.stopTest();
        
        // No response body to test.
    }
    
    @isTest
    static void aggroBulkSearchSyncV2TestGoodResponse() {
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/search/multi/', '[{"test": "test"}]');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/search/multi/', 200);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        String response;
        
        Test.startTest();
        response = AggroService.aggroBulkSearchSyncV2('[{"test": "test"}]');
        Test.stopTest();
        
        System.assertEquals('[{"test": "test"}]', response);
    }
    
    @isTest
    static void aggroBulkSearchSyncV2TestBadResponse() {
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/search/multi/', '[{"test": "test"}]');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/search/multi/', 400);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        Boolean exceptionThrown = false;
        
        Test.startTest();
        try {
        	String response = AggroService.aggroBulkSearchSyncV2('[{"test": "test"}]');
        } catch(Exception ex) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown);
    }
    
    @isTest
    static void postUpdatedAccountsTest() {
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/ingest/salesforce/', '[{"test": "test"}]');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/ingest/salesforce/', 200);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        List<Account> accnts = MyUtilsDataFactory.makeAccounts(2);
        insert accnts;
        
        Test.startTest();
        AggroService.postUpdatedAccounts(new Set<Id> { accnts[0].Id, accnts[1].Id });
        Test.stopTest();
        
        // Nothing to test.
    }
    
    @isTest
    static void postUpdatedLeadsTest() {
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/ingest/salesforce/', '[{"test": "test"}]');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/ingest/salesforce/', 200);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        List<Lead> lds = MyUtilsDataFactory.makeLeads(1);
        insert lds;
        
        Test.startTest();
        AggroService.postUpdatedLeads(new Set<Id> { lds[0].Id });
        Test.stopTest();
        
        // Nothing to test.
    }
    
    @isTest
    static void aggroBulkFileSyncTestGoodResponse() {
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/file/', '[{"test": "test"}]');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/file/', 200);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        String response;
        
        Test.startTest();
        response = AggroService.aggroBulkFileSync('test');
        Test.stopTest();
        
        System.assertEquals('[{"test": "test"}]', response);
    }
    
    @isTest
    static void aggroBulkFileSyncTestBadResponse() {
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/file/', '[{"test": "test"}]');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/file/', 400);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        Boolean exceptionThrown = false;
        
        Test.startTest();
        try {
        	String response = AggroService.aggroBulkFileSync('test');
        } catch(Exception ex) {
            exceptionThrown = true;
        }
        Test.stopTest();
        
        System.assertEquals(true, exceptionThrown);
    }
}