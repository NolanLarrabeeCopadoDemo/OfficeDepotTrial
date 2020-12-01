@isTest
private class ACESKUComponentControllerALL_TC {
	static testMethod void myUnitTest() 
    {
        
        Profile p = [select id from Profile where name='System Administrator' limit 1];
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
        system.runas(user){
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014');
         insert desettings; 


         Account acc = new Account (
                         name = 'SUN Test Account',
                         AOPS_Seq_ID__c = '123456',
                         AOPS_Cust_Id__c = '123456',
                         Oracle_Party_Id__c = '123456',
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         Rolling_12_month_sales__c = 175000.00,
             			 Rolling_9_month_sales__c = 12000.00,
             			 Rolling_6_month_sales__c = 6000.00,
              			 Rolling_3_month_sales__c = 2000.00,
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert acc;

         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                Customer_Notification_Date_Approved__c = system.today(),
                                                SFDC_Notification_Flag__c = '3');
         insert ace1;  

         ACE_Customer_Price_Changes__c ace11 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                Customer_Notification_Date_Approved__c = system.today(),
                                                SFDC_Notification_Flag__c = '3');
         insert ace11;  

        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;
        
        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(price_Changes_Type__c='D',Status__c='Active',SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ace2.id, Update_Timing_Action__c = 'T', SKU_Alt__c = '12233', Alternate_Chosen_Flag__c = true, Price_Change_ID__c = ace1.id,Owning_Customer_Legal__c = 'T');
        insert ace3;            
         
         ApexPages.currentPage().getParameters().Put('id',ace3.id);         
         ACESKUComponentControllerALL test_1 = new ACESKUComponentControllerALL();
         test_1.passThruDelSKU = true;
         test_1.setOcIds(string.valueof(ace1.id)+';CustomerPricing');
         test_1.gotoSkuException();
         test_1.calcRange();
         test_1.setOcIds(string.valueof(ace1.id)+';Customer');
         test_1.getOcIds();
         test_1.nextPage();
         test_1.prevPage();
         test_1.getDisablePrevious();
         test_1.getDisableNext();
         test_1.DataRange = '12-Months';
         test_1.setOcIds(string.valueof(ace1.id)+';CustomerPricing');
         test_1.calcRange();
         test_1.DataRange = '9-Months';
         test_1.setOcIds(string.valueof(ace1.id)+';CustomerPricing');
         test_1.calcRange();
         test_1.DataRange = '6-Months';
         test_1.setOcIds(string.valueof(ace2.id)+';CustomerPricing');
         test_1.calcRange();
         test_1.DataRange = '3-Months';
         test_1.setOcIds(string.valueof(ace3.id)+';CustomerPricing');
         //test_1.calcRange();         
        
         test_1.passThruSkuId = ace3.id;
         Test.starttest();
         test_1.deleteSKU();
         test_1.RevertdeleteSKU();
         test_1.RevertReplaceALTSKU();
         test_1.passStringToController();
        test_1.passThruSkuId1 = ace3.id;
         test_1.refreshPage();
         test_1.searchSKU();
         Test.stopTest();  
        }
        
    }
    
       static testMethod void myUnitTest1() 
    {
        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
        system.runas(user){
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014');
         insert desettings; 


         Account acc = new Account (
                         name = 'SUN Test Account',
                         AOPS_Seq_ID__c = '123456',
                         AOPS_Cust_Id__c = '123456',
                         Oracle_Party_Id__c = '123456',
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         Rolling_12_month_sales__c = 175000.00,
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert acc;

         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                Customer_Notification_Date_Approved__c = system.today(),
                                                SFDC_Notification_Flag__c = '3');
         insert ace1;  

         ACE_Customer_Price_Changes__c ace11 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                Customer_Notification_Date_Approved__c = system.today(),
                                                SFDC_Notification_Flag__c = '3');
         insert ace11;  

        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;
        
        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(price_Changes_Type__c='D',Status__c='Active',SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ace2.id);
        insert ace3;
         
          ApexPages.currentPage().getParameters().Put('id',ace3.id);
        
         ACESKUComponentControllerALL test = new ACESKUComponentControllerALL();
         test.passThruDelSKU = false;
         
         test.gotoSkuException();
         test.calcRange();
         test.setOcIds(string.valueof(ace1.id)+';Customer');
         test.getOcIds();
         test.nextPage();
         test.prevPage();
         test.getDisablePrevious();
         test.getDisableNext();
         test.DataRange = '12-Months';
         test.setOcIds(string.valueof(ace1.id)+';CustomerPricing');
         test.DataRange = '9-Months';
         test.setOcIds(string.valueof(ace1.id)+';CustomerPricing');
         test.calcRange();
         test.DataRange = '6-Months';
         test.setOcIds(string.valueof(ace1.id)+';CustomerPricing');
         test.calcRange();
         test.DataRange = '3-Months';
         test.setOcIds(string.valueof(ace1.id)+';CustomerPricing');
         test.calcRange();
        }
    }
    
    
 static testMethod void myUnitTest2() 
    {
        
        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
        system.runAs(user){
        
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014');
         insert desettings; 
        system.runas(user){

         Account acc = new Account (
                         name = 'SUN Test Account',
                         AOPS_Seq_ID__c = '123456',
                         AOPS_Cust_Id__c = '123456',
                         Oracle_Party_Id__c = '123456',
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         Rolling_12_month_sales__c = 105000.00,
             			 Rolling_9_month_sales__c = 12000.00,
             			 Rolling_6_month_sales__c = 6000.00,
              			 Rolling_3_month_sales__c = 2000.00,
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert acc;

         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                Customer_Notification_Date_Approved__c = system.today(),
                                                SFDC_Notification_Flag__c = '3');
         insert ace1;  

         ACE_Customer_Price_Changes__c ace11 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                Customer_Notification_Date_Approved__c = system.today(),
                                                SFDC_Notification_Flag__c = '3');
         insert ace11;  

        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;
        
        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(price_Changes_Type__c='D',Status__c='Active',SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ace2.id, Update_Timing_Action__c = 'T', SKU_Alt__c = null, Alternate_Chosen_Flag__c = true, Price_Change_ID__c = ace1.id,Owning_Customer_Legal__c = 'F');
        insert ace3;            
         
         ApexPages.currentPage().getParameters().Put('id',ace3.id);         
         ACESKUComponentControllerALL test_1 = new ACESKUComponentControllerALL();
         test_1.passThruDelSKU = true;
       
         test_1.DataRange = '12-Months';
         test_1.setOcIds(string.valueof(ace1.id)+';CustomerPricing_np');
         test_1.calcRange();    
        }
        }
         
        
    }
    
    static testMethod void myUnitTest3() 
    {
        
        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
        system.runas(user){
        
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014');
         insert desettings; 


         Account acc = new Account (
                         name = 'SUN Test Account',
                         AOPS_Seq_ID__c = '123456',
                         AOPS_Cust_Id__c = '123456',
                         Oracle_Party_Id__c = '123456',
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         Rolling_12_month_sales__c = null,
             			 Rolling_9_month_sales__c = 350000.00,
             			 Rolling_6_month_sales__c = 6000.00,
              			 Rolling_3_month_sales__c = 2000.00,
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert acc;

         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                Customer_Notification_Date_Approved__c = system.today(),
                                                SFDC_Notification_Flag__c = '3');
         insert ace1;  

         ACE_Customer_Price_Changes__c ace11 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                Customer_Notification_Date_Approved__c = system.today(),
                                                SFDC_Notification_Flag__c = '3');
         insert ace11;  

        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;
        
        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(price_Changes_Type__c='D',Status__c='Active',SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ace2.id, Update_Timing_Action__c = 'T', SKU_Alt__c = null, Alternate_Chosen_Flag__c = true, Price_Change_ID__c = ace1.id,Owning_Customer_Legal__c = 'F');
        insert ace3;            
         
         ApexPages.currentPage().getParameters().Put('id',ace3.id);         
         ACESKUComponentControllerALL test_1 = new ACESKUComponentControllerALL();
         test_1.passThruDelSKU = true;
       
         test_1.DataRange = '9-Months';
         test_1.setOcIds(string.valueof(ace1.id)+';CustomerPricing_np');
         test_1.calcRange();        
        }
         
        
    }
    
     static testMethod void myUnitTest4() 
    {
        
        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
        system.runas(user){
        
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014');
         insert desettings; 


         Account acc = new Account (
                         name = 'SUN Test Account',
                         AOPS_Seq_ID__c = '123456',
                         AOPS_Cust_Id__c = '123456',
                         Oracle_Party_Id__c = '123456',
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         Rolling_12_month_sales__c = null,
             			 Rolling_9_month_sales__c = null,
             			 Rolling_6_month_sales__c = 50000.00,
              			 Rolling_3_month_sales__c = 2000.00,
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert acc;

         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                Customer_Notification_Date_Approved__c = system.today(),
                                                SFDC_Notification_Flag__c = '3');
         insert ace1;  

         ACE_Customer_Price_Changes__c ace11 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                Customer_Notification_Date_Approved__c = system.today(),
                                                SFDC_Notification_Flag__c = '3');
         insert ace11;  

        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;
        
        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(price_Changes_Type__c='D',Status__c='Active',SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ace2.id, Update_Timing_Action__c = 'T', SKU_Alt__c = null, Alternate_Chosen_Flag__c = true, Price_Change_ID__c = ace1.id,Owning_Customer_Legal__c = 'F');
        insert ace3;            
         
         ApexPages.currentPage().getParameters().Put('id',ace3.id);         
         ACESKUComponentControllerALL test_1 = new ACESKUComponentControllerALL();
         test_1.passThruDelSKU = true;
       
         test_1.DataRange = '6-Months';
         test_1.setOcIds(string.valueof(ace1.id)+';CustomerPricing_np');
         test_1.calcRange();       
        }
         
        
    }
    
     static testMethod void myUnitTest5() 
    {
        
        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
        system.runas(user){
        
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014');
         insert desettings; 


         Account acc = new Account (
                         name = 'SUN Test Account',
                         AOPS_Seq_ID__c = '123456',
                         AOPS_Cust_Id__c = '123456',
                         Oracle_Party_Id__c = '123456',
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         Rolling_12_month_sales__c = null,
             			 Rolling_9_month_sales__c = null,
             			 Rolling_6_month_sales__c = null,
              			 Rolling_3_month_sales__c = 102000.00,
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert acc;

         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                Customer_Notification_Date_Approved__c = system.today(),
                                                SFDC_Notification_Flag__c = '3');
         insert ace1;  

         ACE_Customer_Price_Changes__c ace11 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                Customer_Notification_Date_Approved__c = system.today(),
                                                SFDC_Notification_Flag__c = '3');
         insert ace11;  

        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;
        
        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(price_Changes_Type__c='D',Status__c='Deleted',SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ace2.id, Update_Timing_Action__c = 'T', SKU_Alt__c = null, Alternate_Chosen_Flag__c = true, Price_Change_ID__c = ace1.id,Owning_Customer_Legal__c = 'F');
        insert ace3;            
         
         ApexPages.currentPage().getParameters().Put('id',ace3.id);         
         ACESKUComponentControllerALL test_1 = new ACESKUComponentControllerALL();
         test_1.passThruDelSKU = true;
       
         test_1.DataRange = '3-Months';
         test_1.setOcIds(string.valueof(ace1.id)+';CustomerPricing');
         test_1.calcRange();    
        }
         
        
    }
    
      static testMethod void myUnitTest6() 
    {
        
        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
        system.runas(user){
        
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014');
         insert desettings; 


         Account acc = new Account (
                         name = 'SUN Test Account',
                         AOPS_Seq_ID__c = '123456',
                         AOPS_Cust_Id__c = '123456',
                         Oracle_Party_Id__c = '123456',
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         Rolling_12_month_sales__c = null,
             			 Rolling_9_month_sales__c = null,
             			 Rolling_6_month_sales__c = null,
              			 Rolling_3_month_sales__c = 102000.00,
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert acc;

         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                Customer_Notification_Date_Approved__c = system.today(),
                                                SFDC_Notification_Flag__c = '3');
         insert ace1;  

         ACE_Customer_Price_Changes__c ace11 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q4-2014',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Approval_Type__c = 1,
                                                Customer_Notification_Date_Approved__c = system.today(),
                                                SFDC_Notification_Flag__c = '3');
         insert ace11;  

        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = '123456', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;
        
        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(price_Changes_Type__c='M',Status__c='Deleted',SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ace2.id, Update_Timing_Action__c = 'T', SKU_Alt__c = null, Alternate_Chosen_Flag__c = true, Price_Change_ID__c = ace1.id,Owning_Customer_Legal__c = 'F');
        insert ace3;            
         
         ApexPages.currentPage().getParameters().Put('id',ace3.id);         
         ACESKUComponentControllerALL test_1 = new ACESKUComponentControllerALL();
         test_1.passThruDelSKU = true;
       
         test_1.DataRange = '3-Months';
         test_1.setOcIds(string.valueof(ace1.id)+';CustomerPricing_np');
         test_1.calcRange();      
        }
                 
        
    }
}