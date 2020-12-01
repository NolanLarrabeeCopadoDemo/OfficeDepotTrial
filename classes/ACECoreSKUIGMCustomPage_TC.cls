@isTest
private class ACECoreSKUIGMCustomPage_TC 
{
    static testMethod void ACECoreIGMCustomPage_method(){

        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(short_title__c='BDM',TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        
        ACE_Settings__c ASE = new ACE_Settings__c();
         ASE.trigger_by_pass__c='qwerty';
         ASE.Level1Access__c = 'DSM';
         ASE.Level2Access__c = 'RSD';
         ASE.Level3Access__c = 'VP';
         insert ASE;
        
        List <ACE_Customer_Price_Changes__c> ACPC = new List<ACE_Customer_Price_Changes__c>();

         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(Sales_Price_Change_Effective_Date_Rep__c=Date.newInstance(1980, 10 ,20),name='test',Customer_Notification_Date_Approved__c=Date.newInstance(2013 , 10 ,20),Customer_Notification_Date__c=Date.newInstance(2013 , 12 ,20),Sales_Price_Change_Effective_Date_Approv__c=Date.newInstance(2013 , 12 ,20),OD_Revenue_Impact__c= 8989,Customer_Notification_Date_Rep__c=Date.newInstance(2012 , 10 ,20),SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=80000,Sales_Price_Change_Effective_Date_Min__c=Date.newInstance(2020 , 12 ,20),Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
         
        
         ACPC.add(ace1);
         insert ACPC ;
         
         Ace_Customer_Core_Changes__c CCCC = new Ace_Customer_Core_Changes__c();
         CCCC.ACE_Customer_Price_Changes__c=ace1.id;
         CCCC.CoreID__c='alpha';
         insert CCCC;
         
         Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',status__c='Active',batchId__c='abc',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
         Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = CCCC.id);
         insert ace3;
         
        system.runas(mgruser){
        ApexPages.currentPage().getParameters().Put('id',CCCC.id);
        ApexPages.StandardController con = new ApexPages.StandardController(CCCC);
        ACECoreIGMCustomPage controller = new ACECoreIGMCustomPage(con);
        
        ApexPages.currentPage().getParameters().Put('id',ace3.id);
        ApexPages.StandardController con2 = new ApexPages.StandardController(ace3);
        ACESKUIGMCustomPage controller2 = new ACESKUIGMCustomPage(con2);
        }
    }


}