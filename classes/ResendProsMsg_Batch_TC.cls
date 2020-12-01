@isTest
private class ResendProsMsg_Batch_TC
{
    static testMethod void resendProsMsg_Batch_Test()
    {
    Account testAcc = new Account();
    testAcc.Name='Test';
    testAcc.AOPS_Cust_Id__c ='123456';
    testAcc.OMX_Primary_Key__c='123456';
    insert testAcc;
    
    // Prospect_Message__c Test record
    Prospect_Message__c pmRecord = new Prospect_Message__c();
    pmRecord.Account__c = testAcc.id;
    pmRecord.Message_Complete__c = 'NP';
    insert pmRecord;
    
    // CustTransParentChildLevel__c Custom Setting record
    CustTransParentChildLevel__c custSettingRecord = new CustTransParentChildLevel__c();
    custSettingRecord.name = 'Parent';
    insert custSettingRecord;
    
    //Calling Batch Class
    String strQuery = '';
    ResendProsMsg_Batch resendProsMsgBatch = new ResendProsMsg_Batch();
    database.executebatch(resendProsMsgBatch, 10);
    
    }
    static testMethod void resendProsMsg_Batch_Test1()
    {
        try{
            Account testAcc1 = new Account();
    testAcc1.Name='Test1';
    testAcc1.AOPS_Cust_Id__c ='1234561';
    testAcc1.OMX_Primary_Key__c='1234561';
    testAcc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
    insert testAcc1;
    Account testAcc = new Account();
    testAcc.Name='Test';
    testAcc.AOPS_Cust_Id__c ='123456';
    testAcc.OMX_Primary_Key__c='123456';
    testAcc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        testAcc.Related_Account__c = testAcc1.id;
    insert testAcc;
    
    // Prospect_Message__c Test record
    Prospect_Message__c pmRecord = new Prospect_Message__c();
    pmRecord.Account__c = testAcc.id;
    pmRecord.Message_Complete__c = 'NP';
    insert pmRecord;
    
    // CustTransParentChildLevel__c Custom Setting record
    CustTransParentChildLevel__c custSettingRecord = new CustTransParentChildLevel__c();
    custSettingRecord.name = 'Parent';
    insert custSettingRecord;
    
    //Calling Batch Class
    String strQuery = '';
    ResendProsMsg_Batch resendProsMsgBatch = new ResendProsMsg_Batch();
    database.executebatch(resendProsMsgBatch, 10);
        }catch(exception e){}
        
    
    }
   
}