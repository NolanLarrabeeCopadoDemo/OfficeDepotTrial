@isTest
public class BeforeAccountTrigger_TC {
    @isTest
    public static void test() {
        // Create Cust ODP
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
        
        Account acct = [SELECT Id, RecordTypeId FROM Account WHERE Id = :accId];
        System.debug('------------------------> ' + acct.RecordTypeId);
        
        // Switch to Cust OMX
         Id CustOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId();
        acct.RecordTypeId = CustOMX;
        update acct;
        
        acct = [SELECT Id, RecordTypeId FROM Account WHERE Id = :accId];
        System.debug('------------------------> ' + acct.RecordTypeId);

    }
    static testmethod void method1()
    {
    recordType recType = [Select Id from RecordType where Name = 'Site' AND sObjectType = 'Account'];
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
        
        Account acct = [SELECT Id, RecordTypeId FROM Account WHERE Id = :accId];
        
        
        // Switch to Cust OMX
         Id SiteOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (OfficeMax)').getRecordTypeId();
        acct.RecordTypeId = SiteOMX;
        update acct;
        
        acct = [SELECT Id, RecordTypeId FROM Account WHERE Id = :accId];
      

    }
}