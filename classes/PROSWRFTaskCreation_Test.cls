@isTest
public  class PROSWRFTaskCreation_Test {
    
        
   public static testmethod void TestUpdateMethod(){
       CameleonCPQ.QxHttpCalloutMockImpl theMock = new CameleonCPQ.QxHttpCalloutMockImpl();
        Test.setMock(HttpCalloutMock.class, theMock);
        CameleonCPQ.QxHttpCalloutMockImpl.SetAsMock();
        ConstantsExt.prosWRFCreation = true;
        executeoncetest.CallAgainCase = false; 

        
        
        
        List<User> usrs = DataFactory.createUserTestRecords('SubmitDOAApprovalTest', 5);
        

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
        acc.Hosted_Catalog_Flag__c=false;
        acc.AOPS_Cust_Id__c = '1111111';

        Account acc2 = new Account();
        acc2.Name = 'Test2';
        acc2.Address1__c = 'New Testing';
        acc2.City__c = 'City Test';
        acc2.State__c = 'TMO';
        acc2.Country__c = 'USA';
        acc2.Zip__c = '12321';
        acc2.Hierarchy__c = 'P';
        acc2.RecordtypeId = parentRecordTypeId;

        
        insert new List<Account> { acc, acc2 };
        
        

        CameleonCPQ__QxSetup__c  c = new CameleonCPQ__QxSetup__c(Name='Master',CameleonCPQ__QuoteModelName__c='OfficeDepot',CameleonCPQ__MappingSetName__c='New_Written_Agreement',CameleonCPQ__LinesManagementPolicy__c=1);
        insert c;

        PROS_Access_Custom_Setting__c pacs1 = new PROS_Access_Custom_Setting__c(Name='In Review_VIEW', Profiles__c='Field Sales');
        PROS_Access_Custom_Setting__c pacs2 = new PROS_Access_Custom_Setting__c(Name='Draft_VIEW', Profiles__c='Field Sales');
        insert new List<PROS_Access_Custom_Setting__c> { pacs1, pacs2 };

        
        Id wrfRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Work Request').getRecordTypeId();
        
        Case wrf = new Case();
        wrf.WRF_Hosted_Catalog__c='Yes';
        wrf.recordtypeId = wrfRT ;
        INSERT wrf; 
        
        

Test.StartTest();
        CameleonCPQ__QxQuote__c pq = new CameleonCPQ__QxQuote__c();
        pq.Name = 'Test_Quote_1';
        pq.CameleonCPQ__AccountId__c = acc.id;
        // pq.OpportunityId__c = opp.id;
        pq.Agreement_Term__c = 1;
        pq.CDM__c = UserInfo.getUserId();
        pq.Sales_Rep__c = usrs[0].Id;
        pq.CameleonCPQ__SyncStatus__c = 'COMPLETE';
        pq.Go_Live_Date__c = system.today()-1; 
        pq.WRF__c = wrf.id;       
        pq.Compliance_Approval_Status__c='Submitted';
        pq.CameleonCPQ__Status__c='Inactive'; //CameleonCPQ__Status__c==''
        pq.Customer_Approval_Status__c = 'Rejected';
        insert pq;
        pq.Sales_Rep__c = usrs[0].Id;
        pq.DOA_Approval_Status__c = 'Approved';
        pq.CameleonCPQ__Status__c='Inactive';
        pq.Compliance_Approval_Status__c='Approved';
        update pq;
        
        
        
        
        Test.StopTest();
       
    }
}