global class AccountHeaderAccess_Batch implements database.Batchable<Sobject>, Schedulable
{

                          
     public String acc_query= 'SELECT id,related_account__r.ownerid,owner.isactive,related_account__r.id,ownerid,previous_owner_id__c from account'
                          + ' where Header_Record_Access__c <> true '
                          + ' and recordtypeid = \'012E00000008dTcIAI\' ';        
                          
  /*     public String acc_query= 'SELECT id,related_account__r.ownerid,owner.isactive,related_account__r.id,ownerid,previous_owner_id__c from account'
                          + ' where Header_Record_Access__c = false '
                          + ' and id = \'001E000000EGijh\' ';    */                          
                          
    global AccountHeaderAccess_Batch ()
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
     list<ID> acct_ids = new list<ID>();
     list <account> sites_upd = new list<account>();
     list<accountshare> share_add_list = new list<accountshare> ();
     list<accountshare> share_add_delete = new list<accountshare> ();
     Map<String,accountshare> acct_map = new Map<String,accountshare> ();
     Map<String,String> added_to_share = new Map<String,String> ();
     Map<String,String> removed_from_share = new Map<String,String> ();
     String map_key;
    
    for (account a:account_list)
        acct_ids.add(a.related_account__r.id);
     
     for (accountshare s:[SELECT id,AccountId,UserOrGroupId,OpportunityAccessLevel from accountshare where accountid = :acct_ids]) {
         map_key = string.valueof(s.AccountId) + string.valueof(s.UserOrGroupId);
         acct_map.put(map_key,s);
     }
     
     For (account a: account_list) {
       if (a.related_account__r.id != null && a.ownerid != null && a.owner.isactive) {
         String construct_key = String.valueof(a.related_account__r.id) + String.valueof(a.ownerid);
         if (!acct_map.containskey(construct_key) && !added_to_share.containskey(construct_key) && a.ownerid != a.related_account__r.ownerid) {
           AccountShare accshare = new AccountShare();
           accShare.AccountId = a.related_account__r.id;
           accShare.UserOrGroupId = a.ownerid;
           accShare.AccountAccessLevel = 'Edit';
           accShare.OpportunityAccessLevel = 'None';
           share_add_list.add(accshare);
           added_to_share.put(construct_key,'added');
         }
       } 
       if (a.related_account__r.id != null && a.previous_owner_id__c != null && a.ownerid != a.related_account__r.ownerid) {
          
          String construct_key = String.valueof(a.related_account__r.id) + String.valueof(a.previous_owner_id__c);
        
          if (acct_map.containskey(construct_key) && !removed_from_share.containskey(construct_key)) {
            list<account> owner_exists_on_site = [SELECT ID FROM ACCOUNT where related_account__r.id = :a.related_account__r.id and ownerid = :a.previous_owner_id__c limit 1];
            if ('None'.equals(acct_map.get(construct_key).OpportunityAccessLevel)) {
              if (owner_exists_on_site.size() <= 0) {
                 share_add_delete.add(acct_map.get(construct_key));
                 removed_from_share.put(construct_key,'removed');
                }
               }
          }
             
       }
       
       a.Header_Record_Access__c = true;
       sites_upd.add(a);
      
       
     }
     if (share_add_delete.size() > 0)
       delete share_add_delete;
     if (share_add_list.size() > 0)
       insert share_add_list;
   
      update sites_upd;

    }
    
    global void finish(Database.BatchableContext BC)
    {
        
    }
    
    global void execute(SchedulableContext sc)
    {
    	integer batch_size = 100;
        AccountHeaderAccess_Batch accBatch = new AccountHeaderAccess_Batch();
        Admin_Config__c ownerbatch = Admin_Config__c.getvalues('Default');
        if (ownerbatch.Ownership_Changes_Batch__c != null)
          batch_size = integer.valueof(ownerbatch.Ownership_Changes_Batch__c);
        database.executebatch(accBatch,batch_size);    
    }
  }