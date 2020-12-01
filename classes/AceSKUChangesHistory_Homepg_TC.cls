@isTest
private class AceSKUChangesHistory_Homepg_TC 
{
    static testMethod void AceSKUChangesHistory_Homepg_method()
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
         
         ACE_Customer_sku_Changes__c sku1 = new ACE_Customer_sku_Changes__c(name='test',SKU__c='123456',Ace_Customer_Core_Changes__c = CCCC.id);
         insert sku1;
         AceSKUChangesHistory_Homepg controller = new AceSKUChangesHistory_Homepg(); 
         controller.generateList();
         
         Audit_History__c aHist1 = new Audit_History__c(name='test1',SKU__C=sku1.SKU__c,New_Approval_status__c='Pending'); 
         insert aHist1;
         controller.generateList();
         
         
         Audit_History__c aHist2 = new Audit_History__c(name='test1',SKU__C=sku1.SKU__c,New_Approval_status__c='Approved');
         insert aHist2;
         controller.generateList();
         
         Audit_History__c aHist3 = new Audit_History__c(name='test1',SKU__C=sku1.SKU__c,New_Approval_status__c='Rejected');
         insert aHist3;
         controller.generateList();
         
          Audit_History__c aHist4 = new Audit_History__c(name='test1',SKU__C=sku1.SKU__c,New_Approval_status__c='Modification');
         insert aHist4;
         controller.generateList();
         
         controller.nextPage();
         controller.prevPage();         
         controller.getDisablePrevious();         
         controller.getDisableNext();
 
     }
}