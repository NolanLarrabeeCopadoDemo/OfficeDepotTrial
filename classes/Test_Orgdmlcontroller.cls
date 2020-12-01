@isTest
public class Test_Orgdmlcontroller {
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
        //  orgdmlcontroller.getPricingData(org.id);
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
        DML__C dml = new DML__C(DECISION_MAKER_NM__c='tst',Status__c='Approved',Effective_Start_Date__c=system.today());
        //dml.Effective_Start_Date__c = system.today()-3;
        insert dml;
        DML_Relation__c dmlr = new DML_Relation__c(DML__C=dml.id,org__C=org.id,account__c=prospectAccount.id,Effective_Start_Date__c=system.today());
        insert dmlr;
        
        orgdmlcontroller.getRepData(prospectAccount.Id);
        orgdmlcontroller.getTaskData(prospectAccount.id);
        orgdmlcontroller.getCaseData(prospectAccount.id);
        orgdmlcontroller.getPricingData(prospectAccount.id);
       // orgdmlcontroller.getAccIdOD(Customer);
        //orgdmlcontroller.getAccIdOD(Prospect);
       // orgdmlcontroller.getAccIdOD(Site);
        //  orgdmlcontroller.getNoteData(org.id);
    }
    @isTest
    private static void test_getNoteData() {
        Org__C org = MyUtils_Org.GenerateOrg(12);
        insert org; 
        Account prospectAccount = Test_Utils.CreateAccount('Prospect');
        prospectAccount.org__C = org.id;
        // prospectAccount.Pricing_template_cd__c='testtestpri';
        insert prospectAccount;
        DML__C dml = new DML__C(DECISION_MAKER_NM__c='tst',Status__c='Approved',Effective_Start_Date__c=system.today());
        //dml.Effective_Start_Date__c = system.today()-3;
        insert dml;
        DML_Relation__c dmlr = new DML_Relation__c(DML__C=dml.id,org__C=org.id,Account__C=prospectAccount.id,Effective_Start_Date__c=system.today());
        insert dmlr;
        Note recentNote = new Note();
        recentNote.ParentId=prospectAccount.id; 
        orgdmlcontroller.getNoteData(prospectAccount.id);
        // orgdmlcontroller.getreport(org.id);
    }
    @isTest
    private static void test_getContractData() {
        Org__C org = MyUtils_Org.GenerateOrg(12);
        insert org; 
        DML__C D=New DML__C();
        D.Effective_Start_Date__c = system.today()+1;
        Insert D;
        Account prospectAccount = Test_Utils.CreateAccount('Prospect');
        prospectAccount.org__C = org.id;
        prospectAccount.Related_DML__c=D.id;
        // prospectAccount.Pricing_template_cd__c='testtestpri';
        insert prospectAccount;
        DML__C dml = new DML__C(DECISION_MAKER_NM__c='tst',Status__c='Approved',Effective_Start_Date__c=system.today());
        //dml.Effective_Start_Date__c = system.today()-3;
        insert dml;
        DML_Relation__c dmlr = new DML_Relation__c(DML__C=dml.id,org__C=org.id,Account__C=prospectAccount.id,Effective_Start_Date__c=system.today());
        insert dmlr;
        Opportunity recentOpportunity= new Opportunity();
        recentOpportunity.Accountid=prospectAccount.id;
        Contract recentContract = new Contract();
        recentContract.AccountId=prospectAccount.id;
        Contact recentContact= new Contact();
        recentContact.AccountId=prospectAccount.id;
        orgdmlcontroller.getContractData(prospectAccount.id);
        orgdmlcontroller.getOpportunityData(prospectAccount.id);
        orgdmlcontroller.getContactData(prospectAccount.id);
        orgdmlcontroller.getContactList(prospectAccount.id);
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
      //  orgdmlcontroller.findAllOrgs(org.id);
       // orgdmlcontroller.getOrgHierarchyImage(org.id);
       // orgdmlcontroller.getOrgHierarchyODImage(org.id,true,false,false,false);
        //orgdmlcontroller.getOrgHierarchyOD(org.id,true,false,false,false);
        //orgdmlcontroller.getOrgHierarchy(org.id);
    }
    @isTest
    private static void  test_getCustomerData() {
        Org__C org = MyUtils_Org.GenerateOrg(12);
        insert org; 
        
        Account prospectAccount = Test_Utils.CreateAccount('Customer');
        prospectAccount.org__C = org.id;
        
        //prospectAccount.Pricing_template_cd__c='testtestpri';
        insert prospectAccount;
        Note recentNote = new Note();
        recentNote.ParentId=org.id; 
        DML__C dml = new DML__C(DECISION_MAKER_NM__c='tst',Status__c='Approved',Effective_Start_Date__c=system.today());
        //dml.Effective_Start_Date__c = system.today()-3;
        insert dml;
        DML_Relation__c dmlr = new DML_Relation__c(DML__C=dml.id,org__C=org.id,Account__C=prospectAccount.id,Effective_Start_Date__c=system.today());
        insert dmlr;
        orgdmlcontroller.getCustomerData(prospectAccount.id);
        //  orgdmlcontroller.getNoteData(org.id);
    }
    @isTest
    private static void  test_getSiteData() {
        Org__C org = MyUtils_Org.GenerateOrg(12);
        insert org; 
        //  Account prospectAccount = Test_Utils.CreateAccount('Site');
        // prospectAccount.org__C = org.id;
        // prospectAccount.AOPS_Cust_Id__c='12343325';
        //prospectAccount.Pricing_template_cd__c='testtestpri';
        // insert prospectAccount;
        Account prospectAccountnew = Test_Utils.CreateAccount('Prospect');
        prospectAccountnew.org__C = org.id;
        insert prospectAccountnew;
        Sales_Data__C recentSales = new Sales_Data__C ();
        recentSales.account_type__C='Org';
        recentSales.Org__c=org.id;
        recentSales.Account__c=prospectAccountnew.id;
        insert recentSales;
        DML__C dml = new DML__C(DECISION_MAKER_NM__c='tst',Status__c='Approved',Effective_Start_Date__c=system.today());
        //dml.Effective_Start_Date__c = system.today()-3;
        insert dml;
        DML_Relation__c dmlr = new DML_Relation__c(DML__C=dml.id,org__C=org.id,Account__C=prospectAccountnew.id,Effective_Start_Date__c=system.today());
        insert dmlr;
        orgdmlcontroller.getDMLData(prospectAccountnew.id);
        orgdmlcontroller.getSalesData(prospectAccountnew.id);
        //orgdmlcontroller.getDMLDatas(prospectAccountnew.id);
        orgdmlcontroller.getContactList(org.id);
        orgdmlcontroller.getSiteData(prospectAccountnew.id);
    }
    
}