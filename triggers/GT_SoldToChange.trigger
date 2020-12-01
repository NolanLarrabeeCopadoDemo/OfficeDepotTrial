// Trigger to nullify the contact link when sold to changes for site and dontmatches with contact associated to
trigger GT_SoldToChange on Account (before update) {
     //Account Service Production Fix
    Set<ID> resp = new Set<ID>();
    resp = Util.bizBoxRTIdsByObject('Account');
    
    //Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone)
    /*for(Account a: trigger.new)
    {
        if(util.checkRT('Account').contains(a.recordtypeId))
            return;
    }*/
        List<Id> accId= new List<Id>();
        Set<Id> accSet = new Set<Id>(); // case-00719296
        
     if (Trigger.New != null) {
      for (Account myAccount: Trigger.new) {
       //if (Util.bizBoxRTIdsByObject('Account').contains(myAccount.RecordTypeId)) {
           if (resp.contains(myAccount.RecordTypeId)) {
        return;
        }
       }
      }
    
      for( Account acc: Trigger.new){
      
      if(Trigger.oldMap.get(acc.ID).recordtypeId ==Label.Site_GT_Record_Type  && acc.recordtypeId==Label.Customer_GT_Record_Type){
       acc.Related_Account__c=null;
       acc.Site_Primary_Contact__c=null;
       acc.Site_Contact2__c=null;
       acc.Site_Contact3__c=null;
       acc.Site_Contact4__c=null;
       acc.Site_Contact5__c=null;
       acc.Site_Contact6__c=null;  
      }
        if(acc.recordtypeId==Label.Site_GT_Record_Type){
          if(Trigger.oldMap.get(acc.ID).Related_Account__c != Trigger.newMap.get(acc.ID).Related_Account__c ){
               accId.add(acc.Id);
          }
         }
        //Start-00719296 
        if(acc.recordtypeid==Label.GT_Prospect && acc.OwnerId != Trigger.oldMap.get(acc.Id).OwnerId)
        accset.add(acc.OwnerId);
        
        }
      
      List<Sales_Person__c> splist= new List<Sales_Person__c> ();
      Map<id,Sales_Person__c> spMap =new Map<id,Sales_Person__c>();

      if(accset.size()>0){
           splist = [select id,User__c,IsActive__c,Name,primary__c from Sales_Person__c where 
          User__c IN :accset and primary__c=true and IsActive__c=true];
          for(Sales_person__c sp : splist)
          {
              spmap.put(sp.user__c,sp);
              
          }
          system.debug('@@spMap' +spMap );
      }
      // End-00719296
      if(accId!= null && accId.size()>0){
      Map<ID, Account> accUpdate = new Map<ID, Account>([SELECT Id, Site_Primary_Contact__r.accountId,
      Site_Contact2__r.accountId,Site_Contact3__r.accountId,Site_Contact4__r.accountId,
      Site_Contact5__r.accountId,Site_Contact6__r.accountId
       FROM Account where id in:accId]);
    
        for( Account acc: Trigger.new){
        if(acc.recordtypeId==Label.Site_GT_Record_Type){
          if(Trigger.oldMap.get(acc.ID).Related_Account__c != Trigger.newMap.get(acc.ID).Related_Account__c ){
               if(acc.Related_Account__c!=accUpdate.get(acc.Id).Site_Primary_Contact__r.accountId)
                  acc.Site_Primary_Contact__c=null;
                             if(acc.Related_Account__c!=accUpdate.get(acc.Id).Site_Contact2__r.accountId)
                  acc.Site_Contact2__c=null;
                             if(acc.Related_Account__c!=accUpdate.get(acc.Id).Site_Contact3__r.accountId)
                  acc.Site_Contact3__c=null;
                             if(acc.Related_Account__c!=accUpdate.get(acc.Id).Site_Contact4__r.accountId)
                  acc.Site_Contact4__c=null;
                             if(acc.Related_Account__c!=accUpdate.get(acc.Id).Site_Contact5__r.accountId)
                  acc.Site_Contact5__c=null;
                             if(acc.Related_Account__c!=accUpdate.get(acc.Id).Site_Contact6__r.accountId)
                  acc.Site_Contact6__c=null;
               }
        }
            
            
            
        
        }
      }
      //Start-00719296 
      for(Account acc: trigger.new )
      {
         if(acc.recordtypeid==Label.GT_Prospect && acc.OwnerId != Trigger.oldMap.get(acc.Id).OwnerId)
        {
                    
                    if(spmap.get(acc.Ownerid)!=null)
                    {
                    acc.Sales_PersonID__c=spmap.get(acc.Ownerid).id;    
                    }
                    else
                    {
                        acc.Sales_PersonID__c=null;
                    }
        }  
        
}
// End-00719296 
    
}