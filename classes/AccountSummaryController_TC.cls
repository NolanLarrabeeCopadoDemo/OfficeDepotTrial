@isTest
public class AccountSummaryController_TC {
    @isTest
    private static void findAll() {    
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
        AccountSummaryController.findAll(Org.Id);
    }
  @isTest
    private static void getdml() {    
    Org__C org = MyUtils_Org.GenerateOrg(12);
        insert org;    
        Account prospectAccountnew = Test_Utils.CreateAccount('Prospect');
        prospectAccountnew.org__C = org.id;
        insert prospectAccountnew;      
        DML__C dml = new DML__C(DECISION_MAKER_NM__c='tst',Effective_Start_Date__c=system.today());
        //dml.Effective_Start_Date__c = system.today()-3;
        insert dml;
        DML_Relation__c dmlr = new DML_Relation__c(DML__C=dml.id,org__C=org.id,Account__C=prospectAccountnew.id,Effective_Start_Date__c=system.today());
        insert dmlr;
          AccountSummaryController.getdml(prospectAccountnew.Id);
        AccountSummaryController.getAccid(prospectAccountnew.Id);
        
    }
}