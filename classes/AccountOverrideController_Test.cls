/*************************************************************
*Name : AccountOverrideController_Test
*Created By : Sandesh Ganjare
*Created Date : 04-17-2020
*Purpose : Test class for AccountOverrideController
*JIRA: NAIT-130081 02885348 - Lightning - Record Types Pointing to the Correct Flow.
***************************************************************/
@isTest
public with sharing class AccountOverrideController_Test {
     @TestSetup public static void setup(){
        List<User> userList = DataFactory.createUserTestRecords('Test', 1);
        
        Redirect_Profile__c customsetting = new Redirect_Profile__c();
        customsetting.Name = 'System Administrator';
        customsetting.Profile_Name__c = 'System Administrator';
        customsetting.Redirect_Page__c='Test';
        insert customsetting;                
    }
    
     static testMethod void getRecordTypeData_Method(){
        AccountOverrideController.DataWrapper data = new AccountOverrideController.DataWrapper();
        User user = [SELECT Id, Name FROM User WHERE Id =:UserInfo.getUserId()];
                  
        Test.StartTest();
            system.runAs(user){
                data = AccountOverrideController.getRecordTypeData();
            }             
        Test.StopTest();
        
        System.assertEquals(true, data.shouldRedirect);
     }
}