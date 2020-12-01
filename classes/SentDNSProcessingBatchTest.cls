// Test class for SentDNSProcessingBatch 

@isTest
private class SentDNSProcessingBatchTest {
  static testmethod void tstMethod(){
    //create test data
     //Test.startTest();
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
        ct.DNS_Status_Confirmed__c = true;
        ct.BatchProcessSentDNS__c =true;
        //ct.AOPS_Assigned_AOPS_Account_ID__c = acc.Id;
        insert ct;
    Customer_Transition_Dtls__c details = Test_Utils.createCustomerTransDetails('Sites');
        details.Account_ID__c = acc2.Id;
        details.Bill_To_Account__c = acc2.Id;
        details.OMX_Primary_Key__c = '123456789';
        details.Customer_Transition_ID__c = ct.Id;
        
        insert details;
    
    CustTransParentChildLevel__c customSetting = new CustTransParentChildLevel__c();
      customSetting.Name = 'Parent';
      customSetting.SOA_EndPoint__c='xyz';
      customSetting.soa_user__c='xyz';
      insert customSetting;
  
     //run batch
    
     String strQuery = '';
        SentDNSProcessingBatch SentDNSProcessingBatchObj = new SentDNSProcessingBatch (strQuery);
        database.executebatch(SentDNSProcessingBatchObj, 99);
    

    List<CustTransParentChildLevel__c> PCLevel2 = [SELECT Mod5LaunchBulkBatchID__C,Mod5BulkLaunchBatchInterval__c FROM
      CustTransParentChildLevel__c];
    System.assert(PCLevel2.size() > 0);
      Test.stopTest();
  } 
}