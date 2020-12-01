/**
 * Created by Najma Ateeq for Story #S-331356
 */
@isTest
private class AccountHeaderAccess_Batch_TC {

    static testMethod void myUnitTest() {
    	createTestData();
    	Test.StartTest();
       	 AccountHeaderAccess_Batch sh1 = new  AccountHeaderAccess_Batch();      
 String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
      Test.stopTest();
    	
    }
    static testMethod void myUnitTest1() {
    	createTestData();
    	Test.StartTest();
       	 AccountHeaderAccess_Batch sh1 = new  AccountHeaderAccess_Batch();      
 		database.executeBatch(sh1);
      Test.stopTest();
    	
    }
    public static void createTestData(){
    	Map<String,Schema.RecordTypeInfo> AccRecType = Schema.SObjectType.Account.getRecordTypeInfosByName();
        User u2=[SELECT id,ProfileId,OD_Employee_ID__c,TimeZoneSidKey FROM User WHERE id =:UserInfo.getUserId()];
        
        User u = new user(Username='test_test1@acme.com',FirstName ='test123', LastName='xyz123', Alias='a', CommunityNickname='aa', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId=u2.ProfileId, LanguageLocaleKey='en_US');
        u.email='aaabc@officedepot.com';
        u.MB_Expiration_Date__c = System.now().addminutes(1);
        u.OD_Employee_ID__c ='622207';
        u.IsActive=true;
        u.TimeZoneSidKey=u2.TimeZoneSidKey;
        u.Token_Market_Builder__c ='abc';
        Insert u;
        
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.RecordtypeId = AccRecType.get('Site').getRecordTypeId();
        acc.AOPS_Seq_ID__c = '123456';
       // acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        //acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        System.runAs(u){
        insert acc;
        }
        
        Account acc1 = new Account ();
        acc1.name = 'SUN Test Account 1';
        acc1.BillingStreet = '1040 N 326 W';
        acc1.billingcity = 'Orem';
        acc1.BillingState = 'UT';
        acc1.Billingcountry = 'USA';
        acc1.Oracle_Party_Id__c = '1234561';
        acc1.AOPS_Cust_Id__c = '1234561';
        acc1.RecordtypeId = AccRecType.get('Site').getRecordTypeId();
        acc1.AOPS_Seq_ID__c = '1234561';
        acc1.Related_Account__c = acc.Id;
        acc1.Header_Record_Access__c = false;
       // acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        //acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        insert acc1;
        
        Admin_Config__c cn = new Admin_Config__c();
        cn.Ownership_Changes_Batch__c = '2';
        cn.name = 'Default';
        cn.BatchSize__c = '3';
        insert cn;
    	
    }
}