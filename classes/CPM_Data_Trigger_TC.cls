@isTest
private class CPM_Data_Trigger_TC {

	private static testMethod void test() {
	    Account a = Test_Utils.createAccount('Customer');
	    insert a;
	    
        CPM_Data__c cpm = new CPM_Data__c(Account_name__c = a.Id);
        insert cpm;
	}

}