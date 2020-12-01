trigger GT_DeleteRelatedContactOnAccountChange on Contact (after update) {
        //Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone)
    for(Contact c: trigger.new)
    {
        if(util.checkRT('Contact').contains(c.recordtypeId))
            return;
    }
       // added for ticket 01474559
       if (Trigger.New != null) {
         for (Contact myCont: Trigger.new) {
          if (Util.bizBoxRTIdsByObject('Contact').contains(myCont.RecordTypeId)) {
           return;
          }
         }
        }

      if (Trigger.isAfter) {

          List<Id> accountIdList = new List<Id>();
          List<Account> relatedSiteList = new List<Account>();
          List<Account> updatedRelatedSiteList = new List<Account>();
          List<Id> contactsToLoopList = new List<Id>();

          for(Contact newContctObj : Trigger.new){            
              if(  Trigger.oldMap.get(newContctObj .Id).AccountId != Trigger.newMap.get(newContctObj .Id).AccountId   &&  
                  newContctObj .recordTypeId == Label.Contact_record_type_18){                   
                      accountIdList.add(Trigger.oldMap.get(newContctObj .Id).AccountId);
                      contactsToLoopList.add(newContctObj .id);
                  }              
          }
          
          
          system.debug('@@Account id '+accountIdList);
         if(!accountIdList.IsEmpty() && accountIdList!= null && !contactsToLoopList.isEmpty() && contactsToLoopList!=null ){
             relatedSiteList = [Select id,Site_Contact2__c,Site_Contact3__c,Site_Contact4__c,Site_Contact5__c,Site_Contact6__c,Site_Primary_Contact__c from Account where Related_Account__c IN :accountIdList and recordType.name = 'Site (GT)' and (Site_Primary_Contact__c IN: contactsToLoopList or Site_Contact2__c IN: contactsToLoopList or Site_Contact3__c IN: contactsToLoopList or Site_Contact4__c IN: contactsToLoopList or Site_Contact5__c IN: contactsToLoopList or Site_Contact6__c IN: contactsToLoopList)];
         }
         system.debug('@@related site id list'+relatedSiteList );    
         if(!relatedSiteList.IsEmpty() && relatedSiteList!= null && !contactsToLoopList.isEmpty() && contactsToLoopList!=null){
             for(Account relatedSites : relatedSiteList ){
                   for(Id oldContact : contactsToLoopList){

                         if(relatedSites.Site_Contact2__c == oldContact){
                             relatedSites.Site_Contact2__c = null;
                         }
                         if(relatedSites.Site_Contact3__c == oldContact){
                             relatedSites.Site_Contact3__c = null;
                         }
                         if(relatedSites.Site_Contact4__c == oldContact){
                             relatedSites.Site_Contact4__c = null;
                         }
                         if(relatedSites.Site_Contact5__c == oldContact){
                             relatedSites.Site_Contact5__c = null;
                         }
                         if(relatedSites.Site_Contact6__c == oldContact){
                             relatedSites.Site_Contact6__c = null;
                         }
                         if(relatedSites.Site_Primary_Contact__c == oldContact){
                             relatedSites.Site_Primary_Contact__c = null;
                         }
                       
                 } 
                   updatedRelatedSiteList .add(relatedSites);
             }
         }
         system.debug('@@updated site id list'+updatedRelatedSiteList); 
         if(!updatedRelatedSiteList.IsEmpty() && updatedRelatedSiteList!= null){
         try{ 
             
                 Database.update(updatedRelatedSiteList); 
           
         }catch(Exception e){
             system.debug('Exception :'+ e);
         }  
         }  
      }
      
}