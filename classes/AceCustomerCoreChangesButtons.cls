public class AceCustomerCoreChangesButtons {
 


  public String batch {get;set;}
  public ID customerPriceID {get;set;}
  public Ace_Customer_Core_Changes__c aceCustCoreChanges {get;set;}
  public boolean Redirect {get;set;}
  public String redirectURL {get;set;}
  
  public AceCustomerCoreChangesButtons(ApexPages.StandardController controller) {
     
     Redirect = false; 
     aceCustCoreChanges = (Ace_Customer_Core_Changes__c)controller.getRecord();
     Ace_Customer_Core_Changes__c ap = [SELECT ACE_Customer_Price_Changes__r.id,ACE_Customer_Price_Changes__r.batchid__c from Ace_Customer_Core_Changes__c  where id = :aceCustCoreChanges.id];
     
     batch = ap.ACE_Customer_Price_Changes__r.batchid__c;
     customerPriceID = ap.ACE_Customer_Price_Changes__r.id;
     
     
       
  }
  
 
  
  public void summaryGridRedirect() { 
    Redirect = true;
    redirectURL = '/apex/ACE_Summary_Grid_New?batch=' + batch;
  }
  
  public void customerPriceRedirect() { 
    Redirect = true;
    redirectURL = '/' + customerPriceID;
  }

  
  }