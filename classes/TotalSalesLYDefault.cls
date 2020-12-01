global class TotalSalesLYDefault implements database.Batchable<Sobject>, Schedulable
{

 public String acc_query= 'SELECT ID,Paper_total_LY__c,Ink_Toner_total_LY__c,Furniture_total_LY__c,CBS_total_LY__c,CPD_total_LY__c,Tech_total_LY__c,Filing_Binding_total_LY__c,Labels_Forms_total_LY__c,Writing_Drafting_total_LY__c,Office_Essentials_total_LY__c,MPS_total_LY__c,Miscellaneous_total_LY__c from account';      

 global TotalSalesLYDefault ()
 {
 }
 
 global Database.QueryLocator start(Database.BatchableContext BC)
    {            
        System.debug('Header Query ===== = '+acc_query);
        return Database.getQueryLocator(acc_query);
    }
    
    
global void execute(Database.BatchableContext BC, SObject[] scope)
    {
    
    list<account> account_list = scope;
    list<account> act_upd = new list<account> ();
    for (account a:account_list)
    { 
        if(a.Paper_total_LY__c == null)
         a.Paper_total_LY__c  = 0;
        if(a.Ink_Toner_total_LY__c == null)
         a.Ink_Toner_total_LY__c = 0;
        if(a.Furniture_total_LY__c == null)
         a.Furniture_total_LY__c = 0;
        if(a.CBS_total_LY__c == null)
         a.CBS_total_LY__c = 0;
        if( a.CPD_total_LY__c == null)
         a.CPD_total_LY__c = 0;
        if(a.Tech_total_LY__c == null)
         a.Tech_total_LY__c = 0;
        if( a.Filing_Binding_total_LY__c == null)
         a.Filing_Binding_total_LY__c = 0;
        if(a.Labels_Forms_total_LY__c == null)
         a.Labels_Forms_total_LY__c = 0;
        if(a.Writing_Drafting_total_LY__c == null)
         a.Writing_Drafting_total_LY__c = 0;
        if(a.Office_Essentials_total_LY__c == null)
         a.Office_Essentials_total_LY__c = 0;
        if(a.MPS_total_LY__c == null)
         a.MPS_total_LY__c = 0;
        if(a.Miscellaneous_total_LY__c == null)
         a.Miscellaneous_total_LY__c = 0;
        
        act_upd.add(a);
    }
    update act_upd;
}

 global void finish(Database.BatchableContext BC)
    {
        
    }
    
    global void execute(SchedulableContext sc)
    {
      integer batch_size = 100;
        TotalSalesLYDefault accBatch = new TotalSalesLYDefault();
        database.executebatch(accBatch,2000);    
    }
  }