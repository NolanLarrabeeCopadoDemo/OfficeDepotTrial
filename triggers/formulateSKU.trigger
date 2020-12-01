//This trigger is to recalculate fields that are dependent on Price Changed by REP after the Approval
//Once the above task is done it calculates the rollup
trigger formulateSKU on Ace_Customer_SKU_Changes__c (before update, after Update) 
{    
   Map<id,Ace_Customer_SKU_Changes__c > oldTriggerMap;
    Ace_Customer_SKU_Changes__c oldSKU ; 
    List<Ace_Customer_SKU_Changes__c> oNewTrigger;
    if(Trigger.isbefore && Trigger.isUpdate){
        oldTriggerMap = Trigger.oldMap;
        oNewTrigger = new List<Ace_Customer_SKU_Changes__c>();
        //only applicable when the Approved_Proposed_Price__c  is updated
       
        for(Ace_Customer_SKU_Changes__c newSKU: Trigger.New) { 
         
            oldSKU = oldTriggerMap.get(newSKU.Id);
            
             if(newSKU.Approved_Proposed_Price__c != oldSKU.Approved_Proposed_Price__c){   
                 oNewTrigger.add(newSKU) ;                               
              }

          }//End of For Loop
          
          if(oNewTrigger.size()>0)
          SkuManagement.Updaterecord(oNewTrigger , oldTriggerMap); 
    }//End of Before Update
    
   if(Trigger.isafter && Trigger.isUpdate){
   //The below code is for the Recalculating Rollup's
   Set<id> CoreID_rollup = new Set<id>();
   set<id> CustomerID = new SET<id>();
   Set<Id> SKUID = new Set<Id>();
   oldTriggerMap = Trigger.oldMap;
   list<Ace_Customer_SKU_Changes__c> sku_core = new list<Ace_Customer_SKU_Changes__c>();
   for(Ace_Customer_SKU_Changes__c newSKU: Trigger.New) {  
    oldSKU = oldTriggerMap.get(newSKU.Id);
     if((newSKU.Approved_Proposed_Price__c != oldSKU.Approved_Proposed_Price__c)||(newSKU.Status__c!=oldSKU.Status__c)){         
                 SKUID.add(newSKU.id) ;
                 
            
         }
      }
      
      if(SKUID.size()>0){
          sku_core = new list<Ace_Customer_SKU_Changes__c>();
          sku_core = [select Ace_Customer_Core_Changes__c from Ace_Customer_SKU_Changes__c where id=:SKUID ];
     
      }
      if(sku_core.size()>0){
          for(Ace_Customer_SKU_Changes__c s:sku_core ){
              CoreID_rollup.add(s.Ace_Customer_Core_Changes__c ) ;         
          }     
      }
      
      if(CoreID_rollup.size()>0){

      //Then start doing rollup with SKU and follow with Cores
       //Assuming the Batch Id will be Same 
       String batchId = Trigger.New[0].batchId__c;
       
       List<Ace_Customer_Core_Changes__c > qs = [SELECT id,ACE_Customer_Price_Changes__c,Item_3_Month_Sales__c,Item_6_Month_Sales__c ,Item_9_Month_Sales__c ,
              Item_12_Month_Sales__c , Item_3_Month_Qty__c, Item_6_Month_Qty__c , Item_9_Month_Qty__c,Item_12_Month_Qty__c,  
              Forecasted_Spend_3_Month__c,Forecasted_Spend_6_Month__c,Forecasted_Spend_9_Month__c,Forecasted_Spend_12_Month__c, 
              Old_WATD_SRM1__c, Old_WAPO_Margin1__c, 
              Old_Gross_IGM__c, New_Sell_Price_Dollar_Change_Amount__c, Total_Spend_Impact_3_Month__c,Total_Spend_Impact_6_Month__c,Total_Spend_Impact_9_Month__c, 
              Total_Spend_Impact_12_Month__c, 
              WATD_Cost_Change1__c, New_Gross_IGM__c,
              New_IGM_Change__c, Cap_Lost_Margin_Dollar__c,Cap_Lost_Margin_Dollar_3_Month__c, Cap_Lost_Margin_Dollar_6_Month__c, Cap_Lost_Margin_Dollar_9_Month__c, 
              Cap_Lost_Margin_Dollar_12_Month__c, 
              Proposed_SRM_with_Cap1__c, Proposed_WAPO_Margin_with_Cap1__c, 
              Margin_Exposure_before_change__c, Margin_Exposure_3_Month__c, Margin_Exposure_6_Month__c, Margin_Exposure_9_Month__c, 
              Margin_Exposure_12_Month__c, Current_Margin__c, Current_Margin_3_Month__c, Current_Margin_6_Month__c, Current_Margin_9_Month__c, 
              Current_Margin_12_Month__c, Projected_Margin__c, Projected_Margin_3_Month__c, Projected_Margin_6_Month__c, 
              Projected_Margin_9_Month__c, Projected_Margin_12_Month__c,SRM_Differential__c,
              New_WATD_Cost__c, Old_WATD__c, New_WAPO_Cost__c,Old_WAPO__c,Current_Sell_Price__c,New_List_Price__c,Proposed_Price_with_Cap__c,
              Proposed_Price_Without_Cap__c 
              FROM Ace_Customer_Core_Changes__c where id=:CoreID_rollup and batchId__c =:batchId];            
       
           ACE_Customer_skuRollups rp = new ACE_Customer_skuRollups();
           rp.rollupCores(qs,batchId);
           
           for(Ace_Customer_Core_Changes__c  c:qs){
               CustomerID.add(c.ACE_Customer_Price_Changes__c) ;
           }
           
           //Pricing/Customer Rollup's
           
            List<ACE_Customer_Price_Changes__c> qs_cust = [SELECT id,Item_3_Month_Sales__c,Item_6_Month_Sales__c ,Item_9_Month_Sales__c ,
              Item_12_Month_Sales__c , Item_3_Month_Qty__c, Item_6_Month_Qty__c , Item_9_Month_Qty__c,Item_12_Month_Qty__c,  
              Forecasted_Spend_3_Month__c,Forecasted_Spend_6_Month__c,Forecasted_Spend_9_Month__c,Forecasted_Spend_12_Month__c, 
              Old_WATD_SRM1__c, Old_WAPO_Margin1__c, 
              Old_Gross_IGM__c, New_Sell_Price_Dollar_Change_Amount__c, Total_Spend_Impact_3_Month__c,Total_Spend_Impact_6_Month__c,Total_Spend_Impact_9_Month__c, 
              Total_Spend_Impact_12_Month__c,
              WATD_Cost_Change1__c, New_Gross_IGM__c,
              New_IGM_Change__c, Cap_Lost_Margin_Dollar__c,Cap_Lost_Margin_Dollar_3_Month__c, Cap_Lost_Margin_Dollar_6_Month__c, Cap_Lost_Margin_Dollar_9_Month__c, 
              Cap_Lost_Margin_Dollar_12_Month__c,
              Proposed_SRM_with_Cap1__c, Proposed_WAPO_Margin_with_Cap1__c, 
              Margin_Exposure_before_change__c, Margin_Exposure_3_Month__c, Margin_Exposure_6_Month__c, Margin_Exposure_9_Month__c, 
              Margin_Exposure_12_Month__c, Current_Margin__c, Current_Margin_3_Month__c, Current_Margin_6_Month__c, Current_Margin_9_Month__c, 
              Current_Margin_12_Month__c, Projected_Margin__c, Projected_Margin_3_Month__c, Projected_Margin_6_Month__c, 
              Projected_Margin_9_Month__c, Projected_Margin_12_Month__c, SRM_Differential__c,
              New_WATD_Cost__c, Old_WATD__c, New_WAPO_Cost__c,Old_WAPO__c,Current_Sell_Price__c,New_List_Price__c,Proposed_Price_with_Cap__c,
              Proposed_Price_Without_Cap__c  
              FROM ACE_Customer_Price_Changes__c where id=:CustomerID and batchId__c =:batchId];            
       
           ACE_Customer_skuRollups rp_core = new ACE_Customer_skuRollups();
           rp_core.rollupCustomerPricing(qs_cust,batchId);

       
       }
  
       
   }  
    
}