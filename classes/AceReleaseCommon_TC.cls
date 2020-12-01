/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AceReleaseCommon_TC 
{

 static testMethod void AceReleaseCommon_testmethod() 
 {

 List<Ace_Customer_SKU_Changes__c > lst_sku = new List<Ace_Customer_SKU_Changes__c >();
 
 ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q2-2014');
 insert desettings; 

 Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
 insert acc;
 
 ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='test',customer_notification_date_Rep__c=system.today(),SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456');
 insert ace1;

 Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name='test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
 insert ace2;

 Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
 Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id);
 insert ace3;

 Ace_Customer_SKU_Changes__c ace4 = new Ace_Customer_SKU_Changes__c(SKU__c = '123556',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_3_Month_Sales__c=12.12,Item_6_Month_Sales__c=12.12,
 Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12,name='test', Ace_Customer_Core_Changes__c = ace2.id);
 lst_sku.add(ace4);

 Ace_Customer_SKU_Changes__c ace5 = new Ace_Customer_SKU_Changes__c(SKU__c = '124456',Item_3_Month_Qty__c=12.12,Item_6_Month_Qty__c=12.12,Item_9_Month_Qty__c=12.12,Item_6_Month_Sales__c=12.12,Item_3_Month_Sales__c=12.12,
 Item_9_Month_Sales__c=12.12,Total_Spend_Impact_3_Month__c=12.12,Total_Spend_Impact_6_Month__c=12.12,Total_Spend_Impact_9_Month__c=12.12,name='test',Item_12_Month_Qty__c = 50,Item_12_Month_Sales__c=12.12,Total_Spend_Impact_12_Month__c=123.12, Ace_Customer_Core_Changes__c = ace2.id);
 lst_sku.add(ace5);
 
 insert lst_sku;
 
 AceReleaseCommon controller = new AceReleaseCommon();
 AceReleaseCommon.releaseResponse innercont = new AceReleaseCommon.releaseResponse();
 AceReleaseCommon.releaseRequest innercont1 = new AceReleaseCommon.releaseRequest();
 //controller.Notify(Set<releaseRequest> notifications);
 //controller.Release(Set<releaseRequest> req);
 //controller.ReleaseAllowed(ace1 , ace1.customer_notification_date_Rep__c);
 
  //START S-420971 (OD 00731422) [Hemant 6/30/2016] - Increase code coverage
  ACE_Customer_Price_Changes__c ace11 = new ACE_Customer_Price_Changes__c(name='test', Sales_Price_Change_Effective_Date_Rep__c = Date.today().addDays(10),
    Sales_Price_Change_Effective_Date_Approv__c = Date.today(), Sales_Price_Change_Effective_Date_Min__c = Date.today(),
    Customer_Notification_Date__c = Date.today().addDays(11), Customer_Notification_Date_Approved__c = Date.today().addDays(10), customer_notification_date_Rep__c=system.today(),SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456');
    insert ace11;
     
    controller.Notify(new Set<AceReleaseCommon.releaseRequest>{innercont1});
    controller.Release(new Set<AceReleaseCommon.releaseRequest>{innercont1});
   
    innercont1.acp = ace11;
    controller.Notify(new Set<AceReleaseCommon.releaseRequest>{innercont1});
    controller.Release(new Set<AceReleaseCommon.releaseRequest>{innercont1});

    ACE_Customer_Price_Changes__c ace22 = new ACE_Customer_Price_Changes__c(name='test', Sales_Price_Change_Effective_Date_Rep__c = Date.today().addDays(10),
    Sales_Price_Change_Effective_Date_Approv__c = Date.today(), Sales_Price_Change_Effective_Date_Min__c = Date.today(), sfdc_notification_flag__c = '1',
    Customer_Notification_Date__c = Date.today().addDays(11), Customer_Notification_Date_Approved__c = Date.today().addDays(10), customer_notification_date_Rep__c = Date.today().addDays(10),SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456');
    insert ace22;
    System.assertNotEquals(ace22.Id, null);
   
    innercont1.acp = ace22;
    controller.Notify(new Set<AceReleaseCommon.releaseRequest>{innercont1});
    controller.Release(new Set<AceReleaseCommon.releaseRequest>{innercont1});
    
    ace11.isRemediation__c = true;
    Boolean isReleaseAllow = controller.ReleaseAllowed(ace11 , ace11.customer_notification_date_Rep__c);
    System.assertEquals(isReleaseAllow, false);
    
    ace11 = new ACE_Customer_Price_Changes__c(name='test', Sales_Price_Change_Effective_Date_Rep__c = Date.today().addDays(10),
    Customer_Notification_Date__c = Date.today().addDays(11), Customer_Notification_Date_Approved__c = Date.today().addDays(10));
    
    controller.ReleaseAllowed(ace11 , ace11.customer_notification_date_Rep__c);
    
    ace11 = new ACE_Customer_Price_Changes__c(name='test', Sales_Price_Change_Effective_Date_Rep__c = Date.today().addDays(10),
    Customer_Notification_Date__c = Date.today().addDays(11), Customer_Notification_Date_Approved__c = Date.today().addDays(12));
    controller.ReleaseAllowed(ace11 , Date.today().addDays(13));
    
    ace11 = new ACE_Customer_Price_Changes__c(name='test', Sales_Price_Change_Effective_Date_Rep__c = Date.today().addDays(10),
    Customer_Notification_Date__c = Date.today().addDays(-1), Customer_Notification_Date_Approved__c = Date.today().addDays(-2));
    controller.ReleaseAllowed(ace11 , Date.today().addDays(3));
    
    ace11 = new ACE_Customer_Price_Changes__c(name='test', sfdc_notification_flag__c = '1',Sales_Price_Change_Effective_Date_Min__c = Date.today());
    controller.ReleaseAllowed(ace11 , Date.today().addDays(3));
    
    isReleaseAllow = controller.ReleaseAllowed(ace11 , Date.today().addDays(-3));
    System.assertEquals(isReleaseAllow, false);
    //END S-420971 (OD 00731422) [Hemant 6/30/2016] - Increase code coverage
}
}