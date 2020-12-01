@isTest
private class Account_Profile_Trigger_TC {
    
    private static testmethod void testAccountProfile() {
	    recordType recType = [Select Id from RecordType where Name = 'Customer' AND sObjectType = 'Account'];
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        acc.RecordTypeId = recType.Id;

        Database.SaveResult result = Database.insert(acc);
        Id accId = result.getId();
	    
        Account_Profile__c ap = new Account_Profile__c(Account__c = accId);
        insert ap;
        update ap;
	}
}