/**
 * Created by Najma Ateeq for Story #S-386202(OD Case Number - 00617674)
 */
@isTest
private class beforeTriggerReassignmentQueue_TC {

    static testMethod void myUnitTest() {
        createTestData();
    }
    static void createTestData(){
        Account acc = Test_Utils.createAccount();
        Reassignment_Queue__c reQ = new Reassignment_Queue__c();
        reQ.Autoapprove7thDay__c = true;
        reQ.Account__c = acc.Id;
        insert reQ;
        update reQ;
    }
}