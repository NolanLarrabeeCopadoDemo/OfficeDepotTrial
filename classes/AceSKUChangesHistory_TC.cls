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
private class AceSKUChangesHistory_TC 
{

 static testMethod void AceSKUChangesHistory_method(){

 Profile p = [select id from Profile where name='System Administrator' limit 1];
       
 User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
 Insert mgruser;

 User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
 Insert user;

 ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014',trigger_by_pass__c=string.valueof(user.id));
 insert desettings; 
  
 Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
 insert acc;
 
 ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
 insert ace1;
 
 Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
 insert ace2;

 Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ace2.id);
 insert ace3;
  
 /*Audit_History__c audit1 = new Audit_History__c(ACE_Customer_Price_Changes__c = ace1.id, name = 'test',Old_SalesPrice_Change_Effective_Date_Rep__c = system.today(),NewSales_Price_Change_Effective_Date_Rep__c = system.today()+1,Old_SalesPriceChangeEffectiveDateApprov__c=system.today(),new_SalesPrice_ChangeEffectiveDateApprov__c=system.today()+1);
 insert audit1;

 Audit_History__c audit2 = new Audit_History__c(Old_Approval_status__c = '',Ace_Customer_SKU_Changes__c=ace3.id,ACE_Customer_Price_Changes__c = ace1.id, name = 'test',Old_SalesPrice_Change_Effective_Date_Rep__c = system.today(),NewSales_Price_Change_Effective_Date_Rep__c = system.today(),Old_SalesPriceChangeEffectiveDateApprov__c=system.today(),new_SalesPrice_ChangeEffectiveDateApprov__c=system.today()+1);
 insert audit2;
 
 Audit_History__c audit3 = new Audit_History__c(New_Approval_status__c = 'Pending',Ace_Customer_SKU_Changes__c=ace3.id,ACE_Customer_Price_Changes__c = ace1.id, name = 'test',Old_SalesPrice_Change_Effective_Date_Rep__c = system.today(),NewSales_Price_Change_Effective_Date_Rep__c = system.today(),Old_SalesPriceChangeEffectiveDateApprov__c=system.today(),new_SalesPrice_ChangeEffectiveDateApprov__c=system.today());
 insert audit3;

 Audit_History__c audit4 = new Audit_History__c(New_Approval_status__c = 'Approved',Ace_Customer_SKU_Changes__c=ace3.id,ACE_Customer_Price_Changes__c = ace1.id, name = 'test',Old_SalesPrice_Change_Effective_Date_Rep__c = system.today(),NewSales_Price_Change_Effective_Date_Rep__c = system.today(),Old_SalesPriceChangeEffectiveDateApprov__c=system.today(),new_SalesPrice_ChangeEffectiveDateApprov__c=system.today());
 insert audit4;

 Audit_History__c audit5 = new Audit_History__c(New_Approval_status__c = 'Rejected',Ace_Customer_SKU_Changes__c=ace3.id,ACE_Customer_Price_Changes__c = ace1.id, name = 'test',Old_SalesPrice_Change_Effective_Date_Rep__c = system.today(),NewSales_Price_Change_Effective_Date_Rep__c = system.today(),Old_SalesPriceChangeEffectiveDateApprov__c=system.today(),new_SalesPrice_ChangeEffectiveDateApprov__c=system.today());
 insert audit5;*/

 Audit_History__c audit = new Audit_History__c(Ace_Customer_SKU_Changes__c=ace3.id,ACE_Customer_Price_Changes__c = ace1.id, name = 'test',Old_SalesPrice_Change_Effective_Date_Rep__c = system.today()+1,NewSales_Price_Change_Effective_Date_Rep__c = system.today()+1,Old_SalesPriceChangeEffectiveDateApprov__c=system.today()-1,new_SalesPrice_ChangeEffectiveDateApprov__c=system.today()+5);
 insert audit;

 Audit_History__c audit1 = new Audit_History__c(Ace_Customer_SKU_Changes__c=ace3.id,ACE_Customer_Price_Changes__c = ace1.id, name = 'test',Old_SalesPrice_Change_Effective_Date_Rep__c = system.today()+1,NewSales_Price_Change_Effective_Date_Rep__c = system.today()+5,Old_SalesPriceChangeEffectiveDateApprov__c=system.today()-1,new_SalesPrice_ChangeEffectiveDateApprov__c=system.today()+5);
 insert audit1;

 Audit_History__c audit2 = new Audit_History__c(Ace_Customer_SKU_Changes__c=ace3.id, Old_Approval_Status__c='',New_Approval_Status__c = 'Modification', ACE_Customer_Price_Changes__c = ace1.id, name = 'test',Old_SalesPrice_Change_Effective_Date_Rep__c = system.today()+1,NewSales_Price_Change_Effective_Date_Rep__c = system.today()+1,Old_SalesPriceChangeEffectiveDateApprov__c=system.today()+1,new_SalesPrice_ChangeEffectiveDateApprov__c=system.today()+1);
 insert audit2;

 Audit_History__c audit3 = new Audit_History__c(Ace_Customer_SKU_Changes__c=ace3.id,Record_Unlock_Status__c = 'Pending',New_Approval_status__c='Pending',Old_Approval_Status__c='mod_Pending', ACE_Customer_Price_Changes__c = ace1.id, name = 'test',Old_SalesPrice_Change_Effective_Date_Rep__c = system.today()+1,NewSales_Price_Change_Effective_Date_Rep__c = system.today()+1,Old_SalesPriceChangeEffectiveDateApprov__c=system.today()+1,new_SalesPrice_ChangeEffectiveDateApprov__c=system.today()+1);
 insert audit3;
 
 Audit_History__c audit4 = new Audit_History__c(Ace_Customer_SKU_Changes__c=ace3.id,Record_Unlock_Status__c = 'Approved',New_Approval_status__c='Approved',Old_Approval_Status__c='mod_Pending', ACE_Customer_Price_Changes__c = ace1.id, name = 'test',Old_SalesPrice_Change_Effective_Date_Rep__c = system.today()+1,NewSales_Price_Change_Effective_Date_Rep__c = system.today()+1,Old_SalesPriceChangeEffectiveDateApprov__c=system.today()+1,new_SalesPrice_ChangeEffectiveDateApprov__c=system.today()+1);
 insert audit4;

 Audit_History__c audit5 = new Audit_History__c(Ace_Customer_SKU_Changes__c=ace3.id,Record_Unlock_Status__c = 'Rejected',New_Approval_status__c='Rejected',Old_Approval_Status__c='mod_Pending', ACE_Customer_Price_Changes__c = ace1.id, name = 'test',Old_SalesPrice_Change_Effective_Date_Rep__c = system.today()+1,NewSales_Price_Change_Effective_Date_Rep__c = system.today()+1,Old_SalesPriceChangeEffectiveDateApprov__c=system.today()+1,new_SalesPrice_ChangeEffectiveDateApprov__c=system.today()+1);
 insert audit5;

 Audit_History__c audit6 = new Audit_History__c(Ace_Customer_SKU_Changes__c=ace3.id,Customer_Response__c = 'Approved',New_Approval_status__c='Modification',Old_Approval_Status__c='mod_Pending', ACE_Customer_Price_Changes__c = ace1.id, name = 'test',Old_SalesPrice_Change_Effective_Date_Rep__c = system.today()+1,NewSales_Price_Change_Effective_Date_Rep__c = system.today()+1,Old_SalesPriceChangeEffectiveDateApprov__c=system.today()+1,new_SalesPrice_ChangeEffectiveDateApprov__c=system.today()+1);
 insert audit6;

 Audit_History__c audit7 = new Audit_History__c(Ace_Customer_SKU_Changes__c=ace3.id,Customer_Response__c = 'Call Me',Old_Approval_Status__c='Modification',New_Approval_status__c='Modification', ACE_Customer_Price_Changes__c = ace1.id, name = 'test',Old_Approval_Price__c=20.50,new_Approval_Price__c=18.50,Old_SalesPrice_Change_Effective_Date_Rep__c = system.today()+1,NewSales_Price_Change_Effective_Date_Rep__c = system.today()+1,Old_SalesPriceChangeEffectiveDateApprov__c=system.today()+1,new_SalesPrice_ChangeEffectiveDateApprov__c=system.today()+1);
 insert audit7;

 Audit_History__c audit8 = new Audit_History__c(Ace_Customer_SKU_Changes__c=ace3.id,ACE_Customer_Price_Changes__c = ace1.id, name = 'test',NewSales_Price_Change_Effective_Date_Rep__c = null,Old_SalesPriceChangeEffectiveDateApprov__c=system.today()+1,new_SalesPrice_ChangeEffectiveDateApprov__c=system.today()+1);
 insert audit8;


 system.runas(user){
 ApexPages.currentPage().getParameters().Put('id',ace1.id); 
 AceSKUChangesHistory controller = new AceSKUChangesHistory();
 AceSKUChangesHistory.AceSKUHist innercont= new AceSKUChangesHistory.AceSKUHist();
 controller.nextPage();
 controller.prevPage();
 controller.getDisablePrevious();
 controller.getDisableNext();
 controller.formatCurrency(audit7.Old_Approval_Price__c);
 }
 }
}