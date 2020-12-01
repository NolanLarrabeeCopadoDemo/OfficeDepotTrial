public class ACEReporting_RevMarg_WaterFall_Overview{
    
    public class OverviewData {
     public String formatType {get;set;}
     Public String UrlType{get;set;}
     public String dataType {get;set;}
     public Decimal Initial {get;set;}
     public Decimal ContractErosion{get;set;}
     public Decimal EligibleCustomers{get;set;}//sfdc 861332
     public Decimal SalesErosion{get;set;}
     public Decimal SalesRemediationErosion{get;set;}//sfdc 861332
     public Decimal Implemented{get;set;}
     public Decimal Percentage {get;set;}
    }
    
    public list<OverviewData> ovd {get;set;}
    public Map<String,String> fmt;
    
    public double ImpRevPassThru;
    public double ImpMargPassThru ;
    public double pricePassErosion;
    public double TimePassErosion;
    public double ExposureDaysInitial ;
    public double ExposureDaysSaleErosion ;
    public double ExposureDaysEarlySaleErosion ;
    public double ExposureDaysDateExceptErosion ;
	  
    public String AccessLevel{get;set;}
    public String quarterValue{get;set;}
    public List<ACE_Customer_Price_Changes__c> custList;
    
    public ACEReporting_RevMarg_WaterFall_Overview(){
		        
        system.debug('Entered the Constructor:ACEReporting_RevMarg_WaterFall_Overview>>>>>><<<<<<<<'+quarterValue);
        
        ACE_Batches__c bt = [SELECT Id, Batch__c FROM ACE_Batches__c order by CreatedDate desc limit 1];
        quarterValue = bt.Batch__c;
        
        system.debug('Quarter Value:>>>>>><<<<<<<<'+quarterValue);
       
        //Setting Access Level
        AccessLevel = 'General';
        
        //User Hierarchy code - Starts
        For (Group g : [select id,name from group where name in ('Sales Ops Team')]){ 
            system.debug('<<<<<<<<<<<<>>>>>>>>>>');
             for (groupMember gm : [SELECT id from groupmember where groupid = :g.id and UserOrGroupId = :userinfo.getUserId()]) {
                AccessLevel = 'SalesOps'; 
                system.debug('AccessLevel:<<<<<<<<<<<<>>>>>>>>>>'+AccessLevel);       
             }
        }
        
        CustHeirData();  
        
        //loadData(); 
        
        loadData_1(); 
    }        
    public void CustHeirData(){
    	system.debug('CustHeirData:Entered the Function....');
    	//for initial Customr list
        custList = new List<ACE_Customer_Price_Changes__c>();        
                
        if(AccessLevel == 'General'){
            system.debug('AccessLevel:<<<<<<<GENERAL>>>>>>>>>>'); 
            List<User> userList = new List<User>();
            ACE_User_Cust_Hierarchy_Controller obj = new ACE_User_Cust_Hierarchy_Controller();
            UserList = obj.lUserList;
            system.debug('ownerlist:' + UserList);
            Set<ID> ownerList = new Set<ID>();
            for(User u : UserList)
            {
                ownerList.add(u.id);
            }                    
            
            //Collection of customers
            Set<ID> sID_ACE_Price_ID = new Set<ID>();
            system.debug('Total Users:' + ownerlist.size());
            sID_ACE_Price_ID = obj.CustomerPriceChangeRecs(ownerList,'All',quarterValue);
            system.debug('Total Customers To Collect:' + sID_ACE_Price_ID.size());
            custList = [select id from ACE_Customer_Price_Changes__c where id in:sID_ACE_Price_ID]; 
        }
        else{
            system.debug('AccessLevel:<<<<<<<<<<<<SALES OPS>>>>>>>>>>'); 
            custList = [select id from ACE_Customer_Price_Changes__c where Name=: quarterValue]; 
        }
        
        system.debug('Customers Returned from Hierarchy:' + custList.size());
        system.debug('CustHeirData:Leaving the Function....');       
    
    }
    
     public void loadData_1(){ 
         
        system.debug('loadData_1:Entered the Function....');
        //Pull the customers based on hier
        CustHeirData(); 
        system.debug('Customers Recieved from Hierarchy:' + custList.size());
         
        ovd = new list<OverviewData>();
        Map<String,OverviewData> MAP_ReportData = new Map<String,OverviewData>();
         
        //Calculations for Intial column  
        //AggregateResult[] Results = [select count(id) custCnt 
        //                               from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList ];
        AggregateResult[] Results = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id) custCnt
                                      from Ace_Customer_SKU_Changes__c 
                                      where batchid__c =: quarterValue and
                                      Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList];                                         
        system.debug('Initial Column:1st row: custCnt'+ Double.ValueOf(Results[0].get('custCnt')));
         
        AggregateResult[] Results_2 = [select count(id) skucnt_c_type, sum(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru_c_type
                                      from Ace_Customer_SKU_Changes__c 
                                      where batchid__c =: quarterValue and Price_Change_Type__c = 'C' and
                                      Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList];
        
        system.debug('Initial Column:2nd row: skucnt_c_type:'+ Double.ValueOf(Results_2[0].get('skucnt_c_type')) +' Rev_PassThru_c_type:'+ Double.ValueOf(Results_2[0].get('Rev_PassThru_c_type')));
         
        AggregateResult[] Results_3 = [select count(id) skucnt_m_type, sum(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru_m_type
                                      from Ace_Customer_SKU_Changes__c 
                                      where batchid__c =: quarterValue and Price_Change_Type__c = 'M' and
                                      Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList];
        
        system.debug('Initial Column:3rd row: skucnt_m_type:'+ Double.ValueOf(Results_3[0].get('skucnt_m_type')) +' Rev_PassThru_m_type:'+ Double.ValueOf(Results_3[0].get('Rev_PassThru_m_type')));
         
       
        AggregateResult[] Results_4 = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id)  custCnt_c_type
                                      from Ace_Customer_SKU_Changes__c 
                                      where batchid__c =: quarterValue and Price_Change_Type__c = 'C' and
                                      Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false];
        
        system.debug('Initial Column:4th row: custCnt_c_type:'+ Double.ValueOf(Results_4[0].get('custCnt_c_type')));
         
        AggregateResult[] Results_5 = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id)  custCnt_m_type
                                      from Ace_Customer_SKU_Changes__c 
                                      where batchid__c =: quarterValue and Price_Change_Type__c = 'M' and
                                      Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false];
        
        system.debug('Initial Column:5th row: custCnt_m_type:'+ Double.ValueOf(Results_5[0].get('custCnt_m_type')));
         
        AggregateResult[] Results_6 = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id)  custCnt_c_type
                                      from Ace_Customer_SKU_Changes__c 
                                      where batchid__c =: quarterValue and Price_Change_Type__c = 'C' and
                                      Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c=false];
        
        system.debug('Initial Column:6th row: custCnt_c_type:'+ Double.ValueOf(Results_6[0].get('custCnt_c_type')));
  
         
        //Calculations for (Erosion Due to Contract Terms) column
        //AggregateResult[] Total = [select count(id) CTcnt from ACE_Customer_Price_Changes__c where Name=: quarterValue 
        //                           and id in:custList and (PRICE_NOT_CALCULATED__c= true or Update_Timing_Action__c = 'F')];
        AggregateResult[] Total = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id) custCnt
                                      from Ace_Customer_SKU_Changes__c 
                                      where batchid__c =: quarterValue and
                                      Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      (Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= true or 
                                       Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'F')];
        system.debug('Erosion ct column:1st row: custCnt:'+ Double.ValueOf(Total[0].get('custCnt')) );
         
        AggregateResult[] Total_2 = [select count(id) skucnt_c_type, sum(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru_c_type
                                      from Ace_Customer_SKU_Changes__c 
                                      where batchid__c =: quarterValue and Price_Change_Type__c = 'C' and 
                                     (Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= true  or 
                                      Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'F')
                                      and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList ];
         
        system.debug('Erosion ct column:2ndh row: skucnt_c_type:'+ Double.ValueOf(Total_2[0].get('skucnt_c_type')) +' Rev_PassThru_c_type:'+ Double.ValueOf(Total_2[0].get('Rev_PassThru_c_type')));
         
        AggregateResult[] Total_3 = [select count(id) skucnt_m_type, sum(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru_m_type
                                      from Ace_Customer_SKU_Changes__c 
                                      where batchid__c =: quarterValue and Price_Change_Type__c = 'M' and 
                                     (Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= true  or 
                                      Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'F')
                                      and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList ];
         
        system.debug('Erosion ct column:3rd row: skucnt_m_type:'+ Double.ValueOf(Total_3[0].get('skucnt_m_type')) +' Rev_PassThru_m_type:'+ Double.ValueOf(Total_3[0].get('Rev_PassThru_m_type')));

        AggregateResult[] Total_4 = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id)  custCnt_c_type
                                      from Ace_Customer_SKU_Changes__c 
                                      where batchid__c =: quarterValue and Price_Change_Type__c = 'C' and 
                                     (Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= true  or 
                                      Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'F')
                                      and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false];
         
        system.debug('Erosion ct column:4th row: custCnt_c_type:'+ Double.ValueOf(Total_4[0].get('custCnt_c_type')) );
         
        AggregateResult[] Total_5 = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id)  custCnt_m_type
                                      from Ace_Customer_SKU_Changes__c 
                                      where batchid__c =: quarterValue and Price_Change_Type__c = 'M' and 
                                     (Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= true  or 
                                      Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'F')
                                      and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false];
         
        system.debug('Erosion ct column:5th row: custCnt_m_type:'+ Double.ValueOf(Total_5[0].get('custCnt_m_type')));

        AggregateResult[] Total_6 = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id)  custCnt_c_type
                                      from Ace_Customer_SKU_Changes__c 
                                      where batchid__c =: quarterValue and Price_Change_Type__c = 'C' and 
                                     (Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= true  or 
                                      Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'F')
                                      and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c=false];
         
        system.debug('Erosion ct column:6th row: custCnt_c_type:'+ Double.ValueOf(Total_6[0].get('custCnt_c_type')) );
 
        //Calculations for EligibleCustomers column
        //AggregateResult[] Elig_Cust = [select count(id) cnt
        //                               from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList
        //                               and (Update_Timing_Action__c = 'T' and PRICE_NOT_CALCULATED__c= false)];
        AggregateResult[] Elig_Cust = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id) custCnt
                                      from Ace_Customer_SKU_Changes__c 
                                      where batchid__c =: quarterValue and
                                      Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      (Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'T' and 
                                       Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= false)];                              
        system.debug('Elig cust column:1st row: custcnt:'+ Double.ValueOf(Elig_Cust[0].get('custCnt')));
         
        AggregateResult[] Elig_Cust_2 = [select count(id) skucnt_c_type, 
                                        sum(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru_c_type
                                      	from Ace_Customer_SKU_Changes__c where batchid__c =: quarterValue 
                                        and Price_Change_Type__c = 'C' and 
                                        (Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'T' and 
                                         Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= false) 
                                        and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList];
        system.debug('Elig cust column:2nd row: skucnt_c_type:'+ Double.ValueOf(Elig_Cust_2[0].get('skucnt_c_type')) +' Rev_PassThru_c_type:'+ Double.ValueOf(Elig_Cust_2[0].get('Rev_PassThru_c_type')));
         
        AggregateResult[] Elig_Cust_3 = [select count(id) skucnt_m_type, 
                                        sum(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru_m_type
                                      	from Ace_Customer_SKU_Changes__c where batchid__c =: quarterValue 
                                        and Price_Change_Type__c = 'M' and 
                                        (Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'T' and 
                                         Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= false)
                                        and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList];
        system.debug('Elig cust column:3rd row: skucnt_m_type:'+ Double.ValueOf(Elig_Cust_3[0].get('skucnt_m_type')) +' Rev_PassThru_m_type:'+ Double.ValueOf(Elig_Cust_3[0].get('Rev_PassThru_m_type')));
        
        AggregateResult[] Elig_Cust_4 = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id) custCnt_c_type
                                         from Ace_Customer_SKU_Changes__c where batchid__c =: quarterValue 
                                         and Price_Change_Type__c = 'C' and 
                                         (Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'T' and
                                          Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= false) 
                                         and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                         ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false];
        system.debug('Elig cust column:4th row: custCnt_c_type:'+ Double.ValueOf(Elig_Cust_4[0].get('custCnt_c_type')) );
         
        AggregateResult[] Elig_Cust_5 = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id) custCnt_m_type 
                                         from Ace_Customer_SKU_Changes__c where batchid__c =: quarterValue 
                                         and Price_Change_Type__c = 'M' and 
                                         (Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'T' and
                                          Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= false) 
                                         and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                         ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false];
        system.debug('Elig cust column:5th row: custCnt_m_type:'+ Double.ValueOf(Elig_Cust_5[0].get('custCnt_m_type')) );
         
        AggregateResult[] Elig_Cust_6 = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id) custCnt_c_type 
                                         from Ace_Customer_SKU_Changes__c where batchid__c =: quarterValue 
                                         and Price_Change_Type__c = 'C' and 
                                         (Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Update_Timing_Action__c = 'T' and
                                          Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.PRICE_NOT_CALCULATED__c= false) 
                                         and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                         ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c=false];
        system.debug('Elig cust column:6th row: custCnt_c_type:'+ Double.ValueOf(Elig_Cust_6[0].get('custCnt_c_type')) );
        
        //Calculations for Erosion due to sales decisions
        //AggregateResult[] SKUDeletedCust = [select count(id) cnt                                            
         //                                   from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and 
         //                                   (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true)];
        AggregateResult[] SKUDeletedCust = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id) custCnt
                                      		from Ace_Customer_SKU_Changes__c 
                                      		where batchid__c =: quarterValue and
                                      		Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                            (ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true 
                                            OR ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c =true)];
         									
        system.debug('Erosion due to sales column:1st row: custcnt:'+ Double.ValueOf(SKUDeletedCust[0].get('custCnt')));
         
        AggregateResult[] SKUDeletedCust_2 = [select count(id) skucnt_c_type, sum(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru_c_type
                                              from Ace_Customer_SKU_Changes__c 
                                              where batchid__c =: quarterValue and 
                                              Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                              Price_Change_Type__c = 'C' and
                                          	  (ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true 
                                              OR ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c =true)];
        system.debug('Erosion due to sales Column:2nd row: skucnt_c_type:'+ Double.ValueOf(SKUDeletedCust_2[0].get('skucnt_c_type')) +' Rev_PassThru_c_type:'+ Double.ValueOf(SKUDeletedCust_2[0].get('Rev_PassThru_c_type')));
         
         
     	AggregateResult[] SKUDeletedCust_3 = [select count(id) skucnt_m_type, sum(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru_m_type
                                              from Ace_Customer_SKU_Changes__c 
                                              where batchid__c =: quarterValue and 
                                              Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                              Price_Change_Type__c = 'M' and
                                          	  (ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true 
                                              OR ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c =true)];
        
        system.debug('Erosion due to sales Column:3rd row: skucnt_m_type:'+ Double.ValueOf(SKUDeletedCust_3[0].get('skucnt_m_type')) +' Rev_PassThru_m_type:'+ Double.ValueOf(SKUDeletedCust_3[0].get('Rev_PassThru_m_type')));
         
        AggregateResult[] SKUDeletedCust_4 = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id) custCnt_c_type 
                                              from Ace_Customer_SKU_Changes__c 
                                              where batchid__c =: quarterValue and 
                                              Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                              Price_Change_Type__c = 'C' and
                                          	  //(ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true or//price exception 
                                               ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c =true and//date exception
                                              ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false];//no price exception
        system.debug('Erosion due to sales Column:4th row: custCnt_c_type:'+ Double.ValueOf(SKUDeletedCust_4[0].get('custCnt_c_type')) );
         
         
     	AggregateResult[] SKUDeletedCust_5 = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id) custCnt_m_type 
                                              from Ace_Customer_SKU_Changes__c 
                                              where batchid__c =: quarterValue and 
                                              Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                              Price_Change_Type__c = 'M' and
                                          	  //(ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true or//price exception 
                                              ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c =true and//date exception
                                              ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false];//no price exception         
        system.debug('Erosion due to sales Column:5th row: custCnt_m_type:'+ Double.ValueOf(SKUDeletedCust_5[0].get('custCnt_m_type')) );
        
        AggregateResult[] SKUDeletedCust_6 = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id) custCnt_c_type 
                                              from Ace_Customer_SKU_Changes__c 
                                              where batchid__c =: quarterValue and 
                                              Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                              Price_Change_Type__c = 'C' and
                                          	  ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true and//price exception 
                                              //OR ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c =true) and//date exception
                                              ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c=false];//no date exception
        system.debug('Erosion due to sales Column:6th row: custCnt_c_type:'+ Double.ValueOf(SKUDeletedCust_6[0].get('custCnt_c_type')) );
          
         
		//Calculations for SalesRemediationErosion column
        //AggregateResult[] SalesRemediation_Erosion = [select count(id) cnt
        //                               					from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList
        //                               					and Report_isSKU_Exception__c=true];
        AggregateResult[] SalesRemediation_Erosion = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id) custCnt
                                      					from Ace_Customer_SKU_Changes__c 
                                      					where batchid__c =: quarterValue and
                                      					Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                                      	ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true];
         
        system.debug('SalesRemediationErosion column:1st row: custcnt:'+ Double.ValueOf(SalesRemediation_Erosion[0].get('custCnt')));
         
        AggregateResult[] SalesRemediation_Erosion_2 = [select count(id) skucnt_c_type, sum(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru_c_type
                                              from Ace_Customer_SKU_Changes__c 
                                              where batchid__c =: quarterValue and 
                                              Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                              Price_Change_Type__c = 'C' and
                                          	  ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true];
        system.debug('SalesRemediationErosion Column:2nd row: skucnt_c_type:'+ Double.ValueOf(SalesRemediation_Erosion_2[0].get('skucnt_c_type')) +' Rev_PassThru_c_type:'+ Double.ValueOf(SalesRemediation_Erosion_2[0].get('Rev_PassThru_c_type')));

		AggregateResult[] SalesRemediation_Erosion_3 = [select count(id) skucnt_m_type, sum(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru_m_type
                                              from Ace_Customer_SKU_Changes__c 
                                              where batchid__c =: quarterValue and 
                                              Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                              Price_Change_Type__c = 'M' and
                                          	  ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true];
        system.debug('SalesRemediationErosion Column:3rd row: skucnt_m_type:'+ Double.ValueOf(SalesRemediation_Erosion_3[0].get('skucnt_m_type')) +' Rev_PassThru_m_type:'+ Double.ValueOf(SalesRemediation_Erosion_3[0].get('Rev_PassThru_m_type')));

        AggregateResult[] SalesRemediation_Erosion_6 = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id) custCnt_c_type 
                                              from Ace_Customer_SKU_Changes__c 
                                              where batchid__c =: quarterValue and 
                                              Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                              Price_Change_Type__c = 'C' and
                                          	  ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=true and //price exception
                                              ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c=false];//no date exception
        system.debug('SalesRemediationErosion Column:6th row: custCnt_c_type:'+ Double.ValueOf(SalesRemediation_Erosion_6[0].get('custCnt_c_type')) );

        //Calculations for Implemented column
        //Integer Impcount = Integer.valueof(Results[0].get('custcnt')) - (0+Integer.valueof(SKUDeletedCust[0].get('cnt')));
        //AggregateResult[] Impcount = [select count(id) cnt                                            
        //                                    from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and 
        //                                    (Update_Timing_Action__c = 'T' and PRICE_NOT_CALCULATED__c= false) and
        // 									Report_SKU_Count__c < 1 ];
        AggregateResult[] Impcount = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id) custCnt
                                      from Ace_Customer_SKU_Changes__c 
                                      where batchid__c =: quarterValue and
                                      Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                      (ace_customer_core_changes__r.ace_customer_price_changes__r.Update_Timing_Action__c = 'T' and 
                                      ace_customer_core_changes__r.ace_customer_price_changes__r.PRICE_NOT_CALCULATED__c= false) and
                                      ace_customer_core_changes__r.ace_customer_price_changes__r.Report_SKU_Count__c < 1];
        system.debug('Implemented column:1st row: custcnt:'+ Double.ValueOf(Impcount[0].get('custCnt')));
         
        AggregateResult[] Impcount_2 = [select count(id) skucnt_c_type, sum(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru_c_type
                                              from Ace_Customer_SKU_Changes__c 
                                              where batchid__c =: quarterValue and 
                                              Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                              Price_Change_Type__c = 'C' and
                                          	  (ace_customer_core_changes__r.ace_customer_price_changes__r.Update_Timing_Action__c = 'T' and 
                                               ace_customer_core_changes__r.ace_customer_price_changes__r.PRICE_NOT_CALCULATED__c= false) and
         									  ace_customer_core_changes__r.ace_customer_price_changes__r.Report_SKU_Count__c < 1];
        system.debug('Implemented Column:2nd row: skucnt_c_type:'+ Double.ValueOf(Impcount_2[0].get('skucnt_c_type')) +' Rev_PassThru_c_type:'+ Double.ValueOf(Impcount_2[0].get('Rev_PassThru_c_type')));

        AggregateResult[] Impcount_3 = [select count(id) skucnt_m_type, sum(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru_m_type
                                              from Ace_Customer_SKU_Changes__c 
                                              where batchid__c =: quarterValue and 
                                              Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                              Price_Change_Type__c = 'M' and
                                          	  (ace_customer_core_changes__r.ace_customer_price_changes__r.Update_Timing_Action__c = 'T' and 
                                              ace_customer_core_changes__r.ace_customer_price_changes__r.PRICE_NOT_CALCULATED__c= false) and
         									  ace_customer_core_changes__r.ace_customer_price_changes__r.Report_SKU_Count__c < 1];
        system.debug('Implemented Column:3rd row: skucnt_m_type:'+ Double.ValueOf(Impcount_3[0].get('skucnt_m_type')) +' Rev_PassThru_m_type:'+ Double.ValueOf(Impcount_3[0].get('Rev_PassThru_m_type')));

        AggregateResult[] Impcount_4 = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id) custCnt_c_type 
                                              from Ace_Customer_SKU_Changes__c 
                                              where batchid__c =: quarterValue and 
                                              Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                              Price_Change_Type__c = 'C' and
                                          	  (ace_customer_core_changes__r.ace_customer_price_changes__r.Update_Timing_Action__c = 'T' and 
                                               ace_customer_core_changes__r.ace_customer_price_changes__r.PRICE_NOT_CALCULATED__c= false) and
         									  ace_customer_core_changes__r.ace_customer_price_changes__r.Report_SKU_Count__c < 1 and
                                       		  ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false];
        system.debug('Implemented Column:4th row: custCnt_c_type:'+ Double.ValueOf(Impcount_4[0].get('custCnt_c_type')) );

        AggregateResult[] Impcount_5 = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id) custCnt_m_type 
                                              from Ace_Customer_SKU_Changes__c 
                                              where batchid__c =: quarterValue and 
                                              Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                              Price_Change_Type__c = 'M' and
                                          	  (ace_customer_core_changes__r.ace_customer_price_changes__r.Update_Timing_Action__c = 'T' and 
                                              ace_customer_core_changes__r.ace_customer_price_changes__r.PRICE_NOT_CALCULATED__c= false) and
         									  ace_customer_core_changes__r.ace_customer_price_changes__r.Report_SKU_Count__c < 1 and
                                              ace_customer_core_changes__r.ace_customer_price_changes__r.Report_isSKU_Exception__c=false];
        system.debug('Implemented Column:5th row: custCnt_m_type:'+ Double.ValueOf(Impcount_5[0].get('custCnt_m_type')) );
 
         AggregateResult[] Impcount_6 = [select count_distinct(ace_customer_core_changes__r.ace_customer_price_changes__r.id) custCnt_c_type 
                                              from Ace_Customer_SKU_Changes__c 
                                              where batchid__c =: quarterValue and 
                                              Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in:custList and
                                              Price_Change_Type__c = 'C' and
                                          	  (ace_customer_core_changes__r.ace_customer_price_changes__r.Update_Timing_Action__c = 'T' and 
                                              ace_customer_core_changes__r.ace_customer_price_changes__r.PRICE_NOT_CALCULATED__c= false) and
         									  ace_customer_core_changes__r.ace_customer_price_changes__r.Report_SKU_Count__c < 1 and
                                              ace_customer_core_changes__r.ace_customer_price_changes__r.EffectiveDate_IsDifferent__c=false];
        system.debug('Implemented Column:6th row: custCnt_c_type:'+ Double.ValueOf(Impcount_6[0].get('custCnt_c_type')) );

        //=================================//
        list<String> dTypes = new list<String> {'Customers with Increases','Revenue Pass Through (Cost Increase)', 'Revenue Pass Through (Margin Play)', 'Customers with 100% Price Pass Through (Cost Increase)','Customers with 100% Price Pass Through (Margin Play)','Customers with 100% Pass Through on Time Implementation (Cost Increase)'};
        //list<String> dTypes = new list<String> {'Customers with Increases','Revenue Pass Through(Cost Increase)','Revenue Pass Through(Margin Play)','Customers with 100% Price Pass Through(Cost Increase)','Customers with 100% Price Pass Through(Margin Play)','Customers with 100% Pass Through on Time Implementation(Cost Increase)','Exposure Days(Cost Increase)','Exposure Reduction from Early Release(Cost Increase)','Exposure Increases from Date Exception(Cost Increase)'};         
        fmt = new Map<String,String> ();        
        fmt.put('Customers with Increases','{0, number, ###}');
        fmt.put('Revenue Pass Through (Cost Increase)','${0, number, ###,###,###,##0.00}');
        fmt.put('Revenue Pass Through (Margin Play)','${0, number, ###,###,###,##0.00}');
        fmt.put('Customers with 100% Price Pass Through (Cost Increase)','{0, number, ###}');
        fmt.put('Customers with 100% Price Pass Through (Margin Play)','{0, number, ###}');
        fmt.put('Customers with 100% Pass Through on Time Implementation (Cost Increase)','{0, number, ###}');
        /*fmt.put('Exposure Days(Cost Increase)','{0, number, ###}');
        fmt.put('Exposure Increases from Date Exception(Cost Increase)','{0, number, ###}');//sfdc 861332
        fmt.put('Exposure Reduction from Early Release(Cost Increase)','{0, number, ###}');*/
        //=================================//
         
        //Creating the first line on the report-----Customers with Increases
        OverviewData o1 = new OverviewData();
        o1.dataType = 'Customers with Increases';
        o1.UrlType = 'Customers with Increases';
        o1.formatType = fmt.get('Customers with Increases');
        
        if(Results[0].get('custCnt') != null)
        	o1.Initial = Double.ValueOf(Results[0].get('custCnt'));
        else
            o1.Initial = 0;
         
        //----------
        if(Total[0].get('custCnt') != null)
            o1.ContractErosion = (decimal)Total[0].get('custCnt');
        else
            o1.ContractErosion = 0;
         
		//----------
		if(Elig_Cust[0].get('custCnt') != null)            
        	o1.EligibleCustomers = Double.ValueOf(Elig_Cust[0].get('custCnt'));        
        else
            o1.EligibleCustomers = 0;
         
        //---------
        o1.SalesErosion = Integer.valueof(SKUDeletedCust[0].get('custCnt'));        
        
        //---------
        if(SalesRemediation_Erosion[0].get('custCnt') != null)
        	o1.SalesRemediationErosion = Double.ValueOf(SalesRemediation_Erosion[0].get('custCnt'));                            
        else
            o1.SalesRemediationErosion = 0;
         
         o1.Implemented = Double.ValueOf(Impcount[0].get('custCnt'));
         
        //----------
        if(o1.Initial != null && o1.Initial != 0)
            o1.Percentage = (o1.Implemented/o1.Initial)*100;
        else
            o1.Percentage = 0;
        //-----------------------------------------
        MAP_ReportData.put('Customers with Increases',o1);
        
        //Creating the 2nd line on the report----//Revenue Pass Trough (Cost Increase)
        OverviewData o2 = new OverviewData();
        o2.UrlType = 'Revenue Pass Through (Cost Increase)';
        o2.dataType = 'Revenue Pass Through (Cost Increase)';
        o2.formatType = fmt.get('Revenue Pass Through (Cost Increase)');
         
         
        if(Results_2[0].get('Rev_PassThru_c_type') != null)
        	o2.Initial = Double.ValueOf(Results_2[0].get('Rev_PassThru_c_type'));
        else
            o2.Initial = 0;
        //----------
        if(Total_2[0].get('Rev_PassThru_c_type') != null)
            o2.ContractErosion = (decimal)Total_2[0].get('Rev_PassThru_c_type');
        else
            o2.ContractErosion = 0;
         
        //-------
        if(Elig_Cust_2[0].get('Rev_PassThru_c_type') != null)
        	o2.EligibleCustomers = Double.ValueOf(Elig_Cust_2[0].get('Rev_PassThru_c_type'));          
        else 
            o2.EligibleCustomers = 0;
         
        //----------               
        if(SKUDeletedCust_2[0].get('Rev_PassThru_c_type') != null)
            o2.SalesErosion = double.valueof(SKUDeletedCust_2[0].get('Rev_PassThru_c_type'));
        else
            o2.SalesErosion = 0;       
        
        //------------
        if(SalesRemediation_Erosion_2[0].get('Rev_PassThru_c_type') != null)
        	o2.SalesRemediationErosion = Double.ValueOf(SalesRemediation_Erosion_2[0].get('Rev_PassThru_c_type'));
        else
            o2.SalesRemediationErosion = 0;        
        //----------
        
        //----------
        if(Impcount_2[0].get('Rev_PassThru_c_type') != null)
        	o2.Implemented = Double.ValueOf(Impcount_2[0].get('Rev_PassThru_c_type'));
        else
            o2.Implemented = 0;           
        //----------
        if(o2.Initial != null && o2.Initial != 0)
            o2.Percentage = (o2.Implemented/o2.Initial)*100;
        else
            o2.Percentage = 0;
        //----------
        MAP_ReportData.put('Revenue Pass Through (Cost Increase)',o2); 
        
         
        //Creating the 3rd  line on the report----//Revenue Pass Trough(Margin Play)        
        OverviewData o3 = new OverviewData();
        o3.UrlType = 'Revenue Pass Through (Margin Play)';
        o3.dataType = 'Revenue Pass Through (Margin Play)';
        o3.formatType = fmt.get('Revenue Pass Through (Margin Play)');
        
        if(Results_3[0].get('Rev_PassThru_m_type') != null)
        	o3.Initial = Double.ValueOf(Results_3[0].get('Rev_PassThru_m_type'));
        else
            o3.Initial = 0;
        //------------
        if(Total_3[0].get('Rev_PassThru_m_type') != null)
            o3.ContractErosion = (decimal)Total_3[0].get('Rev_PassThru_m_type');
        else
            o3.ContractErosion = 0;
        //-----------             
        if(Elig_Cust_3[0].get('Rev_PassThru_m_type') != null)
        	o3.EligibleCustomers = Double.ValueOf(Elig_Cust_3[0].get('Rev_PassThru_m_type'));           
        else 
            o3.EligibleCustomers = 0;         
        //----------- 
        if(SKUDeletedCust_3[0].get('Rev_PassThru_m_type') != null)
            o3.SalesErosion = double.valueof(SKUDeletedCust_3[0].get('Rev_PassThru_m_type'));
        else
            o3.SalesErosion = 0;           
        //------------
        if(SalesRemediation_Erosion_3[0].get('Rev_PassThru_m_type') != null)
        	o3.SalesRemediationErosion = Double.ValueOf(SalesRemediation_Erosion_3[0].get('Rev_PassThru_m_type'));
        else
            o3.SalesRemediationErosion = 0;        
        
        //----------------
        //----------
        if(Impcount_3[0].get('Rev_PassThru_m_type') != null)
        	o3.Implemented = Double.ValueOf(Impcount_3[0].get('Rev_PassThru_m_type'));
        else
            o3.Implemented = 0; 
         
        //----------
        if(o3.Initial != null && o3.Initial != 0)
            o3.Percentage = (o3.Implemented/o3.Initial)*100;
        else
            o3.Percentage = 0;
        //-------------------
        MAP_ReportData.put('Revenue Pass Through (Margin Play)',o3);
         
        //Creating the 4th line on the report----//Customers with 100% Price Pass Through (Cost Increase)        
        OverviewData o4 = new OverviewData();
        o4.UrlType = '100PercentPricePassThru (Cost Increase)';
        o4.dataType = 'Customers with 100% Price Pass Through (Cost Increase)';
        o4.formatType = fmt.get('Customers with 100% Price Pass Through (Cost Increase)');
         
        if(Results_4[0].get('custCnt_c_type') != null)
        	o4.Initial = Double.ValueOf(Results_4[0].get('custCnt_c_type'));
        else
            o4.Initial = 0;
        //-------
        if(Total_4[0].get('custCnt_c_type') != null)
            o4.ContractErosion = (decimal)Total_4[0].get('custCnt_c_type');
        else
            o4.ContractErosion = 0;                     
        //-----------
        if(Elig_Cust_4[0].get('custCnt_c_type') != null)
        	o4.EligibleCustomers = Double.ValueOf(Elig_Cust_4[0].get('custCnt_c_type'));           
        else 
           o4.EligibleCustomers = 0;
        //-----------
        if(SKUDeletedCust_4[0].get('custCnt_c_type') != null)
        	o4.SalesErosion = Double.ValueOf(SKUDeletedCust_4[0].get('custCnt_c_type'));           
        else 
           o4.SalesErosion = 0;
        //------------  
        o4.SalesRemediationErosion = 0;        
        //----------
        if(Impcount_4[0].get('custCnt_c_type') != null)
        	o4.Implemented = Double.ValueOf(Impcount_4[0].get('custCnt_c_type'));
        else
            o4.Implemented = 0; 
        //-------
        if(o4.Initial != null && o4.Initial != 0)
            o4.Percentage = (o4.Implemented/o4.Initial)*100;
        else
            o4.Percentage = 0;
        //----------
        MAP_ReportData.put('Customers with 100% Price Pass Through (Cost Increase)',o4); 
         
        //Creating the 4th line on the report----//Customers with 100% Price Pass Through (Margin Play)        
        OverviewData o5 = new OverviewData();
        o5.UrlType = '100PercentPricePassThru (Margin Play)';
        o5.dataType = 'Customers with 100% Price Pass Through (Margin Play)';
        o5.formatType = fmt.get('Customers with 100% Price Pass Through (Margin Play)');
        if(Double.ValueOf(Results_5[0].get('custCnt_m_type')) != null)
        	o5.Initial = Double.ValueOf(Results_5[0].get('custCnt_m_type'));
        else
            o5.Initial = 0;
        //-------
        if(Total_5[0].get('custCnt_m_type') != null)
            o5.ContractErosion = (decimal)Total_5[0].get('custCnt_m_type');
        else
            o5.ContractErosion = 0;                     
        //-----------
        if(Elig_Cust_5[0].get('custCnt_m_type') != null)
        	o5.EligibleCustomers = Double.ValueOf(Elig_Cust_5[0].get('custCnt_m_type'));           
        else 
            o5.EligibleCustomers = 0;
        //---------------        
        if(SKUDeletedCust_5[0].get('custCnt_m_type') != null)
        	o5.SalesErosion = Double.ValueOf(SKUDeletedCust_5[0].get('custCnt_m_type'));           
        else 
           o5.SalesErosion = 0; 
        //---------------
        o5.SalesRemediationErosion = 0;       
        //----------
        if(Impcount_5[0].get('custCnt_m_type') != null)
        	o5.Implemented = Double.ValueOf(Impcount_5[0].get('custCnt_m_type'));
        else
            o5.Implemented = 0; 
        //-------
        if(o5.Initial != null && o5.Initial != 0)
            o5.Percentage = (o5.Implemented/o5.Initial)*100;
        else
            o5.Percentage = 0;
         
        MAP_ReportData.put('Customers with 100% Price Pass Through (Margin Play)',o5); 
         
        //Creating the 5th line on the report----//Customer with 100% Pass Through on Time Implementation (Cost Increase)
        OverviewData o6 = new OverviewData();
        o6.UrlType = '100PercentTimePassThru';
        o6.dataType = 'Customers with 100% Pass Through on Time Implementation (Cost Increase)';
        o6.formatType = fmt.get('Customers with 100% Pass Through on Time Implementation (Cost Increase)');
         
        if(Double.ValueOf(Results_6[0].get('custCnt_c_type')) != null)
        	o6.Initial = Double.ValueOf(Results_6[0].get('custCnt_c_type'));
        else
            o6.Initial = 0;
        //-------
        //-------
        if(Total_6[0].get('custCnt_c_type') != null)
            o6.ContractErosion = (decimal)Total_6[0].get('custCnt_c_type');
        else
            o6.ContractErosion = 0; 
        //---------
        if(Elig_Cust_6[0].get('custCnt_c_type') != null)
        	o6.EligibleCustomers = Double.ValueOf(Elig_Cust_6[0].get('custCnt_c_type'));           
        else 
            o6.EligibleCustomers = 0;         
        //-----------------
        if(SKUDeletedCust_6[0].get('custCnt_c_type') != null)
        	o6.SalesErosion = Double.ValueOf(SKUDeletedCust_6[0].get('custCnt_c_type'));           
        else 
           o6.SalesErosion = 0;
        //------------------             
        if(SalesRemediation_Erosion_6[0].get('custCnt_c_type') != null)
        	o6.SalesRemediationErosion = Integer.valueof(SalesRemediation_Erosion_6[0].get('custCnt_c_type'));
        else
            o6.SalesRemediationErosion = 0;        
        //----------
        if(Impcount_6[0].get('custCnt_c_type') != null)
        	o6.Implemented = Double.ValueOf(Impcount_6[0].get('custCnt_c_type'));
        else
            o6.Implemented = 0; 
        //----------------- 
        if(o6.Initial != null && o6.Initial != 0)
            o6.Percentage = (o6.Implemented/o6.Initial)*100;
        else
            o6.Percentage = 0;
        //----------
        MAP_ReportData.put('Customers with 100% Pass Through on Time Implementation (Cost Increase)',o6); 
         
                                   
        For (String s: dTypes ) {          
          OverviewData o = new OverviewData();
          o.dataType = s;
          o.UrlType = MAP_ReportData.get(s).UrlType;
          o.formatType = MAP_ReportData.get(s).formatType;
          //-----------------
          o.Initial = MAP_ReportData.get(s).Initial;
          o.ContractErosion = MAP_ReportData.get(s).ContractErosion;
          o.EligibleCustomers = MAP_ReportData.get(s).EligibleCustomers;
          o.SalesErosion = MAP_ReportData.get(s).SalesErosion;          
          o.SalesRemediationErosion = MAP_ReportData.get(s).SalesRemediationErosion;
          o.Implemented = MAP_ReportData.get(s).Implemented;
          o.Percentage = MAP_ReportData.get(s).Percentage;
          //-----------------
          ovd.add(o);
          system.debug('>>>>>>>ovd'+ovd);         
        }                 
         
         
        system.debug('loadData_1:Leaving the Function.....');        
      
    }
   /* public void loadData(){   
        CustHeirData(); 
        system.debug('&&&&&&&&');                                
        ovd = new list<OverviewData>();
        Map<String,OverviewData> MAP_ReportData = new Map<String,OverviewData>();// added by guha        
        AggregateResult[] Results = [select count(id) custCnt, SUM(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru,
                                                               SUM(Report_New_Gross_IGM_ACE__c) marg_PassThru
                                                               from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList ];          
        AggregateResult[] SKUDeletedCust = [select count(id) cnt,
                                                                SUM(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru,
                                                                SUM(Report_New_Gross_IGM_ACE__c) marg_PassThru
                                                                from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and 
                                            					(Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true)];//sfdc 861332
                                            					//Report_SKU_Count__c < 1 ];		 
        
        system.debug('&&&&&&&&');
        
        //Calculations for rows Customers with Increases,Revenue Pass Through,Margin Pass Through (Implemented column)-----
        Integer Impcount = Integer.valueof(Results[0].get('custcnt')) - (0+Integer.valueof(SKUDeletedCust[0].get('cnt')));
        //---------
        if(SKUDeletedCust[0].get('Rev_PassThru')!=null)
            ImpRevPassThru = double.valueof(Results[0].get('Rev_PassThru')) - (0+double.valueof(SKUDeletedCust[0].get('Rev_PassThru')));
        else
            ImpRevPassThru = double.valueof(Results[0].get('Rev_PassThru')) - 0; 
        //----------   
        if(SKUDeletedCust[0].get('marg_PassThru')!=null)
            ImpMargPassThru = double.valueof(Results[0].get('marg_PassThru')) - (0+double.valueof(SKUDeletedCust[0].get('marg_PassThru')));
        else
            ImpMargPassThru = double.valueof(Results[0].get('marg_PassThru')) - 0; 
        //------------------------------------------------------------------------------------------------------------------        
        system.debug('&&&&&&&&');
        
        //Calculations for (Erosion Due to Contract Terms) column
        AggregateResult[] Total = [select count(id) CTcnt from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and PRICE_NOT_CALCULATED__c= true];        
        AggregateResult[] RevPassThru = [select SUM(Report_Total_Spend_Impact_12_Month_ACE__c) Revpass from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and PRICE_NOT_CALCULATED__c= true];       
        AggregateResult[] MargPassThru = [select SUM(Report_New_Gross_IGM_ACE__c) MargPass from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and PRICE_NOT_CALCULATED__c= true];
        //----------------------------------------------------------------------
        system.debug('&&&&&&&&');
        
        //Calculations for (Erosion due to Sales Decisions) column-------------start---------------------
        AggregateResult[] PricePassThru= [select count(id) cnt from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and Report_isSKU_Exception__c=true];
        pricePassErosion = double.valueof(PricePassThru[0].get('cnt'));
        //-------------------------------              
        AggregateResult[] TimePassThru= [select count(id) cnt from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and EffectiveDate_IsDifferent__c =true];
        TimePassErosion = double.valueof(TimePassThru[0].get('cnt'));
        //-------------------------------
        AggregateResult[] ExposureDays= [select SUM(Reporting_Exposure_Days_Initial__c) expoInitial, 
                                                SUM(Reporting_Exposure_Days_Sale_Erosion__c) expoSaleErosion
                                                from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and
                                        		(Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true)];//sfdc 861332
        if(ExposureDays[0].get('expoInitial') != null)
        	ExposureDaysInitial = double.valueof(ExposureDays[0].get('expoInitial'));
        else
            ExposureDaysInitial = 0;
        //------------------------------
        if(ExposureDays[0].get('expoSaleErosion') != null)
        	ExposureDaysSaleErosion = double.valueof(ExposureDays[0].get('expoSaleErosion'));
        else
            ExposureDaysSaleErosion = 0;
        //----------------------------------------------------------------------------------------         
        AggregateResult[] ExposureEarly= [select SUM(Reporting_ExposureDaysEarly_Sale_Erosion__c) expoEarlySaleErosion
                                                from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList and
                                         		(Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true)];//sfdc 861332
        if(ExposureEarly[0].get('expoEarlySaleErosion') != null)
        	ExposureDaysEarlySaleErosion = double.valueof(ExposureEarly[0].get('expoEarlySaleErosion'));
        else
            ExposureDaysEarlySaleErosion = 0;
        //---------------------------------------------------------------------------------------------------
        AggregateResult[] ExposureDays_DateExcept_Erosion1 = [select SUM(Reporting_ExposureDays_DateExcep_Erosion__c) expoDateExcep_Erosion
                                       							from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList
                                                            	and EffectiveDate_IsDifferent__c =true];//sfdc 861332
        
        if(ExposureDays_DateExcept_Erosion1[0].get('expoDateExcep_Erosion') != null)
        	ExposureDaysDateExceptErosion = double.valueof(ExposureDays_DateExcept_Erosion1[0].get('expoDateExcep_Erosion'));
        else
            ExposureDaysDateExceptErosion = 0;
        //Calculations for Erosion due to Sales Decisions column-------------end---------------------
        
        //Calculations for EligibleCustomers column---sfdc 861332
        AggregateResult[] Elig_Cust = [select count(id) cnt,SUM(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru,
                                       SUM(Report_New_Gross_IGM_ACE__c) Marg_PassThru
                                       from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList
                                       and Update_Timing_Action__c = 'T'];
        AggregateResult[] Elig_Cust_PricePass = [select count(id) cnt
                                       			from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList
                                       			and Update_Timing_Action__c = 'T' and Report_isSKU_Exception__c=true];
        AggregateResult[] Elig_Cust_TimePass = [select count(id) cnt
                                       			from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList
                                       			and Update_Timing_Action__c = 'T' and EffectiveDate_IsDifferent__c =true];               
        //--------------------------------------------------------------------------------------
        
        //Calculations for SalesRemediationErosion column---sfdc 861332
        AggregateResult[] SalesRemediation_Erosion = [select count(id) cnt,SUM(Report_Total_Spend_Impact_12_Month_ACE__c) Rev_PassThru,
                                       SUM(Report_New_Gross_IGM_ACE__c) Marg_PassThru
                                       from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList
                                       and Report_isSKU_Exception__c=true];
        
        AggregateResult[] SalesRemediation_Erosion_ExposureDays = [select SUM(Reporting_Exposure_Days_Initial__c) expoInitial
                                       							  from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList
                                       							  and Report_isSKU_Exception__c=true];
        AggregateResult[] SalesRemediation_Erosion_ExposureEarly = [select SUM(Reporting_ExposureDaysEarly_Sale_Erosion__c) expoEarlySaleErosion
                                       							   from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList
                                       							   and Report_isSKU_Exception__c=true];              
        AggregateResult[] ExposureDays_DateExcept_Erosion = [select SUM(Reporting_ExposureDays_DateExcep_Erosion__c) expoDateExcep_Erosion
                                       							from ACE_Customer_Price_Changes__c where Name=: quarterValue and id in:custList
                                                            	and Report_isSKU_Exception__c=true];        
        //--------------------------------------------------------------------------
        
        system.debug('>>>>>>>'+ImpRevPassThru);
        system.debug('<<<<<<<<<' +ImpRevPassThru); 
        //Added Erosion in the below line---sfdc 861332
        list<String> dTypes = new list<String> {'Customers with Increases','Revenue Pass Through','Margin Pass Through','Customers with 100% Price Pass Through','Customers with 100% Pass Through on Time Implementation','Exposure Days','Exposure Reduction from Early Release','Exposure Increases from Date Exception'};         
        fmt = new Map<String,String> ();
        fmt.put('Customers with Increases','{0, number, ###}');
        fmt.put('Revenue Pass Through','${0, number, ###,###,###,##0.00}');
        fmt.put('Margin Pass Through','${0, number, ###,###,###,##0.00}');
        fmt.put('Customers with 100% Price Pass Through','{0, number, ###}');
        fmt.put('Customers with 100% Pass Through on Time Implementation','{0, number, ###}');
        fmt.put('Exposure Days','{0, number, ###}');
        fmt.put('Exposure Increases from Date Exception','{0, number, ###}');//sfdc 861332
        fmt.put('Exposure Reduction from Early Release','{0, number, ###}');
         
        //Customers with Increases
        OverviewData o1 = new OverviewData();
        o1.dataType = 'Customers with Increases';
        o1.UrlType = 'Customers with Increases';
        o1.formatType = fmt.get('Customers with Increases');
        o1.Initial = Double.ValueOf(Results[0].get('custCnt'));
        //----------
        if(Total[0].get('CTcnt') != null)
            o1.ContractErosion = (decimal)Total[0].get('CTcnt');
        else
            o1.ContractErosion = 0;
		//----------
        o1.SalesErosion = Integer.valueof(SKUDeletedCust[0].get('cnt'));        
        o1.Implemented = Impcount;
        //-------//sfdc 861332--start--added null checking
        if(Elig_Cust[0].get('cnt') != null)            
        	o1.EligibleCustomers = Double.ValueOf(Elig_Cust[0].get('cnt'));//sfdc 861332         
        else
            o1.EligibleCustomers = 0;
        //---------
        if(SalesRemediation_Erosion[0].get('cnt') != null)
        	o1.SalesRemediationErosion = Double.ValueOf(SalesRemediation_Erosion[0].get('cnt'));//sfdc 861332                             
        else
            o1.SalesRemediationErosion = 0;        
        //----------//sfdc 861332--end
        if(o1.Initial != null && o1.Initial != 0)
            o1.Percentage = (Impcount/o1.Initial)*100;
        else
            o1.Percentage = 0;
        //----------
        MAP_ReportData.put('Customers with Increases',o1);
         
        //Revenue Pass Trough
        OverviewData o2 = new OverviewData();
        o2.UrlType = 'Revenue Pass Through';
        o2.dataType = 'Revenue Pass Through';
        o2.formatType = fmt.get('Revenue Pass Through');
        o2.Initial = Double.ValueOf(Results[0].get('Rev_PassThru'));
        //----------
        if(RevPassThru[0].get('Revpass') != null)
            o2.ContractErosion = (decimal)RevPassThru[0].get('Revpass');
        else
            o2.ContractErosion = 0;
        //----------               
        if(SKUDeletedCust[0].get('Rev_PassThru') != null)
            o2.SalesErosion = double.valueof(SKUDeletedCust[0].get('Rev_PassThru'));
        else
            o2.SalesErosion = 0;
        //----------
        o2.Implemented = ImpRevPassThru;
        //-------//sfdc 861332--start
        if(Elig_Cust[0].get('Rev_PassThru') != null)
        	o2.EligibleCustomers = Double.ValueOf(Elig_Cust[0].get('Rev_PassThru'));          
        else 
            o2.EligibleCustomers = 0;
        //------------
        if(SalesRemediation_Erosion[0].get('Rev_PassThru') != null)
        	o2.SalesRemediationErosion = Double.ValueOf(SalesRemediation_Erosion[0].get('Rev_PassThru'));//sfdc 861332
        else
            o2.SalesRemediationErosion = 0;        
        //----------//sfdc 861332--end
        
        if(o2.Initial != null && o2.Initial != 0)
            o2.Percentage = (ImpRevPassThru/o2.Initial)*100;
        else
            o2.Percentage = 0;
        //----------
        MAP_ReportData.put('Revenue Pass Through',o2);                               
        //Margin Pass Through
        OverviewData o3 = new OverviewData();
        o3.UrlType = 'Margin Pass Through';
        o3.dataType = 'Margin Pass Through';
        o3.formatType = fmt.get('Margin Pass Through');
        o3.Initial = Double.ValueOf(Results[0].get('marg_PassThru'));
        //------------
        if(MargPassThru[0].get('Margpass') != null)
            o3.ContractErosion = (decimal)MargPassThru[0].get('Margpass');
        else
            o3.ContractErosion = 0;
        //-----------        
        if(SKUDeletedCust[0].get('Marg_PassThru') != null)
            o3.SalesErosion = double.valueof(SKUDeletedCust[0].get('Marg_PassThru'));
        else
            o3.SalesErosion = 0;
        //----------------
        o3.Implemented = ImpMargPassThru;
        //-------//sfdc 861332--start
        if(Elig_Cust[0].get('Marg_PassThru') != null)
        	o3.EligibleCustomers = Double.ValueOf(Elig_Cust[0].get('Marg_PassThru'));           
        else 
            o3.EligibleCustomers = 0;
        //------------
        if(SalesRemediation_Erosion[0].get('Marg_PassThru') != null)
        	o3.SalesRemediationErosion = Double.ValueOf(SalesRemediation_Erosion[0].get('Marg_PassThru'));//sfdc 861332
        else
            o3.SalesRemediationErosion = 0;        
        //----------//sfdc 861332--end
        
        if(o3.Initial != null && o3.Initial != 0)
            o3.Percentage = (ImpMargPassThru/o3.Initial)*100;
        else
            o3.Percentage = 0;
        //-------------------
        MAP_ReportData.put('Margin Pass Through',o3);
        
        //Customers with 100% Price Pass Through
        OverviewData o4 = new OverviewData();
        o4.UrlType = '100PercentPricePassThru';
        o4.dataType = 'Customers with 100% Price Pass Through';
        o4.formatType = fmt.get('Customers with 100% Price Pass Through');
        o4.Initial = Double.ValueOf(Results[0].get('custCnt'));
        o4.ContractErosion = 0;        
        o4.SalesErosion = pricePassErosion;
        o4.Implemented = o4.Initial - o4.SalesErosion;
        //-------//sfdc 861332--start
        if(Elig_Cust_PricePass[0].get('cnt') != null)
        	o4.EligibleCustomers = Double.ValueOf(Elig_Cust_PricePass[0].get('cnt'));           
        else 
            o4.EligibleCustomers = 0;
        //-----------
        o4.SalesRemediationErosion = o1.SalesRemediationErosion;        
        //sfdc 861332----end
        //-------
        if(o4.Initial != null && o4.Initial != 0)
            o4.Percentage = (o4.Implemented/o4.Initial)*100;
        else
            o4.Percentage = 0;
        MAP_ReportData.put('Customers with 100% Price Pass Through',o4);
        
        //Customer with 100% Pass Through on Time Implementation
        OverviewData o5 = new OverviewData();
        o5.UrlType = '100PercentTimePassThru';
        o5.dataType = 'Customers with 100% Pass Through on Time Implementation';
        o5.formatType = fmt.get('Customers with 100% Pass Through on Time Implementation');
        o5.Initial = Double.ValueOf(Results[0].get('custCnt'));
        o5.ContractErosion = 0;        
        o5.SalesErosion = TimePassErosion ;
        o5.Implemented = o5.Initial - o5.SalesErosion;
        //-------//sfdc 861332--start
        if(Elig_Cust_TimePass[0].get('cnt') != null)
        	o5.EligibleCustomers = Double.ValueOf(Elig_Cust_TimePass[0].get('cnt'));           
        else 
            o5.EligibleCustomers = 0;
        if(SKUDeletedCust[0].get('cnt') != null)
        	o5.SalesRemediationErosion = Integer.valueof(SKUDeletedCust[0].get('cnt'));
        else
            o5.SalesRemediationErosion = 0;        
        ///-------//sfdc 861332--end
        if(o5.Initial != null && o5.Initial != 0)
            o5.Percentage = (o5.Implemented/o5.Initial)*100;
        else
            o5.Percentage = 0;
        MAP_ReportData.put('Customers with 100% Pass Through on Time Implementation',o5);
        
        //Exposure Days
        OverviewData o6 = new OverviewData();
        o6.UrlType = 'Exposure Days';
        o6.dataType = 'Exposure Days';
        o6.formatType = fmt.get('Exposure Days');
        o6.Initial = ExposureDaysInitial;
        o6.ContractErosion = 0;        
        o6.SalesErosion = ExposureDaysSaleErosion;        
        o6.Implemented = o6.Initial+o6.SalesErosion;
        
        //sfdc 861332----start
        o6.EligibleCustomers = o1.EligibleCustomers;        
        if(SalesRemediation_Erosion_ExposureDays[0].get('expoInitial') != null)
        	o6.SalesRemediationErosion = Double.ValueOf(SalesRemediation_Erosion_ExposureDays[0].get('expoInitial'));
        else
			o6.SalesRemediationErosion = 0;        
        //sfdc 861332----end
        if(o6.Initial != null && o6.Initial != 0)
            o6.Percentage = (o6.Implemented/o6.Initial)*100;
        else
            o6.Percentage = 0;
        MAP_ReportData.put('Exposure Days',o6);
        
        //Exposure Reduction from Early Release
        OverviewData o7 = new OverviewData();
        o7.UrlType = 'Exposure Reduction from Early Release';
        o7.dataType = 'Exposure Reduction from Early Release';
        o7.formatType = fmt.get('Exposure Reduction from Early Release');
        o7.Initial = Double.ValueOf(0);
        o7.ContractErosion = 0;        
        o7.SalesErosion = ExposureDaysEarlySaleErosion;
        o7.Implemented = o7.Initial+o7.SalesErosion;
        //sfdc 861332----start
        o7.EligibleCustomers = o1.EligibleCustomers;
        if(SalesRemediation_Erosion_ExposureEarly[0].get('expoEarlySaleErosion') != null)
        	o7.SalesRemediationErosion = Double.ValueOf(SalesRemediation_Erosion_ExposureEarly[0].get('expoEarlySaleErosion'));
        else
			o7.SalesRemediationErosion = 0;        
        //sfdc 861332----end
        if(o7.Initial != null && o7.Initial != 0)
            o7.Percentage = (o7.Implemented/o7.Initial)*100;
        else
            o7.Percentage = 0;
        MAP_ReportData.put('Exposure Reduction from Early Release',o7);
        
        //sfdc 861332----start
        //Exposure Increases from Date Exception        
        OverviewData o8 = new OverviewData();
        o8.UrlType = 'Exposure Increases from Date Exception';
        o8.dataType = 'Exposure Increases from Date Exception';
        o8.formatType = fmt.get('Exposure Increases from Date Exception');
        o8.Initial = Double.ValueOf(0);
        o8.ContractErosion = 0;        
        o8.SalesErosion = ExposureDaysDateExceptErosion;
        o8.Implemented = o8.Initial+o8.SalesErosion;        
        o8.EligibleCustomers = o1.EligibleCustomers;
        if(ExposureDays_DateExcept_Erosion[0].get('expoDateExcep_Erosion') != null)
        	o8.SalesRemediationErosion = Double.ValueOf(ExposureDays_DateExcept_Erosion[0].get('expoDateExcep_Erosion'));
        else
			o8.SalesRemediationErosion = 0;
        
        
        if(o8.Initial != null && o8.Initial != 0)
            o8.Percentage = (o8.Implemented/o8.Initial)*100;
        else
            o8.Percentage = 0;
        MAP_ReportData.put('Exposure Increases from Date Exception',o8);
        //sfdc 861332----end
        
        //Added by deepak - begins                           
        For (String s: dTypes ) {          
          OverviewData o = new OverviewData();
          o.dataType = s;
          o.UrlType = MAP_ReportData.get(s).UrlType;
          o.formatType = MAP_ReportData.get(s).formatType;
          o.ContractErosion = MAP_ReportData.get(s).ContractErosion;
          o.Initial = MAP_ReportData.get(s).Initial;
          o.SalesErosion = MAP_ReportData.get(s).SalesErosion;
          o.EligibleCustomers = MAP_ReportData.get(s).EligibleCustomers;//sfdc 861332
          o.SalesRemediationErosion = MAP_ReportData.get(s).SalesRemediationErosion;//sfdc 861332
          o.Implemented = MAP_ReportData.get(s).Implemented;
          o.Percentage = MAP_ReportData.get(s).Percentage;
          ovd.add(o);
          system.debug('>>>>>>>ovd'+ovd);         
        }                 
        //Added by deepak - ends  
    } */
    
  /*   public void loadDataByRegion(){                                                       
        
        AggregateResult[] ResultsNorth = [select count(id) custCnt, SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                               SUM(New_Gross_IGM__c) marg_PassThru
                                                               from ACE_Customer_Price_Changes__c 
                                                               where id in:custList and Region__c='North' and (Total_Spend_Impact_12_Month__c != null and New_Gross_IGM__c != null)];          
        AggregateResult[] ResultsSouth = [select count(id) custCnt, SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                               SUM(New_Gross_IGM__c) marg_PassThru
                                                               from ACE_Customer_Price_Changes__c 
                                                               where id in:custList and Region__c='South' and (Total_Spend_Impact_12_Month__c != null and New_Gross_IGM__c != null)];
        AggregateResult[] ResultsEast = [select count(id) custCnt, SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                               SUM(New_Gross_IGM__c) marg_PassThru
                                                               from ACE_Customer_Price_Changes__c 
                                                               where id in:custList and Region__c='East' and (Total_Spend_Impact_12_Month__c != null and New_Gross_IGM__c != null)];
         AggregateResult[] ResultsCentral = [select count(id) custCnt, SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                               SUM(New_Gross_IGM__c) marg_PassThru
                                                               from ACE_Customer_Price_Changes__c 
                                                               where id in:custList and Region__c='Central' and (Total_Spend_Impact_12_Month__c != null and New_Gross_IGM__c != null)];                                                                                                                                                                                                                                           
                                                               
                                                               
        AggregateResult[] SKUDeletedCustNorth = [select count(id) cnt,
                                                                SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                                SUM(New_Gross_IGM__c) marg_PassThru
                                                                 from ACE_Customer_Price_Changes__c 
                                                                 where id in:custList and Report_SKU_Count__c < 1 and Region__c='North' and (Total_Spend_Impact_12_Month__c != null and New_Gross_IGM__c != null)];        
        AggregateResult[] SKUDeletedCustSouth = [select count(id) cnt,
                                                                SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                                SUM(New_Gross_IGM__c) marg_PassThru
                                                                 from ACE_Customer_Price_Changes__c 
                                                                 where id in:custList and Report_SKU_Count__c < 1 and Region__c='South' and Total_Spend_Impact_12_Month__c != null and New_Gross_IGM__c != null];        
        AggregateResult[] SKUDeletedCustEast = [select count(id) cnt,
                                                                SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                                SUM(New_Gross_IGM__c) marg_PassThru
                                                                 from ACE_Customer_Price_Changes__c 
                                                                 where id in:custList and Report_SKU_Count__c < 1 and Region__c='East' and Total_Spend_Impact_12_Month__c != null and New_Gross_IGM__c != null];        
        AggregateResult[] SKUDeletedCustCentral = [select count(id) cnt,
                                                                SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                                SUM(New_Gross_IGM__c) marg_PassThru
                                                                 from ACE_Customer_Price_Changes__c 
                                                                 where id in:custList and Report_SKU_Count__c < 1 and Region__c='Central' and Total_Spend_Impact_12_Month__c != null and New_Gross_IGM__c != null];                                                                                                                                                                                                   
                                                                 
        
        
        AggregateResult[] ErrosionNorth = [select count(id) cnt, 
                                                                SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                                SUM(New_Gross_IGM__c) marg_PassThru
                                                                from ACE_Customer_Price_Changes__c 
                                                                where id in:custList and Region__c='North' and (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true)];
        AggregateResult[] ErrosionSouth = [select count(id) cnt, 
                                                                SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                                SUM(New_Gross_IGM__c) marg_PassThru
                                                                from ACE_Customer_Price_Changes__c 
                                                                where id in:custList and Region__c='South' and (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true)];
        AggregateResult[] ErrosionEast = [select count(id) cnt, 
                                                                SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                                SUM(New_Gross_IGM__c) marg_PassThru
                                                                from ACE_Customer_Price_Changes__c 
                                                                where id in:custList and Region__c='East' and (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true)];
        AggregateResult[] ErrosionCentral = [select count(id) cnt, 
                                                                SUM(Total_Spend_Impact_12_Month__c) Rev_PassThru,
                                                                SUM(New_Gross_IGM__c) marg_PassThru
                                                                from ACE_Customer_Price_Changes__c 
                                                                where id in:custList and Region__c='Central' and (Report_isSKU_Exception__c=true OR EffectiveDate_IsDifferent__c =true)];                                                                                                                                                                        
        
        
                                                                   
        
    }  */
    
    public List<selectOption> getQtrs() {
           List<selectOption> options = new List<selectOption>();
            for (ACE_Batches__c bt : [SELECT Id, Batch__c FROM ACE_Batches__c order by CreatedDate desc]) {
                   options.add(new selectOption(bt.Batch__c, bt.Batch__c));
           }
           return options;
    }

}