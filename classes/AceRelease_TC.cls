@isTest
private class AceRelease_TC 
{
    static testMethod void myUnitTest() 
    {

        Profile p = [select id from Profile where name='Field Sales' limit 1];
               
        User mgruser = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'ACE', FirstName = 'Manager', Email = 'ACE.manager@officedepot.com',Username ='ACE.manager@officedepot.com', Alias='test', CommunityNickname='test Approver', LanguageLocaleKey='en_US', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', OD_Employee_ID__c='653466');
        Insert mgruser;

        User user = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'ACE',Email='Rep.ACE@officedepot.com', Username ='Rep.ACE@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='653486');
        Insert user;

        ACE_Settings__c desettings = new ACE_Settings__c();
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
                                            name='test',
                                            SRM_Differential__c=5,
                                            Item_12_Month_Qty__c = 50,
                                            Total_Spend_Impact_12_Month__c=5,
                                            Customer__c = acc.id, 
                                            Owning_Customer_ID__c ='123456',
                                            Approval_Type__c = 1,
                                            Customer_Notification_Date_Approved__c = system.today(),
                                            SFDC_Notification_Flag__c = '2');
        insert ace1;
        
        ace1.Customer_Notification_Date_Approved__c = system.today();
        update ace1;
        
        ApexPages.currentPage().getParameters().Put('pchangeid',ace1.id);
        AceRelease Controller = new AceRelease();
        Controller.responseSelection = 'Scheduled';
        controller.getReleaseOptions();
        controller.rerenderDateSection();
        controller.save();
        controller.cancel();
        Controller.responseSelection = '';
        controller.rerenderDateSection();

        ACE_Customer_Price_Changes__c ace2 = new ACE_Customer_Price_Changes__c(
                                            Owning_Customer_Legal__c='T',
                                            name='test',
                                            SRM_Differential__c=5,
                                            Item_12_Month_Qty__c = 50,
                                            Total_Spend_Impact_12_Month__c=5,
                                            Customer__c = acc.id, 
                                            Owning_Customer_ID__c ='123456',
                                            Approval_Type__c = 1,
                                            Sales_Price_Change_Effective_Date_Min__c = system.today(),
                                            SFDC_Notification_Flag__c = '1');
        insert ace2;
        
        ApexPages.currentPage().getParameters().Put('pchangeid',ace2.id);
        AceRelease Controller1 = new AceRelease();
        controller1.responseSelection = 'Immediate';
        controller1.save();
        Controller.responseSelection = 'Scheduled';
        controller.getReleaseOptions();
        
    }
}