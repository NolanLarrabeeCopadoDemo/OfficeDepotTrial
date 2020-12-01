@isTest
private class GT_TestDataUtility_TC 
{

    static testMethod void myUnitTest() 
    {
         System.runas(new user(ID = UserInfo.getUserID())){
    User u1 = GT_TestDataUtility.getTestUser('System Administrator','aaa@officedepot.com','227112');
    Sales_Person__c sp1 = GT_TestDataUtility.getSalesPerson(u1,'333333');
    Account acc1 = GT_TestDataUtility.getTestAccount(u1,'123456');
    User u2 = GT_TestDataUtility.getTestUser('System Administrator','aaab@officedepot.com','227113');
    Sales_Person__c sp2 = GT_TestDataUtility.getSalesPerson(u2,'444444');
    Account acc2 = GT_TestDataUtility.getTestAccount(u2,'123654');
    }
    }
    
}