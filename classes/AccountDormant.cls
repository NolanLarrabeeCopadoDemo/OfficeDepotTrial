public class AccountDormant {
       public class processResponse {
           ID AccountID;
           String Status;
           String ErrorMsg;
       }
       
       public list<Account_Dormant__c> accDormant;
       
       public list<account_dormant__c> moveAcct(list<ID> AcctIDs) {
           accDormant = new list<Account_Dormant__c>();
           map<id,id> acctToDormant = new map<id,id>();
           list<processResponse> accRes = new list<processResponse>();
           list<Account> accts = new list<Account>();
           list<Account> acctstoDelete = new list<account>();
           for (account a:[select id,Account_Extension__c,AOPS_Cust_Id__c,AOPS_Seq_ID__c,Address1__c,Address2__c,City__c,Country__c,OMX_Primary_Key__c,State__c,Zip__c
                          from account where id=:acctIDs]) {
                              
                 accts.add(a);               
                             
           }
           
           for (Account a:accts) {
               accDormant.add(setupDormant(a));
           }
           
           if (accDormant.size() > 0)
             database.insert(accDormant,false);
             
           for (account_dormant__c d:accDormant) {
               if (d.id != null) {
                 acctToDormant.put(d.Original_Account_ID__c,d.id);
               }
           }
           
           createNotes(acctToDormant);
           createAttachment(acctToDormant);
           
           for (account a:[select id from account where id=:acctToDormant.keySet()]) {
               acctstoDelete.add(a);
           }
           
           database.delete(acctstoDelete,false);
           
           return accDormant;
       }
       
       public account_dormant__c setupDormant(Account a) {
           account_dormant__c ad = new account_dormant__c();
           ad.AccountExtension__c = a.account_Extension__c;
           ad.Address1__c = a.address1__c;
           ad.Address2__c = a.address2__c;
           ad.AOPS_Cust_Id__c = a.aops_cust_id__c;
           ad.aops_Seq_id__c=a.aops_seq_id__c;
           ad.City__c=a.city__c;
           ad.Country__c=a.Country__c;
           ad.OMX_Primary_Key__c=a.OMX_Primary_Key__c;
           ad.Original_Account_ID__c=a.id;
           ad.State_Province__c=a.state__c;
           ad.Zip_Postal_Code__c=a.zip__c;
           return ad;
           
       }
      
public void createNotes(Map<ID,ID> acctToDormant) {
        list<Note> noteUpd = new list<Note>();
        for (Note n: [select id,ParentId,Body,Title from Note where ParentId=:acctToDormant.keySet()]) {
            if (acctToDormant.containsKey(n.ParentId)) {
               note nc = new note();
               nc.Parentid = acctToDormant.get(n.ParentId);
               nc.Title = n.Title;
               nc.Body = n.Body;
               noteUpd.add(nc);
            }  
         }
        
         if (noteUpd.size() > 0)
             database.Upsert(noteUpd,false);
 }
    
public void createAttachment(Map<ID,ID> acctToDormant) {
        list<Attachment> attachmentUpd = new list<Attachment>();

        for (Attachment a: [select id,ParentId,Body,ContentType,IsPartnerShared,Name from attachment where ParentId=:acctToDormant.keySet()]) {
            if (acctToDormant.containsKey(a.ParentId)) {
               attachment ac = new attachment();
               ac.Parentid = acctToDormant.get(a.ParentId);
               ac.Name = a.Name;
               ac.ContentType = a.ContentType;
               //ac.isPartnerShared = a.isPartnerShared;
               ac.Body = a.Body;
               attachmentUpd.add(ac);
            }  
         }
        
         if (attachmentUpd.size() > 0)
             database.Upsert(attachmentUpd,false);
 }  
       

}