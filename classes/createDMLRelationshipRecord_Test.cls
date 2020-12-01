@isTest
public class createDMLRelationshipRecord_Test {
    static testMethod void UnitTest1() {
        Id Parent_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();
    	Account Acc = new Account();
        Acc.Name='Test';
        Acc.Address1__c='New Testing';
        Acc.City__c='City Test';
        Acc.State__c='TMO';
        Acc.Country__c='USA';
        Acc.Zip__c='12321';
        Acc.Segment__c='State';
        Acc.RecordtypeId=Parent_RecordTypeId;
        Insert Acc;
    }
}