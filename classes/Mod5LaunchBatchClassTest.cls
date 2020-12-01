// Appirio 2015
//
// Test class for Mod5LaunchBatchClass 
// NBOCK - Original - 2.10.2016 - S-377000
@isTest
private class Mod5LaunchBatchClassTest {
  static testmethod void testMod51(){
    CustTransParentChildLevel__c customSetting = new CustTransParentChildLevel__c();
      customSetting.Name = 'Parent';
      insert customSetting;
      //Added by Lalit for S-404759 START
      /*
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
    
        
    Customer_Transition__c acc1CT = new Customer_Transition__c(name='test1',account__c = acc1.id,Status__c='Scheduled',MOD5_Ready_To_Launch__c=true,BulkSplit__C=false);
    insert acc1CT;  */  
    //S-434785 (OD 00777600) Connor Flynn Start
    Account acc = Test_Utils.createAccount('Customer (OfficeMax)');
      acc.Name = 'TestOriginalAccount';

      acc.Split_Record__c = false;
      acc.OMX_Primary_Key__c = '123456';
      insert acc;
    Account acc3 = Test_Utils.createAccount('Site (OfficeMax)');
      acc3.Name = 'TestMasterAccount2';
      acc3.Split_Record__c = false;
      acc3.OMX_Primary_Key__c = '123458';
      acc3.Related_Account__c = acc.Id;
      acc3.Segment__c = 'Major $500K-$1M';
      acc3.Status__c = 'Active';
      insert acc3;
      
      Test.startTest();
      
      User usr = Test_Utils.CreateUser();
      
      Sales_Person__c sp = new Sales_Person__c(Primary__c = true, User__c = usr.Id);
      insert sp;
    
    Account acc2 = Test_Utils.createAccount('Site (OfficeMax)');
      acc2.Name = 'TestMasterAccount';
      acc2.Segment__c = 'Major $500K-$1M';
      acc2.Status__c = 'Active';
      acc2.Split_Record__c = false;
      acc2.OMX_Primary_Key__c = '123457';
      acc2.Related_Account__c = acc3.Id;
      acc2.Sales_PersonID__c = sp.Id;
      acc2.OwnerId = usr.Id;
      insert acc2;
      
      Customer_Transition__c ct2 = Test_Utils.createCustomerTransaction(false, acc);
      ct2.OMX_Primary_Key__c = '1212';
      ct2.Status__c = 'ODP Agreement in Development';
      ct2.MOD5_Ready_To_Launch__c = false;
      ct2.Ready_for_Mod1__c = false;
      ct2.Name = 'Customer Transition Parent of test';
      ct2.BulkSplit__c = false;
      ct2.Mod4FlowStatus__c = 'SplitSubmitted';
      ct2.Written_Agreement__c = true;
      ct2.Account__c = acc3.Id;
      insert ct2;

    Customer_Transition__c ct = Test_Utils.createCustomerTransaction(false, acc);
      ct.OMX_Primary_Key__c = '123457';
      ct.Parent_Transition_ID__c = ct2.Id;
      ct.Status__c = 'ODP Agreement in Development';
      ct.MOD5_Ready_To_Launch__c = true;
      ct.BulkSplit__c = false;
      ct.Mod4FlowStatus__c = 'SplitSubmitted';
      ct.Account__c = acc2.Id;
      insert ct;
  Customer_Transition_Dtls__c details = Test_Utils.createCustomerTransDetails('Sites');
    details.Account_ID__c = acc2.Id;
    details.Bill_To_Account__c = acc2.Id;
    details.OMX_Primary_Key__c = '123456789';
    details.Customer_Transition_ID__c = ct.Id;
    insert details;
    Split_Account_Detail__c sad = Test_Utils.createSplitAccount(false, ct, acc);
      sad.Master_Account__c = acc2.Id;
      sad.NEW_MAIN_ACCT_ADDRESS__c = '123457';
      sad.BatchProcessed__c = false;
      sad.NEW_BILL_TO_OMX_CONSIGNEE__c = '123457';
      sad.Ship_To_Account__c = acc2.Id;
      sad.Billing_Account__c = acc2.Id;
      sad.Main_Account_Name__c = 'TestMasterAccount';
      sad.Customer_Transition_Detail_Id__c = details.Id;
      sad.New_Header_Billing_Account__c = acc2.Id;
      sad.Original_Account__c = acc2.Id;
      sad.Customer_Transition__c = ct.Id;
      sad.Linked_Customer_Transition__c = ct2.Id;
      insert sad;
      //Added by Lalit for S-404759 END
      //S-434785 (OD 00777600) Connor Flynn End
    //Test.startTest();
      Mod5LaunchBatchClass m = new Mod5LaunchBatchClass();
      Database.executeBatch(m);
    Test.stopTest();

    List<CustTransParentChildLevel__c> PCLevel2 = [SELECT Id FROM
      CustTransParentChildLevel__c];
    System.assert(PCLevel2.size() > 0);
  }
}