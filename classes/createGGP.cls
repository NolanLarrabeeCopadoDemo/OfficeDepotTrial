global class createGGP implements database.Batchable<Sobject>,Schedulable,Database.AllowsCallouts
{
   
    public String strQuery;
    public String DEFAULT_QUERY;
    public ID RecordtypeID;

     //Default Constructor
    global createGGP()
    {

       DEFAULT_QUERY = 'SELECT Id, Name,CUSTOMER_GRANDPARENT_ID__c, CUSTOMER_GRANDPARENT_NM__c, CUST_GREAT_GP_ID__c, CUST_GREAT_GP_NM__c from gp_to_ggp__c';             
       this.strQuery = DEFAULT_QUERY;
       RecordType r = [SELECT id from recordtype where sobjecttype='Account' and name = 'Customer'];
       RecordtypeID = r.id;
    }
    
    
    /*This costructor is called from the Batch Schedule method*/
    global createGGP(String query)
    {
        //getCustSettings();
        RecordType r = [SELECT id from recordtype where sobjecttype='Account' and name = 'Customer'];
        RecordtypeID = r.id;
        
        System.debug('QUERY IS---->'+query);
        if(query != null && query != '')
            this.strQuery = query;
        else{
            //conditioncheck();
            this.strQuery = DEFAULT_QUERY;
        }
    }


    /*Start Method*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(strQuery);
    }
    
    global void execute(Database.BatchableContext BC, SObject[] scope){
        
        //Assigning the scope to a list
        List<gp_to_ggp__c> custTransList = scope;
        
        //Create - Update GrandParents
        Map<String,boolean> ggpMap = new Map<String,boolean>();
        list<Account> act_upd = new list<Account>();
        for (gp_to_ggp__c g: custTransList) {
          if (!ggpMap.containskey(g.CUST_GREAT_GP_ID__c) && g.CUST_GREAT_GP_NM__c != null) {
             Account a = new Account();
             a.name = g.CUST_GREAT_GP_NM__c;
             a.aops_cust_id__c = g.CUST_GREAT_GP_ID__c;
             a.recordtypeid = RecordtypeID;
             act_upd.add(a);
             ggpMap.put(g.CUST_GREAT_GP_ID__c,false);
          }
        }
        system.debug('Account Size:' + act_upd.size());
        database.upsert(act_upd,Account.aops_cust_id__c,false);
        
        //Create GP relationship
        act_upd.clear();
        Map<String,ID> ggpIDMap = new Map<String,ID>();
        for (account a: [select id,aops_cust_id__c from account where aops_cust_id__c in :ggpMap.keySet()])
          ggpIDMap.put(a.aops_cust_id__c,a.id);
          
        for (gp_to_ggp__c g: custTransList) {
          
           Account acc = new Account();
           acc.aops_cust_id__c = g.CUSTOMER_GRANDPARENT_ID__c;
           if (ggpIDMap.containskey(g.CUST_GREAT_GP_ID__c))
            acc.parentid = ggpIDMap.get(g.CUST_GREAT_GP_ID__c);
           else
            acc.parentid = null;
           act_upd.add(acc);
        }
        
        database.upsert(act_upd,Account.aops_cust_id__c,false);
        
       }
    
   
    global void finish(Database.BatchableContext BC){
        
      
    }
    //Method to implement Schedulable Interface
    global void execute(SchedulableContext sc){
        //String strQuery = '';
        createGGP assignBatch = new createGGP();
        database.executebatch(assignBatch, 10);
        
    }


 
}