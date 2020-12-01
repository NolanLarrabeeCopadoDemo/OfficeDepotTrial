@isTest
public class UpdateREassignmentPending_TC
{
    static testmethod void createTestData1()
    {
        Account acc = Test_Utils.CreateAccount();
        Reassignment_Queue__c reassignmentQ = new Reassignment_Queue__c();
        reassignmentQ.Approver__c =  UserInfo.getUserId();
        reassignmentQ.Account__c = acc.Id;
        reassignmentQ.status__c = 'Pending Approval';
        insert reassignmentQ;
        
        DateTime dt = DateTime.now();
        String CRON_EXP = '0 0 0 3 9 ? 2022'; 
        
        Test.startTest();
            UpdateREassignmentPending updteReassgnmntPndngObj = new UpdateREassignmentPending();
            String strQuery2 = 'select Approver__c from Reassignment_Queue__c where status__C =\'Pending Approval\' ';
            UpdateREassignmentPending updteReassgnmntPndngObj1 = new UpdateREassignmentPending(strQuery2);
            System.schedule('Assignment Batch',CRON_EXP , updteReassgnmntPndngObj1);
            String strQuery1 = '';
            UpdateREassignmentPending updteReassgnmntPndngObj2 = new UpdateREassignmentPending(strQuery1);
        Test.stopTest();

    }
}