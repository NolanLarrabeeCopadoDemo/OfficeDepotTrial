public class AceCustomerSKUChangesButtons {
 

  public String redirectURL {get;set;}
  public boolean Redirect {get;set;}
  public Ace_Customer_SKU_Changes__c aceCustSKUChanges {get;set;}
  public Map<String,Boolean> renderMap {get;set;}
  public ID accountOwnerID {get;set;}
  public String batch {get;set;}
  public ID customerPriceID {get;set;}
  public ID corePriceID {get;set;}
  public String accountCustID{get;set;} 
  public Boolean STDCore{get;set;} 
  
   public boolean ownerCheck() {
    //Profile p = [SELECT Id,name from profile where name = 'System Administrator'];
    if (Userinfo.getUserId() == accountOwnerID)// || userInfo.getProfileId() == p.id)
      return true;
    else
      return false;
  }
  
  public AceCustomerSKUChangesButtons(ApexPages.StandardController controller) {
     STDCore=false;
     Redirect = false; 
     aceCustSKUChanges = (Ace_Customer_SKU_Changes__c)controller.getRecord();
     Ace_Customer_sku_Changes__c ap = [SELECT price_not_calculated__c,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Owning_Customer_ID__c,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.customer__r.name,ace_customer_core_changes__r.ace_customer_price_changes__r.customer__r.rolling_3_month_sales__c,ace_customer_core_changes__r.ace_customer_price_changes__r.customer__r.rolling_6_month_sales__c,ace_customer_core_changes__r.ace_customer_price_changes__r.customer__r.rolling_9_month_sales__c,ace_customer_core_changes__r.ace_customer_price_changes__r.customer__r.rolling_12_month_sales__c,ace_customer_core_changes__r.ace_customer_price_changes__r.sfdc_notification_flag__c,ace_customer_core_changes__r.ace_customer_price_changes__r.Record_Lock__c,ace_customer_core_changes__r.ace_customer_price_changes__r.isRemediation__c,ace_customer_core_changes__r.ace_customer_price_changes__r.remedy_status__c,Ace_Customer_Core_Changes__r.id,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.batchid__c,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.customer__r.ownerid,Approval_status__c from Ace_Customer_sku_Changes__c where id = :aceCustSKUChanges.id];
     accountOwnerID = ap.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.customer__r.ownerid;
     accountCustID = ap.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Owning_Customer_ID__c;
     batch = ap.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.batchid__c;
     customerPriceID = ap.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.id;
     corePriceID = ap.Ace_Customer_Core_Changes__r.id;
     
     if (!ownerCheck() || ap.price_not_calculated__c) {
        defaultRendering(false);
        if(accountCustID.contains('99999ACE'))
            STDCore=true;
     }
     else {
        defaultRendering(true);
        if (ap.Approval_status__c == 'Pending' || ap.ace_customer_core_changes__r.ace_customer_price_changes__r.remedy_status__c == 'Pending' || ap.ace_customer_core_changes__r.ace_customer_price_changes__r.isRemediation__c || ap.ace_customer_core_changes__r.ace_customer_price_changes__r.record_lock__c)
          renderMap.put('PRICEEXCEPTION',false);
        else if(ap.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.sfdc_notification_flag__c == '1') {
            
            if(ap.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_12_month_sales__c != null){
                            if(ap.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_12_month_sales__c < 75000.00)
                               renderMap.put('PRICEEXCEPTION',false);
            }  
            else if(ap.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_9_month_sales__c != null){
                            if(ap.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_9_month_sales__c*(4/3) < 75000.00)
                               renderMap.put('PRICEEXCEPTION',false);
            }  
            else if(ap.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_6_month_sales__c != null){
                            if(ap.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_6_month_sales__c*2 < 75000.00)
                               renderMap.put('PRICEEXCEPTION',false);
            } 
            else if(ap.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_3_month_sales__c != null){
                            if(ap.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Customer__r.Rolling_3_month_sales__c*4 < 75000.00)
                               renderMap.put('PRICEEXCEPTION',false);
            }  
            
        }
     }
     
     
       
  }
  
  public void defaultRendering(Boolean val) {
     renderMap = new Map<String,Boolean> ();
     renderMap.put('PRICEEXCEPTION',val);
  }
  
  public void summaryGridRedirect() { 
    Redirect = true;
    redirectURL = '/apex/ace_summary_grid_new?batch=' + batch;
  }
  
  public void customerPriceRedirect() { 
    Redirect = true;
    redirectURL = '/' + customerPriceID;
  }
  
  public void corePriceRedirect() { 
    Redirect = true;
    redirectURL = '/' + corePriceID;
  }
  
  
  
  
  public void PriceeExceptionButton() {
    Redirect = true;
    redirectURL = '/apex/SKU_Execption?ID=' + aceCustSKUChanges.id + '&skuID='+aceCustSKUChanges.id;
  }
  

  
  }