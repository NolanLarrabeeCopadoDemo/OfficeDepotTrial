// Appirio 2015
//
// Test class for Mod5BulkBatch 
// NBOCK - Original - 11.25.2015 - S-366874
@isTest
private class Mod5BulkBatchTest {
  static testmethod void testMod51(){
    //create test data
    Account acc = Test_Utils.createAccount('Customer (OfficeMax)');
        acc.Name = 'TestOriginalAccount';
        acc.Split_Record__c = false;
        acc.OMX_Primary_Key__c = '123456';
        insert acc; 
        
        Test.startTest();
               
    Account acc3 = Test_Utils.createAccount('Site (OfficeMax)');
        acc3.Name = 'TestMasterAccount2';
        acc3.Split_Record__c = false;
        acc3.OMX_Primary_Key__c = '123458';
        acc3.Related_Account__c = acc.Id;
        insert acc3;
    Account acc2 = Test_Utils.createAccount('Site (OfficeMax)');
        acc2.Name = 'TestMasterAccount';
        acc2.Split_Record__c = false;
        acc2.OMX_Primary_Key__c = '123457';
        acc2.Related_Account__c = acc3.Id;
        insert acc2;                        
    Customer_Transition__c ct = Test_Utils.createCustomerTransaction(false, acc);
        ct.OMX_Primary_Key__c = '1234567';
        ct.Mod4FlowStatus__c = 'SplitSubmitted';
        ct.Account__c = acc.Id;
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
        insert sad;
    CustTransParentChildLevel__c customSetting = new CustTransParentChildLevel__c();
      customSetting.Name = 'Parent';
      insert customSetting;
    List<Split_Account_Detail__c> splitAccountList = [SELECT Id, Customer_Transition__r.OMX_Primary_Key__c, SHIP_TO_CONSIGNEE__c, 
                                                        Billing_Account__c, NEW_BILL_TO_OMX_CONSIGNEE__c, Master_Account__c, 
                                                        Original_Account__r.ownerId, Original_Account__c, NEW_MAIN_ACCT_ADDRESS__c, 
                                                        Customer_Transition__r.Mod4FlowStatus__c, BatchProcessed__c, New_Header_Billing_Account_Code__c 
                                                        FROM Split_Account_Detail__c 
                                                        WHERE Id = :sad.Id];
     //run batch
    //Test.startTest();
      Mod5BulkBatch m = new Mod5BulkBatch();
      Database.QueryLocator ql = m.start(null);
      m.execute(null,splitAccountList);
      m.Finish(null);
    Test.stopTest();

    List<CustTransParentChildLevel__c> PCLevel2 = [SELECT Mod5LaunchBulkBatchID__C,Mod5BulkLaunchBatchInterval__c FROM
      CustTransParentChildLevel__c];
    System.assert(PCLevel2.size() > 0);
  } 

static testmethod void testMod52(){
    //create test data
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
        insert acc3;
        
        Test.startTest();
        
    Account acc2 = Test_Utils.createAccount('Site (OfficeMax)');
        acc2.Name = 'TestMasterAccount';
        acc2.Split_Record__c = false;
        acc2.OMX_Primary_Key__c = '123457';
        acc2.Related_Account__c = acc3.Id;
        insert acc2;                
    Customer_Transition__c ct = Test_Utils.createCustomerTransaction(false, acc);
        ct.OMX_Primary_Key__c = '1234567';
        ct.Mod4FlowStatus__c = 'SplitSubmitted';
        ct.Account__c = acc.Id;
        insert ct;
    Customer_Transition_Dtls__c details = Test_Utils.createCustomerTransDetails('Sites');
        details.Account_ID__c = acc2.Id;
        details.Bill_To_Account__c = acc2.Id;
        details.OMX_Primary_Key__c = '123456789';
        details.Customer_Transition_ID__c = ct.Id;
        insert details;
    Split_Account_Detail__c sad = Test_Utils.createSplitAccount(false, ct, acc);
        sad.Master_Account__c = acc2.Id;
        sad.BatchProcessed__c = false;
        sad.NEW_BILL_TO_OMX_CONSIGNEE__c = '123457';
        sad.Ship_To_Account__c = acc2.Id;
        sad.Billing_Account__c = acc2.Id;
        sad.Main_Account_Name__c = 'TestMasterAccount';
        sad.Customer_Transition_Detail_Id__c = details.Id;
        sad.New_Header_Billing_Account__c = acc3.Id;
        sad.Original_Account__c = acc.Id;
        insert sad;
    CustTransParentChildLevel__c customSetting = new CustTransParentChildLevel__c();
      customSetting.Name = 'Parent';
      insert customSetting;
    List<Split_Account_Detail__c> splitAccountList = [SELECT Id, Customer_Transition__r.OMX_Primary_Key__c, SHIP_TO_CONSIGNEE__c, 
                                                        Billing_Account__c, NEW_BILL_TO_OMX_CONSIGNEE__c, Master_Account__c, 
                                                        Original_Account__r.ownerId, Original_Account__c, NEW_MAIN_ACCT_ADDRESS__c, 
                                                        Customer_Transition__r.Mod4FlowStatus__c, BatchProcessed__c, New_Header_Billing_Account_Code__c 
                                                        FROM Split_Account_Detail__c 
                                                        WHERE Id = :sad.Id];
     //run batch
      //Test.startTest();
      Mod5BulkBatch m = new Mod5BulkBatch();
      Database.QueryLocator ql = m.start(null);
      m.execute(null,splitAccountList);
      m.Finish(null);
    Test.stopTest();

    List<CustTransParentChildLevel__c> PCLevel2 = [SELECT Mod5LaunchBulkBatchID__C,Mod5BulkLaunchBatchInterval__c FROM
      CustTransParentChildLevel__c];
    System.assert(PCLevel2.size() > 0);
  }
}