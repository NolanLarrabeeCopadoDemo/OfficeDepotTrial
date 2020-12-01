@IsTest
private class SearchCustomerInformation_TC {
	@IsTest
    static void searchCustInformationTest() {
        DNB_API_Setting__c dnbApiSetting = new DNB_API_Setting__c();
        dnbApiSetting.Name = 'DNB API Value';
        dnbApiSetting.ConsumerKey__c = 'test';
        dnbApiSetting.ConsumerSecret__c = 'test';
        dnbApiSetting.Timestamp__c = '2020-04-17 10:38:51';
        dnbApiSetting.AuthAPI__c = 'https://plus.dnb.com/v2/token';
        dnbApiSetting.AccessToken__c = 'test';
        dnbApiSetting.SearchAPI__c = 'https://plus.dnb.com/v1/search/criteria';
        insert dnbApiSetting;
        List<Account> accts = MyUtilsDataFactory.makeAccounts(1);
        accts[0].Address1__c = '111 Test St.';
        accts[0].Address2__c = 'Apt 111';
        accts[0].City__c = 'Boca Raton';
        accts[0].State__c = 'FL';
        accts[0].Zip__c = '11111';
        insert accts;
        
        Test.startTest();
        SearchCustomerInformation.searchCustInformation(new List<List<Account>> { accts });
        Test.stopTest();
    }
}