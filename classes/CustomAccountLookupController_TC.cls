@istest
private class CustomAccountLookupController_TC
{
    static testmethod void method1(){
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        insert acc;   
        
        Customer_Transition__c CT = new Customer_Transition__c(Error_Message__c='test',name='test',account__c = acc.id,Error_Code__c = 'Error');
        insert CT; 
  customer_transition_dtls__c   CTD= new customer_transition_dtls__c(Error_Code__c = 'Error',OMX_Primary_Key__c='1234',Customer_Transition_ID__c=CT.id);
insert CTD;  
        
        CustomAccountLookupController test = new CustomAccountLookupController();
        test.searchString = 'test';
        test.search();
        test.getFormTag();
        test.getTextBox();
    }
}