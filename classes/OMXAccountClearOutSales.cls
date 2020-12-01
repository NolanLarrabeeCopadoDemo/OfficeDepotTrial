/**************************************************************
*Name : OMXAccountClearOutSales 
*Created By : dave sommer
*Created Date : 4/1/2014
*Purpose : clears out sales data for OfficeMax customer and site accounts,
*			uses input param MTD, QTD, YTD (default) to clear associated account sales fields.
*           MTD clears out monthly, QTD clears out MTD and QTD, YTD clears out MTD,QTD,YTD 
********************************************************************/
global class OMXAccountClearOutSales implements database.Batchable<Sobject> , Schedulable
{
    string timePeriod;
    //Record Types via Map
    private static Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Account.getRecordTypeInfosByName();
    public static final string OMX_RECORD_TYPE_NAME_CUSTOMER = 'Customer (OfficeMax)';  
    public static final string OMX_RECORD_TYPE_NAME_SITE = 'Site (OfficeMax)';  

 //public String acc_query= 'SELECT ID from account WHERE id = 001L000000MAYBz and (recordtypeid = :omxRecordTypeIdCustomer OR  recordtypeid = :omxRecordTypeIdSite ) ';      

 global OMXAccountClearOutSales ()
 {
 	this.timePeriod = 'YTD'; //default, clears out all sales data for OfficeMax customer and site accounts
 }

 global OMXAccountClearOutSales (string timePeriod)
 {
 	this.timePeriod = timePeriod;
 	System.debug('************ TIME PERIOD: ' + timePeriod + ' ********************************');
 }
 
 global Database.QueryLocator start(Database.BatchableContext BC)
    {            
        System.debug('********** ************************');
        Id omxRecordTypeIdCustomer = getRecordTypeId(OMX_RECORD_TYPE_NAME_CUSTOMER );
        Id omxRecordTypeIdSite = getRecordTypeId(OMX_RECORD_TYPE_NAME_SITE );
        System.debug('********** omxRecordTypeIdCustomer: ' + omxRecordTypeIdCustomer + ' ************************');
        System.debug('********** omxRecordTypeIdSite: ' + omxRecordTypeIdSite + ' ************************');
        // get all officemax accounts for customer and site recordtypes         
        return Database.getQueryLocator([SELECT ID,MTD_Sales_TY__c , MTD_Sales_LY__c , MTD_Sales_LY_IMU__c , MTD_Sales_TY_IMU__c , Monthly_LY__c , Monthly_LY_IMU__c , ADS_Last_Month__c , ADS_Current_Month__c  ,  
    		 QTD_Sales_TY__c , QTD_Sales_LY__c , QTD_Sales_LY_IMU__c , QTD_Sales_TY_IMU__c , Quarter_LY__c , Quarter_LY_IMU__c  , ADS_Last_Qtr__c , ADS_Current_Qtr__c ,
    		 YTD_Sales_TY__c , YTD_Sales_LY__c , YTD_Sales_LY_IMU__c , YTD_Sales_TY_IMU__c , Year_LY__c , Year_LY_IMU__c  , ADS_Last_Yr__c , ADS_Current_Yr__c 
          from account WHERE (recordtypeid = :omxRecordTypeIdCustomer OR  recordtypeid = :omxRecordTypeIdSite )]);
    }
    
    
global void execute(Database.BatchableContext BC, SObject[] scope)
    {
    
    list<account> account_list = scope;
    list<account> act_upd = new list<account> ();
    System.debug('******* in Execute, found OMX accounts: ' + account_list.size() + ' accounts *************');
    for (account a:account_list)
    { 
    	if (this.timePeriod == 'MTD') {
    	
    		if (a.MTD_Sales_TY__c != null || a.MTD_Sales_LY__c != null || a.MTD_Sales_LY_IMU__c != null || a.MTD_Sales_TY_IMU__c != null || a.Monthly_LY__c != null || a.Monthly_LY_IMU__c != null || a.ADS_Last_Month__c != null || a.ADS_Current_Month__c != null  ) {
		     	 //clear out MTD sales data if not already null
		         a.MTD_Sales_TY__c = null;
		         a.MTD_Sales_LY__c = null;
		         a.MTD_Sales_LY_IMU__c = null;
		         a.MTD_Sales_TY_IMU__c = null;
				 a.Monthly_LY__c = null;
				 a.Monthly_LY_IMU__c = null;
				 a.ADS_Last_Month__c = null;
				 a.ADS_Current_Month__c = null;
				 //add record to list   
				 act_upd.add(a);			
    		}
    	}
    	if (this.timePeriod == 'QTD') {
    	
    		if (a.MTD_Sales_TY__c != null || a.MTD_Sales_LY__c != null || a.MTD_Sales_LY_IMU__c != null || a.MTD_Sales_TY_IMU__c != null || a.Monthly_LY__c != null || a.Monthly_LY_IMU__c != null || a.ADS_Last_Month__c != null || a.ADS_Current_Month__c != null   
    		|| a.QTD_Sales_TY__c != null || a.QTD_Sales_LY__c != null || a.QTD_Sales_LY_IMU__c != null || a.QTD_Sales_TY_IMU__c != null || a.Quarter_LY__c != null || a.Quarter_LY_IMU__c  != null || a.ADS_Last_Qtr__c != null || a.ADS_Current_Qtr__c != null) {
		     	 //clear out MTD & QTD sales data if not already null
		         a.MTD_Sales_TY__c = null;
		         a.MTD_Sales_LY__c = null;
		         a.MTD_Sales_LY_IMU__c = null;
		         a.MTD_Sales_TY_IMU__c = null;
				 a.Monthly_LY__c = null;
				 a.Monthly_LY_IMU__c = null;
				 a.ADS_Last_Month__c = null;
				 a.ADS_Current_Month__c = null;
				 
		         a.QTD_Sales_TY__c = null;
		         a.QTD_Sales_LY__c = null;
		         a.QTD_Sales_LY_IMU__c = null;
		         a.QTD_Sales_TY_IMU__c = null;
		         a.Quarter_LY__c = null;
		         a.Quarter_LY_IMU__c = null;
		         a.ADS_Last_Qtr__c = null;
		         a.ADS_Current_Qtr__c = null;
         		 //add record to list   
				 act_upd.add(a);			
    		}
    	}    	
    	
     	if (this.timePeriod == 'YTD') {
    	
    		if (a.MTD_Sales_TY__c != null || a.MTD_Sales_LY__c != null || a.MTD_Sales_LY_IMU__c != null || a.MTD_Sales_TY_IMU__c != null || a.Monthly_LY__c != null || a.Monthly_LY_IMU__c != null || a.ADS_Last_Month__c != null || a.ADS_Current_Month__c != null   
    		|| a.QTD_Sales_TY__c != null || a.QTD_Sales_LY__c != null || a.QTD_Sales_LY_IMU__c != null || a.QTD_Sales_TY_IMU__c != null || a.Quarter_LY__c != null || a.Quarter_LY_IMU__c  != null || a.ADS_Last_Qtr__c != null || a.ADS_Current_Qtr__c != null
    		|| a.YTD_Sales_TY__c != null || a.YTD_Sales_LY__c != null || a.YTD_Sales_LY_IMU__c != null || a.YTD_Sales_TY_IMU__c != null || a.Year_LY__c != null || a.Year_LY_IMU__c  != null || a.ADS_Last_Yr__c != null || a.ADS_Current_Yr__c != null) {
		     	 //clear out MTD & QTD sales data if not already null
		         a.MTD_Sales_TY__c = null;
		         a.MTD_Sales_LY__c = null;
		         a.MTD_Sales_LY_IMU__c = null;
		         a.MTD_Sales_TY_IMU__c = null;
				 a.Monthly_LY__c = null;
				 a.Monthly_LY_IMU__c = null;
				 a.ADS_Last_Month__c = null;
				 a.ADS_Current_Month__c = null;
				 
		         a.QTD_Sales_TY__c = null;
		         a.QTD_Sales_LY__c = null;
		         a.QTD_Sales_LY_IMU__c = null;
		         a.QTD_Sales_TY_IMU__c = null;
		         a.Quarter_LY__c = null;
		         a.Quarter_LY_IMU__c = null;
		         a.ADS_Last_Qtr__c = null;
		         a.ADS_Current_Qtr__c = null;

		         a.YTD_Sales_TY__c = null;
		         a.YTD_Sales_LY__c = null;
		         a.YTD_Sales_LY_IMU__c = null;
		         a.YTD_Sales_TY_IMU__c = null;
		         a.Year_LY__c = null;
		         a.Year_LY_IMU__c = null;
		         a.ADS_Last_Yr__c = null;
		         a.ADS_Current_Yr__c = null;
		         
		         //additional sales fields
		         a.First_Order_Date__c = null;
		         a.Last_Order_Date__c = null;
		         a.Sales__c = null;
		         
           		 //add record to list   
				 act_upd.add(a);			
    		}
    	} 
    }
    System.debug('******* update OMX accounts: ' + act_upd.size() + ' *************');
    if (act_upd.size()>0) {
    	update act_upd;
    }
}

 global void finish(Database.BatchableContext BC)
    {
    }
    
    global void execute(SchedulableContext sc)
    {
    	System.debug('******* execute *************');
      integer batch_size = 2000;
        OMXAccountClearOutSales accBatch = new OMXAccountClearOutSales();
        database.executebatch(accBatch,batch_size);    
    }

  //================================================================================//
  //Get Record Type Id from record Type Name
  //================================================================================//
  public static  Id getRecordTypeId(String recordTypeName) {
    RecordTypeInfo siteRecordType = rtMapByName.get(recordTypeName); 
    if(siteRecordType == null) return null;
    
    return siteRecordType.getRecordTypeId();
  }  
}