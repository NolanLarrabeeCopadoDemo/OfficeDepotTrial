public with sharing class AceUnlockedAccounts_Homepg {

public ID custSKUChangesID {get;set;}
public String pageval {get;set;}
public Boolean skuRender {get;set;}
public Integer List_size = 50;
public Integer total_size{get;set;}
public Integer counter = 0;
public Map<ID,Integer> offset {get;set;}
public Integer reminderDays,escalationDays;
public List<ACE_Customer_Price_Changes__c> lUnlockAccounts{get;set;}

  

    public AceUnlockedAccounts_Homepg() {  
    	offset = new Map<ID,Integer> ();   
    	reminderDays=0;escalationDays=0;
    	ACE_Settings__c aceSetting =[SELECT Id,processing_window__c,EsclationDays__c,Expiry_Days__c, Name, BatchName__c,Vendavo_Update_Start_Date__c,Vendavo_Update_End_Date__c from ACE_Settings__c limit 1];      
        if (aceSetting.Expiry_Days__c != null)
          reminderDays = (Integer)aceSetting.Expiry_Days__c;
        if (aceSetting.EsclationDays__c != null)
          escalationDays = (Integer)aceSetting.EsclationDays__c;
        generateList();
    }
    
    public void generateList()
    {
        lUnlockAccounts = new list<ACE_Customer_Price_Changes__c>();        
        lUnlockAccounts= [select id,customer__r.owner.name,customer__r.name,customer__r.cust_ID__c,
                                  Sales_Price_Change_Effective_Date_Min__c,
                                  Reschduled_For_Reminder__c,
                                  Owning_Customer_Legal__c
                                            from ACE_Customer_Price_Changes__c 
                                            where Record_Unlock__c = true and customer__r.ownerID =: UserInfo.getUserID()
                                            limit :List_size OFFSET :counter]; 
        total_size = [select count() from ACE_Customer_Price_Changes__c where Record_Unlock__c = true and customer__r.ownerID =: UserInfo.getUserID()];                                        
        
        for (ace_customer_price_changes__c a: lUnlockAccounts) {

        	if (!a.Reschduled_For_Reminder__c) {
        	  if (a.Owning_Customer_Legal__c == 'T')
        	    offset.put(a.id,reminderDays+escalationDays);
        	  else
        	    offset.put(a.id,reminderDays);
        	}
        	else
        	  offset.put(a.id,0);
        	  
        }                          
                           
        
    }
    public void nextPage(){
        counter = counter+List_size; 
          
        generateList();
        
    }
    public void prevPage(){
        counter = counter-List_size;
        generateList();
       
    }
    
    public Boolean getDisablePrevious() {
     
      if (counter>0) return true; else return false;
    }
    
    public Boolean getDisableNext() { 
      if (counter + list_size < total_size) return true; else return false;
    }

}