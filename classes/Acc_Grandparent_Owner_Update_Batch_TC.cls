// Test Preconditions: Grandparent accounts must exist in the database that have invalid sales people associated with them.

@isTest()
public class Acc_Grandparent_Owner_Update_Batch_TC {

    static List<Account> accs = new List<Account>();
	static List<String> AccountIDs = new List<String>();

	public static void CreateTestRecords() {

		Profile p = [select id from Profile where name='System Administrator' limit 1];

		User usr = new User(
				TimeZoneSidKey='America/Los_Angeles',
				ProfileId = p.id,
				Username='Tman@officedepot.com',
				LastName='LasTester',
				Email='Tman@officedepot.com',
				Alias='TMan',
				CommunityNickname='CommNikTest',
				LocaleSidKey='en_US',
				LanguageLocaleKey='en_US',
				EmailEncodingKey='UTF-8',
				OD_Employee_ID__c='653466');
		insert(usr);

		// We creat four sales persons associated with the account the user. We assign an invalid salesperson to the Account.
		Sales_Person__c validSP = new Sales_Person__c(isActive__c=true, Primary__c=true, Name='Valid', User__c = usr.id);
		Sales_Person__c inValidSP = new Sales_Person__c(isActive__c=false, Primary__c=true, Name='InValid', User__c = usr.id);
		Sales_Person__c unValidSP = new Sales_Person__c(isActive__c=false, Primary__c=false, Name='UnValid', User__c = usr.id);
		Sales_Person__c nonValidSP = new Sales_Person__c(isActive__c=true, Primary__c=false, Name='nonValid', User__c = usr.id);

		upsert (validSP);
		upsert (inValidSP);
		upsert (unValidSP);
		upsert (nonValidSP);

       RecordType rec = [SELECT Id, DeveloperName FROM RecordType WHERE DeveloperName='GrandParent' and isactive=true];

		// Create our test Account
		Account testAccount = new Account(name='Im A Test_1', RecordTypeId=rec.Id, OwnerId = usr.Id, Sales_PersonID__c = inValidSP.id);

		upsert (testAccount);
	}

	/*	Test Description:
	    This test verifies that incorrect accounts with invalid sales people
	    associated with them are fixed after the batch runs.
	*/
    static testMethod void UpdateSalesPersonTest() {

		// Initialize our batch job.
      	Acc_Grandparent_Owner_Update_Batch Acc_Grandparent_Owner_Update_Obj = new Acc_Grandparent_Owner_Update_Batch();
		
		// Create our test data.
		CreateTestRecords();
		// Select the test accoun we created in our test data.
		Account TestAccount = [SELECT Id, Sales_PersonID__r.IsActive__c, Sales_PersonID__r.Primary__c FROM Account WHERE Name='Im A Test_1' LIMIT 1];

		// Make sure the test data we created has the issue we want the batch job to fix.
		System.assert (!(TestAccount.Sales_PersonID__r.IsActive__c && TestAccount.Sales_PersonID__r.Primary__c),
						'Account pretest failed for ' + TestAccount.Id);
		
		// Execute the batch operation. Test.startTest(); and the Test.StopTest(); ensure that 
      	// all async operations are completed before going onwards.
      	Test.startTest();
      	ID batchprocessid_1 = Database.executeBatch(Acc_Grandparent_Owner_Update_Obj);
		// Do all Async Stuff inbetween the Test.startTest(); and the Test.StopTest();
        Test.stopTest();
		
		// Get our test account and make sure it now has a valid sales person associated with it.
		TestAccount = [SELECT Id, Sales_PersonID__r.IsActive__c, Sales_PersonID__r.Primary__c FROM Account WHERE Name='Im A Test_1' LIMIT 1];
		System.assert (TestAccount.Sales_PersonID__r.IsActive__c, 'Account ' + TestAccount.Id + ' assert IsActive failed.');
		System.assert (TestAccount.Sales_PersonID__r.Primary__c, 'Account ' + TestAccount.Id + ' assert Primary failed.');

    }    
}