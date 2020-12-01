// (c) 2016 Appirio, Inc.
//
// This test class tests the batch class and scheduler for
// BatchUpdasteCustomerTransition to confirm the 3 email fields are
// filled out
//
// 6 Oct 2016     Luke Slevin       Original S-440213/S-440215

@isTest
private class BatchUpdateCustomerTransitionTest {

    @isTest static void TestPopulationofEmailFields() {
        List<Account> accLst = new List<Account>();
        List<Customer_Transition__c> ctLst = new List<Customer_Transition__c>();

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
        accLst.add(acc1);

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
        accLst.add(acc2);

        Account acc3 = new Account();
        acc3.name = 'Ank Test account3 Testing Email';
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
        accLst.add(acc3);

        Account acc4 = new Account();
        acc4.name = 'Ank Test account4';
        acc4.BillingStreet = '1040 N 329 W';
        acc4.billingcity = 'Orem';
        acc4.BillingState = 'UT';
        acc4.Billingcountry = 'USA';
        acc4.Buying_Group__c = 'Buying Groups Federal';
        acc4.Sector__c = 'Public';
        acc4.Segment__c = 'Federal';
        acc4.parentid=acc2.id;
        acc4.Oracle_Party_Id__c = '654334';
        acc4.AOPS_Cust_Id__c = '123459';
        acc4.AOPS_Seq_ID__c = '123459';
        accLst.add(acc4);

        insert accLst;

        Customer_Transition__c acc1CT = new Customer_Transition__c(name='Customer Transition Grandparent of Test Account',account__c = acc1.id,Status__c='Scheduled');
        ctLst.add(acc1CT);

        Customer_Transition__c acc2CT = new Customer_Transition__c(name='Customer Transition Parent of Test',account__c = acc2.id,Status__c='Scheduled');
        ctLst.add(acc2CT);

        Customer_Transition__c acc3CT = new Customer_Transition__c(name='test3',account__c = acc3.id,Status__c='Scheduled');
        ctLst.add(acc3CT);

        Customer_Transition__c acc4CT = new Customer_Transition__c(name='test4',account__c = acc4.id,Status__c='Scheduled');
        ctLst.add(acc4CT);

        insert ctLst;

        Test.startTest();
            BatchUpdateCustomerTransition b = new BatchUpdateCustomerTransition();
            database.executebatch(b);

            Customer_Transition__c ct = [SELECT Id, Enterprise_Managing_Director_Email__c FROM Customer_Transition__c WHERE ID =: acc2CT.Id];
            system.assert(ct.Enterprise_Managing_Director_Email__c == null);

        Test.stopTest();
    }

}