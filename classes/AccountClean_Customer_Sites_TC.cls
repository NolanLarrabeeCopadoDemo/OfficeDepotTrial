/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AccountClean_Customer_Sites_TC {

    static testMethod void myUnitTest() {
        
         Schema.DescribeSObjectResult AR = Schema.SObjectType.Account;
         Map<String,Schema.RecordTypeInfo> ARMapByName = AR.getRecordTypeInfosByName();
        
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.recordtypeid= ARMapByName.get('Customer').getRecordTypeId();
        acc.ADS_Current_Month__c = null;
        acc.ADS_Current_Qtr__c = null;                      
        acc.ADS_Current_Yr__c = null;
        acc.ADS_Last_Month__c = null;
        acc.ADS_Last_Qtr__c = null;
        acc.ADS_Last_Yr__c = null;
        acc.CBS_IMU_LY__c=null;
        acc.CBS_IMU_TY__c=null;
        acc.CBS_LY__c = null;
        acc.CBS_TY__c = null;
        acc.CBS_Last_Order__c = null;
        acc.CBS_Last_order_amt__c = null;
        acc.CPD_IMU_LY__c = null;
        acc.CPD_IMU_TY__c = null;
        acc.CPD_LY__c = null;
        acc.CPD_TY__c = null;
        acc.CPD_Last_Order__c = null;
        acc.CPD_Last_order_amt__c = null;
        acc.Filing_Binding_IMU_LY__c = null;
        acc.Filing_Binding_IMU_TY__c = null;
        acc.Filing_Binding_LY__c = null;
        acc.Filing_Binding_TY__c = null;
        acc.Filing_Binding_Last_Order__c = null;
        acc.Filing_Binding_Last_Order_amt__c = null;
        acc.Furniture_IMU_LY__c = null;
        acc.Furniture_IMU_TY__c = null;
        acc.Furniture_LY__c = null;
        acc.Furniture_TY__c = null;
        acc.Furniture_Last_Order__c = null;
        acc.Furniture_last_order_amt__c = null;
        acc.Office_Essentials_IMU_LY__c = null;
        acc.Office_Essentials_IMU_TY__c = null;
        acc.Office_Essentials_LY__c = null;
        acc.Office_Essentials_TY__c = null;
        acc.Office_Essentials_Last_Order__c = null;
        acc.Office_Essentials_Last_Order_amt__c = null;
        acc.Ink_Toner_IMU_LY__c = null;
        acc.Ink_Toner_IMU_TY__c = null;
        acc.Ink_Toner_LY__c = null;
        acc.Ink_Toner_TY__c = null;
        acc.Ink_Toner_Last_Order__c = null;
        acc.Ink_Toner_Last_Order_amt__c = null;
        acc.Labels_Forms_IMU_LY__c = null;
        acc.Labels_Forms_IMU_TY__c = null;
        acc.Labels_Forms_LY__c = null;
        acc.Labels_Forms_TY__c = null;
        acc.Labels_Forms_Last_Order__c = null;
        acc.Labels_Forms_Last_Order_amt__c = null;
        acc.Miscellaneous_IMU_LY__c = null;
        acc.Miscellaneous_IMU_TY__c = null;
        acc.Miscellaneous_LY__c = null;
        acc.Miscellaneous_TY__c = null;
        acc.Miscellaneous_Last_Order__c = null;
        acc.Miscellaneous_Last_Order_amt__c = null;
        acc.Paper_IMU_LY__c = null;
        acc.Paper_IMU_TY__c = null;
        acc.Paper_LY__c = null;
        acc.Paper_TY__c = null;
        acc.Paper_Last_Order__c = null;
        acc.Paper_Last_Order_amt__c = null;
        acc.Tech_IMU_LY__c = null;
        acc.Tech_IMU_TY__c = null;
        acc.Tech_LY__c = null;
        acc.Tech_TY__c = null;
        acc.Tech_Last_Order__c = null;
        acc.Tech_Last_Order_amt__c = null;
        acc.Writing_Drafting_IMU_LY__c = null;
        acc.Writing_Drafting_IMU_TY__c = null;
        acc.Writing_Drafting_LY__c = null;
        acc.Writing_Drafting_TY__c = null;
        acc.Writing_Drafting_Last_Order__c = null;
        acc.Writing_Drafting_Last_Order_amt__c=null;
        acc.Monthly_LY_IMU__c=null;
        acc.MTD_Sales_LY_IMU__c=null;
        acc.MTD_Sales_TY_IMU__c=null;
        acc.QTD_Sales_LY_IMU__c=null;
        acc.QTD_Sales_TY_IMU__c=null;
        acc.Quarter_LY_IMU__c=null;
        acc.Year_LY_IMU__c=null;
        acc.YTD_Sales_LY_IMU__c=null;
        acc.YTD_Sales_TY_IMU__c=null;
        acc.QTD_Sales_LY__c=null;
        acc.QTD_Sales_TY__c=null;
        acc.Quarter_LY__c=null;
        acc.Monthly_LY__c=null;
        acc.MTD_Sales_LY__c=null;
        acc.MTD_Sales_TY__c=null;
        acc.Year_LY__c=null;
        acc.YTD_Sales_LY__c=null;
        acc.YTD_Sales_TY__c=null;
        acc.MPS_IMU_LY__c=null;
        acc.MPS_IMU_TY__c=null;
        acc.MPS_LY__c=null;
        acc.MPS_TY__c=null;
        acc.MPS_Last_Order__c=null;
        acc.MPS_Last_order_amt__c=null;
        acc.Orders_Last_Month__c=null;
        acc.Orders_Last_Qtr__c=null;
        acc.Orders_Last_Yr__c=null;
        acc.Orders_Current_Month__c=null;
        acc.Orders_Current_Qtr__c=null;
        acc.Orders_Current_Yr__c=null;
        acc.AOV_Last_Month__c=null;
        acc.AOV_Last_Qtr__c=null;
        acc.AOV_Last_Yr__c=null;
        acc.AOV_Current_Month__c=null;
        acc.AOV_Current_Qtr__c=null;
        acc.AOV_Current_Yr__c=null;
        acc.Org_Number_of_Locations__c=null;
        acc.CBS_Pot__c=null;
        acc.CPD_Pot__c=null;
        acc.Filing_Binding_Pot__c=null;
        acc.Furniture_Pot__c=null;
        acc.Office_Essentials_Pot__c=null;
        acc.Ink_Toner_Pot__c=null;
        acc.Labels_Forms_Pot__c=null;
        acc.Miscellaneous_Pot__c=null;
        acc.Paper_Pot__c=null;
        acc.Tech_Pot__c=null;
        acc.Writing_Drafting_Pot__c=null;
        acc.Monthly_Sales__c=false;
        acc.Weekly_Sales__c=false;
        acc.Number_of_Orders__c=false;
        acc.Predictive_Purchase__c=false;
        acc.Num_of_Orders_Since_Start__c=null;
        acc.Number_of_Categories_Check__c=false;
        acc.Num_of_Categories__c=null;
        acc.Sales_Check__c=false;
        acc.Sales__c=null;
        acc.Number_of_Orders_Check__c=false;
        acc.Weeks_Since_1st_Order__c=null;
        acc.Weeks_Since_Last_Order__c=null;
        acc.Potential_Amount__c=null;
        acc.Stage__c=null;
        acc.Ranking__c=null;
        acc.MPS_Pot__c=null;
        insert acc;
        
        Account accSite = new Account ();
        accSite.name = 'SUN Test Account';
        accSite.BillingStreet = '1040 N 326 W';
        accSite.billingcity = 'Orem';
        accSite.BillingState = 'UT';
        accSite.recordtypeid= ARMapByName.get('Site').getRecordTypeId();
        accSite.Billingcountry = 'USA';
        accSite.Oracle_Party_Site_Id__c = '12345678';
        accSite.AOPS_Cust_Id__c = '12345678';
        accSite.AOPS_Seq_ID__c = '12345678';
        insert accSite;
        
        Test.startTest();            
            String strQuery = 'Select Id, RecordTypeId,ADS_Current_Month__c, ADS_Current_Qtr__c, ADS_Current_Yr__c, ADS_Last_Month__c, ADS_Last_Qtr__c, ADS_Last_Yr__c, ' 
                            +' CBS_IMU_LY__c, CBS_IMU_TY__c, CBS_LY__c, CBS_TY__c, CBS_Last_Order__c, CBS_Last_order_amt__c, CPD_IMU_LY__c, CPD_IMU_TY__c,' 
                            +' CPD_LY__c, CPD_TY__c, CPD_Last_Order__c, CPD_Last_order_amt__c, Filing_Binding_IMU_LY__c, Filing_Binding_IMU_TY__c, Filing_Binding_LY__c,' 
                            +' Filing_Binding_TY__c, Filing_Binding_Last_Order__c, Filing_Binding_Last_Order_amt__c, Furniture_IMU_LY__c, Furniture_IMU_TY__c, Furniture_LY__c, '
                            +' Furniture_TY__c, Furniture_Last_Order__c, Furniture_last_order_amt__c, Office_Essentials_IMU_LY__c, Office_Essentials_IMU_TY__c, Office_Essentials_LY__c,' 
                            +' Office_Essentials_TY__c, Office_Essentials_Last_Order__c, Office_Essentials_Last_Order_amt__c, Ink_Toner_IMU_LY__c, Ink_Toner_IMU_TY__c,'                            
                            +' Ink_Toner_Last_Order__c, Ink_Toner_Last_Order_amt__c, Labels_Forms_IMU_LY__c, Labels_Forms_IMU_TY__c, Labels_Forms_LY__c, Labels_Forms_TY__c, Labels_Forms_Last_Order__c, Labels_Forms_Last_Order_amt__c,' 
                            +' Miscellaneous_IMU_LY__c, Miscellaneous_IMU_TY__c, Miscellaneous_LY__c, Miscellaneous_TY__c, Miscellaneous_Last_Order__c, Miscellaneous_Last_Order_amt__c, Paper_IMU_LY__c,' 
                            +' Paper_IMU_TY__c, Paper_LY__c, Paper_TY__c, Paper_Last_Order__c, Paper_Last_Order_amt__c, Tech_IMU_LY__c, Tech_IMU_TY__c, Tech_LY__c, Tech_TY__c, Tech_Last_Order__c, Tech_Last_Order_amt__c,'
                            +' Writing_Drafting_IMU_LY__c, Writing_Drafting_IMU_TY__c, Writing_Drafting_LY__c, Writing_Drafting_TY__c, Writing_Drafting_Last_Order__c, Writing_Drafting_Last_Order_amt__c, Monthly_LY_IMU__c, MTD_Sales_LY_IMU__c,'
                            +' MTD_Sales_TY_IMU__c, QTD_Sales_LY_IMU__c, QTD_Sales_TY_IMU__c, Quarter_LY_IMU__c, Year_LY_IMU__c, YTD_Sales_LY_IMU__c, YTD_Sales_TY_IMU__c, QTD_Sales_LY__c, QTD_Sales_TY__c, Quarter_LY__c, Monthly_LY__c,'
                            +' MTD_Sales_LY__c, MTD_Sales_TY__c, Year_LY__c, YTD_Sales_LY__c, YTD_Sales_TY__c, MPS_IMU_LY__c, MPS_IMU_TY__c, MPS_LY__c, MPS_TY__c, MPS_Last_Order__c, MPS_Last_order_amt__c, Orders_Last_Month__c, Orders_Last_Qtr__c,'
                            +' Orders_Last_Yr__c, Orders_Current_Month__c, Orders_Current_Qtr__c, Orders_Current_Yr__c, AOV_Last_Month__c, AOV_Last_Qtr__c, AOV_Last_Yr__c, AOV_Current_Month__c, AOV_Current_Qtr__c, AOV_Current_Yr__c, Org_Number_of_Locations__c,'
                            +' CBS_Pot__c, CPD_Pot__c, Filing_Binding_Pot__c, Furniture_Pot__c, Office_Essentials_Pot__c, Ink_Toner_Pot__c, Labels_Forms_Pot__c, Miscellaneous_Pot__c, Paper_Pot__c, Tech_Pot__c, Writing_Drafting_Pot__c, Monthly_Sales__c, Weekly_Sales__c,'
                            +' Number_of_Orders__c, Predictive_Purchase__c, Num_of_Orders_Since_Start__c, Number_of_Categories_Check__c, Num_of_Categories__c, Sales_Check__c, Sales__c, Number_of_Orders_Check__c, Weeks_Since_1st_Order__c, Weeks_Since_Last_Order__c,'
                            +' Potential_Amount__c, Stage__c, Ranking__c, MPS_Pot__c'
                            +' from Account where RecordTypeId = \'012E00000008dTa\' OR RecordTypeId = \'012E00000008dTc\'';
            AccountClean_Customer_Sites cleanBatch = new AccountClean_Customer_Sites(strQuery);
            database.executebatch(cleanBatch, 2000);
        Test.stopTest();
        
    }
}