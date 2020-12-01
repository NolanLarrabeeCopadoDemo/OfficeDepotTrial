@isTest
Private class ACE_BATCH_skuRollup_TC{

    static testMethod void myTest(){ 
    
        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
        
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014',trigger_by_pass__c=string.valueof(user.id));
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
                                                name='Q4-2014',
                                                batchId__c='Q4-2014',
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
          
        Ace_Customer_Core_Changes__c ace2 = new Ace_Customer_Core_Changes__c(batchId__c = 'Q4-2014', name = 'Test',CoreID__c = 'CL-9492090', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace2;

        Ace_Customer_Core_Changes__c ace21 = new Ace_Customer_Core_Changes__c(batchId__c = 'Q4-2014',name = 'Test',CoreID__c = 'CL-9492091', ACE_Customer_Price_Changes__c = ace1.id);
        insert ace21;
        
        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(batchId__c = 'Q4-2014',price_Changes_Type__c='A',Status__c='Inactive',SKU__c = '158849',name='158849',CoreList_ID__c='CL-9492090', Ace_Customer_Core_Changes__c = ace2.id);
        insert ace3;
           
   
         Test.startTest();
         system.runas(user){
         ACE_BATCH_skuRollup batch = new ACE_BATCH_skuRollup( 'SKU','','');
         database.executeBatch(batch,10);
         }
         Test.stopTest();       
        
         ACE_BATCH_skuRollup batch1 = new ACE_BATCH_skuRollup( 'CORE','','');
         database.executeBatch(batch1 ,10);
    }
    
}