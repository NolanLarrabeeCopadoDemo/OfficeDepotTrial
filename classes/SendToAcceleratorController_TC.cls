@isTest
public class SendToAcceleratorController_TC {

    @isTest
    static void Test_SendCasesToAccelerator() {
        // Custom setting
        User usr = [Select id from User where Id = :UserInfo.getUserId()];
 
        System.RunAs(usr)
        {
            SFDCTaskTypes__c type = new SFDCTaskTypes__c(Name = 'Design');
            insert type;
        }
        
        Test.startTest();
        
        // Calling controller
        List<Case> cases = generateCasesWithTasks();
        ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(cases);
        setCon.setSelected(cases);
        SendToAcceleratorController controller = new SendToAcceleratorController(setCon);
        
        Id teamId = generateTeam();
        controller.selectedTagId = generateTag(teamId);
        controller.selectedSprintId = generateSprint(teamId);
        
        controller.getSprints();
        controller.getTags();
        controller.getSelected();
        
        controller.sendToAccelerator();
        controller.sendToAccelerator();
        
        Test.stopTest();
    }
    
    // Helper methods
    static Id generateTeam() {
        agf__ADM_Scrum_Team__c team = new agf__ADM_Scrum_Team__c(Name = 'TestScrumTeam',
                                                                agf__Cloud__c = 'IT');
        Database.SaveResult sr = Database.insert(team);
        Id teamId = sr.getId();
        return teamId;
    }
    
    static Id generateTag(id teamId) {
        agf__ADM_Product_Tag__c tag = new agf__ADM_Product_Tag__c(Name = 'TestProductTag',
                                                                 agf__Team__c = teamId);
        
        Database.SaveResult sr = Database.insert(tag);
        Id tagId = sr.getId();
        return tagId;
    }
    
    static Id generateSprint(id teamId) {
        agf__ADM_Sprint__c sprint = new agf__ADM_Sprint__c(Name = '2015.04a39-TestScrumTeam',
                                                          agf__Scrum_Team__c = teamId,
                                                          agf__Start_Date__c = Date.today(),
                                                          agf__End_Date__c = Date.today().addDays(7));
        
        Database.SaveResult sr = Database.insert(sprint);
        Id sprintId = sr.getId();
        return sprintId;
    }
    
    
    static List<Case> generateCasesWithTasks() {
        // Cases
        Case c = Test_Utils.createCase();
        c.Subject = 'TEST_CASE';
        update c;
        
        List<Case> cases = new List<Case>();
        cases.add(c);
        
        // Tasks
        List<Task> tasks = new List<Task>();
        
        for (Case cc: cases) {
            Task t = new Task(WhatId = cc.Id,
                              Subject = 'Design',
                              Status = 'New',
                              Priority = 'Normal',
                              Task_Type__c = 'IT',
                              IT_TASK_TYPE__c = 'Design',
                              OwnerId = Test_Utils.CreateUser().Id);
            tasks.add(t);
        }
        
        insert tasks;
        
        return cases;
    }
}