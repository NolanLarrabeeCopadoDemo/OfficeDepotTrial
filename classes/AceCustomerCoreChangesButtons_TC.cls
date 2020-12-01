@isTest
private class AceCustomerCoreChangesButtons_TC 
{
    static testMethod void AceCustomerCoreChangesButtons_method()
    {
         ACE_Settings__c desettings = new ACE_Settings__c();
         insert desettings; 
         
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
         insert acc;
         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
         insert ace1;
         
         ApexPages.currentPage().getParameters().Put('id',ace1.id);
         Ace_Customer_Core_Changes__c CCCC = new Ace_Customer_Core_Changes__c();
         CCCC.ACE_Customer_Price_Changes__c=ace1.id;
         CCCC.CoreID__c='alpha';
         insert CCCC;
         
         ApexPages.StandardController con = new ApexPages.StandardController(CCCC);
         AceCustomerCoreChangesButtons controller = new AceCustomerCoreChangesButtons(con); 
         
         controller.summaryGridRedirect();
         controller.customerPriceRedirect();
     
     }
 }