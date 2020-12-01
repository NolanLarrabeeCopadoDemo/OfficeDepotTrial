@isTest
private class CustomerTransitionHierarchyUpdate_TC
{
    static testmethod void CustomerTransitionHierarchyUpdateTest()
    {
        Schema.DescribeSObjectResult d1 = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d1.getRecordTypeInfosByName(); 
         
        
        Account pacc = new Account ();
        pacc.name = 'SUN Test Account1';
        pacc.recordtypeid=rtMapByName.get('Customer (OfficeMax)').getRecordTypeId(); 
        pacc.BillingStreet = '1040 N 326 W';
        pacc.billingcity = 'Orem';
        pacc.BillingState = 'UT';
        pacc.Billingcountry = 'USA';
        pacc.Oracle_Party_Id__c = '543456';
        pacc.AOPS_Cust_Id__c = '003456';
        pacc.status__c='Inactive';
        insert pacc;
        
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.parentid=pacc.id;
        insert acc;   
        
        pacc.status__c='Active';
        update pacc;
        
        Customer_Transition__c parentCT = new Customer_Transition__c(name='parenttest',account__c = pacc.id,Status__c='Scheduled');
        insert parentCT;
        
        Customer_Transition__c CT = new Customer_Transition__c(name='test',account__c = acc.id,Status__c='Scheduled');
        insert CT;
        Set<Id> accId=new Set<Id>();
        accId.add(pacc.id);
        accId.add(acc.id);
        
        CustomerTransitionHierarchyUpdate.updateHierarchy(accId);
    }
}