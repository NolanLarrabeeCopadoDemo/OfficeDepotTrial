public with sharing class AccountTriggerMethods {


    public static Set<Id> getUpdatedAccounts(
        Map<Id, Account> oldAccounts,
        Map<Id, Account> newAccounts){

        Set<Id> myNewCustomerIds = new Set<Id>();
        
        for(Id accountId: newAccounts.keySet()){
            if (oldAccounts.get(accountId).RecordTypeId != newAccounts.get(accountId).RecordTypeId)
                myNewCustomerIds.add(accountId);
        }
        return myNewCustomerIds;
    }
}