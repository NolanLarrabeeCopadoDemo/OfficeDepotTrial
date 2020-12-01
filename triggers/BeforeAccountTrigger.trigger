trigger BeforeAccountTrigger on Account (before update) {
    //Account Service Production Fix
    Set<ID> resp = new Set<ID>();
    resp = Util.bizBoxRTIdsByObject('Account');
    
    
    //Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone)
   /* for(Account a: trigger.new)
    {
        if(util.checkRT('Account').contains(a.recordtypeId))
            return;
    }*/
    if (Trigger.New != null) {
 for (Account myAccount: Trigger.new) {
     //if (Util.bizBoxRTIdsByObject('Account').contains(myAccount.RecordTypeId)) {
     if (resp.contains(myAccount.RecordTypeId)) {
   return;
  }
 }

}

     if(executeoncetest.mod5ByPass==true){

    // Never skip trigger if user is Dataloader
    String currentUserId = UserInfo.getUserId().substring(0,15);
    boolean currentUserIsDL = false;
    
    List<Dataloader_User__c> dataloaderUsers = Dataloader_User__c.getall().values();
    for (Dataloader_User__c dlu : dataloaderUsers) {
        if (currentUserId == dlu.User_ID__c) {
            currentUserIsDL = true;
        }
    }

    if (executeoncetest.notTriggered_BeforeAccountTrigger_before || currentUserIsDL) {
       executeoncetest.notTriggered_BeforeAccountTrigger_before = false;
       
        Id CustOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId();
        Id SiteOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (OfficeMax)').getRecordTypeId();
        Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        Id Site = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
          
        for (Account acc : Trigger.new) {
        
        if(     (acc.RecordTypeId == Site  ||  acc.RecordTypeId == SiteOMX )  &&
        (trigger.oldMap.get(acc.id).Related_Account__c!=  acc.Related_Account__c)  &&  
        
        trigger.oldMap.get(acc.id).Related_account_Split_Record__C ==true)  {
        acc.Related_Account__c=trigger.oldMap.get(acc.id).Related_Account__c;
        
        }      
        
        
            // Case 422896 - Customer Records flipping back to OMX account
            if ( trigger.oldMap.get(acc.id).RecordTypeId !=acc.RecordTypeId  &&     trigger.oldMap.get(acc.id).RecordTypeId== Customer && acc.RecordTypeId == CustOMX) {
                 acc.RecordTypeId = Customer;
              }  
            if ( trigger.oldMap.get(acc.id).RecordTypeId !=acc.RecordTypeId  &&     trigger.oldMap.get(acc.id).RecordTypeId== Site && acc.RecordTypeId == SiteOMX) {
                 acc.RecordTypeId = Site;
              }   
               
               
          //451904 - Parent Updates after Transition Launched          
           //If the Parent changes after Launching, its prevented for OfficeMax
           String loggeduser=UserInfo.getUserId();
           loggeduser=loggeduser.substring(0,15);
           if(acc.RecordTypeId== Customer  &&   (  trigger.oldMap.get(acc.id).parentId !=acc.ParentId) && ACC.OMX_primary_key__C!=null  && loggeduser==Label.SalesforceDataloaderNorth )
           acc.parentId=trigger.oldMap.get(acc.id).parentId;
           
        }
    }
    
 }   
}