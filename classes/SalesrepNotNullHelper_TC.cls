@isTest
public class SalesrepNotNullHelper_TC {
    static testMethod void UnitTest1() {
		Id Parent_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Great Grandparent').getRecordTypeId();
        Id Contact_RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact(US)').getRecordTypeId();
        Id SiteId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        Account Acc = new Account();
        Acc.Name='Test';
        Acc.Address1__c='New Testing';
        Acc.City__c='City Test';
        Acc.State__c='TMO';
        Acc.Country__c='USA';
        Acc.Zip__c='12321';
        Acc.RecordtypeId=Parent_RecordTypeId;
        Insert Acc;
    }
}