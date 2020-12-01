/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *

Description: Test class for Trigger 'OnQuote_IU', As this test class is for trigger so very simple test class just to invoke the trigger.

Created By: Sunil Bansal
Created on : 19-Jun-2012

*/

@isTest
private class OnQuote_IU_TC {

    static testMethod void myUnitTest() 
    {
    
        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='123007',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@123007.com',Reassgin_Opportunity__c='NP',isActive=True);
        insert u1;
        System.runAs(u1)
        {    
            Account account = new Account ();
            account.name = 'SUN Test Account';
            account.BillingStreet = '1040 N 326 W';
            account.billingcity = 'Orem';
            account.BillingState = 'UT';
            account.Billingcountry = 'USA';
            insert account;
                    
            // create Opportunity
            opportunity oppty = new opportunity ();
            oppty.name = 'Sun Test Opportunity';
            oppty.Accountid = account.id;
            oppty.CloseDate = System.today()+7;
            oppty.Product__c = 'All Supplies';
            oppty.StageName = '100%-Implement';
            insert oppty;
            
            Quote quote = new Quote(name='testQuote', OpportunityId = oppty.id, Status = 'Accepted by Customer');
            insert quote;
        }
    }
}