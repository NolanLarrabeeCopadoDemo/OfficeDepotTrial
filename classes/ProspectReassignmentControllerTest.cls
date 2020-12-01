/*************************************************************
*Name : ProspectReassignmentControllerTest
*Created By : Himanshu Sharma
*Created Date :30-03-2020
*Purpose : Test class for ProspectReassignmentController class
*JIRA: NAIT-124929
****************************************************************/
@isTest
public with Sharing class ProspectReassignmentControllerTest {
    public static testMethod void myUnitTest() 
    {
        Test.StartTest();
        ProspectReassignmentController.AccessDataWrapper ADWObj= New ProspectReassignmentController.AccessDataWrapper();
        ADWObj.pageAccess=True;
        ADWObj.adminAccess= true;
        ProspectReassignmentController.AccessDataWrapper ADWObj1=ProspectReassignmentController.getAccessAllowed();
        System.assert(ADWObj1 != null);       
        Test.StopTest();
    }
}