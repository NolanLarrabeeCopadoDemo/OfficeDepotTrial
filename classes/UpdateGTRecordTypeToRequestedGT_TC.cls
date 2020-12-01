@isTest
private class UpdateGTRecordTypeToRequestedGT_TC 
{

    static testMethod void myUnitTest() 
    {
   System.runAs(new user(ID = UserInfo.getUserID())){
   
    User u1 = GT_TestDataUtility.getTestUser('System Administrator','abc@officedepot.com.uat','612207');
 
    Account acc= new Account();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer   
        
        insert acc;
        
        
        
    Account acc2 = GT_TestDataUtility.getTestAccount(u1,'1234567');
ApexPages.currentPage().getParameters().Put('id',acc.id);
    String accountId = acc2.id;
    if(accountId !=null){
    UpdateGTRecordTypeToRequestedGTSite updateGT = new UpdateGTRecordTypeToRequestedGTSite();
 updateGT.updateRTGT();
 updateGT.UpdateGTRecordTypeToRequestedGTSite ();
 
    
        Account acc1= new Account();
        acc1.name = 'SUN Test Account';
        acc1.BillingStreet = '1040 N 326 W';
        acc1.billingcity = 'Orem';
        acc1.BillingState = 'UT';
        acc1.Billingcountry = 'USA';
        acc1.Oracle_Party_Id__c = '12345';
        acc1.AOPS_Cust_Id__c = '1234566';
        acc1.AOPS_Seq_ID__c = '1234568';
        acc1.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        acc1.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer   
   insert acc1;
        
acc.Oracle_Party_Id__c = '12345';
update acc1;
    }
    
    }
   } 
}