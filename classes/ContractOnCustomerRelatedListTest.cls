// Appirio 2016
// 
// NBOCK - Original - S-377000 - needed code coverage
@isTest
private class ContractOnCustomerRelatedListTest {
	
	static testMethod void testContractOnCustomer() {
		//create test data
		Id uId = UserInfo.getUserId();

		Account gpAcc = Test_Utils.createAccount('Customer');
		insert gpAcc;

		Account pAcc = Test_Utils.createAccount('Customer');
		pAcc.ParentId = gpAcc.Id;
		insert pAcc;

		Account acc = Test_Utils.createAccount('Prospect');
		acc.ParentId = pAcc.Id;
		insert acc;

		Customer_Transition__c transition = Test_Utils.CreateCustomerTransaction(true, acc);

		Contract con = new Contract();
		con.AccountId = acc.Id;
		con.Account = acc;
		con.Contract_Development_Negotiation_MGR__c = uId;
		con.Contract_Lifecycle_Manager__c = uId;
		con.Contract_Type__c = 'ALL PRODUCTS';
		insert con;

		Test.startTest();
			PageReference pageRef = new PageReference(transition.Id);
			Test.setCurrentPage(pageRef);
		        
	    	ApexPages.standardController controller = new ApexPages.StandardController(transition);
	        ContractOnCustomerRelatedList ext = new ContractOnCustomerRelatedList(controller);

	        ext.getWrapperList();
	        ext.setWrapperList();

	        pageRef.getParameters().put('selectedRecord', con.Id);
	        ext.deleteContractItem();

        Test.stopTest();

        //verify contract deletion
        List<Contract> delCon = new List<Contract>([SELECT Id FROM Contract WHERE AccountId = :acc.Id]);
        System.assert(delCon.isEmpty());
	}
}