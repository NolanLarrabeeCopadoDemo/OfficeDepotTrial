trigger Contact_Trigger on Contact (before update, before insert) {
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

    // Common actions to be taken for insert and update
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        
        // Assign Account Extension
        List<Id> acctIds = new List<Id>();

        for (Contact c : Trigger.new) {
            Id acctId = c.AccountId;
            
            if (acctId != null) {
                acctIds.add(acctId);
            }
        }
        
        Map<Id, Id> accountIdToExtensionId = (new AccountExtensionHelper()).getAccountExtensionIds(acctIds); 

        for (Contact c : Trigger.new) {
            Id acctId = c.AccountId;
            c.Account_Extension_Name__c = accountIdToExtensionId.get(acctId);
        }
    }
}