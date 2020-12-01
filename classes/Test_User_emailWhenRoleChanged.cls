/*************************************************************
*Name : Test_User_emailWhenRoleChanged 
*Created By : Akash (Appirio Off)
*Created Date : 12th October,2011
*Purpose : Test User_emailWhenRoleChanged Trigger
****************************************************************/
@isTest
private class Test_User_emailWhenRoleChanged {
  
  //Invoke the User_email role changed, trigger,
  //cannot assert anything, as test code cannot verify that email sending
  @isTest
  private static void test_RoleChange() {
    Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
    User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='123355',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='89990@proxy456.com');
    insert u1;
    System.runAs(u1)
    {
        // Create 2 test users to change manager    
        User mgr1 = Test_Utils.createTestUser('Mgr01', '070707');
        User mgr2 = Test_Utils.createTestUser('Mgr02', '060606');
        
        //Normal execution mode
        User user = Test_Utils.CreateUser();
        user.isRoleChanged__c = true;
        user.od_employee_id__c = '010101';
        user.TimeZoneSidKey = 'America/Los_Angeles';
        user.managerid = mgr1.id;
        user.localesidkey='en_US';
        user.emailencodingkey='UTF-8';
        user.languagelocalekey='en_US';
        update user;
        
        //Change title and manager for a user
        user.managerid = mgr2.id;
        user.title = 'TDM';
        user.isRoleChanged__c = false;
        update user;
    
        //Change title and manager for a manager
        //mgr2.managerid = mgr1.id;
        //mgr2.title = 'DSM';
        //mgr2.isRoleChanged__c = true;
        //update mgr2;    
    }        
  }   
}