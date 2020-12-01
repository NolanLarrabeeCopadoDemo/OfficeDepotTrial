@isTest
private class ACE_Export_SKU_Records_Controller_TC
{
    static testMethod void myUnitTest() 
    {

        list<Ace_Customer_Core_Changes__c> acelist= new list<Ace_Customer_Core_Changes__c>();
        map<id,Ace_Customer_Core_Changes__c> cmap= new map<id,Ace_Customer_Core_Changes__c>();
        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
        
         ACE_Settings__c desettings = new ACE_Settings__c(processing_window__c=2,BatchName__c='Q4-2014',Vendavo_Update_Start_Date__c = system.today(), Vendavo_Update_End_Date__c = system.today()+5);
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
        acelist.add(ace2);
        cmap.put(ace2.id,ace2);
        
        Ace_Customer_SKU_Changes__c ace3 = new Ace_Customer_SKU_Changes__c(SKU_Alt__c = '54321',SKU_Description__c='Sku, Description', price_Changes_Type__c='A',Status__c='Active',SKU__c = '123456',name='test', Ace_Customer_Core_Changes__c = ace2.id,update_timing_action__c = 'T');
        insert ace3;
        Ace_Customer_SKU_Changes__c ace4 = new Ace_Customer_SKU_Changes__c(Alt_SKU__c = true,SKU_Description__c='Sku, Description', price_Changes_Type__c='A',Status__c='Active',SKU__c = '54321',name='54321', Ace_Customer_Core_Changes__c = ace2.id, update_timing_action__c = 'T');
        insert ace4;
        
        ApexPages.currentPage().getParameters().Put('id',ace1.id);
        ACE_Export_SKU_Records_Controller test = new ACE_Export_SKU_Records_Controller();
        
    }
}