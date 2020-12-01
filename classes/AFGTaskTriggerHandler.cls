/*****************************************************************
Author          : Appirio India (Hitesh Pareek)
Date(original)  : Jan 19, 2016
Purpose         : Trigger handler for trigger - afgTaskTrigger.trigger on task - S-374370
Modifications   : 
    07 July, 2016   Nick Sharp    S-423436 - added delete method
******************************************************************/

public without sharing class AFGTaskTriggerHandler {
    //Added by Jyoti for Story S-410497
    public static final string COMPLETED = 'Completed';
    public static void afterUpdateHandler(Map<Id, agf__ADM_Task__c> oldRecords, Map<Id, agf__ADM_Task__c> newRecords){
        // check the currengt task and update the corresponding SFDC support's task if required
            syncSupportcaseTask(oldRecords,newRecords);
    }
    //START NSHARP S-423436 07.07.2016
    public static void onBeforeDelete(List<agf__ADM_Task__c> newLst){
        updateStatusAndCaseComment(newLst);
    }
    //END NSHARP S-423436 07.07.2016

    private static void syncSupportcaseTask(Map<Id, agf__ADM_Task__c> oldRecords, Map<Id, agf__ADM_Task__c> newRecords){
        map<Id,Task> afTaskToSupportTaskMap = new map<Id,Task>();
        map<Id, Task> supportTaskmap;
        set<Id> taskIds = new set<Id>();
        set<Id> SFtaskIds = new set<Id>();//Added by Lalit for S-407213
        map<Id, Task> SFTaskmap;//Added by Lalit for S-407213
        map<String,String> sfTaskIdAssignedToMap = new map<String,String>();//Added by Lalit for S-407213
        Map<Id, Case> supportCaseMapToBeUpdated = new Map<Id, Case>();//Added by Lalit for S-407213
        List<Task> SFTaskOwnerToBeUpdated = new List<Task>();//Added by Lalit for S-407213
        for(agf__ADM_Task__c task :newRecords.values()){
            if(oldRecords.get(task.id).agf__Status__c != task.agf__Status__c && task.Task_ID__c != null && task.Task_ID__c != ''){
                afTaskToSupportTaskMap.put(task.id, new Task(id = task.Task_ID__c));
                taskIds.add(task.Task_ID__c);
            }
            //Added by Lalit for S-407213 START
            if(oldRecords.get(task.id).agf__Assigned_To__c != task.agf__Assigned_To__c && task.Task_ID__c != null && task.Task_ID__c != ''){
                SFtaskIds.add(task.Task_ID__c);
                sfTaskIdAssignedToMap.put(task.Task_ID__c, task.agf__Assigned_To__c);
            }
            //Added by Lalit for S-407213 END
        }
        //Added by Lalit for S-407213 START
        if(SFtaskIds.size() > 0){
            SFTaskmap = new map<Id,Task>([select IT_TASK_TYPE__c, WRF_Task_Complete_Dt__c, Description, WhatId from Task where id in:SFtaskIds]);
            
            if(!SFTaskmap.isEmpty()){
                for(Task t : SFTaskmap.values()){
                    System.debug('========>t.IT_TASK_TYPE__c'+t.IT_TASK_TYPE__c);
                    if(t.IT_TASK_TYPE__c== Constants.DESIGN || t.IT_TASK_TYPE__c == Constants.BUILD_UNIT_TEST){
                        t.OwnerId = sfTaskIdAssignedToMap.get(t.id);
                        SFTaskOwnerToBeUpdated.add(t);
                        if(!supportCaseMapToBeUpdated.containsKey(t.WhatId)){
                            Case c = new Case(id=t.WhatId,IT_Assignment__c = sfTaskIdAssignedToMap.get(t.id));
                            supportCaseMapToBeUpdated.put(t.WhatId, c);
                        }
                        else{
                            supportCaseMapToBeUpdated.get(t.WhatId).IT_Assignment__c = sfTaskIdAssignedToMap.get(t.id);
                        }
                    }
                    else if(t.IT_TASK_TYPE__c== Constants.CODE_REVIEW || t.IT_TASK_TYPE__c == Constants.UAT_MiGRATION || t.IT_TASK_TYPE__c == Constants.ARB_REQUIRED || t.IT_TASK_TYPE__c == Constants.USABILITY){
                        t.OwnerId = sfTaskIdAssignedToMap.get(t.id);
                        SFTaskOwnerToBeUpdated.add(t);
                    }
                    else if(t.IT_TASK_TYPE__c== Constants.QA){
                        t.OwnerId = sfTaskIdAssignedToMap.get(t.id);
                        SFTaskOwnerToBeUpdated.add(t);
                        if(!supportCaseMapToBeUpdated.containsKey(t.WhatId)){
                            Case c = new Case(id=t.WhatId,IT_QA_External_Assignment__c = sfTaskIdAssignedToMap.get(t.id));
                            supportCaseMapToBeUpdated.put(t.WhatId, c);
                        }
                        else{
                            supportCaseMapToBeUpdated.get(t.WhatId).IT_QA_External_Assignment__c = sfTaskIdAssignedToMap.get(t.id);
                        }
                    }
                    else if(t.IT_TASK_TYPE__c == Constants.UAT){
                        t.OwnerId = sfTaskIdAssignedToMap.get(t.id);
                        SFTaskOwnerToBeUpdated.add(t);
                        if(!supportCaseMapToBeUpdated.containsKey(t.WhatId)){
                            Case c = new Case(id=t.WhatId,IT_BU_Reviewer__c = sfTaskIdAssignedToMap.get(t.id));
                            supportCaseMapToBeUpdated.put(t.WhatId, c);
                        }
                        else{
                            supportCaseMapToBeUpdated.get(t.WhatId).IT_BU_Reviewer__c = sfTaskIdAssignedToMap.get(t.id);
                        }
                    }
                }
            }
        }
        if(SFTaskOwnerToBeUpdated.size() > 0){
            update SFTaskOwnerToBeUpdated;
        }
        if(supportCaseMapToBeUpdated.size() > 0){
            update supportCaseMapToBeUpdated.values();
        }
        //Added by Lalit for S-407213 END
        if(taskIds.size() >0)
            //Added status field in below query by Jyoti for Story S-410497
            supportTaskmap = new map<Id,Task>([select IT_TASK_TYPE__c, Status, WRF_Task_Complete_Dt__c, Description from Task where id in:taskIds]);

        if(!afTaskToSupportTaskMap.isEmpty()){
            List<Task> tasksToBeUpdated = new List<Task>();
            for(Id afTaskId :afTaskToSupportTaskMap.keySet()){
                agf__ADM_Task__c afTask = newRecords.get(afTaskId);
                Task supportTask = afTaskToSupportTaskMap.get(afTaskId);
               //Added by Kritika Bhati ON 09/30/2016 for Case#00179196
               //Added if statement
	        if(supportTaskmap.containsKey(supportTask.id) && !(supportTaskmap.get(supportTask.id).status  == COMPLETED && (supportTaskmap.get(supportTask.id).IT_TASK_TYPE__c == 'UAT' || supportTaskmap.get(supportTask.id).IT_TASK_TYPE__c == 'Code Review'))){ 				
                
                //If the task is moved to the "In Progress" column in Agile Accelerator, the status on the related task in Salesforce on the support case should be equal to "In Progress."
                if(afTask.agf__Status__c == 'In Progress'){
                    supportTask.status = 'In Progress';
                    //Start - Added by Jyoti for Story S-410497
                    if(oldRecords.get(afTaskId).agf__Status__c == COMPLETED)
                        supportTask.Description = '';
                    //End - Story S-410497    
                    tasksToBeUpdated.add(supportTask);
                }
                //Added supportTask.status condition by Jyoti for Story S-410497
                else if(afTask.agf__Status__c == 'Completed' && supportTaskmap.containsKey(supportTask.id) && supportTaskmap.get(supportTask.id).status  != COMPLETED ){
                    supportTask.status = 'Completed';
                    supportTask.WRF_Task_Complete_Dt__c = DateTime.now();
                    if(supportTaskmap.containsKey(supportTask.id)){
                        if(supportTaskmap.get(supportTask.id).IT_TASK_TYPE__c == 'Design'){
                            supportTask.Description = 'Design completed';
                        }else if(supportTaskmap.get(supportTask.id).IT_TASK_TYPE__c == 'Build/Unit Test'){
                            supportTask.Description = 'Build/Unit Test completed / manifest items added';
                        }else if(supportTaskmap.get(supportTask.id).IT_TASK_TYPE__c == 'Code Review'){
                            supportTask.Description = 'Code review completed';
                        }else if(supportTaskmap.get(supportTask.id).IT_TASK_TYPE__c == 'QA'){
                            supportTask.Description = 'QA testing completed / test cases and scripts added';
                        }else if(supportTaskmap.get(supportTask.id).IT_TASK_TYPE__c == 'UAT'){
                            supportTask.Description = 'UAT testing completed';
                        }else if(supportTaskmap.get(supportTask.id).IT_TASK_TYPE__c == 'Usability'){
                            supportTask.Description = 'Usability completed';
                        }else if(supportTaskmap.get(supportTask.id).IT_TASK_TYPE__c == 'ARB Required'){
                            supportTask.Description = 'ARB Review completed';
                        }
                        else if(supportTaskmap.get(supportTask.id).IT_TASK_TYPE__c == Constants.UAT_MiGRATION){//Added this if block by Lalit for S-404756
                            supportTask.Description = Constants.MiGRATION_TO_UAT_COMPLETED;
                        }
                    }
                    tasksToBeUpdated.add(supportTask);
                }else if(oldRecords.get(afTaskId).agf__Status__c == 'Completed' && (afTask.agf__Status__c == 'In Progress' || afTask.agf__Status__c == 'Not Started')){
                    if(afTask.agf__Status__c == 'Not Started')
                        supportTask.status = 'New';
                    if(afTask.agf__Status__c == 'In Progress')
                        supportTask.status = 'In Progress';
                    //Added by Jyoti for Story S-410497    
                    supportTask.Description = '';                      
                    tasksToBeUpdated.add(supportTask);
                }else if(oldRecords.get(afTaskId).agf__Status__c == 'In Progress' && afTask.agf__Status__c == 'Not Started'){
                    supportTask.status = 'New';
                    tasksToBeUpdated.add(supportTask);
                }else
                    continue;
		    
             }
            }
			//End Case#00179196
            if(tasksToBeUpdated.size() > 0)
                update tasksToBeUpdated;
        }
    }

    //START NSHARP S-423436 07.07.2016
    public static void updateStatusAndCaseComment(List<agf__ADM_Task__c> newLst){
        Set<Id> taskSet = new Set<Id>();
        List<Task> taskList = new List<Task>();
        List<CaseComment> commentList = new List<CaseComment>();
        
        for(agf__ADM_Task__c a: newLst){
            taskSet.add(a.Task_ID__c);
        }

        for(Task t: [SELECT Id, WhatId, Status, Subject, IT_TASK_TYPE__c, Action__c, Outcome__c, WRF_Task_Complete_Dt__c,LastModifiedBy.Name,Description FROM Task WHERE Id IN: taskSet AND Status != 'Completed']){
            //update task status and add to list for update
            t.Status = 'Cancelled';
            taskList.add(t);
            //create case comment for cancelled task
            CaseComment c = new CaseComment();
            c.ParentId = t.WhatId;
            String comment = 'Task deleted from Agile Accelerator - marked as not required (CANCELLED)\n';
            comment += 'Task Subject: ' + nullCheck(t.Subject) + '\n';
            comment += 'Task Type: ' + nullCheck(t.IT_TASK_TYPE__c) + '\n';
            comment += 'Action: ' + nullCheck(t.Action__c) + '\n';
            comment += 'Outcome: ' + nullCheck(t.Outcome__c) + '\n';
            comment += 'Completion Date: ' + nullCheck(t.WRF_Task_Complete_Dt__c) + '\n';
            comment += 'Completed By: ' + t.LastModifiedBy.Name + '\n';
            comment += 'Task Comment: CANCELLED';
            c.CommentBody = comment;
            commentList.add(c);
        }

        if(!taskList.isEmpty()){
            update taskList;
        }
        if(!commentList.isEmpty()){
            insert commentList;
        }
    }

    public static String nullCheck(String str){
        if(str==null){
                return '';
            }
        else{
            return str.escapeHtml4();
        }
    }

    public static String nullCheck(DateTime d){
        if(d == null){
            return '';
        }
        else{
            return d.format();
        }
    }
    //END NSHARP S-423436 07.07.2016
}