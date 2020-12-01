/**********************************************************
Class: ACEMailDelivery_TC
Author : Lalit M
Date:    05/31/2016
Details : To test ACEMailDelivery
***********************************************************/
@isTest
private class ACEMailDelivery_TC {

    static testMethod void myUnitTest() {
            Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
            insert acc;
             
            ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014');
            insert desettings; 
            
            Contact con = new contact(firstname='test',
                                     lastname='lastname',
                                     role__c = 'Price Change Approver',
                                     email='test@test.com',
                                     Accountid=acc.id);
                                     
            insert con;
            ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='1234ddd',
                                     SRM_Differential__c=5,
                                     Customer_Response__c='Approved',
                                     Item_12_Month_Qty__c = 50,
                                     Total_Spend_Impact_12_Month__c=5,
                                     Customer__c = acc.id, 
                                     Owning_Customer_ID__c ='123456', 
                                     SFDC_Notification_Flag__c = '3',
                                     Record_Unlock__c = true,
                                     SKU_Approval_Pending__c = true,
                                     Exception_Date_Lock__c = true,
                                     page_Key__c='pagekey1234');
            insert ace1;
            ACE_Customer_MailOut__c mailout = new ACE_Customer_MailOut__c(name = '1234ddd',
                                     Email__c='test@testemail.com',
                                     contact__c = con.id,
                                     Email_Key__c='1234ddd',
                                     Customer_Core_Price_Changes__c = ace1.id);
           insert mailout;
           
           mailout.bounced_flag__c = true;
           update mailout;  
           ace_customer_price_changes__c updatedPrice = [select id, Notification_Status_Code__c,Notification_Error__c from ace_customer_price_changes__c where id = :ace1.id limit 1];
           system.assertEquals(updatedPrice.Notification_Status_Code__c , 'NOTIFY-FAILED');
           system.assertEquals(updatedPrice.Notification_Error__c  , 'Email Delivery Bounced on all Contacts');    
    }
}