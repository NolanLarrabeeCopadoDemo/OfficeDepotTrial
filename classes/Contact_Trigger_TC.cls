@isTest
private class Contact_Trigger_TC {

	private static testMethod void test() {
	    Account a = Test_Utils.createAccount('Customer');
	    insert a;
	    
        Contact c = new Contact(AccountId=a.Id, Email='test@test.com', FirstName='Test6845126541', LastName='Test89564123648');
        insert c;
	}

}