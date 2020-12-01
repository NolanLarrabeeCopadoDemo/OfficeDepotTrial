//Copyright Appirio @2015
//Created By: Shubham Paboowal ON 13th Oct 2015
//Description :Test Class of InlineAcountHerachy_TestUtilities
//Added for Story S-357929
@isTest
private class InlineAcountHerachy_TestUtilitiesTest {

    static testMethod void testAccountHierarchy() {
		InlineAcountHerachy_TestUtilities testUtils = new InlineAcountHerachy_TestUtilities();
		testUtils.testUserList = new List<User>();
		testUtils.testLeadList = new List<Lead>();
		testUtils.testOppList = new List<Opportunity>();
		testUtils.testConList = new List<Contact>();
		testUtils.testTaskList = new List<Task>();
		
		testUtils.testUser = new User();
		testUtils.testAcc = new Account();
		testUtils.testLead = new Lead();
		testUtils.testOpp = new Opportunity();
		testUtils.testCon = new Contact();
		testUtils.testTask = new Task();
		
		
    	//Set of Fields should be checked
    	Set<String> fieldsToCheck = new Set<String>{'AnnualRevenue', 'BillingCity','BillingCountry','BillingPostalCode','BillingState', 'BillingStreet', 'Description', 'ShippingCity', 'ShippingStreet', 'Name', 'ShippingState', 'ShippingPostalCode', 'ShippingCountry' };
		
		test.startTest();
		//Create my Parent Account 
		testUtils.createAccounts( 1 , fieldsToCheck );
 		testUtils.testAccList[0].Name = 'HierarchyTest0';
 		testUtils.updateAccountList( fieldsToCheck );
 		
 		Account parentAccount = testUtils.testAccList[0];
        Id parentID = parentAccount.Id;
        System.Assert( parentID != null , 'Parent Id not found' );
        
        // Create 10 sub accounts
    	testUtils.createAccounts( 10 , fieldsToCheck );
    	Integer i = 0;
        for ( Account accAux : testUtils.testAccList ){ //Changing names
        	accAux.Name = 'HierarchyTest' + String.valueOf( i );
            i++;
        }
        testUtils.updateAccountList( fieldsToCheck );        
        
        List<Account> accountList = [ Select Id, parentID, name from account where name like 'HierarchyTest%' ORDER BY Name limit 10 ];
                
        for ( Integer x = 0; x < accountList.size(); x++ ){
            if ( accountList[x].name != 'HierarchyTest0' ){
                accountList[x].parentID = parentID;
                parentID = accountList[x].Id; 
            }
        }
        
        testUtils.testAccList.clear();
        testUtils.testAccList.addAll( accountList );
        testUtils.updateAccountList( fieldsToCheck );

		// Create 10 sub accounts
		Account subTreeParent = [ Select id, parentID, name from account where name = 'HierarchyTest4' limit 10 ];
        parentID = subTreeParent.Id;
        testUtils.createAccounts( 10, fieldsToCheck );
    	 
		i = 0;
		for ( Account accAux : testUtils.testAccList ){ //Changing names
        	accAux.Name = 'HierarchyTest' + '4.' + String.valueOf( i );
        }
		testUtils.updateAccountList( fieldsToCheck );

        List<Account> subAccountsList = [ Select Id, parentID, Name from Account where Name like 'HierarchyTest4%' limit 10  ];
        for ( Integer z = 1; z < subAccountsList.size(); z++ ){
            subAccountsList[z].parentID = parentID;
            parentID = accountList[z].Id; 
        }
        
        testUtils.testAccList.clear();
        testUtils.testAccList.addAll( subAccountsList );
        test.stopTest();
    }
}