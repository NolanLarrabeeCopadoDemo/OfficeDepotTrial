/***********************************************************************************************
Name    : SprintTasksController_TC
Created : 8/26/2016 [Hemant]
Story   : S-434793 [OD 00786800] 
Desc    : Test class for class - SprintTasksController
***********************************************************************************************/
@isTest
public class SprintTasksController_TC {

    static testMethod void SprintTasksControllerTest()
    {   
         Boolean isSelected;
         
         Case c = new Case();
         String IT_CasesRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IT Cases').getRecordTypeId();
         if(String.isNotBlank(IT_CasesRecordTypeID)){
           c.RecordTypeId = IT_CasesRecordTypeID;
         }  
         insert c;
         System.assertNotEquals(c.Id, null);
         
         // Calling controller with no selected case
        List<Case> csLst = new List<Case>(); 
        ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(csLst);
        setCon.setSelected(csLst);
        
        SprintTasksController controller = new SprintTasksController(setCon);
        controller.init();
        
        // Calling controller with selected case
        csLst.add(c); 
        setCon.setSelected(csLst);
        controller = new SprintTasksController(setCon);
        controller.init();
        
        for(SprintTasksController.TaskWrapper tw : controller.taskWrapperList){
          
          for(SprintTasksController.TaskT wraperTask : tw.taskTLst){
            if(wraperTask.T1.IT_TASK_TYPE__c == 'QA'){
	            wraperTask.isSelected = true;
	            wraperTask.T1.OwnerId = Userinfo.getUserId();
	            wraperTask.Hours = 12;
            }
          }
          
        }
        controller.saveTasks();
        Case updatedCase = [select id, IT_QA_External_Assignment__c from Case where id = :c.id limit 1];
        System.assert(updatedCase.IT_QA_External_Assignment__c == Userinfo.getUserId()) ;
    }

}