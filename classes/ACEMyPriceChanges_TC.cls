@isTest
private class ACEMyPriceChanges_TC 
{

static testMethod void ACEMyPriceChanges_method(){
  
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
 system.debug('@@@@'+ace1);
 insert ace1;
  
 Ace_Customer_Core_Changes__c CCCC = new Ace_Customer_Core_Changes__c();
 CCCC.ACE_Customer_Price_Changes__c=ace1.id;
 CCCC.CoreID__c='alpha';
 insert CCCC;

   ACE_Customer_MailOut__c mailout = new ACE_Customer_MailOut__c(name = '1234ddd',
                                     Email__c='test@testemail.com',
                                     contact__c = con.id,
                                     Email_Key__c='1234ddd');
   insert mailout;
   update mailout;   
 
 ApexPages.currentPage().getParameters().Put('pkey','pagekey1234');
 ApexPages.currentPage().getParameters().Put('ekey','1234ddd');
 ACEMyPriceChanges AMPC = new ACEMyPriceChanges ();
   AMPC.sortCust();
   AMPC.Refresh_rec();
   AMPC.skuDownload();
   AMPC.getDisablePrevious();
   AMPC.getDisableNext();
   AMPC.nextPage();
   AMPC.prevPage();
   AMPC.displayHighlighted = true;
   AMPC.searchText  = '1234';
   AMPC.getSKURecords();
   AMPC.AppRec();
   AMPC.RejRec();
   AMPC.searchText  = '';
   AMPC.getSKURecords();   
   AMPC.getFieldName = 'Approved_Proposed_Price__c';
   AMPC.sortCust();
   AMPC.getFieldName = 'Alt_Sell_Price__c';
   AMPC.sortCust();
   AMPC.getFieldName = 'Current_Sell_Price__c';
   AMPC.sortCust();
   AMPC.getFieldName = 'Item_12_Month_Sales__c';
   AMPC.sortCust();
   AMPC.getFieldName = 'Item_12_Month_Qty__c';
   AMPC.sortCust();
   AMPC.getFieldName = 'Alt_UOM__c';
   AMPC.sortCust();
   AMPC.getFieldName = 'UOM__c';
   AMPC.sortCust();
   AMPC.getFieldName = 'Alt_SKU_Description__c';
   AMPC.sortCust();
   AMPC.getFieldName = 'SKU_Description__c';
   AMPC.sortCust();
   AMPC.getFieldName = 'Alt_SKU__c';
   AMPC.sortCust();
   AMPC.getFieldName = 'SKU__c';
   AMPC.sortCust();
 }
}