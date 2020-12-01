trigger beforeTaskTrigger on Task (before Insert, before update) {
    //Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone)
    for(Task t: trigger.new)
    {
        if(util.checkRT('Task').contains(t.recordtypeId))
            return;
    }
       for(Task newTask : Trigger.New) {
        // Case 01442425 - Skip everything if the lead is of recordtype BizBox 
        if (newTask .RecordTypeId == Schema.SobjectType.Task.getRecordTypeInfosByName().get('BizBox').getRecordTypeId()) {
            return;
        } 
         
         }
    // Common actions to be taken for insert and update
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        
        // Assign Account Extension
        List<Id> acctIds = new List<Id>();

        for (Task t : Trigger.new) {
            Id acctId = t.AccountId;
            
            if (acctId != null) {
                acctIds.add(acctId);
            }
        }
        
        Map<Id, Id> accountIdToExtensionId = (new AccountExtensionHelper()).getAccountExtensionIds(acctIds); 

        for (Task t : Trigger.new) {
            Id acctId = t.AccountId;
            t.Event_Account_Extension__c = accountIdToExtensionId.get(acctId);
        }
    }
    
    // To store ILC users
    List<Instructional_Lead_Consultant__c> iLCList = [SELECT Id, User__c FROM Instructional_Lead_Consultant__c];
    Map <Id, Instructional_Lead_Consultant__c> ilcMap = new Map<Id, Instructional_Lead_Consultant__c>();
    
    for (Instructional_Lead_Consultant__c i: iLCList) {
        ilcMap.put(i.User__C, i) ;
    }
    
    for (Task rec : Trigger.New) {
        if (Trigger.isInsert || (Trigger.isUpdate && rec.ActivityDate != Trigger.oldMap.get(rec.Id).ActivityDate)) {
            if (rec.Task_Type__c == 'In Person' && ilcMap.containsKey(rec.ownerId)) {
                rec.ILC_Batch__C = true;
            }
        }
    }
}