public class SendToAcceleratorController {
    private Integer MAX_AC_LENGTH = 80;

    public String selectedSprintId {get; set;}
    public String selectedTagId {get; set;}
    ApexPages.StandardSetController setCon;
    private List<String> defaultTasks;

    
    public SendToAcceleratorController(ApexPages.StandardSetController setCon) {
        this.setCon = setCon;
        defaultTasks = new List<String>();
        
        if (SFDCTaskTypes__c.getAll().keyset() != null && SFDCTaskTypes__c.getAll().keyset().size() > 0) {    //Added this if block by Lalit for S-404753
            defaultTasks.addAll(SFDCTaskTypes__c.getAll().keyset());
        }  
    }
    
    public List<SelectOption> getSprints() {
        List<SelectOption> sprints = new List<SelectOption>();
        
        for (agf__ADM_Sprint__c sp : [SELECT Id, Name FROM agf__ADM_Sprint__c ORDER BY LastModifiedDate DESC]) {
            sprints.add(new SelectOption(sp.Id, sp.Name));    
        }
        
        return sprints;
    }
    
    public List<SelectOption> getTags() {
        List<SelectOption> tags = new List<SelectOption>();
        
        for (agf__ADM_Product_Tag__c t : [SELECT Id, Name FROM agf__ADM_Product_Tag__c ORDER BY LastModifiedDate DESC]) {
            tags.add(new SelectOption(t.Id, t.Name));    
        }
        
        return tags;
    }

    public void sendToAccelerator() {
        // Get stories selected to send to accelerator
        List<Case> selectedList = (List<Case>)setCon.getSelected();

        List<Case> selectedCases = [SELECT Id, IT_Resolution__c, CaseNumber, Subject, Description, IT_Assignment__c, IT_BU_Reviewer__c, 
                                IT_QA_External_Assignment__c, Rank__c, IT_Impact__c FROM Case WHERE Id IN :selectedList];
        
        // Get selected stories already in accelerator
        Map<Id, agf__ADM_Work__c> migratedCases = new Map<Id, agf__ADM_Work__c>();
        for (agf__ADM_Work__c w : [SELECT Id, Case_Id__c FROM agf__ADM_Work__c WHERE Case_Id__c IN :selectedList]) {
            migratedCases.put(w.Case_Id__c, w);
        }
        
        // Get sprint and related team
        agf__ADM_Sprint__c[] selectedSprint = [SELECT Id, agf__Scrum_Team__c FROM agf__ADM_Sprint__c WHERE Id = :selectedSprintId];
        Id team = selectedSprint[0].agf__Scrum_Team__c;
        
        // Insert/update user stories 
        List<agf__ADM_Work__c> newStories = new List<agf__ADM_Work__c>();
        List<agf__ADM_Work__c> storiesToUpdate = new List<agf__ADM_Work__c>();
        
        for (Case c : selectedCases) {
            // Get decimal from resolution
            decimal points;
            
            try {
                String[] resolutionSplit = c.IT_Resolution__c.split(' ');
                points = Decimal.valueOf(resolutionSplit[0]);
            } catch (Exception e) {
                points = 0;
            }
            
            // If story hasn't been migrated yet, create new
            if (!migratedCases.containsKey(c.Id)) {
                agf__ADM_Work__c w = new agf__ADM_Work__c(agf__Subject__c = c.CaseNumber.substring(2) + ' - ' + c.Subject,
                                                            agf__Details__c = c.Description,
                                                            agf__Story_Points__c = points,
                                                            agf__Assignee__c = c.IT_Assignment__c,
                                                            agf__Product_Owner__c = c.IT_BU_Reviewer__c,
                                                            agf__QA_Engineer__c = c.IT_QA_External_Assignment__c,
                                                            agf__Priority_Rank__c = c.Rank__c,
                                                            agf__Sprint__c = selectedSprintId,
                                                            agf__Product_Tag__c = selectedTagId,
                                                            agf__Scrum_Team__c = team,
                                                            case_Id__c = c.Id
                                                            );
                newStories.add(w);
            }
            else { // Update story
                agf__ADM_Work__c existingWork = migratedCases.get(c.Id);
                existingWork.agf__Subject__c = c.CaseNumber + ' - ' + c.Subject;
                existingWork.agf__Details__c = c.Description;
                existingWork.agf__Story_Points__c = points;
                existingWork.agf__Assignee__c = c.IT_Assignment__c;
                existingWork.agf__Product_Owner__c = c.IT_BU_Reviewer__c;
                existingWork.agf__QA_Engineer__c = c.IT_QA_External_Assignment__c;
                existingWork.agf__Priority_Rank__c = c.Rank__c;
                existingWork.agf__Sprint__c = selectedSprintId;
                existingWork.agf__Product_Tag__c = selectedTagId;
                existingWork.agf__Scrum_Team__c = team;
                existingWork.case_Id__c = c.Id;
                
                storiesToUpdate.add(existingWork);
            }
        }
        
        // Insert new works
        Database.SaveResult[] insertedStories = Database.insert(newStories);
        List<Id> newStoriesIds = new List<Id>();
        for (Database.SaveResult sr : insertedStories) {
            newStoriesIds.add(sr.getId());
        }
        
        // Update existing works
        Database.SaveResult[] updatedStories = Database.update(storiesToUpdate);
        
        // All modified works IDs
        Map<Id, agf__ADM_Work__c> modifiedWorks = new Map<Id, agf__ADM_Work__c>(migratedCases);
        for (agf__ADM_Work__c w : [SELECT Id, Case_Id__c FROM agf__ADM_Work__c WHERE Id IN :newStoriesIds]) {
            modifiedWorks.put(w.Case_Id__c, w);
        }
        
        // Acceptance criteria and tasks
        List<agf__ADM_Acceptance_Criterion__c> existingAcceptanceCriteria = [SELECT Id
                                                                            FROM agf__ADM_Acceptance_Criterion__c 
                                                                            WHERE agf__Work__c IN :storiesToUpdate];
                                                                            
        List<agf__ADM_Task__c> existingTasks = [SELECT Id, agf__Work__c, agf__Subject__c, Task_ID__c 
                                                FROM agf__ADM_Task__c
                                                WHERE agf__Work__c IN :storiesToUpdate];
                                                                            
        List<agf__ADM_Acceptance_Criterion__c> newCriteria = new List<agf__ADM_Acceptance_Criterion__c>();
        List<agf__ADM_Task__c> newTasks = new List<agf__ADM_Task__c >();
        List<agf__ADM_Task__c> updatedTasks = new List<agf__ADM_Task__c >();
        List<agf__ADM_Task__c> cancelledTasks = new List<agf__ADM_Task__c >();
        
        for (Case c : selectedCases) {            
            // Acceptance criteria - shorten name
            String acName = c.Subject;
            if (acName.length() >= MAX_AC_LENGTH) {
                acName = acName.substring(0, MAX_AC_LENGTH-1);
            }
            
            agf__ADM_Acceptance_Criterion__c ac = new agf__ADM_Acceptance_Criterion__c(Name = acName,
                                                                                        agf__Description__c = c.IT_Impact__c,
                                                                                        agf__Work__c = modifiedWorks.get(c.Id).Id
                                                                                        );
            newCriteria.add(ac);
            
            // Default tasks
            boolean createTask;
            
            for (Task t : [SELECT Id, Subject, OwnerId, Status, Estimated_LOE__c FROM Task WHERE Subject IN :defaultTasks AND WhatId = :c.Id]) {
                createTask = true;
             
                // Check that task doesn't exist already in work
                if (migratedCases.containsKey(c.Id)) {
                    for (agf__ADM_Task__c agfTask : existingTasks) {
                        if (agfTask.Task_ID__c == t.Id) {
                            // Update LOE
                            agfTask.agf__Starting_Hours__c = t.Estimated_LOE__c;
                            
                            // Update assignment
                            agfTask.agf__Assigned_To__c = t.OwnerId;
                            
                            // Update task status
                            if (t.Status == 'New') {
                                agfTask.agf__Status__c = 'Not Started';
                                updatedTasks.add(agfTask);
                            }
                            else if (t.Status == 'In Progress') {
                                agfTask.agf__Status__c = 'In Progress';
                                updatedTasks.add(agfTask);
                            }
                            else if (t.Status == 'Completed') {
                                agfTask.agf__Status__c = 'Completed';
                                updatedTasks.add(agfTask);
                            }
                            else if (t.Status == 'Cancelled') {
                                cancelledTasks.add(agfTask);
                            }
                            
                            createTask = false;
                            break;
                        }
                    }
                }
                
                // Create new tasks
                if (createTask) {
                    String taskStatus = '';

                    if (t.Status == 'New') {
                        taskStatus = 'Not Started';
                    }
                    else if (t.Status == 'In Progress') {
                        taskStatus = 'In Progress';
                    }
                    else if (t.Status == 'Completed') {
                        taskStatus = 'Completed';
                    }
                    
                    if (taskStatus != '') {
                        agf__ADM_Task__c accTask = new agf__ADM_Task__c(agf__Work__c = modifiedWorks.get(c.Id).Id,
                                                                        agf__Assigned_To__c = t.OwnerId,
                                                                        agf__SprintId__c = selectedSprintId,
                                                                        agf__Subject__c = t.Subject,
                                                                        agf__Status__c = taskStatus,
                                                                        agf__Starting_Hours__c = t.Estimated_LOE__c,
                                                                        agf__Hours_Remaining__c = t.Estimated_LOE__c,
                                                                        agf__Actual_Hours__c = 0,
                                                                        Task_ID__c = t.Id
                                                                        );
                        newTasks.add(accTask);
                    }
                }
            }
        }
        
        delete(existingAcceptanceCriteria);
        insert(newCriteria);
        insert(newTasks);
        update(updatedTasks);
        delete(cancelledTasks);
    }
    
    public List<Case> getSelected() {
        return setCon.getSelected();
    }
}