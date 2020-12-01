public with sharing class ACE_Customer_skuRollups {
public static boolean userByPass = false;
// constructor
    public ACE_Customer_skuRollups () {
    
        list<ACE_Settings__c> desettings =[SELECT Id, trigger_by_pass__c from ACE_Settings__c limit 1];
        if(desettings[0]!= null) {
            if (desettings[0].trigger_by_pass__c != null) {
              userByPass = desettings[0].trigger_by_pass__c.contains(userInfo.getUserId());
              
            }
        }
    
    }
    
    public void rollupCores( list<Ace_Customer_Core_Changes__c> accc, String batchId ) {
    // roll up Skus for a set of Cores

        if (accc != null && !accc.isEmpty()) {
            rollUpCores( new map<id, Ace_Customer_Core_Changes__c>(accc), batchId );
        }
    }
    public void rollupCustomerPricing(list<ACE_Customer_Price_Changes__c> acpc, String batchId ){
    // roll up Cores for the Cusotmer
        if(acpc != null && !acpc .isEmpty()){
            rollupCustomerPricing(new map<id,ACE_Customer_Price_Changes__c>(acpc), batchId );
        }
    }

    public void rollUpCores(map<id,Ace_Customer_Core_Changes__c> cmap, String batchId ){
    // roll up sku's to their respective core's
       System.debug('Core Rollup is called');
        map<id, Ace_Customer_Core_Changes__c> coresToUpdate = new map<id, Ace_Customer_Core_Changes__c>();
        map<id, Ace_Customer_Core_Changes__c> coresToUpdate2 = new map<id, Ace_Customer_Core_Changes__c>();
        set<id> allCores = cmap.keyset();
        for(id cid : allCores ){
            coresToUpdate.put(cid, new Ace_Customer_Core_Changes__c(
            id = cid,
            Item_3_Month_Sales__c = 0,
            Item_6_Month_Sales__c = 0,
            Item_9_Month_Sales__c = 0,
            Item_12_Month_Sales__c = 0,
            Item_3_Month_Qty__c = 0,
            Item_6_Month_Qty__c  = 0,
            Item_9_Month_Qty__c = 0,
            Item_12_Month_Qty__c = 0,
            Forecasted_Spend_3_Month__c = 0,
            Forecasted_Spend_6_Month__c = 0,
            Forecasted_Spend_9_Month__c = 0,
            Forecasted_Spend_12_Month__c = 0,
            Old_WATD_SRM1__c = 0,
            Old_WAPO_Margin1__c = 0,
            Old_Gross_IGM__c = 0,
            New_Sell_Price_Dollar_Change_Amount__c = 0,
            Total_Spend_Impact_3_Month__c = 0,
            Total_Spend_Impact_6_Month__c = 0,
            Total_Spend_Impact_9_Month__c = 0,
            Total_Spend_Impact_12_Month__c = 0,
            Report_New_Gross_IGM_ACE__c = 0,
            Report_Total_Spend_Impact_12_Month_ACE__c = 0,
            WATD_Cost_Change1__c = 0,
            New_Gross_IGM__c = 0,
            //New_Gross_IGM1__c = 0,
            New_IGM_Change__c = 0,
            Cap_Lost_Margin_Dollar__c = 0,
            Cap_Lost_Margin_Dollar_3_Month__c = 0,
            Cap_Lost_Margin_Dollar_6_Month__c = 0,
            Cap_Lost_Margin_Dollar_9_Month__c = 0,
            Cap_Lost_Margin_Dollar_12_Month__c = 0,
            Proposed_SRM_with_Cap1__c = 0,
            Proposed_WAPO_Margin_with_Cap1__c = 0,
            Margin_Exposure_before_change__c = 0,
            Margin_Exposure_3_Month__c = 0,
            Margin_Exposure_6_Month__c = 0,
            Margin_Exposure_9_Month__c = 0,
            Margin_Exposure_12_Month__c = 0,
            Current_Margin__c = 0,
            Current_Margin_3_Month__c = 0,
            Current_Margin_6_Month__c = 0,
            Current_Margin_9_Month__c = 0,
            Current_Margin_12_Month__c = 0,
            Projected_Margin__c = 0,
            Projected_Margin_3_Month__c = 0,
            Projected_Margin_6_Month__c = 0,
            Projected_Margin_9_Month__c = 0,
            Projected_Margin_12_Month__c = 0,
            SRM_Differential__c = 0,
            //New Fields that will be used in the calculations -
            New_WATD_Cost__c = 0,
            Old_WATD__c = 0, 
            New_WAPO_Cost__c = 0,
            Old_WAPO__c =0 ,
            Current_Sell_Price__c = 0,
            New_List_Price__c = 0,
            Proposed_Price_with_Cap__c = 0,
            Proposed_Price_Without_Cap__c = 0,
            Reporting_Erosion_Margin__c = 0,
            Reporting_Erosion_Margin_CAP__c = 0,
            Reporting_Erosion_Revenue__c = 0,
            Reporting_Erosion_Revenue_CAP__c = 0,
            Reporting_Erosion_Field_MarkDown__c = 0
            //Add all the Core Field that need roll-up
            ));
        
        }
        
        for (sobject r : [SELECT Ace_Customer_Core_Changes__c, 
                
                SUM(Item_3_Month_Sales__c) i3ms, SUM(Item_6_Month_Sales__c) i6ms,
                SUM(Item_9_Month_Sales__c) i9ms, SUM(Item_12_Month_Sales__c) i12ms,                
                SUM(Item_3_Month_Qty__c) i3mq, SUM(Item_6_Month_Qty__c) i6mq, 
                SUM(Item_9_Month_Qty__c) i9mq, SUM(Item_12_Month_Qty__c) i12mq,
                SUM(Forecasted_Spend_3_Month__c) fs3m , SUM(Forecasted_Spend_6_Month__c) fs6m,
                SUM(Forecasted_Spend_9_Month__c) fs9m , SUM(Forecasted_Spend_12_Month__c) fs12m,
                SUM(Old_WATD_SRM1__c) ows1,
                SUM(Old_WAPO_Margin1__c) owm1 ,
                SUM(Old_Gross_IGM__c) ogi ,
                SUM(New_Sell_Price_Dollar_Change_Amount__c) nspdca , SUM(Total_Spend_Impact_3_Month__c) tsi3m ,
                SUM(Total_Spend_Impact_6_Month__c) tsi6m , SUM(Total_Spend_Impact_9_Month__c) tsi9m,
                SUM(Total_Spend_Impact_12_Month__c) tsi12m ,
                SUM(WATD_Cost_Change1__c) watdcc1 ,SUM(New_Gross_IGM__c) ngi,
                SUM(New_IGM_Change__c) nic , SUM(Cap_Lost_Margin_Dollar__c) clmd,
                SUM(Cap_Lost_Margin_Dollar_3_Month__c) clmd3m ,SUM(Cap_Lost_Margin_Dollar_6_Month__c) clmd6m ,
                SUM(Cap_Lost_Margin_Dollar_9_Month__c) clmd9m ,SUM(Cap_Lost_Margin_Dollar_12_Month__c) clmd12m ,
                SUM(Proposed_SRM_with_Cap1__c) pswc1 , SUM(Proposed_WAPO_Margin_with_Cap1__c) pwmwc1,
                SUM(Margin_Exposure_before_change__c) mebc ,
                SUM(Margin_Exposure_3_Month__c) me3m ,SUM(Margin_Exposure_6_Month__c) me6m,
                SUM(Margin_Exposure_9_Month__c) me9m ,SUM(Margin_Exposure_12_Month__c ) me12m,
                SUM(Current_Margin__c) cm , SUM(Current_Margin_3_Month__c) cm3m ,
                SUM(Current_Margin_6_Month__c) cm6m , SUM(Current_Margin_9_Month__c) cm9m,
                SUM(Current_Margin_12_Month__c) cm12m , SUM(Projected_Margin__c ) pm, 
                SUM(Projected_Margin_3_Month__c) pm3m , SUM(Projected_Margin_6_Month__c) pm6m ,
                SUM(Projected_Margin_9_Month__c) pm9m ,SUM(Projected_Margin_12_Month__c) pm12m,
                SUM(SRM_Differential__c) sd,
                //New Fields that will be used in the calculations -
                SUM(New_WATD_Cost__c) nwc, SUM(Old_WATD__c) owc,
                SUM(New_WAPO_Cost__c) nwpc, SUM(Old_WAPO__c) owpc,
                SUM(Current_Sell_Price__c) csp, SUM(New_List_Price__c) nlp,
                SUM(Proposed_Price_with_Cap__c) ppwc, SUM(Proposed_Price_Without_Cap__c) ppwoc,
                SUM(Reporting_Erosion_Revenue__c) rer, SUM(Reporting_Erosion_Margin__c) rem,
                SUM(Reporting_Erosion_Revenue_CAP__c) rerC,SUM(Reporting_Erosion_Margin_CAP__c) remC,
                SUM(Reporting_Erosion_Field_MarkDown__c) refm,
                SUM(Reporting_Erosion_Margin_Field_MarkDown__c) remfm,
                SUM(Report_New_Gross_IGM_ACE__c) rngi,
                SUM(Report_Total_Spend_Impact_12_Month_ACE__c) rtsi12m,
                count(id) skuTotal
              
             FROM Ace_Customer_SKU_Changes__c
             WHERE batchId__c =: batchId
             AND Status__C = 'Active'
             AND Update_Timing_Action__c = 'T'//ROM-37 - to not showup in detail page for the records with Update_Timing_Action__c = 'F'
             AND Ace_Customer_Core_Changes__c IN : allCores 
             GROUP BY Ace_Customer_Core_Changes__c]){
             
             // get the Core id for this result row
             id core_id = (id)(r.get('Ace_Customer_Core_Changes__c'));
             
             updateRollupFromResult((sobject)(coresToUpdate.get(core_id )), r);
             
             }      
            // update all the Cores from this batch 
        update coresToUpdate.values();
        
       // Added for Updating Reporting values
        for(id cid : allCores ){
            coresToUpdate2.put(cid, new Ace_Customer_Core_Changes__c(
            id = cid,
            Report_New_Gross_IGM_ACE__c = 0,
            Report_Total_Spend_Impact_12_Month_ACE__c = 0
            //Add all the Core Field that need roll-up
            ));
        
        }
        for (sobject r2 : [SELECT Ace_Customer_Core_Changes__c, 
                SUM(Report_New_Gross_IGM_ACE__c) rngi,
                SUM(Report_Total_Spend_Impact_12_Month_ACE__c) rtsi12m
             FROM Ace_Customer_SKU_Changes__c
             WHERE batchId__c =: batchId
             AND Status__C <> 'Inactive'
             AND Update_Timing_Action__c = 'T'//ROM-37 - to not showup in detail page for Update_Timing_Action__c = 'F'
             AND Ace_Customer_Core_Changes__c IN : allCores 
             GROUP BY Ace_Customer_Core_Changes__c]){
             
             // get the Core id for this result row
             id core_id2 = (id)(r2.get('Ace_Customer_Core_Changes__c'));
             ace_customer_core_changes__c core = new ace_customer_core_changes__c(id = core_id2);
             core.Report_New_Gross_IGM_ACE__c = (Decimal)r2.get('rngi');
             core.Report_Total_Spend_Impact_12_Month_ACE__c = (Decimal)r2.get('rtsi12m');
             
             //updateRollupFromResult((sobject)(coresToUpdate2.get(core_id2 )), r2);
             coresToUpdate2.put(core_id2,core);
             }      
            // update all the Cores from this batch 
            update coresToUpdate2.values();
        
         
    
    }
    
     public void rollupCustomerPricing(map<id,ACE_Customer_Price_Changes__c >cpmap, String batchId){
        // roll up Core's to their respective Pricing Customer
        map<id, ACE_Customer_Price_Changes__c > CPToUpdate = new map<id, ACE_Customer_Price_Changes__c >();
        set<id> allCust = cpmap.keyset();
        for(id cpid : allCust){
            CPToUpdate.put(cpid, new ACE_Customer_Price_Changes__c(
            id = cpid,
            Item_3_Month_Sales__c = 0,
            Item_6_Month_Sales__c = 0,
            Item_9_Month_Sales__c = 0,
            Item_12_Month_Sales__c = 0,
            Item_3_Month_Qty__c = 0,
            Item_6_Month_Qty__c  = 0,
            Item_9_Month_Qty__c = 0,
            Item_12_Month_Qty__c = 0,
            Forecasted_Spend_3_Month__c = 0,
            Forecasted_Spend_6_Month__c = 0,
            Forecasted_Spend_9_Month__c = 0,
            Forecasted_Spend_12_Month__c = 0,
            Old_WATD_SRM1__c = 0,
            Old_WAPO_Margin1__c = 0,
            Old_Gross_IGM__c = 0,
            New_Sell_Price_Dollar_Change_Amount__c = 0,
            Total_Spend_Impact_3_Month__c = 0,
            Total_Spend_Impact_6_Month__c = 0,
            Total_Spend_Impact_9_Month__c = 0,
            Total_Spend_Impact_12_Month__c = 0,
            WATD_Cost_Change1__c = 0,
            New_Gross_IGM__c = 0,
            //New_Gross_IGM1__c = 0,
            New_IGM_Change__c = 0,
            Cap_Lost_Margin_Dollar__c = 0,
            Cap_Lost_Margin_Dollar_3_Month__c = 0,
            Cap_Lost_Margin_Dollar_6_Month__c = 0,
            Cap_Lost_Margin_Dollar_9_Month__c = 0,
            Cap_Lost_Margin_Dollar_12_Month__c = 0,
            Proposed_SRM_with_Cap1__c = 0,
            Proposed_WAPO_Margin_with_Cap1__c = 0,
            Margin_Exposure_before_change__c = 0,
            Margin_Exposure_3_Month__c = 0,
            Margin_Exposure_6_Month__c = 0,
            Margin_Exposure_9_Month__c = 0,
            Margin_Exposure_12_Month__c = 0,
            Current_Margin__c = 0,
            Current_Margin_3_Month__c = 0,
            Current_Margin_6_Month__c = 0,
            Current_Margin_9_Month__c = 0,
            Current_Margin_12_Month__c = 0,
            Projected_Margin__c = 0,
            Projected_Margin_3_Month__c = 0,
            Projected_Margin_6_Month__c = 0,
            Projected_Margin_9_Month__c = 0,
            Projected_Margin_12_Month__c = 0,
            SRM_Differential__c = 0,
            //New Fields that will be used in the calculations -
            New_WATD_Cost__c = 0,
            Old_WATD__c = 0, 
            New_WAPO_Cost__c = 0,
            Old_WAPO__c =0 ,
            Current_Sell_Price__c = 0,
            New_List_Price__c = 0,
            Proposed_Price_with_Cap__c = 0,
            Proposed_Price_Without_Cap__c = 0,
            Reporting_Erosion_Margin__c = 0,
            Reporting_Erosion_Margin_CAP__c = 0,
            Reporting_Erosion_Revenue__c = 0,
            Reporting_Erosion_Revenue_CAP__c = 0,
            Reporting_Erosion_Field_MarkDown__c = 0,
            Report_New_Gross_IGM_ACE__c = 0,
            Report_Total_Spend_Impact_12_Month_ACE__c = 0
            //Add all the Customer Pricing  Field that need roll-up
            ));
        
        }
        Set<Id> CustomerId = new Set<Id>(); 
        for (sobject r : [SELECT ACE_Customer_Price_Changes__c,         
                SUM(Item_3_Month_Sales__c) i3ms, SUM(Item_6_Month_Sales__c) i6ms,
                SUM(Item_9_Month_Sales__c) i9ms, SUM(Item_12_Month_Sales__c) i12ms,                
                SUM(Item_3_Month_Qty__c) i3mq, SUM(Item_6_Month_Qty__c) i6mq, 
                SUM(Item_9_Month_Qty__c) i9mq, SUM(Item_12_Month_Qty__c) i12mq,
                SUM(Forecasted_Spend_3_Month__c) fs3m , SUM(Forecasted_Spend_6_Month__c) fs6m,
                SUM(Forecasted_Spend_9_Month__c) fs9m , SUM(Forecasted_Spend_12_Month__c) fs12m,
                SUM(Old_WATD_SRM1__c) ows1,
                SUM(Old_WAPO_Margin1__c) owm1 ,
                SUM(Old_Gross_IGM__c) ogi , 
                SUM(New_Sell_Price_Dollar_Change_Amount__c) nspdca , SUM(Total_Spend_Impact_3_Month__c) tsi3m ,
                SUM(Total_Spend_Impact_6_Month__c) tsi6m , SUM(Total_Spend_Impact_9_Month__c) tsi9m,
                SUM(Total_Spend_Impact_12_Month__c) tsi12m ,  
                SUM(WATD_Cost_Change1__c) watdcc1 ,SUM(New_Gross_IGM__c) ngi,
                SUM(New_IGM_Change__c) nic , SUM(Cap_Lost_Margin_Dollar__c) clmd,
                SUM(Cap_Lost_Margin_Dollar_3_Month__c) clmd3m ,SUM(Cap_Lost_Margin_Dollar_6_Month__c) clmd6m ,
                SUM(Cap_Lost_Margin_Dollar_9_Month__c) clmd9m ,SUM(Cap_Lost_Margin_Dollar_12_Month__c) clmd12m ,
                SUM(Proposed_SRM_with_Cap1__c) pswc1 , SUM(Proposed_WAPO_Margin_with_Cap1__c) pwmwc1,
                SUM(Margin_Exposure_before_change__c) mebc ,
                SUM(Margin_Exposure_3_Month__c) me3m ,SUM(Margin_Exposure_6_Month__c) me6m,
                SUM(Margin_Exposure_9_Month__c) me9m ,SUM(Margin_Exposure_12_Month__c ) me12m,
                SUM(Current_Margin__c) cm , SUM(Current_Margin_3_Month__c) cm3m ,
                SUM(Current_Margin_6_Month__c) cm6m , SUM(Current_Margin_9_Month__c) cm9m,
                SUM(Current_Margin_12_Month__c) cm12m , SUM(Projected_Margin__c ) pm, 
                SUM(Projected_Margin_3_Month__c) pm3m , SUM(Projected_Margin_6_Month__c) pm6m ,
                SUM(Projected_Margin_9_Month__c) pm9m ,SUM(Projected_Margin_12_Month__c) pm12m,
                SUM(SRM_Differential__c) sd,
                //New Fields that will be used in the calculations -
                SUM(New_WATD_Cost__c) nwc, SUM(Old_WATD__c) owc,
                SUM(New_WAPO_Cost__c) nwpc, SUM(Old_WAPO__c) owpc,
                SUM(Current_Sell_Price__c) csp, SUM(New_List_Price__c) nlp,
                SUM(Proposed_Price_with_Cap__c) ppwc, SUM(Proposed_Price_Without_Cap__c) ppwoc,
                SUM(Reporting_Erosion_Revenue__c) rer, SUM(Reporting_Erosion_Margin__c) rem,
                SUM(Reporting_Erosion_Revenue_CAP__c) rerC,SUM(Reporting_Erosion_Margin_CAP__c) remC,
                SUM(Reporting_Erosion_Field_MarkDown__c) refm,
                SUM(Reporting_Erosion_Margin_Field_MarkDown__c) remfm,
                SUM(Report_New_Gross_IGM_ACE__c) rngi,
                SUM(Report_Total_Spend_Impact_12_Month_ACE__c) rtsi12m,
                SUM(Report_SKU_Count__c) skuTotal
             FROM Ace_Customer_Core_Changes__c
             WHERE batchId__c =: batchId
             AND ACE_Customer_Price_Changes__c IN : allCust 
             GROUP BY ACE_Customer_Price_Changes__c]){
             
             // get the Core id for this result row
             id core_id = (id)(r.get('ACE_Customer_Price_Changes__c'));
             
             updateRollupFromResult((sobject)(CPToUpdate.get(core_id )), r);
             // we will use this set to create the feed for their respective Customers    
             CustomerId.add(core_id);
             }
             
            // update all the Cores from this batch 
        update CPToUpdate.values();
         //create a chatter feed for all the customer records..
         if(CustomerId.size()> 0){
             List<FeedItem> lfeed = new List<FeedItem>();
             for(ACE_Customer_Price_Changes__c r: [SELECT Customer__c,Customer__r.name FROM ACE_Customer_Price_Changes__c where id=:CustomerId ]){
                FeedItem  fItem = new FeedItem();
                fItem.Type = 'TextPost';
                fItem.ParentId = r.Customer__c;
                fItem.Body = 'Price/Margin changes are Available for the current customer:'+r.Customer__r.name;
                lfeed.add(fItem);
             }
            insert lfeed;
         }
    }
    
    
    
    public static void updateRollupFromResult(sobject obj, sobject r) { 
            if(r.get('i3ms') != null)
            obj.put('Item_3_Month_Sales__c', (decimal)(r.get('i3ms'))); 
            if(r.get('i6ms') != null)
            obj.put('Item_6_Month_Sales__c', (decimal)(r.get('i6ms')));
            if(r.get('i9ms') != null)
            obj.put('Item_9_Month_Sales__c', (decimal)(r.get('i9ms')));
            if(r.get('i12ms') != null)
            obj.put('Item_12_Month_Sales__c', (decimal)(r.get('i12ms')));
            if(r.get('i3mq') != null)
            obj.put('Item_3_Month_Qty__c', (decimal)(r.get('i3mq')));
            if(r.get('i6mq') != null)
            obj.put('Item_6_Month_Qty__c', (decimal)(r.get('i6mq')));
            if(r.get('i9mq') != null)
            obj.put('Item_9_Month_Qty__c', (decimal)(r.get('i9mq')));
            if(r.get('i12mq') != null)
            obj.put('Item_12_Month_Qty__c', (decimal)(r.get('i12mq')));
            if(r.get('fs3m') != null)
            obj.put('Forecasted_Spend_3_Month__c', (decimal)(r.get('fs3m'))); 
            if(r.get('fs6m') != null)
            obj.put('Forecasted_Spend_6_Month__c', (decimal)(r.get('fs6m')));
            if(r.get('fs9m') != null)
            obj.put('Forecasted_Spend_9_Month__c', (decimal)(r.get('fs9m')));
            if(r.get('fs12m') != null)
            obj.put('Forecasted_Spend_12_Month__c', (decimal)(r.get('fs12m')));
            if(r.get('ows1') != null)
            obj.put('Old_WATD_SRM1__c', (decimal)(r.get('ows1')));
            if(r.get('owm1') != null)
            obj.put('Old_WAPO_Margin1__c', (decimal)(r.get('owm1')));
            if(r.get('ogi') != null)
            obj.put('Old_Gross_IGM__c', (decimal)(r.get('ogi')));
            if(r.get('nspdca') != null)
            obj.put('New_Sell_Price_Dollar_Change_Amount__c', (decimal)(r.get('nspdca')));
            if(r.get('tsi3m') != null)
            obj.put('Total_Spend_Impact_3_Month__c', (decimal)(r.get('tsi3m')));
            if(r.get('tsi6m') != null)
            obj.put('Total_Spend_Impact_6_Month__c', (decimal)(r.get('tsi6m')));
            if(r.get('tsi9m') != null)
            obj.put('Total_Spend_Impact_9_Month__c', (decimal)(r.get('tsi9m')));
            if(r.get('tsi12m') != null)
            obj.put('Total_Spend_Impact_12_Month__c', (decimal)(r.get('tsi12m')));
            if(r.get('watdcc1') != null)
            obj.put('WATD_Cost_Change1__c', (decimal)(r.get('watdcc1'))); 
            if(r.get('ngi') != null)
            obj.put('New_Gross_IGM__c', (decimal)(r.get('ngi'))); 
            if(r.get('nic') != null)
            obj.put('New_IGM_Change__c', (decimal)(r.get('nic'))); 
            if(r.get('clmd') != null)
            obj.put('Cap_Lost_Margin_Dollar__c', (decimal)(r.get('clmd'))); 
            if(r.get('clmd3m') != null)
            obj.put('Cap_Lost_Margin_Dollar_3_Month__c', (decimal)(r.get('clmd3m')));  
            if(r.get('clmd6m') != null)
            obj.put('Cap_Lost_Margin_Dollar_6_Month__c', (decimal)(r.get('clmd6m')));  
            if(r.get('clmd9m') != null)
            obj.put('Cap_Lost_Margin_Dollar_9_Month__c', (decimal)(r.get('clmd9m')));  
            if(r.get('clmd12m') != null)
            obj.put('Cap_Lost_Margin_Dollar_12_Month__c', (decimal)(r.get('clmd12m'))); 
            if(r.get('pswc1') != null)
            obj.put('Proposed_SRM_with_Cap1__c', (decimal)(r.get('pswc1')));
            if(r.get('pwmwc1') != null)
            obj.put('Proposed_WAPO_Margin_with_Cap1__c', (decimal)(r.get('pwmwc1')));
            if(r.get('mebc') != null)
            obj.put('Margin_Exposure_before_change__c', (decimal)(r.get('mebc')));
            if(r.get('me3m') != null)
            obj.put('Margin_Exposure_3_Month__c', (decimal)(r.get('me3m')));
            if(r.get('me6m') != null)
            obj.put('Margin_Exposure_6_Month__c', (decimal)(r.get('me6m')));
            if(r.get('me9m') != null)
            obj.put('Margin_Exposure_9_Month__c', (decimal)(r.get('me9m'))); 
            if(r.get('me12m') != null)
            obj.put('Margin_Exposure_12_Month__c', (decimal)(r.get('me12m'))); 
            if(r.get('cm') != null)
            obj.put('Current_Margin__c', (decimal)(r.get('cm'))); 
            if(r.get('cm3m') != null)
            obj.put('Current_Margin_3_Month__c', (decimal)(r.get('cm3m'))); 
            if(r.get('cm3m') != null)
            obj.put('Current_Margin_6_Month__c', (decimal)(r.get('cm6m')));
            if(r.get('cm9m') != null)
            obj.put('Current_Margin_9_Month__c', (decimal)(r.get('cm9m')));
            if(r.get('cm12m') != null)
            obj.put('Current_Margin_12_Month__c', (decimal)(r.get('cm12m')));
            if(r.get('pm') != null)
            obj.put('Projected_Margin__c', (decimal)(r.get('pm')));
            if(r.get('pm3m') != null)
            obj.put('Projected_Margin_3_Month__c', (decimal)(r.get('pm3m')));
            if(r.get('pm6m') != null)
            obj.put('Projected_Margin_6_Month__c', (decimal)(r.get('pm6m'))); 
            if(r.get('pm9m') != null)
            obj.put('Projected_Margin_9_Month__c', (decimal)(r.get('pm9m'))); 
            if(r.get('pm12m') != null)
            obj.put('Projected_Margin_12_Month__c', (decimal)(r.get('pm12m')));  
            if(r.get('sd') != null)
            obj.put('SRM_Differential__c', (decimal)(r.get('sd')));
            //NEW FIELD
            if(r.get('nwc') != null)
            obj.put('New_WATD_Cost__c', (decimal)(r.get('nwc')));
            if(r.get('owc') != null)
            obj.put('Old_WATD__c', (decimal)(r.get('owc')));
            if(r.get('nwpc') != null)
            obj.put('New_WAPO_Cost__c', (decimal)(r.get('nwpc')));
            if(r.get('owpc') != null)
            obj.put('Old_WAPO__c', (decimal)(r.get('owpc')));
            if(r.get('csp') != null)
            obj.put('Current_Sell_Price__c', (decimal)(r.get('csp')));
            if(r.get('nlp') != null)
            obj.put('New_List_Price__c', (decimal)(r.get('nlp')));
            if(r.get('ppwc') != null)
            obj.put('Proposed_Price_with_Cap__c', (decimal)(r.get('ppwc')));
            if(r.get('ppwoc') != null)
             obj.put('Proposed_Price_Without_Cap__c', (decimal)(r.get('ppwoc')));
            if(r.get('skuTotal') != null){
             if(userByPass){
             system.debug('Guha - trace log for report sku count >>>>>>>>');
             obj.put('Report_SKU_Count__c',(decimal)(r.get('skuTotal')));
             }
            } 
            if(r.get('rer') != null)
             obj.put('Reporting_Erosion_Revenue__c',(decimal)(r.get('rer')));
            if(r.get('rem') != null)
             obj.put('Reporting_Erosion_Margin__c',(decimal)(r.get('rem')));
            if(r.get('rerC') != null)
             obj.put('Reporting_Erosion_Revenue_CAP__c',(decimal)(r.get('rerC')));
            if(r.get('remC') != null)
             obj.put('Reporting_Erosion_Margin_CAP__c',(decimal)(r.get('remC')));
            if(r.get('refm') != null)
             obj.put('Reporting_Erosion_Field_MarkDown__c',(decimal)(r.get('refm')));
            if(r.get('remfm') != null)
             obj.put('Reporting_Erosion_Margin_Field_MarkDown__c',(decimal)(r.get('remfm')));
            if(r.get('rtsi12m') != null)
             obj.put('Report_Total_Spend_Impact_12_Month_ACE__c',(decimal)(r.get('rtsi12m')));
            if(r.get('rngi') != null)
             obj.put('Report_New_Gross_IGM_ACE__c',(decimal)(r.get('rngi')));
                  
    }
    
    

}