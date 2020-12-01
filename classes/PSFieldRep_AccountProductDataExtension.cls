/*************************************************************
*Name       : PSFieldRep_AccountProductDataExtension
*Created By   : Virendra (Appirio Off)
*Created Date   : 10 Nov 2011
*Purpose     : To calculate sum of product data related to sites of current User
****************************************************************/
public virtual with sharing class PSFieldRep_AccountProductDataExtension {
  
  //The current Account record,on which processing is going on
  //private List<Account> accounts = null;
  protected List<AggregateResult> accounts1 = null;
  public Account dummyAccount {get;set;}
  public Id userRoleID {get;set;}
  private static Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Account.getRecordTypeInfosByName();
  
  //A place holder object, to store the total sum of lineItems
  // public Account opportunitySumAccount {get;set;}
  
  public SiteAccounts siteAccount {get;set;}
  //Mapping of Category and the sum of opportunity lineItems, we are using account.Opportunity_Amt__c as a place holder
  //this will ensure that the formatting on the VF page is proper
  public Map<String,Account> mpCategoryAmount{get;set;}
  
  public decimal tickInterval{get;set;} 
  List<String> lstCategory = new List<String>{'CBS','Office Essentials','Filing & Binding','Furniture',
                                              'Tech','Labels & Forms','CPD-Print','CPD-Promo','Paper','Miscellaneous',
                                              'Writing Drafting','Ink Toner','CPD','MPS'};
  
  list<String> lstFieldApi = new List<String>{'CPD_','Office_Essentials_','Filing_Binding_','Furniture_',
                                              'Tech_','Labels_Forms_','CBS_','Paper_','MPS_','Miscellaneous_',
                                              'Writing_Drafting_','Ink_Toner_'};
                                              
                                              
  public Double calculate_imu_per(Double margin, Double sales )
  {    
    Double imu =0.0;
     if (sales > 0 )
       if(margin != null && sales != null)
           imu = margin/sales;
    return imu;
    
  }  
  
  //---------------------------------------------------//
  //  To calculate the difference
  //---------------------------------------------------//
  public Double calculate_diff_per(Double tysales, Double lysales )
  { 
    /*Double diff=0.0;    
    if (lysales > 0 )
      if(lysales != null)
           diff = ((tysales-lysales)/lysales);
    return diff;*/ 
       
    Decimal diff=0;
        if(tysales != null && lysales != null)
           diff = (tysales-lysales);
    return diff; 
  } 
   
 
  //---------------------------------------------------//
  //  constructor to buid initial page
  //---------------------------------------------------//
  public PSFieldRep_AccountProductDataExtension() {
    dummyAccount = new Account();
    dummyAccount.OwnerId = UserInfo.getUserId();
    userRoleID = UserInfo.getUserRoleId();      
    accounts1 =   getAllLAccountsForCurrentUser();
 
    tickInterval = 100;
    populateDefaultsCategory();

  }
  
  //================================================================//
  //To populate data based on selected user
  //===============================================================//
  protected virtual void RefreshAccounts() {
     accounts1 =   getAllLAccountsForCurrentUser();
  }
  

  //================================================================//
  //To populate the default catgories in the map,put the initial value as zero
  //===============================================================//
  private void populateDefaultsCategory() {     
    mpCategoryAmount = new Map<String,Account>();     
    for(String category : lstCategory) {
      mpCategoryAmount.put(category,new Account());
    }     
  }  
  
   //================================================================================//
  //Get Record Type Id from record Type Name
  //================================================================================//
  public static  Id getRecordTypeId(String recordTypeName) {
    RecordTypeInfo siteRecordType = rtMapByName.get(recordTypeName); 
    if(siteRecordType == null) return null;
    
    return siteRecordType.getRecordTypeId();
  }
  

  
  protected virtual List<AggregateResult> getAggregateResult() {
    Set<Id> siteRecordTypeID = new Set<Id>();
    siteRecordTypeID.add(getRecordTypeId('Site'));
    siteRecordTypeID.add(getRecordTypeId('Site (OfficeMax)'));    
  return [Select
             sum(Paper_TY__c) Paper_TY,
             //sum(Paper_IMU_TY__c) Paper_IMU_TY,
             sum(Paper_LY__c) Paper_LY,
             //sum(paper_IMU_LY__c) paper_IMU_LY,
             //sum(Paper_Diff__c) Paper_Diff,
             //sum(Paper_Pot__c) Paper_Pot__c,
             //sum(Paper_Last_Order_amt__c) Paper_Last_Order_amt__c,
             //max(Paper_Last_Order__c) Paper_Last_Order__c,
             sum(Ink_Toner_TY__c) Ink_Toner_TY__c,
             //sum(Ink_Toner_IMU_TY__c) Ink_Toner_IMU_TY__c,
             sum(Ink_Toner_LY__c) Ink_Toner_LY__c,
             //sum(Ink_Toner_IMU_LY__c) Ink_Toner_IMU_LY__c,
             //sum(Ink_Toner_Diff__c) Ink_Toner_Diff__c,
             //sum(Ink_Toner_Pot__c) Ink_Toner_Pot__c,
             //max(Ink_Toner_Last_Order__c) Ink_Toner_Last_Order__c,
             //sum(Ink_Toner_Last_Order_amt__c) Ink_Toner_Last_Order_amt,
             sum(Furniture_TY__c) Furniture_TY__c,
             //sum(Furniture_IMU_TY__c) Furniture_IMU_TY__c,
             sum(Furniture_LY__c) Furniture_LY__c,
             //sum(Furniture_IMU_LY__c) Furniture_IMU_LY__c,
             // sum(Furniture_Diff__c) Furniture_Diff__c,
             //sum(Furniture_Pot__c) Furniture_Pot__c,
             //max(Furniture_Last_Order__c) Furniture_Last_Order__c,
             //sum(Furniture_last_order_amt__c) Furniture_last_order_amt,
             sum(CBS_TY__c) CBS_TY__c,
             //sum(CBS_IMU_TY__c) CBS_IMU_TY__c,
             sum(CBS_LY__c) CBS_LY__c,
             //sum(CBS_IMU_LY__c) CBS_IMU_LY__c,
             //sum(CBS_Diff__c) CBS_Diff__c,
             //sum(CBS_Pot__c) CBS_Pot__c,
             //max(CBS_Last_Order__c) CBS_Last_Order__c,
             //sum(CBS_Last_order_amt__c) CBS_Last_order_amt__c,
             sum(CPD_TY__c) CPD_TY__c,
             //sum(CPD_IMU_TY__c) CPD_IMU_TY__c,
             sum(CPD_LY__c) CPD_LY__c,
             //sum(CPD_IMU_LY__c) CPD_IMU_LY__c,
             //sum(CPD_Diff__c) CPD_Diff__c,
             //sum(CPD_Pot__c) CPD_Pot__c,
             //max(CPD_Last_Order__c) CPD_Last_Order__c,
             //sum(CPD_Last_order_amt__c) CPD_Last_order_amt__c,
             sum(Tech_TY__c) Tech_TY__c,
             //sum(Tech_IMU_TY__c) Tech_IMU_TY__c,
             sum(Tech_LY__c) Tech_LY__c,
             //sum(Tech_IMU_LY__c) Tech_IMU_LY__c,
             //sum(Tech_Diff__c) Tech_Diff__c,
             //sum(Tech_Pot__c) Tech_Pot__c,
             //max(Tech_Last_Order__c) Tech_Last_Order__c,
             //sum(Tech_Last_Order_amt__c) Tech_Last_Order_amt__c,
             sum(Filing_Binding_TY__c) Filing_Binding_TY__c, 
             //sum(Filing_Binding_IMU_TY__c) Filing_Binding_IMU_TY__c,
             sum(Filing_Binding_LY__c) Filing_Binding_LY__c,
             //sum(Filing_Binding_IMU_LY__c) Filing_Binding_IMU_LY__c,
             //sum(Filing_Binding_Diff__c) Filing_Binding_Diff__c,
             //sum(Filing_Binding_Pot__c) Filing_Binding_Pot__c,
             //max(Filing_Binding_Last_Order__c) Filing_Binding_LO,
             //sum(Filing_Binding_Last_Order_amt__c) Filing_Binding_LO_amt,
             sum(Labels_Forms_TY__c) Labels_Forms_TY__c,
             //sum(Labels_Forms_IMU_TY__c) Labels_Forms_IMU_TY__c,
             sum(Labels_Forms_LY__c) Labels_Forms_LY__c,
             //sum(Labels_Forms_IMU_LY__c) Labels_Forms_IMU_LY__c,
             //sum(Labels_Forms_Diff__c) Labels_Forms_Diff__c ,
             //sum(Labels_Forms_Pot__c) Labels_Forms_Pot__c,
             //max(Labels_Forms_Last_Order__c) Labels_Forms_LO__c,
             //sum(Labels_Forms_Last_Order_amt__c) Labels_Forms_LO_amt,
             sum(Writing_Drafting_TY__c) Writing_Drafting_TY__c,
             //sum(nvl(Writing_Drafting_IMU_TY__c,0)) Writing_Drafting_IMU_TY,
             // sum(Writing_Drafting_IMU_LY__c) Writing_Drafting_IMU_TY,
             sum(Writing_Drafting_LY__c) Writing_Drafting_LY__c,
             //sum(Writing_Drafting_IMU_LY__c) Writing_Drafting_IMU_LY,
             //sum(Writing_Drafting_Diff__c) Writing_Drafting_Diff__c,
             //sum(Writing_Drafting_Pot__c) Writing_Drafting_Pot__c,
             //max(Writing_Drafting_Last_Order__c) Writing_Drafting_LO,
             //sum(Writing_Drafting_Last_Order_amt__c) Writing_Drafting_LO_amt,
             sum(Office_Essentials_TY__c) Office_Essentials_TY__c,
             //sum(Office_Essentials_IMU_TY__c) Office_Essentials_IMU_TY,
             sum(Office_Essentials_LY__c) Office_Essentials_LY,
             //sum(Office_Essentials_IMU_LY__c) Office_Essentials_IMU_LY,
             //sum(Office_Essentials_Diff__c) Office_Essentials_Diff__c,
             //sum(Office_Essentials_Pot__c) Office_Essentials_Pot__c,
             //max(Office_Essentials_Last_Order__c) Office_Essentials_LO,
             //sum(Office_Essentials_Last_Order_amt__c) Office_Essentials_LO_amt,
             sum(MPS_TY__c) MPS_TY__c,
             //sum(MPS_IMU_TY__c) MPS_IMU_TY__c,
             sum(MPS_LY__c) MPS_LY__c,
             //sum(MPS_IMU_LY__c) MPS_IMU_LY__c,
             //sum(MPS_Diff__c) MPS_Diff__c,
             //sum(MPS_Pot__c) MPS_Pot__c,
             //max(MPS_Last_Order__c) MPS_Last_Order__c,
             //sum(MPS_Last_order_amt__c) MPS_Last_order_amt__c,
             sum(Miscellaneous_TY__c) Miscellaneous_TY__c,
             //sum(Miscellaneous_IMU_TY__c) Miscellaneous_IMU_TY__c,
             sum(Miscellaneous_LY__c) Miscellaneous_LY__c,
             //sum(Miscellaneous_IMU_LY__c) Miscellaneous_IMU_LY__c,
             //sum(Miscellaneous_Diff__c) Miscellaneous_Diff__c,
             //sum(Miscellaneous_Pot__c) Miscellaneous_Pot__c,
             //max(Miscellaneous_Last_Order__c) Miscellaneous_LO ,
             //sum(Miscellaneous_Last_Order_amt__c)  Miscellaneous_LO_amt,
             sum(Total_TY_Sales_to_Date__c) Total_TY_Sales_to_Date__c ,
             //sum(YTD_Sales_TY_IMU__c) Total_TY_IMU_per__c ,
             sum(Total_LY_Sales_to_Date__c) Total_LY_Sales_to_Date__c,
            //sum(Year_LY_IMU__c)  Total_LY_IMU_Per__c,
            sum(Total_Sales_Diff__c) Total_Sales_Diff__c
            //sum(Total_Potential_to_Date__c) Total_Potential_to_Date  
  from Account where RecordTypeId IN: siteRecordTypeID and Sector__c = 'Public' and Segment__C != 'Federal' and ownerId=:UserInfo.getUserId()]; 

  }
  
  public List<AggregateResult> getAllLAccountsForCurrentUser(){
    siteAccount = new SiteAccounts();  
    Id siteRecordTypeID = getRecordTypeId('Site');
     
   List<AggregateResult> results =  getAggregateResult();
   for (AggregateResult ar : results)
   { 
    siteAccount.Paper_TY = (Double)ar.get('Paper_TY');
    //siteAccount.Paper_IMU_TY_per = (Double)ar.get('Paper_IMU_TY');
    siteAccount.Paper_LY  = (Double)ar.get('Paper_LY');
    //siteAccount.paper_IMU_LY_per  = (Double)ar.get('paper_IMU_LY');
   
    //siteAccount.Paper_Pot  = (Double)ar.get('Paper_Pot__c');
    //siteAccount.Paper_Last_Order = acct.Paper_Last_Order__c');
    //siteAccount.Paper_Last_Order_amt  = (Double)ar.get('Paper_Last_Order_amt__c');
    siteAccount.Ink_Toner_TY  = (Double)ar.get('Ink_Toner_TY__c');
    //siteAccount.Ink_Toner_IMU_TY_per  = (Double)ar.get('Ink_Toner_IMU_TY__c');
    siteAccount.Ink_Toner_LY  = (Double)ar.get('Ink_Toner_LY__c');
    //siteAccount.Ink_Toner_IMU_LY_per  = (Double)ar.get('Ink_Toner_IMU_LY__c');
   
    //siteAccount.Ink_Toner_Pot  = (Double)ar.get('Ink_Toner_Pot__c');
    //siteAccount.Ink_Toner_Last_Order = acct.Ink_Toner_Last_Order__c');
    //siteAccount.Ink_Toner_Last_Order_amt  = (Double)ar.get('Ink_Toner_Last_Order_amt');
    siteAccount.Furniture_TY  = (Double)ar.get('Furniture_TY__c');
    //siteAccount.Furniture_IMU_TY_per  = (Double)ar.get('Furniture_IMU_TY__c');
    siteAccount.Furniture_LY  = (Double)ar.get('Furniture_LY__c');
    //siteAccount.Furniture_IMU_LY_per  = (Double)ar.get('Furniture_IMU_LY__c');   
    //siteAccount.Furniture_Pot  = (Double)ar.get('Furniture_Pot__c');
    //siteAccount.Furniture_Last_Order = acct.Furniture_Last_Order__c');
    //siteAccount.Furniture_last_order_amt  = (Double)ar.get('Furniture_last_order_amt');
    siteAccount.CBS_TY  = (Double)ar.get('CBS_TY__c');
    //siteAccount.CBS_IMU_TY_per  = (Double)ar.get('CBS_IMU_TY__c');
    siteAccount.CBS_LY  = (Double)ar.get('CBS_LY__c');
    //siteAccount.CBS_IMU_LY_per  = (Double)ar.get('CBS_IMU_LY__c'); 
    //siteAccount.CBS_Pot  = (Double)ar.get('CBS_Pot__c');
    //siteAccount.CBS_Last_Order = acct.CBS_Last_Order__c');
    //siteAccount.CBS_Last_order_amt  = (Double)ar.get('CBS_Last_order_amt__c');
    siteAccount.CPD_TY  = (Double)ar.get('CPD_TY__c');
    //siteAccount.CPD_IMU_TY_per  = (Double)ar.get('CPD_IMU_TY__c');
    siteAccount.CPD_LY  = (Double)ar.get('CPD_LY__c');
    //siteAccount.CPD_IMU_LY_per  = (Double)ar.get('CPD_IMU_LY__c');   
    //siteAccount.CPD_Pot  = (Double)ar.get('CPD_Pot__c');
    //siteAccount.CPD_Last_Order = acct.CPD_Last_Order__c');
    //siteAccount.CPD_Last_order_amt  = (Double)ar.get('CPD_Last_order_amt__c');
    siteAccount.Tech_TY  = (Double)ar.get('Tech_TY__c');    
    //siteAccount.Tech_IMU_TY_per  = (Double)ar.get('Tech_IMU_TY__c');
    siteAccount.Tech_LY  = (Double)ar.get('Tech_LY__c');
    //siteAccount.Tech_IMU_LY_per =( Double)ar.get('Tech_IMU_LY__c');   
    //siteAccount.Tech_Pot  = (Double)ar.get('Tech_Pot__c');
    //siteAccount.Tech_Last_Order = acct.Tech_Last_Order__c');
    //siteAccount.Tech_Last_Order_amt  = (Double)ar.get('Tech_Last_Order_amt__c');
    siteAccount.Filing_Binding_TY  = (Double)ar.get('Filing_Binding_TY__c');
    //siteAccount.Filing_Binding_IMU_TY_per  = (Double)ar.get('Filing_Binding_IMU_TY__c');
    siteAccount.Filing_Binding_LY  = (Double)ar.get('Filing_Binding_LY__c');
    //siteAccount.Filing_Binding_IMU_LY_per  = (Double)ar.get('Filing_Binding_IMU_LY__c');   
    //siteAccount.Filing_Binding_Pot  = (Double)ar.get('Filing_Binding_Pot__c');
    //siteAccount.Filing_Binding_Last_Order = acct.Filing_Binding_Last_Order__c');
    //siteAccount.Filing_Binding_Last_Order_amt  = (Double)ar.get('Filing_Binding_LO_amt');
    siteAccount.Labels_Forms_TY  = (Double)ar.get('Labels_Forms_TY__c');
    //siteAccount.Labels_Forms_IMU_TY_per  = (Double)ar.get('Labels_Forms_IMU_TY__c');
    siteAccount.Labels_Forms_LY  = (Double)ar.get('Labels_Forms_LY__c');
    //siteAccount.Labels_Forms_IMU_LY_per  = (Double)ar.get('Labels_Forms_IMU_LY__c');   
    //siteAccount.Labels_Forms_Pot  = (Double)ar.get('Labels_Forms_Pot__c');
    //siteAccount.Labels_Forms_Last_Order = acct.Labels_Forms_Last_Order__c');
    //siteAccount.Labels_Forms_Last_Order_amt  = (Double)ar.get('Labels_Forms_LO_amt');
    siteAccount.Writing_Drafting_TY  = (Double)ar.get('Writing_Drafting_TY__c');
    //siteAccount.Writing_Drafting_IMU_TY_per  = (Double)ar.get('Writing_Drafting_IMU_TY');
    siteAccount.Writing_Drafting_LY  = (Double)ar.get('Writing_Drafting_LY__c');
    //siteAccount.Writing_Drafting_IMU_LY_per  = (Double)ar.get('Writing_Drafting_IMU_LY');
    //siteAccount.Writing_Drafting_Pot  = (Double)ar.get('Writing_Drafting_Pot__c');
    //siteAccount.Writing_Drafting_Last_Order = acct.Writing_Drafting_Last_Order__c');
    //siteAccount.Writing_Drafting_Last_Order_amt  = (Double)ar.get('Writing_Drafting_LO_amt');
    siteAccount.Office_Essentials_TY  = (Double)ar.get('Office_Essentials_TY__c');
    //siteAccount.Office_Essentials_IMU_TY_per  = (Double)ar.get('Office_Essentials_IMU_TY');
    siteAccount.Office_Essentials_LY  = (Double)ar.get('Office_Essentials_LY');
    //siteAccount.Office_Essentials_IMU_LY_per  = (Double)ar.get('Office_Essentials_IMU_LY');
    //siteAccount.Office_Essentials_Pot  = (Double)ar.get('Office_Essentials_Pot__c');
    //siteAccount.Office_Essentials_Last_Order = acct.Office_Essentials_Last_Order__c');
    //siteAccount.Office_Essentials_Last_Order_amt  = (Double)ar.get('Office_Essentials_LO_amt');
    siteAccount.MPS_TY  = (Double)ar.get('MPS_TY__c');
    //siteAccount.MPS_IMU_TY_per  = (Double)ar.get('MPS_IMU_TY__c');
    siteAccount.MPS_LY  = (Double)ar.get('MPS_LY__c');
    //siteAccount.MPS_IMU_LY_per  = (Double)ar.get('MPS_IMU_LY__c');   
    //siteAccount.MPS_Pot  = (Double)ar.get('MPS_Pot__c');
    //siteAccount.MPS_Last_Order = acct.MPS_Last_Order__c');
    //siteAccount.MPS_Last_order_amt  = (Double)ar.get('MPS_Last_order_amt__c');
    siteAccount.Miscellaneous_TY  = (Double)ar.get('Miscellaneous_TY__c');
    //siteAccount.Miscellaneous_IMU_TY_per  = (Double)ar.get('Miscellaneous_IMU_TY__c');
    siteAccount.Miscellaneous_LY  = (Double)ar.get('Miscellaneous_LY__c');
    //siteAccount.Miscellaneous_IMU_LY_per  = (Double)ar.get('Miscellaneous_IMU_LY__c');    
    //siteAccount.Miscellaneous_Pot  = (Double)ar.get('Miscellaneous_Pot__c');
    //siteAccount.Miscellaneous_Last_Order = acct.Miscellaneous_Last_Order__c');
    //siteAccount.Miscellaneous_Last_Order_amt  = (Double)ar.get('Miscellaneous_LO_amt');
    siteAccount.Total_TY_Sales_to_Date  = (Double)ar.get('Total_TY_Sales_to_Date__c');
    //siteAccount.Total_TY_IMU_per  = (Double)ar.get('Total_TY_IMU_per__c');
    siteAccount.Total_LY_Sales_to_Date  = (Double)ar.get('Total_LY_Sales_to_Date__c');
    //siteAccount.Total_LY_IMU_Per  = (Double)ar.get('Total_LY_IMU_Per__c');
    siteAccount.Total_Sales_Diff  = (Double)ar.get('Total_Sales_Diff__c');
    //siteAccount.Total_Potential_to_Date  = (Double)ar.get('Total_Potential_to_Date');
      
    //  System.debug(ar.get('Paper_TY')+'-'+ar.get('Paper_IMU_TY')+'-'+ar.get('Total_LY_IMU_Per__c')); 
   }
  
  //Calculate IMU for all products
  //siteAccount.Paper_IMU_TY_per=calculate_imu_per(siteAccount.Paper_IMU_TY_per,siteAccount.Paper_TY );
  //siteAccount.paper_IMU_LY_per =calculate_imu_per(siteAccount.paper_IMU_LY_per,siteAccount.Paper_LY);
  //siteAccount.Ink_Toner_IMU_TY_per = calculate_imu_per(siteAccount.Ink_Toner_IMU_TY_per,siteAccount.Ink_Toner_TY);
  //siteAccount.Ink_Toner_IMU_LY_per =calculate_imu_per(siteAccount.Ink_Toner_IMU_LY_per,siteAccount.Ink_Toner_LY);
  //siteAccount.Furniture_IMU_TY_per =calculate_imu_per(siteAccount.Furniture_IMU_TY_per,siteAccount.Furniture_TY);
  //siteAccount.Furniture_IMU_LY_per =calculate_imu_per(siteAccount.Furniture_IMU_LY_per,siteAccount.Furniture_LY);
  //siteAccount.CBS_IMU_TY_per =calculate_imu_per(siteAccount.CBS_IMU_TY_per,siteAccount.CBS_TY);
  //siteAccount.CBS_IMU_LY_per =calculate_imu_per(siteAccount.CBS_IMU_LY_per ,siteAccount.CBS_LY );
  //siteAccount.CPD_IMU_TY_per =calculate_imu_per(siteAccount.CPD_IMU_TY_per,siteAccount.CPD_TY);
  //siteAccount.CPD_IMU_LY_per  =calculate_imu_per(siteAccount.CPD_IMU_LY_per,siteAccount.CPD_LY);
  //siteAccount.Tech_IMU_TY_per =calculate_imu_per(siteAccount.Tech_IMU_TY_per,siteAccount.Tech_TY);
  //siteAccount.Tech_IMU_LY_per =calculate_imu_per(//siteAccount.Tech_IMU_LY_per,siteAccount.Tech_LY );
  //siteAccount.Filing_Binding_IMU_TY_per =calculate_imu_per(siteAccount.Filing_Binding_IMU_TY_per,siteAccount.Filing_Binding_TY);
  //siteAccount.Filing_Binding_IMU_LY_per =calculate_imu_per(siteAccount.Filing_Binding_IMU_LY_per,siteAccount.Filing_Binding_LY);
  //siteAccount.Labels_Forms_IMU_TY_per =calculate_imu_per(siteAccount.Labels_Forms_IMU_TY_per,siteAccount.Labels_Forms_TY);
  //siteAccount.Labels_Forms_IMU_LY_per =calculate_imu_per(siteAccount.Labels_Forms_IMU_LY_per,siteAccount.Labels_Forms_LY);
  //siteAccount.Writing_Drafting_IMU_TY_per =calculate_imu_per(siteAccount.Writing_Drafting_IMU_TY_per,siteAccount.Writing_Drafting_TY);
  //siteAccount.Writing_Drafting_IMU_LY_per =calculate_imu_per(siteAccount.Writing_Drafting_IMU_LY_per,siteAccount.Writing_Drafting_LY);
  //siteAccount.Office_Essentials_IMU_TY_per =calculate_imu_per(siteAccount.Office_Essentials_IMU_TY_per,siteAccount.Office_Essentials_TY);
  //siteAccount.Office_Essentials_IMU_LY_per =calculate_imu_per(siteAccount.Office_Essentials_IMU_LY_per,siteAccount.Office_Essentials_LY);
  //siteAccount.MPS_IMU_TY_per =calculate_imu_per(siteAccount.MPS_IMU_TY_per,siteAccount.MPS_TY);
  //siteAccount.MPS_IMU_LY_per =calculate_imu_per(siteAccount.MPS_IMU_LY_per,siteAccount.MPS_LY);
  //siteAccount.Miscellaneous_IMU_TY_per =calculate_imu_per(siteAccount.Miscellaneous_IMU_TY_per,siteAccount.Miscellaneous_TY );
  //siteAccount.Miscellaneous_IMU_LY_per =calculate_imu_per(siteAccount.Miscellaneous_IMU_LY_per,siteAccount.Miscellaneous_LY );
  //siteAccount.Total_TY_IMU_per =calculate_imu_per(siteAccount.Total_TY_IMU_per,siteAccount.Total_TY_Sales_to_Date );
  //siteAccount.Total_LY_IMU_Per  =calculate_imu_per(siteAccount.Total_LY_IMU_Per ,siteAccount.Total_LY_Sales_to_Date  );  

  //Caculate Diff for all Products  
  siteAccount.Total_Sales_Diff = calculate_diff_per(siteAccount.Total_TY_Sales_to_Date,siteAccount.Total_LY_Sales_to_Date);
  siteAccount.Paper_Diff = calculate_diff_per(siteAccount.Paper_TY,siteAccount.Paper_LY);
  siteAccount.Ink_Toner_Diff = calculate_diff_per(siteAccount.Ink_Toner_TY,siteAccount.Ink_Toner_LY);
  siteAccount.Furniture_Diff = calculate_diff_per(siteAccount.Furniture_TY,siteAccount.Furniture_LY);
  siteAccount.CBS_Diff = calculate_diff_per(siteAccount.CBS_TY,siteAccount.CBS_LY);
  siteAccount.CPD_Diff = calculate_diff_per(siteAccount.CPD_TY,siteAccount.CPD_LY);
  siteAccount.Tech_Diff = calculate_diff_per(siteAccount.Tech_TY,siteAccount.Tech_LY);
  siteAccount.Filing_Binding_Diff = calculate_diff_per(siteAccount.Filing_Binding_TY,siteAccount.Filing_Binding_LY);
  siteAccount.Labels_Forms_Diff = calculate_diff_per(siteAccount.Labels_Forms_TY,siteAccount.Labels_Forms_LY);
  siteAccount.Writing_Drafting_Diff = calculate_diff_per(siteAccount.Writing_Drafting_TY,siteAccount.Writing_Drafting_LY);
  siteAccount.MPS_Diff = calculate_diff_per(siteAccount.MPS_TY,siteAccount.MPS_LY);    
  siteAccount.Office_Essentials_Diff = calculate_diff_per(siteAccount.Office_Essentials_TY,siteAccount.Office_Essentials_LY);
  siteAccount.Miscellaneous_Diff = calculate_diff_per(siteAccount.Miscellaneous_TY,siteAccount.Miscellaneous_LY);

   
      
   return results;            
  }
  
  public class SiteAccounts{
      public SiteAccounts(){
        Paper_TY = 0.0; 
        //Paper_IMU_TY_per = 0.0; 
        Paper_LY = 0.0; 
        //paper_IMU_LY_per = 0.0; 
        Paper_Diff = 0.0; 
        //Paper_Pot = 0.0;  
        //Paper_Last_Order_amt = 0.0;
       
       Ink_Toner_TY = 0.0;
       //Ink_Toner_IMU_TY_per = 0.0;
       Ink_Toner_LY = 0.0;
       //Ink_Toner_IMU_LY_per = 0.0;       
       Ink_Toner_Diff = 0.0;
       //Ink_Toner_Pot = 0.0;
     
       //Ink_Toner_Last_Order_amt = 0.0;
      
       Furniture_TY = 0.0;
       //Furniture_IMU_TY_per = 0.0;
       Furniture_LY = 0.0;
       //Furniture_IMU_LY_per = 0.0;  
       Furniture_Diff = 0.0;   
       //Furniture_Pot = 0.0;
       //Furniture_last_order_amt = 0.0;
      
       CBS_TY = 0.0;
       //CBS_IMU_TY_per = 0.0;
       CBS_LY = 0.0;
       //CBS_IMU_LY_per = 0.0;       
       CBS_Diff = 0.0; 
       //CBS_Pot = 0.0;
       //CBS_Last_order_amt = 0.0;
      
       CPD_TY = 0.0;
       //CPD_IMU_TY_per = 0.0;
       CPD_LY = 0.0;
       //CPD_IMU_LY_per = 0.0;
       CPD_Diff = 0.0;
       //CPD_Pot = 0.0;
       //CPD_Last_order_amt = 0.0;
      
       Tech_TY = 0.0;
       //Tech_IMU_TY_per = 0.0;
       Tech_LY = 0.0;
       //Tech_IMU_LY_per = 0.0;      
       Tech_Diff = 0.0;  
       //Tech_Pot = 0.0;
       //Tech_Last_Order_amt = 0.0;
      
       Filing_Binding_TY = 0.0;
       //Filing_Binding_IMU_TY_per = 0.0;
       Filing_Binding_LY = 0.0;
       //Filing_Binding_IMU_LY_per = 0.0;
       Filing_Binding_Diff = 0.0; 
       //Filing_Binding_Pot = 0.0;
       //Filing_Binding_Last_Order_amt = 0.0;
      
       Labels_Forms_TY = 0.0;
       //Labels_Forms_IMU_TY_per = 0.0;
       Labels_Forms_LY = 0.0;
       //Labels_Forms_IMU_LY_per = 0.0;
       Labels_Forms_Diff = 0.0; 
       //Labels_Forms_Pot = 0.0;
       //Labels_Forms_Last_Order_amt = 0.0;
      
      Writing_Drafting_TY = 0.0;
      //Writing_Drafting_IMU_TY_per = 0.0;
      Writing_Drafting_LY = 0.0;
      //Writing_Drafting_IMU_LY_per = 0.0;
      Writing_Drafting_Diff = 0.0;
      //Writing_Drafting_Pot = 0.0;
      //Writing_Drafting_Last_Order_amt = 0.0;
     
      Office_Essentials_TY = 0.0;
      //Office_Essentials_IMU_TY_per = 0.0;
      Office_Essentials_LY = 0.0;
      //Office_Essentials_IMU_LY_per = 0.0;       
      Office_Essentials_Diff = 0.0;
      //Office_Essentials_Pot = 0.0;
      //Office_Essentials_Last_Order_amt = 0.0;
     
      MPS_TY = 0.0;
      //MPS_IMU_TY_per = 0.0;
      MPS_LY = 0.0;
      //MPS_IMU_LY_per = 0.0;
      MPS_Diff = 0.0;
      //MPS_Pot = 0.0;
      //MPS_Last_order_amt = 0.0;
     
    
      Miscellaneous_TY = 0.0;
      //Miscellaneous_IMU_TY_per = 0.0;
      Miscellaneous_LY = 0.0;
      //Miscellaneous_IMU_LY_per = 0.0;
      Miscellaneous_Diff = 0.0;
      //Miscellaneous_Pot = 0.0;
      //Miscellaneous_Last_Order_amt = 0.0;
     
      Total_TY_Sales_to_Date = 0.0;
      //Total_TY_IMU_per = 0.0;
      Total_LY_Sales_to_Date = 0.0;
      //Total_LY_IMU_Per = 0.0;
      Total_Sales_Diff = 0.0;
      //Total_Potential_to_Date = 0.0;
      }
      public Double Paper_TY{get;set;}
      //public Double Paper_IMU_TY_per{get;set;}
      public Double Paper_LY{get;set;}
      //public Double paper_IMU_LY_per{get;set;}
      public Double Paper_Diff{get;set;}
      //public Double Paper_Pot{get;set;}
      //public Date Paper_Last_Order{get;set;}
      //public Double Paper_Last_Order_amt{get;set;}
       
      public Double Ink_Toner_TY{get;set;}
      //public Double Ink_Toner_IMU_TY_per{get;set;}
      public Double Ink_Toner_LY{get;set;}
      //public Double Ink_Toner_IMU_LY_per{get;set;}
      public Double Ink_Toner_Diff{get;set;}
      //public Double Ink_Toner_Pot{get;set;}
      //public Date Ink_Toner_Last_Order{get;set;}
      //public Double Ink_Toner_Last_Order_amt{get;set;}
      
      public Double Furniture_TY{get;set;}
      //public Double Furniture_IMU_TY_per{get;set;}
      public Double Furniture_LY{get;set;}
      //public Double Furniture_IMU_LY_per{get;set;}  
      public Double Furniture_Diff{get;set;}   
      //public Double Furniture_Pot{get;set;}
      //public Date Furniture_Last_Order{get;set;}
      //public Double Furniture_last_order_amt{get;set;}
      
      public Double CBS_TY{get;set;}
      //public Double CBS_IMU_TY_per{get;set;}
      public Double CBS_LY{get;set;}
      //public Double CBS_IMU_LY_per{get;set;}       
      public Double CBS_Diff{get;set;} 
      //public Double CBS_Pot{get;set;}
      //public Date CBS_Last_Order{get;set;}
      //public Double CBS_Last_order_amt{get;set;}
      
      public Double CPD_TY{get;set;}
      //public Double CPD_IMU_TY_per{get;set;}
      public Double CPD_LY{get;set;}
      //public Double CPD_IMU_LY_per{get;set;}
      public Double CPD_Diff{get;set;}
      //public Double CPD_Pot{get;set;}
      //public Date CPD_Last_Order{get;set;}
      //public Double CPD_Last_order_amt{get;set;}
      
      public Double Tech_TY{get;set;}
      //public Double Tech_IMU_TY_per{get;set;}
      public Double Tech_LY{get;set;}
      //public Double Tech_IMU_LY_per{get;set;}      
      public Double Tech_Diff{get;set;}  
      //public Double Tech_Pot{get;set;}
      //public Date Tech_Last_Order{get;set;}
      //public Double Tech_Last_Order_amt{get;set;}
      
      public Double Filing_Binding_TY{get;set;}
      //public Double Filing_Binding_IMU_TY_per{get;set;}
      public Double Filing_Binding_LY{get;set;}
      //public Double Filing_Binding_IMU_LY_per{get;set;}
      public Double Filing_Binding_Diff{get;set;} 
      //public Double Filing_Binding_Pot{get;set;}
      //public Date Filing_Binding_Last_Order{get;set;}
      //public Double Filing_Binding_Last_Order_amt{get;set;}
      
      public Double Labels_Forms_TY{get;set;}
      //public Double Labels_Forms_IMU_TY_per{get;set;}
      public Double Labels_Forms_LY{get;set;}
      //public Double Labels_Forms_IMU_LY_per{get;set;}
      public Double Labels_Forms_Diff{get;set;} 
      //public Double Labels_Forms_Pot{get;set;}
      //public Date Labels_Forms_Last_Order{get;set;}
      //public Double Labels_Forms_Last_Order_amt{get;set;}
      
     public Double Writing_Drafting_TY{get;set;}
     //public Double Writing_Drafting_IMU_TY_per{get;set;}
     public Double Writing_Drafting_LY{get;set;}
     //public Double Writing_Drafting_IMU_LY_per{get;set;}
     public Double Writing_Drafting_Diff{get;set;}
     //public Double Writing_Drafting_Pot{get;set;}
     //public Date Writing_Drafting_Last_Order{get;set;}
     //public Double Writing_Drafting_Last_Order_amt{get;set;}
     
     public Double Office_Essentials_TY{get;set;}
     //public Double Office_Essentials_IMU_TY_per{get;set;}
     public Double Office_Essentials_LY{get;set;}
     //public Double Office_Essentials_IMU_LY_per{get;set;}       
     public Double Office_Essentials_Diff{get;set;}
     //public Double Office_Essentials_Pot{get;set;}
     //public Date Office_Essentials_Last_Order{get;set;}
     //public Double Office_Essentials_Last_Order_amt{get;set;}
     
     public Double MPS_TY{get;set;}
     //public Double MPS_IMU_TY_per{get;set;}
     public Double MPS_LY{get;set;}
     //public Double MPS_IMU_LY_per{get;set;}
     public Double MPS_Diff{get;set;}
     //public Double MPS_Pot{get;set;}
     //public Date MPS_Last_Order{get;set;}
     //public Double MPS_Last_order_amt{get;set;}
     
    
     public Double Miscellaneous_TY{get;set;}
     //public Double Miscellaneous_IMU_TY_per{get;set;}
     public Double Miscellaneous_LY{get;set;}
     //public Double Miscellaneous_IMU_LY_per{get;set;}
     public Double Miscellaneous_Diff{get;set;}
     //public Double Miscellaneous_Pot{get;set;}
     //public Date Miscellaneous_Last_Order{get;set;}
     //public Double Miscellaneous_Last_Order_amt{get;set;}
     
     public Double Total_TY_Sales_to_Date{get;set;}
     //public Double Total_TY_IMU_per{get;set;}
     public Double Total_LY_Sales_to_Date{get;set;}
     //public Double Total_LY_IMU_Per{get;set;}
     public Double Total_Sales_Diff{get;set;}
     //public Double Total_Potential_to_Date{get;set;}
     
  }  
}