// Appirio 2015
//
// Test class for Mod5LaunchBatchClassBulk 
// NBOCK - Original - 11.25.2015 - S-366874
@isTest
private class Mod5LaunchBatchClassBulkTest {
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
      insert ct2;
    Split_Account_Detail__c splitAccount = new Split_Account_Detail__c();
      splitAccount.Original_Account__c = acc.Id;
      splitAccount.Customer_Transition__c = ct2.Id;
      splitAccount.BulkLaunchProcessed__c = false;
      splitAccount.Linked_Customer_Transition__c = ct2.Id;
      insert splitAccount; 
    CustTransParentChildLevel__c customSetting = new CustTransParentChildLevel__c();
      customSetting.Name = 'Parent';
      insert customSetting;

    List<Customer_Transition__c> transitionList = [SELECT Id, Parent_Transition_ID__c, Parent_Transition_ID__r.Ready_for_Mod1__c, Parent_Transition_ID__r.Customer_Transition_Type__c, Parent_Transition_ID__r.OMX_Primary_Key__c, OMX_Primary_Key__c, No_of_Active_Sites__c, CountLaunchError__c FROM Customer_Transition__c WHERE Id = :ct2.Id Limit 1];
     //run batch
    Test.startTest();
      Mod5LaunchBatchClassBulk m = new Mod5LaunchBatchClassBulk();
      Database.QueryLocator ql = m.start(null);
      m.execute(null,transitionList);
      m.Finish(null);
    Test.stopTest();

    List<CustTransParentChildLevel__c> PCLevel2 = [SELECT Mod5LaunchBulkBatchID__C,Mod5BulkLaunchBatchInterval__c FROM
      CustTransParentChildLevel__c];
    System.assert(PCLevel2.size() > 0);
  } 

  static testmethod void testMod52(){
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
      ct.Written_Agreement__c = true;
      insert ct;
    Customer_Transition__c ct2 = Test_Utils.createCustomerTransaction(false, acc);
      ct2.MOD5_Ready_To_Launch__c = true;
      ct2.BulkSplit__c = true;
      ct2.OMX_Primary_Key__c = acc.Id;
      ct2.Parent_Transition_ID__c = ct.Id;
      ct2.Status__c = 'Scheduled';
      insert ct2;
    Split_Account_Detail__c splitAccount = new Split_Account_Detail__c();
      splitAccount.Original_Account__c = acc.Id;
      splitAccount.Customer_Transition__c = ct2.Id;
      splitAccount.BulkLaunchProcessed__c = false;
      splitAccount.Linked_Customer_Transition__c = ct2.Id;
      insert splitAccount; 
    CustTransParentChildLevel__c customSetting = new CustTransParentChildLevel__c();
      customSetting.Name = 'Parent';
      insert customSetting;

    List<Customer_Transition__c> transitionList = [SELECT Id, Parent_Transition_ID__c, Parent_Transition_ID__r.Ready_for_Mod1__c, Parent_Transition_ID__r.Customer_Transition_Type__c, Parent_Transition_ID__r.OMX_Primary_Key__c, OMX_Primary_Key__c, No_of_Active_Sites__c, CountLaunchError__c FROM Customer_Transition__c WHERE Id = :ct2.Id Limit 1];
     //run batch
    Test.startTest();
      Mod5LaunchBatchClassBulk m = new Mod5LaunchBatchClassBulk();
      Database.QueryLocator ql = m.start(null);
      m.execute(null,transitionList);
      m.Finish(null);
    Test.stopTest();

    List<CustTransParentChildLevel__c> PCLevel2 = [SELECT Mod5LaunchBulkBatchID__C,Mod5BulkLaunchBatchInterval__c FROM
      CustTransParentChildLevel__c];
    System.assert(PCLevel2.size() > 0);
  } 

  static testmethod void testMod53(){
    // create test data
    Account acc = Test_Utils.createAccount('Customer (OfficeMax)');
      acc.Split_Record__c = true;
      insert acc;
      acc.OMX_Primary_Key__c = acc.Id;
      acc.Sales_PersonID__c = null;
      acc.OMX_Mainframe_Account_Level__c = 'Main Account';
      update acc;
    Customer_Transition__c ct = Test_Utils.createCustomerTransaction(false, acc);
      ct.MOD5_Ready_To_Launch__c = true;
      ct.Ready_for_Mod1__c = false;
      ct.Name = 'Customer Transition Parent of TestAccount';
      ct.BulkSplit__c = true;
      ct.OMX_Primary_Key__c = acc.Id + '-1';
      ct.Status__c = 'On Deck';
      ct.Written_Agreement__c = false;
      insert ct;
    Customer_Transition__c ct2 = Test_Utils.createCustomerTransaction(false, acc);
      ct2.MOD5_Ready_To_Launch__c = true;
      ct2.BulkSplit__c = true;
      ct2.OMX_Primary_Key__c = acc.Id;
      ct2.Parent_Transition_ID__c = ct.Id;
      ct2.Status__c = 'On Deck';
      ct2.Written_Agreement__c = false;
      insert ct2;
    Split_Account_Detail__c splitAccount = new Split_Account_Detail__c();
      splitAccount.Original_Account__c = acc.Id;
      splitAccount.Customer_Transition__c = ct2.Id;
      splitAccount.BulkLaunchProcessed__c = false;
      splitAccount.Linked_Customer_Transition__c = ct2.Id;
      insert splitAccount; 
    CustTransParentChildLevel__c customSetting = new CustTransParentChildLevel__c();
      customSetting.Name = 'Parent';
      insert customSetting;

    List<Customer_Transition__c> transitionList = [SELECT Id, Parent_Transition_ID__c, Parent_Transition_ID__r.Ready_for_Mod1__c, Parent_Transition_ID__r.Customer_Transition_Type__c, Parent_Transition_ID__r.OMX_Primary_Key__c, OMX_Primary_Key__c, No_of_Active_Sites__c, CountLaunchError__c FROM Customer_Transition__c WHERE Id = :ct2.Id Limit 1];
     //run batch
    Test.startTest();
      Mod5LaunchBatchClassBulk m = new Mod5LaunchBatchClassBulk();
      Database.QueryLocator ql = m.start(null);
      m.execute(null,transitionList);
      m.Finish(null);
    Test.stopTest();

    List<CustTransParentChildLevel__c> PCLevel2 = [SELECT Mod5LaunchBulkBatchID__C,Mod5BulkLaunchBatchInterval__c FROM
         CustTransParentChildLevel__c];
    System.assert(PCLevel2.size() > 0);
  }
}