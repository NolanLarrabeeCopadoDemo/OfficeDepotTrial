@isTest
private class AccountCustomerTransitionCreation_TC
{

    static testMethod void AccountCustomerTransitionCreationTest() 
    {
    
    Account acc1 = new Account();
    acc1.name = 'Ank Test account1';
    acc1.BillingStreet = '1040 N 326 W';
    acc1.billingcity = 'Orem';
    acc1.BillingState = 'UT';
    acc1.Billingcountry = 'USA';
    acc1.Buying_Group__c = 'Buying Groups Federal';
    acc1.Sector__c = 'Public';
    acc1.Segment__c = 'Federal';
    acc1.Oracle_Party_Id__c = 'testdata';
    acc1.AOPS_Cust_Id__c = '123456';
    acc1.AOPS_Seq_ID__c = '123456';
    insert acc1;
    
    Account acc2 = new Account();
    acc2.name = 'Ank Test account2';
    acc2.BillingStreet = '1040 N 327 W';
    acc2.billingcity = 'Orem';
    acc2.BillingState = 'UT';
    acc2.Billingcountry = 'USA';
    acc2.Buying_Group__c = 'Buying Groups Federal';
    acc2.Sector__c = 'Public';
    acc2.Segment__c = 'Federal';
    acc2.parentid=acc1.id;
    acc2.Oracle_Party_Id__c = '654321';
    acc2.AOPS_Cust_Id__c = '123457';
    acc2.AOPS_Seq_ID__c = '123457';
    insert acc2;
    
    Account acc3 = new Account();
    acc3.name = 'Ank Test account3';
    acc3.BillingStreet = '1040 N 328 W';
    acc3.billingcity = 'Orem';
    acc3.BillingState = 'UT';
    acc3.Billingcountry = 'USA';
    acc3.Buying_Group__c = 'Buying Groups Federal';
    acc3.Sector__c = 'Public';
    acc3.Segment__c = 'Federal';
    acc3.parentid=acc2.id;
    acc3.Oracle_Party_Id__c = '654312';
    acc3.AOPS_Cust_Id__c = '123458';
    acc3.AOPS_Seq_ID__c = '123458';
    insert acc3;
    
    Account acc4 = new Account();
    acc4.name = 'Ank Test account4';
    acc4.BillingStreet = '1040 N 329 W';
    acc4.billingcity = 'Orem';
    acc4.BillingState = 'UT';
    acc4.Billingcountry = 'USA';
    acc4.Buying_Group__c = 'Buying Groups Federal';
    acc4.Sector__c = 'Public';
    acc4.Segment__c = 'Federal';
    acc4.parentid=acc3.id;
    acc4.Oracle_Party_Id__c = '654334';
    acc4.AOPS_Cust_Id__c = '123459';
    acc4.AOPS_Seq_ID__c = '123459';
    insert acc4;
    
    Account acc5 = new Account();
    acc5.name = 'Ank Test account5';
    acc5.BillingStreet = '1040 N 330 W';
    acc5.billingcity = 'Orem';
    acc5.BillingState = 'UT';
    acc5.Billingcountry = 'USA';
    acc5.Buying_Group__c = 'Buying Groups Federal';
    acc5.Sector__c = 'Public';
    acc5.Segment__c = 'Federal';
    acc5.parentid=acc4.id;
    acc5.Oracle_Party_Id__c = '654356';
    acc5.AOPS_Cust_Id__c = '123460';
    acc5.AOPS_Seq_ID__c = '123460';
    insert acc5;
    
    //AccountCustomerTransitionCreation accCustomerT = new AccountCustomerTransitionCreation();
    Set<Id> accountIdsList = new Set<Id>();
    accountIdsList.add(acc1.id);
    accountIdsList.add(acc2.id);
    accountIdsList.add(acc3.id);
    accountIdsList.add(acc4.id);
    accountIdsList.add(acc5.id);
    
    Test.startTest(); 
    Customer_Transition__c acc1CT = new Customer_Transition__c(name='test1',account__c = acc1.id,Status__c='Scheduled');
    insert acc1CT;
    
    Customer_Transition__c acc2CT = new Customer_Transition__c(name='test2',account__c = acc2.id,Status__c='Scheduled');
    insert acc2CT;
    
    Customer_Transition__c acc3CT = new Customer_Transition__c(name='test3',account__c = acc3.id,Status__c='Scheduled');
    insert acc3CT;
    
    Customer_Transition__c acc4CT = new Customer_Transition__c(name='test4',account__c = acc4.id,Status__c='Scheduled');
    insert acc4CT;
    
    Customer_Transition__c acc5CT = new Customer_Transition__c(name='test5',account__c = acc5.id,Status__c='Scheduled');
    insert acc5CT;
    Test.stopTest();
    
    AccountCustomerTransitionCreation.findAndAddAllParents(accountIdsList);
    List<account> updateAcc = new List<account>();
    List<Customer_Transition__c> ctList = new List<Customer_Transition__c>();
    
    acc1.AOPS_Cust_Id__c = '12345';
    acc2.omx_mainframe_account_level__c='Main Account';
    acc3.omx_mainframe_account_level__c='National';
    acc4.recordtypeId=System.Label.Customer;
    
    updateAcc.add(acc1);
    updateAcc.add(acc2);
    updateAcc.add(acc3);
    updateAcc.add(acc4);
    
    ctList.add(acc1CT);
    ctList.add(acc2CT);
    ctList.add(acc3CT);
    ctList.add(acc4CT);
    
    update updateAcc;
    delete ctList;

    List<Id> newAccountIdsList = new List<Id>();
    newAccountIdsList.add(acc1.id);
    newAccountIdsList.add(acc2.id);
    newAccountIdsList.add(acc3.id);
    newAccountIdsList.add(acc4.id);
    newAccountIdsList.add(acc5.id);
    
    AccountCustomerTransitionCreation.createAssociatedCustomerTransitionRecord(newAccountIdsList);
    
    }
}