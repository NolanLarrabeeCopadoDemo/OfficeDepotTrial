@isTest
private class CleanProsMsg_Batch_TC
{
    static testMethod void cleanProsMsg_Batch_Test1()
    {
    //Account Test record
    Account testAcc = new Account();
    testAcc.Name='Test';
    testAcc.AOPS_Cust_Id__c ='123456';
    testAcc.OMX_Primary_Key__c='123456';
    insert testAcc;
    
    //Prospect_Message__c Test record
    Prospect_Message__c pmRecord = new Prospect_Message__c();
    pmRecord.Account__c = testAcc.id;
    pmRecord.Message_Complete__c = 'NP';
    insert pmRecord;
   
    //Calling Batch Class
    CleanProsMsg_Batch cleanProsMsgBatchObj = new CleanProsMsg_Batch();
    database.executebatch(cleanProsMsgBatchObj, 10);   
    }
    
    static testMethod void cleanProsMsg_Batch_Test2()
    {
    //Account Test record
    Account testAcc = new Account();
    testAcc.Name='Test';
    testAcc.AOPS_Cust_Id__c ='123456';
    testAcc.OMX_Primary_Key__c='123456';
    insert testAcc;
    
    //Prospect_Message__c Test record
    Prospect_Message__c pmRecord = new Prospect_Message__c();
    pmRecord.Account__c = testAcc.id;
    pmRecord.Message_Complete__c = 'NP';
    insert pmRecord;
   
    //Calling Batch Class
    String strQuery = 'select id,createddate from Prospect_Message__c where createddate <= :todayDate';
    CleanProsMsg_Batch cleanProsMsgBatchObj = new CleanProsMsg_Batch(strQuery);
    database.executebatch(cleanProsMsgBatchObj, 10);   
    }
}