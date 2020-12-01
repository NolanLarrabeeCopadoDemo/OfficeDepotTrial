global class AccountDormantBatch implements database.Batchable<sobject>,Schedulable {
      private string DEFAULT_QUERY='select Sfdc_Id__c from Account_Dedup_Staging__c  where Dormant_Change__c=\'I\'';
       public String strQuery;

global AccountDormantBatch (String query) {
        if (query != null && query !='')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
}

 global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('QUERY IS ====='+strQuery);
        return Database.getQueryLocator(strQuery);
    }
    
    
    global void execute(Database.BatchableContext BC, SObject[] scope)
     {
          list<Account_Dedup_Staging__c> ac = scope;
          list<ID> ACCTIDs = new list<ID>();
          list<ID> ACCIDs_Dormant = new list<ID>();
          for (Account_Dedup_Staging__c a: ac) {
              ACCTIDs.add(a.sfdc_id__c); 
          }
          
          for (account a:[select id from account where id=:ACCTIDS]) 
            ACCIDs_Dormant.add(a.id);
          
          AccountDormant b = new AccountDormant();
          b.moveAcct(ACCIDs_Dormant);
          
     }
     
   global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        HierarchyBatch b = new HierarchyBatch(strQuery);
        database.executebatch(b, 100);
        
    }
    
      global void finish(Database.BatchableContext BC)
    {
        // not required
    }
}