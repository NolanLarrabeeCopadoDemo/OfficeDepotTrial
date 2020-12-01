trigger Opportunity_Lattice on Opportunity (before insert) {
    
       //Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone)
    for(Opportunity o: trigger.new)
    {
        if(util.checkRT('Opportunity').contains(o.recordtypeId))
            return;
    }
       // added for ticket 01474559
       if (Trigger.New != null) {
         for (Opportunity myOpp: Trigger.new) {
          if (Util.bizBoxRTIdsByObject('Opportunity').contains(myOpp.RecordTypeId)) {
           return;
          }
         }
        }
        
    set<id> acctIDs = new set<id>();
    Id RecordTypeId='012E000000093JvIAI';
    if (Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GT Field Sales') != null)
      RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('GT Field Sales').getRecordTypeId();
      
    for(Opportunity o : trigger.new){
           if (o.RecordTypeId != RecordTypeId)
            acctIDs.add(o.AccountID);
    }

    map<id, Account> accts = new map<id,Account>([select id, recordtype.Developername, Related_Account__c from Account where id in: acctIDs]); 
    
    for(Opportunity o: trigger.new){
     if (o.RecordTypeId != RecordTypeId) {
        // If Account Type = Site, then (Opportunity) Account Name = (Account) Related Account AND (Opportunity) Related Site = (Account) Account Name
        system.debug(accts.get(o.AccountId));
        if(accts.containsKey(o.AccountId)) {
          if(accts.get(o.AccountId).recordtype.Developername == 'Site' || accts.get(o.AccountId).recordtype.Developername == 'Site_OfficeMax'){
            o.Related_Site__c = o.AccountID;
            o.AccountID= accts.get(o.AccountID).Related_Account__c;
          }
        }
      }  
    }
        
}