/**
* @author Rajendra Shahane, rajendra.shahane@officedepot.com
* @date 09/16/2020
*
* 
* @description This test class for marketing360GMILController
*              
*               related class => marketing360GMILController class
* Created for JIRA: NAIT-148002 03049086 - Display Marketing Data in Customer 360/GMIL
*/
@isTest
public class marketing360GMILController_Test {
    
     @TestSetup public static void setup()
     {
        Account acc3 = new Account();
        acc3.Name='TestAcc1';
        acc3.Aops_seq_id__c='75638474-111';
         acc3.AOPS_Cust_ID__c = '75638474';
        insert acc3;

        contact c = new contact();
        c.AccountId = acc3.ID;
        c.LastName = 'Smith';
        c.AOPS_Contact_Number__c = '111111111';
        c.Override_Duplicate_Check__c = true;
        c.Email_1_AOPS_Seq__c='663282';
        c.Title = 'Office Supply Buyer';
        c.Primary_Contact__c = false;
        c.AOPS_Role__c = 'SLS';
        c.Authorized_Buyer__c = 'Y';
        c.Status__c = 'Active';
        c.Email = 'test@test.com';
        insert c;
        
        Lead ld = new Lead(LastName='test', Company='test', Zip__c='11111');
        insert ld;
        
        et4ae5__Automated_Send__c at = new et4ae5__Automated_Send__c();
        at.et4ae5__Active__c = true;
        at.et4ae5__Subscribed_For_Tracking__c = true;
        at.Name = 'Email One (Retention-EMAIL 1 - 0913a2b12f7146bda13959139f0b03eb';
        at.et4ae5__EmailName__c = 'Email One (Retention-EMAIL 1 )';
        insert at;
        
        et4ae5__IndividualEmailResult__c et = new et4ae5__IndividualEmailResult__c();
        et.et4ae5__FromAddress__c = 'test@test.com';
        et.Name = 'SFMC Email Preview Sample';
        et.et4ae5__Contact__c = c.id;
        et.et4ae5__TriggeredSendDefinition__c = at.id;
        insert et;
    }
    
    @isTest
    public static void getContactDetailsTest()
    {
        list<Account> lstAcc = [select Id,AOPS_Cust_ID__c from Account where Name='TestAcc1' limit 1];
        test.startTest();
        Map <String,list<et4ae5__IndividualEmailResult__c>> mapContactEmailRes = marketing360GMILController.getContactDetails(lstAcc[0].Id);
        test.stopTest();
        System.assertEquals(true,mapContactEmailRes.size()>0);
    }
    
    @isTest
    public static void searchContactDetailsTest()
    {
        list<contact> lstCon = [select Id,Name,AccountId,Account.AOPS_Cust_ID__c from contact where Account.Name='TestAcc1' limit 1];
        test.startTest();
        Map <String,list<et4ae5__IndividualEmailResult__c>> mapContactEmailRes = marketing360GMILController.searchContactDetails(lstCon[0].AccountId,lstCon[0].Name);
        test.stopTest();
        System.assertEquals(true,mapContactEmailRes.size()>0);
    }
}