/*
 * @description This class is used to manage application licences for users.
 * @author Adam
 * @datecreated 2018-10-23 11:19:46.322851
 *
 * @changes Log any modifications here...
 */
@isTest(SeeAllData=false)
private class SeismicLicenseManagementBatch_Test {


	static PackageLicense seismicPL = [SELECT Id, NamespacePrefix, AllowedLicenses, UsedLicenses, 
							 ExpirationDate,Status FROM PackageLicense WHERE 
							 NamespacePrefix = 'seismic'];
	/*
	 * @description This method sets up the test data for testing license allocation. 10 Users are generated and any details specific to a test situation 
	 * are added prior to test start.
	 * @author Adam Albright
	 * @datecreated 2018-10-23
	 *
	 * @changes Log any modifications here...
	 */
	@testSetup
	static void setup() {
	
		List<User> myTestUsers = MyUtilsDataFactory.makeUsers(10);
		
		List<UserPackageLicense> user_package_list = [SELECT Id, PackageLicenseId, UserId,  CreatedDate FROM UserPackageLicense WHERE PackageLicenseId=:seismicPL.Id];

		Delete user_package_list;
		try{
			Insert myTestUsers;
		} catch (DmlException e){
			System.debug(LoggingLevel.ERROR, 'Error at line: ' + e.getLineNumber());
			System.debug(LoggingLevel.ERROR, 'Error Message: ' + e.getMessage());
			System.debug(LoggingLevel.ERROR, 'Stack Trace: ' + e.getStackTraceString());
		}


		user_package_list = [SELECT Id, PackageLicenseId, UserId,  CreatedDate FROM UserPackageLicense WHERE PackageLicenseId=:seismicPL.Id];
		myTestUsers = [SELECT Id, IsSeismicUser__c, CreatedDate, IsActive, Alias FROM User WHERE Alias='tuserfct'];

		System.assert(user_package_list.size() == 0, 'User Packages Not Set Up Correctly, Got ' + user_package_list.size() + ', Expected ' + 0);
		System.assert(myTestUsers.size() == 10, 'User Not Set Up Correctly, Got ' + myTestUsers.size() + ', Expected 10');
	}

	/*
	 * @description This method tests to determin if new users are allocated a license when they are flagged. The Flag being used is IsSeismicUser__c
	 * @author Adam Albright
	 * @datecreated 2018-10-23
	 *
	 * @changes Log any modifications here...
	 */
	@isTest
	static void addNewLicenseFlag() {

		List<User> myUsers = [SELECT Id, IsSeismicUser__c, CreatedDate, IsActive, Alias FROM User WHERE Alias='tuserfct'];
		List<UserPackageLicense> seismicPackages = [SELECT Id, PackageLicenseId, UserId,  CreatedDate FROM UserPackageLicense WHERE PackageLicenseId=:seismicPL.Id];
		Set<Id> userIds = new Set<Id>();
		Integer userCount = myUsers.size();
		Integer seismicPackageCount = seismicPackages.size();

		System.debug(LoggingLevel.DEBUG, 'Initial User Count is ' + userCount);
		System.debug(LoggingLevel.DEBUG, 'Initial License Count is ' + seismicPackageCount);

		for(User myUsr: myUsers){
			userIds.add(myUsr.Id);
		}

		// Adding two Seismic Users
		myUsers[0].IsSeismicUser__c = true;
		myUsers[1].IsSeismicUser__c = true;

		Update myUsers;
		
		//Run Your Tests Here
		Test.startTest();
		SeismicLicenseInsertBatch obj = new SeismicLicenseInsertBatch();
		DataBase.executeBatch(obj); 
		Test.stopTest();

		// Performs your assertions here
		seismicPackages = [SELECT Id, PackageLicenseId, UserId,  CreatedDate
		FROM UserPackageLicense 
		WHERE PackageLicenseId=:seismicPL.Id AND UserId IN :userIds]; 

		System.assert(seismicPackages.size() == 2, 'User Package number incorrect. Got ' + seismicPackages.size() + ', Expected ' + 2);
	}

	/*
	 * @description This method tests to ensure that is a user that was flagged to have a seismic license is no longer flagged, the license is removed. 
	 * @author Adam Albright
	 * @datecreated 2018-10-23
	 *
	 * @changes Log any modifications here...
	 */
	@isTest
	static void removeLicenseFlag() {
		List<User> myUsers = [SELECT Id, IsSeismicUser__c, CreatedDate, IsActive, Alias FROM User WHERE Alias='tuserfct'];
		List<UserPackageLicense> seismicPackages = new List<UserPackageLicense>();
		Set<Id> userIds = new Set<Id>();
		// Get Id Set
		for(User myUsr: myUsers){
			userIds.add(myUsr.Id);
		}

		//Allocate two Licenses and make one of the users Inactive. Make sure one license is present at the end.
		myUsers[0].IsSeismicUser__c = true;
		myUsers[0].IsActive = false;
		myUsers[1].IsSeismicUser__c = true;
		Update myUsers;

		seismicPackages.add(new UserPackageLicense(PackageLicenseId=seismicPL.Id, UserId=myUsers[0].Id));
		seismicPackages.add(new UserPackageLicense(PackageLicenseId=seismicPL.Id, UserId=myUsers[1].Id));

		Insert seismicPackages;
		
		seismicPackages = [SELECT Id, UserId FROM UserPackageLicense WHERE UserId = :myUsers[0].Id OR UserId = :myUsers[1].Id];

		System.debug(LoggingLevel.INFO, 'Seismic Licenses ' + seismicPackages);

		//Run Your Tests Here
		Test.startTest();
		SeismicLicenseDeleteBatch obj = new SeismicLicenseDeleteBatch();
		DataBase.executeBatch(obj); 
		Test.stopTest();

		// Performs your assertions here

		List<UserPackageLicense> user_package_list = [SELECT Id, PackageLicenseId, UserId,  CreatedDate
		FROM UserPackageLicense 
		WHERE PackageLicenseId=:seismicPL.Id AND UserId IN :userIds]; 

		
		System.assert(user_package_list.size() == 1, 'User Package number incorrect. Got ' + user_package_list.size() + ', Expected ' + 1);
	}


	/*
	 * @description This method tests to ensure that a deactivated user nolonger has a license after the batch job runs. 
	 * @author Adam Albright
	 * @datecreated 2018-10-23
	 *
	 * @changes Log any modifications here...
	 */
	@isTest
	static void removeDeactivatedUser() {
		List<User> myUsers = [SELECT Id, IsSeismicUser__c, CreatedDate, IsActive, Alias FROM User WHERE Alias='tuserfct'];
		List<UserPackageLicense> seismicPackages = new List<UserPackageLicense>();
		Set<Id> userIds = new Set<Id>();
		// Get Id Set
		for(User myUsr: myUsers){
			userIds.add(myUsr.Id);
		}

		//Allocate two Licenses and make one of the users Inactive. Make sure one license is present at the end.
		myUsers[0].IsSeismicUser__c = true;
		myUsers[0].IsActive = false;
		myUsers[1].IsSeismicUser__c = true;

		seismicPackages.add(new UserPackageLicense(PackageLicenseId=seismicPL.Id, UserId=myUsers[0].Id));
		seismicPackages.add(new UserPackageLicense(PackageLicenseId=seismicPL.Id, UserId=myUsers[1].Id));

		Insert seismicPackages;
		Update myUsers;

		Test.startTest();
		//Run Your Tests Here
		SeismicLicenseDeleteBatch obj = new SeismicLicenseDeleteBatch();
		DataBase.executeBatch(obj); 
		Test.stopTest();

		// Performs your assertions here

		List<UserPackageLicense> user_package_list = [SELECT Id, PackageLicenseId, UserId,  CreatedDate
		FROM UserPackageLicense 
		WHERE PackageLicenseId=:seismicPL.Id AND UserId IN :userIds]; 

		
		System.assert(user_package_list.size() == 1, 'User Package number incorrect. Got ' + user_package_list.size() + ', Expected ' + 1);
	}

	/*
	 * @description Tests that users are allocated a license based on their user profiles.
	 * @author Adam Albright
	 * @datecreated 2018-10-23
	 *
	 * @changes Log any modifications here...
	 */
	 
	@isTest
	static void addByUserProfile() {
		List<User> myUsers = [SELECT Id, IsSeismicUser__c, CreatedDate, IsActive, Alias, ProfileId FROM User WHERE Alias='tuserfct'];
		List<UserPackageLicense> seismicPackages = new List<UserPackageLicense>();
		Set<Id> userIds = new Set<Id>();

		// Get Id Set
		for(User myUsr: myUsers){
			userIds.add(myUsr.Id);
		}

		License_Manager__mdt license_profiles = [SELECT User_Profile_API_Names__c FROM License_Manager__mdt WHERE Package_Namespace__c='seismic'];
		List<String> profile_names = new List<String>(license_profiles.User_Profile_API_Names__c.split(','));
		for(Integer i = 0; i < profile_names.size(); i++){
			profile_names[i] = profile_names[i].trim();
		}

		// Assign Some users the profile IDs we want to assign licenses on. 
		Integer x = 0;
		for(Profile prof: [Select Id, Name FROM Profile WHERE Name IN :profile_names]){
			myUsers[x].ProfileId = prof.Id;
			x++;
		}

		Update myUsers;


		Test.startTest();
		//Run Your Tests Here
		SeismicLicenseInsertBatch obj = new SeismicLicenseInsertBatch();
		DataBase.executeBatch(obj); 
		Test.stopTest();

		// Performs your assertions here

		List<UserPackageLicense> user_package_list = [SELECT Id, PackageLicenseId, UserId,  CreatedDate
		FROM UserPackageLicense 
		WHERE PackageLicenseId=:seismicPL.Id AND UserId IN :userIds]; 

		System.debug(LoggingLevel.DEBUG, 'User Package number incorrect. Got ' + user_package_list.size() + ', Expected ' + profile_names.size());

		System.assert(user_package_list.size() == profile_names.size(), 'User Package number incorrect. Got ' + user_package_list.size() + ', Expected ' + profile_names.size());
	}

	/*
	 * @description Tests that the batch still runs correctly when there are no records to insert.
	 * @author Adam Albright
	 * @datecreated 2018-10-23
	 *
	 * @changes Log any modifications here...
	 */
	 
	@isTest
	static void testForNoInserts() {
		List<User> myUsers = [SELECT Id, IsSeismicUser__c, CreatedDate, IsActive, Alias, ProfileId FROM User WHERE Alias='tuserfct'];
		List<UserPackageLicense> seismicPackages = new List<UserPackageLicense>();
		Set<Id> userIds = new Set<Id>();

		// Get Id Set
		for(User myUsr: myUsers){
			userIds.add(myUsr.Id);
		}

		License_Manager__mdt license_profiles = [SELECT User_Profile_API_Names__c FROM License_Manager__mdt WHERE Package_Namespace__c='seismic'];
		List<String> profile_names = new List<String>(license_profiles.User_Profile_API_Names__c.split(','));
		for(Integer i = 0; i < profile_names.size(); i++){
			profile_names[i] = profile_names[i].trim();
		}

		// Assign Some users the profile IDs we want to assign licenses on. 
		Integer x = 0;
		for(Profile prof: [Select Id, Name FROM Profile WHERE Name IN :profile_names]){
			myUsers[x].ProfileId = prof.Id;
			seismicPackages.add(new UserPackageLicense(PackageLicenseId=seismicPL.Id, UserId=myUsers[x].Id));
			x++;
			
		}

		Update myUsers;


		Test.startTest();
		//Run Your Tests Here
		SeismicLicenseInsertBatch obj = new SeismicLicenseInsertBatch();
		DataBase.executeBatch(obj); 
		Test.stopTest();

		// Performs your assertions here

		List<UserPackageLicense> user_package_list = [SELECT Id, PackageLicenseId, UserId,  CreatedDate
		FROM UserPackageLicense 
		WHERE PackageLicenseId=:seismicPL.Id AND UserId IN :userIds]; 

		System.debug(LoggingLevel.DEBUG, 'User Package number incorrect. Got ' + user_package_list.size() + ', Expected ' + profile_names.size());

		System.assert(user_package_list.size() == profile_names.size(), 'User Package number incorrect. Got ' + user_package_list.size() + ', Expected ' + profile_names.size());
	}


	/*
	 * @description Tests that users with the correct profiles are not allocated licenses if they are inactive.
	 * @author Adam Albright
	 * @datecreated 2018-10-23
	 *
	 * @changes Log any modifications here...
	 */
	@isTest
	static void removeInactiveWithUserProfile() {

		List<User> myUsers = [SELECT Id, IsSeismicUser__c, CreatedDate, IsActive, Alias, ProfileId FROM User WHERE Alias='tuserfct'];
		List<UserPackageLicense> seismicPackages = new List<UserPackageLicense>();
		Set<Id> userIds = new Set<Id>();
		// Get Id Set
		for(User myUsr: myUsers){
			userIds.add(myUsr.Id);
		}

		License_Manager__mdt license_profiles = [SELECT User_Profile_API_Names__c FROM License_Manager__mdt WHERE Package_Namespace__c='seismic'];
		List<String> profile_names = new List<String>(license_profiles.User_Profile_API_Names__c.split(','));
		for(Integer i = 0; i < profile_names.size(); i++){
			profile_names[i] = profile_names[i].trim();
		}

		// Assign Some users the profile IDs we want to assign licenses on. Since the users are Inactive, there should be no licenses allocated.
		Integer x = 0;
		// Care must be taken to ensure that there is a user for each profile.
		for(Profile prof: [Select Id, Name FROM Profile WHERE Name IN :profile_names]){
			myUsers[x].ProfileId = prof.Id;
			myUsers[x].IsActive = false;
			seismicPackages.add(new UserPackageLicense(PackageLicenseId=seismicPL.Id, UserId=myUsers[x].Id));
			x++;
		}
		myUsers[0].IsActive = true;

		Insert seismicPackages;

		Update myUsers;

		System.debug(LoggingLevel.DEBUG, 'Users: ' + myUsers);
		System.debug(LoggingLevel.DEBUG, 'Before Packages: ' + seismicPackages);
		System.debug(LoggingLevel.DEBUG, 'Before Count: ' + seismicPackages.size());


		Test.startTest();
		//Run Your Tests Here
		SeismicLicenseDeleteBatch obj = new SeismicLicenseDeleteBatch();
		DataBase.executeBatch(obj); 
		Test.stopTest();

		// Performs your assertions here

		List<UserPackageLicense> user_package_list = [SELECT Id, PackageLicenseId, UserId,  CreatedDate
		FROM UserPackageLicense 
		WHERE PackageLicenseId=:seismicPL.Id AND UserId IN :userIds]; 

		System.debug(LoggingLevel.DEBUG, 'After Packages: ' + user_package_list);
		
		System.debug(LoggingLevel.DEBUG, 'User Package number incorrect. Got ' + user_package_list.size() + ', Expected ' + 1);

		System.assert(user_package_list.size() == 1, 'User Package number incorrect. Got ' + user_package_list.size() + ', Expected ' + 1);
	}

	/*
	 * @description Tests for the case when there are no records to update.
	 * @author Adam Albright
	 * @datecreated 2018-10-23
	 *
	 * @changes Log any modifications here...
	 */
	@isTest
	static void noUsersToDelete() {

		List<User> myUsers = [SELECT Id, IsSeismicUser__c, CreatedDate, IsActive, Alias, ProfileId FROM User WHERE Alias='tuserfct'];
		Set<Id> userIds = new Set<Id>();
		// Get Id Set
		for(User myUsr: myUsers){
			userIds.add(myUsr.Id);
		}

		License_Manager__mdt license_profiles = [SELECT User_Profile_API_Names__c FROM License_Manager__mdt WHERE Package_Namespace__c='seismic'];
		List<String> profile_names = new List<String>(license_profiles.User_Profile_API_Names__c.split(','));
		for(Integer i = 0; i < profile_names.size(); i++){
			profile_names[i] = profile_names[i].trim();
		}

		// Assign Some users the profile IDs we want to assign licenses on. Since the users are Inactive, there should be no licenses allocated.
		Integer x = 0;
		// Care must be taken to ensure that there is a user for each profile.
		for(Profile prof: [Select Id, Name FROM Profile WHERE Name IN :profile_names]){
			myUsers[x].ProfileId = prof.Id;
			myUsers[x].IsActive = false;
			x++;
		}

		Update myUsers;

		System.debug(LoggingLevel.DEBUG, 'Users: ' + myUsers);

		Test.startTest();
		//Run Your Tests Here
		SeismicLicenseDeleteBatch obj = new SeismicLicenseDeleteBatch();
		DataBase.executeBatch(obj); 
		Test.stopTest();

		// Performs your assertions here

		List<UserPackageLicense> user_package_list = [SELECT Id, PackageLicenseId, UserId,  CreatedDate
		FROM UserPackageLicense 
		WHERE PackageLicenseId=:seismicPL.Id AND UserId IN :userIds]; 

		System.debug(LoggingLevel.DEBUG, 'After Packages: ' + user_package_list);

	}

	

	/*
	 * @description Tests Scheduled Insert Job Execution.
	 * @author Adam Albright
	 * @datecreated 2018-11-6
	 *
	 * @changes Log any modifications here...
	 */
	@isTest
	static void test_scheduled_insert_batch(){

		List<User> myUsers = [SELECT Id, IsSeismicUser__c, CreatedDate, IsActive, Alias, ProfileId FROM User WHERE Alias='tuserfct'];
		List<UserPackageLicense> seismicPackages = new List<UserPackageLicense>();
		Set<Id> userIds = new Set<Id>();
		// Get Id Set
		for(User myUsr: myUsers){
			userIds.add(myUsr.Id);
		}

		License_Manager__mdt license_profiles = [SELECT User_Profile_API_Names__c FROM License_Manager__mdt WHERE Package_Namespace__c='seismic'];
		List<String> profile_names = new List<String>(license_profiles.User_Profile_API_Names__c.split(','));
		for(Integer i = 0; i < profile_names.size(); i++){
			profile_names[i] = profile_names[i].trim();
		}

		// Assign Some users the profile IDs we want to assign licenses on. Since the users are Inactive, there should be no licenses allocated.
		Integer x = 0;
		// Care must be taken to ensure that there is a user for each profile. I.e enough test users are generated.
		for(Profile prof: [Select Id, Name FROM Profile WHERE Name IN :profile_names]){
			myUsers[x].ProfileId = prof.Id;
			myUsers[x].IsActive = false;
			x++;
		}
		myUsers[0].IsActive = true;

		Update myUsers;

		System.debug(LoggingLevel.DEBUG, 'Before Packages: ' + seismicPackages);

		Test.startTest();
		// After API Version 40, The job does not get executed in a test unless explicitly called.
		SeismicUserLicenseInsertScheduler.execute(null);
		// Stopping the test will run the job synchronously
		Test.stopTest();

		seismicPackages = [SELECT Id, UserId, PackageLicenseId FROM UserPackageLicense WHERE PackageLicenseId = :seismicPL.Id AND UserId IN :userIds];
		System.assertEquals(1, seismicPackages.size(), 'Job failed to run...');
	}

	/*
	 * @description Tests Scheduled Delete Job Execution.
	 * @author Adam Albright
	 * @datecreated 2018-11-6
	 *
	 * @changes Log any modifications here...
	 */
	@isTest
	static void test_scheduled_delete_batch(){

		List<User> myUsers = [SELECT Id, IsSeismicUser__c, CreatedDate, IsActive, Alias, ProfileId FROM User WHERE Alias='tuserfct'];
		List<UserPackageLicense> seismicPackages = new List<UserPackageLicense>();
		Set<Id> userIds = new Set<Id>();
		// Get Id Set
		for(User myUsr: myUsers){
			userIds.add(myUsr.Id);
		}

		License_Manager__mdt license_profiles = [SELECT User_Profile_API_Names__c FROM License_Manager__mdt WHERE Package_Namespace__c='seismic'];
		List<String> profile_names = new List<String>(license_profiles.User_Profile_API_Names__c.split(','));
		for(Integer i = 0; i < profile_names.size(); i++){
			profile_names[i] = profile_names[i].trim();
		}

		// Assign Some users the profile IDs we want to assign licenses on. Since the users are Inactive, there should be no licenses allocated.
		Integer x = 0;
		// Care must be taken to ensure that there is a user for each profile. I.e enough test users are generated.
		for(Profile prof: [Select Id, Name FROM Profile WHERE Name IN :profile_names]){
			myUsers[x].ProfileId = prof.Id;
			myUsers[x].IsActive = false;
			seismicPackages.add(new UserPackageLicense(PackageLicenseId=seismicPL.Id, UserId=myUsers[x].Id));
			x++;
		}
		myUsers[0].IsActive = true;


		
		Insert seismicPackages;

		Update myUsers;

		System.debug(LoggingLevel.DEBUG, 'Before Packages: ' + seismicPackages);

		Test.startTest();
		// After API Version 40, The job does not get executed in a test unless explicitly called.
		SeismicUserLicenseDeleteScheduler.execute(null);
		// Stopping the test will run the job synchronously
		Test.stopTest();

		seismicPackages = [SELECT Id, UserId, PackageLicenseId FROM UserPackageLicense WHERE PackageLicenseId = :seismicPL.Id AND UserId IN :userIds];
		System.assertEquals(1, seismicPackages.size(), 'Job failed to run...');
	}

}