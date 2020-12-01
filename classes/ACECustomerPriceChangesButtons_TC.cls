@isTest
private class ACECustomerPriceChangesButtons_TC 
{
    static testMethod void ACECustomerPriceChangesButtons_method()
    {
         ACE_Settings__c desettings = new ACE_Settings__c();
         insert desettings; 
         
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
         insert acc;
          ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
         insert ace1;
          ACE_Customer_Price_Changes__c ace2 = new ACE_Customer_Price_Changes__c(name='test',Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3', Remedy_Status__c = null, L1_Mgr_Approval_Start_Date__c = null, Remediation_Request_User__c = null);
          insert ace2;
         ApexPages.currentPage().getParameters().Put('id',ace1.id);
         Ace_Customer_Core_Changes__c CCCC = new Ace_Customer_Core_Changes__c();
         CCCC.ACE_Customer_Price_Changes__c=ace1.id;
         CCCC.CoreID__c='alpha';
         insert CCCC;
         ApexPages.StandardController con = new ApexPages.StandardController(ace1);
         ACECustomerPriceChangesButtons controller = new ACECustomerPriceChangesButtons(con); 
         ApexPages.StandardController con2 = new ApexPages.StandardController(ace2);
         controller.ownerCheck();
         controller.defaultRendering(true);
         controller.defaultRendering(false);
         controller.reLock();
         controller.releaseButton();
         controller.ReqRemediation();
         controller.CancelRemediation();
         controller.allowremediation = true;
         controller.cancelremediation = true;
         controller.DateExceptionButton();
         controller.customerNotificationButton();
         controller.customerResponseButton();
         controller.summaryGridRedirect();
         controller.exportSKU();
         controller.triggerApproval();
         controller.AceAccess();
         controller.aceCustomerPriceChangesID = null;
         controller.custRec = null;
         controller.Comments = 'test';
         controller.renderMap = null;
    }
    static testMethod void ACECustomerPriceChangesButtons_method2()
    {
         ACE_Settings__c desettings = new ACE_Settings__c();
         insert desettings; 
         
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
         insert acc;
          ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3',isRemediation__c = true);
         insert ace1;
          ACE_Customer_Price_Changes__c ace2 = new ACE_Customer_Price_Changes__c(name='test',Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3', Remedy_Status__c = null, L1_Mgr_Approval_Start_Date__c = null, Remediation_Request_User__c = null);
          insert ace2;
         ApexPages.currentPage().getParameters().Put('id',ace1.id);
         Ace_Customer_Core_Changes__c CCCC = new Ace_Customer_Core_Changes__c();
         CCCC.ACE_Customer_Price_Changes__c=ace1.id;
         CCCC.CoreID__c='alpha';
         insert CCCC;
         ApexPages.StandardController con = new ApexPages.StandardController(ace1);
         ACECustomerPriceChangesButtons controller = new ACECustomerPriceChangesButtons(con); 
         ApexPages.StandardController con2 = new ApexPages.StandardController(ace2);
         controller.ownerCheck();
         controller.defaultRendering(true);
         controller.defaultRendering(false);
         controller.reLock();
         controller.releaseButton();
         controller.ReqRemediation();
         controller.CancelRemediation();
         controller.allowremediation = true;
         controller.cancelremediation = true;
         controller.DateExceptionButton();
         controller.customerNotificationButton();
         controller.customerResponseButton();
         controller.summaryGridRedirect();
         controller.exportSKU();
         controller.triggerApproval();
         controller.AceAccess();
         controller.aceCustomerPriceChangesID = null;
         controller.custRec = null;
         controller.Comments = 'test';
         controller.renderMap = null;
    }
}