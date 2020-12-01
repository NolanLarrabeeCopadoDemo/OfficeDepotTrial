// Appirio 2016 
//
// NBOCK - Modified 2.5.2016 S-377008 
//
public class ITTaskAutomationController {

    public ID caseid {get;set;}
    private ApexPages.StandardController controller {get; set;}
    Public list<TaskT> Tasklst{get;set;}
    Public list<Task> TaskToSavelst{get;set;}


    public ITTaskAutomationController (ApexPages.StandardController c1) {
       caseid = ApexPages.currentPage().getParameters().get('ID');     
       Tasklst = new list<TaskT>();
       TaskToSavelst = new list<Task>();
  
      // Get a list of picklist values from an existing object field.
      list<SelectOption> options = new list<SelectOption>();
      // Get the object type of the SObject. (Task)
      Schema.sObjectType objType = Task.getSObjectType(); 
      // Describe the SObject using its object type.
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe(); 
      // Get a map of fields for the SObject      
      map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
      // Get the list of picklist values for this field. 
      list<Schema.PicklistEntry> values = fieldMap.get('IT_TASK_TYPE__c').getDescribe().getPickListValues();
      
      //NBOCK S-377008 2.5.2016 - added 'UAT Migration' value
      for (Schema.PicklistEntry a : values)
      {     
         if(a.getValue() == 'Usability' || a.getValue() == 'Design' || a.getValue() == 'Build/Unit Test' || a.getValue() == 'QA' || a.getValue() == 'Code Review' || a.getValue() == 'UAT Migration'){
                Task tsk = new Task(); 
                tsk.whatId = caseid;
                tsk.Task_Type__c = 'IT';
                tsk.IT_TASK_TYPE__c = a.getValue();
                
                TaskT  t = new TaskT(); 
                t.T1 = tsk;
                t.isSelected = false;
                t.Label1 = a.getValue();
                tsk.subject = t.Label1;
                tsk.Estimated_LOE__c = t.Hours;
                Tasklst.add(t);
           }
           
           else {
              Task tsk = new Task(); 
                tsk.whatId = caseid;
                tsk.Task_Type__c = 'Business';
                tsk.IT_TASK_TYPE__c = a.getValue();
                
                TaskT  t = new TaskT(); 
                t.T1 = tsk;
                t.isSelected = false;
                t.Label1 = a.getValue();
                tsk.subject = t.Label1;
                tsk.Estimated_LOE__c = t.Hours;
                Tasklst.add(t);
           
           
           
           
           
           }
         
        
      }
       //System.debug('^^^^^^^^^^^^^'+Tasklst);
    }
    
    public PageReference save() {
     Case caseToBeUpdated = null;//Added by Lalit for S-407214
     if(Tasklst.size()>0){
            for(TaskT h: Tasklst){
            //System.debug('^^^^^^^^^^^^^HHHJH'+h);
            //System.debug('^^^^^^^^^^^^^H'+h.T1.OwnerID);
                if((h.isSelected)&&(h.T1.OwnerID !=null)){
                    TaskToSavelst.add(h.T1);
                    if(h.T1.IT_TASK_TYPE__c == Constants.QA && h.T1.Subject == Constants.QA){//Added this if block by Lalit for S-407214
                    	caseToBeUpdated = new Case(id = caseid, IT_QA_External_Assignment__c = h.T1.OwnerId) ;
                    }
                }
            }
     
         }
         if(TaskToSavelst.size()>0){        
             insert TaskToSavelst;
         }
         if(caseToBeUpdated!=null && caseToBeUpdated.id!=null){//Added this if block by Lalit for S-407214
         	Update caseToBeUpdated;
         }
     
       PageReference p1 = new PageReference('/'+caseid);
       p1.setRedirect(true);
       return p1; 
    }
    
    public PageReference cancel() {
       PageReference p1 = new PageReference('/'+caseid);
       p1.setRedirect(true);
       return p1;
  }
    
    public class TaskT {
     public Boolean isSelected{get;set;}
     public  String Label1{get;set;}
     public Task T1{get;set;}
     public Integer Hours{get;set;}
    
    }

}