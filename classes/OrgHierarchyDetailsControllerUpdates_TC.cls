@isTest
public class OrgHierarchyDetailsControllerUpdates_TC {
       @isTest
    private static void test_getPricingData() {
        Org__C org = MyUtils_Org.GenerateOrg(12);
        insert org; 
        Account prospectAccount = Test_Utils.CreateAccount('Prospect');
        prospectAccount.org__C = org.id;
        prospectAccount.Pricing_template_cd__c='testtestpri';
        insert prospectAccount;
        User usr = Test_Utils.CreateUser();
        //  insert usr;
        Sales_Person__c salesPerson = Test_Utils.createTestSalesPerson(usr.Id,'testSalesPerson');
        //Sales_Person__c salesPerson = Test_Utils.createTestSalesPerson(prospectAccount.ownerid, '21344');
        salesPerson.IsActive__c=true;
        update salesPerson;
        Pricing_Template__c Pricing = Test_Utils.createPricingTemplate();
        pricing.name=prospectAccount.Pricing_template_cd__c;
        insert Pricing;    
        //  OrgHierarchyDetailsControllerUpdates.getPricingData(org.id);
        String sObjectName='Account';
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(sObjectName).getDescribe();
        String Customer= 'Customer';
        String Prospect= 'Prospect';
        String Site= 'Site';
        Task recentTask = new Task();
        recentTask.WhatId=org.id;
        insert recentTask;
        Case recentCase = new Case();
        recentCase.org__C=org.id;
        insert recentCase;
        OrgHierarchyDetailsControllerUpdates.getRepData(Org.Id);
        OrgHierarchyDetailsControllerUpdates.getTaskData(org.id);
        OrgHierarchyDetailsControllerUpdates.getCaseData(org.id);
        OrgHierarchyDetailsControllerUpdates.getPricingData(org.id);
        OrgHierarchyDetailsControllerUpdates.getAccIdOD(Customer);
        OrgHierarchyDetailsControllerUpdates.getAccIdOD(Prospect);
        OrgHierarchyDetailsControllerUpdates.getAccIdOD(Site);
    }
    @isTest
    private static void test_getNoteData() {
        Org__C org = MyUtils_Org.GenerateOrg(12);
        insert org; 
        Account prospectAccount = Test_Utils.CreateAccount('Prospect');
        prospectAccount.org__C = org.id;
        // prospectAccount.Pricing_template_cd__c='testtestpri';
        insert prospectAccount;
        Note recentNote = new Note();
        recentNote.ParentId=org.id; 
        OrgHierarchyDetailsControllerUpdates.getNoteData(org.id);
        // OrgHierarchyDetailsControllerUpdates.getreport(org.id);
    }
    @isTest
    private static void test_getContractData() {
        Org__C org = MyUtils_Org.GenerateOrg(12);
        insert org; 
        Account prospectAccount = Test_Utils.CreateAccount('Prospect');
        prospectAccount.org__C = org.id;
        // prospectAccount.Pricing_template_cd__c='testtestpri';
        insert prospectAccount;
        Opportunity recentOpportunity= new Opportunity();
        recentOpportunity.Accountid=prospectAccount.id;
        Contract recentContract = new Contract();
        recentContract.Org__c=org.id;
        Contact recentContact= new Contact();
        recentContact.AccountId=prospectAccount.id;
        OrgHierarchyDetailsControllerUpdates.getContractData(org.id);
        OrgHierarchyDetailsControllerUpdates.getOpportunityData(org.id);
        OrgHierarchyDetailsControllerUpdates.getContactData(org.id);
        OrgHierarchyDetailsControllerUpdates.getContactList(org.id);
    }
    @isTest
    private static void test_findAllOrgs() {
        Org__C org = MyUtils_Org.GenerateOrg(123);
        insert org; 
        Org__C orgchild = MyUtils_Org.GenerateOrg(14);
        orgchild.Parent_Org__c=org.id;
        insert orgchild; 
        Org__C orgchild1 = MyUtils_Org.GenerateOrg(10);
        orgchild1.Parent_Org__c=orgchild.id;
        insert orgchild1; 
        Org__C orgchild2 = MyUtils_Org.GenerateOrg(13);
        orgchild2.Parent_Org__c=orgchild1.id;
        insert orgchild2; 
        Account prospectAccount = Test_Utils.CreateAccount('Prospect');
        prospectAccount.org__C = org.id;
        // prospectAccount.Pricing_template_cd__c='testtestpri';
        insert prospectAccount;
        Note recentNote = new Note();
        recentNote.ParentId=org.id;
        OrgHierarchyDetailsControllerUpdates.findAllOrgs(org.id);
        //OrgHierarchyDetailsControllerUpdates.getOrgHierarchyImage(org.id);
        OrgHierarchyDetailsControllerUpdates.getOrgHierarchyODImage(org.id,true,false,false,false);
       // OrgHierarchyDetailsControllerUpdates.getOrgHierarchyOD(org.id,true,false,false,false);
        OrgHierarchyDetailsControllerUpdates.getOrgHierarchy(org.id);
    }
    @isTest
    private static void  test_getCustomerData() {
        Org__C org = MyUtils_Org.GenerateOrg(12);
        insert org; 
        Account prospectAccount = Test_Utils.CreateAccount('Customer');
        prospectAccount.org__C = org.id;
        //prospectAccount.Pricing_template_cd__c='testtestpri';
        insert prospectAccount;
        OrgHierarchyDetailsControllerUpdates.getCustomerData(org.id);
    }
    @isTest
    private static void  test_getSiteData() {
        Org__C org = MyUtils_Org.GenerateOrg(12);
        insert org; 
        Account prospectAccount = Test_Utils.CreateAccount('Customer');
        prospectAccount.org__C = org.id;
        //prospectAccount.Pricing_template_cd__c='testtestpri';
        insert prospectAccount;
        Sales_Data__C recentSales = new Sales_Data__C ();
        recentSales.account_type__C='Org';
        recentSales.Org__c=org.id;
        insert recentSales;
        DML__C dml = new DML__C(DECISION_MAKER_NM__c='tst',Status__c='Approved',Effective_Start_Date__c=system.today());
        insert dml;
        DML_Relation__c dmlr = new DML_Relation__c(DML__C=dml.id,org__C=org.id,Account__c=prospectAccount.id,Effective_Start_Date__c=system.today());
        insert dmlr;
        OrgHierarchyDetailsControllerUpdates.getDMLData(org.id);
        OrgHierarchyDetailsControllerUpdates.getSalesData(org.id);
        OrgHierarchyDetailsControllerUpdates.getSiteData(org.id);
    }
    
    @isTest
    private static void test_AccountRelatedDataExtn()
    {
        
    }
}