@isTest
public with sharing class Delegate_Approver_Batch_TC
{
    @TestSetup
    public static void makeData()
    {
    	Profile system_administrator_profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        // This user represents the person that submits a Delegate Approver request
		User original_approver = new User(
            Username 			= 'original_approver@officedepot.com',
        	FirstName 			= 'Original Approver',
            LastName 			= 'Original Approver',
            Email 				= 'original_approver@officedepot.com',
            Alias		 		= 'origapp',
            LocaleSidKey 		= 'en_US',
            LanguageLocaleKey 	= 'en_US',
            TimeZoneSidKey 		= 'America/Los_Angeles',
            ProfileId 			= system_administrator_profile.Id
        );
        insert original_approver;
        
        // This user represensts the delegate approver
		User delegated_approver = new User(
            Username 			= 'delegated_approver@officedepot.com',
        	FirstName 			= 'Delegated Approver',
            LastName 			= 'Delegated Approver',
            Email 				= 'delegated_approver@officedepot.com',
            Alias 				= 'deleapp',
            LocaleSidKey 		= 'en_US',
            LanguageLocaleKey 	= 'en_US',
            TimeZoneSidKey 		= 'America/Los_Angeles',
            ProfileId 			= system_administrator_profile.Id
        );
        insert delegated_approver;
    }
    
    /*
    * This method will test a Delegate Approver Request that was Submitted
    * and Approved and should start today.
	*/
    @isTest
    public static void test_submitted_approved_start_today()
    {
        User original_approver  = [SELECT Id, DelegatedApproverId
                                   FROM User
                                   WHERE FirstName = 'Original Approver'];
        User delegated_approver = [SELECT Id
                                   FROM User
                                   WHERE FirstName = 'Delegated Approver'];
        
        Delegate_Approver_Request__c request = new Delegate_Approver_Request__c(
            User__c 				= original_approver.Id,
            Delegate_Approver__c 	= delegated_approver.Id,
            Status__c 				= 'Submitted',
            Approved__c				= true,
            Start_Date__c 			= Date.today(),
            End_Date__c 			= Date.today().addDays(1)
        );
        insert request;
        
        Test.startTest();
        	Delegate_Approver_Batch batch = new Delegate_Approver_Batch();
        	Database.executeBatch(batch);
        Test.stopTest();
        
        Delegate_Approver_Request__c result = [SELECT Id, Status__c
                                               FROM Delegate_Approver_Request__c
                                               WHERE Id = :request.Id];
        
        // We have to query for the user again because the value of
        // DelegatedApproverId should have changed
        original_approver  = [SELECT Id, DelegatedApproverId
                              FROM User
                              WHERE FirstName = 'Original Approver'];
        
        System.assert(result.Status__c == 'Started');
        System.assert(original_approver.DelegatedApproverId == delegated_approver.Id);
    }
    
    /*
    * This method will test multiple Delegate Approver Requests that were
    * Submitted by the same user and Approved and should start today.
	*/
    @isTest
    public static void test_same_user_miltiple_submitted_approved_start_today()
    {
        User original_approver  = [SELECT Id, DelegatedApproverId
                                   FROM User
                                   WHERE FirstName = 'Original Approver'];
        User delegated_approver = [SELECT Id
                                   FROM User
                                   WHERE FirstName = 'Delegated Approver'];
        
        Delegate_Approver_Request__c request1 = new Delegate_Approver_Request__c(
            User__c 				= original_approver.Id,
            Delegate_Approver__c 	= delegated_approver.Id,
            Status__c 				= 'Submitted',
            Approved__c				= true,
            Start_Date__c 			= Date.today().addDays(-3),
            End_Date__c 			= Date.today().addDays(1)
        );
        insert request1;
        
        Delegate_Approver_Request__c request2 = new Delegate_Approver_Request__c(
            User__c 				= original_approver.Id,
            Delegate_Approver__c 	= delegated_approver.Id,
            Status__c 				= 'Submitted',
            Approved__c				= true,
            Start_Date__c 			= Date.today(),
            End_Date__c 			= Date.today().addDays(1)
        );
        insert request2;
        
        Test.startTest();
        	Delegate_Approver_Batch batch = new Delegate_Approver_Batch();
        	Database.executeBatch(batch);
        Test.stopTest();
        
        Delegate_Approver_Request__c result1 = [SELECT Id, Status__c
                                               FROM Delegate_Approver_Request__c
                                               WHERE Id = :request1.Id];
        
        // We have to query for the user again because the value of
        // DelegatedApproverId should have changed
        original_approver  = [SELECT Id, DelegatedApproverId
                              FROM User
                              WHERE FirstName = 'Original Approver'];
        
        System.assert(result1.Status__c == 'Started');
        System.assert(original_approver.DelegatedApproverId == delegated_approver.Id);
        
        Delegate_Approver_Request__c result2 = [SELECT Id, Status__c
                                               FROM Delegate_Approver_Request__c
                                               WHERE Id = :request2.Id];
        
        // We have to query for the user again because the value of
        // DelegatedApproverId should have changed
        original_approver  = [SELECT Id, DelegatedApproverId
                              FROM User
                              WHERE FirstName = 'Original Approver'];
        
        System.assert(result2.Status__c == 'Started');
        System.assert(original_approver.DelegatedApproverId == delegated_approver.Id);
    }
    
    /*
    * This method will test a Delegate Approver Request that was Submitted
    * and Approved, but should start tomorrow.
    */
    @isTest
    public static void test_submitted_approved_start_tomorrow()
    {
        User original_approver  = [SELECT Id, DelegatedApproverId
                                   FROM User
                                   WHERE FirstName = 'Original Approver'];
        User delegated_approver = [SELECT Id
                                   FROM User
                                   WHERE FirstName = 'Delegated Approver'];
        
        Delegate_Approver_Request__c request = new Delegate_Approver_Request__c(
            User__c 				= original_approver.Id,
            Delegate_Approver__c 	= delegated_approver.Id,
            Status__c 				= 'Submitted',
            Approved__c				= true,
            Start_Date__c 			= Date.today().addDays(1),
            End_Date__c 			= Date.today().addDays(1)
        );
        insert request;
        
        Test.startTest();
        	Delegate_Approver_Batch batch = new Delegate_Approver_Batch();
        	Database.executeBatch(batch);
        Test.stopTest();
        
        Delegate_Approver_Request__c result = [SELECT Id, Status__c
                                               FROM Delegate_Approver_Request__c
                                               WHERE Id = :request.Id];
        
        // We have to query for the user again because the value of
        // DelegatedApproverId should have changed
        original_approver  = [SELECT Id, DelegatedApproverId
                              FROM User
                              WHERE FirstName = 'Original Approver'];
        
        System.assert(result.Status__c == 'Submitted');
        System.assert(original_approver.DelegatedApproverId == null);
    }
    
    /*
    * This method will test a Delegate Approver Request that was Submitted
    * and Approved, and should have been started yesterday.
    * This is basically testing the scenario where: if this job fails, will
    * it catch up on requests once it runs successfully?
	*/
    @isTest
    public static void test_submitted_approved_start_yesterday()
    {
        User original_approver  = [SELECT Id, DelegatedApproverId
                                   FROM User
                                   WHERE FirstName = 'Original Approver'];
        User delegated_approver = [SELECT Id
                                   FROM User
                                   WHERE FirstName = 'Delegated Approver'];
        
        Delegate_Approver_Request__c request = new Delegate_Approver_Request__c(
            User__c 				= original_approver.Id,
            Delegate_Approver__c 	= delegated_approver.Id,
            Status__c 				= 'Submitted',
            Approved__c				= true,
            Start_Date__c 			= Date.today().addDays(-1),
            End_Date__c 			= Date.today().addDays(1)
        );
        insert request;
        
        Test.startTest();
        	Delegate_Approver_Batch batch = new Delegate_Approver_Batch();
        	Database.executeBatch(batch);
        Test.stopTest();
        
        Delegate_Approver_Request__c result = [SELECT Id, Status__c
                                               FROM Delegate_Approver_Request__c
                                               WHERE Id = :request.Id];
        
        // We have to query for the user again because the value of
        // DelegatedApproverId should have changed
        original_approver  = [SELECT Id, DelegatedApproverId
                              FROM User
                              WHERE FirstName = 'Original Approver'];
        
        System.assert(result.Status__c == 'Started');
        System.assert(original_approver.DelegatedApproverId == delegated_approver.Id);
    }
    
    /*
    * This method will test a Delegate Approver Request that was Submitted
    * and Approved and should have started previously, but should end now.
    * This is basically testing the scenario where: if this job fails, will it end
    * requests that were never started but should have already ended?
	*/
    @isTest
    public static void test_submitted_approved_start_yesterday_end_today()
    {
        User original_approver  = [SELECT Id, DelegatedApproverId
                                   FROM User
                                   WHERE FirstName = 'Original Approver'];
        User delegated_approver = [SELECT Id
                                   FROM User
                                   WHERE FirstName = 'Delegated Approver'];
        
        Delegate_Approver_Request__c request = new Delegate_Approver_Request__c(
            User__c 				= original_approver.Id,
            Delegate_Approver__c 	= delegated_approver.Id,
            Status__c 				= 'Submitted',
            Approved__c				= true,
            Start_Date__c 			= Date.today().addDays(-2),
            End_Date__c 			= Date.today().addDays(-1)
        );
        insert request;
        
        Test.startTest();
        	Delegate_Approver_Batch batch = new Delegate_Approver_Batch();
        	Database.executeBatch(batch);
        Test.stopTest();
        
        Delegate_Approver_Request__c result = [SELECT Id, Status__c
                                               FROM Delegate_Approver_Request__c
                                               WHERE Id = :request.Id];
        
        // We have to query for the user again because the value of
        // DelegatedApproverId should have changed
        original_approver  = [SELECT Id, DelegatedApproverId
                              FROM User
                              WHERE FirstName = 'Original Approver'];
        
        System.assert(result.Status__c == 'Ended');
        System.assert(original_approver.DelegatedApproverId == null);
    }
    
    /*
    * This method will test a Delegate Approver Request that was Submitted
    * and Approved and started, and should end now.
	*/
    @isTest
    public static void test_submitted_approved_started_yesterday_end_today()
    {
        User original_approver  = [SELECT Id, DelegatedApproverId
                                   FROM User
                                   WHERE FirstName = 'Original Approver'];
        User delegated_approver = [SELECT Id
                                   FROM User
                                   WHERE FirstName = 'Delegated Approver'];
        
        Delegate_Approver_Request__c request = new Delegate_Approver_Request__c(
            User__c 				= original_approver.Id,
            Delegate_Approver__c 	= delegated_approver.Id,
            Status__c 				= 'Submitted',
            Approved__c				= true,
            Start_Date__c 			= Date.today().addDays(-2),
            End_Date__c 			= Date.today().addDays(-1)
        );
        insert request;
        
        Test.startTest();
        	Delegate_Approver_Batch batch = new Delegate_Approver_Batch();
        	Database.executeBatch(batch);
        Test.stopTest();
        
        Delegate_Approver_Request__c result = [SELECT Id, Status__c
                                               FROM Delegate_Approver_Request__c
                                               WHERE Id = :request.Id];
        
        // We have to query for the user again because the value of
        // DelegatedApproverId should have changed
        original_approver  = [SELECT Id, DelegatedApproverId
                              FROM User
                              WHERE FirstName = 'Original Approver'];
        
        System.assert(result.Status__c == 'Ended');
        System.assert(original_approver.DelegatedApproverId == null);
    }
    
    /* 
    * This method will test a Delegate Approver Request that was Submitted
    * and NOT approved.
    */
    @isTest
    public static void test_submitted_and_not_approved()
    {
        User original_approver  = [SELECT Id, DelegatedApproverId
                                   FROM User
                                   WHERE FirstName = 'Original Approver'];
        User delegated_approver = [SELECT Id
                                   FROM User
                                   WHERE FirstName = 'Delegated Approver'];
        
        Delegate_Approver_Request__c request = new Delegate_Approver_Request__c(
            User__c 				= original_approver.Id,
            Delegate_Approver__c 	= delegated_approver.Id,
            Status__c 				= 'Submitted',
            Approved__c				= false,
            Start_Date__c 			= Date.today(),
            End_Date__c 			= Date.today().addDays(1)
        );
        insert request;
        
        Test.startTest();
        	Delegate_Approver_Batch batch = new Delegate_Approver_Batch();
        	Database.executeBatch(batch);
        Test.stopTest();
        
        Delegate_Approver_Request__c result = [SELECT Id, Status__c
                                               FROM Delegate_Approver_Request__c
                                               WHERE Id = :request.Id];
        
        // We have to query for the user again because the value of
        // DelegatedApproverId should have changed
        original_approver  = [SELECT Id, DelegatedApproverId
                              FROM User
                              WHERE FirstName = 'Original Approver'];
        
        System.assert(result.Status__c == 'Submitted');
        System.assert(original_approver.DelegatedApproverId == null);
    }
}