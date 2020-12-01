public with sharing class LightningAccountSalesHistory
{
	@AuraEnabled
	public static String getDetails (String accountId)
	{
		Account account = [
			SELECT
			Legacy_CreatedDate__c,
			Weeks_Since_1st_Order__c,
			Weeks_since_1st_Order_new__c,
			First_Order_Date__c,
			Last_Order_Date__c,
			Weeks_Since_Last_Order__c,     // What is this?
			Weeks_since_last_order_new__c,
			Total_Order__c,
			Monthly_Sales__c,
			Weekly_Sales__c,
			Number_of_Orders__c,
			Predictive_Purchase__c,
			Number_of_Orders_Check__c,
			Num_of_Orders_Since_Start__c,
			Number_of_Categories_Check__c,
			Num_of_Categories__c,
			Sales__c
			FROM Account WHERE Id =:accountId
		];
		return JSON.serialize(account);
	}

	@AuraEnabled
	public static String getCurrentUserLocale()
	{
		User u = [SELECT LanguageLocaleKey FROM User WHERE Id =:UserInfo.getUserId()];
		return u.LanguageLocaleKey;
	}

	/**************************************************************
	 * Retrieves the account data associated with the account id.
	 * @param accountId
	 * @throws AuraHandledException
	 * @return Account
	 * @author Mohanad Abu Sheikha, Mohanad.AbuSheikha@officedepot.com
	 * @author Adam Albright, adam.albright@officedepot.com
	 * @since 2020-03-03
	 */
	@AuraEnabled
	public static String getAccountDetails (String accountId)
	{
		try
		{
			Account my_account = [
				SELECT
				Legacy_CreatedDate__c,
				Weeks_Since_1st_Order__c,
				Weeks_since_1st_Order_new__c,
				First_Order_Date__c,
				Last_Order_Date__c,
				Weeks_Since_Last_Order__c,     // What is this?
				Weeks_since_last_order_new__c,     // What is this?
				Total_Order__c,
				Monthly_Sales__c,
				Weekly_Sales__c,
				Number_of_Orders__c,
				Predictive_Purchase__c,
				Number_of_Orders_Check__c,
				Num_of_Orders_Since_Start__c,
				Number_of_Categories_Check__c,
				Num_of_Categories__c,
				Sales__c,
				Sales_Check__c
				FROM Account WHERE Id =:accountId
			];
			return JSON.serialize(my_account);
		} catch (QueryException e)
		{
			System.debug(LoggingLevel.ERROR, e);
			throw new AuraHandledException('Sales data could not be retrieved for the account.');
		}
	}

	/**************************************************************
	 * Retrieves the sales data associated with the account id.
	 * @param accountId
	 * @throws AuraHandledException
	 * @return Object
	 * @author Mohanad Abu Sheikha, Mohanad.AbuSheikha@officedepot.com
	 * @author Adam Albright, adam.albright@officedepot.com
	 * @since 2020-03-03
	 */
	@AuraEnabled
	public static String getSalesData (String accountId)
	{
		try
		{

			Account account_sales_data = [
				SELECT
				MTD_Sales_TY__c,
				MTD_Sales_TY_IMU__c,
				MTD_Sales_LY__c,
				MTD_Sales_LY_IMU__c,
				Monthly_LY__c,
				Monthly_LY_IMU__c,
				ADS_Current_Month__c,
				ADS_Last_Month__c,
				AOV_Current_Month__c,
				AOV_Last_Month__c,
				QTD_Sales_TY__c,
				QTD_Sales_TY_IMU__c,
				QTD_Sales_LY__c,
				QTD_Sales_LY_IMU__c,
				Quarter_LY__c,
				Quarter_LY_IMU__c,
				ADS_Current_Qtr__c,
				ADS_Last_Qtr__c,
				AOV_Current_Qtr__c,
				AOV_Last_Qtr__c,
				YTD_Sales_TY__c,
				YTD_Sales_TY_IMU__c,
				YTD_Sales_LY__c,
				YTD_Sales_LY_IMU__c,
				Year_LY__c,
				Year_LY_IMU__c,
				ADS_Current_Yr__c,
				ADS_Last_Yr__c,
				AOV_Current_Yr__c,
				AOV_Last_Yr__c,
				RecordType.DeveloperName
				FROM Account WHERE Id =:accountId
			];

			if (account_sales_data.RecordType.DeveloperName == 'Customer_GT')
				return JSON.serialize(account_sales_data);

			Sales_Data__c salesData = [
				SELECT
				MTD_Sales_TY__c,
				MTD_Sales_TY_IMU__c,
				MTD_Sales_LY__c,
				MTD_Sales_LY_IMU__c,
				Monthly_LY__c,
				Monthly_LY_IMU__c,
				ADS_Current_Month__c,
				ADS_Last_Month__c,
				AOV_Current_Month__c,
				AOV_Last_Month__c,
				QTD_Sales_TY__c,
				QTD_Sales_TY_IMU__c,
				QTD_Sales_LY__c,
				QTD_Sales_LY_IMU__c,
				Quarter_LY__c,
				Quarter_LY_IMU__c,
				ADS_Current_Qtr__c,
				ADS_Last_Qtr__c,
				AOV_Current_Qtr__c,
				AOV_Last_Qtr__c,
				YTD_Sales_TY__c,
				YTD_Sales_TY_IMU__c,
				YTD_Sales_LY__c,
				YTD_Sales_LY_IMU__c,
				Year_LY__c,
				Year_LY_IMU__c,
				ADS_Current_Yr__c,
				ADS_Last_Yr__c,
				AOV_Current_Yr__c,
				AOV_Last_Yr__c
				FROM Sales_Data__c WHERE Account__c =:accountId LIMIT 1
			];
			return JSON.serialize(salesData);
		} catch (Exception e)
		{
			System.debug(LoggingLevel.ERROR, e);
			throw new AuraHandledException('Sales data could not be retrieved for the account.');
		}
	}
}