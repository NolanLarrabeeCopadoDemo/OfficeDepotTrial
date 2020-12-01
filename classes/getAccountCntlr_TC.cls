//
// (c) Appirio Inc. 2015
//
//
// Author    Joe Norman    August 5th, 2015
//
// Test class
//
//
@isTest
private class getAccountCntlr_TC {

	static testMethod void test_odpID() {
			
			//Get Test Records
	        User user = Test_Utils.getTestUser('System Administrator','aaab@officedepot.com','227112');
        system.runas(user){
			Account acc = Test_Utils.getTestAccount(user,'9999999');
			String Id = acc.Id;
			String shortId = Id.substring(0,15);

			//Set Page
			PageReference pageRef = Page.GetAccount;
			Test.setCurrentPage(pageRef);

			// Add parameters to page URL
			ApexPages.currentPage().getParameters().put('odpid', acc.AOPS_Cust_Id__c);

			//Instantiate Controller and Call Page Ref
			GetAccountCntlr controller = new GetAccountCntlr();
			String forward = controller.frwd().getUrl();

			//Assert
			system.assertEquals('/'+shortID,forward);

        }

	}

	static testMethod void test_omxID() {
			
			//Get Test Records
	        User user = Test_Utils.getTestUser('System Administrator','aaab@officedepot.com','227112');
        system.runAs(user){
        Account acc = Test_Utils.getTestAccount(user,'9999999');
			String Id = acc.Id;
			String shortId = Id.substring(0,15);

			//Set Page
			PageReference pageRef = Page.GetAccount;
			Test.setCurrentPage(pageRef);

			// Add parameters to page URL
			ApexPages.currentPage().getParameters().put('omxid', acc.AOPS_Cust_Id__c);

			//Instantiate Controller and Call Page Ref
			GetAccountCntlr controller = new GetAccountCntlr();
			String forward = controller.frwd().getUrl();

			//Assert
			system.assertEquals('/'+shortID,forward);
        }
			

	}



}