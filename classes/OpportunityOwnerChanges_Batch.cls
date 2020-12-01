global class OpportunityOwnerChanges_Batch implements database.Batchable<Sobject>, Schedulable
{
 public String opp_query= 'SELECT id,account.id,account.ownerid,ownerid,account.owner.isactive,related_site__r.ownerid,related_site__r.owner.isactive from opportunity'
                          + ' where owner.Reassgin_Opportunity__c IN (\'NP\',\'P\') and owner.ActivatedbyBatch__c != true';
 
    global OpportunityOwnerChanges_Batch ()
    {
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {            
        System.debug('Opportunity Query ===== = '+opp_query);
        return Database.getQueryLocator(opp_query);
    }
    
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
      list<opportunity> opp_list = scope;
      list<opportunity> opp_upd = new list<opportunity> ();
      list<ID> user_id = new list<ID> ();
      list<user> update_users = new list<user> ();
      Map<id,boolean> users_partial_update = new Map<id,boolean> ();
       
      For (opportunity o: opp_list) {
       if (o.related_site__r.owner.isactive) {
          user_id.add(o.ownerid);
          o.ownerid = o.related_site__r.ownerid;
          opp_upd.add(o);
       }
       else if (o.account.owner.isactive) {
         user_id.add(o.ownerid);
         o.ownerid = o.account.ownerid;
         opp_upd.add(o);
       }
       else
        users_partial_update.put(o.ownerid,true);  
        
      }
 
      for (user u: [SELECT ID FROM USER WHERE ID = :user_id]) {
       if (!users_partial_update.containskey(u.id)) {
         u.Reassgin_Opportunity__c = 'C';
         update_users.add(u);
        }
       else {
         u.Reassgin_Opportunity__c = 'P';
         update_users.add(u);
       }
      }
      try{
     Database.update(opp_upd,false);
      Database.update(update_users,false);
      }
      catch(Exception e)
      {
      system.debug('@@@@'+e);
      }
    }
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
    
    global void execute(SchedulableContext sc)
    {
        integer batch_size = 100;
        OpportunityOwnerChanges_Batch oppBatch = new OpportunityOwnerChanges_Batch();
        Admin_Config__c ownerbatch = Admin_Config__c.getvalues('Default');
        if (ownerbatch.Ownership_Changes_Batch__c != null)
          batch_size = integer.valueof(ownerbatch.Ownership_Changes_Batch__c);
        database.executebatch(oppBatch, batch_size);      
         
    } 
    
}