@isTest
private class LeadDuplicateCheck_TC {
    
    static testMethod void noDuplicatesFound() {
        Map<String, String> responseMapping = new Map<String, String>();
        Aggro_Service__mdt aggro_service_token = [SELECT Aggro_Access_Token__c, Aggro_Service_URL__c FROM Aggro_Service__mdt WHERE DeveloperName='Service_Details'];
        responseMapping.put(aggro_service_token.Aggro_Service_URL__c + '/lookup/search/account/', '[]');
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping));
        
        Lead ld = new Lead(LastName='test', Company='test', Zip__c='11111');
        insert ld;
        List<Lead>leadList = new List<Lead>();
        leadList.add(ld);
        List<Id> leadIds = new List<Id> { ld.Id };
        
        Test.startTest();
        leadAllHelperMeths.funcDuplicateCheck(leadList );
        leadAllHelperMeths.setDupFlagIfNecessary(leadIds);
        
        Test.stopTest();
        
        ld = [SELECT Id, Potential_Duplicate__c FROM Lead WHERE Id =: ld.Id];
        System.assertEquals(false, ld.Potential_Duplicate__c);
    }
    
    static testMethod void duplicatesFound() {
        List<Account> accnts = MyUtilsDataFactory.makeAccounts(1);
        insert accnts;
        
        Map<String, String> responseMapping = new Map<String, String>();
        Aggro_Service__mdt aggro_service_token = [SELECT Aggro_Access_Token__c, Aggro_Service_URL__c FROM Aggro_Service__mdt WHERE DeveloperName='Service_Details'];
        responseMapping.put(aggro_service_token.Aggro_Service_URL__c + '/lookup/search/account/', '[{"id":"' + accnts[0].Id + '"}]');
        Test.setMock(HttpCalloutMock.class, new AggroService_Mock(responseMapping));
        
        Lead ld = new Lead(LastName='test', Company='test', Zip__c='11111');
        insert ld;
        List<Id> leadIds = new List<Id> { ld.Id };
        
        Test.startTest();
        leadAllHelperMeths.setDupFlagIfNecessary(leadIds);
        Test.stopTest();
        
        ld = [SELECT Id, Potential_Duplicate__c FROM Lead WHERE Id =: ld.Id];
        System.assertEquals(true, ld.Potential_Duplicate__c);
    }
    
    static testMethod void legacyDuplicateGAndT() {
        RecordType canadaRecordType = [SELECT Id FROM RecordType WHERE Name='Lead (Canada)' LIMIT 1];
        Lead ld = new Lead(FirstName='aaa', LastName='aaa', Company='aaa', Phone='1111111111', Email='aaa@aaa.com', Zip__c='11111', State__c='AA', RecordTypeId=canadaRecordType.Id);
        insert ld;
        Contact ct = new Contact(FirstName='bbb', LastName='bbb', Phone='2222222222', Email='bbb@bbb.com');
        insert ct;
        List<Account> accnts = MyUtilsDataFactory.makeAccounts(1);
        accnts[0].Name = 'ccc';
        accnts[0].Zip__c = '33333';
        accnts[0].State__c = 'CC';
        
        insert accnts;

        System.debug(accnts);
        
        List<Lead> lds = new List<Lead>();
        // Is a potential duplicate of the Lead.
        Lead test1 = new Lead(FirstName='ddd', LastName='ddd', Company='aaa', Phone='4444444444', Email='ddd@ddd.com', Zip__c='11111', State__c='DD', RecordTypeId=canadaRecordType.Id);
        lds.add(test1);
        // Is a potential duplicate of the Contact.
        Lead test2 = new Lead(FirstName='eee', LastName='bbb', Company='eee', Phone='2222222222', Email='eee@eee.com', Zip__c='55555', State__c='EE', RecordTypeId=canadaRecordType.Id);
        lds.add(test2);
        // Is a potential duplicate of the Account.
        Lead test3 = new Lead(FirstName='fff', LastName='fff', Company='ccc', Phone='6666666666', Email='fff@fff.com', Zip__c='66666', State__c='CC', RecordTypeId=canadaRecordType.Id);
        lds.add(test3);
        // Is not a potential duplicate.
        Lead test4 = new Lead(FirstName='ggg', LastName='ggg', Company='ggg', Phone='7777777777', Email='ggg@ggg.com', Zip__c='77777', State__c='GG', RecordTypeId=canadaRecordType.Id);
        lds.add(test4);
        
        Test.startTest();
        insert lds;
        System.debug(lds);
       
        Test.stopTest();
        
        test1 = [SELECT Id, Potential_Duplicate__c FROM Lead WHERE Id =: test1.Id];
        System.assertEquals(true, test1.Potential_Duplicate__c);
        
        test2 = [SELECT Id, Potential_Duplicate__c FROM Lead WHERE Id =: test2.Id];
        System.assertEquals(true, test2.Potential_Duplicate__c);
        
        test3 = [SELECT Id, Potential_Duplicate__c FROM Lead WHERE Id =: test3.Id];
        System.assertEquals(true, test3.Potential_Duplicate__c);
        
        test4 = [SELECT Id, Potential_Duplicate__c FROM Lead WHERE Id =: test4.Id];
        System.assertEquals(false, test4.Potential_Duplicate__c);
    }
}