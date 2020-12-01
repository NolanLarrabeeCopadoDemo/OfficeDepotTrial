/*************************************************************
*Name           : OverlayRep_AccountSalesHistoryExtension 
*Created By     : Virendra (Appirio Off)
*Created Date   : 11 Nov, 2011
*Updated By     : Prasad Devar
*Update Date    : 5 Dec, 2011
*Purpose        : To Show the Current Users Accont Sales History
****************************************************************/
public virtual with sharing class OverlayRep_AccountSalesHistoryExtension{
  //The current Account record,on which processing is going on
  private List<AggregateResult> accounts = null;
  private static Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Account.getRecordTypeInfosByName();
  
  public SiteAccounts siteAccountHistory {get;set;}
  public Account dummyAccount {get;set;} 
  private String userId;
  
  //---------------------------------------------------//
  //  constructor to buid initial page
  //---------------------------------------------------//
  public OverlayRep_AccountSalesHistoryExtension() {
    dummyAccount = new Account();
    //dummyAccount.OwnerId = UserInfo.getUserId();
    userId = UserInfo.getUserId(); 
    dummyAccount.OwnerId = userId;      
    siteAccountHistory = getAllSiteAccountsForCurrentUser();
  }
  
  public PageReference Refresh() {
    //System.debug('---------------- userid ---------------- '+ dummyAccount.OwnerId);
    userId = dummyAccount.OwnerId;
    siteAccountHistory = getAllSiteAccountsForCurrentUser();
    return null;
  }
  
  
  public Double calculate_imu_per(Double margin, Double sales )
  { 
    Double imu =0.0;
    
    if (sales > 0 )
      if(margin != null && sales != null)
           imu  = margin/sales;
    return imu;    
  }
  
  //---------------------------------------------------//
  //  Get logged in user
  //---------------------------------------------------//
  private String loggedInUserId(){
     return Util.getCurrentDashboardUserId(Util.getCurrentPageName());
  } 
  
   protected virtual List<AggregateResult> getAggregateResult() {
    Set<Id> siteRecordTypeID = new Set<Id>();
    siteRecordTypeID.add(getRecordTypeId('Site'));
    siteRecordTypeID.add(getRecordTypeId('Site (OfficeMax)'));
    return [SELECT sum(MTD_Sales_TY__c) MTD_Sales_TY__c,
      sum(MTD_Sales_TY_IMU__c) MTD_Sales_TY_IMU2__c,
      sum(MTD_Sales_LY__c) MTD_Sales_LY__c,
      sum(MTD_Sales_LY_IMU__c) MTD_Sales_LY_IMU2__c,
      sum(MTD_Sales_Diff__c) MTD_Sales_Diff__c,
      sum(Monthly_LY__c) Monthly_LY__c,
      sum(Monthly_LY_IMU__c) Monthly_LY_IMU_Per__c,
      sum(Month_Goal__c) Month_Goal__c,
      sum(ADS_Current_Month__c) ADS_Current_Month__c,
      sum(ADS_Last_Month__c) ADS_Last_Month__c,
      sum(QTD_Sales_TY__c) QTD_Sales_TY__c,
      sum(QTD_Sales_TY_IMU__c) QTD_Sales_TY_IMU2__c,
      sum(QTD_Sales_LY__c) QTD_Sales_LY__c,
      sum(QTD_Sales_LY_IMU__c) QTD_Sales_LY_IMU2__c,
      sum(QTD_Sales_Diff__c) QTD_Sales_Diff__c,
      sum(Quarter_LY__c) Quarter_LY__c,
      sum(Quarter_LY_IMU__c) Quarter_LY_IMU_per__c,
      sum(Quarter_Goal__c) Quarter_Goal__c,
      sum(ADS_Current_Qtr__c) ADS_Current_Qtr__c,
      sum(ADS_Last_Qtr__c) ADS_Last_Qtr__c,
      sum(YTD_Sales_TY__c) YTD_Sales_TY__c,
      sum(YTD_Sales_TY_IMU__c) YTD_Sales_TY_IMU2__c,
      sum(YTD_Sales_LY__c) YTD_Sales_LY__c,
      sum(YTD_Sales_LY_IMU__c) YTD_Sales_LY_IMU2__c,
      sum(YTD_Sales_Diff__c) YTD_Sales_Diff__c,
      sum(Year_LY__c) Year_LY__c,
      sum(Year_LY_IMU__c) Year_LY_IMU_per__c,
      sum(Year_Goal__c) Year_Goal__c,
      sum(ADS_Current_Yr__c) ADS_Current_Yr__c,
      sum(ADS_Last_Yr__c) ADS_Last_Yr__c
       //From Account Where RecordTypeId =:siteRecordTypeID And Id IN :Util.setOfAccountIdsFromAccountTeamMember(loggedInUserId() ) ]; 
       From Account Where RecordTypeId IN:siteRecordTypeID And 
       //Id IN (SELECT AccountID  FROM AccountTeamMember WHERE UserId = :loggedInUserId())];   
       Id IN (SELECT AccountID  FROM AccountTeamMember WHERE UserId = :userId)];
   }   
   
  public SiteAccounts getAllSiteAccountsForCurrentUser(){
    SiteAccounts siteAccount = new SiteAccounts();     
    Id siteRecordTypeID = getRecordTypeId('Site');
    List<AggregateResult> accounts = getAggregateResult();
        
    for(AggregateResult acct:accounts){
        siteAccount.MTD_Sales_TY=(Double)acct.get('MTD_Sales_TY__c');
        siteAccount.MTD_Sales_TY_IMU2=(Double)acct.get('MTD_Sales_TY_IMU2__c');
        siteAccount.MTD_Sales_LY=(Double)acct.get('MTD_Sales_LY__c');
        siteAccount.MTD_Sales_LY_IMU2=(Double)acct.get('MTD_Sales_LY_IMU2__c');
        siteAccount.MTD_Sales_Diff=(Double)acct.get('MTD_Sales_Diff__c');
        siteAccount.Monthly_LY=(Double)acct.get('Monthly_LY__c');
        siteAccount.Monthly_LY_IMU_Per=(Double)acct.get('Monthly_LY_IMU_Per__c');
        siteAccount.Month_Goal=(Double)acct.get('Month_Goal__c');
        siteAccount.ADS_Current_Month=(Double)acct.get('ADS_Current_Month__c');
        siteAccount.ADS_Last_Month=(Double)acct.get('ADS_Last_Month__c');
        siteAccount.QTD_Sales_TY=(Double)acct.get('QTD_Sales_TY__c');
        siteAccount.QTD_Sales_TY_IMU2=(Double)acct.get('QTD_Sales_TY_IMU2__c');
        siteAccount.QTD_Sales_LY=(Double)acct.get('QTD_Sales_LY__c');
        siteAccount.QTD_Sales_LY_IMU2=(Double)acct.get('QTD_Sales_LY_IMU2__c');
        siteAccount.QTD_Sales_Diff =(Double)acct.get('QTD_Sales_Diff__c');
        siteAccount.Quarter_LY =(Double)acct.get('Quarter_LY__c');
        siteAccount.Quarter_LY_IMU_per =(Double)acct.get('Quarter_LY_IMU_per__c');
        siteAccount.Quarter_Goal =(Double)acct.get('Quarter_Goal__c');
        siteAccount.ADS_Current_Qtr =(Double)acct.get('ADS_Current_Qtr__c');
        siteAccount.ADS_Last_Qtr =(Double)acct.get('ADS_Last_Qtr__c');
        siteAccount.YTD_Sales_TY =(Double)acct.get('YTD_Sales_TY__c');
        siteAccount.YTD_Sales_TY_IMU2 =(Double)acct.get('YTD_Sales_TY_IMU2__c');
        siteAccount.YTD_Sales_LY =(Double)acct.get('YTD_Sales_LY__c');
        siteAccount.YTD_Sales_LY_IMU2 =(Double)acct.get('YTD_Sales_LY_IMU2__c');
        siteAccount.YTD_Sales_Diff =(Double)acct.get('YTD_Sales_Diff__c');
        siteAccount.Year_LY =(Double)acct.get('Year_LY__c');
        siteAccount.Year_LY_IMU_per =(Double)acct.get('Year_LY_IMU_per__c');
        siteAccount.Year_Goal =(Double)acct.get('Year_Goal__c');
        siteAccount.ADS_Current_Yr =(Double)acct.get('ADS_Current_Yr__c');
        siteAccount.ADS_Last_Yr  =(Double)acct.get('ADS_Last_Yr__c');
    }
  // calculate MTD TY IMU by dividing with sales.
        siteAccount.MTD_Sales_TY_IMU2 = calculate_imu_per(siteAccount.MTD_Sales_TY_IMU2,siteAccount.MTD_Sales_TY);

  // calculate MTD LY IMU by dividing with sales.
   
         siteAccount.MTD_Sales_LY_IMU2 =  calculate_imu_per(siteAccount.MTD_Sales_LY_IMU2,siteAccount.MTD_Sales_LY);
         
  // calculate Monthly LY IMU by dividing with sales.
         siteAccount.Monthly_LY_IMU_Per =  calculate_imu_per(siteAccount.Monthly_LY_IMU_Per,siteAccount.Monthly_LY);
              
  // calculate QTD TY IMU by dividing with sales.
         siteAccount.QTD_Sales_TY_IMU2 =  calculate_imu_per(siteAccount.QTD_Sales_TY_IMU2,siteAccount.QTD_Sales_TY);
            
  // calculate QTD LY IMU by dividing with sales.
         siteAccount.QTD_Sales_LY_IMU2 =  calculate_imu_per(siteAccount.QTD_Sales_LY_IMU2,siteAccount.QTD_Sales_LY);

 // calculate Quarter LY IMU by dividing with sales.
         siteAccount.Quarter_LY_IMU_per =  calculate_imu_per(siteAccount.Quarter_LY_IMU_per,siteAccount.Quarter_LY);

 // calculate YTD TY IMU by dividing with sales.
         siteAccount.YTD_Sales_TY_IMU2 =  calculate_imu_per(siteAccount.YTD_Sales_TY_IMU2,siteAccount.YTD_Sales_TY);
            
  // calculate YTD LY IMU by dividing with sales.
         siteAccount.YTD_Sales_LY_IMU2 =  calculate_imu_per(siteAccount.YTD_Sales_LY_IMU2,siteAccount.YTD_Sales_LY);

 // calculate Year LY IMU by dividing with sales.
         siteAccount.Year_LY_IMU_per =  calculate_imu_per(siteAccount.Year_LY_IMU_per,siteAccount.Year_LY);
   
    return siteAccount;
  }
  
  public class SiteAccounts{
     public SiteAccounts(){
      MTD_Sales_TY  = 0.0;
      MTD_Sales_TY_IMU2  = 0.0;
      MTD_Sales_LY  = 0.0;
      MTD_Sales_LY_IMU2  = 0.0;
      MTD_Sales_Diff  = 0.0;
      Monthly_LY  = 0.0;
      Monthly_LY_IMU_Per  = 0.0;
      Month_Goal  = 0.0;
      ADS_Current_Month  = 0.0;
      ADS_Last_Month  = 0.0;
      QTD_Sales_TY  = 0.0;
      QTD_Sales_TY_IMU2  = 0.0;
      QTD_Sales_LY  = 0.0;
      QTD_Sales_LY_IMU2  = 0.0;
      QTD_Sales_Diff  = 0.0;
      Quarter_LY  = 0.0;
      Quarter_LY_IMU_per  = 0.0;
      Quarter_Goal  = 0.0;
      ADS_Current_Qtr  = 0.0;
      ADS_Last_Qtr  = 0.0;
      YTD_Sales_TY  = 0.0;
      YTD_Sales_TY_IMU2  = 0.0;
      YTD_Sales_LY  = 0.0;
      YTD_Sales_LY_IMU2  = 0.0;
      YTD_Sales_Diff  = 0.0;
      Year_LY  = 0.0;
      Year_LY_IMU_per  = 0.0;
      Year_Goal  = 0.0;
      ADS_Current_Yr  = 0.0;
      ADS_Last_Yr  = 0.0;
     }
     public Double MTD_Sales_TY {get;set;}
     public Double MTD_Sales_TY_IMU2 {get;set;}
     public Double MTD_Sales_LY {get;set;}
     public Double MTD_Sales_LY_IMU2 {get;set;}
     public Double MTD_Sales_Diff {get;set;}
     public Double Monthly_LY {get;set;}
     public Double Monthly_LY_IMU_Per {get;set;}
     public Double Month_Goal {get;set;}
     public Double ADS_Current_Month {get;set;}
     public Double ADS_Last_Month {get;set;}
     public Double QTD_Sales_TY {get;set;}
     public Double QTD_Sales_TY_IMU2 {get;set;}
     public Double QTD_Sales_LY {get;set;}
     public Double QTD_Sales_LY_IMU2 {get;set;}
     public Double QTD_Sales_Diff {get;set;}
     public Double Quarter_LY {get;set;}
     public Double Quarter_LY_IMU_per {get;set;}
     public Double Quarter_Goal {get;set;}
     public Double ADS_Current_Qtr {get;set;}
     public Double ADS_Last_Qtr {get;set;}
     public Double YTD_Sales_TY {get;set;}
     public Double YTD_Sales_TY_IMU2 {get;set;}
     public Double YTD_Sales_LY {get;set;}
     public Double YTD_Sales_LY_IMU2 {get;set;}
     public Double YTD_Sales_Diff {get;set;}
     public Double Year_LY {get;set;}
     public Double Year_LY_IMU_per {get;set;}
     public Double Year_Goal {get;set;}
     public Double ADS_Current_Yr {get;set;}
     public Double ADS_Last_Yr {get;set;}
     
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