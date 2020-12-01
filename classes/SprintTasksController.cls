/***********************************************************************************************
Name    : SprintTasksController
VF Page : SprintTasks
Created : 8/24/2016 [Hemant]
Story   : S-434793 [OD 00786800] 
Desc    : To create the sprint tasks for cases
***********************************************************************************************/
public class SprintTasksController {

  public List<TaskWrapper> taskWrapperList{get;set;}
  private List<Case> selectedCases{get;set;}
  private ApexPages.StandardSetController setCon;
  
  //constructor
  public SprintTasksController(ApexPages.StandardSetController setCon) {
      this.setCon = setCon;
  }
  
  // initialize tasks list with 10 tasks
  public void init(){
    // populate selected cases values
    initSelectedCaseItems();
    
    // create tasl list for display on screen
    constructTaskList();
  }
  
  //populate the selected cases
  private void initSelectedCaseItems(){
    List<Case> selectedList = (List<Case>)setCon.getSelected();
    
    selectedCases = [SELECT Id, IT_Assignment__c, IT_BU_Reviewer__c, IT_QA_External_Assignment__c, Subject, CaseNumber
                    FROM Case 
                    WHERE Id IN :selectedList];
    if(selectedCases.size() == 0){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Constants.MSG_SELECT_CASE_RECORD)) ;
    }
    return;
  }
  
  // contruct task list with IT_TASK_TYPE__c picklist values tasks
  private void constructTaskList(){
    // Get the list of picklist values for IT_TASK_TYPE__c field. 
    list<Schema.PicklistEntry> IT_TASK_TYPE_Values = Task.getSObjectType().getDescribe().fields.getMap().get('IT_TASK_TYPE__c').getDescribe().getPickListValues();
      
    taskWrapperList = new List<TaskWrapper>();
    
    for(Case cs : selectedCases){

      TaskWrapper wrapper = new TaskWrapper();
      list<TaskT> Tasklst = new list<TaskT>();
    
      for (Schema.PicklistEntry a : IT_TASK_TYPE_Values){
        Task tsk = new Task(WhatId = cs.Id, IT_TASK_TYPE__c = a.getValue());
        if(a.getValue() == Constants.UAT){
          tsk.Task_Type__c = Constants.CASE_TASK_TYPE_BUSINESS;
        }else{
          tsk.Task_Type__c = Constants.CASE_TASK_TYPE_IT;
        }
        
        TaskT  t = new TaskT(); 
        t.T1 = tsk;
        t.isSelected = false;
        t.Label1 = a.getValue();
        tsk.subject = t.Label1;
        tsk.Estimated_LOE__c = t.Hours;
        Tasklst.add(t);
      }
      wrapper.taskTLst = Tasklst;
      wrapper.twCase = cs;
      taskWrapperList.add(wrapper); 
    }
  } 
  
  // save tasks
  public Pagereference saveTasks(){
    
    if(taskWrapperList.size() > 0){
      
      list<Task> TaskToSavelst = new list<Task>();
      list<Case> caseLstToUpdateForQATask = new list<Case>();
      
      for(TaskWrapper tw : taskWrapperList){
        if(tw.taskTLst.size()>0){
          
          for(TaskT tt : tw.taskTLst){
            if(tt.isSelected && tt.T1.OwnerID != null){
               TaskToSavelst.add(tt.T1);
               
               if(tt.T1.IT_TASK_TYPE__c == Constants.QA && tt.T1.Subject == Constants.QA){
                 caseLstToUpdateForQATask.add(new Case(id = tw.twCase.ID, IT_QA_External_Assignment__c = tt.T1.OwnerId));
               }
            }  
          }//end for loop for taskTLst
        }
      }//end for loop for taskWrapperList
      
      //insert tasks
      if(TaskToSavelst.size()>0){        
        insert TaskToSavelst;
      }
      
      //update cases for QA tasks
      if(caseLstToUpdateForQATask.size()>0){        
        update caseLstToUpdateForQATask;
      }
      
    }//end if
    
    //return back to list view
    PageReference cancel = setCon.cancel();
    return cancel;
  }
  
  public class TaskWrapper{
    public list<TaskT> taskTLst {get;set;}
    public Case twCase {get;set;}
  }
    
  public class TaskT {
    public Boolean isSelected{get;set;}
    public String Label1{get;set;}
    public Task T1{get;set;}
    public Integer Hours{get;set;}
  }
}