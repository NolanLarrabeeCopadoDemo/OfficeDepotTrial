/*
Last Modified by Najma Ateeq
Case #00126834
Set Time_of_non_API_User_Modification__c field value on each lead creation and added Time_of_non_API_User_Modification__c field to all the queries
*/
@isTest
private class RemindLeadOwner_Batch_TC 
{
    static testMethod void myUnitTest() 
    {
    List <lead> lds = new List<lead>();
    String DEFAULT_USER = 'salesforce';
    User salesforceUsr  = [select Id from User where lastname = :DEFAULT_USER AND IsActive = true Limit 1];
    lead ld=new lead ();
    ld.lastname='testlead';
    ld.company='testcompany';
    ld.zip__c='12345';
    ld.Status='Open';
    ld.LeadSource='BSD NET';
    ld.Industry='Business Services';
    ld.Change_Owner__c = false;
    ld.OwnerId = '005M0000005tJ1zIAE';
    ld.Time_of_non_API_User_Modification__c = System.now()-3;
    lds.add(ld);
    
    lead ld1=new lead ();
    ld1.lastname='testlead';
    ld1.company='testcompany';
    ld1.zip__c='123456';
    ld1.Status='Open';
    ld1.LeadSource='Customer Service';
    ld1.Change_Owner__c = true;
    ld1.OwnerId = '005M0000005tJ1zIAE';
    ld1.Time_of_non_API_User_Modification__c = System.now()-3;
    lds.add(ld1);
        
    List<Assignment_Rule__c> asgnRules = new List<Assignment_Rule__c>();
    Assignment_Rule__c assign1 = new Assignment_Rule__c();
    assign1.Zip_Code__c = '12345';
    assign1.WCW_Count__c = '1to19';
    Assignment_Rule__c assign2 = new Assignment_Rule__c();
    assign2.Zip_Code__c = '123456';
    assign2.WCW_Count__c = '1to19';
    asgnRules.add(assign1);
    asgnRules.add(assign2);
    
    insert asgnRules;
    insert lds;
    
    test.startTest();
     //Updated by Shubham for Case# 00140740
     String strquery = 'Select id,New_Date_time__c,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,ownerid,Change_Owner__c,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c,Time_of_non_API_User_Modification__c,CreatedDate,Lead_Age__c from lead where zip__c in (\'12345\',\'123456\')'; // S-343740 [Hemant 10/21/2105] - Add CreatedDate,Lead_Age__c 
        //String strquery = 'Select id,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,ownerid,Change_Owner__c,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c from lead where Status=\'Open\' and (LeadSource=\'BSD NET\' OR LeadSource=\'Customer Service\' OR LeadSource=\'Web Lead\' OR LeadSource=\'Store Lead\') and (Industry!=\'Government\' or Industry!=\'Education/Schools\')';       
        RemindLeadOwner_Batch assignBatch1 = new RemindLeadOwner_Batch(strQuery);
        assignBatch1.day='Monday';
        database.executebatch(assignBatch1, 10);
        assignBatch1.changeOwnerDate();
        test.StopTest();
    }

static testMethod void testOnThursday() 
    {
    List <lead> lds = new List<lead>();
    String DEFAULT_USER = 'salesforce';
    User salesforceUsr  = [select Id from User where lastname = :DEFAULT_USER AND IsActive = true Limit 1];
    lead ld=new lead ();
    ld.lastname='testlead';
    ld.company='testcompany';
    ld.zip__c='12345';
    ld.Status='Open';
    ld.LeadSource='BSD NET';
    ld.Industry='Business Services';
    ld.Change_Owner__c = false;
    ld.OwnerId = '005M0000005tJ1zIAE';
    ld.Auto_Assign__c = false;
    ld.Time_of_non_API_User_Modification__c = System.now()-3;
    lds.add(ld);
    
    lead ld1=new lead ();
    ld1.lastname='testlead';
    ld1.company='testcompany';
    ld1.zip__c='123456';
    ld1.Status='Open';
    ld1.LeadSource='Customer Service';
    ld1.Change_Owner__c = true;
    ld1.OwnerId = '005M0000005tJ1zIAE';
    ld1.Auto_Assign__c = false;
    ld1.Time_of_non_API_User_Modification__c = System.now()-3;
    lds.add(ld1);
        
    List<Assignment_Rule__c> asgnRules = new List<Assignment_Rule__c>();
    Assignment_Rule__c assign1 = new Assignment_Rule__c();
    assign1.Zip_Code__c = '12345';
    assign1.WCW_Count__c = '1to19';
    Assignment_Rule__c assign2 = new Assignment_Rule__c();
    assign2.Zip_Code__c = '123456';
    assign2.WCW_Count__c = '1to19';
    asgnRules.add(assign1);
    asgnRules.add(assign2);
    
    insert asgnRules;
    insert lds;
    List<Lead> lds2 = new List<Lead>();
    for(Lead l : [Select Id, ownerid FROM Lead WHERE Id IN :lds]){
        l.ownerId = UserInfo.getUserId();//'005M0000005tJ1zIAE';
        lds2.add(l);
    }

    update lds2;

    
    RemindLeadOwner_Batch testConstructor = new RemindLeadOwner_Batch();

    test.startTest();
     //Updated by Shubham for Case# 00140740
     String strquery = 'Select id,New_Date_time__c,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,ownerid,Change_Owner__c,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c,Time_of_non_API_User_Modification__c,CreatedDate,Lead_Age__c from lead where zip__c in (\'12345\',\'123456\')'; // S-343740 [Hemant 10/21/2105] - Add CreatedDate,Lead_Age__c
        //String strquery = 'Select id,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,ownerid,Change_Owner__c,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c from lead where Status=\'Open\' and (LeadSource=\'BSD NET\' OR LeadSource=\'Customer Service\' OR LeadSource=\'Web Lead\' OR LeadSource=\'Store Lead\') and (Industry!=\'Government\' or Industry!=\'Education/Schools\')';       
        system.debug('strquery'+strquery);
        RemindLeadOwner_Batch assignBatch1 = new RemindLeadOwner_Batch(strQuery);
        assignBatch1.hoursSinceLastModifiedUsedForTestClass = 50;
        assignBatch1.day = 'Thursday';
        database.executebatch(assignBatch1, 10);
        assignBatch1.changeOwnerDate();
        test.StopTest();
    }


static testMethod void test24Hours() 
    {
    List <lead> lds = new List<lead>();
    String DEFAULT_USER = 'salesforce';
    User salesforceUsr  = [select Id from User where lastname = :DEFAULT_USER AND IsActive = true Limit 1];
    lead ld=new lead ();
    ld.lastname='testlead';
    ld.company='testcompany';
    ld.zip__c='12345';
    ld.Status='Open';
    ld.LeadSource='BSD NET';
    ld.Industry='Business Services';
    ld.Change_Owner__c = true;
    ld.OwnerId = '005M0000005tJ1zIAE';
    ld.Auto_Assign__c = false;
    ld.Time_of_non_API_User_Modification__c = System.now()-3;
    lds.add(ld);
    
    lead ld1=new lead ();
    ld1.lastname='testlead';
    ld1.company='testcompany';
    ld1.zip__c='123456';
    ld1.Status='Open';
    ld1.LeadSource='Customer Service';
    ld1.Change_Owner__c = true;
    ld1.OwnerId = '005M0000005tJ1zIAE';
    ld1.Auto_Assign__c = false;
    ld1.Time_of_non_API_User_Modification__c = System.now()-3;
    lds.add(ld1);
        
    List<Assignment_Rule__c> asgnRules = new List<Assignment_Rule__c>();
    Assignment_Rule__c assign1 = new Assignment_Rule__c();
    assign1.Zip_Code__c = '12345';
    assign1.WCW_Count__c = '1to19';
    Assignment_Rule__c assign2 = new Assignment_Rule__c();
    assign2.Zip_Code__c = '123456';
    assign2.WCW_Count__c = '1to19';
    asgnRules.add(assign1);
    asgnRules.add(assign2);
    
    insert asgnRules;
    insert lds;
    List<Lead> lds2 = new List<Lead>();
    for(Lead l : [Select Id, ownerid FROM Lead WHERE Id IN :lds]){
        l.ownerId = UserInfo.getUserId();//'005M0000005tJ1zIAE';
        lds2.add(l);
    }

    update lds2;

    
    RemindLeadOwner_Batch testConstructor = new RemindLeadOwner_Batch();

    test.startTest();
     //Updated by Shubham for Case# 00140740
     String strquery = 'Select id,New_Date_time__c,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,ownerid,Change_Owner__c,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c,Time_of_non_API_User_Modification__c,CreatedDate,Lead_Age__c from lead where zip__c in (\'12345\',\'123456\')'; // S-343740 [Hemant 10/21/2105] - Add CreatedDate,Lead_Age__c
        //String strquery = 'Select id,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,ownerid,Change_Owner__c,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c from lead where Status=\'Open\' and (LeadSource=\'BSD NET\' OR LeadSource=\'Customer Service\' OR LeadSource=\'Web Lead\' OR LeadSource=\'Store Lead\') and (Industry!=\'Government\' or Industry!=\'Education/Schools\')';       
        RemindLeadOwner_Batch assignBatch1 = new RemindLeadOwner_Batch(strQuery);
        assignBatch1.hoursSinceLastModifiedUsedForTestClass = 25;
        database.executebatch(assignBatch1,10);
        assignBatch1.changeOwnerDate();
        test.StopTest();
    }

    static testMethod void test72Hours() 
    {
    List <lead> lds = new List<lead>();
    String DEFAULT_USER = 'salesforce';
    User salesforceUsr  = [select Id from User where lastname = :DEFAULT_USER AND IsActive = true Limit 1];
    lead ld=new lead ();
    ld.lastname='testlead';
    ld.company='testcompany';
    ld.zip__c='12345';
    ld.Status='Open';
    ld.LeadSource='BSD NET';
    ld.Industry='Business Services';
    ld.Change_Owner__c = false;
    ld.OwnerId = '005M0000005tJ1zIAE';
    ld.Auto_Assign__c = false;
    ld.Time_of_non_API_User_Modification__c = System.now()-3;
    lds.add(ld);
    
    lead ld1=new lead ();
    ld1.lastname='testlead';
    ld1.company='testcompany';
    ld1.zip__c='123456';
    ld1.Status='Open';
    ld1.LeadSource='Customer Service';
    ld1.Change_Owner__c = true;
    ld1.OwnerId = '005M0000005tJ1zIAE';
    ld1.Auto_Assign__c = false;
    ld1.Time_of_non_API_User_Modification__c = System.now()-3;
    lds.add(ld1);
        
    List<Assignment_Rule__c> asgnRules = new List<Assignment_Rule__c>();
    Assignment_Rule__c assign1 = new Assignment_Rule__c();
    assign1.Zip_Code__c = '12345';
    assign1.WCW_Count__c = '1to19';
    Assignment_Rule__c assign2 = new Assignment_Rule__c();
    assign2.Zip_Code__c = '123456';
    assign2.WCW_Count__c = '1to19';
    asgnRules.add(assign1);
    asgnRules.add(assign2);
    
    insert asgnRules;
    insert lds;
    List<Lead> lds2 = new List<Lead>();
    for(Lead l : [Select Id, ownerid FROM Lead WHERE Id IN :lds]){
        l.ownerId = UserInfo.getUserId();//'005M0000005tJ1zIAE';
        lds2.add(l);
    }

    update lds2;

    
  //  RemindLeadOwner_Batch testConstructor = new RemindLeadOwner_Batch();

    test.startTest();
     //Updated by Shubham for Case# 00140740
     String strquery = 'Select id,New_Date_time__c,Zip__c,Industry,Industry_Code__c,'+
         'lastmodifieddate,Status,LeadSource,ownerid,Change_Owner__c,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c,Time_of_non_API_User_Modification__c,CreatedDate,Lead_Age__c from lead where zip__c in (\'12345\',\'123456\') limit 100'; // S-343740 [Hemant 10/21/2105] - Add CreatedDate,Lead_Age__c
        //String strquery = 'Select id,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,ownerid,Change_Owner__c,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c from lead where Status=\'Open\' and (LeadSource=\'BSD NET\' OR LeadSource=\'Customer Service\' OR LeadSource=\'Web Lead\' OR LeadSource=\'Store Lead\') and (Industry!=\'Government\' or Industry!=\'Education/Schools\')';       
        RemindLeadOwner_Batch assignBatch1 = new RemindLeadOwner_Batch(strQuery);
        assignBatch1.hoursSinceLastModifiedUsedForTestClass = 73;
        database.executebatch(assignBatch1, 10);
        assignBatch1.changeOwnerDate();
        test.StopTest();
    }
    
    //Code added - Padmesh Soni (10/30/2015 - Appirio Offshore) - S-359754: 00539876: Test Class Updates to Increase Test Coverage - Story 9
    /*** Change Starts here ***/
    //New test method added for enhancing coverage of Class: RemindLeadOwner_Batch_TC​
    //Old Coverage: 82%
    //Current Coverage: 86%
    private static testMethod void testRemindLeadOwnerBatchTC() {
        
        //List to hold Assignment Rules
        List<Assignment_Rule__c> assignmentRules = new List<Assignment_Rule__c>();
        
        //adding Assignment_Rule__c instances into list
        assignmentRules.add(new Assignment_Rule__c(Zip_Code__c = '12345', WCW_Count__c = '1to19', User__c = Userinfo.getUserId()));
        assignmentRules.add(new Assignment_Rule__c(Zip_Code__c = '123456', WCW_Count__c = '1to19'));
        
        //DML operation on Assignment Rules list
        insert assignmentRules;
        
        System.debug('Rulle L:::::'+ [select Zip_Code__c,Industry_Group__c,WCW_Count__c ,User__c FROM Assignment_Rule__c where Id IN :assignmentRules]);
        //List to hold Lead test records
        List<Lead> leads = new List<lead>();
        
        //adding Lead instances into list
        leads.add(new lead (LastName='testlead', Company='testcompany', Zip__c='12345', Status='Open', LeadSource= 'Web Lead', Industry='Business Services', 
                            Change_Owner__c = false, OwnerId = '005M0000005tJ1zIAE', Auto_Assign__c = false, Time_of_non_API_User_Modification__c = System.now()-3));
        leads.add(new lead (LastName='testlead', Company='testcompany', Zip__c='123456', Status='Open', LeadSource= 'Web Lead',  
                            Change_Owner__c = true, OwnerId = '005M0000005tJ1zIAE', Auto_Assign__c = false, Time_of_non_API_User_Modification__c = System.now()-3));
        
        //DML operation on lead list
        insert leads;
        
        //String to hold batch query value
        String soqlStr;
        
        //Test context starts here
        Test.startTest();
        
        //String strquery = 'Select id,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,ownerid,Change_Owner__c,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c from lead where Status=\'Open\' and (LeadSource=\'BSD NET\' OR LeadSource=\'Customer Service\' OR LeadSource=\'Web Lead\' OR LeadSource=\'Store Lead\') and (Industry!=\'Government\' or Industry!=\'Education/Schools\')';       
        
        //Instance of batch
        RemindLeadOwner_Batch batchProcess = new RemindLeadOwner_Batch(soqlStr);
        
        //Assign field values on Batch property
        batchProcess.hoursSinceLastModifiedUsedForTestClass = 73;
        
        //Execute the batch here
        Database.executeBatch(batchProcess, 10);
        
        //Test stops here
        Test.StopTest();
    }
    
    //New test method added for enhancing coverage of Class: RemindLeadOwner_Batch_TC​
    //Old Coverage: 82%
    //Current Coverage: 86%
    private static testMethod void testSchedRemindLeadOwnerBatchTC1() {
        
        //String to hold batch query value
        String soqlStr;
        
        //Instance of batch
        RemindLeadOwner_Batch batchProcess = new RemindLeadOwner_Batch(soqlStr);
        
        //Assign field values on Batch property
        batchProcess.hoursSinceLastModifiedUsedForTestClass = 73;
        
        //Execute the batch here
        Database.executeBatch(batchProcess, 10);
        
        //Test starts here
        Test.startTest();
        
        // Schedule the test job at midnight Sept. 3rd. 2022
        String jobId = System.schedule('Test_Sched_CheckDeletedTMs', '0 0 0 3 9 ? 2022', new RemindLeadOwner_Batch());
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals('0 0 0 3 9 ? 2022', ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        
        //Test stops here
        Test.stopTest();
    }
    
    /*** Change Stops here ***/
    
    }