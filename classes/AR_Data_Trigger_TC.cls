@isTest
private class AR_Data_Trigger_TC {

	private static testMethod void test() {
	    Account a = Test_Utils.createAccount('Customer');
	    insert a;
	    
        A_R_Data__c ar = new A_R_Data__c(Account__c=a.Id);
        insert ar;
	}

}