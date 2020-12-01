@isTest
private class ACEReporting_RevMarg_WF_Overview_TC 
{

    static testMethod void TestACEReporting_RevMarg_WaterFall_Overview() 
    {
        ACE_Batches__c aceBatch = new ACE_Batches__c();
        aceBatch.Name = 'Q4-2014';
        aceBatch.Batch__c = 'Q4-2014';
        
        insert aceBatch;
        
        Profile p = [select id from Profile where name='System Administrator' limit 1];
        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
             Insert user;
        
        system.runas(user){
        	Test.startTest();
        	ACE_User_Cust_Hierarchy_Controller_method();
        	ACEReporting_RevMarg_WaterFall_Overview aceRRWO = new ACEReporting_RevMarg_WaterFall_Overview();
        	//List<selectOption> options = aceRRWO.getQtrs();
        	Test.stopTest();
        }
        
    }
    
    
    static testMethod void ACE_User_Cust_Hierarchy_Controller_method()
    {
         ACE_Settings__c desettings = new ACE_Settings__c();
         insert desettings; 
         
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
         insert acc;                 
         
         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='Q4-2014',SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
         insert ace1;
         ApexPages.currentPage().getParameters().Put('id',ace1.id);
         Ace_Customer_Core_Changes__c CCCC = new Ace_Customer_Core_Changes__c();
         CCCC.ACE_Customer_Price_Changes__c=ace1.id;
         CCCC.CoreID__c='alpha';
         insert CCCC;
         
         
         
         ACE_Customer_sku_Changes__c sku1 = new ACE_Customer_sku_Changes__c(name='test',SKU__c='123456',Ace_Customer_Core_Changes__c = CCCC.id);
         insert sku1;
     }
}