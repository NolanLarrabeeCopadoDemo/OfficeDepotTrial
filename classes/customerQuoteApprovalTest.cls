@isTest
public class customerQuoteApprovalTest {
    @isTest
    private static void testData(){
        RecordType rtCust   = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Customer'];
        RecordType rtSite   = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Site'];
        
        Account acc = new Account();
        acc.Name='Test Acc';
        acc.RecordtypeId=rtCust.Id;
        insert acc;
        
        Account siteAcc1     = new Account(Name='Siteacc1', RecordtypeId=rtSite.Id, related_Account__c=acc.id);
        Account siteAcc2     = new Account(Name='Siteacc2', RecordtypeId=rtSite.Id, related_Account__c=acc.id);
        List<Account> accounts   = new List<Account>{ siteAcc1, siteAcc2 };
            insert accounts;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.name = 'testOpp';
        opp.status__c = 'open';
        opp.stagename = 'Qualify';
        opp.CloseDate = System.today().adddays(100);
        insert opp;
        
        Quote q=new Quote(Name = 'testQillBill');
        q.name = 'testQillBill';
        q.OpportunityId= opp.Id;
        q.Quote_Id__c = '112233';
        q.Bill_To_Account__c = siteAcc1.Id;
        q.ship_to_account__c=siteAcc2.Id;
        insert q;
        
        Customer_Approval_EA__c cstmrAprvl = new Customer_Approval_EA__c();
        cstmrAprvl.ParentQuote__c = q.Id;
        cstmrAprvl.Content_Document_URL__c='www.testpainting.com';
        insert cstmrAprvl;
    }
    @isTest
    private static void testgetQuoteDocument() {
        testdata();
        Quote q = [Select Id from Quote where Name = 'testQillBill' LIMIT 1];
        Customer_Approval_EA__c cstmrAprvl  = [select id,Content_Document_URL__c from Customer_Approval_EA__c where ParentQuote__c =: q.Id];
        customerQuoteApproval.getQuoteDocument(String.valueOf(cstmrAprvl.Id));
    }
    @isTest
    private static void testapprovalHelper() {
        testdata();
        Quote q = [Select Id from Quote where Name = 'testQillBill' LIMIT 1];
        Customer_Approval_EA__c cstmrAprvl  = [select id,Content_Document_URL__c from Customer_Approval_EA__c where ParentQuote__c =: q.Id];
        customerQuoteApproval.approvalHelper(String.valueOf(cstmrAprvl.Id), false , 'approving as i love office depot');
    }
    @isTest
    private static void testrejectHelper() {
        testdata();
        Quote q = [Select Id from Quote where Name = 'testQillBill' LIMIT 1];
        Customer_Approval_EA__c cstmrAprvl  = [select id,Content_Document_URL__c from Customer_Approval_EA__c where ParentQuote__c =: q.Id];
        customerQuoteApproval.rejectHelper(String.valueOf(cstmrAprvl.Id), 'rejecting, want a new one');
    }
    @isTest
    private static void testmoreInfoHelper() {
        testdata();
        Quote q = [Select Id from Quote where Name = 'testQillBill' LIMIT 1];
        Customer_Approval_EA__c cstmrAprvl  = [select id,Content_Document_URL__c from Customer_Approval_EA__c where ParentQuote__c =: q.Id];
        customerQuoteApproval.moreInfoHelper(String.valueOf(cstmrAprvl.Id), 'wait,what?!Send me some more information');
    }
    @isTest
    private static void testsaveFile() {
        testdata();
        Quote q = [Select Id from Quote where Name = 'testQillBill' LIMIT 1];
        Customer_Approval_EA__c cstmrAprvl  = [select id,Content_Document_URL__c from Customer_Approval_EA__c where ParentQuote__c =: q.Id];
        customerQuoteApproval.saveFile(cstmrAprvl.Id, 'Awesome,I love the quote', 'TestFileDoc', true);
    }
}