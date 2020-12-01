trigger Deviated_Cost_Trigger on Deviated_Cost__c (before insert, before update) {
    // Common actions to be taken for insert and update
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        
        // Assign Account Extension
        List<Id> acctIds = new List<Id>();

        for (Deviated_Cost__c dc : Trigger.new) {
            Id acctId = dc.Account_Name__c;
            
            if (acctId != null) {
                acctIds.add(acctId);
            }
        }
        
        Map<Id, Id> accountIdToExtensionId = (new AccountExtensionHelper()).getAccountExtensionIds(acctIds); 

        for (Deviated_Cost__c dc : Trigger.new) {
            Id acctId = dc.Account_Name__c;
            dc.Account_Extension_Name__c = accountIdToExtensionId.get(acctId);
        }
    }
}