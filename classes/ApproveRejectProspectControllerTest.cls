/*************************************************************
*Name : ProspectReassignmentControllerTest
*Created By : Himanshu Sharma
*Created Date :31-03-2020
*Purpose : Test class for ProspectReassignmentController class
*JIRA: NAIT-124929
****************************************************************/
@isTest
public class ApproveRejectProspectControllerTest {
    
    public static testMethod void testApproveRejectProspectController() 
    {
        list<Account> acclist = new list<Account>();
        Account acc = new Account();
        acc.OwnerId=UserInfo.getUserId();
        acc.name='test1';
        acc.Primary_Site__c = true;
        acclist.add(acc);
        insert acclist;
        
        Reassignment_Queue__c rq = new Reassignment_Queue__c();
        rq.Account__c = acc.id;
        rq.Requestor__c = UserInfo.getUserId();
        rq.New_Owner__c = UserInfo.getUserId();
        rq.Approver__c = UserInfo.getUserId();
        rq.Status__c = 'Pending Approval';
        rq.Approve_Reject_Date__c= system.now();
        insert rq;
        
        Test.StartTest();
        
        List<ApproveRejectProspectController.ApproveRejectWrapper> lstwrap1 = ApproveRejectProspectController.getApproveRejectData('My Approvals');
        system.assertEquals(lstwrap1[0].id, rq.Id);
        List<ApproveRejectProspectController.ApproveRejectWrapper> lstwrap2 = ApproveRejectProspectController.getApproveRejectData('');
        system.assertEquals(lstwrap2[0].id, rq.Id);
        
        ApproveRejectProspectController.ApproveRejectWrapper objwrapper = new ApproveRejectProspectController.ApproveRejectWrapper();
        objwrapper.id = rq.Id;
        objwrapper.Reassignment_Queue = rq;
        list<ApproveRejectProspectController.ApproveRejectWrapper> lstwrapper = new list<ApproveRejectProspectController.ApproveRejectWrapper>();
        lstwrapper.add(objwrapper);
        
        ApproveRejectProspectController.ResponseWrapper wrap1 = ApproveRejectProspectController.ProcessRecords('A', JSON.serialize(lstwrapper));
        ApproveRejectProspectController.ResponseWrapper wrap2 = ApproveRejectProspectController.ProcessRecords('', JSON.serialize(lstwrapper));
        
        Test.StopTest();
    }

}