/**************************************************************
*Name           : Update_WRFTaskAging_Batch_TC 
*Created By     : Wipro Offshore
*Created Date   : 3rd Oct,2012
*Purpose        : To test Update_WRFTaskAging_Batch Batch Class
*
*Current Version:	V_1.1
*					
*Revision Log	:	V_1.0 - Created
*						Changes: Class created without body
*					V_1.1 - Modified - Padmesh Soni (Appirio Offshore - 2 Nov 2015) - S-359754: 00539876: Test Class Updates to Increase Test Coverage - Story 9
*						Changes: Class definition defined
*
*Code Coverage	:	V_1.0 - 0%
*					V_1.1 - 98%
********************************************************************/
@isTest(seeAllData=false)
private class Update_WRFTaskAging_Batch_TC {
	
	/**** Changes Start here ****/
	//Code added - Padmesh Soni (Appirio Offshore - 2 Nov 2015) - S-359754: 00539876: Test Class Updates to Increase Test Coverage - Story 9
	//Class properties
	private static List<Account> accounts;
	private static List<Case> cases;
	private static List<WRF_Task__C> wrfTasks;
	
	//Method to store test data creation logic
	private static void createTestData() {
		
		Schema.DescribeSObjectResult WR = Schema.SObjectType.WRF_Task__c; 
        Map<String,Schema.RecordTypeInfo> WRFMapByName = WR.getRecordTypeInfosByName();

        Schema.DescribeSObjectResult CR = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> CRFMapByName = CR.getRecordTypeInfosByName();
        
        //Dummy instances added into Accounts list
        accounts.add(new Account(Name='Test'));
		
		//DML operation on Accounts list
		insert accounts;
		
		//Dummy instances added into Cases list
        cases.add(new Case(RecordTypeId = CRFMapByName.get('Work Request').getRecordTypeId(), Status='New', WRF_Request_Type__c='Core Review', AccountId = accounts[0].id));
        
        //DML operation on Cases list
		insert cases; 

        //Dummy instances added into WRF Tasks list
        wrfTasks.add(new WRF_Task__C(RecordTypeId = WRFMapByName.get('WRF Task').getRecordTypeId(), Task_Type__c='Pricing Implementation', Status__c = 'Not Started',
        								Disposition_Code__c='Bids', Due_Date__c = System.today(), Assigned_To__c = Userinfo.getUserId(), Priority__c = 'Normal',
        								Assignment_Group__c='Public/GPO', WRF__c=cases[0].id));
        wrfTasks.add(new WRF_Task__C(RecordTypeId = WRFMapByName.get('WRF Task').getRecordTypeId(), Task_Type__c='Pricing Implementation', Status__c = 'Under Review',
        								Disposition_Code__c='Bids', Due_Date__c = System.today(), Assigned_To__c = Userinfo.getUserId(), Priority__c = 'Normal',
        								Assignment_Group__c='Public/GPO', WRF__c=cases[0].id, Under_Review_Date__c = DateTime.now().addDays(-1)));
        wrfTasks.add(new WRF_Task__C(RecordTypeId = WRFMapByName.get('WRF Task').getRecordTypeId(), Task_Type__c='Pricing Implementation', Status__c = 'Team Review',
        								Disposition_Code__c='Bids', Due_Date__c = System.today(), Assigned_To__c = Userinfo.getUserId(), Priority__c = 'Normal',
        								Assignment_Group__c='Public/GPO', WRF__c=cases[0].id, Team_Review_Date__c = DateTime.now().addDays(-1)));
        wrfTasks.add(new WRF_Task__C(RecordTypeId = WRFMapByName.get('WRF Task').getRecordTypeId(), Task_Type__c='Pricing Implementation', Status__c = 'In Progress',
        								Disposition_Code__c='Bids', Due_Date__c = System.today(), Assigned_To__c = Userinfo.getUserId(), Priority__c='Normal',
        								Assignment_Group__c='Public/GPO', WRF__c=cases[0].id, In_Progress_Date__c = DateTime.now()));
        wrfTasks.add(new WRF_Task__C(RecordTypeId = WRFMapByName.get('WRF Task').getRecordTypeId(), Task_Type__c='Pricing Implementation', Status__c = 'Final Review',
        								Disposition_Code__c='Bids', Due_Date__c = System.today(), Assigned_To__c = Userinfo.getUserId(), Priority__c='Normal',
        								Assignment_Group__c='Public/GPO', WRF__c=cases[0].id, Final_Review_Date__c = DateTime.now()));
        wrfTasks.add(new WRF_Task__C(RecordTypeId = WRFMapByName.get('WRF Task').getRecordTypeId(), Task_Type__c='Pricing Implementation', Status__c = 'Awaiting Action',
        								Disposition_Code__c='Bids', Due_Date__c = System.today(), Assigned_To__c = Userinfo.getUserId(), Priority__c='Normal',
        								Assignment_Group__c='Public/GPO', WRF__c=cases[0].id, Awaiting_Action_Date__c = DateTime.now()));
        
        //DML operation on Cases list
		insert wrfTasks;
	}
	
	//Method to test the functionality of Batch process
	private static testmethod void testUpdate_WRFTaskAging_Batch() {
		
		//Initialize the instances of Sobjects
		accounts = new List<Account>();
		cases = new List<Case>();
		wrfTasks = new List<WRF_Task__C>();
		
		//Test stats here
		Test.StartTest();
		
		//Call method to creation of test data
		createTestData();
        
        //Execute the batch process
        Database.executeBatch(new Update_WRFTaskAging_Batch(), 10);
        
        //Test stops here
        Test.stopTest();
        
        //Query result of WRF Task
        for(WRF_Task__C wrfTask : [SELECT Id, Status__c, Hours_Not_Started_Current__c, Hours_Under_Review_Current__c, Hours_Team_Review_Current__c, 
        								Hours_In_Progress_Current__c, Hours_Final_Review_Current__c, Hours_Awaiting_Info_Current__c FROM WRF_Task__C 
        								WHERE Id IN: wrfTasks]) {
        	
        	//Check for Stats of Not Started and Check for assert statement
        	if(wrfTask.Status__c == 'Not Started')
        		System.assert(wrfTask.Hours_Not_Started_Current__c != null);
        	
        	//Check for Stats of Under Review and Check for assert statement
        	else if(wrfTask.Status__c == 'Under Review')
        		System.assert(wrfTask.Hours_Under_Review_Current__c != null);
        	
        	//Check for Stats of Team Review and Check for assert statement
        	else if(wrfTask.Status__c == 'Team Review')
        		System.assert(wrfTask.Hours_Team_Review_Current__c != null);
        	
        	//Check for Stats of In Progress and Check for assert statement
        	else if(wrfTask.Status__c == 'In Progress')
        		System.assert(wrfTask.Hours_In_Progress_Current__c != null);
        	
        	//Check for Stats of Final Review and Check for assert statement
        	else if(wrfTask.Status__c == 'Final Review')
        		System.assert(wrfTask.Hours_Final_Review_Current__c != null);
        	
        	//Check for Stats of Awaiting Action and Check for assert statement
        	else if(wrfTask.Status__c == 'Awaiting Action')
        		System.assert(wrfTask.Hours_Awaiting_Info_Current__c != null);
        }
        
        //String to hold batch query value
        String soqlStr = 'SELECT Id, Status__c, Hours_Not_Started_Current__c, Hours_Under_Review_Current__c, Hours_Team_Review_Current__c, Hours_In_Progress_Current__c,'+
        					+' Hours_Final_Review_Current__c, Hours_Awaiting_Info_Current__c FROM WRF_Task__C LIMIT 0';
        
        //Execute the batch here
        Database.executeBatch(new Update_WRFTaskAging_Batch(soqlStr), 10);
	}
	
	//Test method to test Scheduler of Update_WRFTaskAging_Batch
    private static testMethod void testSchedUpdate_WRFTaskAging_Batch() {
        
        //String to hold batch query value
        String soqlStr;
        
        //Instance of batch
        Update_WRFTaskAging_Batch batchProcess = new Update_WRFTaskAging_Batch(soqlStr);
        
        //Execute the batch here
        Database.executeBatch(batchProcess, 10);
        
        //Test starts here
        Test.startTest();
        
        // Schedule the test job at midnight Sept. 3rd. 2022
        String jobId = System.schedule('Test_Sched_Update_WRFTaskAging_Batch', '0 0 0 3 9 ? 2022', new Update_WRFTaskAging_Batch());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals('0 0 0 3 9 ? 2022', ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
		
		//Test stops here
		Test.stopTest();
    }
    
    /**** Changes Stop here ****/
}