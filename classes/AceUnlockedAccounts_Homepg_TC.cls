@isTest
private class AceUnlockedAccounts_Homepg_TC 
{
    static testMethod void AceUnlockedAccounts_Homepg_method()
    {
         ACE_Settings__c desettings = new ACE_Settings__c();
         insert desettings; 
         
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
         insert acc;
         /*
          ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
         insert ace1;
         ApexPages.currentPage().getParameters().Put('id',ace1.id);
         Ace_Customer_Core_Changes__c CCCC = new Ace_Customer_Core_Changes__c();
         CCCC.ACE_Customer_Price_Changes__c=ace1.id;
         CCCC.CoreID__c='alpha';
         insert CCCC;
         
         
         
         ACE_Customer_sku_Changes__c sku1 = new ACE_Customer_sku_Changes__c(name='test',SKU__c='123456',Ace_Customer_Core_Changes__c = CCCC.id);
         insert sku1;
         */
         AceUnlockedAccounts_Homepg controller = new AceUnlockedAccounts_Homepg(); 
         
         ACE_Customer_Price_Changes__c ace11 = new ACE_Customer_Price_Changes__c(Owning_Customer_Legal__c='T',Reschduled_For_Reminder__c=true,name='test',SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
         insert ace11;
         controller.generateList();
         
         ACE_Customer_Price_Changes__c ace2 = new ACE_Customer_Price_Changes__c(Owning_Customer_Legal__c='L',Reschduled_For_Reminder__c=true,name='test',SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
         insert ace2;
         controller.generateList();
         
         ACE_Customer_Price_Changes__c ace3 = new ACE_Customer_Price_Changes__c(Owning_Customer_Legal__c='L',Reschduled_For_Reminder__c=false,name='test',SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
         insert ace3;
         controller.generateList();
         
         controller.nextPage();
         controller.prevPage();         
         controller.getDisablePrevious();         
         controller.getDisableNext();
 
     }
}