@isTest
public class TestCaseScriptsClone_TC{
    
    static testMethod void TestCaseScriptsClone_TC(){
        
         Case c = new Case();
         c.RecordTypeId = '012E00000008dWdIAI';
         Insert c;
         
         SFDC_Test_Case__c stc = new SFDC_Test_Case__c();
         stc.Support_Case__c = c.id;
         insert stc; 
        
         TestCaseStep__c tcs = new TestCaseStep__c();
         tcs.Test_Case__c = stc.id;
         insert tcs;
        
        
         ApexPages.currentPage().getParameters().Put('id',stc.id);
         ApexPages.StandardController con = new ApexPages.StandardController(stc);
         TestCaseScriptsClone controller = new TestCaseScriptsClone(con);
        
         ApexPages.currentPage().getParameters().Put('id',tcs.id);
         controller.clone2();
         //TestCaseScriptsClone.cRecord crec = new TestCaseScriptsClone.cRecord();
    }
      

}