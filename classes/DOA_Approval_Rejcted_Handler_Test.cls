@istest
public class DOA_Approval_Rejcted_Handler_Test {
    static void makeData() {
        List<User> usrs = DataFactory.createUserTestRecords('SubmitDOAApprovalTest', 5);
        usrs[0].Job_Code_Level__c = 'Manager';
        usrs[1].Job_Code_Level__c = 'Director';
        usrs[2].Job_Code_Level__c = 'Senior Director';
        usrs[3].Job_Code_Level__c = 'VP';
        usrs[4].Job_Code_Level__c = 'SVP';
        usrs[0].ManagerId = usrs[1].Id;
        usrs[1].ManagerId = usrs[2].Id;
        usrs[2].ManagerId = usrs[3].Id;
        usrs[3].ManagerId = usrs[4].Id;
        update usrs;

        Id Prospect_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id parentRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
       
        Account acc = new Account();
        acc.Name = 'Test';
        acc.Address1__c = 'New Testing';
        acc.City__c = 'City Test';
        acc.State__c = 'TMO';
        acc.Country__c = 'USA';
        acc.Zip__c = '12321';
        acc.RecordtypeId = Prospect_RecordTypeId;

        Account acc2 = new Account();
        acc2.Name = 'Test2';
        acc2.Address1__c = 'New Testing';
        acc2.City__c = 'City Test';
        acc2.State__c = 'TMO';
        acc2.Country__c = 'USA';
        acc2.Zip__c = '12321';
        acc2.Hierarchy__c = 'P';
        acc2.RecordtypeId = parentRecordTypeId;

        Account acc3 = new Account();
        acc3.Name = 'Test3';
        acc3.Address1__c = 'New Testing';
        acc3.City__c = 'City Test';
        acc3.State__c = 'TMO';
        acc3.Country__c = 'USA';
        acc3.Zip__c = '12321';
        acc3.Hierarchy__c = 'P';
        acc3.RecordtypeId = parentRecordTypeId;
        insert new List<Account> { acc, acc2, acc3 };
        
        // Opportunity opp = new Opportunity();
        // opp.name = 'Test';
        // opp.AccountId = Acc.Id;
        // opp.StageName = 'Closed Won';
        // opp.CloseDate = date.today();
        // opp.Type = 'New Customers';
        // insert opp;

        CameleonCPQ__QxSetup__c  c = new CameleonCPQ__QxSetup__c(Name='Master',CameleonCPQ__QuoteModelName__c='OfficeDepot',CameleonCPQ__MappingSetName__c='New_Written_Agreement',CameleonCPQ__LinesManagementPolicy__c=1);
        insert c;

        PROS_Access_Custom_Setting__c pacs1 = new PROS_Access_Custom_Setting__c(Name='In Review_VIEW', Profiles__c='Field Sales');
        PROS_Access_Custom_Setting__c pacs2 = new PROS_Access_Custom_Setting__c(Name='Draft_VIEW', Profiles__c='Field Sales');
        insert new List<PROS_Access_Custom_Setting__c> { pacs1, pacs2 };

        DOA_Approval_Paremeters__c doaApprovalParameters = new DOA_Approval_Paremeters__c();
        doaApprovalParameters.CPD_Director__c = UserInfo.getUserId();
        doaApprovalParameters.CBFS_Director__c = UserInfo.getUserId();
        doaApprovalParameters.EVP__c = UserInfo.getUserId();
        doaApprovalParameters.CFO__c = UserInfo.getUserId();
        doaApprovalParameters.Sales_Threshold_1__c = 250000;
        doaApprovalParameters.Sales_Threshold_2__c = 3000000;
        doaApprovalParameters.Sales_Threshold_3__c = 5000000;
        doaApprovalParameters.Sales_Threshold_4__c = 10000000;
        insert doaApprovalParameters;
        
        CameleonCPQ__QxQuote__c pq = new CameleonCPQ__QxQuote__c();
        pq.Name = 'Test_Quote_1';
        pq.CameleonCPQ__AccountId__c = acc.id;
        // pq.OpportunityId__c = opp.id;
        pq.Agreement_Term__c = 1;
        pq.CDM__c = UserInfo.getUserId();
        pq.Sales_Rep__c = usrs[0].Id;
        pq.CameleonCPQ__SyncStatus__c = 'COMPLETE';
        pq.DOA_Approval_Status__c = 'Approval Submitted	';
        pq.CameleonCPQ__Status__c='Approved Internally';
        insert pq;
        //pq.Sales_Rep__c = usrs[0].Id;
       
        //pq.DOA_Approval_Status__c = 'Approved';
        //update pq;

        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for approval.');
        req1.setObjectId(pq.id);        
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(pq.ownerId);    
        
        //Submit the record to specific process and skip the criteria evaluation
        req1.setProcessDefinitionNameOrId('CPM_Approvals_LF');
        req1.setSkipEntryCriteria(true);
        

        // Submit the approval request for the account
        Approval.ProcessResult result = Approval.process(req1); 
        
    }

    public static testmethod void TestUpdateMethod(){
        //Test.setMock(QxCCoreIdCallOutMock.class, new QxCCoreIdCallOutMock()); 
        CameleonCPQ.QxHttpCalloutMockImpl theMock = new CameleonCPQ.QxHttpCalloutMockImpl();
        Test.setMock(HttpCalloutMock.class, theMock);
        CameleonCPQ.QxHttpCalloutMockImpl.setAsMock();
        
        Test.StartTest();
        makeData();
        Test.StopTest();
    }
}