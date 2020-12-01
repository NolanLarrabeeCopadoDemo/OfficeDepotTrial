@isTest
private class ACECustomerCoreController_TC 
{
    static testMethod void ACECustomerCoreController_method()
    {
         ACE_Settings__c desettings = new ACE_Settings__c();
         desettings.trigger_by_pass__c = '005E0000000lNbVIAU';
         insert desettings; 
         
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
         insert acc;
         
         Product2 prod = new Product2();
         prod.Name = 'testProd';
         prod.SKUID__c='123456';
         prod.quntity_per_unit__c = 5.0;
         insert prod;         
        
         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(batchId__c='Q2-2014',name='Q2-2014',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
         ace1.Record_Lock_Code__c = 'yes';
         insert ace1;
         
         Ace_Customer_Core_Changes__c ACCH=new Ace_Customer_Core_Changes__c();
         ACCH.CoreID__c='27653';
         ACCH.batchId__c='Q2-2014';
         ACCH.ACE_Customer_Price_Changes__c = ace1.id; 
         
         List<Ace_Customer_Core_Changes__c > lCores = new List<Ace_Customer_Core_Changes__c >();
         lCores.add(ACCH);
         insert lCores;
         
         Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(Status__c='Active',CoreList_ID__c='27653',SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ACCH.id, Update_Timing_Action__c='T');
         insert ace3;
         
         ApexPages.currentPage().getParameters().Put('id',ace1.id);
         ACECustomerCoreController ACCC= new ACECustomerCoreController();
         ACCC.generateDataforRange('12-Months');
         ACCC.generateDataforRange('9-Months');
         ACCC.generateDataforRange('6-Months');
         ACCC.generateDataforRange('3-Months');
         ACCC.calcRange();
         
         // Public testMethod void CustomerCoreDataResponse_method(){
         ACECustomerCoreController.CustomerCoreDataResponse CCDR = new ACECustomerCoreController.CustomerCoreDataResponse();
         ACCC.nextPage();
         ACCC.prevPage();
         ACCC.getDisablePrevious();
         ACCC.getDisableNext();
         
         
         //Ace_Customer_Core_Changes__c ACC = new Ace_Customer_Core_Changes__c();
         ACCC.generateSummaryRow(lCores,'12');
    }
 
}