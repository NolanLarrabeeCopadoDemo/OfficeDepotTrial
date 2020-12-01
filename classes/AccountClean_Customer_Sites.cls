/***
This single class is used to clean the data for Customer and Sites DW field of all Accounts.


Created By: Wipro Offshore
Created Date: 29-Jan-2013
Frequency: More over Yearly(At the Starting of the every Year)
Modified By:
Modified Date:
  
Modify Reason:
**/
global class AccountClean_Customer_Sites implements database.Batchable<Sobject>, Schedulable
{
    public String strQuery; //this variable used to set query from test class or from scheduler if required
    
    // below is set a default query in case not set in test class or in scheduler
    private String DEFAULT_QUERY = 'Select Id, RecordTypeId,ADS_Current_Month__c, ADS_Current_Qtr__c, ADS_Current_Yr__c, ADS_Last_Month__c, ADS_Last_Qtr__c, ADS_Last_Yr__c, ' 
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


    /* Default Constructor*/
    global AccountClean_Customer_Sites()
    {
    }
    
    /*This costructor is called from the Batch Schedule mathod*/
    global AccountClean_Customer_Sites(String query)
    {
        System.debug('QUEERY IS---->'+query);
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
    }
    
    /* This method prepares the scope of the batch programbased on the query result and send the records count email before processing*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {            
        System.debug('QUERY IS ===== = '+strQuery);
        return Database.getQueryLocator(strQuery);
    }
    
    /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
            System.debug('EXECUTE 1111');
            List<Account> lstAccounts = scope;       
            List<Account> lstUpdateAccounts = new List<Account>();
            
            // loop on the batch scope        
            for(Account objAccounts: lstAccounts)
            {
                if(objAccounts.RecordTypeId=='012E00000008dTa' || objAccounts.RecordTypeId=='012E00000008dTc')
                    {
                        objAccounts.ADS_Current_Month__c = null;
                        objAccounts.ADS_Current_Qtr__c = null;                      
                        objAccounts.ADS_Current_Yr__c = null;
                        objAccounts.ADS_Last_Month__c = null;
                        objAccounts.ADS_Last_Qtr__c = null;
                        objAccounts.ADS_Last_Yr__c = null;
                        objAccounts.CBS_IMU_LY__c=null;
                        objAccounts.CBS_IMU_TY__c=null;
                        objAccounts.CBS_LY__c = null;
                        objAccounts.CBS_TY__c = null;
                        objAccounts.CBS_Last_Order__c = null;
                        objAccounts.CBS_Last_order_amt__c = null;
                        objAccounts.CPD_IMU_LY__c = null;
                        objAccounts.CPD_IMU_TY__c = null;
                        objAccounts.CPD_LY__c = null;
                        objAccounts.CPD_TY__c = null;
                        objAccounts.CPD_Last_Order__c = null;
                        objAccounts.CPD_Last_order_amt__c = null;
                        objAccounts.Filing_Binding_IMU_LY__c = null;
                        objAccounts.Filing_Binding_IMU_TY__c = null;
                        objAccounts.Filing_Binding_LY__c = null;
                        objAccounts.Filing_Binding_TY__c = null;
                        objAccounts.Filing_Binding_Last_Order__c = null;
                        objAccounts.Filing_Binding_Last_Order_amt__c = null;
                        objAccounts.Furniture_IMU_LY__c = null;
                        objAccounts.Furniture_IMU_TY__c = null;
                        objAccounts.Furniture_LY__c = null;
                        objAccounts.Furniture_TY__c = null;
                        objAccounts.Furniture_Last_Order__c = null;
                        objAccounts.Furniture_last_order_amt__c = null;
                        objAccounts.Office_Essentials_IMU_LY__c = null;
                        objAccounts.Office_Essentials_IMU_TY__c = null;
                        objAccounts.Office_Essentials_LY__c = null;
                        objAccounts.Office_Essentials_TY__c = null;
                        objAccounts.Office_Essentials_Last_Order__c = null;
                        objAccounts.Office_Essentials_Last_Order_amt__c = null;
                        objAccounts.Ink_Toner_IMU_LY__c = null;
                        objAccounts.Ink_Toner_IMU_TY__c = null;
                        objAccounts.Ink_Toner_LY__c = null;
                        objAccounts.Ink_Toner_TY__c = null;
                        objAccounts.Ink_Toner_Last_Order__c = null;
                        objAccounts.Ink_Toner_Last_Order_amt__c = null;
                        objAccounts.Labels_Forms_IMU_LY__c = null;
                        objAccounts.Labels_Forms_IMU_TY__c = null;
                        objAccounts.Labels_Forms_LY__c = null;
                        objAccounts.Labels_Forms_TY__c = null;
                        objAccounts.Labels_Forms_Last_Order__c = null;
                        objAccounts.Labels_Forms_Last_Order_amt__c = null;
                        objAccounts.Miscellaneous_IMU_LY__c = null;
                        objAccounts.Miscellaneous_IMU_TY__c = null;
                        objAccounts.Miscellaneous_LY__c = null;
                        objAccounts.Miscellaneous_TY__c = null;
                        objAccounts.Miscellaneous_Last_Order__c = null;
                        objAccounts.Miscellaneous_Last_Order_amt__c = null;
                        objAccounts.Paper_IMU_LY__c = null;
                        objAccounts.Paper_IMU_TY__c = null;
                        objAccounts.Paper_LY__c = null;
                        objAccounts.Paper_TY__c = null;
                        objAccounts.Paper_Last_Order__c = null;
                        objAccounts.Paper_Last_Order_amt__c = null;
                        objAccounts.Tech_IMU_LY__c = null;
                        objAccounts.Tech_IMU_TY__c = null;
                        objAccounts.Tech_LY__c = null;
                        objAccounts.Tech_TY__c = null;
                        objAccounts.Tech_Last_Order__c = null;
                        objAccounts.Tech_Last_Order_amt__c = null;
                        objAccounts.Writing_Drafting_IMU_LY__c = null;
                        objAccounts.Writing_Drafting_IMU_TY__c = null;
                        objAccounts.Writing_Drafting_LY__c = null;
                        objAccounts.Writing_Drafting_TY__c = null;
                        objAccounts.Writing_Drafting_Last_Order__c = null;
                        objAccounts.Writing_Drafting_Last_Order_amt__c=null;
                        objAccounts.Monthly_LY_IMU__c=null;
                        objAccounts.MTD_Sales_LY_IMU__c=null;
                        objAccounts.MTD_Sales_TY_IMU__c=null;
                        objAccounts.QTD_Sales_LY_IMU__c=null;
                        objAccounts.QTD_Sales_TY_IMU__c=null;
                        objAccounts.Quarter_LY_IMU__c=null;
                        objAccounts.Year_LY_IMU__c=null;
                        objAccounts.YTD_Sales_LY_IMU__c=null;
                        objAccounts.YTD_Sales_TY_IMU__c=null;
                        objAccounts.QTD_Sales_LY__c=null;
                        objAccounts.QTD_Sales_TY__c=null;
                        objAccounts.Quarter_LY__c=null;
                        objAccounts.Monthly_LY__c=null;
                        objAccounts.MTD_Sales_LY__c=null;
                        objAccounts.MTD_Sales_TY__c=null;
                        objAccounts.Year_LY__c=null;
                        objAccounts.YTD_Sales_LY__c=null;
                        objAccounts.YTD_Sales_TY__c=null;
                        objAccounts.MPS_IMU_LY__c=null;
                        objAccounts.MPS_IMU_TY__c=null;
                        objAccounts.MPS_LY__c=null;
                        objAccounts.MPS_TY__c=null;
                        objAccounts.MPS_Last_Order__c=null;
                        objAccounts.MPS_Last_order_amt__c=null;
                        objAccounts.Orders_Last_Month__c=null;
                        objAccounts.Orders_Last_Qtr__c=null;
                        objAccounts.Orders_Last_Yr__c=null;
                        objAccounts.Orders_Current_Month__c=null;
                        objAccounts.Orders_Current_Qtr__c=null;
                        objAccounts.Orders_Current_Yr__c=null;
                        objAccounts.AOV_Last_Month__c=null;
                        objAccounts.AOV_Last_Qtr__c=null;
                        objAccounts.AOV_Last_Yr__c=null;
                        objAccounts.AOV_Current_Month__c=null;
                        objAccounts.AOV_Current_Qtr__c=null;
                        objAccounts.AOV_Current_Yr__c=null;
                        objAccounts.Org_Number_of_Locations__c=null;
                        objAccounts.CBS_Pot__c=null;
                        objAccounts.CPD_Pot__c=null;
                        objAccounts.Filing_Binding_Pot__c=null;
                        objAccounts.Furniture_Pot__c=null;
                        objAccounts.Office_Essentials_Pot__c=null;
                        objAccounts.Ink_Toner_Pot__c=null;
                        objAccounts.Labels_Forms_Pot__c=null;
                        objAccounts.Miscellaneous_Pot__c=null;
                        objAccounts.Paper_Pot__c=null;
                        objAccounts.Tech_Pot__c=null;
                        objAccounts.Writing_Drafting_Pot__c=null;
                        objAccounts.Monthly_Sales__c=false;
                        objAccounts.Weekly_Sales__c=false;
                        objAccounts.Number_of_Orders__c=false;
                        objAccounts.Predictive_Purchase__c=false;
                        objAccounts.Num_of_Orders_Since_Start__c=null;
                        objAccounts.Number_of_Categories_Check__c=false;
                        objAccounts.Num_of_Categories__c=null;
                        objAccounts.Sales_Check__c=false;
                        objAccounts.Sales__c=null;
                        objAccounts.Number_of_Orders_Check__c=false;
                        objAccounts.Weeks_Since_1st_Order__c=null;
                        objAccounts.Weeks_Since_Last_Order__c=null;
                        objAccounts.Potential_Amount__c=null;
                        objAccounts.Stage__c=null;
                        objAccounts.Ranking__c=null;
                        objAccounts.MPS_Pot__c=null;
                    }
                        lstUpdateAccounts.add(objAccounts);
            }
            System.debug('EXECUTE 2222');
            update lstUpdateAccounts;
            System.debug('EXECUTE 3333');
    } 
    global void finish(Database.BatchableContext BC)
    {
        // do nothing
    }
    
  
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        AccountClean_Customer_Sites cleanBatch = new AccountClean_Customer_Sites(strQuery);
        database.executebatch(cleanBatch, 2000);      
         
    } 


}