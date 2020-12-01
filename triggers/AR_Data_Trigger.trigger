trigger AR_Data_Trigger on A_R_Data__c (before update, before insert) {
    // Common actions to be taken for insert and update
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        
        // Assign Account Extension
        List<Id> acctIds = new List<Id>();

        for (A_R_Data__c ar : Trigger.new) {
            Id acctId = ar.Account__c;
            
            if (acctId != null) {
                acctIds.add(acctId);
            }
        }
        
        Map<Id, Id> accountIdToExtensionId = (new AccountExtensionHelper()).getAccountExtensionIds(acctIds); 

        for (A_R_Data__c ar : Trigger.new) {
            Id acctId = ar.Account__c;
            ar.Account_Extension__c = accountIdToExtensionId.get(acctId);
        }
    }
}