@isTest
private class AExtensionTrigger_TC {

    private static testMethod void test() {
        Account a = Test_Utils.createAccount('Customer');
        insert a;
        Account a1 = [SELECT Id, Account_Extension__c FROM Account WHERE ID = :a.Id];
        
        Account_Dormant__c d = new Account_Dormant__c(Original_Account_ID__c = a1.Id, AccountExtension__c = a1.Account_Extension__c);
        insert d;
        
        Account_Extension__c ae = new Account_Extension__c(Id = a1.Account_Extension__c, Account_Owner_ID__c = '005E0000000R7xz'); // Dataloader user
        update ae;
    }
}