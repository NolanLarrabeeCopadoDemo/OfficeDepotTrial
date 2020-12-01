@isTest
public class ITTaskAutomationController_TC {

    static testMethod void ITTaskAutomationController_TC()
    {   
         Boolean isSelected;
         
         Case c = new Case();
         c.RecordTypeId = '012E00000008dWdIAI';
         insert c;
         
         Task t = new Task();
         t.whatId = c.id;
         t.Task_Type__c = 'IT';
         t.IT_Task_Type__c = 'Design';
         t.subject = 'Design';
        // t.isSelected = true;
         insert t;

         /*Task taskT = new Task();
         taskT  t2 = new taskT();
         t2.whatId = t.whatId;
         t2.isSelected = true;
         t2.Label1 = 'Design';
         t.subject = 'Design';
         insert t2;*/
         
         List<ITTaskAutomationController.TaskT> tasksWrapperList = new List<ITTaskAutomationController.TaskT>(); //Added by Lalit for S-407214       
      
         
       ApexPages.currentPage().getParameters().Put('id',c.id);
       ApexPages.StandardController con = new ApexPages.StandardController(c);
       //Added by Lalit for S-407214 STRAT
       ITTaskAutomationController controller = new ITTaskAutomationController(con); 
       tasksWrapperList = controller.Tasklst;
       for(ITTaskAutomationController.TaskT wraperTask : tasksWrapperList){
       	if(wraperTask.T1.IT_TASK_TYPE__c == 'QA'){
       		wraperTask.isSelected = true;
       		wraperTask.T1.OwnerId = Userinfo.getUserId();
       		wraperTask.Hours = 12;
       		
       	}
       }
       //Added by Lalit for S-407214 END
       controller.save();
       controller.cancel(); 
       Case updatedCase = [select id, IT_QA_External_Assignment__c from Case where id = :c.id limit 1];//Added by Lalit for S-407214
       System.assert(updatedCase.IT_QA_External_Assignment__c == Userinfo.getUserId()) ;//Added by Lalit for S-407214
    }

}