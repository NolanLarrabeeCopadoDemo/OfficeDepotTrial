// 10/17/2016       Jessica Schilling       S-445702        Added logic to map Great Grandparents
//
Global class HierarchyBatch implements database.Batchable<Sobject>,Schedulable {
    private string DEFAULT_QUERY = 'select id,hierarchy__c from account where recordtype.name=\'Customer\'';
    public String strQuery;
    
    global HierarchyBatch (String query) {
        if (query != null && query !='')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
    }
    
    global HierarchyBatch () {
       this.strQuery = DEFAULT_QUERY;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('QUERY IS ====='+strQuery);
        return Database.getQueryLocator(strQuery);
    }
    
     global void execute(Database.BatchableContext BC, SObject[] scope)
     {
         list<Account> ac = scope;
         Map<ID,String> acctoHier = new Map<ID,String>();
         for (Account a:ac) {
             acctoHier.put(a.id,'S');
         }
         //START JSCHILLING S-445702 10/17/2016
         //OD Story number 00781061 Added check for Great Grandparents and added additional check for Grandparents
         for (Account a:[select parentid, Grandparent__c from account where parentid=:acctoHier.keySet() and recordtype.name in ('Customer','Customer (OfficeMax)','GrandParent')]) {
             if (a.Grandparent__c == 'Yes')
                 acctoHier.put(a.parentid,'GG');
         }
         //Check for GP
         for (account a:[select id from account where id=:acctoHier.keySet() and Grandparent__c = 'Yes']){
            if(acctoHier.get(a.id) == 'S')
                acctoHier.put(a.id,'GP');
         }
         //END JSCHILLING S-445702 10/17/2016
         //Check for Parent
         AggregateResult[] parentResults= [select parentid from account where parentid=:acctoHier.keySet() and recordtype.name in ('Customer','Customer (OfficeMax)') group by parentid];
         for (AggregateResult a:parentResults) {
             if (acctoHier.get((id)a.get('parentid')) == 'S')
                 acctoHier.put((ID)a.get('parentid'),'P');
         }
         //Check for Child
         for (account a:[select id from account where id=:acctoHier.keySet() and parentid != null]) {
             if (acctoHier.get(a.id) == 'S')
                  acctoHier.put(a.id,'C');
         }
         list<Account> acctUpds = new list<Account>();
         for (ID i:acctoHier.keySet()) {
             Account a = new Account(ID=i);
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
        
       strQuery = 'select id,hierarchy__c from account where recordtype.name=\'Customer (OfficeMax)\'';
       HierarchyBatch bOmx = new HierarchyBatch(strQuery);
       database.executebatch(bOmx, 1000);
    }
    
}