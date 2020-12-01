@isTest
public class Test_AccountServiceDataDelete_Batch {
public testmethod static void testAccountServiceDataDelete(){
    Test.startTest();
    Account_Service_Data__c  custRec= new   Account_Service_Data__c (); 
        custRec.CREATE_UPDATE_FLAG__C='C';
        custRec.CONTRACT_RETAIL_CUST_CODE__C='C';
        custRec.BUSINESS_NAME__C='DID INC GSA ?';
        custRec.CUSTOMER_DELETE_FLAG__C='Active';
        custRec.CUSTOMER_TYPE__C='RG';
        custRec.FREIGHT_CHARGE_REQUIRED__C='N';
        custRec.SEGMENTATION__C='Federal';
        custRec.SECTOR__C='Public';
        custRec.ORDER_MAX_AMOUNT__C='0';
        custRec.REP__C='C502007';
        custRec.EMP_ID__C='175050';
        custRec.HOSTED_CATALOG_FLAG__c='N';
        custRec.Legal_Flag__C='N';
        custRec.Account_Type__c='Customer';
        custRec.Batch_Processed__c	= true;
        custRec.ORACLE_CUSTOMER_ID__C = '346105743';
        custRec.AOPS_CUSTOMER_ID__c = '90254922';
        custRec.SPC_Indicator__c = 'Y';
        custRec.Status__c = 'SUCCESS';
       insert custRec;
    String sch = '0 0 23 * * ?'; 
    system.schedule('Success -Account Service Data Delete', sch, new AccountServiceDataDelete_Batch());
    Test.stopTest();
}
}