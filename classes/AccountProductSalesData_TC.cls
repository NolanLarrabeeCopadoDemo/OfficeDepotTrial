@IsTest
public with sharing class AccountProductSalesData_TC {
    @TestSetup
	static void makeData()
	{
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

	/**************************************************************
    * Tests that retrieving sales data works correctly. An exception should be reaised if there is an error. 
    * @return void
    * @author Adam Albright, adam.albright@officedepot.com
    * @since 2020-04-10
    */
	@IsTest
	public static void test_scenario_getSalesData_no_account ()
	{
		
		Test.startTest();
		try{
			AccountProductSalesData.getSalesData('');
		} catch (Exception e){
			System.debug(LoggingLevel.INFO, 'Exception expected.');
		}
		Account test_account = [SELECT Id, Name FROM Account WHERE Name = 'testAccount1'];
		AccountProductSalesData.getSalesData(test_account.Id);
	
		Test.stopTest();
	}


}