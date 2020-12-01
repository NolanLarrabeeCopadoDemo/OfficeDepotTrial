/*************************************************************************************************************
Author       :   Jyoti Singh (Appirio Offshore)
Created Date :   May 19,2016
Story        :   S-410335
Description  :   Test Class for aceCustomerSKUChanges
**************************************************************************************************************/

@isTest
private class aceCustomerSKUChanges_TC 
{
    static testMethod void aceCustomerSKUChanges_method()
    {
        ACE_Settings__c desettings = new ACE_Settings__c();
        desettings.trigger_by_pass__c  = '';
        insert desettings;         
         
         
        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
         
        Product2 prod = new Product2();
        prod.Name = 'testProd';
        prod.SKUID__c='123456';
        prod.quntity_per_unit__c = 5.0;
        insert prod;
        
        Contact con = new contact(firstname='test',
                         lastname='lastname',
                         role__c = 'Price Change Approver',
                         email='test@test.com',
                         Accountid=acc.id);
                         
        insert con;
         
        ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
        insert ace1;
         
        Ace_Customer_Core_Changes__c CCCC = new Ace_Customer_Core_Changes__c();
        CCCC.ACE_Customer_Price_Changes__c=ace1.id;
        CCCC.CoreID__c='alpha';
        insert CCCC;
        
        ACE_Customer_MailOut__c mailout = new ACE_Customer_MailOut__c(name = '1234ddd',
                                     Email__c='test@testemail.com',
                                     contact__c = con.id,
                                     Email_Key__c='1234ddd', customer_core_price_changes__c =ace1.Id );
       insert mailout;
       update mailout;
         
         
        List<ACE_Customer_sku_Changes__c>  skuList = new List<ACE_Customer_sku_Changes__c>();
        ACE_Customer_sku_Changes__c sku1 = new ACE_Customer_sku_Changes__c(name='test',SKU__c='123456',Ace_Customer_Core_Changes__c = CCCC.id,Approval_status__c ='Pending',Alternate_Chosen_Flag__c = true,SKU_Alt__c = '123456',Price_Change_ID__c =ace1.Id );         
        skuList.add(sku1);        
        
        ACE_Customer_sku_Changes__c sku2 = new ACE_Customer_sku_Changes__c(name='test1',SKU__c='123456',Ace_Customer_Core_Changes__c = CCCC.id,Approval_status__c ='Pending',Alternate_Chosen_Flag__c = true,SKU_Alt__c = '123456',Price_Change_ID__c =ace1.Id );         
        skuList.add(sku2);
        
        ACE_Customer_sku_Changes__c sku3 = new ACE_Customer_sku_Changes__c(name='test1',SKU__c='123456',Ace_Customer_Core_Changes__c = CCCC.id,Approval_status__c ='Pending',Alternate_Chosen_Flag__c = true,SKU_Alt__c = '123456',Implementation_Status__c  = 'DATA-FAILED',Price_Change_ID__c =ace1.Id);         
        skuList.add(sku3);
        insert skuList;
        
        Test.startTest();
        sku1.Implementation_Status__c = 'DATA-FAILED';
        sku1.Sales_Price_Change_Effective_Date_Approv__c = date.today();
        sku1.status__c = 'Deleted';
        sku1.Approval_status__c = 'Approved';
        sku1.Approved_Proposed_Price__c = 10;
        update sku1;
        sku2.Implementation_Status__c = 'DATA-SUCCESS';
        sku2.Sales_Price_Change_Effective_Date_Approv__c = date.today();
        sku2.status__c = 'Deleted';
        sku2.Approval_status__c = 'Pending';
        sku2.Approved_Proposed_Price__c = 10;
        update sku2;
        Test.stopTest();
 
     }
     
}