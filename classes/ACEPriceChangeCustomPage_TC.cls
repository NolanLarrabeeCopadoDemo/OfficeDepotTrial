@isTest
private class ACEPriceChangeCustomPage_TC 
{
 static testMethod void ACEPriceChangeCustomPage_method(){
 Profile p = [select id from Profile where name='System Administrator' limit 1];
       
 User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
 Insert mgruser;

 User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
 Insert user;

 ACE_Settings__c desettings = new ACE_Settings__c(Level3Access__c='VP',Level2Access__c='RSD',Level1Access__c='DSM',BatchName__c='Q4-2014',trigger_by_pass__c=string.valueof(user.id));
 insert desettings; 

 Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
 insert acc;
 
 ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(name='test',SRM_Differential__c=5,Item_12_Month_Qty__c = 50,Total_Spend_Impact_12_Month__c=5,Customer__c = acc.id, Owning_Customer_ID__c ='123456', SFDC_Notification_Flag__c = '3');
 insert ace1;


 ApexPages.currentPage().getParameters().Put('id',ace1.id);
 ApexPages.StandardController con = new ApexPages.StandardController(ace1);
 ACEPriceChangeCustomPage controller = new ACEPriceChangeCustomPage(con); 
 
 }
 }