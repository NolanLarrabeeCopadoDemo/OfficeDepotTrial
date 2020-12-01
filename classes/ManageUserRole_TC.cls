/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@istest
private class ManageUserRole_TC
{

    static testMethod void TestManageUserRole() 
    {
        
     Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
     User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='894524',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='pr78y@proxy456.com',isactive=true);
     insert u1;     
        
                 
        Test.startTest();
        ManageUserRole testObject = new ManageUserRole(); 
        testObject.ChgRoleVal();
        testObject.getUserActivitiesData();
        testObject.allUserRole();
        
        for (ManageUserRole.UserActivityData  MU:testObject.userDataList)
        {
            MU.isRoleSelected  =true;
        }
        testObject.ChgRole();
        testObject.ChgFlag();
        testObject.cancelRlchg();
        Test.stopTest();  
    }
}