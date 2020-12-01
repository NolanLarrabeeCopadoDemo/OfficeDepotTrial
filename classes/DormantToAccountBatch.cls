global class DormantToAccountBatch implements database.Batchable<Sobject>, Schedulable
{
    private String DEFAULT_QUERY = 'SELECT id,accountExtension__c from account_dormant__c where accountExtension__r.last_order_date__c = last_n_days:5';
    public String strQuery;
    
    global DormantToAccountBatch (String query)
    {
        
         if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
    }
    
    
    global DormantToAccountBatch ()
    {
        this.strQuery = DEFAULT_QUERY;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {            
        System.debug(' Query ===== = '+strQuery );
        return Database.getQueryLocator(strQuery );
    }
    
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
        list<Account_Dormant__c> adUpd = scope;
        AccountRestore ar = new AccountRestore();
        String ret = ar.RestoreAccount(adUpd,'Sales Exist','');
    }
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
    
     global void execute(SchedulableContext sc)
     {
      integer batch_size = 1;
      String strQuery =''; 
        DormantToAccountBatch  dToABatch = new DormantToAccountBatch (strQuery );
            database.executebatch(dToABatch,batch_size);    
     }
    
}