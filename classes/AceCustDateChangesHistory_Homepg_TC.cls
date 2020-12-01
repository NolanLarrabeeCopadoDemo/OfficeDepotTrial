@isTest
private class AceCustDateChangesHistory_Homepg_TC 
{
 static testMethod void AceCustDateChangesHistory_Homepg_method()
 {
     ACE_Settings__c desettings = new ACE_Settings__c();
     desettings.Current_Quarter__c = 'Q2-2014';
     insert desettings; 
     Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
     insert acc;
     
     ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='Q2-2014',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
     insert ace1;
     Audit_History__c audit = new Audit_History__c(ACE_Customer_Price_Changes__c = ace1.id,SKU__c='', name = 'Q2-2014',Old_SalesPrice_Change_Effective_Date_Rep__c = system.today(),NewSales_Price_Change_Effective_Date_Rep__c = system.today()+1,Old_SalesPriceChangeEffectiveDateApprov__c=system.today(),new_SalesPrice_ChangeEffectiveDateApprov__c=system.today()+1);
     insert audit;
     
     AceCustDateChangesHistory_Homepg ADCH= new AceCustDateChangesHistory_Homepg();
     ADCH.generateList();
     ADCH.nextPage();
     ADCH.prevPage();
     ADCH.getDisablePrevious();
     ADCH.getDisableNext();
     }
 }