/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class OMXAccountClearOutSales_TC {

    //Record Types via Map
    private static Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Account.getRecordTypeInfosByName();
    public static final string OMX_RECORD_TYPE_NAME_CUSTOMER = 'Customer (OfficeMax)';  
    public static final string ODP_RECORD_TYPE_NAME_CUSTOMER = 'Customer';  
    public static final string OMX_RECORD_TYPE_NAME_SITE = 'Site (OfficeMax)';  

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Id omxRecordTypeIdCustomer = getRecordTypeId(OMX_RECORD_TYPE_NAME_CUSTOMER );
        Account acc = new Account ();
        acc.name = 'Test OMX Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.RecordTypeId = omxRecordTypeIdCustomer;
        acc.OMX_Primary_Key__c = 'test123abcde';
        acc.MTD_Sales_TY__c = 123456;
        acc.QTD_Sales_TY__c = 123456;
        acc.YTD_Sales_TY__c = 123456;
        insert acc;
 
        Id odpRecordTypeIdCustomer = getRecordTypeId(ODP_RECORD_TYPE_NAME_CUSTOMER );
        Account acc2 = new Account ();
        acc2.name = 'Test ODP Account';
        acc2.BillingStreet = '1040 N 326 W';
        acc2.billingcity = 'Orem';
        acc2.BillingState = 'UT';
        acc2.Billingcountry = 'USA';
        acc2.RecordTypeId = odpRecordTypeIdCustomer;
        acc2.OMX_Primary_Key__c = 'test456';
        acc2.MTD_Sales_TY__c = 123456;
        acc2.QTD_Sales_TY__c = 123456;
        acc2.YTD_Sales_TY__c = 123456;
        insert acc2;
      
        Datetime dt = System.now();
        String scheduleString='0';
        scheduleString+=' '+ dt.minute();
        scheduleString+=' '+ dt.hour();
        scheduleString+=' '+ dt.day();
        scheduleString+=' '+ dt.month();
        scheduleString+=' ?';
        scheduleString+=' '+ dt.year();     
        System.debug('currently scheduled.' + scheduleString); 

        String CRON_EXP = '0 0 0 3 9 ? 2022';    
       
        Test.startTest();
        
        OMXAccountClearOutSales batchJob = new OMXAccountClearOutSales('YTD');
        database.executebatch(batchJob);
        System.schedule('Assignment Batch',CRON_EXP, batchJob);
        Test.stopTest();
        
        //first test the OMX account
        string theKey = acc.OMX_Primary_Key__c;
        string myquery = 'Select MTD_Sales_TY__c from Account where omx_primary_key__c = :theKey';
        List<Account> myResult = Database.query(myquery);
        
        if (myResult.size() == 1) {
            System.debug('********** ASSERT OMX db value: ' + myResult[0].MTD_Sales_TY__c + ' *****************');
        }
        System.assert(myResult[0].MTD_Sales_TY__c == null);
        
        //then test the DEPOT account
        theKey = acc2.OMX_Primary_Key__c;
        List<Account> myResult2 = Database.query(myquery);
        
        if (myResult2.size() == 1) {
            System.debug('********** ASSERT DEPOT db value: ' + myResult2[0].MTD_Sales_TY__c + ' *****************');
        }
        System.assert(myResult2[0].MTD_Sales_TY__c == 123456);

    }

    static testMethod void myUnitTest1() {
        // TO DO: implement unit test
        Id omxRecordTypeIdCustomer = getRecordTypeId(OMX_RECORD_TYPE_NAME_CUSTOMER );
        Account acc = new Account ();
        acc.name = 'Test OMX Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.RecordTypeId = omxRecordTypeIdCustomer;
        acc.OMX_Primary_Key__c = 'test123abcde';
        acc.MTD_Sales_TY__c = 123456;
        acc.QTD_Sales_TY__c = 123456;
        acc.YTD_Sales_TY__c = 123456;
        insert acc;
 
        Id odpRecordTypeIdCustomer = getRecordTypeId(ODP_RECORD_TYPE_NAME_CUSTOMER );
        Account acc2 = new Account ();
        acc2.name = 'Test ODP Account';
        acc2.BillingStreet = '1040 N 326 W';
        acc2.billingcity = 'Orem';
        acc2.BillingState = 'UT';
        acc2.Billingcountry = 'USA';
        acc2.RecordTypeId = odpRecordTypeIdCustomer;
        acc2.OMX_Primary_Key__c = 'test456';
        acc2.MTD_Sales_TY__c = 123456;
        acc2.QTD_Sales_TY__c = 123456;
        acc2.YTD_Sales_TY__c = 123456;
        insert acc2;
      
        Datetime dt = System.now();
        String scheduleString='0';
        scheduleString+=' '+ dt.minute();
        scheduleString+=' '+ dt.hour();
        scheduleString+=' '+ dt.day();
        scheduleString+=' '+ dt.month();
        scheduleString+=' ?';
        scheduleString+=' '+ dt.year();     
        System.debug('currently scheduled.' + scheduleString); 

        String CRON_EXP = '0 0 0 3 9 ? 2022';    
       
        Test.startTest();
        
        OMXAccountClearOutSales batchJob = new OMXAccountClearOutSales('MTD');
        database.executebatch(batchJob);
        System.schedule('Assignment Batch',CRON_EXP, batchJob);
        Test.stopTest();
        
        //first test the OMX account
        string theKey = acc.OMX_Primary_Key__c;
        string myquery = 'Select MTD_Sales_TY__c from Account where omx_primary_key__c = :theKey';
        List<Account> myResult = Database.query(myquery);
        
        if (myResult.size() == 1) {
            System.debug('********** ASSERT OMX db value: ' + myResult[0].MTD_Sales_TY__c + ' *****************');
        }
        System.assert(myResult[0].MTD_Sales_TY__c == null);
        
        //then test the DEPOT account
        theKey = acc2.OMX_Primary_Key__c;
        List<Account> myResult2 = Database.query(myquery);
        
        if (myResult2.size() == 1) {
            System.debug('********** ASSERT DEPOT db value: ' + myResult2[0].MTD_Sales_TY__c + ' *****************');
        }
        System.assert(myResult2[0].MTD_Sales_TY__c == 123456);

    }
  //================================================================================//
  //Get Record Type Id from record Type Name
  //================================================================================//
  public static  Id getRecordTypeId(String recordTypeName) {
    RecordTypeInfo siteRecordType = rtMapByName.get(recordTypeName); 
    if(siteRecordType == null) return null;
    
    return siteRecordType.getRecordTypeId();
  }  

}