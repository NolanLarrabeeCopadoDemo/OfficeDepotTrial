@IsTest
private class ConvertLead_TC {
	@IsTest
    static void convertLeadTest() {
        List<Lead> lds = MyUtilsDataFactory.makeLeads(1);
        lds[0].OwnerId = UserInfo.getUserId();
        lds[0].Auto_Assign__c = false;
        insert lds;
        List<Account> accts = MyUtilsDataFactory.makeAccounts(1);
        insert accts;
        List<Contact> cntcts = MyUtilsDataFactory.makeContacts(1);
        cntcts[0].AccountId = accts[0].Id;
        insert cntcts;
        
        List<Id> ids = new List<Id> { lds[0].Id, accts[0].Id, cntcts[0].Id };
        
        Test.startTest();
        ConvertLead.convertLead(new List<List<Id>> { ids });
        Test.stopTest();
    }
}