/***********************************************************************************************
Name    : RepQueueAssignmentController_TC
VF Page : RepQueueAssignment
Created : 8/31/2015 [Hemant]
Story   : S-346407
Desc    : Test class for the class "RepQueueAssignmentController"
***********************************************************************************************/
@isTest
private class RepQueueAssignmentController_TC
{

 //added for S-429673
 @testSetup
 static void allTheDataForThisTestClass() {
     createTestData();
 }//end S-429673
 
  //Modified for S-429672
  //test method
  static testMethod void RQAControllerTest(){

    Test.startTest();
    RepQueueAssignmentController RQACont = new RepQueueAssignmentController();
    RepQueueAssignmentController.RepQueueAssignmentCls rqaC = RQACont.repAssignWrapper.get(0);
    rqaC.repQueAssignmentLst.get(0).Priority__c = '2';
    RQACont.save();
    RQACont.cancel();
    
    //added for S-429673
    List<Integer> linkList = RQACont.listOfLinks;
    Boolean isMoreNext =   RQACont.isMoreNext ;
    Boolean isMorePrevious =   RQACont.isMorePrevious ;
    Integer totalPage1 =   RQACont.totalPage;
    RQACont.getList();
    
    //end S-429673
    Test.stopTest();
  } //End S-429672

  //create Test data
  private static void createTestData(){
    //insert user for sales rep having role like %Rep%
    User testRepUser = Test_Utils.createTestUser('Tst','112233');
    for(UserRole usrRole : [Select Id From UserRole
                             Where Name LIKE '%Rep%' Limit 1]){
        testRepUser.UserRoleId = usrRole.Id;
    }
    testRepUser.ManagerId = UserInfo.getUserId();
    insert testRepUser;

    System.RunAs(testRepUser){
        //insert RQA
        Rep_Queue_Assignment__c rqa = new Rep_Queue_Assignment__c();
        rqa.Sales_Rep__c = testRepUser.Id;
          rqa.Priority__c = '3';
          rqa.Queue_Name__c = 'Government Leads';
          insert rqa;
          System.assertNotEquals(rqa, null);
    }
  }

}