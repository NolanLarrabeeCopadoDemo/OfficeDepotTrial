@isTest
private class AggroServiceRunner_TC {
    static testMethod void search_for_matchesTest() {
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/search/dnb/', '[{"duns_no": "12345678"}]');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/search/dnb/', 200);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        List<AggroMatchResultV2> results;
        
        Test.startTest();
        results = AggroServiceRunner.search_for_matches('name', 'street', 'city', 'state', 'zip');
        Test.stopTest();
        
        System.assertEquals(1, results.size());
        System.assertEquals('12345678', results[0].duns_no);
    }
    
    static testMethod void json_search_for_matchesTest() {
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/search/dnb/', '[{"duns_no": "12345678"}]');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/search/dnb/', 200);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        String results;
        
        Test.startTest();
        results = AggroServiceRunner.json_search_for_matches('name', 'street', 'city', 'state', 'zip');
        Test.stopTest();
        
        System.assertEquals('[{"duns_no": "12345678"}]', results);
    }
    
    static testMethod void search_for_account_matchesTest() {
        List<Account> accnts = MyUtilsDataFactory.makeAccounts(1);
        insert accnts;
        
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/search/account/', '[{"Id": "' + accnts[0].Id + '"}]');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/search/account/', 200);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        List<Account> matches;
        
        Test.startTest();
        matches = AggroServiceRunner.search_for_account_matches('name', 'street', 'city', 'state', 'zip');
        Test.stopTest();
        
        System.assertEquals(1, matches.size());
        System.assertEquals(accnts[0].Id, matches[0].Id);
    }
    
    static testMethod void json_search_for_account_matchesTest() {
        List<Account> accnts = MyUtilsDataFactory.makeAccounts(1);
        insert accnts;
        
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/search/account/', '[{"Id": "' + accnts[0].Id + '"}]');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/search/account/', 200);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        String results;
        
        Test.startTest();
        results = AggroServiceRunner.json_search_for_account_matches('name', 'street', 'city', 'state', 'zip');
        Test.stopTest();
        
        System.assertEquals('[{"Id": "' + accnts[0].Id + '"}]', results);
    }
    
    static testMethod void getAccountsTest() {
        Id customerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        List<Account> accnts = MyUtilsDataFactory.makeAccounts(3);
        accnts[0].RecordTypeId = customerRecordTypeId;
        accnts[0].State__c = 'CO';
        accnts[1].RecordTypeId = customerRecordTypeId;
        accnts[1].State__c = 'CO';
        insert accnts;
        
        String idList = accnts[0].Id + ',' + accnts[1].Id + ',' + accnts[2].Id;
        
        List<Account> foundAccounts;
        
        Test.startTest();
        foundAccounts = AggroServiceRunner.getAccounts(idList, 'Customer');
        Test.stopTest();
        
        System.assertEquals(2, foundAccounts.size());
        System.assertEquals('CO', foundAccounts[0].State__c);
        System.assertEquals('CO', foundAccounts[1].State__c);
    }
    
    static testMethod void getLeadsTest() {
        Id usRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead (US)').getRecordTypeId();
        Id canadaRecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead (Canada)').getRecordTypeId();
        Lead ld1 = new Lead(LastName='test', Company='test', Zip__c='12345', RecordTypeId=usRecordTypeId);
        insert ld1;
        Lead ld2 = new Lead(LastName='test', Company='test', Zip__c='12345', RecordTypeId=usRecordTypeId);
        insert ld2;
        Lead ld3 = new Lead(LastName='ld3', Company='ld3', Zip__c='12345', RecordTypeId=canadaRecordTypeId);
        insert ld3;
        
        String idList = ld1.Id + ',' + ld2.Id + ',' + ld3.Id;
        
        List<Lead> foundLeads;
        
        Test.startTest();
        foundLeads = AggroServiceRunner.getLeads(idList, 'Lead_US');
        Test.stopTest();
        
        System.assertEquals(2, foundLeads.size());
        System.assertEquals('test', foundLeads[0].Name);
        System.assertEquals('test', foundLeads[1].Name);
    }
    
    static testMethod void full_search_for_matchesTest() {
        Id customerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        List<Account> accnts = MyUtilsDataFactory.makeAccounts(1);
        accnts[0].RecordTypeId = customerRecordTypeId;
        insert accnts;
        
        Map<String, String> responseMapping = new Map<String, String>();
        responseMapping.put('/lookup/search/multi/', '[{"Account_Matches__c": "' + accnts[0].Id + '"}]');
        Map<String, Integer> statusCodeMapping = new Map<String, Integer>();
        statusCodeMapping.put('/lookup/search/multi/', 200);
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping, statusCodeMapping));
        
        Map<String, List<SObject>> results;
        
        Test.startTest();
        results = AggroServiceRunner.full_search_for_matches('name', 'street', 'city', 'state', 'zip');
        Test.stopTest();
        
        System.assertEquals(1, results.get('customers').size());
    }
}