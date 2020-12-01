@IsTest
public with sharing class ACECustomersSummary_Test
{
	@TestSetup
	static void makeData()
	{
		Profile fieldSalesProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Field Sales'];

		User user1 = new User
					 (
						 Alias = 'blabla1', Email = 'blabla1@officedepot.com',
						 EmailEncodingKey = 'UTF-8', LastName = 'blabla1', LanguageLocaleKey = 'en_US',
						 LocaleSidKey = 'en_US', ProfileId = fieldSalesProfile.Id,
						 TimeZoneSidKey = 'America/Los_Angeles', UserName = 'blabla1@officedepot.com'
					 );
		insert user1;

		User user2 = new User
					 (
						 Alias = 'blabla2', Email = 'blabla2@officedepot.com',
						 EmailEncodingKey = 'UTF-8', LastName = 'blabla2', LanguageLocaleKey = 'en_US',
						 LocaleSidKey = 'en_US', ProfileId = fieldSalesProfile.Id,
						 TimeZoneSidKey = 'America/Los_Angeles', UserName = 'blabla2@officedepot.com',
						 ManagerId = user1.Id
					 );
		insert user2;

		Account a1 = new Account
					 (
						 Name = 'blablaaccount1',
						 OwnerId = user1.Id
					 );
		insert a1;

		ACE_Settings__c aceSettings = new ACE_Settings__c
		(
			BatchName__c = 'Q4-2014',
			Trigger_By_Pass__c = String.valueOf(UserInfo.getUserId())
		);
		insert aceSettings;

		ACE_Customer_Price_Changes__c cpc1 = new ACE_Customer_Price_Changes__c
											 (
												 Name = 'Q2-2020',
												 SFDC_Notification_Flag__c = '1',
												 Customer__c = a1.Id,
												 Owning_Customer_ID__c = a1.Id,
												 Total_Spend_Impact_12_Month__c = 2382,
												 Item_12_Month_Sales__c = 23,
												 Item_12_Month_Qty__c = 1,
												 SRM_Differential__c = 928,
												 Customer_Notification_Date_Approved__c = Date.newInstance(2020, 8, 10),
												 Sales_Price_Change_Effective_Date_Min__c = Date.newInstance(2020, 8, 10)
											 );
		insert cpc1;

		ACE_Customer_Price_Changes__c cpc2 = new ACE_Customer_Price_Changes__c
											 (
												 Name = 'Q2-2020',
												 SFDC_Notification_Flag__c = '2',
												 Customer__c = a1.Id,
												 Owning_Customer_ID__c = a1.Id,
												 Total_Spend_Impact_12_Month__c = 2382,
												 Item_12_Month_Sales__c = 23,
												 Item_12_Month_Qty__c = 1,
												 SRM_Differential__c = 928,
												 Customer_Notification_Date_Approved__c = Date.newInstance(2020, 8, 10),
												 Sales_Price_Change_Effective_Date_Min__c = Date.newInstance(2020, 8, 10)
											 );
		insert cpc2;

		ACE_Customer_Price_Changes__c cpc3 = new ACE_Customer_Price_Changes__c
											 (
												 Name = 'Q2-2020',
												 SFDC_Notification_Flag__c = '3',
												 Customer__c = a1.Id,
												 Owning_Customer_ID__c = a1.Id,
												 Item_12_Month_Sales__c = 23,
												 Item_12_Month_Qty__c = 1,
												 SRM_Differential__c = 928,
												 Customer_Notification_Date_Approved__c = Date.newInstance(2020, 8, 10),
												 Sales_Price_Change_Effective_Date_Min__c = Date.newInstance(2020, 8, 10)
											 );
		insert cpc3;
	}

	@IsTest
	public static void testGetSubordinatesSuccess()
	{
		User u = [SELECT Id FROM User WHERE LastName = 'blabla1'];

		Test.startTest();
		List<User> subordinates = ACECustomersSummary.getSubordinates(u);
		Test.stopTest();

		System.assertEquals(1, subordinates.size());
	}

	@IsTest
	public static void testGetIdsFromUsersSuccess()
	{
		User u1 = [SELECT Id FROM User WHERE LastName = 'blabla1'];
		List<User> users = new List<User> { u1 };

		Test.startTest();
		Set<Id> userIds = ACECustomersSummary.getIdsFromUsers(users);
		Test.stopTest();

		List<Id> userIdsList = new List<Id>(userIds);
		System.assertEquals(u1.Id, userIdsList.get(0));
	}

	@IsTest
	public static void testGetCurrentUserSuborindatesSuccess()
	{
		User u1 = [SELECT Id FROM User WHERE LastName = 'blabla1'];
		List<User> subordinates = new List<User>();

		Test.startTest();
		System.runAs(u1)
		{
			subordinates = ACECustomersSummary.getCurrentUserSubordinates();
		}
		Test.stopTest();

		System.assertEquals(1, subordinates.size());
	}

	@IsTest
	public static void testGetCustomerPriceChangesSuccess()
	{
		User u1 = [SELECT Id FROM User WHERE LastName = 'blabla1'];
		final String batch = 'Q2-2020';
		final String notificationFlag = '1';
		Set<Id> userIds = new Set<Id> { u1.Id };

		Test.startTest();
		List<ACE_Customer_Price_Changes__c> customerPriceChanges = ACECustomersSummary.getCustomerPriceChanges(batch, notificationFlag, userIds);
		Test.stopTest();

		System.assertEquals(1, customerPriceChanges.size());
	}

	@IsTest
	public static void testGetCustomerPriceChangesOwnedByMyTeam()
	{
		User u1 = [SELECT Id FROM User WHERE LastName = 'blabla1'];
		final String batch = 'Q2-2020';
		final String notificationFlag = '1';
		List<ACE_Customer_Price_Changes__c> customerPriceChanges = new List<ACE_Customer_Price_Changes__c>();

		Test.startTest();
		System.runAs(u1)
		{
			Set<Id> userIds = ACECustomersSummary.getUserIdsBasedOnOwnership('ownedByMyTeam');
			customerPriceChanges = ACECustomersSummary.getCustomerPriceChanges(batch, notificationFlag, userIds);
		}
		Test.stopTest();

		System.assertEquals(0, customerPriceChanges.size());
	}

	@IsTest
	public static void testGetCustomerPriceChangesOwnedByMe()
	{
		User u1 = [SELECT Id FROM User WHERE LastName = 'blabla1'];
		final String batch = 'Q2-2020';
		final String notificationFlag = '1';
		List<ACE_Customer_Price_Changes__c> customerPriceChanges = new List<ACE_Customer_Price_Changes__c>();

		Test.startTest();
		System.runAs(u1)
		{
			Set<Id> userIds = ACECustomersSummary.getUserIdsBasedOnOwnership('ownedByMe');
			customerPriceChanges = ACECustomersSummary.getCustomerPriceChanges(batch, notificationFlag, userIds);
		}
		Test.stopTest();

		System.assertEquals(1, customerPriceChanges.size());
	}

	@IsTest
	public static void testGetCustomerPriceChangesAll()
	{
		User u1 = [SELECT Id FROM User WHERE LastName = 'blabla1'];
		final String batch = 'Q2-2020';
		final String notificationFlag = '1';
		List<ACE_Customer_Price_Changes__c> customerPriceChanges = new List<ACE_Customer_Price_Changes__c>();

		Test.startTest();
		System.runAs(u1)
		{
			Set<Id> userIds = ACECustomersSummary.getUserIdsBasedOnOwnership('all');
			customerPriceChanges = ACECustomersSummary.getCustomerPriceChanges(batch, notificationFlag, userIds);
		}
		Test.stopTest();

		System.assertEquals(1, customerPriceChanges.size());
	}

	@IsTest
	public static void testGetCustomerPriceChangesFailure()
	{
		User u2 = [SELECT Id FROM User WHERE LastName = 'blabla2'];

		final String batch = 'Q2-2020';
		final String notificationFlag = '1';
		Set<Id> userIds = new Set<Id> { u2.Id };

		Test.startTest();
		List<ACE_Customer_Price_Changes__c> customerPriceChanges = ACECustomersSummary.getCustomerPriceChanges(batch, notificationFlag, userIds);
		Test.stopTest();

		System.assertEquals(0, customerPriceChanges.size());
	}

	@IsTest
	public static void testGetUserIdsBasedOnOwnershipOwnedByMe()
	{
		User u1 = [SELECT Id FROM User WHERE LastName = 'blabla1'];
		Set<Id> userIds = new Set<Id>();

		Test.startTest();
		System.runAs(u1)
		{
			userIds = ACECustomersSummary.getUserIdsBasedOnOwnership('ownedByMe');
		}
		Test.stopTest();

		System.assertEquals(1, userIds.size());
	}

	@IsTest
	public static void testGetUserIdsBasedOnOwnershipAll()
	{
		User u1 = [SELECT Id FROM User WHERE LastName = 'blabla1'];
		Set<Id> userIds = new Set<Id>();

		Test.startTest();
		System.runAs(u1)
		{
			userIds = ACECustomersSummary.getUserIdsBasedOnOwnership('all');
		}
		Test.stopTest();

		System.assertEquals(2, userIds.size());
	}

	@IsTest
	public static void testGetUserIdsBasedOnOwnershipOwnedByMyTeam()
	{
		User u1 = [SELECT Id FROM User WHERE LastName = 'blabla1'];
		Set<Id> userIds = new Set<Id>();

		Test.startTest();
		System.runAs(u1)
		{
			userIds = ACECustomersSummary.getUserIdsBasedOnOwnership('ownedByMyTeam');
		}
		Test.stopTest();

		System.assertEquals(1, userIds.size());
	}

	@IsTest
	public static void testFormatCustomerPriceChanges()
	{
		User u1 = [SELECT Id FROM User WHERE LastName = 'blabla1'];
		final String batch = 'Q2-2020';
		final String notificationFlag = '1';
		Set<Id> userIds = new Set<Id> { u1.Id };
		List<ACE_Customer_Price_Changes__c> customerPriceChanges = ACECustomersSummary.getCustomerPriceChanges(batch, notificationFlag, userIds);

		Test.startTest();
		List<ACECustomersSummary.ACECustomer> formattedPriceChanges = ACECustomersSummary.formatCustomerPriceChanges(customerPriceChanges);
		Test.stopTest();

		ACECustomersSummary.ACECustomer formattedPriceChange = (ACECustomersSummary.ACECustomer) formattedPriceChanges.get(0);
		System.assertEquals('blabla1', formattedPriceChange.repName);
		System.assertEquals(928, formattedPriceChange.totalSrmImpact);
	}

	@IsTest
	public static void testGetCustomersApprovalRequired()
	{
		User u1 = [SELECT Id, Name FROM User WHERE LastName = 'blabla1'];
		final String batch = 'Q2-2020';
		final String ownership = 'all';
		List<ACECustomersSummary.ACECustomer> formattedPriceChanges = new List<ACECustomersSummary.ACECustomer>();

		Test.startTest();
		System.runAs(u1)
		{
			String jsonResponse = ACECustomersSummary.getCustomersApprovalRequired(batch, ownership);
			formattedPriceChanges = (List<ACECustomersSummary.ACECustomer>) JSON.deserialize(jsonResponse, List<ACECustomersSummary.ACECustomer>.class);
		}
		Test.stopTest();

		System.assertEquals(1, formattedPriceChanges.size());
		System.assertEquals(u1.Name, ((ACECustomersSummary.ACECustomer) formattedPriceChanges.get(0)).repName);
	}

	@IsTest
	public static void testGetCustomersNotificationRequired()
	{
		User u1 = [SELECT Id, Name FROM User WHERE LastName = 'blabla1'];
		final String batch = 'Q2-2020';
		final String ownership = 'all';
		List<ACECustomersSummary.ACECustomer> formattedPriceChanges = new List<ACECustomersSummary.ACECustomer>();

		Test.startTest();
		System.runAs(u1)
		{
			String jsonResponse = ACECustomersSummary.getCustomersNotificationRequired(batch, ownership);
			formattedPriceChanges = (List<ACECustomersSummary.ACECustomer>) JSON.deserialize(jsonResponse, List<ACECustomersSummary.ACECustomer>.class);
		}
		Test.stopTest();

		System.assertEquals(1, formattedPriceChanges.size());
		System.assertEquals(u1.Name, ((ACECustomersSummary.ACECustomer) formattedPriceChanges.get(0)).repName);
	}

	@IsTest
	public static void testGetCustomersNoRequirements()
	{
		User u1 = [SELECT Id, Name FROM User WHERE LastName = 'blabla1'];
		final String batch = 'Q2-2020';
		final String ownership = 'all';
		List<ACECustomersSummary.ACECustomer> formattedPriceChanges = new List<ACECustomersSummary.ACECustomer>();

		Test.startTest();
		System.runAs(u1)
		{
			String jsonResponse = ACECustomersSummary.getCustomersNoRequirements(batch, ownership);
			formattedPriceChanges = (List<ACECustomersSummary.ACECustomer>) JSON.deserialize(jsonResponse, List<ACECustomersSummary.ACECustomer>.class);
		}
		Test.stopTest();

		System.assertEquals(1, formattedPriceChanges.size());
		System.assertEquals(u1.Name, ((ACECustomersSummary.ACECustomer) formattedPriceChanges.get(0)).repName);
	}

	@IsTest
	public static void testGetCustomersApprovalRequiredSummary()
	{
		ACECustomersSummary.getCustomersApprovalRequiredSummary('Q2-2018', 'all');
	}

	@IsTest
	public static void testGetCustomersNotificationRequiredSummary()
	{
		ACECustomersSummary.getCustomersNotificationRequiredSummary('Q2-2018', 'all');
	}

	@IsTest
	public static void testGetCustomersNoRequirementsSummary()
	{
		ACECustomersSummary.getCustomersNoRequirementsSummary('Q2-2018', 'all');
	}
}