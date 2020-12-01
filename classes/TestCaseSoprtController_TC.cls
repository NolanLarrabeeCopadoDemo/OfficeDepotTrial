@isTest
public class TestCaseSoprtController_TC{

  static testMethod void TestCaseSoprtController_TC() {
  
         Case c = new Case();
         c.RecordTypeId = '012E00000008dWd';
         Insert c;
        
          
      
         
         SFDC_Test_Case__c stc = new SFDC_Test_Case__c();
         stc.Support_Case__c = c.id;
         insert stc; 
      
        
      
      
         TestCaseStep__c tcs = new TestCaseStep__c();
         tcs.Test_Case__c = stc.id;
         tcs.name = '2';
         insert tcs;
      
         ApexPages.currentPage().getParameters().Put('id',tcs.id);
         ApexPages.StandardController con = new ApexPages.StandardController(tcs);
         TestCaseSoprtController controller = new TestCaseSoprtController(con);
         //update tcs;
         
         //insert tcs;
         controller.TestCaseScriptsController1();
         
         controller.onsave();
         TestCaseSoprtController.cRecord wrapcont = new TestCaseSoprtController.cRecord();
         ApexPages.currentPage().getParameters().Put('pid',stc.id);
         controller.TestCaseScriptsController1();
      
      //update stc;
      //controller.onsave();
      
      /*ApexPages.currentPage().getParameters().Put('id',tcs.name);
      ApexPages.StandardController con1 = new ApexPages.StandardController(tcs);
      TestCaseSoprtController controller1 = new TestCaseSoprtController(con1);*/
     
      
      //controller1.onsave();
  
  }


}