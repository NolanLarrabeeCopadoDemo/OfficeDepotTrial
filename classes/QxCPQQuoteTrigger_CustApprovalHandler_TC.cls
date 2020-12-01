@isTest
public class QxCPQQuoteTrigger_CustApprovalHandler_TC {
    private static Account account1;
    private static Opportunity opp1;
    private static QxCPQQuoteTriggerHandler handler;
    
    private static void init(){
        Account masterAccount = new Account(Name='master account'); 
        masterAccount.Sharing_Group__c = 'Master Account Share'; 
        insert masterAccount; 
        
        Recordtype custAccRT = [Select id, Sobjecttype from recordtype where name = 'Customer' and Sobjecttype = 'Account']; 
        account1 = new Account(Name='Test Account');
        account1.RecordTypeId = custAccRT.Id; 
        account1.ParentId = masterAccount.Id; 
        insert account1; 
        
        Contact con = new Contact(LastName='userName', AccountId = account1.Id);
        insert con; 
        
        Contact con2 = new Contact(LastName='userName2', AccountId = account1.Id);
        insert con2; 
        

        opp1 = new Opportunity(); 
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

        PROS_Access_Custom_Setting__c pacs1 = new PROS_Access_Custom_Setting__c(Name='In Review_VIEW', Profiles__c='Field Sales');
        PROS_Access_Custom_Setting__c pacs2 = new PROS_Access_Custom_Setting__c(Name='Draft_VIEW', Profiles__c='Field Sales');
        insert new List<PROS_Access_Custom_Setting__c> { pacs1, pacs2 };

    }
    
  /*  static TestMethod void test_handleBeforeInsert_primaryQuote_1(){
        init();
        Test.startTest(); 
        
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',OpportunityId__c=opp1.Id);
        insert testQuote1;
        CameleonCPQ__QxQuote__c resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
        System.assertEquals(true, resultTestQuote1.Primary_Quote__c, 'Primary Quote Flag should be checked');

        CameleonCPQ__QxQuote__c testQuote2 = new CameleonCPQ__QxQuote__c(Name='TEST 2',OpportunityId__c=opp1.Id);
        insert testQuote2;
        resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
        System.assertEquals(true, resultTestQuote1.Primary_Quote__c, 'Primary Quote Flag should be checked');
        CameleonCPQ__QxQuote__c resultTestQuote2 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote2.Id];
        System.assertEquals(false, resultTestQuote2.Primary_Quote__c, 'Primary Quote Flag should be unchecked');
        
        CameleonCPQ__QxQuote__c testQuote3 = new CameleonCPQ__QxQuote__c(Name='TEST 3',OpportunityId__c=opp1.Id, Primary_Quote__c=true);
        insert testQuote3;        
        resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
        System.assertEquals(false, resultTestQuote1.Primary_Quote__c, 'Primary Quote Flag should be unchecked');
         resultTestQuote2 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote2.Id];
        System.assertEquals(false, resultTestQuote2.Primary_Quote__c, 'Primary Quote Flag should be unchecked');
        CameleonCPQ__QxQuote__c resultTestQuote3 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote3.Id];
        System.assertEquals(true, resultTestQuote3.Primary_Quote__c, 'Primary Quote Flag should be checked');


        
        Test.stopTest();
    }
    
    static TestMethod void test_handleBeforeInsert_primaryQuote_2(){
        init();
        Test.startTest(); 
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',OpportunityId__c=opp1.Id,CameleonCPQ__Status__c='Accepted');
        insert testQuote1;
        CameleonCPQ__QxQuote__c resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
        System.assertEquals(true, resultTestQuote1.Primary_Quote__c, 'Primary Quote Flag should be checked');

        Boolean expectedExceptionThrown = false;
        try{
            CameleonCPQ__QxQuote__c testQuote2 = new CameleonCPQ__QxQuote__c(Name='TEST 3',OpportunityId__c=opp1.Id, Primary_Quote__c=true);
            insert testQuote2;      
            throw new MyException('An exception should have been thrown, cannot insert primary quote');
        }catch(Exception e){
            expectedExceptionThrown =  e.getMessage().contains(QxCPQQuoteHelper.ERROR_MSG_FLAG_WITH_ACCEPTED_PRIMARY_QUOTE) ? true : false;           
        }finally{
            System.AssertEquals(expectedExceptionThrown, true);
        }

        
        Test.stopTest();
    }
*/    
    static TestMethod void test_handleBeforeUpdate_primaryQuote_1(){
        init();
        Test.startTest(); 
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',OpportunityId__c=opp1.Id);
        testQuote1.Customer_AutoApproval__c= false;
        testQuote1.Customer_Approval_Status__c='Requested to be Contacted';
        testQuote1.Customer_Approval_1st_reminder__c = false;
        testQuote1.Customer_Approval_2nd_reminder__c = false;
        testQuote1.Send_for_Customer_Approval__c     = false;
        //testQuote1.Customer_approval_is_received__c=true;       
        testQuote1.Customer_approval_is_received__c='Approved';     //Reverted Changes as part of SR-02481388
        testQuote1.Customer_Approval_Received_Date__c=System.today();
        insert testQuote1;
        //testQuote1.Customer_Approval_Status__c='Approved';
        //update testQuote1;
        CameleonCPQ__QxQuote__c testQuote2 = new CameleonCPQ__QxQuote__c(Name='TEST 2',OpportunityId__c=opp1.Id);
        insert testQuote2;         
        CameleonCPQ__QxQuote__c resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
        //System.assertEquals(true, resultTestQuote1.Primary_Quote__c, 'Primary Quote Flag should be checked');
        CameleonCPQ__QxQuote__c resultTestQuote2 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote2.Id];
        //System.assertEquals(false, resultTestQuote2.Primary_Quote__c, 'Primary Quote Flag should be unchecked');
        
        //Flag  2nd quote a primary
        testQuote2.Primary_Quote__c = true;
        update testQuote2;
        resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
        //System.assertEquals(false, resultTestQuote1.Primary_Quote__c, 'Primary Quote Flag should be unchecked');
        resultTestQuote2 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote2.Id];
        //System.assertEquals(true, resultTestQuote2.Primary_Quote__c, 'Primary Quote Flag should be checked');
        
        
        //Try to unflag a quote
        Boolean expectedExceptionThrown = false;
        try{
            testQuote2.Primary_Quote__c = false;
            update testQuote2;  
            throw new MyException('An exception should have been thrown, cannot insert primary quote');
        }catch(Exception e){
            expectedExceptionThrown =  e.getMessage().contains(QxCPQQuoteHelper.ERROR_MSG_UNFLAG_PRIMARY_QUOTE) ? true : false;           
        }finally{
            System.AssertEquals(expectedExceptionThrown, false);
        }
        

        Test.stopTest();
    }
    
    static TestMethod void test_handleBeforeUpdate_primaryQuote_2(){
        init();
        Test.startTest(); 
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',OpportunityId__c=opp1.Id,CameleonCPQ__Status__c='Accepted');
        insert testQuote1;
        CameleonCPQ__QxQuote__c testQuote2 = new CameleonCPQ__QxQuote__c(Name='TEST 2',OpportunityId__c=opp1.Id);
        insert testQuote2;         
        CameleonCPQ__QxQuote__c resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
        System.assertEquals(false, resultTestQuote1.Primary_Quote__c, 'Primary Quote Flag should be checked');
        CameleonCPQ__QxQuote__c resultTestQuote2 = [SELECT Id,Name,Primary_Quote__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote2.Id];
        System.assertEquals(false, resultTestQuote2.Primary_Quote__c, 'Primary Quote Flag should be unchecked');
        
        
        //Try to flag a quote with another accepted primary quote
        Boolean expectedExceptionThrown = false;
        try{
            testQuote2.Primary_Quote__c = true;
            update testQuote2;  
            throw new MyException('ERROR_MSG_FLAG_WITH_ACCEPTED_PRIMARY_QUOTE');
        }catch(Exception e){
            expectedExceptionThrown =  e.getMessage().contains(QxCPQQuoteHelper.ERROR_MSG_FLAG_WITH_ACCEPTED_PRIMARY_QUOTE) ? true : false;           
        }finally{
            System.AssertEquals(expectedExceptionThrown, false);
        }
        
        Test.stopTest();
    }
    
/*    static TestMethod void test_handleBeforeInsert_AccountLookUp_1(){
        init();
        Test.startTest(); 
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',OpportunityId__c=opp1.Id,CameleonCPQ__Status__c='Accepted');
        insert testQuote1;   
        CameleonCPQ__QxQuote__c resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c,CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
        System.assertEquals(account1.Id, resultTestQuote1.CameleonCPQ__AccountId__c, 'Wrong Account Lookup at Quote Level');
 
        Test.stopTest();
    }    
    */
    static TestMethod void test_handleAfterupdate_AccountLookUp_1(){
        init();
        List<User> usrs = [Select id from User Limit 10];
        Test.startTest(); 
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',OpportunityId__c=opp1.Id,CameleonCPQ__Status__c='Accepted');
        testQuote1.Customer_AutoApproval__c= false;
        testQuote1.Customer_Approval_Status__c='Submitted';
        testQuote1.Customer_Approval_1st_reminder__c = false;
        testQuote1.Customer_Approval_2nd_reminder__c = false;
        testQuote1.Send_for_Customer_Approval__c     = false;
        //testQuote1.Customer_approval_is_received__c=true;       
        testQuote1.Customer_approval_is_received__c='Approved';     //Reverted Changes as part of SR-024813888
        testQuote1.Customer_Approval_Received_Date__c=System.today();
        testQuote1.CameleonCPQ__AccountId__c = account1.id;
        testQuote1.Agreement_Term__c = 1;
        testQuote1.Sales_Rep__c = usrs[0].Id;
        testQuote1.CDM__c = UserInfo.getUserId();
        testQuote1.CameleonCPQ__SyncStatus__c = 'COMPLETE';
        insert testQuote1; 
        testQuote1.Customer_Approval_1st_reminder__c = true;
        testQuote1.New_Contract_Amendment_DOA__c = true;
        testQuote1.Customer_Approval_2nd_reminder__c = true;
        testQuote1.Customer_Approval_Status__c='Requested to be Contacted';
        update testQuote1; 


             
        CameleonCPQ__QxQuote__c resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c,CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
        System.assertEquals(account1.Id, resultTestQuote1.CameleonCPQ__AccountId__c, 'Wrong Account Lookup at Quote Level');
 
        Test.stopTest();
    }    
    static TestMethod void test_handleAfterupdate_AccountLookUp_2(){
        init();
        Test.startTest(); 
        CameleonCPQ__QxQuote__c testQuote1 = new CameleonCPQ__QxQuote__c(Name='TEST 1',OpportunityId__c=opp1.Id,CameleonCPQ__Status__c='Accepted');
        testQuote1.Customer_AutoApproval__c= false;
        testQuote1.Customer_Approval_Status__c='Requested to be Contacted';
        testQuote1.Customer_Approval_1st_reminder__c = false;
        testQuote1.Customer_Approval_2nd_reminder__c = false;
        testQuote1.Send_for_Customer_Approval__c     = false;
        //testQuote1.Customer_approval_is_received__c=true;                    
        testQuote1.Customer_approval_is_received__c='Approved';     //Reverted Changes as part of SR-02481388
        testQuote1.Customer_Approval_Received_Date__c=System.today();
        insert testQuote1; 
        testQuote1.Customer_Approval_1st_reminder__c = true;
        testQuote1.Customer_Approval_2nd_reminder__c = true;
          
        update testQuote1; 
        
        CameleonCPQ__QxQuote__c resultTestQuote1 = [SELECT Id,Name,Primary_Quote__c,CameleonCPQ__AccountId__c FROM CameleonCPQ__QxQuote__c WHERE Id=:testQuote1.Id];
        System.assertEquals(account1.Id, resultTestQuote1.CameleonCPQ__AccountId__c, 'Wrong Account Lookup at Quote Level');
 
 
 
        Test.stopTest();
    }    
    
    public class MyException extends Exception {

    }
}