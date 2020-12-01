/******************************************************
* Name : Mod5InsertCntcBatchV3_TC
* Created By : Alka Taneja
* Created Date : 16 June, 2016
* Story : S-418600 (00715635)
/******************************************************/
@isTest(seeAllData=false)
public class Mod5InsertCntcBatchV3_TC{

    public static Split_Account_Detail__c eachCTdtls;
    public static Customer_Transition__c ct;
    public static Account acc;
    public static Contact c1;
    
    public static testMethod void TestActvityCreation() {
        
        Test.startTest();
        
        createTestData();
        
        Mod5InsertCntcBatchV3 ob = new Mod5InsertCntcBatchV3();
        Database.executeBatch(ob, 200);
        
        Test.stopTest();
    }
    
    public static void createTestData() {
    
      // Create sample data
      CustTransParentChildLevel__c custPCLevel = new CustTransParentChildLevel__c();
      custPCLevel.name = 'Parent_Child';
      custPCLevel.SOA_EndPoint__c = 'https://osbuat01.officedepot.com/';
      custPCLevel.soa_user__c = 'SVC-SFDCWS:SVC4sfd3';
      insert custPCLevel;
      
      acc = Test_Utils.createAccount('Customer (OfficeMax)');
      acc.Split_Record__c = true;
      insert acc;
      acc.OMX_Primary_Key__c = acc.Id;
      update acc;
      
      c1 = new Contact();
      c1.LastName='LastNametest1';
      c1.email='testemail1@test.com';
      c1.AccountId = acc.id;
      c1.firstname='first';
      c1.OMX_primary_key__c='1234';
      c1.title = 'Manager';
      c1.Primary_Contact__c = true;
      insert c1;
      
      ct = Test_Utils.createCustomerTransaction(false, acc);
      ct.MOD5_Ready_To_Launch__c = true;
      ct.Ready_for_Mod1__c = false;
      ct.Name = 'Customer Transition Parent of TestAccount';
      ct.BulkSplit__c = true;
      ct.OMX_Primary_Key__c = acc.Id + '-1';
      ct.Status__c = 'Scheduled';
      ct.Mod5TriggerContact__c = true;
      ct.Split_Launching_Status__c = 'Success';
      ct.account__c = acc.id;
      insert ct;
      
      eachCTdtls = new Split_Account_Detail__c();
      eachCTdtls.status__c='';
      eachCTdtls.Master_Account__c ='123458-01';
      eachCTdtls.Customer_Transition__c =ct.id;
      eachCTdtls.AP_CONTACT_FIRST_NAME__c ='First';
      eachCTdtls.AP_CONTACT_LAST_NAME__c ='Last';
      eachCTdtls.NEW_BILLING_TYPE_AT_HEADER_LEVEL__c ='Di';
      eachCTdtls.Original_Account__c = acc.id;
      eachCTdtls.AP_CONTACT_TELEPHONE__c ='12345698789';
      eachCTdtls.NEW_BILL_TO_OMX_CONSIGNEE__c = '123456';
      eachCTdtls.NEW_MAIN_ACCT_ADDRESS__c = '123456';
      eachCTdtls.Main_Account_Name__c ='New Name';  
      eachCTdtls.Linked_Customer_Transition__c = ct.id;
      eachCTdtls.ContactsAdded__c = false;
      insert eachCTdtls;
      
    }
}