@isTest
private class ACEVendavoRecCollection_TC
{
    @testSetup static void setUpData(){ 
    
    
System.runAs(new user(ID = UserInfo.getUserID())){


        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
        
        ACE_Settings__c desettings = new ACE_Settings__c(processing_window__c=2,BatchName__c='Q1-2017',Vendavo_Update_Start_Date__c = system.today()-1, Vendavo_Update_End_Date__c = system.today()+5,Max_Object_ID__c=3,Minimum_Object_ID__c=1,batchsize__c=1);
        insert desettings; 


        Account acc = new Account (
                         name = 'SUN Test Account',
                         AOPS_Seq_ID__c = '123456',
                         AOPS_Cust_Id__c = '123456',
                         Oracle_Party_Id__c = '123456',
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         ownerid = user.id,
                         billingcity = 'Orem');
        insert acc;
                Account acc2 = new Account (
                         name = 'SUN Test 7Account',
                         AOPS_Seq_ID__c = '123457',
                         AOPS_Cust_Id__c = '123457',
                         Oracle_Party_Id__c = '123457',
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         ownerid = user.id,
                         billingcity = 'Orem');
        insert acc2;


        ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q1-2017',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Sales_Price_Change_Effective_Date_Min__c = system.today()-1,
                                                Approval_Type__c = 1,
                                                record_unlock__c = true,
                                                Customer_Notification_Date_Approved__c = system.today(),
                                                SFDC_Notification_Flag__c = '1');
        insert ace1;  

        ACE_Customer_Price_Changes__c ace3 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q1-2017',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123457',
                                                DSM__c = mgruser.id, 
                                                Sales_Price_Change_Effective_Date_Min__c = system.today()-1,
                                                Approval_Type__c = 1,
                                                record_unlock__c = true,
                                                
                                                Customer_Notification_Date_Approved__c = system.today(),
                                                SFDC_Notification_Flag__c = '1');
        insert ace3; 
        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = 'CL-9492090', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;
           Ace_Customer_Core_Changes__c ace4 = new Ace_Customer_Core_Changes__c(name = 'Test4',CoreID__c = 'CL-9492090', ACE_Customer_Price_Changes__c = ace3.id);
        insert ace4;
        //Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(price_Changes_Type__c='A',Status__c='Active',SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ace2.id);
        Ace_Customer_SKU_Changes__c ace5 = new Ace_Customer_SKU_Changes__c(price_Changes_Type__c='A',ACE_SKU_Changes_ID__c = 1,Status__c='Active',SKU__c = '123456',name='test', batchid__c = 'Q1-2017', Ace_Customer_Core_Changes__c = ace2.id);
        insert ace5;
           Ace_Customer_SKU_Changes__c ace6 = new Ace_Customer_SKU_Changes__c(price_Changes_Type__c='A',ACE_SKU_Changes_ID__c = 2,Status__c='Active',SKU__c = '123457',name='test', batchid__c = 'Q1-2017', Ace_Customer_Core_Changes__c = ace4.id);
        insert ace6;
    }
    }
    
    static testMethod void myUnitTest() 
    {
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        //----------------
        system.debug('Entered myUnitTest:');
        ACE_Settings__c aceSetting =[SELECT Id,Name, BatchName__c,Vendavo_Update_Start_Date__c,Vendavo_Update_End_Date__c from ACE_Settings__c limit 1];
        DAte StartDate = aceSetting.Vendavo_Update_Start_Date__c;//Date.valueOf('2017-03-19');//
        Date EndDate = aceSetting.Vendavo_Update_End_Date__c+1;//Date.valueOf('2017-03-25');//
        system.debug('QUERY---'+[select SKU__c,Vendavo_Update_Date__c from ACE_Customer_SKU_Changes__c where (Vendavo_Update_Date__c >= :StartDate  AND Vendavo_Update_Date__c < :EndDate ) AND batchid__c = 'Q1-2017']);
        //---------------
        Test.startTest();
        ACEVendavoRecCollection aceBatch = new ACEVendavoRecCollection();
        database.executebatch(aceBatch);
        System.schedule('TestBatch1',CRON_EXP , aceBatch );
        Test.stopTest();        
         
    }
    
    
}
/*private class ACEVendavoRecCollection_TC 
{
    static testMethod void myUnitTest() 
    {
        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
        
         ACE_Settings__c desettings = new ACE_Settings__c(processing_window__c=2,BatchName__c='Q1-2017',Vendavo_Update_Start_Date__c = system.today(), Vendavo_Update_End_Date__c = system.today()+5);
         insert desettings; 


         Account acc = new Account (
                         name = 'SUN Test Account',
                         AOPS_Seq_ID__c = '123456',
                         AOPS_Cust_Id__c = '123456',
                         Oracle_Party_Id__c = '123456',
                         Billingcountry = 'USA',
                         BillingState = 'UT',
                         BillingStreet = '1040 N 326 W',
                         ownerid = user.id,
                         billingcity = 'Orem');
         insert acc;

         ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                                Owning_Customer_Legal__c='T',
                                                name='Q1-2017',
                                                SRM_Differential__c=5,
                                                Item_12_Month_Qty__c = 50,
                                                Total_Spend_Impact_12_Month__c=5,
                                                Customer__c = acc.id, 
                                                Owning_Customer_ID__c ='123456',
                                                DSM__c = mgruser.id, 
                                                Sales_Price_Change_Effective_Date_Min__c = system.today()-1,
                                                Approval_Type__c = 1,
                                                record_unlock__c = true,
                                                Customer_Notification_Date_Approved__c = system.today(),
                                                SFDC_Notification_Flag__c = '1');
         insert ace1;  

        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(name = 'Test',CoreID__c = 'CL-9492090', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;
        
        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(price_Changes_Type__c='A',Status__c='Active',SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ace2.id);
        insert ace3;
        
         ACEVendavoRecCollection aceBatch = new ACEVendavoRecCollection();
         database.executebatch(aceBatch);
         String CRON_EXP = '0 0 0 3 9 ? 2022';
         //String CRON_EXP = '0 0 0 20 3 ? 2017';
         System.schedule('TestBatch1',CRON_EXP , aceBatch );
        
    }
}
*/