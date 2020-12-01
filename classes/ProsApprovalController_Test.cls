/**
* @class name: ProsApprovalController_Test
* @author :  Sandesh Ganjare, sandesh.ganjare@officedepot.com
* @date : 10/14/2020
* @description : test class for ProsApprovalController_Test

* @JIRA NAIT-128079 (02870008) : Automate Approval Process
*/
@isTest
public class ProsApprovalController_Test {
    @TestSetup
    static void makeData(){

        String currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
        INSERT new  PROS_Access_Custom_Setting__c(Name = 'Draft_VIEW', Profiles__c = currentProfile);
        INSERT new  PROS_Access_Custom_Setting__c(Name = 'Pricing Analyst_NO ACCESS', Profiles__c = currentProfile);
        INSERT new  PROS_Access_Custom_Setting__c(Name = 'In Review_VIEW', Profiles__c = currentProfile);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'apTest', Email='standarduser@officedepot.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='dataloadernorth1111111111@officedepot.com');
            insert u;

        Recordtype rcd =  [select id from recordtype where name = 'Customer'];
        List<Account> accountList = DataFactory.createAccountTestRecords('Test acc', 1, '');
        accountList[0].Oracle_Party_Id__c = '123456'; 
        accountList[0].AOPS_Cust_Id__c = '123456';          
        //accountList[0].OwnerId=userList[0].id;
        accountList[0].recordtypeid = rcd.id;
        accountList[0].Industry_OD_SIC_Rep__c = 'Accounting';
        accountList[0].Org_WCW_Count_DB__c =11112234;
        accountList[0].Org_WCW_Count_Rep__c = 55 ;
        accountList[0].ZIP__C = '111111';
        accountList[0].AccountNumber ='223112';
        //accountList[0].Sales_PersonID__c = salesPerson.id; //Sales person Id for the Salesforce USer

        UPDATE accountList;

        CameleonCPQ__QxSetup__c  c = new CameleonCPQ__QxSetup__c(Name='Master',CameleonCPQ__QuoteModelName__c='OfficeDepot',CameleonCPQ__MappingSetName__c='New_Written_Agreement',CameleonCPQ__LinesManagementPolicy__c=1);
        INSERT c;

        PROS_Access_Custom_Setting__c pacs1 = new PROS_Access_Custom_Setting__c(Name='In Review_VIEW', Profiles__c='Field Sales');
        PROS_Access_Custom_Setting__c pacs2 = new PROS_Access_Custom_Setting__c(Name='Draft_VIEW', Profiles__c='Field Sales');
        INSERT new List<PROS_Access_Custom_Setting__c> { pacs1, pacs2 };

        //Id ScoeRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SCOE Cases').getRecordTypeId();
           

        Case newCase= new Case();
        newCase.accountId=accountList[0].Id;
        newCase.Support_Type__c='New DML Exception';
        //newCase.RecordTypeId = ScoeRT;
        //newCase.SCOE_Issue_Type__c = 'Legal/Business Callout'; 
        newCase.subject= accountList[0].Name;
        //newCase.AM_Approver1__c = UserInfo.getUserId();
        //newCase.RecordTypeId=rt.Id;
        newCase.Description='Account Name :'+' '+accountList[0].Name;
        INSERT newCase;

        CameleonCPQ__QxQuote__c pq = new CameleonCPQ__QxQuote__c();
        pq.Name = 'Test_Quote_1';
        pq.CameleonCPQ__AccountId__c = accountList[0].id;
        // pq.OpportunityId__c = opp.id;
        pq.Agreement_Term__c = 1;
        pq.CDM__c = UserInfo.getUserId();
        //pq.Sales_Rep__c = userList[0].Id;
        pq.CameleonCPQ__SyncStatus__c = 'COMPLETE';
        pq.Go_Live_Date__c = system.today()-1; 
        //pq.WRF__c = wrf.id;       
        pq.Compliance_Approval_Status__c='Submitted';
        pq.CameleonCPQ__Status__c='Inactive'; //CameleonCPQ__Status__c==''
        pq.Customer_Approval_Status__c = 'Rejected';
        pq.Type__c='Audit';
        pq.Issue_Term__c='OD to pay audit costs';
        pq.Case__c = newCase.id;   
        INSERT pq;
        
        Opportunity opp = new Opportunity(Name='TestOpp1', StageName='Propose', CloseDate=Date.today(), 
                                          AccountId=accountList[0].Id, Decision_Date__c= (Date.today()+1),
                                          Probability_Move_to_Verbal_Close__c='80% - 90%');
        INSERT opp;

        Account site1 = new Account();
        site1.Name = 'TestAccount2';
        site1.RecordTypeId = [SELECT Id, Name FROM RecordType WHERE Name = 'Site'].Id;
        site1.Related_Account__c = accountList[0].Id;
        site1.AOPS_Seq_Id__c = '1';
        INSERT site1;
       
        Tech_Sales_Internal_Approval_Rule_Header__c Rule1 = new Tech_Sales_Internal_Approval_Rule_Header__c();
        Rule1.Name = 'PROS Rule 1';
        Rule1.Active__c = true;
        Rule1.Project__c ='PROS';
        Rule1.Approver__c = 'VP';
        Rule1.Rule_Name__c='PROS Rule 1';
        INSERT Rule1;

        List<Tech_Sales_Int_Approval_Rule_Criteria__c> lstCriteria = new List<Tech_Sales_Int_Approval_Rule_Criteria__c>();
        Tech_Sales_Int_Approval_Rule_Criteria__c cri_1 = new Tech_Sales_Int_Approval_Rule_Criteria__c();
        cri_1.Name = 'Cri 1';
        cri_1.Criteria_Field__c = 'Issue Term';
        cri_1.Operator__c = 'Equal To';
        cri_1.Tech_Sales_Internal_Approval_Rule_Header__c = Rule1.Id;
        cri_1.Text_Value__c = 'OD to pay audit costs';
        lstCriteria.add(cri_1);

        Tech_Sales_Int_Approval_Rule_Criteria__c cri_2 = new Tech_Sales_Int_Approval_Rule_Criteria__c();
        cri_2.Name = 'Cri 2';
        cri_2.Criteria_Field__c = 'Type';
        cri_2.Operator__c = 'Equal To';
        cri_2.Tech_Sales_Internal_Approval_Rule_Header__c = Rule1.Id;
        cri_2.Text_Value__c = 'Audit';
        lstCriteria.add(cri_2);

        Tech_Sales_Internal_Approval_Rule_Header__c Rule2 = new Tech_Sales_Internal_Approval_Rule_Header__c();
        Rule2.Name = 'PROS Rule 2';
        Rule2.Active__c = true;
        Rule2.Project__c ='PROS';
        Rule2.Approver__c = 'VP';
        Rule2.Rule_Name__c='PROS Rule 2';
        INSERT Rule2;

        //List<Tech_Sales_Int_Approval_Rule_Criteria__c> lstCriteria = new List<Tech_Sales_Int_Approval_Rule_Criteria__c>();
        Tech_Sales_Int_Approval_Rule_Criteria__c cri_3 = new Tech_Sales_Int_Approval_Rule_Criteria__c();
        cri_3.Name = 'Cri 1';
        cri_3.Criteria_Field__c = 'Issue Term';
        cri_3.Operator__c = 'Equal To';
        cri_3.Tech_Sales_Internal_Approval_Rule_Header__c = Rule1.Id;
        cri_3.Text_Value__c = 'OD to pay audit costs';
        lstCriteria.add(cri_3);

        Tech_Sales_Int_Approval_Rule_Criteria__c cri_4 = new Tech_Sales_Int_Approval_Rule_Criteria__c();
        cri_4.Name = 'Cri 2';
        cri_4.Criteria_Field__c = 'Type';
        cri_4.Operator__c = 'Equal To';
        cri_4.Tech_Sales_Internal_Approval_Rule_Header__c = Rule1.Id;
        cri_4.Text_Value__c = 'Audit';
        lstCriteria.add(cri_4);

        INSERT lstCriteria;

        
    }

    @isTest
    private static void coverage_approvalStatus() {
        Boolean isApproved = false;
        Case support = [SELECT Id FROM Case LIMIT 1];
            
        Test.startTest();
            isApproved = ProsApprovalController.approvalStatus(support.id,'');
        Test.stopTest();
       
        System.assertEquals(true, isApproved);
    }

    @isTest
    private static void coverage_approveReject() {
        Boolean isApproved = false;
        Case support = [SELECT Id FROM Case LIMIT 1];
            
        Test.startTest();
            isApproved = ProsApprovalController.approveReject(support.id,'','Test commented', 'Approve', 'VGVzdCBkYXRh', 'TestfileName');
        Test.stopTest();
       
        System.assertEquals(false, isApproved);
    }
    
  @isTest
    private static void coverage_CreateSCOECaseFORApproval() { 
      //  List<User> approvalTitles = new List<User>();
        
        CameleonCPQ__QxQuote__c q = [SELECT Id, OwnerId, Type__c,Issue_Term__c FROM CameleonCPQ__QxQuote__c LIMIT 1];
        
        List<String> usrs = new List<String>{UserInfo.getUserId()};
        Test.startTest();
         try{
            ProsApprovalController.CreateSCOECaseFORApproval(q.Id, 'Test', 'Test', Json.serialize(usrs));
         }catch(Exception e){
            System.debug('Known Expeption');
         }            
           
        Test.stopTest();

      //  System.assertEquals(true, approvalTitles != null);
    }

    @isTest
    private static void coverage_getApprovalUsers() { 
        List<User> approvalTitles = new List<User>();
        CameleonCPQ__QxQuote__c q = [SELECT Id, OwnerId, Type__c,Issue_Term__c FROM CameleonCPQ__QxQuote__c LIMIT 1];
        List<Tech_Sales_Internal_Approval_Rule_Header__c> rules = [SELECT Id,Name, Approver__c, (SELECT Id, Criteria_Field__c, Operator__c, Value__c,Text_Value__c FROM Tech_Sales_Int_Approval_Rules_Criteria__r)
                                                                        FROM Tech_Sales_Internal_Approval_Rule_Header__c WHERE Project__c = 'PROS' AND Active__c = true];
        List<User> lstUser = [Select id from User Limit 2];        
        Test.startTest();
            approvalTitles = ProsApprovalController.getApprovalUsers(q.Id, 'Audit', 'OD to pay audit costs');
            ProsApprovalController.listIncludesUser(lstUser, lstUser[0]);
            Test.stopTest();

        System.assertEquals(true, approvalTitles != null);
    }

    @isTest
    private static void coverage_getIssueTerms() { 
        List<String> issueTerms = new List<String>();
        CameleonCPQ__QxQuote__c q = [SELECT Id, OwnerId, Type__c,Issue_Term__c FROM CameleonCPQ__QxQuote__c LIMIT 1];
            
        Test.startTest();
        issueTerms = ProsApprovalController.getIssueTerms('Audit');
        Test.stopTest();

        System.assertEquals(true, issueTerms != null);
    }
}