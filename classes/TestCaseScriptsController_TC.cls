@isTest
public class TestCaseScriptsController_TC{
    
     static testMethod void TestCaseScriptsController_TC() 
     {
         Case c = new Case();
         c.RecordTypeId = '012E00000008dWdIAI';
         Insert c;
         
         SFDC_Test_Case__c stc = new SFDC_Test_Case__c();
         stc.Support_Case__c = c.id;
         insert stc;
         
         TestCaseStep__c tcs = new TestCaseStep__c();
         tcs.Test_Case__c = stc.id;
         tcs.name = '1';
         tcs.comments__c = 'no comment';
         insert tcs;
         
       ApexPages.currentPage().getParameters().Put('id',stc.id);
       ApexPages.StandardController con = new ApexPages.StandardController(stc);
       TestCaseScriptsController controller = new TestCaseScriptsController(con);
       TestCaseScriptsController.cRecord crec = new TestCaseScriptsController.cRecord();
       
         list<TestCaseStep__c> lTCS = [select id, name, comments__c from TestCaseStep__c where id=:tcs.Id  ];
         
         crec.selected = false;
         crec.rec = lTCS[0];
         
       controller.new1();
       controller.addFive();
       controller.delete1();
       
         ApexPages.currentPage().getParameters().Put('id',tcs.id);
          controller.save();
          controller.cancel();
         controller.saveStep();
        // ApexPages.currentPage().getParameters().Put('id',tcs.id);
         
         
         
         
        /* TestCaseStep__c abc = new TestCaseStep__c();
         abc.Test_Case__c = stc.id;
         abc.name = '2';
         abc.comments__c = 'no comments';
         insert abc;
         delete abc;*/
         
          
         
         
         
         
       
     
     }

}