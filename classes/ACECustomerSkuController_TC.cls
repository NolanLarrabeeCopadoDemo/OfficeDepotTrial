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
private class ACECustomerSkuController_TC 
{

 static testMethod void ACECustomerSkuController_testmethod() 
 {

 String DataRange = '12-Months';
 String DataRange1 = '9-Months';
 String DataRange2 = '6-Months';
 String DataRange3 = '3-Months';
 
 List<Ace_Customer_SKU_Changes__c > lst_sku = new List<Ace_Customer_SKU_Changes__c >();

 Profile p = [select id from Profile where name='System Administrator' limit 1];
       
 User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
 Insert mgruser;

 User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
 Insert user;

 ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014',trigger_by_pass__c=string.valueof(user.id));
 insert desettings; 
 
 Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
 insert acc;
 
 ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456');
 insert ace1;

 Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
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

 ApexPages.currentPage().getParameters().Put('id',ace1.id);
 ApexPages.StandardController con = new ApexPages.StandardController(ace1);
 ACECustomerSkuController controller = new ACECustomerSkuController(con);
 controller.generateDataforRange(DataRange); 
 controller.generateDataforRange(DataRange1);
 controller.generateDataforRange(DataRange2);
 controller.generateDataforRange(DataRange3);
 controller.getskusforCustomer(ace1.id);
 controller.generateSummaryRow(lst_sku, DataRange);
 controller.calcRange();
 ACECustomerSkuController.CustomerSKUDataResponse innercontroller= new ACECustomerSkuController.CustomerSKUDataResponse();

 }
 
 
}