global class CreateOrgSalesDataRollUpNew implements database.Batchable<Sobject>,Schedulable,Database.AllowsCallouts,Database.stateful
{

    private String strQuery;      
    private String DEFAULT_QUERY ='Select id ,Batch_Org_Sales__C,Parent_Org__c FROM Org__c WHERE  Batch_Org_Sales__C=true  Limit 50000'; 
    
    // Default Constructor
    global CreateOrgSalesDataRollUpNew()
    {
        this.strQuery = DEFAULT_QUERY;
    }
    
    //This constructor is called from the Batch Schedule method
    global CreateOrgSalesDataRollUpNew(String query)
    {
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
        System.debug('QUERY IS---->'+strQuery);
    }
    
    // This method prepares the scope of the batch program based on the query result 
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
       
       return Database.getQueryLocator(strQuery);
    }
    
    
    // This method processes query result in batches 
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
    
    Integer count=[select count() from Org__C where SalesDataBatch__C=true];
    
    if(count==0){
    
    
       List<Org__c> siteData = scope;
       Set<Id> OrgId= new Set<Id>();
       for(Org__C rec : siteData)
       {
            /*if(! OrgId.contains(rec.Parent_Org__c))
            OrgId.add(rec.Parent_Org__c);  */
                        OrgId.add(rec.Id);
                        rec.Batch_Org_Sales__C=false;     
       }
       
       System.debug('&&&&&&&&&OrgId'+OrgId);
       //Finding the Parent Org Id's
       Map<Id, Id> mapParent = new Map<Id, Id>();
       
       for  (Org__C rec  :  [select Id,Parent_Org__c  from  Org__C where Parent_Org__c!=null and
       Id in :OrgId]){
         mapParent.put( rec.Id, rec.Parent_Org__c);       
       }
       
       if(OrgId.size()>0){
       
       //Get only unique record for the Org- select the hierarchy Record if one is present over Org type
               /*List<Sales_Data__C> uniqueList= [SELECT Id,org__C
                from  Sales_Data__C where org__C in :OrgId
                and (account_Type__c='Org'     or  account_Type__c='OrgHierarchy' )     
                ORDER BY account_Type__c desc];
       Set<Id> uniqueId= new Set<Id>();
        List<Id> uniqueSalesId= new List<Id>();

      for(Sales_Data__C  rec  :uniqueList){
         if(!uniqueId.contains(rec.org__C)){
         uniqueSalesId.add(rec.Id);
         uniqueId.add(rec.org__C);
         }
      }
       */
       
       
       
          List<AggregateResult> siteDataRollUp= [SELECT Parent_Org__c,sum(SITE_COUNT__c) sitecount,sum(LAST_365_DAYS_SALES_AMT__c) Last365Days,
         sum(LAST_270_DAYS_SALES_AMT__c) Last270Days,sum(LAST_180_DAYS_SALES_AMT__c) Last180Days, sum(Copiers__c) copier, sum(Potential_Printers__c) printer ,sum(Num_of_Categories__c)category ,
          sum(ORDERS_SINCE_START_COUNT__c) ordersstartcount,Sum(Org_WCW_Count_Rep__c)OrgWCWCount,Sum(Weeks_Since_Last_Order__c)WeeksLastOrder,
         Sum(CATEGORY_COUNT__c)categorycount, Sum(Weeks_Since_1st_Order__c)Weeks1stOrder,Sum(DNB_WCW_Total__c)DNBWCWTotal,
          Sum(DNB_WCW_Here__c)DNBWCW,Sum(Total_Order__c)TotalOrder,Sum(Ranking__c) Ranking,
          Sum(PID_numeric__c)PID,Sum(Org_WCW_Count_DB__c)ORGWCW,Sum(Orders_Last_Yr__c)OLY,Sum(Orders_Last_Qtr__c)OLQ,
          Sum(Orders_Last_Month__c)OLM,Sum(Orders_Current_Yr__c)OCY,Sum(Orders_Current_Qtr__c)OCQ,Sum(Orders_Current_Month__c)OCM,
          Sum(OMAXProspectSer_Batch_Processed__c)OMAX,Sum(Org_Number_of_Locations__c)OrgLocations,Sum(DNBI_MatchScore__c)DNBIMatch,
          Sum(DNBI_FSS_Score__c)DNBIFSS,Sum(Cadence_Call_Date_Override_Value__c)Cadence,sum(Est_Spend_CAD__c)EstSpendCAD,sum(Potential_Amount__c)Amount,
          Sum(Rolling_9_month_sales__c)Rolling9,Sum(Rolling_12_month_sales__c)Rolling12,Sum(Rolling_3_month_sales__c)Rolling3,Sum(Rolling_6_month_sales__c)Rolling6,
          Sum(Year_LY__c)YLY,Sum(Year_Goal__c)YGoal,Sum(Quarter_LY__c)QLY,Sum(Partner_LY_Services_Sales__c)PLYSS,Sum(Partner_LY_Hardware_Sales__c)PLYHS,
          Sum(Opportunity_Amt__c)OppAmt,Sum(Monthly_LY__c)MonthlyLY,Sum(AOV_Last_Yr__c)AOVLY,Sum(AOV_Last_Qtr__c)AOVLQ,Sum(AOV_Last_Month__c)AOVLM,
          Sum(AOV_Current_Yr__c)AOVCY,Sum(AOV_Current_Qtr__c)AOVCQ,Sum(AOV_Current_Month__c)AOVCM,Sum(ADS_Last_Yr__c)ADSLY,Sum(ADS_Last_Qtr__c)ADSLQ,
          Sum(ADS_Last_Month__c)ADSLM,Sum(ADS_Current_Yr__c)ADSCY,Sum(ADS_Current_Qtr__c)ADSCQ,Sum(ADS_Current_Month__c)ADSCM,Sum(Max_Order_Limit__c)MaxOrder,
          Sum(Filing_Binding_IMU_TY__c)FBIMUTY,Sum(Filing_Binding_IMU_LY__c)FBIMULY,Sum(CPD_TY__c)CPDTY,Sum(CPD_Total_LY__c)CPDTotalLY,
          Sum(CPD_Pot__c)CPDPot,Sum(CPD_LY__c)CPDLY,Sum(CPD_Last_order_amt__c)CPDLastOrder,Sum(CPD_IMU_TY__c)CPDIMUTY,
          Sum(CPD_IMU_LY__c)CPDIMULY,Sum(Contract_Furniture_TY__c)CFTY,Sum(Contract_Furniture_Pot__c)CFPot,
          Sum(Contract_Furniture_LY__c)CFLY,Sum(Contract_Furniture_Last_Order_amt__c)CFLastOrder,Sum(Contract_Furniture_IMU_TY__c)CFIMUTY,
          Sum(Contract_Furniture_IMU_LY__c)CFIMULY,Sum(CBS_TY__c)CBSTY,Sum(CBS_Total_LY__c)CBSTotalLY,Sum(CBS_Pot__c)CBSPot,
          Sum(CBS_LY__c)CBSLY,Sum(CBS_Last_order_amt__c)CBSLastOrder,Sum(LAST_90_DAYS_SALES_AMT__c)Last90Days,Sum(CBS_IMU_TY__c)CBSIMUTY,Sum(CBS_IMU_LY__c)CBSIMULY,sum(Est_Spend__c)EstSpend
                                                 
         from  Sales_Data__C  where Parent_Org__c in :OrgId 
        // and  Id in :uniqueSalesId
         and account_Type__c='Org'         
          GROUP BY CUBE(Parent_Org__c)  ORDER BY GROUPING(Parent_Org__c)];
           
                   List<AggregateResult> siteDataRollUpCont= [SELECT Parent_Org__c,Sum(Num_of_Orders_Since_Start__c) Nooforders,sum(Year_LY_IMU__c) YearLYIMU,
                                                  Sum(YTD_Sales_TY_IMU__c)YTDSalesTYIMU,Sum(YTD_Sales_TY__c)YTDSalesTY,Sum(YTD_Sales_LY_IMU__c)YTDSalesLYIMU,Sum(YTD_Sales_LY__c)YTDSalesLY,  
                                                  Sum(Writing_Drafting_TY__c)WDTY,Sum(Writing_Drafting_Total_LY__c)WDTotalLY,Sum(Writing_Drafting_Pot__c)WDPot,
                                                    Sum(Writing_Drafting_LY__c)WDLY,Sum(Writing_Drafting_Last_Order_amt__c)WDLastOrder,Sum(Writing_Drafting_IMU_TY__c)WDIMUTY,
                                                    Sum(Writing_Drafting_IMU_LY__c)WDIMULY,Sum(Tech_TY__c)TechTY,Sum(Tech_Total_LY__c)TechTotalLY,Sum(Tech_Pot__c)TechPot,Sum(Tech_LY__c)TechLY,
                                                    Sum(Tech_Last_Order_amt__c)TechLastOrder,Sum(Tech_IMU_TY__c)TechIMUTY,Sum(Tech_IMU_LY__c)TechIMULY,Sum(Sales__c)Sales,
                                                    Sum(Quarter_LY_IMU__c)QuarterLYIMU,Sum(Quarter_Goal__c)QuarterGoal,Sum(QTD_Sales_TY_IMU__c)QTDSalesTYIMU,Sum(QTD_Sales_TY__c)QTDSalesTY,
                                                    Sum(QTD_Sales_LY_IMU__c)QTDSalesLYIMU,Sum(QTD_Sales_LY__c)QTDSalesLY,Sum(Paper_TY__c)PaperTY,Sum(Paper_Total_LY__c)PaperTotalLY,
                                                    Sum(Paper_Pot__c)PaperPot,Sum(Paper_LY__c)PaperLY,Sum(Paper_Last_Order_amt__c)PaperLastOrder,Sum(Paper_IMU_TY__c)PaperIMUTY,
                                                    Sum(Paper_IMU_LY__c)PaperIMULY,Sum(Office_Essentials_TY__c)OfficeETY,Sum(Office_Essentials_Total_LY__c)OfficeETotalLY,
                                                    Sum(Office_Essentials_Pot__c)OfficeEPot,Sum(Office_Essentials_LY__c)OfficeELY,Sum(Office_Essentials_Last_Order_amt__c)OfficeELastOrder,
                                                    Sum(Office_Essentials_IMU_TY__c)OfficeEIMUTY,Sum(Office_Essentials_IMU_LY__c)OfficeEIMULY,Sum(MTD_Sales_TY_IMU__c)MTDSalesTYIMU,
                                                    Sum(MTD_Sales_TY__c)MTDSalesTY,Sum(MTD_Sales_LY_IMU__c)MTDSalesLYIMU,Sum(MTD_Sales_LY__c)MTDSalesLY,Sum(MPS_TY__c)MPSTY,
                                                    Sum(MPS_Total_LY__c)MPSTotalLY,Sum(MPS_Pot__c)MPSPot,Sum(MPS_LY__c)MPSLY,Sum(MPS_Last_order_amt__c)MPSLastOrder,Sum(MPS_IMU_TY__c)MPSIMUTY,
                                                    Sum(MPS_IMU_LY__c)MPSIMULY,Sum(Monthly_LY_IMU__c)MonthLYIMU,Sum(Month_Goal__c)MonthGoal,Sum(Miscellaneous_TY__c)MTY,
                                                    Sum(Miscellaneous_Total_LY__c)MTotalLY,Sum(Miscellaneous_Pot__c)Mpot,Sum(Miscellaneous_LY__c)MLY,Sum(Miscellaneous_Last_Order_amt__c)MLastOrder,
                                                    Sum(Miscellaneous_IMU_TY__c)MIMUTY,Sum(Miscellaneous_IMU_LY__c)MIMULY,Sum(Labels_Forms_TY__c)LFTY,Sum(Labels_Forms_Total_LY__c)LFTotalLY,
                                                    Sum(Labels_Forms_Pot__c)LFPot,Sum(Labels_Forms_LY__c)LFLY,Sum(Labels_Forms_Last_Order_amt__c)LFLastOrder,Sum(Labels_Forms_IMU_TY__c)LFIMUTY,
                                                    Sum(Labels_Forms_IMU_LY__c)LFIMULY,Sum(Ink_Toner_TY__c)InkTTY,Sum(Ink_Toner_Total_LY__c)InkTTotalLY,Sum(Ink_Toner_Pot__c)InkTPot,
                                                    Sum(Ink_Toner_LY__c)InkTLY,Sum(Ink_Toner_Last_Order_amt__c)InkTLastOrder,Sum(Ink_Toner_IMU_TY__c)InkTIMUTY,Sum(Ink_Toner_IMU_LY__c)InkTIMULY,
                                                    Sum(Furniture_TY__c)FTY,Sum(Furniture_Total_LY__c)FTotalLY,Sum(Furniture_Pot__c)Fpot,Sum(Furniture_LY__c)FLY,
                                                    Sum(Furniture_last_order_amt__c)FLastOrder,Sum(Furniture_IMU_TY__c)FIMUTY,Sum(Furniture_IMU_LY__c)FIMULY,Sum(Filing_Binding_TY__c)FBTY,
                                                    Sum(Filing_Binding_Total_LY__c)FBTotalLY,Sum(Filing_Binding_Pot__c)FBPot,Sum(Filing_Binding_LY__c)FBLY,Sum(Filing_Binding_Last_Order_amt__c)FBLastOrder,sum(GParent_GPID__c)GparentGPID

         from  Sales_Data__C   where Parent_Org__c in :OrgId 
        // and  Id in :uniqueSalesId
         and account_Type__c='Org'         
          GROUP BY CUBE(Parent_Org__c)  ORDER BY GROUPING(Parent_Org__c)];
          
          
         Map<Id, AggregateResult> MapCont = new Map<Id, AggregateResult>();
         for (AggregateResult ar : siteDataRollUpCont){ 
         MapCont.put((Id)ar.get('Parent_Org__c'),ar);
         }

         List<Sales_Data__C> orgUpsert= new List<Sales_Data__C>();

        for (AggregateResult ar : siteDataRollUp) {
        
          System.debug('&&&&&&&& Rec'+ar);
          Id currentRecId=(Id)ar.get('Parent_Org__c');
           if(currentRecId!=null){
           System.debug('inside loop');

         // Creating roll up for sites
           Sales_Data__C newRec = new Sales_Data__C();
           Id orgRecId=(Id)ar.get('Parent_Org__c');
           System.debug('&&&&&&&&orgRecId'+orgRecId);
           //newRec.Org_Id_RollUp__c=orgRecId;
           newRec.org__C=orgRecId;
           newRec.account_type__C='OrgHierarchy';
           Id parentId=mapParent.get(orgRecId);
           newRec.Unique_Key__C=orgRecId+'OrgHierarchy';

           if(parentId !=null){
           //newRec.batchprocessed__C=true;
           newrec.Parent_Org__C=parentId;
           
           }
            newRec.copiers__C=((decimal)ar.get('copier'));
           newRec.Potential_Printers__c = ((decimal)ar.get('Printer'));
           newRec.Num_of_Categories__c =((decimal)ar.get('Category'));
           newRec.Org_WCW_Count_Rep__c = ((decimal)ar.get('OrgWCWCount'));
           newRec.Weeks_Since_Last_Order__c = ((decimal)ar.get('WeeksLastOrder'));
           newRec.Weeks_Since_1st_Order__c = ((decimal)ar.get('Weeks1stOrder'));
           newRec.DNB_WCW_Total__c = ((decimal)ar.get('DNBWCWTotal'));
           newRec.DNB_WCW_Here__c = ((decimal)ar.get('DNBWCW'));
           newRec.Total_Order__c = ((decimal)ar.get('TotalOrder'));
           newRec.Ranking__c = ((decimal)ar.get('Ranking'));
           newRec.PID_numeric__c = ((decimal)ar.get('PID'));
           newRec.Org_WCW_Count_DB__c = ((decimal)ar.get('ORGWCW'));
           newRec.Orders_Last_Yr__c = ((decimal)ar.get('OLY'));
           newRec.Orders_Last_Qtr__c = ((decimal)ar.get('OLQ'));
           newRec.Orders_Last_Month__c = ((decimal)ar.get('OLM'));
           newRec.Orders_Current_Yr__c = ((decimal)ar.get('OCY'));
           newRec.Orders_Current_Qtr__c = ((decimal)ar.get('OCQ'));
           newRec.Orders_Current_Month__c = ((decimal)ar.get('OCM'));
           newRec.OMAXProspectSer_Batch_Processed__c = ((decimal)ar.get('OMAX'));
           newRec.Org_Number_of_Locations__c = ((decimal)ar.get('ORGLocations'));
           newRec.DNBI_MatchScore__c = ((decimal)ar.get('DNBIMatch'));
           newRec.DNBI_FSS_Score__c = ((decimal)ar.get('DNBIFSS'));
           newRec.Cadence_Call_Date_Override_Value__c = ((decimal)ar.get('Cadence'));
           newRec.Est_Spend_CAD__c = ((decimal)ar.get('EstSpendCAD'));
           newRec.Potential_Amount__c = ((decimal)ar.get('Amount'));
           newRec.Rolling_9_month_sales__c = ((decimal)ar.get('Rolling9'));
           newRec.Rolling_12_month_sales__c = ((decimal)ar.get('Rolling12'));
           newRec.Rolling_3_month_sales__c = ((decimal)ar.get('Rolling3'));
           newRec.Rolling_6_month_sales__c = ((decimal)ar.get('Rolling6'));
           newRec.Year_LY__c = ((decimal)ar.get('YLY'));
           newRec.Year_Goal__c = ((decimal)ar.get('YGoal'));
           newRec.Quarter_LY__c = ((decimal)ar.get('QLY'));
           newRec.Partner_LY_Services_Sales__c = ((decimal)ar.get('PLYSS'));
           newRec.Partner_LY_Hardware_Sales__c = ((decimal)ar.get('PLYHS'));
           newRec.Opportunity_Amt__c = ((decimal)ar.get('OppAmt'));
           newRec.Monthly_LY__c = ((decimal)ar.get('MonthlyLY'));
           newRec.AOV_Last_Yr__c = ((decimal)ar.get('AOVLY'));
           newRec.AOV_Last_Qtr__c = ((decimal)ar.get('AOVLQ'));
           newRec.AOV_Last_Month__c = ((decimal)ar.get('AOVLM'));
           newRec.AOV_Current_Yr__c = ((decimal)ar.get('AOVCY'));
           newRec.AOV_Current_Qtr__c = ((decimal)ar.get('AOVCQ'));
           newRec.AOV_Current_Month__c = ((decimal)ar.get('AOVCM'));
           newRec.ADS_Last_Yr__c = ((decimal)ar.get('ADSLY'));
           newRec.ADS_Last_Qtr__c = ((decimal)ar.get('ADSLQ'));
           newRec.ADS_Last_Month__c = ((decimal)ar.get('ADSLM'));
           newRec.ADS_Current_Yr__c = ((decimal)ar.get('ADSCY'));
           newRec.ADS_Current_Qtr__c = ((decimal)ar.get('ADSCQ'));
           newRec.ADS_Current_Month__c = ((decimal)ar.get('ADSCM'));
           newRec.Max_Order_Limit__c = ((decimal)ar.get('MaxOrder'));
           newRec.Filing_Binding_IMU_TY__c = ((decimal)ar.get('FBIMUTY'));
           newRec.Filing_Binding_IMU_LY__c = ((decimal)ar.get('FBIMULY')); 
           newRec.CPD_TY__c = ((decimal)ar.get('CPDTY'));
           newRec.CPD_Total_LY__c = ((decimal)ar.get('CPDTotalLY'));
           newRec.CPD_Pot__c = ((decimal)ar.get('CPDPot'));
           newRec.CPD_LY__c = ((decimal)ar.get('CPDLY'));
           newRec.CPD_Last_Order_amt__c = ((decimal)ar.get('CPDLastOrder'));
           newRec.CPD_IMU_TY__c = ((decimal)ar.get('CPDIMUTY'));
           newRec.CPD_IMU_LY__c = ((decimal)ar.get('CPDIMULY'));
           newRec.Contract_Furniture_TY__c = ((decimal)ar.get('CFTY'));
           newRec.Contract_Furniture_Pot__c = ((decimal)ar.get('CFPot'));
           newRec.Contract_Furniture_LY__c = ((decimal)ar.get('CFLY'));
           newRec.Contract_Furniture_Last_Order_amt__c = ((decimal)ar.get('CFLastOrder'));
           newRec.Contract_Furniture_IMU_TY__c = ((decimal)ar.get('CFIMUTY'));
           newRec.Contract_Furniture_IMU_LY__c = ((decimal)ar.get('CFIMULY'));
           newRec.CBS_TY__c = ((decimal)ar.get('CBSTY'));
           newRec.CBS_Pot__c = ((decimal)ar.get('CBSPot'));
           newRec.CBS_LY__c = ((decimal)ar.get('CBSLY'));
           newRec.CBS_Last_Order_amt__c = ((decimal)ar.get('CBSLastOrder'));
           newRec.CBS_IMU_TY__c = ((decimal)ar.get('CBSIMUTY'));
           newRec.CBS_IMU_LY__c = ((decimal)ar.get('CBSIMULY'));
           newRec.Est_Spend__c = ((decimal)ar.get('EstSpend'));
           newRec.CBS_Total_LY__c= ((decimal)ar.get('CBSTotalLY'));
            newRec.LAST_90_DAYS_SALES_AMT__c= ((decimal)ar.get('Last90Days'));
            newRec.LAST_365_DAYS_SALES_AMT__c=((decimal)ar.get('Last365Days'));
            newRec.SITE_COUNT__c=((decimal)ar.get('sitecount'));
            newRec.LAST_180_DAYS_SALES_AMT__c=((decimal)ar.get('Last180Days'));
            newRec.ORDERS_SINCE_START_COUNT__c=((decimal)ar.get('ordersstartcount'));
            newRec.CATEGORY_COUNT__c=((decimal)ar.get('categorycount'));
            newRec.LAST_270_DAYS_SALES_AMT__c=((decimal)ar.get('Last270Days'));
                //Current Record
                
           AggregateResult arRec=MapCont.get(orgRecId);
           newRec.Num_of_Orders_Since_Start__c = ((decimal)arRec.get('Nooforders'));
           newRec.YTD_Sales_TY_IMU__c=((decimal)arRec.get('YTDSalesTYIMU'));
           newRec.YTD_Sales_TY__c = ((decimal)arRec.get('YTDSalesTY'));
           newRec.YTD_Sales_LY_IMU__c =((decimal)arRec.get('YTDSalesLYIMU'));
           newRec.YTD_Sales_LY__c = ((decimal)arRec.get('YTDSalesLY'));
           newRec.Year_LY_IMU__c = ((decimal)arRec.get('YearLYIMU'));
           newRec.Writing_Drafting_TY__c = ((decimal)arRec.get('WDTY'));
           newRec.Writing_Drafting_Total_LY__c = ((decimal)arRec.get('WDTotalLY'));
           newRec.Writing_Drafting_Pot__c = ((decimal)arRec.get('WDPOT'));
           newRec.Writing_Drafting_LY__c = ((decimal)arRec.get('WDLY'));
           newRec.Writing_Drafting_Last_Order_amt__c = ((decimal)arRec.get('WDLastOrder'));
           newRec.Writing_Drafting_IMU_TY__c = ((decimal)arRec.get('WDIMUTY'));
           newRec.Writing_Drafting_IMU_LY__c = ((decimal)arRec.get('WDIMULY'));
           newRec.Tech_TY__c = ((decimal)arRec.get('TechTY'));
           newRec.Tech_Total_LY__c = ((decimal)arRec.get('TechTotalLY'));
           newRec.Tech_Pot__c = ((decimal)arRec.get('TechPot'));
           newRec.Tech_LY__c = ((decimal)arRec.get('TechLY'));
           newRec.Tech_Last_Order_amt__c = ((decimal)arRec.get('TechLastOrder'));
           newRec.Tech_IMU_TY__c = ((decimal)arRec.get('TechIMUTY'));
           newRec.Tech_IMU_LY__c = ((decimal)arRec.get('TechIMULY'));
           newRec.Sales__c = ((decimal)arRec.get('Sales'));
           newRec.Quarter_LY_IMU__c = ((decimal)arRec.get('QuarterLYIMU'));
           newRec.Quarter_Goal__c = ((decimal)arRec.get('QuarterGoal'));
           newRec.QTD_Sales_TY_IMU__c=((decimal)arRec.get('QTDSalesTYIMU'));
           newRec.QTD_Sales_TY__c = ((decimal)arRec.get('QTDSalesTY'));
           newRec.QTD_Sales_LY_IMU__c =((decimal)arRec.get('QTDSalesLYIMU'));
           newRec.QTD_Sales_LY__c = ((decimal)arRec.get('QTDSalesLY'));
           newRec.Paper_TY__c = ((decimal)arRec.get('PaperTY'));
           newRec.Paper_Total_LY__c = ((decimal)arRec.get('PaperTotalLY'));
           newRec.Paper_Pot__c = ((decimal)arRec.get('PaperPot'));
           newRec.Paper_LY__c = ((decimal)arRec.get('PaperLY'));
           newRec.Paper_Last_Order_amt__c = ((decimal)arRec.get('PaperLastOrder'));
           newRec.Paper_IMU_TY__c = ((decimal)arRec.get('PaperIMUTY'));
           newRec.Paper_IMU_LY__c = ((decimal)arRec.get('PaperIMULY'));
           newRec.Office_Essentials_TY__c = ((decimal)arRec.get('OfficeETY'));
           newRec.Office_Essentials_Total_LY__c = ((decimal)arRec.get('OfficeETotalLY'));
           newRec.Office_Essentials_Pot__c = ((decimal)arRec.get('OfficeEPot'));
           newRec.Office_Essentials_LY__c = ((decimal)arRec.get('OfficeELY'));
           newRec.Office_Essentials_Last_Order_amt__c = ((decimal)arRec.get('OfficeELastOrder'));
           newRec.Office_Essentials_IMU_TY__c = ((decimal)arRec.get('OfficeEIMUTY'));
           newRec.Office_Essentials_IMU_LY__c = ((decimal)arRec.get('OfficeEIMULY'));
           newRec.MTD_Sales_TY_IMU__c = ((decimal)arRec.get('MTDSalesTYIMU'));
           newRec.MTD_Sales_TY__c = ((decimal)arRec.get('MTDSalesTY'));
           newRec.MTD_Sales_LY_IMU__c = ((decimal)arRec.get('MTDSalesLYIMU'));
           newRec.MTD_Sales_LY__c = ((decimal)arRec.get('MTDSalesLY'));
           newRec.MPS_TY__c = ((decimal)arRec.get('MPSTY'));
           newRec.MPS_Total_LY__c = ((decimal)arRec.get('MPSTotalLY'));
           newRec.MPS_Pot__c = ((decimal)arRec.get('MPSPot'));
           newRec.MPS_LY__c = ((decimal)arRec.get('MPSLY'));
           newRec.MPS_Last_Order_amt__c = ((decimal)arRec.get('MPSLastOrder'));
           newRec.MPS_IMU_TY__c = ((decimal)arRec.get('MPSIMUTY'));
           newRec.MPS_IMU_LY__c = ((decimal)arRec.get('MPSIMULY'));
           newRec.Monthly_LY_IMU__c = ((decimal)arRec.get('MonthLYIMU'));
           newRec.Month_Goal__c = ((decimal)arRec.get('MonthGoal'));
           newRec.Miscellaneous_TY__c = ((decimal)arRec.get('MTY'));
           newRec.Miscellaneous_Total_LY__c = ((decimal)arRec.get('MTotalLY'));
           newRec.Miscellaneous_Pot__c = ((decimal)arRec.get('MPot'));
           newRec.Miscellaneous_LY__c = ((decimal)arRec.get('MLY'));
           newRec.Miscellaneous_Last_Order_amt__c = ((decimal)arRec.get('MLastOrder'));
           newRec.Miscellaneous_IMU_TY__c = ((decimal)arRec.get('MIMUTY'));
           newRec.Miscellaneous_IMU_LY__c = ((decimal)arRec.get('MIMULY'));
           newRec.Labels_Forms_TY__c = ((decimal)arRec.get('LFTY'));
           newRec.Labels_Forms_Total_LY__c = ((decimal)arRec.get('LFTotalLY'));
           newRec.Labels_Forms_Pot__c = ((decimal)arRec.get('LFPot'));
           newRec.Labels_Forms_LY__c = ((decimal)arRec.get('LFLY'));
           newRec.Labels_Forms_Last_Order_amt__c = ((decimal)arRec.get('LFLastOrder'));
           newRec.Labels_Forms_IMU_TY__c = ((decimal)arRec.get('LFIMUTY'));
           newRec.Labels_Forms_IMU_LY__c = ((decimal)arRec.get('LFIMULY'));
           newRec.Ink_Toner_TY__c = ((decimal)arRec.get('InkTTY'));
           newRec.Ink_Toner_Total_LY__c = ((decimal)arRec.get('InkTTotalLY'));
           newRec.Ink_Toner_Pot__c = ((decimal)arRec.get('InkTPot'));
           newRec.Ink_Toner_LY__c = ((decimal)arRec.get('InkTLY'));
           newRec.Ink_Toner_Last_Order_amt__c = ((decimal)arRec.get('InkTLastOrder'));
           newRec.Ink_Toner_IMU_TY__c = ((decimal)arRec.get('InkTIMUTY'));
           newRec.Ink_Toner_IMU_LY__c = ((decimal)arRec.get('InkTIMULY'));
           newRec.Furniture_TY__c = ((decimal)arRec.get('FTY'));
           newRec.Furniture_Total_LY__c = ((decimal)arRec.get('FTotalLY'));
           newRec.Furniture_Pot__c = ((decimal)arRec.get('FPot'));
           newRec.Furniture_LY__c = ((decimal)arRec.get('FLY'));
           newRec.Furniture_Last_Order_amt__c = ((decimal)arRec.get('FLastOrder'));
           newRec.Furniture_IMU_TY__c = ((decimal)arRec.get('FIMUTY'));
           newRec.Furniture_IMU_LY__c = ((decimal)arRec.get('FIMULY')); 
           newRec.Filing_Binding_TY__c = ((decimal)arRec.get('FBTY'));
           newRec.Filing_Binding_Total_LY__c = ((decimal)arRec.get('FBTotalLY'));
           newRec.Filing_Binding_Pot__c = ((decimal)arRec.get('FBPot'));
           newRec.Filing_Binding_LY__c = ((decimal)arRec.get('FBLY'));
           newRec.Filing_Binding_Last_Order_amt__c = ((decimal)arRec.get('FBLastOrder'));
           newRec.GParent_GPID__c = ((decimal)arRec.get('GParentGPID'));
 
            

           orgUpsert.add(newRec);
           }
         }
         System.debug('&&&&&&&&&orgUpsert'+orgUpsert);
          Schema.SObjectField f = Sales_Data__C.Fields.Unique_Key__C;
          if(orgUpsert.size()>0){ 
          try{
          Database.UpsertResult [] cr=Database.Upsert(orgUpsert,f,false);
          System.debug('&&&&&&&here');
          for(Integer index = 0, size = cr.size(); index < size; index++) {
              if(cr[index].isSuccess()) {
                  system.debug('&&&&&&&&Id'+cr[index].getId());
              }

           }
          }
          catch(Exception e){
                   System.debug('&&&&&&&&&error'+e.getmessage());

          }
          }

       }
       //Resetting batch flag to false;
       update siteData;
    }
    }
    
    // This method is to execute to relase some resources if any
    global void finish(Database.BatchableContext BC)
    {    
     
     CustTransParentChildLevel__c PCLevel2 = [select OrgSalesSummaryBatchID__c,OrgSalesSummaryBatchInterval__c from 
            CustTransParentChildLevel__c limit 1];
        integer interval = 300;        
        if (PCLevel2.OrgSalesSummaryBatchID__c<> null) {
            for (CronTrigger existingJob: [SELECT Id FROM CronTrigger where ID=:PCLevel2.OrgSalesSummaryBatchID__c])
            system.abortJob(existingJob.id);
        }
        
        if(PCLevel2.OrgSalesSummaryBatchInterval__c!= null)
            interval = (Integer)PCLevel2.OrgSalesSummaryBatchInterval__c;
        
        DateTime sysTime = System.now().addSeconds(interval);
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        CreateOrgSalesDataRollUpNew SentDNSProcessingBatchObj = new CreateOrgSalesDataRollUpNew ();
        ID cronid = System.schedule( 'CreateOrgSalesDataRollUpNew' + sysTime, chronExpression, SentDNSProcessingBatchObj );    
        
        PCLevel2.OrgSalesSummaryBatchID__c= cronid;
        
        update PCLevel2;  
         
    }     
        
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        CreateOrgSalesDataRollUpNew SentDNSProcessingBatchObj = new CreateOrgSalesDataRollUpNew (strQuery);
        database.executebatch(SentDNSProcessingBatchObj, 500);
    } 
    
    
    
}