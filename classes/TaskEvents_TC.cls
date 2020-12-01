//
// (c) 2015 Appirio, Inc.
//
// Test Class for TaskEvents trigger
//
// 6 Mar 2015     Appirio CM - S-302450
//
//


@isTest
private class TaskEvents_TC {

//split out task test methods to avoid running into the exec limit imposed bu executeoncetest.cls


    @isTest static void test_ITdev() {
        
        Profile sa = [SELECT Id FROM profile WHERE name = 'System Administrator'];
        
        //LSLEVIN 2.10.16 S-376887 updated below liens employee id to include OD
        User u1 = new User(alias = 'test123 ', email = 'proxy@proxy456.officedepot.com', OD_Employee_ID__c = 'xx123', emailencodingkey = 'UTF-8', lastname = 'test123', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = sa.Id, timezonesidkey = 'America/Los_Angeles', username = 'proxy@proxy456.com', isactive = true);
        insert u1;
  System.runAs(u1)
    {
        
        //Generate Type Maps
        Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
        Map<String, Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();

        Schema.DescribeSObjectResult TR = Schema.SObjectType.Task;
        Map<String, Schema.RecordTypeInfo> TRMapByName = TR.getRecordTypeInfosByName();


        //Create a case
        Case testCase = new Case();
        testCase.RecordTypeId = CRMapByName.get('IT Cases').getRecordTypeId();
        testCase.Subject = 'Test Case';
        insert testCase;

        test.startTest();

        //create an tasks for case
        //List<Task> testTasks = new List<Task>();

        Task ITDevTask = new Task();
        ITDevTask.recordtypeid = TRMapByName.get('Support Task').getRecordTypeId();
        ITDevTask.Task_Type__c = 'IT';
        ITDevTask.action__c = 'Development';
        ITDevTask.Status =  'Completed';
        ITDevTask.WhatId = testCase.id;
        insert ITDevTask;

        test.stopTest();
    }



    }

    @isTest static void test_BizRejectTask() {

        Profile sa = [SELECT Id FROM profile WHERE name = 'System Administrator'];
        
        //LSLEVIN 2.10.16 S-376887 updated below liens employee id to include OD
        User u1 = new User(alias = 'test123 ', email = 'proxy@proxy456.officedepot.com', OD_Employee_ID__c = 'xx123', emailencodingkey = 'UTF-8', lastname = 'test123', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = sa.Id, timezonesidkey = 'America/Los_Angeles', username = 'proxy@proxy456.com', isactive = true);
        insert u1;
  System.runAs(u1)
    {

        //Generate Type Maps
        Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
        Map<String, Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();

        Schema.DescribeSObjectResult TR = Schema.SObjectType.Task;
        Map<String, Schema.RecordTypeInfo> TRMapByName = TR.getRecordTypeInfosByName();


        //Create a case
        Case testCase = new Case();
        testCase.RecordTypeId = CRMapByName.get('IT Cases').getRecordTypeId();
        testCase.Subject = 'Test Case';
        testCase.IT_BU_Reviewer__c = u1.id;
        insert testCase;

        test.StartTest();
        //create an tasks for case
        //List<Task> testTasks = new List<Task>();
        Task BizRejectTask = new Task();
        BizRejectTask.recordtypeid = TRMapByName.get('Support Task').getRecordTypeId();
        BizRejectTask.Task_Type__c = 'Business';
        BizRejectTask.action__c = 'Validation';
        BizRejectTask.outcome__c = 'Rejected';
        BizRejectTask.Status =  'Completed';
        BizRejectTask.WhatId = testCase.id;
        insert BizRejectTask;

        test.StopTest();

    }

    }

    @isTest static void test_BizApprovedTask() {
        //Generate Type Maps
        Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
        Map<String, Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();

        Schema.DescribeSObjectResult TR = Schema.SObjectType.Task;
        Map<String, Schema.RecordTypeInfo> TRMapByName = TR.getRecordTypeInfosByName();

        Profile sa = [SELECT Id FROM profile WHERE name = 'System Administrator'];
        
        //LSLEVIN 2.10.16 S-376887 updated below liens employee id to include OD
        User u1 = new User(alias = 'test123 ', email = 'proxy@proxy456.officedepot.com', OD_Employee_ID__c = 'xx456', emailencodingkey = 'UTF-8', lastname = 'test123', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = sa.Id, timezonesidkey = 'America/Los_Angeles', username = 'proxy@proxy456.com', isactive = true);
        insert u1;
          System.runAs(u1)
    {

        //Create a case
        Case testCase = new Case();
        testCase.RecordTypeId = CRMapByName.get('IT Cases').getRecordTypeId();
        testCase.Subject = 'Test Case';
        testCase.IT_BU_Reviewer__c = u1.id;
        testCase.IT_Production_Date__c = system.today();
        insert testCase;


        //create an tasks for case
        //List<Task> testTasks = new List<Task>();

        test.StartTest();

        Task BizApprovedTask = new Task();
        BizApprovedTask.recordtypeid = TRMapByName.get('Support Task').getRecordTypeId();
        BizApprovedTask.Task_Type__c = 'Business';
        BizApprovedTask.action__c = 'Validation';
        BizApprovedTask.outcome__c = 'Approved';
        BizApprovedTask.Status =  'Completed';
        BizApprovedTask.WhatId = testCase.id;
        insert BizApprovedTask;

        test.StopTest();
    }




    }

    @isTest static void test_ITMigTask() {

        Profile sa = [SELECT Id FROM profile WHERE name = 'System Administrator'];
        
        //LSLEVIN 2.10.16 S-376887 updated below liens employee id to include OD
        User u1 = new User(alias = 'test123 ', email = 'proxy@proxy456.officedepot.com', OD_Employee_ID__c = 'xx123', emailencodingkey = 'UTF-8', lastname = 'test123', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = sa.Id, timezonesidkey = 'America/Los_Angeles', username = 'proxy@proxy456.com', isactive = true);
        insert u1;
  System.runAs(u1)
    {
        //Generate Type Maps
        Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
        Map<String, Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();

        Schema.DescribeSObjectResult TR = Schema.SObjectType.Task;
        Map<String, Schema.RecordTypeInfo> TRMapByName = TR.getRecordTypeInfosByName();


        //Create a case
        Case testCase = new Case();
        testCase.RecordTypeId = CRMapByName.get('IT Cases').getRecordTypeId();
        testCase.Subject = 'Test Case';
        insert testCase;


        test.StartTest();

        Task ITMigTask = new Task();
        ITMigTask.recordtypeid = TRMapByName.get('Support Task').getRecordTypeId();
        ITMigTask.Task_Type__c = 'IT';
        ITMigTask.action__c = 'Migration';
        ITMigTask.Status =  'Completed';
        ITMigTask.WhatId = testCase.id;
        insert ITMigTask;

        test.StopTest();

    }

    }

    @isTest static void test_BizMigValTask() {
        //Generate Type Maps
        Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
        Map<String, Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();

        Schema.DescribeSObjectResult TR = Schema.SObjectType.Task;
        Map<String, Schema.RecordTypeInfo> TRMapByName = TR.getRecordTypeInfosByName();

        Profile sa = [SELECT Id FROM profile WHERE name = 'System Administrator'];
        
        //LSLEVIN 2.10.16 S-376887 updated below liens employee id to include OD
        User u1 = new User(alias = 'test123 ', email = 'proxy@proxy456.officedepot.com', OD_Employee_ID__c = 'xx887', emailencodingkey = 'UTF-8', lastname = 'test123', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = sa.Id, timezonesidkey = 'America/Los_Angeles', username = 'proxy@proxy456.com', isactive = true);
        insert u1;
          System.runAs(u1)
    {

        //Create a case
        Case testCase = new Case();
        testCase.RecordTypeId = CRMapByName.get('IT Cases').getRecordTypeId();
        testCase.Subject = 'Test Case';
        testCase.IT_BU_Reviewer__c = u1.id;
        insert testCase;


        //create an tasks for case
        //List<Task> testTasks = new List<Task>();

        test.startTest();


        Task BizMigValTask = new Task();
        BizMigValTask.recordtypeid = TRMapByName.get('Support Task').getRecordTypeId();
        BizMigValTask.Task_Type__c = 'Business';
        BizMigValTask.action__c = 'Migration Validation';
        BizMigValTask.outcome__c = 'Rejected';
        BizMigValTask.Status =  'Completed';
        BizMigValTask.WhatId = testCase.id;
        Insert BizMigValTask;

        test.stopTest();
    }

    }

    @isTest static void test_AccountTask() {
        //Generate Type Maps
        Schema.DescribeSObjectResult AR = Schema.SObjectType.Account;
        Map<String, Schema.RecordTypeInfo> ARMapByName = AR.getRecordTypeInfosByName();

        Schema.DescribeSObjectResult TR = Schema.SObjectType.Task;
        Map<String, Schema.RecordTypeInfo> TRMapByName = TR.getRecordTypeInfosByName();

        Schema.DescribeSObjectResult CR = Schema.SObjectType.Contact;
        Map<String, Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();

        //Create User
        Profile sa = [SELECT Id FROM profile WHERE name = 'System Administrator'];
        //LSLEVIN 2.10.16 S-376887 updated below liens employee id to include OD
        User u1 = new User(alias = 'test123 ', email = 'proxy@proxy456.officedepot.com', OD_Employee_ID__c = 'xx7789', emailencodingkey = 'UTF-8', lastname = 'test123', languagelocalekey = 'en_US', localesidkey = 'en_US', profileid = sa.Id, timezonesidkey = 'America/Los_Angeles', username = 'proxy@proxy456.com', isactive = true);
        insert u1;
  System.runAs(u1)
    {
        //Create Sales Person
        Sales_Person__c sp = new Sales_Person__c (name = 'test', user__c = u1.id);
        insert sp;

        

        //create an account
        Account acc = new Account ();
        acc.name = 'Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        acc.OwnerID = u1.id;
        acc.Sales_PersonID__c = sp.id;
        insert acc;
        

       Account accSite = new Account ();
       accSite.name = 'Test Site';
       accSite.BillingStreet = '1040 N 326 W';
       accSite.billingcity = 'Orem';
       accSite.BillingState = 'UT';
       accSite.Billingcountry = 'US';
       accSite.Address1__c = '4785 S Citation Drive';
       accSite.Address2__c = '202';
       accSite.City__c = 'Delray Beach';
       accSite.State__c = 'FL';
       accSite.zip__c ='33351';
       accSite.Country__c = 'USA';
       accSite.County__c = 'US';
       accSite.Related_Account__c = acc.id;
       accSite.Primary_Site__c= true;
       accSite.Oracle_Party_Site_Id__c = 'testdata';
       accSite.AOPS_Cust_Id__c = '12345678';
       accSite.AOPS_Seq_ID__c = '12345678';
       accSite.Cadence_Call_Date__c = system.today();
       accSite.Stage__c = 'SOW';
       accSite.Cadence_Call_Date_Override__c = True;
       accSite.Cadence_Call_Date_Override_Value__c = 20;
       accSite.recordtypeid = ARMapByName.get('Site').getRecordTypeId();

       insert accSite;
       


        //Create Site Contacts

        List<Contact> contacts = new List<Contact>();

        for (Integer i = 0; i < 6; i++) {
            contacts.add(new Contact(lastname = 'Test' + i,accountid = acc.id));
        }

        insert contacts;


        
        //Associate site contacts
        accSite.Site_Primary_Contact__c = contacts.get(0).id;
        accSite.Site_Contact2__c = contacts.get(1).id;
        accSite.Site_Contact3__c = contacts.get(2).id;
        accSite.Site_Contact4__c = contacts.get(3).id;
        accSite.Site_Contact5__c = contacts.get(4).id;
        accSite.Site_Contact6__c = contacts.get(5).id;
        update accSite;

        //create an tasks for case
        //List<Task> testTasks = new List<Task>();

        test.startTest();

        Task AcctTask = new Task();
        AcctTask.recordtypeid = TRMapByName.get('Inside Sales').getRecordTypeId();
        AcctTask.Call_Disposition__c = 'Sales Related';
        AcctTask.action__c = 'Migration Validation';
        AcctTask.Status =  'Completed';
        AcctTask.Call_Disposition__c = 'Pricing Maintenance';
        AcctTask.Disposition_Code__c = 'Pricing escalation';
        AcctTask.WhatId = accSite.id;
        Insert AcctTask;
        system.debug('whatid' + AcctTask.WhatId);
        test.stopTest();
    }
    }



}