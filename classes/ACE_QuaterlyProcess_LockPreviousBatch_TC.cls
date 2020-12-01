@isTest
private class ACE_QuaterlyProcess_LockPreviousBatch_TC {

    static testMethod void myUnitTest() 
    {
        
        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='133446',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com');
        insert u1; 
        system.runAs(u1){
        
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
                     billingcity = 'Orem');
        insert acc;
        
        ACE_Customer_Price_Changes__c ace1 = new ACE_Customer_Price_Changes__c(
                                            Owning_Customer_Legal__c='T',
                                            name='test',
                                            batchId__c='Q4-2014',
                                            SRM_Differential__c=5,
                                            Item_12_Month_Qty__c = 50,
                                            Total_Spend_Impact_12_Month__c=5,
                                            Customer__c = acc.id, 
                                            Owning_Customer_ID__c ='123456',
                                            Approval_Type__c = 1,
                                            Customer_Notification_Date_Approved__c = system.today(),
                                            SFDC_Notification_Flag__c = '2');
        insert ace1;
        
        test.starttest();
        ACE_QuaterlyProcess_LockPreviousBatch assignbatch = new ACE_QuaterlyProcess_LockPreviousBatch('Q4-2014');
        database.executebatch(assignbatch,10); 
        test.stoptest();   
        }
                     
    }    
}