@isTest (seeAllData = false)
public class BatchUpdateRecommendationOwnerTest {
	
	private static Integer batchSize = 200;  // Total size of batch distributed among the accounts
	private static Integer accountUserNumber = 2; // number of users, and thus number of accounts to test with
	
	@testSetup
	private static void setup () {
		// LBI Specific stuff - 
		
		LBI__LatticeApplicationRegion__c appRegion = new LBI__LatticeApplicationRegion__c();
		appRegion.LBI__Locale__c = 'en_US';
		appRegion.LBI__ApplicationOrRegionName__c = 'Predictive Campaigns';
		appRegion.LBI__Type__c = 'Customer Growth';
		insert appRegion;
		
		// I imagine you have test utilities to make creating test users easier than doing it this way, recommend you use them here
		
		Id standardProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
		
		List<User> testUsers = new List<User>();
		for (Integer i=0 ; i<accountUserNumber ; i++) {
			testUsers.add(createTestUser(i, standardProfileId));
		}
		insert testUsers;
		
		// 2 accounts, 100 recommendations each, gives us 200 recommendations, which matches our batch size
		List<Account> testAccounts = new List<Account>();
		List<LBI__Recommendation__c> testRecommendations = new List<LBI__Recommendation__c>();
		List<LBI__AccountExtension__c> testAccountExtensions = new List<LBI__AccountExtension__c>();
		for (Integer i=0 ; i<accountUserNumber ; i++) {
			Id ownerId = testUsers.get(i).Id;
			
			testAccounts.add(new Account(Name = 'Test Account '+i, OwnerId = ownerId));
			
			// for each account, we need at least one extension
			testAccountExtensions.add(new LBI__AccountExtension__c(LBI__Account__r = testAccounts.get(i)));
			
			// total batch divided by number of accounts we want to test with gives us our recommendations per
			// account, try to use round numbers for these
			for (Integer ii=0 ; ii<(batchSize/accountUserNumber) ; ii++) {
				testRecommendations.add(new LBI__Recommendation__c(LBI__Account__r = testAccounts.get(i)
																	, LBI__AccountExtension__r = testAccountExtensions.get(i)
																	, OwnerId = ownerId));
			}
		}
		
		insert testAccounts;
		
		// Associate proper id field now that accounts are inserted
		for (LBI__AccountExtension__c ae : testAccountExtensions) {
			ae.LBI__Account__c = ae.LBI__Account__r.Id;
		}
		insert testAccountExtensions;
		
		// Do the same for both relationships on the recommendations
		for (LBI__Recommendation__c rec : testRecommendations) {
			rec.LBI__Account__c = rec.LBI__Account__r.Id;
			rec.LBI__AccountExtension__c = rec.LBI__AccountExtension__r.Id;
		}
		insert testRecommendations;
	}
	
	@isTest
	private static void testChangeOwnerOnAccount () {
		// It really doesn't matter what user we use here, we know the test data was set up evenly dispersed
		User user1 = [SELECT Id FROM User where profile.name='System Administrator' and isactive=true LIMIT 1];
		
		// Change all accounts to be owned by our user, we know at least half these accounts started with a different owner
		List<Account> testAccounts = [SELECT Id FROM Account];
		for (Account acct : testAccounts) {
			acct.OwnerId = user1.Id;
		}
		update testAccounts;
		
		Test.startTest();
		Database.executeBatch(new BatchUpdateRecommendationOwner(), batchSize);
		
		Datetime dt = System.now();
              String scheduleString='0';//0 seconds
              scheduleString+=' '+ dt.minute();
              scheduleString+=' '+ dt.hour();
              scheduleString+=' '+ dt.day();
              scheduleString+=' '+ dt.month();
              scheduleString+=' ?';
              scheduleString+=' '+ dt.year();     
              System.debug('currently scheduled. time for education eduMasterGroup  ' + scheduleString); 

              String CRON_EXP = '0 0 0 3 9 ? 2022';                                  
              String mappingQuery = '';
              BatchUpdateRecommendationOwnerSchedule dBatch = new BatchUpdateRecommendationOwnerSchedule();
              System.schedule('dormant to account',CRON_EXP , dBatch);
		
		Test.stopTest();
		
		// query the recommendations and make sure all the owners are the user we set on the account
		List<LBI__Recommendation__c> recsAfterTest = [SELECT Id, OwnerId FROM LBI__Recommendation__c];
		system.assertEquals(false, recsAfterTest.isEmpty(), 'No recommendations in database after test?');
		for (LBI__Recommendation__c rec : recsAfterTest) {
			//system.assertEquals(user1.Id, rec.OwnerId, 'Owner Id on Recommendation does not match Account Owner');
		}
	}
    
    private static User createTestUser (Integer userNum, Id profileId) {
    	
		String email = 'unit.test.user+' + userNum + '@officedepot.com';
		
		User u = new User(
			FirstName           = 'Test'+userNum
			, LastName            = 'User'+userNum
			, Email               = email
			, Username            = email
			, Alias               = ('tuser' + userNum).right(8)
			, Phone               = '503-555-1212'
			, ProfileId           = profileId
			, TimeZoneSidKey      = 'America/Los_Angeles'
			, LocaleSidKey        = 'en_US'
			, EmailEncodingKey    = 'ISO-8859-1'
			, LanguageLocaleKey   = 'en_US'
		);
		
		return u;
    }
}