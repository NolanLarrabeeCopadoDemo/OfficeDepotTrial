trigger beforeeventTrigger  on Event (before Insert, before update) {
//Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone)
    for(Event e: trigger.new)
    {
        if(util.checkRT('Event').contains(e.recordtypeId))
            return;
    }
    // Common actions to be taken for insert and update
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        
        // Assign Account Extension
        List<Id> acctIds = new List<Id>();

        for (Event e : Trigger.new) {
            Id acctId = e.AccountId;
            
            if (acctId != null) {
                acctIds.add(acctId);
            }
        }
        
        Map<Id, Id> accountIdToExtensionId = (new AccountExtensionHelper()).getAccountExtensionIds(acctIds); 

        for (Event e : Trigger.new) {
            Id acctId = e.AccountId;
            e.Event_Account_Extension__c = accountIdToExtensionId.get(acctId);
        }
    }

    //to store ILC users
        List< Instructional_Lead_Consultant__c> iLCList= [SELECT Id, User__c FROM Instructional_Lead_Consultant__c];
        Map<Id,Instructional_Lead_Consultant__c>ilcMap= new Map<Id,Instructional_Lead_Consultant__c>();
        for(Instructional_Lead_Consultant__c i: iLCList ){
         ilcMap.put(i.User__C,i) ;
        }

  for( Event rec: Trigger.New){
  if(Trigger.isInsert || (Trigger.isUpdate &&  rec.ActivityDate!= Trigger.oldMap.get(rec.Id).ActivityDate))
     if(rec.Task_Type__c=='In Person' && ilcMap.containsKey(rec.ownerId)){
       rec.ILC_Batch__C=true;
     }
  }

}