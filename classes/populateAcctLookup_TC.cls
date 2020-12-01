/**
 * Created by Najma Ateeq - not to be deployed since populateAcctLookup does not exist on prod.
 */
@isTest
private class populateAcctLookup_TC {

    static testMethod void myUnitTest() {
        createTestData();
    }
    static void createTestData(){
    	Account acc = Test_Utils.CreateAccount();
    	Reassignment_Queue__c reQ = new Reassignment_Queue__c();
    	reQ.Account__c = acc.Id;
    	insert reQ;
    }
}