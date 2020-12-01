@isTest
public class TestCaseEdit_TC{
    
    static testMethod void TestCaseEdit_TC() 
     {
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
         ApexPages.StandardController con = new ApexPages.StandardController(tcs);
         TestCaseEdit controller = new TestCaseEdit(con);
         controller.edit2();
         
         
     }

}