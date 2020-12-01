trigger GT_DeleteContacts on Account (after update) {
     //Account Service Production Fix
    Set<ID> resp = new Set<ID>();
    resp = Util.bizBoxRTIdsByObject('Account');
    
    //Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone)
    /*for(Account a: trigger.new)
    {
        if(util.checkRT('Account').contains(a.recordtypeId))
            return;
    }*/
    // Never skip trigger if user is  Dataloader
    if (Trigger.New != null) {
 for (Account myAccount: Trigger.new) {
 // if (Util.bizBoxRTIdsByObject('Account').contains(myAccount.RecordTypeId)) {
      if (resp.contains(myAccount.RecordTypeId)) {
   return;
  }
 }

}
    String currentUserId = UserInfo.getUserId().substring(0,15);
    boolean currentUserIsDL = false;
    
    List<Dataloader_User__c> dataloaderUsers = Dataloader_User__c.getall().values();
    for (Dataloader_User__c dlu : dataloaderUsers) {
        if (currentUserId == dlu.User_ID__c) {
            currentUserIsDL = true;
        }
    }
    
    // Execute trigger once
    if (executeoncetest.notTriggered_GT_DeleteContacts_after || currentUserIsDL) {
        //executeoncetest.notTriggered_GT_DeleteContacts_after = false;
        
        List<Id> accountId= new List<Id>();
        List<contact> contactId= new List<contact> ();
        List<contact> updatecontactId= new List<contact> ();
        
      for(Account accounts: Trigger.new){

      
         if(  (Trigger.oldMap.get(accounts.Id).recordtypeId!= Trigger.newMap.get(accounts.Id).recordtypeId)  &&
            // old recordtype is account set up requested
             Trigger.oldMap.get(accounts.Id).recordtypeId==Label.Account_Setup_Record_Type  &&  
              // new recordtype is Customer GT
             Trigger.newMap.get(accounts.Id).recordtypeId ==Label.Customer_GT_Record_Type
         ){
          accountId.add( accounts.Id);
         }
      }
      // get the primary contacts associated for deletion
      if(accountId!=null && accountId.size()>0){
          contactId=[Select Id from contact where AccountId in :accountId and Primary_Contact__c=true];
      }
      if(contactId.size()>0)
      delete contactId;
      // get the other contacts associated for dummy update
      if(accountId!=null && accountId.size()>0){
      updatecontactId=[Select Id from contact where AccountId in :accountId and Primary_Contact__c=false];
      }
      if(updatecontactId.size()>0)
      update updatecontactId;
    }
}