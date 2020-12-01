@IsTest
public class LightningAccountSalesHistory_TC
{
	@TestSetup
	static void makeData()
	{
		User frenchUser = new User(
			Username = 'french@officedepot.com',
			LastName = 'french',
			Email = 'french@officedepot.com',
			Alias = 'frnch',
			LocaleSidKey = 'fr',
			LanguageLocaleKey = 'fr',
			IsActive = true
			);
		insert frenchUser;

		User englishUser = new User(
			Username = 'english-us@officedepot.com',
			LastName = 'english-us',
			Email = 'english-us@officedepot.com',
			Alias = 'engus',
			LocaleSidKey = 'en_US',
			LanguageLocaleKey = 'en_US',
			IsActive = true
			);
		insert englishUser;

		Account test_account = new Account(
			Name = 'testAccount1',
			Weeks_Since_1st_Order__c = 1,
			First_Order_Date__c = Date.today(),
			Last_Order_Date__c = Date.today(),
			Weeks_Since_Last_Order__c = 1,
			Total_Order__c = 1,
			Monthly_Sales__c = true,
			Weekly_Sales__c = true,
			Number_of_Orders__c = true,
			Predictive_Purchase__c = true,
			Number_of_Orders_Check__c = true,
			Num_of_Orders_Since_Start__c = 1,
			Num_of_Categories__c = 1,
			Sales__c = 1
			);

		insert test_account;

		Sales_Data__c sales_data = new Sales_Data__c(
			MTD_Sales_TY__c = 1,
			MTD_Sales_TY_IMU__c = 1,
			MTD_Sales_LY__c = 1,
			MTD_Sales_LY_IMU__c = 1,
			Monthly_LY__c = 1,
			Monthly_LY_IMU__c = 1,
			ADS_Current_Month__c = 1,
			ADS_Last_Month__c = 1,
			AOV_Current_Month__c = 1,
			AOV_Last_Month__c = 1,
			QTD_Sales_TY__c = 1,
			QTD_Sales_TY_IMU__c = 1,
			QTD_Sales_LY__c = 1,
			QTD_Sales_LY_IMU__c = 1,
			Quarter_LY__c = 1,
			Quarter_LY_IMU__c = 1,
			ADS_Current_Qtr__c = 1,
			ADS_Last_Qtr__c = 1,
			AOV_Current_Qtr__c = 1,
			AOV_Last_Qtr__c = 1,
			YTD_Sales_TY__c = 1,
			YTD_Sales_TY_IMU__c = 1,
			YTD_Sales_LY__c = 1,
			YTD_Sales_LY_IMU__c = 1,
			Year_LY__c = 1,
			Year_LY_IMU__c = 1,
			ADS_Current_Yr__c = 1,
			ADS_Last_Yr__c = 1,
			AOV_Current_Yr__c = 1,
			AOV_Last_Yr__c = 1,
			Account__c = test_account.Id
			);

		insert sales_data;
	}

	@IsTest
	public static void testGetCurrentUserLocaleFrench()
	{
		User user = [SELECT Id FROM User WHERE Username = 'french@officedepot.com' LIMIT 1];
		Test.startTest();
		System.runAs(user)
		{
			String locale = LightningAccountSalesHistory.getCurrentUserLocale();
			System.assertEquals('fr', locale);
		}
		Test.stopTest();
	}

	@IsTest
	public static void testGetCurrentUserLocaleEnglish()
	{
		User user = [SELECT Id FROM User WHERE Username = 'english-us@officedepot.com' LIMIT 1];
		Test.startTest();
		System.runAs(user)
		{
			String locale = LightningAccountSalesHistory.getCurrentUserLocale();
			System.assertEquals('en_US', locale);
		}
		Test.stopTest();
	}

	/**************************************************************
	 * Tests that retrieving account details works correctly. An exception should be reaised if there is an error.
	 * @return void
	 * @author Adam Albright, adam.albright@officedepot.com
	 * @since 2020-03-03
	 */
	@IsTest
	public static void test_scenario_getAccountDetails_no_account ()
	{

		Test.startTest();
		try
		{
			LightningAccountSalesHistory.getAccountDetails('');
		} catch (Exception e)
		{
			System.debug(LoggingLevel.INFO, 'Exception expected.');
		}
		Account test_account = [SELECT Id, Name FROM Account WHERE Name = 'testAccount1'];
		LightningAccountSalesHistory.getAccountDetails(test_account.Id);

		Test.stopTest();
	}

	/**************************************************************
	 * Tests that retrieving sales_data works correctly. An exception should be reaised if there is an error.
	 * @return void
	 * @author Adam Albright, adam.albright@officedepot.com
	 * @since 2020-03-03
	 */
	@IsTest
	public static void test_scenario_getSalesData_no_account ()
	{

		Test.startTest();
		try
		{
			LightningAccountSalesHistory.getSalesData('');
		} catch (Exception e)
		{
			System.debug(LoggingLevel.INFO, 'Exception expected.');
		}
		Account test_account = [SELECT Id, Name FROM Account WHERE Name = 'testAccount1'];
		LightningAccountSalesHistory.getSalesData(test_account.Id);

		Test.stopTest();
	}
}