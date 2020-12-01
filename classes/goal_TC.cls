@isTest
private class goal_TC {
     static User testUser;
	private static testMethod void goalTriggerTest() {
             testUser = Test_Utils.createTestUser('test11','999654');
              System.RunAs(testUser) {
                   coaching__c c = new coaching__c(Sales_Rep__c=testUser.id);
                   insert c;
                   goal__C g = new goal__C(Employee_ID__c='999654',Record_ID__c='unique123',Sales_Goal__c=100,Sales_Actual__c=100,Annual_Sales_Goal__c=200);
                   insert g;
              }
	}

}