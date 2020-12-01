@IsTest
public with sharing class ACECustomerPriceChangesTrigger_Test
{
	@TestSetup
	static void makeData()
	{
		Profile systemAdminProfile = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];

		User user1 = new User();
		user1.Alias = 'blabla1';
		user1.Email = 'blabla1@officedepot.com';
		user1.EmailEncodingKey = 'UTF-8';
		user1.LastName = 'blabla1';
		user1.LanguageLocaleKey = 'en_US';
		user1.LocaleSidKey = 'en_US';
		user1.ProfileId = systemAdminProfile.Id;
		user1.TimeZoneSidKey = 'America/Los_Angeles';
		user1.UserName = 'blabla1@officedepot.com';
		insert user1;

		User user2 = new User();
		user2.Alias = 'blabla2';
		user2.Email = 'blabla2@officedepot.com';
		user2.EmailEncodingKey = 'UTF-8';
		user2.LastName = 'blabla2';
		user2.LanguageLocaleKey = 'en_US';
		user2.LocaleSidKey = 'en_US';
		user2.ProfileId = systemAdminProfile.Id;
		user2.TimeZoneSidKey = 'America/Los_Angeles';
		user2.UserName = 'blabla2@officedepot.com';
		insert user2;

		Account a1 = new Account();
		a1.Name = 'blablaaccount1';
		a1.OwnerId = user1.Id;
		insert a1;

		ACE_Customer_Price_Changes__c acpc1 = new ACE_Customer_Price_Changes__c();
		acpc1.Customer__c = a1.Id;
		acpc1.Owning_Customer_ID__c = a1.id;
		acpc1.SFDC_Notification_Flag__c = '3';
		acpc1.Customer_Response__c = 'customer response';
		acpc1.Record_Lock_Code__c = 'lock code 1';
		acpc1.Record_Unlock_Status__c = 'unlock status 1';
		acpc1.Notification_Error__c = 'notification error 1';
		acpc1.Sales_Price_Change_Effective_Date_Min__c = Date.today().addDays(-1);
		insert acpc1;

		System.runAs(user2)
		{
			acpc1.Notification_Error__c = 'notification error 2';
			acpc1.Sales_Price_Change_Effective_Date_Min__c = Date.today();
			acpc1.Reschduled_For_Reminder__c = true;
			acpc1.Record_Unlock_Status__c = 'unlock status 2';
			acpc1.Customer_Response__c = 'Approved';
			update acpc1;
		}
	}

	@IsTest
	static void testUpdate1()
	{
		Profile systemAdminProfile = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];

		User user1 = new User();
		user1.Alias = 'blabla2';
		user1.Email = 'blabla2@officedepot.com';
		user1.EmailEncodingKey = 'UTF-8';
		user1.LastName = 'blabla2';
		user1.LanguageLocaleKey = 'en_US';
		user1.LocaleSidKey = 'en_US';
		user1.ProfileId = systemAdminProfile.Id;
		user1.TimeZoneSidKey = 'America/Los_Angeles';
		user1.UserName = 'blabla4@officedepot.com';
		insert user1;

		System.runAs(user1)
		{
			Account a1 = [SELECT Id FROM Account WHERE Name = 'blablaaccount1'];
			ACE_Customer_Price_Changes__c acpc1 = [SELECT Id FROM ACE_Customer_Price_Changes__c WHERE Customer__c =:a1.Id];
			acpc1.Notification_Error__c = 'notification error 2';
			acpc1.Sales_Price_Change_Effective_Date_Min__c = Date.today();
			acpc1.Reschduled_For_Reminder__c = true;
			acpc1.Record_Unlock_Status__c = 'unlock status 2';
			acpc1.Customer_Response__c = 'Approved';
			update acpc1;
		}
	}

	@IsTest
	static void testUpdate2()
	{
		Profile systemAdminProfile = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];

		User user1 = new User();
		user1.Alias = 'blabla3';
		user1.Email = 'blabla3@officedepot.com';
		user1.EmailEncodingKey = 'UTF-8';
		user1.LastName = 'blabla3';
		user1.LanguageLocaleKey = 'en_US';
		user1.LocaleSidKey = 'en_US';
		user1.ProfileId = systemAdminProfile.Id;
		user1.TimeZoneSidKey = 'America/Los_Angeles';
		user1.UserName = 'blabla3@officedepot.com';
		insert user1;

		System.runAs(user1)
		{
			Account a1 = [SELECT Id FROM Account WHERE Name = 'blablaaccount1'];
			ACE_Customer_Price_Changes__c acpc1 = [SELECT Id FROM ACE_Customer_Price_Changes__c WHERE Customer__c =:a1.Id];
			acpc1.Notification_Error__c = 'notification error 3';
			acpc1.Reschduled_For_Reminder__c = true;
			acpc1.Record_Lock_Code__c = 'lock code 2';
			acpc1.Record_Unlock_Status__c = 'unlock status 3';
			acpc1.Customer_Response__c = 'Call Me';
			update acpc1;
		}
	}

	@IsTest
	static void testBypass()
	{
		ACE_Settings__c aceSettings = new ACE_Settings__c();
		aceSettings.BatchName__c = 'Q4-2014';
		aceSettings.Trigger_By_Pass__c = String.valueOf(UserInfo.getUserId());
		insert aceSettings;

		Profile systemAdminProfile = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator'];

		User user1 = new User();
		user1.Alias = 'blabla3';
		user1.Email = 'blabla3@officedepot.com';
		user1.EmailEncodingKey = 'UTF-8';
		user1.LastName = 'blabla3';
		user1.LanguageLocaleKey = 'en_US';
		user1.LocaleSidKey = 'en_US';
		user1.ProfileId = systemAdminProfile.Id;
		user1.TimeZoneSidKey = 'America/Los_Angeles';
		user1.UserName = 'blabla5@officedepot.com';
		insert user1;

		System.runAs(user1)
		{
			Account a1 = [SELECT Id FROM Account WHERE Name = 'blablaaccount1'];
			ACE_Customer_Price_Changes__c acpc1 = [SELECT Id FROM ACE_Customer_Price_Changes__c WHERE Customer__c =:a1.Id];
			acpc1.Notification_Error__c = 'notification error 3';
			acpc1.Reschduled_For_Reminder__c = true;
			acpc1.Record_Lock_Code__c = 'lock code 2';
			acpc1.Record_Unlock_Status__c = 'unlock status 3';
			acpc1.Customer_Response__c = 'Call Me';
			update acpc1;
		}
	}
}