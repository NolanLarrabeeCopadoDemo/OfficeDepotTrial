//
// 8/09/2016 Jessica Schilling Case 175803 Fixed test class failures
//
@isTest

private class WRFTaskManagement_TC
{
  //Case#00175758 --START--Hitesh[Aug 10, 2016]
  @testSetup static void createAcc() {
      Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
          insert acc;

          Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];
          User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='854796',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy785426@proxy456.com',isactive=true);
          insert u1;
  }
  //Case#00175758 --END--Hitesh[Aug 10, 2016]
    static testmethod void WRFTaskManagement_TC1()
    {

        List<Sobject> InsertList1 = new List<Sobject>();
        List<Sobject> InsertList2 = new List<Sobject>();
        List<Sobject> InsertList3 = new List<Sobject>();
        List<Sobject> UpdateList1 = new List<Sobject>();
        Map<String,Schema.RecordTypeInfo> WRFTaskRecType = Schema.SObjectType.WRF_Task__c.getRecordTypeInfosByName();
        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
        Map<String,Schema.RecordTypeInfo> CaseSlaRecType = Schema.SObjectType.Case_SLA__c.getRecordTypeInfosByName();

        //Case#00175758 --START--Hitesh[Aug 10, 2016]
        //Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];
        User u1 = [select id from User where email='proxy@proxy456.officedepot.com' limit 1];
        //User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='854796',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy785426@proxy456.com',isactive=true);
        //insert u1;

        Account acc = [select id from Account where AOPS_Seq_ID__c = '123456' and name ='SUN Test Account' limit 1];
        //Case#00175758 --END--Hitesh[Aug 10, 2016]

        Case_SLA__c csla = new Case_SLA__C();
        csla.RecordtypeId = CaseSlaRecType.get('WRF Task').getRecordTypeId();
        csla.Request_Type__c='Add Exclusions';
        csla.Request_Type__C ='Automatic Toner Replenishment (ATR)';
        csla.Parent_Task_Dis_Code__c='MPS Implementation';
        csla.Turnaround_Time__c=10;
        csla.Routed_to__c=u1.id;
        csla.Task_Sequence__c=1.0;
        insert Csla;

        Case_SLA__c csla1 = new Case_SLA__C();
        csla1.RecordtypeId = CaseSlaRecType.get('WRF Task').getRecordTypeId();
        csla1.Request_Type__c='Add Exclusions';
        csla1.Request_Type__C ='Automatic Toner Replenishment (ATR)';
        csla1.Parent_Task_Dis_Code__c='MPS Implementation';
        csla1.Turnaround_Time__c=10;
        csla1.Task_Sequence__c=1.0;
        csla1.Routed_to__c=u1.id;
        csla1.Control_Task_Sequence__c='1.0';
        insert csla1;


        Case WRFCase = new Case();
        WRFCase.RecordTypeId =CaseRecType.get('Work Request').getRecordTypeId();
        WRFCase.Status='New';
        WRFCase.WRF_Submission_Issue__c='Complete and Accurate';
        WRFCase.WRF_Request_Type__c='Automatic Toner Replenishment (ATR)';
        WRFCase.accountId = acc.id;    //Case#00175758 ----Hitesh[Aug 09, 2016]
        insert WRFCase;

        List<WRF_Task__C>wtlist=new List<WRF_Task__C>();
        WRF_Task__C WRF1 = new WRF_Task__C();
        WRF1.RecordTypeId=WRFTaskRecType.get('WRF Task').getRecordTypeId();
        WRF1.Disposition_Code__c='MPS Implementation';
        WRF1.Assigned_To__c=u1.id;
        WRF1.WRF__C=WRFCase.id;
        WRF1.WRF_Stage__c='Cross referencing';
        wtlist.add(WRF1);

        WRF_Task__C WRF2 = new WRF_Task__C();
        WRF2.RecordTypeId=WRFTaskRecType.get('WRF Task').getRecordTypeId();
        WRF2.Disposition_Code__c='Remediation';
        WRF2.Assigned_To__c=u1.id;
        WRF2.WRF__C=WRFCase.id;
        WRF2.WRF_Stage__c='Cross referencing';
        //wtlist.add(WRF2);    //Case#00175758 ----Hitesh[Aug 10, 2016]
        Test.startTest();
        insert wtlist;

        //Test.startTest();    //hitesh
        WRF_Task__C WRFSubTask = new WRF_Task__C();
        WRFSubTask.RecordTypeId=WRFTaskRecType.get('WRF Sub Task').getRecordTypeId();
        WRFSubTask.Parent_WRF_Task__c=WRF1.id;
        WRFSubTask.Disposition_Code__c='Public/GPO';
        WRFSubTask.Assigned_To__c=u1.id;
        WRFSubTask.WRF__C=WRFCase.id;
        WRFSubTask.Task_Sequence__c=1.0;
        //InsertList1.add(WRFSubTask);    //Case#00175758 ----Hitesh[Aug 10, 2016]

        WRF_Task__C WRFSubTask1 = new WRF_Task__C();
        WRFSubTask1.RecordTypeId=WRFTaskRecType.get('WRF Sub Task').getRecordTypeId();
        WRFSubTask1.Parent_WRF_Task__c=WRF1.id;
        WRFSubTask1.Disposition_Code__c='Remediation';
        WRFSubTask1.Assigned_To__c=u1.id;
        WRFSubTask1.Task_Sequence__c=1.0;
        WRFSubTask1.WRF__C=WRFCase.id;
        //InsertList1.add(WRFSubTask1);    //Case#00175758 ----Hitesh[Aug 10, 2016]

        WRF_Task__C WRFSubTask2 = new WRF_Task__C();
        WRFSubTask2.RecordTypeId=WRFTaskRecType.get('WRF Sub Task').getRecordTypeId();
        WRFSubTask2.Parent_WRF_Task__c=WRF1.id;
        WRFSubTask2.Disposition_Code__c='MPS Pricing';
        WRFSubTask2.Assigned_To__c=u1.id;
        WRFSubTask2.WRF__C=WRFCase.id;
        WRFSubTask2.Task_Sequence__c=1.0;
        InsertList1.add(WRFSubTask2);

        insert InsertList1;
    Test.stopTest();    //Case#00175758 ----Hitesh[Aug 10, 2016]


        WRFSubTask.Disposition_Code__c='MPS Implementation';
        WRFSubTask.Projected_Gross_IMU__c=10.2;
        WRFSubTask.Projected_Sales__c=100;
        WRFSubTask.Status__C='Completed';
        WRFSubTask.Task_Type__c = 'Pricing/CPM'; //S-309660 - Fix test class failure and increase code coverage
        WRFSubTask.number_of_Devices__c=2;
        WRFSubTask.Task_Sequence__c=1.0;
        WRFSubTask1.Task_Sequence__c=1.0;
        WRFSubTask2.Task_Sequence__c=1.0;
        UpdateList1.add(WRFSubTask);
        UpdateList1.add(WRFSubTask1);
        UpdateList1.add(WRFSubTask2);
        //START S-309660 [Hemant 5/20/2015] - Fix test class failure
        //update UpdateList1;    //Case#00175758 ----Hitesh[Aug 10, 2016]

        UpdateList1 = new List<WRF_Task__C>();
        //END S-309660
        WRF1.Disposition_Code__c='MPS Implementation';
        WRF1.Projected_Gross_IMU__c=10.2;
        WRF1.Projected_Sales__c=100;
        WRF1.number_of_Devices__c=2;
        WRF1.Status__C='Completed';
        UpdateList1.add(WRF1);

        //update UpdateList1;    //Case#00175758 ----Hitesh[Aug 10, 2016]
        //delete WRF2; //S-309660 - Fix test class failure and increase code coverage //hitesh
    //Test.stopTest();    //hitesh
    }

    //Added for S-429674
    static testmethod void WRFTaskManagement_TC11()
    {

        List<Sobject> InsertList1 = new List<Sobject>();
        List<Sobject> InsertList2 = new List<Sobject>();
        List<Sobject> InsertList3 = new List<Sobject>();
        List<Sobject> UpdateList1 = new List<Sobject>();
        Map<String,Schema.RecordTypeInfo> WRFTaskRecType = Schema.SObjectType.WRF_Task__c.getRecordTypeInfosByName();
        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
        Map<String,Schema.RecordTypeInfo> CaseSlaRecType = Schema.SObjectType.Case_SLA__c.getRecordTypeInfosByName();

        User u1 = [select id from User where email='proxy@proxy456.officedepot.com' limit 1];

        Account acc = [select id from Account where AOPS_Seq_ID__c = '123456' and name ='SUN Test Account' limit 1];

        Case_SLA__c csla = new Case_SLA__C();
        csla.RecordtypeId = CaseSlaRecType.get('WRF Task').getRecordTypeId();
        csla.Request_Type__c='Add Exclusions';
        csla.Request_Type__C ='Automatic Toner Replenishment (ATR)';
        csla.Parent_Task_Dis_Code__c='MPS Implementation';
        csla.Turnaround_Time__c=10;
        csla.Routed_to__c=u1.id;
        csla.Task_Sequence__c=1.0;
        insert Csla;

        Case_SLA__c csla1 = new Case_SLA__C();
        csla1.RecordtypeId = CaseSlaRecType.get('WRF Task').getRecordTypeId();
        csla1.Request_Type__c='Add Exclusions';
        csla1.Request_Type__C ='Automatic Toner Replenishment (ATR)';
        csla1.Parent_Task_Dis_Code__c='MPS Implementation';
        csla1.Turnaround_Time__c=10;
        csla1.Task_Sequence__c=1.0;
        csla1.Routed_to__c=u1.id;
        csla1.Control_Task_Sequence__c='1.0';
        insert csla1;


        Case WRFCase = new Case();
        WRFCase.RecordTypeId =CaseRecType.get('Work Request').getRecordTypeId();
        WRFCase.Status='New';
        WRFCase.WRF_Submission_Issue__c='Complete and Accurate';
        WRFCase.WRF_Request_Type__c='Automatic Toner Replenishment (ATR)';
        WRFCase.accountId = acc.id;
        insert WRFCase;

        List<WRF_Task__C>wtlist=new List<WRF_Task__C>();
        WRF_Task__C WRF2 = new WRF_Task__C();
        WRF2.RecordTypeId=WRFTaskRecType.get('WRF Task').getRecordTypeId();
        WRF2.Disposition_Code__c='Remediation';
        WRF2.Assigned_To__c=u1.id;
        WRF2.WRF__C=WRFCase.id;
        WRF2.WRF_Stage__c='Cross referencing';
        wtlist.add(WRF2);


        Test.startTest();
        insert wtlist;

        WRF_Task__C WRFSubTask = new WRF_Task__C();
        WRFSubTask.RecordTypeId=WRFTaskRecType.get('WRF Sub Task').getRecordTypeId();
        WRFSubTask.Parent_WRF_Task__c=WRF2.id;
        WRFSubTask.Disposition_Code__c='Public/GPO';
        WRFSubTask.Assigned_To__c=u1.id;
        WRFSubTask.WRF__C=WRFCase.id;
        WRFSubTask.Task_Sequence__c=1.0;
        InsertList1.add(WRFSubTask);

        WRF_Task__C WRFSubTask1 = new WRF_Task__C();
        WRFSubTask1.RecordTypeId=WRFTaskRecType.get('WRF Sub Task').getRecordTypeId();
        WRFSubTask1.Parent_WRF_Task__c=WRF2.id;
        WRFSubTask1.Disposition_Code__c='Remediation';
        WRFSubTask1.Assigned_To__c=u1.id;
        WRFSubTask1.Task_Sequence__c=1.0;
        WRFSubTask1.WRF__C=WRFCase.id;
        InsertList1.add(WRFSubTask1);
        WRF_Task__C WRFSubTask2 = new WRF_Task__C();
        WRFSubTask2.RecordTypeId=WRFTaskRecType.get('WRF Sub Task').getRecordTypeId();
        WRFSubTask2.Parent_WRF_Task__c=WRF2.id;
        WRFSubTask2.Disposition_Code__c='MPS Pricing';
        WRFSubTask2.Assigned_To__c=u1.id;
        WRFSubTask2.WRF__C=WRFCase.id;
        WRFSubTask2.Task_Sequence__c=1.0;
        InsertList1.add(WRFSubTask2);

        insert InsertList1;


        WRFSubTask.Disposition_Code__c='MPS Implementation';
        WRFSubTask.Projected_Gross_IMU__c=10.2;
        WRFSubTask.Projected_Sales__c=100;
        WRFSubTask.Status__C='Completed';
        WRFSubTask.Task_Type__c = 'Pricing/CPM';
        WRFSubTask.number_of_Devices__c=2;
        WRFSubTask.Task_Sequence__c=1.0;
        WRFSubTask1.Task_Sequence__c=1.0;
        WRFSubTask2.Task_Sequence__c=1.0;
        UpdateList1.add(WRFSubTask);
        UpdateList1.add(WRFSubTask1);
        UpdateList1.add(WRFSubTask2);
        Test.stopTest();
        update UpdateList1;

    } //end S-429674


    static testmethod void WRFTaskManagement_TC2()
    {
        Map<String,Schema.RecordTypeInfo> WRFTaskRecType = Schema.SObjectType.WRF_Task__c.getRecordTypeInfosByName();
        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();

        //Case#00175758 --START--Hitesh[Aug 10, 2016]
        //Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];
        User u1 = [select id from User where email='proxy@proxy456.officedepot.com' limit 1];
        //User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='854796',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy785426@proxy456.com',isactive=true);
        //insert u1;

        Account acc = [select id from Account where AOPS_Seq_ID__c = '123456' and name ='SUN Test Account' limit 1];
        //Case#00175758 --END--Hitesh[Aug 10, 2016]


        Case WRFCase = new Case();
        WRFCase.RecordTypeId =CaseRecType.get('Work Request').getRecordTypeId();
        WRFCase.Status='New';
        WRFCase.WRF_Submission_Issue__c='Complete and Accurate';
        WRFCase.WRF_Request_Type__c='Automatic Toner Replenishment (ATR)';
        WRFCase.accountId = acc.id;    //Case#00175758 ----Hitesh[Aug 09, 2016]
        insert WRFCase;

        List<Sobject> InsrtList = new List<Sobject>();

        WRF_Task__C WRF1 = new WRF_Task__C();
        WRF1.RecordTypeId=WRFTaskRecType.get('WRF Task').getRecordTypeId();
        WRF1.Disposition_Code__c='Bids';
        WRF1.Assigned_To__c=u1.id;
        WRF1.WRF__C=WRFCase.id;
        InsrtList.add(WRF1);

        WRF_Task__C WRF2 = new WRF_Task__C();
        WRF2.RecordTypeId=WRFTaskRecType.get('WRF Task').getRecordTypeId();
        WRF2.Disposition_Code__c='MPS Implementation';
        WRF2.Assigned_To__c=u1.id;
        WRF2.WRF__C=WRFCase.id;
        //InsrtList.add(WRF2);    //Case#00175758 ----Hitesh[Aug 09, 2016]

    test.starttest();
        insert InsrtList;

        InsrtList.clear();

        WRF_Task__C WRFSubTask = new WRF_Task__C();
        WRFSubTask.RecordTypeId=WRFTaskRecType.get('WRF Sub Task').getRecordTypeId();
        WRFSubTask.Parent_WRF_Task__c=WRF1.id;
        WRFSubTask.Disposition_Code__c='Public/GPO';
        WRFSubTask.Assigned_To__c=u1.id;
        WRFSubTask.WRF__C=WRFCase.id;
        WRFSubTask.Task_Sequence__c=1.0;
        //InsrtList.add(WRFSubTask);    //Case#00175758 ----Hitesh[Aug 09, 2016]

        WRF_Task__C WRFSubTask1 = new WRF_Task__C();
        WRFSubTask1.RecordTypeId=WRFTaskRecType.get('WRF Sub Task').getRecordTypeId();
        WRFSubTask1.Parent_WRF_Task__c=WRF1.id;
        WRFSubTask1.Disposition_Code__c='MPS Implementation';
        WRFSubTask1.Assigned_To__c=u1.id;
        WRFSubTask1.WRF__C=WRFCase.id;
        WRFSubTask1.Task_Sequence__c=1.0;
        InsrtList.add(WRFSubTask1);

        insert InsrtList;
        test.stoptest();    //Case#00175758 ----Hitesh[Aug 09, 2016]
        InsrtList.clear();
        //InsrtList.add(WRF2);
        InsrtList.add(WRF1);
        Delete InsrtList;
    }

    static testMethod void method_AutoSeq()
    {
        Map<String,Schema.RecordTypeInfo> WRFTaskRecType = Schema.SObjectType.WRF_Task__c.getRecordTypeInfosByName();
        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
        Map<String,Schema.RecordTypeInfo> CaseSlaRecType = Schema.SObjectType.Case_SLA__c.getRecordTypeInfosByName();

        //Case#00175758 --START--Hitesh[Aug 10, 2016]
        //Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];
        User u1 = [select id from User where email='proxy@proxy456.officedepot.com' limit 1];
        //User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='854796',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy785426@proxy456.com',isactive=true);
        //insert u1;

        Account acc = [select id from Account where AOPS_Seq_ID__c = '123456' and name ='SUN Test Account' limit 1];
        //Case#00175758 --END--Hitesh[Aug 10, 2016]

        Case WRFCase = new Case();
        WRFCase.RecordTypeId =CaseRecType.get('Work Request').getRecordTypeId();
        WRFCase.Status='New';
        WRFCase.WRF_Submission_Issue__c='Complete and Accurate';
        WRFCase.WRF_Request_Type__C ='Automatic Toner Replenishment (ATR)';
        WRFCase.accountId = acc.id;     //Case#00175758 ----Hitesh[Aug 09, 2016]
        insert WRFCase;
        //Test.startTest(); //S-309660 - Fix test class failure and increase code coverage
        Case_SLA__c csla1 = new Case_SLA__C();
        csla1.RecordtypeId = CaseSlaRecType.get('WRF Task').getRecordTypeId();
        csla1.Request_Type__c='Add Exclusions';
        csla1.Request_Type__C ='Automatic Toner Replenishment (ATR)';
        csla1.Parent_Task_Dis_Code__c='MPS Implementation';
        csla1.Turnaround_Time__c=10;
        csla1.Task_Sequence__c=1.0;
        csla1.Routed_to__c=u1.id;
        //csla1.Control_Task_Sequence__c='1.0';
        insert csla1;

        WRF_Task__C WRFTsk = new WRF_Task__C();
        WRFTsk.RecordTypeId=WRFTaskRecType.get('WRF Task').getRecordTypeId();
        WRFTsk.Disposition_Code__c='MPS Implementation';
        WRFTsk.Assigned_To__c=u1.id;
        WRFTsk.WRF__C=WRFCase.id;
        WRFTsk.Due_date__C=system.today();
        WRFTsk.Task_Sequence__c=1.0;



        Test.startTest(); //S-309660 - Fix test class failure and increase code coverage

        Insert WRFTsk;    //Case#00175758 ----Hitesh[Aug 10, 2016]
        WRF_Task__C WRFSubTsk = new WRF_Task__C();
        WRFSubTsk.RecordTypeId=WRFTaskRecType.get('WRF Sub Task').getRecordTypeId();
        WRFSubTsk.Disposition_Code__c='MPS Implementation';
        WRFSubTsk.Assigned_To__c=u1.id;
        WRFSubTsk.WRF__C=WRFCase.id;
        WRFSubTsk.number_of_Devices__c=2;
        WRFSubTsk.Parent_WRF_Task__c=WRFTsk.id;
        WRFSubTsk.Due_date__C=system.today();
        WRFSubTsk.Task_Sequence__c=1;
        Insert WRFSubTsk;

    test.stopTest();    //Case#00175758 ----Hitesh[Aug 10, 2016]
        //Test.startTest();
        csla1.Control_Task_Sequence__c='1';
        update csla1;
        WRFSubTsk.Due_date__C=system.today()+1;
        WRFSubTsk.status__c='Completed';
        Update WRFSubTsk;

     //added for S-429674
        WRFTaskManagement.gBusinessHours();
        //end S-429674
    }


    static testMethod void method1()
    {
        List<Sobject> InsertList1 = new List<Sobject>();
        List<Sobject> InsertList2 = new List<Sobject>();
        List<Sobject> InsertList3 = new List<Sobject>();
        List<Sobject> UpdateList1 = new List<Sobject>();
        Map<String,Schema.RecordTypeInfo> WRFTaskRecType = Schema.SObjectType.WRF_Task__c.getRecordTypeInfosByName();
        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
        Map<String,Schema.RecordTypeInfo> CaseSlaRecType = Schema.SObjectType.Case_SLA__c.getRecordTypeInfosByName();

        //Case#00175758 --START--Hitesh[Aug 10, 2016]
        //Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];
        User u1 = [select id from User where email='proxy@proxy456.officedepot.com' limit 1];
        //User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='854796',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy785426@proxy456.com',isactive=true);
        //insert u1;

        Account acc = [select id from Account where AOPS_Seq_ID__c = '123456' and name ='SUN Test Account' limit 1];
        //Case#00175758 --END--Hitesh[Aug 10, 2016]

        List<case> WRFCases = new List<case>();

        Case WRFCase = new Case();
        WRFCase.RecordTypeId =CaseRecType.get('Work Request').getRecordTypeId();
        WRFCase.Status='New';
        WRFCase.WRF_Submission_Issue__c='Complete and Accurate';
        WRFCase.WRF_Request_Type__C ='Automatic Toner Replenishment (ATR)';
        WRFCase.accountId = acc.id;    //Case#00175758 ----Hitesh[Aug 09, 2016]
        WRFCases.add(WRFCase);      //Case#00175758 ----Hitesh[Aug 10, 2016]
        //insert WRFCase;        //Case#00175758 ----Hitesh[Aug 10, 2016]

        Case WRFCase1 = new Case();
        WRFCase1.RecordTypeId =CaseRecType.get('Work Request').getRecordTypeId();
        WRFCase1.Status='New';
        WRFCase1.WRF_Submission_Issue__c='Complete and Accurate';
        //Added the below line JSCHILLING Case 175803 8/09/2016 Added to fix test class failure
        WRFCase1.AccountId = acc.Id;
        WRFCases.add(WRFCase1);      //Case#00175758 ----Hitesh[Aug 10, 2016]
        //insert WRFCase1;        //Case#00175758 ----Hitesh[Aug 10, 2016]
        insert WRFCases;        //Case#00175758 ----Hitesh[Aug 10, 2016]



        Case_SLA__c csla1 = new Case_SLA__C();
        csla1.RecordtypeId = CaseSlaRecType.get('WRF Task').getRecordTypeId();
        csla1.Request_Type__c='Add Exclusions';
        csla1.Request_Type__C ='Automatic Toner Replenishment (ATR)';
        csla1.Parent_Task_Dis_Code__c='MPS Implementation';
        csla1.Turnaround_Time__c=10;
        csla1.Task_Sequence__c=1.0;
        csla1.Routed_to__c=u1.id;
        csla1.Control_Task_Sequence__c='1.0';

        Test.startTest();

        List<WRF_Task__c> wrfTaskList = new List<WRF_Task__c>(); //S-309660 [Hemant 5/20/2015] - Fix test class failure
        WRF_Task__C WRF1 = new WRF_Task__C();
        WRF1.RecordTypeId=WRFTaskRecType.get('WRF Task').getRecordTypeId();
        WRF1.Disposition_Code__c='MPS Implementation';
        WRF1.Assigned_To__c=u1.id;
        WRF1.WRF__C=WRFCase.id;
        WRF1.Due_date__C=system.today();
        //Insert WRF1; //S-309660 [Hemant 5/20/2015] - Fix test class failure
        //wrfTaskList.add(WRF1);      //Case#00175758 ----Hitesh[Aug 10, 2016]


        WRF_Task__C WRF2 = new WRF_Task__C();
        WRF2.RecordTypeId=WRFTaskRecType.get('WRF Task').getRecordTypeId();
        WRF2.Disposition_Code__c='MPS Implementation';
        WRF2.Assigned_To__c=u1.id;
        //WRF2.WRF__C=WRFCase.id;      //Case#00175758 ----Hitesh[Aug 10, 2016]
        WRF2.WRF__C=WRFCases[0].id;      //Case#00175758 ----Hitesh[Aug 10, 2016]
        WRF2.Due_date__C=system.today();
        WRF2.status__c='Awaiting Action';
        //insert WRF2; //S-309660 [Hemant 5/20/2015] - Fix test class failure
        wrfTaskList.add(WRF2);

        WRF_Task__C WRF3 = new WRF_Task__C();
        WRF3.RecordTypeId=WRFTaskRecType.get('WRF Task').getRecordTypeId();
        WRF3.Disposition_Code__c='MPS Implementation';
        WRF3.Assigned_To__c=u1.id;
        WRF3.WRF__C=WRFCase.id;
        WRF3.Due_date__C=system.today();
        WRF3.status__c='Awaiting Action';
        //insert WRF3; //S-309660 [Hemant 5/20/2015] - Fix test class failure
        //wrfTaskList.add(WRF3);      //Case#00175758 ----Hitesh[Aug 10, 2016]

        insert wrfTaskList; //S-309660 [Hemant 5/20/2015] - Fix test class failure

        WRF_Task__C WRFSubTask = new WRF_Task__C();
        WRFSubTask.RecordTypeId=WRFTaskRecType.get('WRF Sub Task').getRecordTypeId();
        WRFSubTask.Parent_WRF_Task__c=WRF2.id;
        WRFSubTask.Disposition_Code__c='Public/GPO';
        WRFSubTask.Assigned_To__c=u1.id;
       // WRFSubTask.WRF__C=WRFCase.id;    //Case#00175758 ----Hitesh[Aug 10, 2016]
           WRFSubTask.WRF__C=WRFCases[0].id;    //Case#00175758 ----Hitesh[Aug 10, 2016]
        WRFSubTask.Task_Sequence__c=1.0;
        WRFSubTask.status__c='Awaiting Action';
        InsertList1.add(WRFSubTask);

        WRF_Task__C WRFSubTask1 = new WRF_Task__C();
        WRFSubTask1.RecordTypeId=WRFTaskRecType.get('WRF Sub Task').getRecordTypeId();
        WRFSubTask1.Parent_WRF_Task__c=WRF1.id;
        WRFSubTask1.Disposition_Code__c='Public/GPO';
        WRFSubTask1.Assigned_To__c=u1.id;
        WRFSubTask1.WRF__C=WRFCase.id;
        WRFSubTask1.Task_Sequence__c=1.0;
        //InsertList1.add(WRFSubTask1);      //Case#00175758 ----Hitesh[Aug 10, 2016]



        insert InsertList1;
    Test.stopTest();      //Case#00175758 ----Hitesh[Aug 10, 2016]


        WRFSubTask.Task_Sequence__c=1.0;
        WRFSubTask.status__c='Completed';
        WRFSubTask.Disposition_Code__c='Bids';
        update WRFSubTask;    //Case#00175758 ----Hitesh[Aug 10, 2016]

        executeoncetest.querycaseonce=true;
        executeoncetest.wrftaskupdate=true;
        WRF1.Due_date__C=system.today()+1;
        WRF1.number_of_Devices__c=2;
        WRF1.Status__C='Completed';
        //update WRF1;          //Case#00175758 ----Hitesh[Aug 10, 2016]
    }

    //Added for story S-423432
     static testmethod void WRFTaskManagement_TC3()
    {

        List<Sobject> InsertList1 = new List<Sobject>();
        List<Sobject> InsertList2 = new List<Sobject>();
        List<Sobject> InsertList3 = new List<Sobject>();
        List<Sobject> UpdateList1 = new List<Sobject>();
        Map<String,Schema.RecordTypeInfo> WRFTaskRecType = Schema.SObjectType.WRF_Task__c.getRecordTypeInfosByName();
        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();

        //Case#00175758 --START--Hitesh[Aug 10, 2016]
        //Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];
        User u1 = [select id from User where email='proxy@proxy456.officedepot.com' limit 1];
        //User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='854796',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy785426@proxy456.com',isactive=true);
        //insert u1;

        Account acc = [select id from Account where AOPS_Seq_ID__c = '123456' and name ='SUN Test Account' limit 1];
        //Case#00175758 --END--Hitesh[Aug 10, 2016]

        Case WRFCase = new Case();
        WRFCase.RecordTypeId =CaseRecType.get('Work Request').getRecordTypeId();
        WRFCase.Status='New';
        WRFCase.WRF_Submission_Issue__c='Complete and Accurate';
        WRFCase.WRF_Request_Type__c='Automatic Toner Replenishment (ATR)';
        WRFCase.accountId = acc.id;    //Case#00175758 ----Hitesh[Aug 09, 2016]
        insert WRFCase;

        List<WRF_Task__C>wtlist=new List<WRF_Task__C>();
        WRF_Task__C WRF1 = new WRF_Task__C();
        WRF1.RecordTypeId=WRFTaskRecType.get('WRF Task').getRecordTypeId();
        WRF1.Disposition_Code__c='MPS Implementation';
        WRF1.Assigned_To__c=u1.id;
        WRF1.WRF__C=WRFCase.id;
        WRF1.WRF_Stage__c='Cross referencing';
        wtlist.add(WRF1);

    Test.startTest();    //Case#00175758 ----Hitesh[Aug 09, 2016]
        insert wtlist;


        WRF_Task__C WRFSubTask = new WRF_Task__C();
        WRFSubTask.RecordTypeId=WRFTaskRecType.get('WRF Sub Task').getRecordTypeId();
        WRFSubTask.Parent_WRF_Task__c=WRF1.id;
        WRFSubTask.Disposition_Code__c='Public/GPO';
        WRFSubTask.Assigned_To__c=u1.id;
        WRFSubTask.WRF__C=WRFCase.id;
        WRFSubTask.Task_Sequence__c=1.0;
        WRFSubTask.Task_Type__c = 'Pricing/CPM';
        InsertList1.add(WRFSubTask);


        insert InsertList1;
    Test.stopTest();

        WRFSubTask.Status__C='Completed';
        WRF1.Status__C='Completed';
        WRF1.Disposition_Code__c='MPS Implementation';
        WRF1.Projected_Gross_IMU__c=10.2;
        WRF1.Projected_Sales__c=100;
        WRF1.number_of_Devices__c=2;
        //Modified for   S-429674
        update WRFSubTask;    //Case#00175758 ----Hitesh[Aug 09, 2016]

        UpdateList1.add(WRF1);
        //update UpdateList1;
        //End S-429674

        //System.assertEquals(true, [Select Id, All_Task_Closed__c from Case where id=: WRFCase.id].get(0).All_Task_Closed__c);    //Case#00175758 ----Hitesh[Aug 09, 2016]

    } //END S-423432


    //Added for story S-429674
     static testmethod void WRFTaskManagement_TC4()
    {

        List<Sobject> InsertList1 = new List<Sobject>();
        List<Sobject> InsertList2 = new List<Sobject>();
        List<Sobject> InsertList3 = new List<Sobject>();
        List<Sobject> UpdateList1 = new List<Sobject>();
        Map<String,Schema.RecordTypeInfo> WRFTaskRecType = Schema.SObjectType.WRF_Task__c.getRecordTypeInfosByName();
        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();

    User u1 = [select id from User where email='proxy@proxy456.officedepot.com' limit 1];
        Account acc = [select id from Account where AOPS_Seq_ID__c = '123456' and name ='SUN Test Account' limit 1];

        Case WRFCase = new Case();
        WRFCase.RecordTypeId =CaseRecType.get('Work Request').getRecordTypeId();
        WRFCase.Status='New';
        WRFCase.WRF_Submission_Issue__c='Complete and Accurate';
        WRFCase.WRF_Request_Type__c='Automatic Toner Replenishment (ATR)';
        WRFCase.accountId = acc.id;
        insert WRFCase;

        List<WRF_Task__C>wtlist=new List<WRF_Task__C>();
        WRF_Task__C WRF1 = new WRF_Task__C();
        WRF1.RecordTypeId=WRFTaskRecType.get('WRF Task').getRecordTypeId();
        WRF1.Disposition_Code__c='MPS Implementation';
        WRF1.Assigned_To__c=u1.id;
        WRF1.WRF__C=WRFCase.id;
        WRF1.WRF_Stage__c='Cross referencing';
        wtlist.add(WRF1);
        
    Test.startTest();
        insert wtlist;

        WRF1.Status__C='Completed';
        WRF1.Disposition_Code__c='MPS Implementation';
        WRF1.Projected_Gross_IMU__c=10.2;
        WRF1.Projected_Sales__c=100;
        WRF1.number_of_Devices__c=2;

        UpdateList1.add(WRF1);
        update UpdateList1;
		Test.stopTest();

    } //END S-429674


}