@isTest
public class RequestforQuoteUpdate_Ctrl_TC {
    
    @TestSetup
    static void makeData() {
        
	Account masterAccount = new Account(Name='master account'); 
        masterAccount.Sharing_Group__c = 'Master Account Share'; 
        insert masterAccount;
        Recordtype custAccRT = [Select id, Sobjecttype from recordtype where name = 'Customer' and Sobjecttype = 'Account']; 
        Account account1 = new Account(Name='Test Account');
        account1.RecordTypeId = custAccRT.Id; 
        account1.ParentId = masterAccount.Id; 
        insert account1; 
        
        Contact con = new Contact(LastName='userName', AccountId = account1.Id);
        insert con; 
        
        Contact con2 = new Contact(LastName='userName2', AccountId = account1.Id);
        insert con2; 
        

        Opportunity opp1 = new Opportunity(); 
        opp1.Name = 'Test';   
        opp1.Product__c = 'Furniture - Catalog';
        opp1.StageName = 'Prospecting'; 
        opp1.CloseDate = Date.today().addDays(1);
        opp1.AccountId = account1.Id;
        opp1.Amount=10000000;
        opp1.Primary_Competitor1_DonotInUse__c = 'comp1';
        //system.debug('opp '+ opp1);
        insert opp1;
        
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
        pq.OpportunityId__c = opp1.id;
        pq.Agreement_Term__c = 1;
        pq.CDM__c = UserInfo.getUserId();
        pq.CameleonCPQ__SyncStatus__c = 'COMPLETE';
        
        insert pq;
    }
    
    @isTest
    public static void testmethod1(){
        
        makeData();
        CameleonCPQ__QxQuote__c testQuote1 = [select id from CameleonCPQ__QxQuote__c LIMIT 1];
        //insert testQuote1;
        
       	QxQuote_Note__c testQuoteN = new QxQuote_Note__c(QxQuote__c = testQuote1.Id);
        insert testQuoteN;
        PageReference pageRef = Page.RequestforQuoteUpdate;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id',testQuote1.id);
        
        Test.startTest();
		
		ApexPages.StandardController con1 = new ApexPages.StandardController(testQuote1);
		RequestforQuoteUpdate_Ctrl mycon = new RequestforQuoteUpdate_Ctrl(con1);
		mycon.RequestforQuoteUpdate();
		Test.stopTest();


    }
    
    @isTest
    public static void testmethod2(){
        
        makeData();
        CameleonCPQ__QxQuote__c testQuote1 = [select id from CameleonCPQ__QxQuote__c LIMIT 1];
        //insert testQuote1;
        
       	QxQuote_Note__c testQuoteN = new QxQuote_Note__c(QxQuote__c = testQuote1.Id);
        insert testQuoteN;
        
        Test.startTest();
		
		ApexPages.StandardController con1 = new ApexPages.StandardController(testQuote1);
		RequestforQuoteUpdate_Ctrl mycon = new RequestforQuoteUpdate_Ctrl(con1);
		RequestforQuoteUpdate_Ctrl.RequestforQuoteUpdate(testQuote1.Id,'Test','Test');
		Test.stopTest();


    }
    
    @isTest
    public static void testmethod3(){
        
        makeData();
        CameleonCPQ__QxQuote__c testQuote1 = [select id from CameleonCPQ__QxQuote__c LIMIT 1];
        //insert testQuote1;
        
       	QxQuote_Note__c testQuoteN = new QxQuote_Note__c(QxQuote__c = testQuote1.Id);
        insert testQuoteN;
        
        Test.startTest();
		
		ApexPages.StandardController con1 = new ApexPages.StandardController(testQuote1);
		RequestforQuoteUpdate_Ctrl mycon = new RequestforQuoteUpdate_Ctrl(con1);
		RequestforQuoteUpdate_Ctrl.Onload(testQuote1.Id);
        RequestforQuoteUpdate_Ctrl.Onload(null);
		Test.stopTest();


    }
}