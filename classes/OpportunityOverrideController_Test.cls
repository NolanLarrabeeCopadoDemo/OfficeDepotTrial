/*************************************************************
*Name : OpportunityOverrideController_Test
*Created By : Himanshu Sharma
*Created Date : 04-27-2020
*Purpose : Test class for OpportunityOverrideController
*JIRA: 02903377- New Opportunity Button Pointing to Qualifying Deal Creation.
*JIRA: NAIT-131982.
***************************************************************/
@isTest
public with sharing class OpportunityOverrideController_Test {
     @TestSetup public static void setup(){
        List<User> userList = DataFactory.createUserTestRecords('Test', 1);
           
    }
    
     static testMethod void getProfileName_Method(){
        boolean shouldRedirect;
        Profile__c customsetting = new Profile__c(); 
        customsetting.Name = 'System Administrator';
        customsetting.Profile_Name__c = 'System Administrator';
        insert customsetting;
        User user = [SELECT Id, Name FROM User WHERE Id =:UserInfo.getUserId()];
                  
        Test.StartTest();
            system.runAs(user){
                shouldRedirect = OpportunityOverrideController.getCorrectProfileName();
            }             
        Test.StopTest();
        
        System.assertEquals(true, shouldRedirect);
        }
    
     static testMethod void getProfileName_Method2(){
        boolean shouldRedirect;
        User user = [SELECT Id, Name FROM User WHERE Id =:UserInfo.getUserId()];
                  
        Test.StartTest();
            system.runAs(user){
                shouldRedirect = OpportunityOverrideController.getCorrectProfileName();
            }             
        Test.StopTest();
        System.assertEquals(false, shouldRedirect);
    }
}