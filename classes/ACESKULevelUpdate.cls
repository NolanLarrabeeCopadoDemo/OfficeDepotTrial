global class ACESKULevelUpdate implements Database.Batchable<SObject>,Database.Stateful,Schedulable {
public String query { get; set; } 
global set<ID> CustIDs {get;set;}
  global ACESKULevelUpdate (){
	 query = 'SELECT id,ace_customer_core_changes__r.ace_customer_price_changes__r.Sales_Price_Change_Effective_Date_Min__c,ace_customer_core_changes__r.ace_customer_price_changes__r.Sales_Price_Change_Effective_Date_approv__c,'
	       +'ace_customer_core_changes__r.ace_customer_price_changes__r.Customer_Notification_Date_Approved__c,'
	       +'ace_customer_core_changes__r.ace_customer_price_changes__c,'
	       +'ace_customer_core_changes__r.ace_customer_price_changes__r.Sales_Price_Change_Effective_Date__c,'
	       +'ace_customer_core_changes__r.ace_customer_price_changes__r.effective_date_difference__c,'
	       +'ace_customer_core_changes__r.ace_customer_price_changes__r.sfdc_notification_flag__c,'
	       +'ace_customer_core_changes__r.ace_customer_price_changes__r.Update_Vendavo_Date__c,ace_customer_core_changes__r.ace_customer_price_changes__r.Effective_Date_Modified__c,'
           +'Vendavo_Update_Date__c,Sales_Price_Change_Effective_Date_Approv__c from ace_customer_sku_changes__c'
           +' where ace_customer_core_changes__r.ace_customer_price_changes__r.Effective_Date_Modified__c = true OR ace_customer_core_changes__r.ace_customer_price_changes__r.Update_Vendavo_Date__c = true';
           //+' where price_change_id__c=\'a1vM0000001nREnIAM\' limit 10';
    System.debug('Query:: '+query );
    CustIDs = new set<ID>();
  }
  
  global database.Querylocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);      
    }
  
  global void execute(Database.BatchableContext bc, Sobject[] scope) {
  	List<ACE_customer_sku_changes__c> skuList = scope;
    

    for (ace_customer_sku_changes__c s: skulist)  	 {
    	if (s.ace_customer_core_changes__r.ace_customer_price_changes__r.Effective_Date_Modified__c == true) {
    		if (s.ace_customer_core_changes__r.ace_customer_price_changes__r.sfdc_notification_flag__c != '1' && s.ace_customer_core_changes__r.ace_customer_price_changes__r.Customer_Notification_Date_Approved__c != null && s.ace_customer_core_changes__r.ace_customer_price_changes__r.effective_date_difference__c != null) {
    			  integer datediff = integer.valueof(s.ace_customer_core_changes__r.ace_customer_price_changes__r.effective_date_difference__c);
    			  
    			  if (s.Sales_Price_Change_Effective_Date_Approv__c != null)
    			   s.Sales_Price_Change_Effective_Date_Approv__c = s.Sales_Price_Change_Effective_Date_Approv__c.adddays(datediff);
    		}
    		else {
    			  s.Sales_Price_Change_Effective_Date_Approv__c = s.ace_customer_core_changes__r.ace_customer_price_changes__r.Sales_Price_Change_Effective_Date_approv__c;
    		}	
    	}
    	s.Vendavo_Update_Date__c = system.now();
    	
    }
  	  update skulist;
  	  for (ace_customer_sku_changes__c s: skulist)
  	    CustIDs.add(s.ace_customer_core_changes__r.ace_customer_price_changes__c);
  	  /*list<ace_customer_price_changes__c> pUpd = new list<ace_customer_price_changes__c>();
  	  for (ace_customer_price_changes__c p:[select id,effective_date_difference__c,effective_date_modified__c,Update_Vendavo_Date__c from ace_customer_price_changes__c where id in :CustIDs and (effective_date_modified__c != false or Update_Vendavo_Date__c != false or effective_date_difference__c != null)]) {
       	    p.effective_date_difference__c = null;
       	    p.Update_Vendavo_Date__c = false;
       	    p.effective_Date_modified__c = false;
       	    pUpd.add(p);
       }
       update pUpd;*/
  }
  
  global void finish(Database.BatchableContext BC)
    {
       System.debug('Completed Processing') ;
       list<ace_customer_price_changes__c> pUpd = new list<ace_customer_price_changes__c>();
       system.debug('Customer Update Count:' + custIDs.size());
       for (ace_customer_price_changes__c p:[select id,effective_date_difference__c,effective_date_modified__c,Update_Vendavo_Date__c from ace_customer_price_changes__c where id in :CustIDs]) {
       	    p.effective_date_difference__c = null;
       	    p.Update_Vendavo_Date__c = false;
       	    p.effective_Date_modified__c = false;
       	    pUpd.add(p);
       }
       update pUpd;
    }
    
  global void execute(SchedulableContext sc)
    {
     //Batch size set for each iteration
     integer batch_size = 200; 
     ACESKULevelUpdate aceBatch = new ACESKULevelUpdate();
     database.executebatch(aceBatch,batch_size);
    }
  
}