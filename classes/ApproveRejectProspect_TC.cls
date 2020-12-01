/**
 * Created by Najma Ateeq for Story #S-386202(OD Case Number - 00617674)
 */
@isTest
private class ApproveRejectProspect_TC 
{

    static testMethod void myUnitTest() 
    {
        createTestData();
        createTestData1();
        ApproveRejectProspect approveRejectPro = new ApproveRejectProspect();
        system.assert(approveRejectPro.ReassignList.size() > 0);
        approveRejectPro.refreshView();
        approveRejectPro.Approve();
        approveRejectPro.Reject();
        approveRejectPro.Cancel();
        approveRejectPro.getoptions();
        approveRejectPro.gettypeofView();
        
    }
    static void createTestData1()
    {
        Account acc = Test_Utils.CreateAccount();
        //acc.initial_site_flag__c = true;
        //update acc;
        Reassignment_Queue__c reassignmentQ1 = new Reassignment_Queue__c();
        //reassignmentQ.Name = 'Test';
        reassignmentQ1.Requestor__c = UserInfo.getUserId();
        reassignmentQ1.Approver__c =  UserInfo.getUserId();
        reassignmentQ1.Account__c = acc.Id;
        reassignmentQ1.status__c = 'Pending Approval';
        insert reassignmentQ1;
    }
    
    static void createTestData()
    {
        ReassignUtils ru = new ReassignUtils();
        ApproveRejectProspect apprveRejctPrspct = new ApproveRejectProspect();
        apprveRejctPrspct.typeofView = 'My App';
        Account acc = Test_Utils.CreateAccount();
        //acc.initial_site_flag__c = true;
        //update acc;
        Reassignment_Queue__c reassignmentQ = new Reassignment_Queue__c();
        //reassignmentQ.Name = 'Test';
        reassignmentQ.Requestor__c = UserInfo.getUserId();
        reassignmentQ.Account__c = acc.Id;
        reassignmentQ.status__c = 'Pending Approval';
        insert reassignmentQ;
    }
}