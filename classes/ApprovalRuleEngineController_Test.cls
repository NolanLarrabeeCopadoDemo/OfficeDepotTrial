/**
 * @class name: ApprovalRuleEngineController_Test
* @author :  Sandesh Ganjare, sandesh.ganjare@officedepot.com
* @date : 10/14/2020
* @description : This is Generic Framework which used to get Approvers based on the Bussiness Rules setup
*                Test class for ApprovalRuleEngineController
* @JIRA NAIT-128079 (02870008) : Automate Approval Process
*/
@isTest
public class ApprovalRuleEngineController_Test {
    @TestSetup
    static void makeData(){
        //List<User> userList = DataFactory.createUserTestRecords('Test', 1);
        String currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
        insert new  PROS_Access_Custom_Setting__c(Name = 'Draft_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Pricing Analyst_NO ACCESS', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'In Review_VIEW', Profiles__c = currentProfile);
  
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
        insert c;

        PROS_Access_Custom_Setting__c pacs1 = new PROS_Access_Custom_Setting__c(Name='In Review_VIEW', Profiles__c='Field Sales');
        PROS_Access_Custom_Setting__c pacs2 = new PROS_Access_Custom_Setting__c(Name='Draft_VIEW', Profiles__c='Field Sales');
        insert new List<PROS_Access_Custom_Setting__c> { pacs1, pacs2 };

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
        INSERT pq;
        
        Opportunity opp = new Opportunity(Name='TestOpp1', StageName='Propose', CloseDate=Date.today(), 
                                          AccountId=accountList[0].Id, Decision_Date__c= (Date.today()+1),
                                          Probability_Move_to_Verbal_Close__c='80% - 90%');
        insert opp;

        Account site1 = new Account();
		site1.Name = 'TestAccount2';
		site1.RecordTypeId = [SELECT Id, Name FROM RecordType WHERE Name = 'Site'].Id;
		site1.Related_Account__c = accountList[0].Id;
		site1.AOPS_Seq_Id__c = '1';
        insert site1;
        
        Quote quote1 = new Quote();
		quote1.OpportunityId = opp.Id;
		quote1.Ship_To_Account__c = site1.Id;
		quote1.Name = 'TestQuote1';
		quote1.Desktop__c = '1';
		quote1.Cost_Center__c = '1';
		quote1.Release__c = '1';
        quote1.Customer_PO_Number__c = '1';
        //quote1.Margin_Percent__c = 0.6;
        //quote1.Margin_Amount__c = 90;
        //quote1.TotalPrice = 100;
        insert quote1;
        Id standardPBID = Test.getStandardPricebookId();
        Product2 prod = new Product2(Name='Test');
        insert prod;
        PriceBookEntry pbEntry = new PriceBookEntry(UnitPrice=1, Pricebook2Id=standardPBID, Product2Id=prod.Id, UseStandardPrice=false, IsActive=true);
        insert pbEntry;
        QuoteLineItem lineItem = new QuoteLineItem(QuoteId=quote1.Id, PricebookEntryId=pbEntry.Id, UnitPrice=2, Quantity=1);

        Tech_Sales_Internal_Approval_Rule_Header__c Rule1 = new Tech_Sales_Internal_Approval_Rule_Header__c();
        Rule1.Name = 'PROS Rule 1';
        Rule1.Active__c = true;
        Rule1.Project__c ='PROS';
        Rule1.Approver__c = 'VP';
        Rule1.Rule_Name__c='PROS Rule 1';
        INSERT Rule1;

        Tech_Sales_Internal_Approval_Rule_Header__c Rule2 = new Tech_Sales_Internal_Approval_Rule_Header__c();
        Rule2.Name = 'PROS Rule 2';
        Rule2.Active__c = true;
        Rule2.Project__c ='Tech Sale';
        Rule2.Approver__c = 'VP';
        Rule2.Rule_Name__c='PROS Rule 2';
        INSERT Rule2;

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

        Tech_Sales_Int_Approval_Rule_Criteria__c cri_3 = new Tech_Sales_Int_Approval_Rule_Criteria__c();
        cri_3.Name = 'Cri 3';
        cri_3.Criteria_Field__c = 'Margin Percentage'; //Margin_Percent__c
        cri_3.Operator__c = 'Greater Than';
        cri_3.Tech_Sales_Internal_Approval_Rule_Header__c = Rule2.Id;
        cri_3.Value__c = -1.0;
        lstCriteria.add(cri_3);

        Tech_Sales_Int_Approval_Rule_Criteria__c cri_4 = new Tech_Sales_Int_Approval_Rule_Criteria__c();
        cri_4.Name = 'Cri 4';
        cri_4.Criteria_Field__c = 'Margin Amount'; //Margin_Amount__c
        cri_4.Operator__c = 'Less Than';
        cri_4.Tech_Sales_Internal_Approval_Rule_Header__c = Rule2.Id;
        cri_4.Value__c = 2.0;
        lstCriteria.add(cri_4);

        Tech_Sales_Int_Approval_Rule_Criteria__c cri_5 = new Tech_Sales_Int_Approval_Rule_Criteria__c();
        cri_5.Name = 'Cri 5';
        cri_5.Criteria_Field__c = 'Price'; // TotalPrice
        cri_5.Operator__c = 'Less Than Or Equal To';
        cri_5.Tech_Sales_Internal_Approval_Rule_Header__c = Rule2.Id;
        cri_5.Value__c = 0.0;
        lstCriteria.add(cri_5);

        Tech_Sales_Int_Approval_Rule_Criteria__c cri_6 = new Tech_Sales_Int_Approval_Rule_Criteria__c();
        cri_6.Name = 'Cri 6';
        cri_6.Criteria_Field__c = 'Cost'; // TotalPrice
        cri_6.Operator__c = 'Greater Than Or Equal To';
        cri_6.Tech_Sales_Internal_Approval_Rule_Header__c = Rule2.Id;
        cri_6.Value__c = 0.0;
        lstCriteria.add(cri_6);

        Tech_Sales_Int_Approval_Rule_Criteria__c cri_7 = new Tech_Sales_Int_Approval_Rule_Criteria__c();
        cri_7.Name = 'Cri 7';
        cri_7.Criteria_Field__c = 'Quantity'; // TotalPrice
        cri_7.Operator__c = 'Greater Than Or Equal To';
        cri_7.Tech_Sales_Internal_Approval_Rule_Header__c = Rule2.Id;
        cri_7.Value__c = 0;
        lstCriteria.add(cri_7);

        INSERT lstCriteria;
    }

    @isTest
    private static void coverage_getApprovalTitles1() {
        List<String> approvalTitles = new List<String>();
        CameleonCPQ__QxQuote__c q = [SELECT Id, OwnerId, Type__c,Issue_Term__c FROM CameleonCPQ__QxQuote__c LIMIT 1];
        List<Tech_Sales_Internal_Approval_Rule_Header__c> rules = [SELECT Id,Name, Approver__c, (SELECT Id, Criteria_Field__c, Operator__c, Value__c,Text_Value__c FROM Tech_Sales_Int_Approval_Rules_Criteria__r)
                                                                        FROM Tech_Sales_Internal_Approval_Rule_Header__c WHERE Project__c = 'PROS' AND Active__c = true];
            
        Test.startTest();
            approvalTitles = ApprovalRuleEngineController.getApprovalTitles(q,rules);
        Test.stopTest();

        System.assertEquals(true, approvalTitles != null);
    }

    @isTest
    private static void coverage_getApprovalTitles2() {
        List<String> approvalTitles = new List<String>();
        Quote q = [SELECT Id, Margin_Percent__c, Margin_Amount__c, TotalPrice, Total_Cost_Rollup__c, Total_Line_Item_Qty__c
                        FROM Quote LIMIT 1];
        System.debug('Margin_Percent__c>>'+q.Margin_Percent__c);
        System.debug('TotalPrice>>'+q.TotalPrice);
        System.debug('Margin_Amount__c>>'+q.Margin_Amount__c);
        List<Tech_Sales_Internal_Approval_Rule_Header__c> rules = [SELECT Id,Name, Approver__c, (SELECT Id, Criteria_Field__c, Operator__c, Value__c,Text_Value__c FROM Tech_Sales_Int_Approval_Rules_Criteria__r)
                                                                        FROM Tech_Sales_Internal_Approval_Rule_Header__c WHERE Project__c != 'PROS' AND Active__c = true];
            
        Test.startTest();
            approvalTitles = ApprovalRuleEngineController.getApprovalTitles(q,rules);
        Test.stopTest();

        System.assertEquals(true, approvalTitles != null);
    }


    @isTest
    private static void coverage_getMapWithAccOwnerHierarchyAdded() {
        User accOwner = [SELECT Id, Manager_ID__c, Director_ID__c, Senior_Director_ID__c, VP_ID__c, SVP_ID__c FROM User LIMIT 1];
        
        Map<String, User> possibleApprovalUsers = new Map<String, User>();
        Test.startTest();
        possibleApprovalUsers = ApprovalRuleEngineController.getMapWithAccOwnerHierarchyAdded(possibleApprovalUsers,accOwner);
        Test.stopTest();

        System.assertEquals(true, possibleApprovalUsers != null);
    }
}