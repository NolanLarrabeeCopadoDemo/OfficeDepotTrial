trigger CPM_Data_Trigger on CPM_Data__c (before update, before insert) {
    // Common actions to be taken for insert and update
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        
        // Assign Account Extension
        List<Id> acctIds = new List<Id>();

        for (CPM_Data__c cpm : Trigger.new) {
            Id acctId = cpm.Account_name__c;
            
            if (acctId != null) {
                acctIds.add(acctId);
            }
        }
        
        Map<Id, Id> accountIdToExtensionId = (new AccountExtensionHelper()).getAccountExtensionIds(acctIds); 

        for (CPM_Data__c cpm : Trigger.new) {
            Id acctId = cpm.Account_name__c;
            cpm.Account_Extension__c = accountIdToExtensionId.get(acctId);
        }
    }
}