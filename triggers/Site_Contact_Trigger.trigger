trigger Site_Contact_Trigger on SiteContacts__c (before update, before insert) {
    // Common actions to be taken for insert and update
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        
        // Assign Account Extension
        List<Id> acctIds = new List<Id>();

        for (SiteContacts__c c : Trigger.new) {
            Id acctId = c.Account__c;
            
            if (acctId != null) {
                acctIds.add(acctId);
            }
        }
        
        Map<Id, Id> accountIdToExtensionId = (new AccountExtensionHelper()).getAccountExtensionIds(acctIds); 

        for (SiteContacts__c c : Trigger.new) {
            Id acctId = c.Account__c;
            c.Account_Extension__c = accountIdToExtensionId.get(acctId);
        }
    }
}