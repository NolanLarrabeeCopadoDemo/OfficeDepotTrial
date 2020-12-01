@isTest
private class Mod5BulkLaunchUpdate_TC {
  static testmethod void Mod5BulkLaunchUpdate_method(){
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
      system.debug('@@@@accids 1' + acc.Id + ' 2 ' + acc2.Id + ' 3 ' + acc3.Id);
    Customer_Transition__c ct = Test_Utils.createCustomerTransaction(false, acc);
      ct.OMX_Primary_Key__c = '1234567';
      ct.Update_Launch_Status__C= true;
      ct.Account__c = acc.Id;
      ct.Split_Launching_Status__c ='Fail';
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
      sad.BulkLaunchProcessed__c=true;
      sad.BatchProcessed__c = false;
      sad.NEW_BILL_TO_OMX_CONSIGNEE__c = '123457';
      sad.Ship_To_Account__c = acc2.Id;
      sad.Billing_Account__c = acc2.Id;
      sad.Main_Account_Name__c = 'TestMasterAccount';
      sad.Customer_Transition_Detail_Id__c = details.Id;
      sad.New_Header_Billing_Account__c = acc2.Id;
      insert sad;
      
      Account sadAcc = Test_Utils.createAccount('Site (OfficeMax)');
      sadAcc.Name = 'TestMasterAccount-01';
      sadAcc.Split_Record__c = false;
      sadAcc.OMX_Primary_Key__c = '123457-01';
      sadAcc.Related_Account__c = acc.Id;
      insert sadAcc;
      system.debug('@@@@accids 1' + acc.Id + ' 2 ' + acc2.Id + ' 3 ' + acc3.Id);
    Customer_Transition__c sadCt = Test_Utils.createCustomerTransaction(false, sadAcc);
      sadCt.OMX_Primary_Key__c = '1234567-01';
      sadCt.Account__c = sadAcc.Id;
      insert sadCt;
      
     
      
    CustTransParentChildLevel__c customSetting = new CustTransParentChildLevel__c();
      customSetting.Name = 'Parent';
      customSetting.Mod5_LaunchUpdateInterval__C=300;
      insert customSetting;
      
      
    List<Split_Account_Detail__c> splitAccountList = [SELECT Id, Customer_Transition__r.OMX_Primary_Key__c, SHIP_TO_CONSIGNEE__c, 
                              Billing_Account__c, NEW_BILL_TO_OMX_CONSIGNEE__c, Master_Account__c, 
                              Original_Account__r.ownerId, Original_Account__c, NEW_MAIN_ACCT_ADDRESS__c, 
                              Customer_Transition__r.Mod4FlowStatus__c, BatchProcessed__c, New_Header_Billing_Account_Code__c 
                              FROM Split_Account_Detail__c 
                            WHERE Id = :sad.Id];
     //run batch
    //Test.startTest();
     String strQuery = '';
        Mod5BulkLaunchUpdate Mod5BulkSplitCreateBatchObj = new Mod5BulkLaunchUpdate (strQuery);
        database.executebatch(Mod5BulkSplitCreateBatchObj , 500);
        
        sad.BulkLaunchProcessed__c=true;
        sad.Linked_Customer_Transition__c=sadCt.Id;
        update sad;
        ct.Split_Launching_Status__c ='Success';
        ct.Update_Launch_Status__C= true;
        update ct;
        
      Mod5BulkLaunchUpdate Mod5BulkSplitCreateBatchObj1 = new Mod5BulkLaunchUpdate (strQuery);
        database.executebatch(Mod5BulkSplitCreateBatchObj1 , 500);
      
    Test.stopTest();

    List<CustTransParentChildLevel__c> PCLevel2 = [SELECT Mod5LaunchBulkBatchID__C,Mod5BulkLaunchBatchInterval__c FROM
      CustTransParentChildLevel__c];
    System.assert(PCLevel2.size() > 0);
    
    
    
    
  } 
  }