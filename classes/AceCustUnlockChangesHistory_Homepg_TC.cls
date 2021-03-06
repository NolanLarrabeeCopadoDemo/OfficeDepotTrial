@isTest
private class AceCustUnlockChangesHistory_Homepg_TC 
{
    static testMethod void myUnitTest() 
    {
        Profile p = [select id from Profile where name='System Administrator' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;
        
         ACE_Settings__c desettings = new ACE_Settings__c(BatchName__c='Q4-2014',Current_Quarter__c='Q4-2014');
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
                                                Approval_Type__c = 1,
                                                Customer_Notification_Date_Approved__c = system.today(),
                                                SFDC_Notification_Flag__c = '3');
         insert ace1;  
        system.runas(user){
        Audit_History__c audit = new Audit_History__c(Record_Unlock_Status__c='Pending',sku__c='',ACE_Customer_Price_Changes__c = ace1.id, name = 'test',Old_SalesPrice_Change_Effective_Date_Rep__c = system.today(),NewSales_Price_Change_Effective_Date_Rep__c = system.today()+1,Old_SalesPriceChangeEffectiveDateApprov__c=system.today(),new_SalesPrice_ChangeEffectiveDateApprov__c=system.today()+1);
        insert audit;
        Audit_History__c audit1 = new Audit_History__c(Record_Unlock_Status__c='Approved',sku__c='',ACE_Customer_Price_Changes__c = ace1.id, name = 'test',Old_SalesPrice_Change_Effective_Date_Rep__c = system.today(),NewSales_Price_Change_Effective_Date_Rep__c = system.today()+1,Old_SalesPriceChangeEffectiveDateApprov__c=system.today(),new_SalesPrice_ChangeEffectiveDateApprov__c=system.today()+1);
        insert audit1;
        Audit_History__c audit2 = new Audit_History__c(Record_Unlock_Status__c='Rejected',sku__c='',ACE_Customer_Price_Changes__c = ace1.id, name = 'test',Old_SalesPrice_Change_Effective_Date_Rep__c = system.today(),NewSales_Price_Change_Effective_Date_Rep__c = system.today()+1,Old_SalesPriceChangeEffectiveDateApprov__c=system.today(),new_SalesPrice_ChangeEffectiveDateApprov__c=system.today()+1);
        insert audit2;
         
         AceCustUnlockChangesHistory_Homepg test = new AceCustUnlockChangesHistory_Homepg();
         test.nextPage();
         test.prevPage();
         test.getDisablePrevious();
         test.getDisableNext();
         }
    }
}