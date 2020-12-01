// Appirio 2015
//
// Test class for Mod5BulkSplitDeleteBatch 
// NBOCK - Original - 11.25.2015 - S-366874
@isTest
private class Mod5BulkSplitDeleteBatchTest {
  static testmethod void testMod51(){
    // create test data
    Account acc = Test_Utils.createAccount('Customer (OfficeMax)');
      acc.Split_Record__c = true;
      insert acc;
      acc.OMX_Primary_Key__c = acc.Id;
      update acc;
    Customer_Transition__c ct = Test_Utils.createCustomerTransaction(false, acc);
      ct.MOD5_Ready_To_Launch__c = true;
      ct.Ready_for_Mod1__c = false;
      ct.Name = 'Customer Transition Parent of TestAccount';
      ct.BulkSplit__c = true;
      ct.OMX_Primary_Key__c = acc.Id + '-1';
      ct.Status__c = 'Scheduled';
      insert ct;
    Customer_Transition__c ct2 = Test_Utils.createCustomerTransaction(false, acc);
      ct2.MOD5_Ready_To_Launch__c = true;
      ct2.BulkSplit__c = true;
      ct2.OMX_Primary_Key__c = acc.Id;
      ct2.Parent_Transition_ID__c = ct.Id;
      ct2.Status__c = 'Scheduled';
      ct2.Mod4FlowStatus__c = 'Bulk Split Delete';
      insert ct2;
    Split_Account_Detail__c splitAccount = new Split_Account_Detail__c();
      splitAccount.Original_Account__c = acc.Id;
      splitAccount.Customer_Transition__c = ct2.Id;
      splitAccount.BulkLaunchProcessed__c = false;
      splitAccount.Linked_Customer_Transition__c = ct2.Id;
      insert splitAccount; 

  	Customer_Transition_Dtls__c details = Test_Utils.createCustomerTransDetails('Sites');
  	details.Customer_Transition_ID__c = ct2.Id;
  	details.aops_flag__C = 'Y';
  	insert details; 

    CustTransParentChildLevel__c customSetting = new CustTransParentChildLevel__c();
      customSetting.Name = 'Parent';
      insert customSetting;
     //run batch
    Test.startTest();
      Mod5BulkSplitDeleteBatch m = new Mod5BulkSplitDeleteBatch();
      Database.executeBatch(m, 200);
    Test.stopTest();

    List<CustTransParentChildLevel__c> PCLevel2 = [SELECT Mod5LaunchBulkBatchID__C,Mod5BulkLaunchBatchInterval__c FROM
      CustTransParentChildLevel__c];
    System.assert(PCLevel2.size() > 0);
  } 
}