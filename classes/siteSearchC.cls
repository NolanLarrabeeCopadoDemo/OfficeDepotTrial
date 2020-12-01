public class siteSearchC {
   public Account newact {get;set;}
   public static list<Account> acctSites;
   
   
   @AuraEnabled
    public static siteSearchC doinit() {
        Account a = new Account();
        siteSearchC s = new siteSearchC();
        s.newact = a;        
        return s;
    }
  
    @AuraEnabled
    public static list<Account> searchSites(String acctID) {
       //String acctID = '39693115';
       return acctSites = [select Name,aops_seq_id__c,GPO_Site_Status__c,Status__c,address1__c,address2__c,city__c,state__c,zip__c,Address_Key__c from account where related_account__r.aops_cust_id__c=:acctID];
    }
    
     @AuraEnabled
    public static list<Account> searchsdata(String name, String seq, String status, String addKey, String acctID) {
       //String acctID = '39693115';
       list<Account> accts = new list<Account>();
       string query = 'select Name,aops_seq_id__c,GPO_Site_Status__c,Status__c,address1__c,address2__c,city__c,state__c,zip__c,Address_Key__c from account where related_account__r.aops_cust_id__c=\''+acctID+'\'';
       if (seq != null) {
          
           query=query+' and aops_seq_id__c like \''+seq+'%\'';
       }
       else if (status != null && status != '') {
          
           query=query+' and GPO_Site_Status__c = \''+status+'\'';
       }
       else if (name != null) {
           
            query=query+' and name like \''+name+'%\'';
       }
       else if (addkey != null) {
         
            query=query+' and Address_Key__c like \''+addkey+'%\'';
       
       }
       
       query=query+' limit 50';
            
      list<sObject> qdata = database.Query(query);
      
      for (sObject s: qdata) {
          Account a = (Account)s;
          accts.add(a);
      }
          
       system.debug('Query:' + query);
       return accts;    
    }
    
    @AuraEnabled
    public static Account ActivateSite(Account acct) {
      system.debug('inside activateSite');
      acct.GPO_Site_Status__c='Active';
      update acct;
        return acct;
   }
   
    @AuraEnabled
        public static list<Account> UpdateMSites(list<Account> accts,String action) {
      system.debug('inside activateSite(s)');
      for (account a:accts) 
        a.GPO_Site_Status__c=action;
      update accts;
      return accts;
   }
   
 
   
   @AuraEnabled
    public static Account DeactivateSite(Account acct) {
      system.debug('inside DeactivateSite');
      acct.GPO_Site_Status__c='Inactive';
      update acct;
        return acct;
   }
}