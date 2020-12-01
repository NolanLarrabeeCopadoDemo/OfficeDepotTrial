@isTest
private class AceCustomerSKUChangesButtons_TC 
{
    static testMethod void AceCustomerSKUChangesButtons_method()
    {
         ACE_Settings__c desettings = new ACE_Settings__c();
         insert desettings; 
         
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
         insert acc;
          ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
         insert ace1;
         ApexPages.currentPage().getParameters().Put('id',ace1.id);
         Ace_Customer_Core_Changes__c CCCC = new Ace_Customer_Core_Changes__c();
         CCCC.ACE_Customer_Price_Changes__c=ace1.id;
         CCCC.CoreID__c='alpha';
         insert CCCC;
         
         ACE_Customer_sku_Changes__c sku1 = new ACE_Customer_sku_Changes__c(name='test',SKU__c='123456',Ace_Customer_Core_Changes__c = CCCC.id,Approval_status__c ='Pending');
         insert sku1;
        
         ApexPages.StandardController con = new ApexPages.StandardController(sku1);
         AceCustomerSKUChangesButtons controller = new AceCustomerSKUChangesButtons(con); 
         controller.defaultRendering(true);
         controller.summaryGridRedirect();
         controller.customerPriceRedirect();         
         controller.corePriceRedirect();         
         controller.ownerCheck();
         controller.PriceeExceptionButton();
 
     }
     static testMethod void AceCustomerSKUChangesButtons_method1()
    {
         ACE_Settings__c desettings = new ACE_Settings__c();
         insert desettings; 
         
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem', Rolling_12_month_sales__c = 74000.00);
         insert acc;
         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '1');
         insert ace1;
         
         ApexPages.currentPage().getParameters().Put('id',ace1.id);
         Ace_Customer_Core_Changes__c CCCC = new Ace_Customer_Core_Changes__c();
         CCCC.ACE_Customer_Price_Changes__c=ace1.id;
         CCCC.CoreID__c='alpha';
         insert CCCC;
         
         ACE_Customer_sku_Changes__c sku1 = new ACE_Customer_sku_Changes__c(name='test',SKU__c='123456',Ace_Customer_Core_Changes__c = CCCC.id);
         insert sku1;
        
         ApexPages.StandardController con = new ApexPages.StandardController(sku1);
         AceCustomerSKUChangesButtons controller = new AceCustomerSKUChangesButtons(con); 
         controller.defaultRendering(true);
         controller.summaryGridRedirect();
         controller.customerPriceRedirect();         
         controller.corePriceRedirect();         
         controller.ownerCheck();
         controller.PriceeExceptionButton();
 
     }
     static testMethod void AceCustomerSKUChangesButtons_method2()
    {
         ACE_Settings__c desettings = new ACE_Settings__c();
         insert desettings; 
         
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem', Rolling_9_month_sales__c = 55500.00);
         insert acc;
         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '1');
         insert ace1;
         
         ApexPages.currentPage().getParameters().Put('id',ace1.id);
         Ace_Customer_Core_Changes__c CCCC = new Ace_Customer_Core_Changes__c();
         CCCC.ACE_Customer_Price_Changes__c=ace1.id;
         CCCC.CoreID__c='alpha';
         insert CCCC;
         
         ACE_Customer_sku_Changes__c sku1 = new ACE_Customer_sku_Changes__c(name='test',SKU__c='123456',Ace_Customer_Core_Changes__c = CCCC.id);
         insert sku1;
        
         ApexPages.StandardController con = new ApexPages.StandardController(sku1);
         AceCustomerSKUChangesButtons controller = new AceCustomerSKUChangesButtons(con); 
         controller.defaultRendering(true);
         controller.summaryGridRedirect();
         controller.customerPriceRedirect();         
         controller.corePriceRedirect();         
         controller.ownerCheck();
         controller.PriceeExceptionButton();
 
     }
     static testMethod void AceCustomerSKUChangesButtons_method3()
    {
         ACE_Settings__c desettings = new ACE_Settings__c();
         insert desettings; 
         
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem', Rolling_6_month_sales__c= 37000.00);
         insert acc;
         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '1');
         insert ace1;
         
         ApexPages.currentPage().getParameters().Put('id',ace1.id);
         Ace_Customer_Core_Changes__c CCCC = new Ace_Customer_Core_Changes__c();
         CCCC.ACE_Customer_Price_Changes__c=ace1.id;
         CCCC.CoreID__c='alpha';
         insert CCCC;
         
         ACE_Customer_sku_Changes__c sku1 = new ACE_Customer_sku_Changes__c(name='test',SKU__c='123456',Ace_Customer_Core_Changes__c = CCCC.id);
         insert sku1;
        
         ApexPages.StandardController con = new ApexPages.StandardController(sku1);
         AceCustomerSKUChangesButtons controller = new AceCustomerSKUChangesButtons(con); 
         controller.defaultRendering(true);
         controller.summaryGridRedirect();
         controller.customerPriceRedirect();         
         controller.corePriceRedirect();         
         controller.ownerCheck();
         controller.PriceeExceptionButton();
 
     }
     static testMethod void AceCustomerSKUChangesButtons_method4()
    {
         ACE_Settings__c desettings = new ACE_Settings__c();
         insert desettings; 
         
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem', Rolling_3_month_sales__c= 18500.00);
         insert acc;
         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '1');
         insert ace1;
         
         ApexPages.currentPage().getParameters().Put('id',ace1.id);
         Ace_Customer_Core_Changes__c CCCC = new Ace_Customer_Core_Changes__c();
         CCCC.ACE_Customer_Price_Changes__c=ace1.id;
         CCCC.CoreID__c='alpha';
         insert CCCC;
         
         ACE_Customer_sku_Changes__c sku1 = new ACE_Customer_sku_Changes__c(name='test',SKU__c='123456',Ace_Customer_Core_Changes__c = CCCC.id);
         insert sku1;
        
         ApexPages.StandardController con = new ApexPages.StandardController(sku1);
         AceCustomerSKUChangesButtons controller = new AceCustomerSKUChangesButtons(con); 
         controller.defaultRendering(true);
         controller.summaryGridRedirect();
         controller.customerPriceRedirect();         
         controller.corePriceRedirect();         
         controller.ownerCheck();
         controller.PriceeExceptionButton();
 
     }
}