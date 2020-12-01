@isTest
private class OMXAddressUpdate_TC
{
    static testMethod void TestOMXAddressUpdate(){
    Id RecTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId();
    
    Account acc = new Account();
    acc.Name = 'OMX Address 2 Update Test Account';
    acc.Recordtypeid = RecTypeId;
    acc.Address1__c = '4826 River Walk';
    acc.Address2__c = 'Apt 22';
    acc.City__c = 'Illinois';
    acc.Zip__c = '60001';
    acc.State__c = 'CH';
    acc.Country__c = 'USA';
    insert acc;
    
    acc.Address2__c = 'Apt 50';
    update acc;
    }
}