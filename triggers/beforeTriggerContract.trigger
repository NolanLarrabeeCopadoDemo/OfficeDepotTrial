trigger beforeTriggerContract on Contract (before insert, before update) {
    // Common actions to be taken for insert and update
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        
        // Assign Account Extension
        List<Id> acctIds = new List<Id>();

        for (Contract c : Trigger.new) {
            Id acctId = c.AccountId;
            
            if (acctId != null) {
                acctIds.add(acctId);
            }
        }
        
        Map<Id, Id> accountIdToExtensionId = (new AccountExtensionHelper()).getAccountExtensionIds(acctIds); 

        for (Contract c : Trigger.new) {
            Id acctId = c.AccountId;
            c.Account_Extension_Name__c = accountIdToExtensionId.get(acctId);
        }
    }
}