global class ACE_BATCH_skuRollup implements Database.Batchable<SObject> {
// batch apex class to rollup skus

    public String query { get; set; }
    public String batchId{ get; set; }
    
    // constructor
    // By passing the obj if String Q is empty it picks the default Query based on the Object:  
    public ACE_BATCH_skuRollup(String objectname, String q, String batchId_p){
        if((batchId_p != null)&&(batchId_p!= '')){
            this.batchId = batchId_p;
        }else{
            list<ACE_Settings__c> desettings =[SELECT Id, Name, BatchName__c from ACE_Settings__c limit 1];
            if(desettings[0]!= null)
                this.batchId = desettings[0].BatchName__c;
        }
        
        
        
        if((q != '')&&(q != null)){
            query = q; 
          }
          else{
              String qs = 'SELECT id,Item_3_Month_Sales__c,Item_6_Month_Sales__c ,Item_9_Month_Sales__c ,'
              +' Item_12_Month_Sales__c , Item_3_Month_Qty__c, Item_6_Month_Qty__c , Item_9_Month_Qty__c,Item_12_Month_Qty__c,  '
              +' Forecasted_Spend_3_Month__c,Forecasted_Spend_6_Month__c,Forecasted_Spend_9_Month__c,Forecasted_Spend_12_Month__c, '
              +' Old_WATD_SRM__c, Old_WATD_SRM1__c, Old_WAPO_Margin__c, Old_WAPO_Margin1__c, '
              +' Old_Gross_IGM__c, Old_Gross_IGM1__c, New_Sell_Price_Dollar_Change_Amount__c, Total_Spend_Impact_3_Month__c,Total_Spend_Impact_6_Month__c,Total_Spend_Impact_9_Month__c, '
              +' Total_Spend_Impact_12_Month__c, New_Sell_Price_Percentage_Change_Amoun__c,Margin_wo_Change_WATD__c,Margin_wo_Change_WAPO__c, WAPO_Cost_Change__c, WATD_Cost_Change__c, '
              +' WATD_Cost_Change1__c, New_Gross_IGM__c, New_Gross_IGM1__c, Gross_IGM_Basis_Point_Increase__c, '
              +' New_IGM_Change__c, Cap_Lost_Margin_Dollar__c,Cap_Lost_Margin_Dollar_3_Month__c, Cap_Lost_Margin_Dollar_6_Month__c, Cap_Lost_Margin_Dollar_9_Month__c, '
              +' Cap_Lost_Margin_Dollar_12_Month__c, Proposed_SRM_with_Cap__c, Proposed_WAPO_Margin_with_Cap__c, '
              +' Proposed_SRM_with_Cap1__c, Proposed_WAPO_Margin_with_Cap1__c, Proposed_New_List_Less_Disc_Without_Cap__c, '
              +' Margin_Exposure_before_change__c, Margin_Exposure_3_Month__c, Margin_Exposure_6_Month__c, Margin_Exposure_9_Month__c, '
              +' Margin_Exposure_12_Month__c, Current_Margin__c, Current_Margin_3_Month__c, Current_Margin_6_Month__c, Current_Margin_9_Month__c, '
              +' Current_Margin_12_Month__c, Projected_Margin__c, Projected_Margin_3_Month__c, Projected_Margin_6_Month__c, '
              +' Projected_Margin_9_Month__c, Projected_Margin_12_Month__c, SRM_Basis_Point_Increase__c, SRM_Differential__c, '
              +' New_WATD_Cost__c, Old_WATD__c, New_WAPO_Cost__c, Old_WAPO__c, Current_Sell_Price__c, New_List_Price__c, Proposed_Price_with_Cap__c, '
              +' Proposed_Price_Without_Cap__c,	Reporting_Erosion_Margin__c,Reporting_Erosion_Revenue__c,Reporting_Erosion_Margin_CAP__c,Reporting_Erosion_Revenue_CAP__c ' ;
          
          
              if(objectname == 'SKU'){
              query = qs +' FROM Ace_Customer_Core_Changes__c where batchId__c =\''+ batchId+'\'';
              }
              if(objectname == 'CORE'){
              query = qs +' FROM ACE_Customer_Price_Changes__c where batchId__c =\''+ batchId+'\'';
              }
              
              System.debug('Query:: '+query );
          }    
    }
    
    global database.Querylocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);      
    }
    
    global void execute(Database.BatchableContext bc, Sobject[] result) {
        
        
       
        // run rollups for this batch       
        ACE_Customer_skuRollups sg = new ACE_Customer_skuRollups ();
        
        //by using the below if condition we will us this same class for both sku's and core 
            if (result[0].getSObjectType() == Ace_Customer_Core_Changes__c.sObjectType) { 
                sg.RollupCores((list<Ace_Customer_Core_Changes__c>)result, batchId);
            } 
            if(result[0].getSObjectType() == ACE_Customer_Price_Changes__c.sObjectType){
               sg.RollupCustomerPricing((list<ACE_Customer_Price_Changes__c>)result,batchId);
            }
        
    }

    global void finish(Database.BatchableContext bc) {
        system.debug('COMPLETED -- ROLLUP');
        //Probally need to send out an email to kick off the Core Rollup's
    }
    
    
  
    
 }