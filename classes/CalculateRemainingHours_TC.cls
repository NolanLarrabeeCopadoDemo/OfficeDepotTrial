@isTest
public class CalculateRemainingHours_TC {
    
    @isTest
    static void withHours() {
        Id workId = createWork();
        
        agf__ADM_Task__c task = new agf__ADM_Task__c(agf__Starting_Hours__c = 7,
                                                     agf__Actual_Hours__c = 9,
                                                     agf__Assigned_To__c = Test_Utils.CreateUser().Id,
                                                     agf__Subject__c = 'Test',
                                                     agf__Work__c = workId);
        insert task;
    }
    
    @isTest
    static void withoutHours() {
        Id workId = createWork();
        
        agf__ADM_Task__c task = new agf__ADM_Task__c(agf__Assigned_To__c = Test_Utils.CreateUser().Id,
                                                     agf__Subject__c = 'Test',
                                                     agf__Work__c = workId);
        insert task;
    }
    
    static Id createWork() {
        Id tagId = createProductTag();
        
        agf__ADM_Work__c work = new agf__ADM_Work__c(agf__Subject__c = 'Test',
                                                     agf__Product_Tag__c = tagId,
                                                     agf__Assignee__c = Test_Utils.CreateUser().Id
                                                    );
        
        Database.SaveResult sr = Database.insert(work);
        Id workId = sr.getId();
        return workId;
    }
    
    static Id createProductTag() {
        Id teamId = generateTeam();
        
        agf__ADM_Product_Tag__c tag = new agf__ADM_Product_Tag__c(Name = 'TestProductTag',
                                                                  agf__Team__c = teamId);
        
        Database.SaveResult sr = Database.insert(tag);
        Id tagId = sr.getId();
        return tagId;
    }
    
    static Id generateTeam() {
        agf__ADM_Scrum_Team__c team = new agf__ADM_Scrum_Team__c(Name = 'TestScrumTeam',
                                                                 agf__Cloud__c = 'IT');
        Database.SaveResult sr = Database.insert(team);
        Id teamId = sr.getId();
        return teamId;
    }
}