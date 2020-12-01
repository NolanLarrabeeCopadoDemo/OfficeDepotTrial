/*****************************************************************
Author          : Appirio India (Hitesh Pareek)
Date(original)  : Jan 14, 2016
Purpose         : Test class for Trigger handler- WorkTriggerHandler.cls, created as part of - S-374368
******************************************************************/
@isTest
private class WorkTriggerHandlerTest {

    static testMethod void testStoryUpdateSyncToSFDC() {
        agf__ADM_Scrum_Team__c team = new agf__ADM_Scrum_Team__c();
        team.Name = 'Test Scrum Team';
        team.agf__Cloud__c = 'IT';        
        
        insert team;
        system.assertNotEquals(null, team.id);
        
        agf__ADM_Product_Tag__c tag = new agf__ADM_Product_Tag__c();
        tag.name = 'Test';
        tag.agf__Active__c = true;
        tag.agf__Team__c = team.id;
        
        insert tag;
        system.assertNotEquals(null, tag.id);
        
        agf__ADM_Sprint__c sprint = new agf__ADM_Sprint__c();
        sprint.name = '2016.01c52-Hitesh';
        sprint.agf__Scrum_Team__c = team.id;
        sprint.agf__Start_Date__c = Date.today();
        sprint.agf__End_Date__c = Date.today().addDays(15);
        
        insert sprint;
        system.assertNotEquals(null, sprint.id);
        
        Id supportCaseRecTypeId = Schema.sObjectType.Case.getRecordTypeInfosByName().get('Support').getRecordTypeId();
        Case supportCase = new Case();
        supportCase.recordTypeId = supportCaseRecTypeId;
        supportCase.subject = 'test subject';
        supportCase.description = 'test description';
        
        insert supportCase;
        system.assertNotEquals(null, supportCase.id);
        
        agf__ADM_Work__c story = new agf__ADM_Work__c();
        story.agf__Subject__c = 'test story';
        story.agf__Product_Tag__c = tag.id;
        story.agf__Status__c = 'New';
        story.agf__Sprint__c = sprint.id;
        story.agf__Assignee__c = UserInfo.getUserId();
        story.Case_ID__c = supportCase.id;
        
        insert story;
        system.assertNotEquals(null, story.id);
        
        Test.startTest();
        
        story.agf__Status__c = 'In Progress';
        update story;
        
        Case supportcase_Updated = [select status from Case where id =:supportCase.id limit 1];
        system.assertEquals('In Progress', supportcase_Updated.status);
        
        story.agf__Status__c = 'Waiting';
        story.agf__QA_Engineer__c = UserInfo.getUserId();
        update story;
        
        supportcase_Updated = [select status from Case where id =:supportCase.id limit 1];
        system.assertEquals('Awaiting Information', supportcase_Updated.status);
        
        story.agf__Status__c = 'Ready for Review';        
        update story;
        
        supportcase_Updated = [select status from Case where id =:supportCase.id limit 1];
        system.assertEquals('In Progress', supportcase_Updated.status);
        
        // Added by Lalit for S-414434 Start
        story.agf__Status__c = 'QA In Progress';        
        update story;
        
        supportcase_Updated = [select status from Case where id =:supportCase.id limit 1];
        system.assertEquals('In Progress', supportcase_Updated.status);
        
        story.agf__Status__c = 'Pending Release';        
        update story;
        
        supportcase_Updated = [select status from Case where id =:supportCase.id limit 1];
        system.assertEquals('In Progress', supportcase_Updated.status);
        //Added by Lalit for S-414434 END
        
        Test.stopTest();
    }
}