@IsTest
private class InsertingCustomerSKUValue_TC {
    
    static testMethod void InsertingCustomerSKUValue_TC(){
        
          
         ACE_Settings__c desettings = new ACE_Settings__c();
         insert desettings; 
         
         Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
         insert acc;               
         
         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='Q4-2014',SRM_Differential__c=5,record_unlock_Status__c='open',Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
         insert ace1;
         
         Ace_Customer_Core_Changes__c CCCC = new Ace_Customer_Core_Changes__c();
         CCCC.ACE_Customer_Price_Changes__c=ace1.id;
         CCCC.CoreID__c='alpha';
         insert CCCC;         
         
         
         ACE_Customer_sku_Changes__c sku1 = new ACE_Customer_sku_Changes__c(name='test',SKU__c='123456',Ace_Customer_Core_Changes__c = CCCC.id);
         insert sku1;
        
         system.debug('----->>> BEFORE INSERT CUST VIEW IN TC: ' + ace1.Owning_Customer_ID__c);
		 Test.startTest();
         ACE_Customer_View__c ace_cv = new ACE_Customer_View__c();
         ace_cv.SKUID__c = sku1.id;
         insert ace_cv;
         Test.stopTest();
         system.debug('----->>> AFTER INSERT CUST VIEW IN TC: ' + ace1.Owning_Customer_ID__c);
            
        
        
    }

}