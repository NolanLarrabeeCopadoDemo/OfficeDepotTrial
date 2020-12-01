/*****************************************************************
Author          : Appirio India (Hitesh Pareek)
Date(original)  : Jan 19, 2016
Purpose         : Test class for Trigger handler - AFGTaskTriggerHandler.cls on task - S-374370
******************************************************************/
@isTest
private class AFGTaskTriggerHandlerTest {


    static testMethod void testTaskUpdateToSFDC() {
        //Added by Lalit for S-407213 START
        //Start - Added by Jyoti for Story S-410497
        Id profileId=userinfo.getProfileId();
        user u = new user(email='abc.xyz@officedepot.com',Username='jasmet@acme.com',FirstName ='test123', LastName='xyz123', Alias='a', CommunityNickname='aa', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId=profileId, LanguageLocaleKey='en_US');
        //End - Story S-410497
        //Start - commented by Jyoti for Story S-410497
        //user u2=[SELECT id,ProfileId,OD_Employee_ID__c,TimeZoneSidKey FROM USER WHERE id =:UserInfo.getUserId()];
        //user u = new user(email='abc.xyz@officedepot.com',Username='jasmet@acme.com',FirstName ='test123', LastName='xyz123', Alias='a', CommunityNickname='aa', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId=u2.ProfileId, LanguageLocaleKey='en_US');
        //End - Story S-410497
        u.isActive = true;
        insert u ;
        //Added by Lalit for S-407213 END
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
        supportCase.IT_BU_Reviewer__c = Userinfo.getUserId();//Added by Lalit for S-407213

        insert supportCase;
        system.assertNotEquals(null, supportCase.id);
        List<Task> taskList = new List<Task>(); // Added by Jyoti for Story S-410497
        Task t = new Task();
        t.WhatId = supportCase.id;
        t.subject = 'test sub';
        t.ActivityDate = Date.today();
        t.IT_TASK_TYPE__c = 'Design';
        //insert t; // Commeted by Jyoti for Story S-410497
        taskList.add(t);  //Added by Jyoti for Story S-410497

        //Added by Lalit for S-404756 START
        Task uatMigration = new Task();
        uatMigration.WhatId = supportCase.id;
        uatMigration.subject = 'test UAT Migration';
        uatMigration.ActivityDate = Date.today();
        uatMigration.IT_TASK_TYPE__c = 'UAT Migration';
        //insert uatMigration; // Commeted by Jyoti for Story S-410497
        //Start - Added by Jyoti for Story S-410497
        taskList.add(uatMigration);
        insert taskList;
        //End - Added by Jyoti for Story S-410497

        //Added by Lalit for S-404756 END

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
        agf__ADM_Task__c agfTask = new agf__ADM_Task__c();
        agfTask.agf__Work__c = story.id;
        agfTask.Task_ID__c = t.id;
        agfTask.agf__Status__c = 'Not Started';
        agfTask.agf__Subject__c = 'test sub';
        agfTask.agf__Assigned_To__c = UserInfo.getUserId();
        insert agfTask;
        system.assertNotEquals(null, agfTask.id);
        //Added by Lalit for S-407213 START
        agfTask.agf__Assigned_To__c = u.id;
        Update agfTask;



        Task updatedTask = [Select OwnerId,WhatId from Task where id = :t.id limit 1];
        Case updatedSupportCase = [select IT_Assignment__c from Case where id = :updatedTask.WhatId limit 1];
        System.assert(updatedTask.OwnerId==agfTask.agf__Assigned_To__c);
        System.assert(updatedSupportCase.IT_Assignment__c==agfTask.agf__Assigned_To__c);

        //Added by Lalit for S-407213 END
        //Added by Lalit for S-404756 START
        agf__ADM_Task__c agfMigrationTask = new agf__ADM_Task__c();
        agfMigrationTask.agf__Work__c = story.id;
        agfMigrationTask.Task_ID__c = uatMigration.id;
        agfMigrationTask.agf__Status__c = 'Not Started';
        agfMigrationTask.agf__Subject__c = 'test UAT Migration';
        agfMigrationTask.agf__Assigned_To__c = UserInfo.getUserId();
        insert agfMigrationTask;
        //Added by Lalit for S-404756 END


        agfTask.agf__Status__c = 'In Progress';
        update agfTask;

        Task suppTask = [select status,Description from Task where id =:t.id limit 1];
        system.assertEquals('In Progress', suppTask.status);


		//Modified [commented] for S-423439
       /* agfTask.agf__Status__c = 'Completed';
        update agfTask;

        suppTask = [select status,Description from Task where id =:t.id limit 1];
        system.assertEquals('Completed', suppTask.status);
        system.assertEquals('Design completed',suppTask.Description);


		*/
        //Start - Commented by Jyoti for Story S-410497
        /*agfTask.agf__Status__c = 'In Progress';
        update agfTask;

        suppTask = [select status,Description from Task where id =:t.id limit 1];
        system.assertEquals('In Progress', suppTask.status);
        */
        //End - Story S-410497

        //Added by Lalit for S-404756 START
       /* agfMigrationTask.agf__Status__c = 'Completed';
        update agfMigrationTask;
        suppTask = [select status,Description from Task where id =:uatMigration.id limit 1];
        system.assertEquals('Completed', suppTask.status);
        //Added by Lalit for S-404756 END

        agfTask.agf__Status__c = 'Not Started';
        update agfTask;

        suppTask = [select status,Description from Task where id =:t.id limit 1];
        system.assertEquals('New', suppTask.status);*/
        //END S-423439
        Test.stopTest();
    }

	//Added for S-423439
     static testMethod void testTaskUpdateToSFDC2() {
     	 //Added by Lalit for S-407213 START
        //Start - Added by Jyoti for Story S-410497
        Id profileId=userinfo.getProfileId();
        user u = new user(email='abc.xyz@officedepot.com',Username='jasmet@acme.com',FirstName ='test123', LastName='xyz123', Alias='a', CommunityNickname='aa', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId=profileId, LanguageLocaleKey='en_US');
        //End - Story S-410497
        //Start - commented by Jyoti for Story S-410497
        //user u2=[SELECT id,ProfileId,OD_Employee_ID__c,TimeZoneSidKey FROM USER WHERE id =:UserInfo.getUserId()];
        //user u = new user(email='abc.xyz@officedepot.com',Username='jasmet@acme.com',FirstName ='test123', LastName='xyz123', Alias='a', CommunityNickname='aa', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId=u2.ProfileId, LanguageLocaleKey='en_US');
        //End - Story S-410497
        u.isActive = true;
        insert u ;
        //Added by Lalit for S-407213 END
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
        supportCase.IT_BU_Reviewer__c = Userinfo.getUserId();//Added by Lalit for S-407213

        insert supportCase;
        system.assertNotEquals(null, supportCase.id);
        List<Task> taskList = new List<Task>(); // Added by Jyoti for Story S-410497
        Task t = new Task();
        t.WhatId = supportCase.id;
        t.subject = 'test sub';
        t.ActivityDate = Date.today();
        t.IT_TASK_TYPE__c = 'Design';
        //insert t; // Commeted by Jyoti for Story S-410497
        taskList.add(t);  //Added by Jyoti for Story S-410497

        //Added by Lalit for S-404756 START
        Task uatMigration = new Task();
        uatMigration.WhatId = supportCase.id;
        uatMigration.subject = 'test UAT Migration';
        uatMigration.ActivityDate = Date.today();
        uatMigration.IT_TASK_TYPE__c = 'UAT Migration';
        //insert uatMigration; // Commeted by Jyoti for Story S-410497
        //Start - Added by Jyoti for Story S-410497
        taskList.add(uatMigration);
        insert taskList;
        //End - Added by Jyoti for Story S-410497

        //Added by Lalit for S-404756 END

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
        agf__ADM_Task__c agfTask = new agf__ADM_Task__c();
        agfTask.agf__Work__c = story.id;
        agfTask.Task_ID__c = t.id;
        agfTask.agf__Status__c = 'Not Started';
        agfTask.agf__Subject__c = 'test sub';
        agfTask.agf__Assigned_To__c = UserInfo.getUserId();
        insert agfTask;
        system.assertNotEquals(null, agfTask.id);
        //Added by Lalit for S-407213 START
        agfTask.agf__Assigned_To__c = u.id;
        Update agfTask;



        Task updatedTask = [Select OwnerId,WhatId from Task where id = :t.id limit 1];
        Case updatedSupportCase = [select IT_Assignment__c from Case where id = :updatedTask.WhatId limit 1];
        System.assert(updatedTask.OwnerId==agfTask.agf__Assigned_To__c);
        System.assert(updatedSupportCase.IT_Assignment__c==agfTask.agf__Assigned_To__c);

        //Added by Lalit for S-407213 END
        //Added by Lalit for S-404756 START
        agf__ADM_Task__c agfMigrationTask = new agf__ADM_Task__c();
        agfMigrationTask.agf__Work__c = story.id;
        agfMigrationTask.Task_ID__c = uatMigration.id;
        agfMigrationTask.agf__Status__c = 'Not Started';
        agfMigrationTask.agf__Subject__c = 'test UAT Migration';
        agfMigrationTask.agf__Assigned_To__c = UserInfo.getUserId();
        insert agfMigrationTask;
        //Added by Lalit for S-404756 END

        agfTask.agf__Status__c = 'Completed';
        update agfTask;

        Task suppTask = [select status,Description from Task where id =:t.id limit 1];
        system.assertEquals('Completed', suppTask.status);
        system.assertEquals('Design completed',suppTask.Description);
     	Test.stopTest();
     }

	  static testMethod void testTaskUpdateToSFDC3() {
        //Added by Lalit for S-407213 START
        //Start - Added by Jyoti for Story S-410497
        Id profileId=userinfo.getProfileId();
        user u = new user(email='abc.xyz@officedepot.com',Username='jasmet@acme.com',FirstName ='test123', LastName='xyz123', Alias='a', CommunityNickname='aa', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId=profileId, LanguageLocaleKey='en_US');
        //End - Story S-410497
        //Start - commented by Jyoti for Story S-410497
        //user u2=[SELECT id,ProfileId,OD_Employee_ID__c,TimeZoneSidKey FROM USER WHERE id =:UserInfo.getUserId()];
        //user u = new user(email='abc.xyz@officedepot.com',Username='jasmet@acme.com',FirstName ='test123', LastName='xyz123', Alias='a', CommunityNickname='aa', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId=u2.ProfileId, LanguageLocaleKey='en_US');
        //End - Story S-410497
        u.isActive = true;
        insert u ;
        //Added by Lalit for S-407213 END
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
        supportCase.IT_BU_Reviewer__c = Userinfo.getUserId();//Added by Lalit for S-407213

        insert supportCase;
        system.assertNotEquals(null, supportCase.id);
        List<Task> taskList = new List<Task>(); // Added by Jyoti for Story S-410497
        Task t = new Task();
        t.WhatId = supportCase.id;
        t.subject = 'test sub';
        t.ActivityDate = Date.today();
        t.IT_TASK_TYPE__c = 'Design';
        //insert t; // Commeted by Jyoti for Story S-410497
        taskList.add(t);  //Added by Jyoti for Story S-410497

        //Added by Lalit for S-404756 START
        Task uatMigration = new Task();
        uatMigration.WhatId = supportCase.id;
        uatMigration.subject = 'test UAT Migration';
        uatMigration.ActivityDate = Date.today();
        uatMigration.IT_TASK_TYPE__c = 'UAT Migration';
        //insert uatMigration; // Commeted by Jyoti for Story S-410497
        //Start - Added by Jyoti for Story S-410497
        taskList.add(uatMigration);
        insert taskList;
        //End - Added by Jyoti for Story S-410497

        //Added by Lalit for S-404756 END

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
        agf__ADM_Task__c agfTask = new agf__ADM_Task__c();
        agfTask.agf__Work__c = story.id;
        agfTask.Task_ID__c = t.id;
        agfTask.agf__Status__c = 'Not Started';
        agfTask.agf__Subject__c = 'test sub';
        agfTask.agf__Assigned_To__c = UserInfo.getUserId();
        insert agfTask;
        system.assertNotEquals(null, agfTask.id);
        //Added by Lalit for S-407213 START
        agfTask.agf__Assigned_To__c = u.id;
        Update agfTask;



        Task updatedTask = [Select OwnerId,WhatId from Task where id = :t.id limit 1];
        Case updatedSupportCase = [select IT_Assignment__c from Case where id = :updatedTask.WhatId limit 1];
        System.assert(updatedTask.OwnerId==agfTask.agf__Assigned_To__c);
        System.assert(updatedSupportCase.IT_Assignment__c==agfTask.agf__Assigned_To__c);

        //Added by Lalit for S-407213 END
        //Added by Lalit for S-404756 START
        agf__ADM_Task__c agfMigrationTask = new agf__ADM_Task__c();
        agfMigrationTask.agf__Work__c = story.id;
        agfMigrationTask.Task_ID__c = uatMigration.id;
        agfMigrationTask.agf__Status__c = 'Not Started';
        agfMigrationTask.agf__Subject__c = 'test UAT Migration';
        agfMigrationTask.agf__Assigned_To__c = UserInfo.getUserId();
        insert agfMigrationTask;
        //Added by Lalit for S-404756 END


        //Added by Lalit for S-404756 START
        agfMigrationTask.agf__Status__c = 'Completed';
        update agfMigrationTask;
        Task suppTask = [select status,Description from Task where id =:uatMigration.id limit 1];
        system.assertEquals('Completed', suppTask.status);
        //Added by Lalit for S-404756 END

        Test.stopTest();

	}

	static testMethod void testTaskUpdateToSFDC4() {
        //Added by Lalit for S-407213 START
        //Start - Added by Jyoti for Story S-410497
        Id profileId=userinfo.getProfileId();
        user u = new user(email='abc.xyz@officedepot.com',Username='jasmet@acme.com',FirstName ='test123', LastName='xyz123', Alias='a', CommunityNickname='aa', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId=profileId, LanguageLocaleKey='en_US');
        //End - Story S-410497
        //Start - commented by Jyoti for Story S-410497
        //user u2=[SELECT id,ProfileId,OD_Employee_ID__c,TimeZoneSidKey FROM USER WHERE id =:UserInfo.getUserId()];
        //user u = new user(email='abc.xyz@officedepot.com',Username='jasmet@acme.com',FirstName ='test123', LastName='xyz123', Alias='a', CommunityNickname='aa', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId=u2.ProfileId, LanguageLocaleKey='en_US');
        //End - Story S-410497
        u.isActive = true;
        insert u ;
        //Added by Lalit for S-407213 END
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
        supportCase.IT_BU_Reviewer__c = Userinfo.getUserId();//Added by Lalit for S-407213

        insert supportCase;
        system.assertNotEquals(null, supportCase.id);
        List<Task> taskList = new List<Task>(); // Added by Jyoti for Story S-410497
        Task t = new Task();
        t.WhatId = supportCase.id;
        t.subject = 'test sub';
        t.ActivityDate = Date.today();
        t.IT_TASK_TYPE__c = 'Design';
        //insert t; // Commeted by Jyoti for Story S-410497
        taskList.add(t);  //Added by Jyoti for Story S-410497

        //Added by Lalit for S-404756 START
        Task uatMigration = new Task();
        uatMigration.WhatId = supportCase.id;
        uatMigration.subject = 'test UAT Migration';
        uatMigration.ActivityDate = Date.today();
        uatMigration.IT_TASK_TYPE__c = 'UAT Migration';
        //insert uatMigration; // Commeted by Jyoti for Story S-410497
        //Start - Added by Jyoti for Story S-410497
        taskList.add(uatMigration);
        insert taskList;
        //End - Added by Jyoti for Story S-410497

        //Added by Lalit for S-404756 END

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
        agf__ADM_Task__c agfTask = new agf__ADM_Task__c();
        agfTask.agf__Work__c = story.id;
        agfTask.Task_ID__c = t.id;
        agfTask.agf__Status__c = 'Not Started';
        agfTask.agf__Subject__c = 'test sub';
        agfTask.agf__Assigned_To__c = UserInfo.getUserId();
        insert agfTask;
        system.assertNotEquals(null, agfTask.id);
        //Added by Lalit for S-407213 START
        agfTask.agf__Assigned_To__c = u.id;
        Update agfTask;



        Task updatedTask = [Select OwnerId,WhatId from Task where id = :t.id limit 1];
        Case updatedSupportCase = [select IT_Assignment__c from Case where id = :updatedTask.WhatId limit 1];
        System.assert(updatedTask.OwnerId==agfTask.agf__Assigned_To__c);
        System.assert(updatedSupportCase.IT_Assignment__c==agfTask.agf__Assigned_To__c);

        //Added by Lalit for S-407213 END
        //Added by Lalit for S-404756 START
        agf__ADM_Task__c agfMigrationTask = new agf__ADM_Task__c();
        agfMigrationTask.agf__Work__c = story.id;
        agfMigrationTask.Task_ID__c = uatMigration.id;
        agfMigrationTask.agf__Status__c = 'Not Started';
        agfMigrationTask.agf__Subject__c = 'test UAT Migration';
        agfMigrationTask.agf__Assigned_To__c = UserInfo.getUserId();
        insert agfMigrationTask;
        //Added by Lalit for S-404756 END

        agfTask.agf__Status__c = 'Not Started';
        update agfTask;

        Task suppTask = [select status,Description from Task where id =:t.id limit 1];
        system.assertEquals('New', suppTask.status);

        Test.stopTest();

	}//END S-423439


    //START S-420975 (OD 00731428) [Hemant 7/1/2016] - Increase code coverage
    static testMethod void testTaskUpdateToSFDC1() {
        Id profileId=userinfo.getProfileId();
        user u = new user(email='abc.xyz@officedepot.com',Username='jasmet@acme.com',FirstName ='test123', LastName='xyz123', Alias='a', CommunityNickname='aa', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId=profileId, LanguageLocaleKey='en_US');
        u.isActive = true;
        insert u ;

        Id supportCaseRecTypeId = Schema.sObjectType.Case.getRecordTypeInfosByName().get('Support').getRecordTypeId();
        Case supportCase = new Case();
        supportCase.recordTypeId = supportCaseRecTypeId;
        supportCase.subject = 'test subject';
        supportCase.description = 'test description';
        supportCase.IT_BU_Reviewer__c = Userinfo.getUserId();
        insert supportCase;
        system.assertNotEquals(null, supportCase.id);

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
        List<Task> taskList = new List<Task>();
        taskList.add(createTask(supportCase.id, 'Design'));
        taskList.add(createTask(supportCase.id, 'Design'));
        taskList.add(createTask(supportCase.id, 'UAT Migration'));
        taskList.add(createTask(supportCase.id, Constants.QA));
        taskList.add(createTask(supportCase.id, Constants.UAT));

        insert taskList;

        List<agf__ADM_Task__c> agfTaskLst = new List<agf__ADM_Task__c>();

        for(Task tsk : taskList){
          agfTaskLst.add(createAGFADM_Task(story.id, tsk.Id));
        }
        insert agfTaskLst;

        for(agf__ADM_Task__c admTask : agfTaskLst){
          admTask.agf__Assigned_To__c = u.id;
        }
        update agfTaskLst;
        Test.stopTest();

        agfTaskLst.get(3).agf__Assigned_To__c = UserInfo.getUserId();
        update agfTaskLst.get(3);

		//Modified for S-423439
        //agfTaskLst.get(4).agf__Assigned_To__c = UserInfo.getUserId();
        //update agfTaskLst.get(4);
        //END S-423439

    }

    //method to create agf__ADM_Task__c
    private static agf__ADM_Task__c createAGFADM_Task(Id storyId, Id tskId){
    	return (new agf__ADM_Task__c(agf__Work__c = storyId,
	      Task_ID__c = tskId,
	      agf__Status__c = 'Not Started',
	      agf__Subject__c = 'test sub',
	      agf__Assigned_To__c = UserInfo.getUserId()));
    }
    //method to create Task
    private static Task createTask(Id caseId, String taskType){
    	return (new Task(WhatId = caseId,
        subject = taskType,
        ActivityDate = Date.today(),
        IT_TASK_TYPE__c = taskType));
    }
    //END S-420975 (OD 00731428) [Hemant 7/1/2016] - Increase code coverage
}