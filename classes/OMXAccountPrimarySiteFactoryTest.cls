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
private class OMXAccountPrimarySiteFactoryTest {

    private static Map<String,Schema.RecordTypeInfo> rtMapByName = Schema.SObjectType.Account.getRecordTypeInfosByName();
    public static final string OMX_RECORD_TYPE_NAME_CUSTOMER = 'Customer (OfficeMax)';  
    public static final string OMX_RECORD_TYPE_NAME_SITE = 'Site (OfficeMax)'; 

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        //Setup Test Cases
        Id omxRecordTypeIdCustomer = getRecordTypeId(OMX_RECORD_TYPE_NAME_CUSTOMER );
        //Id omxRecordTypeIdSite = getRecordTypeId(OMX_RECORD_TYPE_NAME_SITE );
        
        List<Account> accountsToInsert = new List<Account>();
        List<Account> accountsToupdate = new List<Account>();
            
        Account testAccount1 = new Account();
        testAccount1.Name = 'Test Account1';
        testAccount1.RecordTypeId = omxRecordTypeIdCustomer ;
        testAccount1.OMX_Mainframe_Account_Level__c = 'Main Account';
        testAccount1.Address1__c = 'My Street';
        testAccount1.State__c = 'IL';
        testAccount1.Type =  'Site';
        testAccount1.OMX_Primary_Key__c = 'Test_OMX_1114'; //S-367255 [12/10/2015]- Fix test class
        accountsToInsert.add(testAccount1);
/*
        Account testAccount2 = new Account();
        testAccount2.Name = 'Test Account2';
        testAccount2.RecordTypeId = omxRecordTypeIdCustomer ;
        testAccount2.OMX_Mainframe_Account_Level__c = 'Main Account';
        testAccount2.Address1__c = 'My Street';
        testAccount2.State__c = 'IL';
        testAccount2.Type =  'Site';
    
        accountsToInsert.add(testAccount2);
  */  

        //Run Test that will invoke the trigger
        Test.startTest();
    //test insert trigger
        insert accountsToInsert;
    //test update tringger
    testAccount1.Name = 'change me';
    accountsToupdate.add(testAccount1); 
    update accountsToupdate;
    
        Test.stopTest();

        //Validate Test
        System.assertEquals(testAccount1.Name, 'change me');
    }
    
  /***********************************Utils Method************************************************************************/
  
  //================================================================================//
  //Get Record Type Id from record Type Name
  //================================================================================//
  public static  Id getRecordTypeId(String recordTypeName) {
    RecordTypeInfo siteRecordType = rtMapByName.get(recordTypeName); 
    if(siteRecordType == null) return null;
    
    return siteRecordType.getRecordTypeId();
  }    
}