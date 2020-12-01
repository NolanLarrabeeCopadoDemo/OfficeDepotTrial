@isTest
public class lwcCustomLookupControllerTest {
    public static testMethod void testlwcCustomLookupController() 
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
        
        String lstResult = lwcCustomLookupController.getResults('Account', 'Name', 'test1');
        List<lwcCustomLookupController.LookupResult> data =  (List<lwcCustomLookupController.LookupResult>)JSON.deserialize(lstResult, List<lwcCustomLookupController.LookupResult>.class);
        system.assertEquals(data[0].recordId, acclist[0].Id);
        
        Test.StopTest();
    }
}