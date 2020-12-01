//This class will be called from the SKU Trigger - formulateSKU 
public class SkuManagement {
    
    public static void Updaterecord(List<Ace_Customer_SKU_Changes__c>  newTrigger, Map<id,Ace_Customer_SKU_Changes__c>  oldTriggerMap){
       
        for(Ace_Customer_SKU_Changes__c newSKU: newTrigger) {  
            // Get the old Snapshot
            Ace_Customer_SKU_Changes__c oldSKU = oldTriggerMap.get(newSKU.Id);
            
            system.debug('newTrigger Values : '+newTrigger) ;
            system.debug('oldTriggerMap Values : '+oldTriggerMap) ;
            Decimal PP = newSKU.Approved_Proposed_Price__c ;
            //Change the impacted Values 
            if (pp != null) {
             if (newSKU.Item_3_Month_Qty__c != null)          
              newSKU.Forecasted_Spend_3_Month__c = newSKU.Item_3_Month_Qty__c*PP ;
             if (newSKU.Item_6_Month_Qty__c != null)
              newSKU.Forecasted_Spend_6_Month__c = newSKU.Item_6_Month_Qty__c*PP ;
             if (newSKU.Item_9_Month_Qty__c != null)
              newSKU.Forecasted_Spend_9_Month__c = newSKU.Item_9_Month_Qty__c*PP ;
             if (newSKU.Item_12_Month_Qty__c != null)
              newSKU.Forecasted_Spend_12_Month__c = newSKU.Item_12_Month_Qty__c*PP ;
             if (newSKU.Current_Sell_Price__c != null)
              newSKU.New_Sell_Price_Dollar_Change_Amount__c = PP  - newSKU.Current_Sell_Price__c;
            }
            
            if (newSKU.New_Sell_Price_Dollar_Change_Amount__c != null) {
             if (newSKU.Item_3_Month_Qty__c != null)
              newSKU.Total_Spend_Impact_3_Month__c = newSKU.New_Sell_Price_Dollar_Change_Amount__c * newSKU.Item_3_Month_Qty__c;
             if (newSKU.Item_6_Month_Qty__c != null)
              newSKU.Total_Spend_Impact_6_Month__c = newSKU.New_Sell_Price_Dollar_Change_Amount__c * newSKU.Item_6_Month_Qty__c;
             if (newSKU.Item_9_Month_Qty__c != null)
              newSKU.Total_Spend_Impact_9_Month__c = newSKU.New_Sell_Price_Dollar_Change_Amount__c * newSKU.Item_9_Month_Qty__c;
             if (newSKU.Item_12_Month_Qty__c != null)
              newSKU.Total_Spend_Impact_12_Month__c = newSKU.New_Sell_Price_Dollar_Change_Amount__c * newSKU.Item_12_Month_Qty__c;
            }
           
           if (newSKU.New_Sell_Price_Dollar_Change_Amount__c != null && newSKU.Current_Sell_Price__c != null)
            if(newSKU.Current_Sell_Price__c != 0)
             newSKU.New_Sell_Price_Percentage_Change_Amoun__c = (newSKU.New_Sell_Price_Dollar_Change_Amount__c/newSKU.Current_Sell_Price__c)*100;
            
           if (pp != null) {
           	if (newSKU.New_WANET_Cost__c != null)
             newSKU.New_Gross_IGM__c = PP - newSKU.New_WANET_Cost__c;
           if(PP!=0)
            newSKU.New_Gross_IGM1__c = (1-(newSKU.New_WANET_Cost__c/PP))*100;
           }
           
           if (newSKU.Old_Gross_IGM1__c != null && newSKU.New_Gross_IGM1__c != null)
            newSKU.Gross_IGM_Basis_Point_Increase__c = (newSKU.New_Gross_IGM1__c - newSKU.Old_Gross_IGM1__c)*100;
           if (newSKU.New_Gross_IGM__c != null && newSKU.Old_Gross_IGM__c != null)
            newSKU.New_IGM_Change__c = newSKU.New_Gross_IGM__c - newSKU.Old_Gross_IGM__c;
           if(PP!=0 && PP != null){
           	if(newSKU.New_WATD_Cost__c != null)
             newSKU.Proposed_SRM_with_Cap__c = (1-(newSKU.New_WATD_Cost__c/PP))*100;  
            if (newSKU.New_WAPO_Cost__c != null)         
             newSKU.Proposed_WAPO_Margin_with_Cap__c = (1-(newSKU.New_WAPO_Cost__c/PP))*100;
           }
            if (pp != null && newSKU.New_WATD_Cost__c != null)
             newSKU.Proposed_SRM_with_Cap1__c =  PP-newSKU.New_WATD_Cost__c;
            if(newSKU.New_List_Price__c !=0 && pp != null && newSKU.New_List_Price__c != null && newSKU.New_List_Price__c != null)
             newSKU.Proposed_New_List_Less_Disc_Without_Cap__c = ((newSKU.New_List_Price__c - PP)/newSKU.New_List_Price__c)*100 ;
            if (PP != null && newSKU.New_WAPO_Cost__c != null)
             newSKU.Projected_Margin__c = PP - newSKU.New_WAPO_Cost__c;
            if (newSKU.Projected_Margin__c != null) {
             if (newSKU.Item_3_Month_Qty__c != null)
              newSKU.Projected_Margin_3_Month__c =  newSKU.Projected_Margin__c*newSKU.Item_3_Month_Qty__c;  
             if (newSKU.Item_6_Month_Qty__c != null)
              newSKU.Projected_Margin_6_Month__c =  newSKU.Projected_Margin__c*newSKU.Item_6_Month_Qty__c; 
             if (newSKU.Item_9_Month_Qty__c != null)
              newSKU.Projected_Margin_9_Month__c =  newSKU.Projected_Margin__c*newSKU.Item_9_Month_Qty__c; 
             if (newSKU.Item_12_Month_Qty__c != null)
              newSKU.Projected_Margin_12_Month__c =  newSKU.Projected_Margin__c*newSKU.Item_12_Month_Qty__c; 
            }
            if (newSKU.Proposed_SRM_with_Cap__c != null && newSKU.Old_WATD_SRM__c != null)
             newSKU.SRM_Basis_Point_Increase__c = (newSKU.Proposed_SRM_with_Cap__c - newSKU.Old_WATD_SRM__c)*100;
            if (newSKU.Proposed_SRM_with_Cap1__c != null && newSKU.Old_WATD_SRM1__c != null)
             newSKU.SRM_Differential__c = newSKU.Proposed_SRM_with_Cap1__c - newSKU.Old_WATD_SRM1__c;
                  
          } 
        
        
        
       
    
    }
    
    

}