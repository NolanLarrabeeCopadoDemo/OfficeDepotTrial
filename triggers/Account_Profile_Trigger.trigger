trigger Account_Profile_Trigger on Account_Profile__c (before update, before insert) {
    
          Id SystemId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('System').getRecordTypeId();

    // Common actions to be taken for insert and update
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        
        // Assign Account Extension
        List<Id> acctIds = new List<Id>();

        for (Account_Profile__c ap : Trigger.new) {
            Id acctId = ap.Account__c;
            if (acctId != null  ) {
                acctIds.add(acctId);
            }
        }
        // Bypass the logic If teh account is a System Account 
        Map<Id, Id> accountIdToExtensionId = new Map<Id, Id> ();
        List<Account> accntFilter =[select Id from Account where Id in:acctIds and recordtypeId !=:SystemId];
        if(accntFilter.size()>0)
        accountIdToExtensionId = (new AccountExtensionHelper()).getAccountExtensionIds(acctIds); 

        for (Account_Profile__c ap : Trigger.new) {
            Id acctId = ap.Account__c;
            if(accountIdToExtensionId .containskey(acctId))
            ap.Account_Profile_Extension_Account__c = accountIdToExtensionId.get(acctId);
        }
    }
}