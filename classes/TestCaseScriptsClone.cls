public class TestCaseScriptsClone {

   private ApexPages.StandardController controller {get; set;} 
   private SFDC_Test_Case__c po {get;set;}
   public ID newRecordId {get;set;}
   public ID testCaseid {get;set;}
   
   public TestCaseScriptsClone(ApexPages.StandardController c2)
   
   { this.controller = c2;
     
     po = (SFDC_Test_Case__c)c2.getRecord();
     
     }
     
     
     public PageReference clone2() {

      Savepoint sp = Database.setSavepoint();
      SFDC_Test_Case__c newPO;
       
     try {
            po = [select Id, Name, Impact_Tab__c, Other_Tab__c,Regression_Parent_Case__c, Status__c, Support_Case__c, Prerequisites_and_Initial_Conditions_del__c, Test_Phase__c, Test_Type__c, Title__c from SFDC_Test_Case__c  where id = :po.id];  
            newPO = po.clone(false);
            insert newPO;
        
        newRecordId = newPO.id;
        
        
        List<TestCaseStep__c> steps = new List<TestCaseStep__c>();
        for (TestCaseStep__c pi : [Select Id,name, Actual_Results__c, Comments__c, Expected_Results__c, Status__c, Step__c, Support__c, Test_Case__c, Test_Step_Description__c from TestCaseStep__c  where Test_Case__c = :po.id])  
         { pi.Actual_Results__c = null;
           pi.Comments__c = null;
           pi.Status__c = 'Not Started';
           pi.Support__c = null;
           TestCaseStep__c newPI = pi.clone(false);
           newPI.Test_Case__c = newPO.id;
           steps.add(newPI);
         }
          
          insert steps; 
         
         } 
         
         catch (Exception e){
             
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null; 
            
            }
            
            return new PageReference ('/'+newPO.id);
         }   
   }