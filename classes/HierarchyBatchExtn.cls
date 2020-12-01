// 10/17/2016       Jessica Schilling       S-445702        Added logic to map Great Grandparents
//
Global class HierarchyBatchExtn implements database.Batchable<Sobject>,Schedulable {
    private string DEFAULT_QUERY = 'select id,hierarchy__c from account_extension__c where recordtype.developername=\'Customer\'';
    public String strQuery;
    
    global HierarchyBatchExtn (String query) {
        if (query != null && query !='')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
    }
    
    global HierarchyBatchExtn () {
       this.strQuery = DEFAULT_QUERY;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('QUERY IS ====='+strQuery);
        return Database.getQueryLocator(strQuery);
    }
    
     global void execute(Database.BatchableContext BC, SObject[] scope)
     {
         list<Account_Extension__c> ac = scope;
         Map<ID,String> acctoHier = new Map<ID,String>();
         for (Account_Extension__c a:ac) {
             acctoHier.put(a.id,'S');
         }
         //START JSCHILLING S-445702 10/17/2016
         //OD Story number 00781061 Added check for Great Grandparents and added additional check for Grandparents
         for (Account_Extension__c a:[select Account_ParentId__c, Grandparent__c from account_extension__c where Account_ParentId__c=:acctoHier.keySet() and recordtype.developername in ('Customer','Customer_OfficeMax','GrandParent')]) {
             if (a.Grandparent__c == 'Yes')
                 acctoHier.put(a.Account_ParentId__c,'GG');
         }
         //Check for GP
         for (account_Extension__c a:[select id from account_extension__c where id=:acctoHier.keySet() and Grandparent__c = 'Yes']){
            if(acctoHier.get(a.id) == 'S')
                acctoHier.put(a.id,'GP');
         }
         //END JSCHILLING S-445702 10/17/2016
         //Check for Parent
         AggregateResult[] parentResults= [select Account_ParentId__c from account_extension__c where Account_ParentId__c=:acctoHier.keySet() and recordtype.developername in ('Customer','Customer_OfficeMax') group by Account_ParentId__c];
         for (AggregateResult a:parentResults) {
             if (acctoHier.get((id)a.get('Account_ParentId__c')) == 'S')
                 acctoHier.put((ID)a.get('Account_ParentId__c'),'P');
         }
         //Check for Child
         for (account_Extension__c a:[select id from account_extension__c where id=:acctoHier.keySet() and Account_ParentId__c != null]) {
             if (acctoHier.get(a.id) == 'S')
                  acctoHier.put(a.id,'C');
         }
         list<Account_Extension__c> acctUpds = new list<Account_Extension__c>();
         for (ID i:acctoHier.keySet()) {
             Account_Extension__c a = new Account_Extension__c(ID=i);
             a.Hierarchy__c = acctoHier.get(i);
             acctUpds.add(a);
         }
         update acctUpds;
     }
    
     global void finish(Database.BatchableContext BC)
    {
        // not required
    }
    
     global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        HierarchyBatch b = new HierarchyBatch(strQuery);
        database.executebatch(b, 1000);
        
       strQuery = 'select id,hierarchy__c from account_extension__c where recordtype.developername=\'Customer_OfficeMax\'';
       HierarchyBatch bOmx = new HierarchyBatch(strQuery);
       database.executebatch(bOmx, 1000);
    }
    
}