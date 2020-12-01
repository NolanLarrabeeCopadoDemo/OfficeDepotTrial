/*************************************************************
*Name : AssignmentProspectControllerTest
*Created By : Sandesh Ganjare
*Created Date :30-03-2020
*Purpose : Test class for AssignmentProspectController.
*JIRA: NAIT-124929
****************************************************************/
@isTest
public with sharing class AssignmentProspectControllerTest {
    @TestSetup public static void setup(){
        List<User> userList = DataFactory.createUserTestRecords('Test', 1);
        Recordtype rcd =  [select id from recordtype where name = 'Prospect'];
        system.runAs(userList[0])
        {
            Sales_Person__c salesPerson = new Sales_Person__c();
            salesPerson.Role_Relate_Id__c='012100';
            salesPerson.OwnerId = userList[0].id;
            INSERT salesPerson ;

            List<Account> accountList = DataFactory.createAccountTestRecords('Test acc', 5, '');
            accountList[0].Oracle_Party_Id__c = '123456';           
            accountList[0].OwnerId=userList[0].id;
            accountList[0].recordtypeid = rcd.id;
            accountList[0].Industry_OD_SIC_Rep__c = 'Accounting';
            accountList[0].Org_WCW_Count_DB__c =11112234;
            accountList[0].Org_WCW_Count_Rep__c = 55 ;
            accountList[0].ZIP__C = '111111';
            accountList[0].AccountNumber ='223112';
            accountList[0].Sales_PersonID__c = salesPerson.id; //Sales person Id for the Salesforce USer

            UPDATE accountList;

            Reassignment_Queue__c rq = new Reassignment_Queue__c();
            rq.Account__c = accountList[0].id;
            rq.Requestor__c = userList[0].id;
            rq.New_Owner__c = userList[0].id;
            rq.Approver__c = userList[0].id;
            rq.Status__c = 'Pending Approval';
            rq.Approve_Reject_Date__c= system.now();
            INSERT rq;
        }                
    }

    Static testMethod void Search_Method(){
        AssignmentProspectController.ReassignDataWrapper data = new AssignmentProspectController.ReassignDataWrapper();
        User user = [SELECT Id, Name FROM User WHERE Id =:UserInfo.getUserId()];
                  
        Test.StartTest();
            system.runAs(user){
                data = AssignmentProspectController.Search('Test acc', '', '','111111,111112','','','50-99','', '','', 0);
            }             
        Test.StopTest();
        
        System.assertEquals(true, data != null);
     }

     Static testMethod void Reassign_Method(){
        AssignmentProspectController.ReassignDataWrapper data = new AssignmentProspectController.ReassignDataWrapper();
        User user = [SELECT Id, Name FROM User WHERE Id =:UserInfo.getUserId()];
        Account account = [SELECT Id, Name FROM Account LIMIT 1];  
        String str = '[{"id": "' + String.ValueOf(account.id) + '"}]';               
        Test.StartTest();
            system.runAs(user){
                data = AssignmentProspectController.Reassign('Test acc', '', '','111111,111112','','','50-99','', '','',String.ValueOf(user.id),str, 0);
            }             
        Test.StopTest();
        
        System.assertEquals(true, data != null);
     }

     Static testMethod void ReassignAll_Method(){
        AssignmentProspectController.ReassignDataWrapper data = new AssignmentProspectController.ReassignDataWrapper();
        User user = [SELECT Id, Name FROM User WHERE Id =:UserInfo.getUserId()];
                  
        Test.StartTest();
            system.runAs(user){
                data = AssignmentProspectController.ReassignAll('Test acc', '', '','111111,111112','','','50-99','', '','',String.ValueOf(user.id), 0);
            }             
        Test.StopTest();
        
        System.assertEquals(true, data != null);
     }
   
}