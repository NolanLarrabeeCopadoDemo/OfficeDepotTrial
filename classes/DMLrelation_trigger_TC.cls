@isTest

public class DMLrelation_trigger_TC {
   
     static testmethod void test() {
        
        Org__c OG = new Org__c();
        OG.Business_Name__c = 'Test';
        insert OG;
        
        Account acct = Test_Utils.CreateAccount('Prospect');
        acct.AOPS_Cust_Id__c='12345';
        acct.Org__c= OG.Id;
        insert acct; 
         system.debug('aacct'+acct);
        
        DML__C DL = new DML__C();
        DL.DECISION_MAKER_ID__c = '2345';
        DL.Effective_Start_Date__c=system.today()+4;
        insert DL;
        
        acct.Related_DML__c = DL.id;
        acct.AOPS_Cust_Id__c='123453306';
        acct.Org__c=OG.id;
        acct.related_dml__C=dl.Id;
        update acct;
        
        DML_Relation__c DR = new DML_Relation__c();
       // DR.CUSTOMERID__c = '1230045';
       // DR.DECISIONMAKERID__c ='2345';
        //DR.Effective_End_Date__c=system.today();
        DR.DML__C=DL.ID;
        DR.Effective_Start_Date__c=system.today()+8;
        DR.Account__c = acct.id;
        insert DR;
          system.debug('aacct'+DR);
         
         DR.New_start_Date__c=system.today()+10;
         DR.ProcessNew_Request__c=true;
         
        update DR;
         
         DML_Relation_History__c DMLRHistory= new DML_Relation_History__c();
        DMLRHistory.DML__c=DL.id;
        insert DMLRHistory;
        
        DMLRHistory.Effective_Start_Date__c=system.today();
        update DMLRHistory;
        
    }
    
   

}