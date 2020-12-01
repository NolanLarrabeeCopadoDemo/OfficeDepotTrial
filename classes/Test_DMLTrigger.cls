@isTest
public class Test_DMLTrigger {
    @isTest
    private static void test_CreateDML() {
        DML__C dml = new DML__C(DECISION_MAKER_NM__c='tst',Status__c='Approved');
        dml.Effective_Start_Date__c=system.today();
        insert dml;
    }
    @isTest
    private static void test_CreateDMLHandler() {
        
        DML__C dml = new DML__C(DECISION_MAKER_NM__c='tst',Status__c='Approved',Effective_End_Date__c=system.today()+5);
        insert dml;
        
        Account prospectAccount = Test_Utils.CreateAccount('Prospect');
        insert prospectAccount;
        
        //DML_Relation__c DL = new DML_Relation__c(CUSTOMERID__c='tessst',Account__c =prospectAccount.id,DML__c=dml.Id);
        
        DML_Relation__c dr=new DML_Relation__c();
        dr.DML__c=dml.Id;        
        dr.Account__c =prospectAccount.id;
        dr.Effective_End_Date__c=system.today()+5;
        insert dr;
            
        dml.Effective_End_Date__c=system.today()+10;
        dml.ProcessNew_Request__c=true;
        update dml;
        
        DML_History__c DMLHistory= new DML_History__c();
        DMLHistory.DML__c=dml.id;
        insert DMLHistory;
        
        DMLHistory.Effective_Start_Date__c=system.today();
        update DMLHistory;
        
        
        
           
    }
}