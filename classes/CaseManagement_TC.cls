//
// 8/09/2016 Jessica Schilling Case 175803 Fixed test class failures
//
@isTest
private class CaseManagement_TC

{
     
    static testMethod void WRFCaseManagement_TC()
    {
try {

         Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];
         List<User> insertuser= new List<User>();
         User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='123456',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive=true);
         insertuser.add(u1);
         User u2 = new User(alias = 'test123 ', email='proxy@proxy4567.officedepot.com',OD_Employee_ID__c='xxyy123457',emailencodingkey='UTF-8', lastname='test1234',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy457.com',isactive=true);
         insertuser.add(u2);
         insert insertuser;

         Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
         Map<String,Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();

         Schema.DescribeSObjectResult AR = Schema.SObjectType.Account;
         Map<String,Schema.RecordTypeInfo> ARMapByName = AR.getRecordTypeInfosByName();

         Schema.DescribeSObjectResult WRF = Schema.SObjectType.WRF_Task__C;
         Map<String,Schema.RecordTypeInfo> WRFMapByName = WRF.getRecordTypeInfosByName();

         List<Sobject> InsrtAccList = new List<Sobject>();
         List<Sobject> InsrtCseList = new List<Sobject>();
         List<Sobject> InsrtWRFList = new List<Sobject>();
         List<Sobject> UpdateCseList = new List<Sobject>();
         System.debug('=========== TEST STARTED==============');
         Account acc = new Account();
         acc.Name='Test Account 1';
         acc.recordTypeId = ARMapByName.get('Customer').getRecordTypeId();
         acc.AOPS_Cust_ID__C='78906';
         insert acc;
         InsrtAccList.add(acc);

         Account acc1 = new Account();
         acc1.Name='Test Account 1';
         acc1.recordTypeId = ARMapByName.get('Prospect').getRecordTypeId();
         acc1.Oracle_Party_Id__C='78907';
         insert acc1;
         InsrtAccList.add(acc1);

         Insert  InsrtAccList;

         Case WRCase1 = new Case();
         WRCase1.recordTypeId = CRMapByName .get('Work Request').getRecordTypeId();
         WRCase1.DUP_Acct_ID__c = '78906';
         WRCase1.DUP_Requestor_ID__c = '123456';
        WRCase1.WRF_Request_Type__c = 'Early Pay Discount Terms Requests';
         insert WRCase1;
         InsrtCseList.add(WRCase1);

        Case WRCase2 = new Case();
         WRCase2.recordTypeId = CRMapByName .get('Work Request').getRecordTypeId();
         WRCase2.DUP_Acct_ID__c = '78907';
         WRCase2.DUP_Requestor_ID__c = '123456';
         WRCase2.Approval_Status__C='Pending Approval';
         WRCase2.WRF_Date_CPM_Launched__C=System.today();
         WRCase2.Related_Case_Number__C='12345';
         WRCase2.Compliance_Mgr_Action_Date__c=System.today()-1;
         insert WRCase2;
         InsrtCseList.add(WRCase2); 
        
        Case WRCase3 = new Case();
         WRCase3.recordTypeId = CRMapByName .get('Work Request').getRecordTypeId();
         WRCase3.DUP_Acct_ID__c = '78907';
         WRCase3.DUP_Requestor_ID__c = '123456';
         WRCase3.Approval_Status__C='Pending Approval';
         WRCase3.WRF_Date_CPM_Launched__C=System.today();
         WRCase3.Related_Case_Number__C='12345';
        WRCase3.Compliance_Mgr_Action_Date__c=System.today()-1;
         InsrtCseList.add(WRCase3);
         System.RunAs(u1){
             insert InsrtCseList; 
         }

         WRF_Task__c WRFTsk1 = new WRF_Task__C();
         WRFTsk1.RecordTypeId=WRFMapByName.get('WRF Task').getRecordTypeId();
         WRFTsk1.WRF__C=WRCase1.id;
         WRFTsk1.Assigned_To__C=u1.id;
         WRFTsk1.Disposition_Code__C='Bids';
         WRFTsk1.Status__c='New';
         //Insert WRFTsk1;
         InsrtWRFList.add(WRFTsk1);

         WRF_Task__c WRFTsk2 = new WRF_Task__C();
         WRFTsk2.RecordTypeId=WRFMapByName.get('WRF Task').getRecordTypeId();
        // WRFTsk2.WRF__C=WRCase2.id;
         WRFTsk2.Assigned_To__C=u1.id;
         WRFTsk2.Disposition_Code__C='Bids';
         WRFTsk2.Status__c='New';
         //Insert WRFTsk2;
         InsrtWRFList.add(WRFTsk2);

         insert InsrtWRFList;
         Test.startTest();

         //START S-309660 [Hemant 5/22/2015] - Increase code coverage
         Record_History__c recHistory = new Record_History__c(Start_Date__c = Date.Today(), No_of_Hours__c = 5, Case__c = WRCase1.Id);
         insert recHistory;
         //END S-309660

         WRCase1.Approval_Status__C='Pending Approval';
         WRCase2.Approval_Status__C='Approved';
         WRCase2.Compliance_Mgr_Action_Date__c=System.today();
         WRCase2.IT_Action_Taken__c='Code Change';
         WRCase2.Status='Closed';
         WRCase2.Related_Case_Number__C=WRCase1.CaseNumber;

         WRCase1.Approval_Status__C='Approved';
         WRCase1.DSM_Action_Date__c = date.today(); //S-309660 [Hemant 5/22/2015] - Increase code coverage
         WRCase3.Compliance_Mgr_Action_Date__c=System.today()+1;
         WRCase1.Next_ApproverId__c=u1.id;

         UpdateCseList.add(WRCase1);
         UpdateCseList.add(WRCase2);
         UpdateCseList.add(WRCase3);

         
         update UpdateCseList;
         //START S-309660 [Hemant 5/22/2015] - Increase code coverage
         delete UpdateCseList; //S-309660 [Hemant 5/22/2015] - Increase code coverage
         CaseManagement.ENDOPERATIONS();
         //END S-309660
         Test.stopTest();


         System.debug('================ TEST ENDED============');
        }catch(Exception e){}

    }
    
    static testMethod void ACCMAINTCaseManagement_TC()
    {


         Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];
         List<User> insertuser= new List<User>();
         User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='xxyyOD123456',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive=true);
         insertuser.add(u1);
         User u2 = new User(alias = 'test123 ', email='proxy@proxy4567.officedepot.com',OD_Employee_ID__c='xxyyOD12456789',emailencodingkey='UTF-8', lastname='test1234',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy457.com',isactive=true);
         insertuser.add(u2);
         insert insertuser;
         Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
         Map<String,Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();

         Schema.DescribeSObjectResult AR = Schema.SObjectType.Account;
         Map<String,Schema.RecordTypeInfo> ARMapByName = AR.getRecordTypeInfosByName();

         Schema.DescribeSObjectResult WRF = Schema.SObjectType.WRF_Task__C;
         Map<String,Schema.RecordTypeInfo> WRFMapByName = WRF.getRecordTypeInfosByName();

         Schema.DescribeSObjectResult CSLARF = Schema.SObjectType.Case_SLA__C;
         Map<String,Schema.RecordTypeInfo> CSLAMapByName = CSLARF.getRecordTypeInfosByName();

         List<Sobject> InsrtAccList = new List<Sobject>();
         List<Sobject> InsrtCseList = new List<Sobject>();
         List<Sobject> InsrtWRFList = new List<Sobject>();
         List<Sobject> UpdateCseList = new List<Sobject>();
         System.debug('=========== TEST STARTED==============');
         Account acc = new Account();
         acc.Name='Test Account 1';
         acc.recordTypeId = ARMapByName.get('Customer').getRecordTypeId();
         acc.AOPS_Cust_ID__C='78906';
         acc.Implementation_Manager__c=u1.id;
         insert acc;
         // InsrtAccList.add(acc);

         Account acc1 = new Account();
         acc1.Name='Test Account 1';
         acc1.recordTypeId = ARMapByName.get('Prospect').getRecordTypeId();
         acc1.Oracle_Party_Id__C='78907';
         acc1.Implementation_Manager__c=u1.id;
         insert acc1;
         // InsrtAccList.add(acc1);

         // Insert  InsrtAccList;

        Case_SLA__c csla = new Case_SLA__C();
        csla.RecordtypeId = CSLAMapByName.get('Account').getRecordTypeId();
        csla.Request_Type__c='Add Exclusions';
        csla.Request_Type__C ='Catalog Update';
        csla.Parent_Task_Dis_Code__c='MPS Implementation';
        csla.Owner_Type__c='User';
        csla.Turnaround_Time__c=10;
        csla.Routed_to__c='123456';
        csla.Task_Sequence__c=1.0;
        insert Csla;
        

        
        Case_SLA__c csla1 = new Case_SLA__C();
        csla1.RecordtypeId = CSLAMapByName.get('Account').getRecordTypeId();
        csla1.Request_Type__c='Add Exclusions';
        csla1.Request_Type__C ='Catalog Update';
        csla1.Parent_Task_Dis_Code__c='MPS Implementation';
        csla1.Owner_Type__c='User';
        csla1.Turnaround_Time__c=10;
        csla1.Routed_to__c='123457';
        csla1.Task_Sequence__c=1.0;
        insert Csla1;
        
        Acct_Maint__c ACM = new Acct_Maint__c();
        ACM.Implementation_Manager__c = '123456';
        insert ACM;

         Case WRCase1 = new Case();
         WRCase1.WRF_Source__c='GMILL';
         WRCase1.WRF_Requestor__c=u1.id;
         WRCase1.recordTypeId = CRMapByName .get('Account Maintenance').getRecordTypeId();
         WRCase1.DUP_Acct_ID__c = '78906';
         WRCase1.DUP_Requestor_ID__c = '123456';
         WRCase1.AM_Assigned_TO__C=u1.id;
         WRCase1.DUP_Acct_Type__c = 'New Prospect';
         WRCase1.WRF_Request_Type__C='Catalog Update';
         //insert WRCase1;
         InsrtCseList.add(WRCase1);

         Case WRCase2 = new Case();
         WRCase2.recordTypeId = CRMapByName .get('Account Maintenance').getRecordTypeId();
         WRCase2.DUP_Acct_ID__c = '78907';
         WRCase2.DUP_Requestor_ID__c = '123456';
         WRCase2.Approval_Status__C='Pending Approval';
         WRCase2.WRF_Date_CPM_Launched__C=System.today();
         WRCase2.Related_Case_Number__C='12345';
         WRCase2.DUP_Acct_Type__c = 'New Prospect';
         WRCase2.Compliance_Mgr_Action_Date__c=System.today()-1;
         WRCase2.Related_Case_Number__c=WRCase1.Id;
         insert WRCase2;
         InsrtCseList.add(WRCase2);

         Case WRCase3 = new Case();
         WRCase3.recordTypeId = CRMapByName .get('Account Maintenance').getRecordTypeId();
         WRCase3.DUP_Acct_ID__c = '78907';
         WRCase3.DUP_Requestor_ID__c = '123456';
         WRCase3.Approval_Status__C='Pending Approval';
         WRCase3.WRF_Date_CPM_Launched__C=System.today();
         WRCase3.Related_Case_Number__C='12345';
         WRCase3.DUP_Acct_Type__c = 'New Prospect';
        WRCase3.Compliance_Mgr_Action_Date__c=System.today()-1;
         InsrtCseList.add(WRCase3);

         //START S-309660 [Hemant 5/22/2015] - Increase code coverage
         Case WRCase4 = new Case();
         WRCase4.recordTypeId = CRMapByName .get('Work Request').getRecordTypeId();
         WRCase4.DUP_Acct_ID__c = '78907';
         WRCase4.DUP_Requestor_ID__c = '123456';
         WRCase4.WRF_Date_CPM_Launched__C=System.today();
         WRCase4.Related_Case_Number__C='12345';
         WRCase4.DUP_Acct_Type__c = 'New Prospect';
         InsrtCseList.add(WRCase4);

         Case WRCase5 = new Case();
         WRCase5.recordTypeId = CRMapByName .get('Account Maintenance').getRecordTypeId();
         WRCase5.DUP_Acct_ID__c = '78907';
         WRCase5.DUP_Requestor_ID__c = '123456';
         WRCase5.Approval_Status__C='Pending Approval';
         WRCase5.WRF_Date_CPM_Launched__C=System.today();
         WRCase5.Related_Case_Number__C='12345';
         WRCase5.DUP_Acct_Type__c = 'New Prospect';
         WRCase5.WRF_Source__c='GMILL';
         WRCase5.WRF_Requestor__c=u1.id;
        // try{
            //insert WRCase5;
            //Update WRCase5;
        // }catch(Exception e){} //handle exception
         //END S-309660 [Hemant 5/22/2015] - Increase code coverage
     try{
         insert InsrtCseList;
    }catch(Exception e){} 
         
        Case testcase = [select id from case limit 1];
        

        
         WRF_Task__c WRFTsk1 = new WRF_Task__C();
         WRFTsk1.RecordTypeId=WRFMapByName.get('WRF Task').getRecordTypeId();
         WRFTsk1.WRF__C=WRCase1.id;
         WRFTsk1.Assigned_To__C=u1.id;
         WRFTsk1.Disposition_Code__C='Bids';
         WRFTsk1.Status__c='New';
         //Insert WRFTsk1;
         InsrtWRFList.add(WRFTsk1);

         WRF_Task__c WRFTsk2 = new WRF_Task__C();
         WRFTsk2.RecordTypeId=WRFMapByName.get('WRF Task').getRecordTypeId();
         WRFTsk2.WRF__C=WRCase2.id;
         WRFTsk2.Assigned_To__C=u1.id;
         WRFTsk2.Disposition_Code__C='Bids';
         WRFTsk2.Status__c='New';
         Insert WRFTsk2;
         InsrtWRFList.add(WRFTsk2);
  try{
        insert InsrtWRFList;
    }catch(Exception e){}
         
         

         WRCase1.Approval_Status__C='Pending Approval';
         WRCase1.WRF_Source__c='GMILL';
         WRCase1.WRF_Requestor__c=u1.id;
         WRCase1.AM_Assigned_TO__C=u2.id;
         WRCase1.AM_Assigned_TO1__C=u2.id;
         WRCase1.WRF_Request_Type__C='Comparison Private Brand';
         WRCase2.Approval_Status__C='Approved';
         //WRCase2.WRCase2.Compliance_Mgr_Action_Date__c=System.today();
         WRCase2.IT_Action_Taken__c='Code Change';
         WRCase2.Status='Closed';
         WRCase2.Related_Case_Number__C=WRCase1.CaseNumber;

         WRCase3.Approval_Status__C='Approved';
        // WRCase3.Compliance_Mgr_Action_Date__c=System.today()+1;
         WRCase3.Next_ApproverId__c=u1.id;
         WRCase4.Approval_Status__C='Pending Approval'; //S-309660 [Hemant 5/22/2015] - Increase code coverage

         UpdateCseList.add(WRCase1);
         UpdateCseList.add(WRCase2);
         UpdateCseList.add(WRCase3);

         Test.startTest();
          try{
           update UpdateCseList;
    }catch(Exception e){}
         
         
      
         Test.stopTest();


         System.debug('================ TEST ENDED============');
       
    }

    static testMethod void SupportCaseManagement_TC()
    {
/*
         Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];
         List<User> insertuser= new List<User>();
         User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='xxyy123456',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive=true);
         insertuser.add(u1);
         User u2 = new User(alias = 'test123 ', email='proxy@proxy4567.officedepot.com',OD_Employee_ID__c='xxyy123457',emailencodingkey='UTF-8', lastname='test1234',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy457.com',isactive=true);
         insertuser.add(u2);
         insert insertuser;
         Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
         Map<String,Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();

         Schema.DescribeSObjectResult AR = Schema.SObjectType.Account;
         Map<String,Schema.RecordTypeInfo> ARMapByName = AR.getRecordTypeInfosByName();

         Schema.DescribeSObjectResult WRF = Schema.SObjectType.WRF_Task__C;
         Map<String,Schema.RecordTypeInfo> WRFMapByName = WRF.getRecordTypeInfosByName();

         List<Sobject> InsrtAccList = new List<Sobject>();
         List<Sobject> InsrtCseList = new List<Sobject>();
         List<Sobject> InsrtWRFList = new List<Sobject>();
         List<Sobject> UpdateCseList = new List<Sobject>();
         System.debug('=========== TEST STARTED==============');
         Account acc = new Account();
         acc.Name='Test Account 1';
         acc.recordTypeId = ARMapByName.get('Customer').getRecordTypeId();
         acc.AOPS_Cust_ID__C='78906';
         //insert acc;
         InsrtAccList.add(acc);



         Task tsk = new Task();
         tsk.subject = 'Test Task';
         tsk.task_type__c = 'IT';
         tsk.Action__C = 'Analysis/Development';
         tsk.ownerId = '005E0000003cbs5' ;
         tsk.Status = 'New';
         tsk.activitydate = system.today();

         insert tsk;

         Account acc1 = new Account();
         acc1.Name='Test Account 1';
         acc1.recordTypeId = ARMapByName.get('Prospect').getRecordTypeId();
         acc1.Oracle_Party_Id__C='78907';
         //insert acc1;
         InsrtAccList.add(acc1);

         Insert  InsrtAccList;

         Case WRCase1 = new Case();
         WRCase1.recordTypeId = CRMapByName .get('Support').getRecordTypeId();
         WRCase1.DUP_Acct_ID__c = '78906';
         WRCase1.DUP_Requestor_ID__c = '123456';
         //WRCase1.IT_Assignment__C=u1.id; //S-309660 [Hemant 5/22/2015] - Increase code coverage
         WRCase1.IT_BU_Reviewer__c=u2.id;
         WRCase1.IT_Classification__c='Issue';
         WRCase1.Origin = 'Salesprism';
         WRCase1.wrf_requestor__c = '005E0000003cbs5';
         //insert WRCase1;
         InsrtCseList.add(WRCase1);

         Case WRCase2 = new Case();
         WRCase2.recordTypeId = CRMapByName .get('Support').getRecordTypeId();
         WRCase2.DUP_Acct_ID__c = '78907';
         WRCase2.DUP_Requestor_ID__c = '123456';
         WRCase2.Approval_Status__C='Pending Approval';
         WRCase2.IT_Assignment__C=u1.id;
         WRCase2.IT_BU_Reviewer__c=u2.id;
         WRCase2.IT_Classification__c='Issue';
         WRCase2.Priority='3-Medium';
         WRCase2.IT_Track__C='Production Fix';
         WRCase2.WRF_Date_CPM_Launched__C=System.today();
         WRCase2.Related_Case_Number__C='12345';
         WRCase2.Origin = 'Savo';
         WRCase2.wrf_requestor__c = '005E0000003cbs5';
        // WRCase2.Compliance_Mgr_Action_Date__c=System.today()-1;
         //insert WRCase2;
         InsrtCseList.add(WRCase2);

         Case WRCase3 = new Case();
         WRCase3.recordTypeId = CRMapByName .get('Support').getRecordTypeId();
         WRCase3.DUP_Acct_ID__c = '78907';
         WRCase3.DUP_Requestor_ID__c = '123456';
         WRCase3.Approval_Status__C='Pending Approval';
         WRCase3.IT_Assignment__C=u1.id;
         WRCase3.IT_BU_Reviewer__c=u2.id;
         WRCase3.IT_Classification__c='Issue';
         WRCase2.Priority='2-High';
         WRCase2.IT_Impact__c='Test Impact';
         WRCase2.IT_Track__C='Sprint';
         WRCase3.WRF_Date_CPM_Launched__C=System.today();
         WRCase3.Related_Case_Number__C='12345';
         WRCase3.Origin = 'Global Support';
         //START S-309660 [Hemant 5/22/2015] - Increase code coverage
         WRCase3.SuppliedEmail = 'test_SuppliedEmail@test.com';
         WRCase3.Status = 'Cancelled';
         //END S-309660 [Hemant 5/22/2015] - Increase code coverage
         //WRCase3.Compliance_Mgr_Action_Date__c=System.today()-1;
         InsrtCseList.add(WRCase3);

         insert InsrtCseList;
         
         
         WRF_Task__c WRFTsk1 = new WRF_Task__C();
         WRFTsk1.RecordTypeId=WRFMapByName.get('WRF Task').getRecordTypeId();
         WRFTsk1.WRF__C=WRCase1.id;
         WRFTsk1.Assigned_To__C=u1.id;
         WRFTsk1.Disposition_Code__C='Bids';
         WRFTsk1.Status__c='New';
         //Insert WRFTsk1;
         InsrtWRFList.add(WRFTsk1);

         WRF_Task__c WRFTsk2 = new WRF_Task__C();
         WRFTsk2.RecordTypeId=WRFMapByName.get('WRF Task').getRecordTypeId();
         WRFTsk2.WRF__C=WRCase2.id;
         WRFTsk2.Assigned_To__C=u1.id;
         WRFTsk2.Disposition_Code__C='Bids';
         WRFTsk2.Status__c='New';
         //Insert WRFTsk2;
         InsrtWRFList.add(WRFTsk2);

         insert InsrtWRFList;
         
         
         WRCase1.Approval_Status__C='Pending Approval';
         WRCase2.Approval_Status__C='Approved';
         //WRCase2.WRCase2.Compliance_Mgr_Action_Date__c=System.today();
         WRCase2.IT_Action_Taken__c='Code Change';
         WRCase2.IT_Assignment__C=u2.id;
         WRCase2.Status='Closed';
         WRCase2.Related_Case_Number__C=WRCase1.CaseNumber;

         WRCase3.Approval_Status__C='Approved';
        // WRCase3.Compliance_Mgr_Action_Date__c=System.today()+1;
         WRCase3.Next_ApproverId__c=u1.id;

         UpdateCseList.add(WRCase1);
         UpdateCseList.add(WRCase2);
         UpdateCseList.add(WRCase3);

         Test.startTest();
         update UpdateCseList;
         Test.stopTest();


         System.debug('================ TEST ENDED============');
        */

    }
  
    //START S-309660 [Hemant 5/22/2015] - Increase code coverage
    static testMethod void SupportCaseManagement_TC1()
    {
/*
         Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];
         List<User> insertuser= new List<User>();
         //Added -t in od employee id by Najma Ateeq for Story #S-377005
         User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='xxyyOD1234',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive=true);
         insertuser.add(u1);
         User u2 = new User(alias = 'test123 ', email='proxy@proxy4567.officedepot.com',OD_Employee_ID__c='xxyyOD6789',emailencodingkey='UTF-8', lastname='test1234',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy457.com',isactive=true);
         insertuser.add(u2);
         insert insertuser;
        system.runAs(u1)
        {
         Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
         Map<String,Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();

         Schema.DescribeSObjectResult AR = Schema.SObjectType.Account;
         Map<String,Schema.RecordTypeInfo> ARMapByName = AR.getRecordTypeInfosByName();

         Schema.DescribeSObjectResult WRF = Schema.SObjectType.WRF_Task__C;
         Map<String,Schema.RecordTypeInfo> WRFMapByName = WRF.getRecordTypeInfosByName();

         List<Sobject> InsrtAccList = new List<Sobject>();
         List<Sobject> InsrtCseList = new List<Sobject>();
         List<Sobject> InsrtWRFList = new List<Sobject>();
         List<Sobject> UpdateCseList = new List<Sobject>();
         System.debug('=========== TEST STARTED==============');
         Account acc = new Account();
         acc.Name='Test Account 1';
         acc.recordTypeId = ARMapByName.get('Customer').getRecordTypeId();
         acc.AOPS_Cust_ID__C='78906';
         //insert acc;
         InsrtAccList.add(acc);

         Task tsk = new Task();
         tsk.subject = 'Test Task';
         tsk.task_type__c = 'IT';
         tsk.Action__C = 'Analysis/Development';
         tsk.ownerId = '005E0000003cbs5' ;
         tsk.Status = 'New';
         tsk.activitydate = system.today();

         insert tsk;

         Account acc1 = new Account();
         acc1.Name='Test Account 1';
         acc1.recordTypeId = ARMapByName.get('Prospect').getRecordTypeId();
         acc1.Oracle_Party_Id__C='78907';
         //insert acc1;
         InsrtAccList.add(acc1);

         Insert  InsrtAccList;

         Case WRCase1 = new Case();
         WRCase1.recordTypeId = CRMapByName .get('Support').getRecordTypeId();
         WRCase1.DUP_Acct_ID__c = '78906';
         WRCase1.DUP_Requestor_ID__c = '123456';
         WRCase1.IT_Classification__c='Issue';
         WRCase1.Origin = 'Salesprism';
         WRCase1.wrf_requestor__c = '005E0000003cbs5';
         WRCase1.Status = 'Cancelled';
         InsrtCseList.add(WRCase1);

         Case WRCase2 = new Case();
         WRCase2.recordTypeId = CRMapByName .get('Support').getRecordTypeId();
         WRCase2.DUP_Acct_ID__c = '78907';
         WRCase2.DUP_Requestor_ID__c = '123456';
         WRCase2.Approval_Status__C='Pending Approval';
         WRCase2.IT_Classification__c='Issue';
         WRCase2.Priority='3-Medium';
         WRCase2.IT_Track__C='Production Fix';
         WRCase2.WRF_Date_CPM_Launched__C=System.today();
         WRCase2.Related_Case_Number__C='12345';
         WRCase2.Origin = 'Savo';
         WRCase2.wrf_requestor__c = '005E0000003cbs5';
         InsrtCseList.add(WRCase2);

         insert InsrtCseList;
         Update InsrtCseList;
            
           
        }
*/
    }
    
    //Connor Flynn S-437498 (00801298)
    static testMethod void SupportCaseManagement_OriginValue()
    {

         Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
         Map<String,Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();

         Schema.DescribeSObjectResult AR = Schema.SObjectType.Account;
         Map<String,Schema.RecordTypeInfo> ARMapByName = AR.getRecordTypeInfosByName();


         List<Sobject> InsrtAccList = new List<Sobject>();
         List<Sobject> InsrtCseList = new List<Sobject>();  

         Account acc1 = new Account();
         acc1.Name='Test Account 1';
         acc1.recordTypeId = ARMapByName.get('Prospect').getRecordTypeId();
         acc1.Oracle_Party_Id__C='78907';
         //insert acc1;
         InsrtAccList.add(acc1);

         Insert  InsrtAccList;
         
         List<Case_Origin_Value__mdt> insertCaseOriginList = new List<Case_Origin_Value__mdt>();
         /*Case_Origin_Value__mdt caseOriginValue1 = new Case_Origin_Value__mdt(CaseTrigger__c = false, RecordType__c = Constants.SUPPORT, Origin_Value__c = 'AppirioTest');
         Case_Origin_Value__mdt caseOriginValue2 = new Case_Origin_Value__mdt(CaseTrigger__c = false, RecordType__c = Constants.SUPPORT, Origin_Value__c = 'AppirioTest2');
         insertCaseOriginList.add(caseOriginValue1);
         insertCaseOriginList.add(caseOriginValue2);
         insert insertCaseOriginList; */

         Case WRCase1 = new Case();
         WRCase1.recordTypeId = CRMapByName.get(Constants.SUPPORT).getRecordTypeId();
         WRCase1.DUP_Acct_ID__c = '78906';
         WRCase1.DUP_Requestor_ID__c = '123456';
         WRCase1.IT_Classification__c='Issue';
         WRCase1.Origin = 'RCOE';
         WRCase1.wrf_requestor__c = '005E0000003cbs5';
         WRCase1.Status = 'Cancelled';
         InsrtCseList.add(WRCase1);

         Case WRCase2 = new Case();
         WRCase2.recordTypeId = CRMapByName .get(CONSTANTS.PARTNER_CASE).getRecordTypeId();
         WRCase2.DUP_Acct_ID__c = '78907';
         WRCase2.DUP_Requestor_ID__c = '123456';
         WRCase2.Approval_Status__C='Pending Approval';
         WRCase2.IT_Classification__c='Issue';
         WRCase2.Priority='3-Medium';
         WRCase2.IT_Track__C='Production Fix';
         WRCase2.WRF_Date_CPM_Launched__C=System.today();
         WRCase2.Related_Case_Number__C='12345';
         WRCase2.Origin = 'Partner Email';
         WRCase2.wrf_requestor__c = '005E0000003cbs5';
         InsrtCseList.add(WRCase2);

         Case WRCase3 = new Case();
         WRCase3.recordTypeId = CRMapByName .get(CONSTANTS.ACCOUNT_MAINTENANCE).getRecordTypeId();
         WRCase3.DUP_Acct_ID__c = '78907';
         WRCase3.DUP_Requestor_ID__c = '123456';
         WRCase3.Approval_Status__C='Pending Approval';
         WRCase3.IT_Classification__c='Issue';
         WRCase3.Priority='3-Medium';
         WRCase3.IT_Track__C='Production Fix';
         WRCase3.WRF_Date_CPM_Launched__C=System.today();
         WRCase3.Related_Case_Number__C='12345';
         WRCase3.Origin = 'General Maint';
         WRCase3.wrf_requestor__c = '005E0000003cbs5';
         InsrtCseList.add(WRCase3);

         Case WRCase4 = new Case();
         WRCase4.recordTypeId = CRMapByName .get(CONSTANTS.ECOMMERCE_FIELD_SUPPORT).getRecordTypeId();
         WRCase4.DUP_Acct_ID__c = '78907';
         WRCase4.DUP_Requestor_ID__c = '123456';
         WRCase4.Approval_Status__C='Pending Approval';
         WRCase4.IT_Classification__c='Issue';
         WRCase4.Priority='3-Medium';
         WRCase4.IT_Track__C='Production Fix';
         WRCase4.WRF_Date_CPM_Launched__C=System.today();
         WRCase4.Related_Case_Number__C='12345';
         WRCase4.Origin = 'eComm Email';
         WRCase4.wrf_requestor__c = '005E0000003cbs5';
         InsrtCseList.add(WRCase4);

         Case WRCase5 = new Case();
         WRCase5.recordTypeId = CRMapByName .get(CONSTANTS.GT_CASES).getRecordTypeId();
         WRCase5.DUP_Acct_ID__c = '78907';
         WRCase5.DUP_Requestor_ID__c = '123456';
         WRCase5.Approval_Status__C='Pending Approval';
         WRCase5.IT_Classification__c='Issue';
         WRCase5.Priority='3-Medium';
         WRCase5.IT_Track__C='Production Fix';
         WRCase5.WRF_Date_CPM_Launched__C=System.today();
         WRCase5.Related_Case_Number__C='12345';
         WRCase5.Origin = 'GT BC';
         WRCase5.wrf_requestor__c = '005E0000003cbs5';
         InsrtCseList.add(WRCase5);


         insert InsrtCseList;
    }
    //Connor Flynn S-437498 (00801298) End

    //END S-309660 [Hemant 5/22/2015] - Increase code coverage
    //START S-377014 by Najma Ateeq
    static testMethod void ITCaseManagement_TC()
    {
         Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
         Map<String,Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();

         Case itCase = new Case();
         if(CRMapByName.containsKey('IT Cases'))
         itCase.recordTypeId = CRMapByName .get('IT Cases').getRecordTypeId();
         itCase.Origin = 'Salesprism';
         itCase.Status = 'New';
         itCase.IT_Assignment__c = UserInfo.getUserId();
         itCase.IT_BU_Reviewer__c = UserInfo.getUserId();

         itCase.IT_Track__c = 'Fast Track';
         itCase.IT_Environment__c = 'Production';
         itCase.IT_Classification__c = 'Enhancement';
         insert itCase;
         
         List<Task> lstTask = [Select Id from Task where WhatId=:itCase.Id];

         //System.assert(lstTask.size() > 0); //task would be created by trigger after insert.

     }
    //End S-377014 by Najma Ateeq

    //START S-377012 by Najma Ateeq
    static testMethod void ITCaseManagement_TC1()
    {
         Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
         Map<String,Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();

         Case itCase = new Case();
         if(CRMapByName.containsKey('IT Cases'))
         itCase.recordTypeId = CRMapByName .get('IT Cases').getRecordTypeId();
         itCase.Origin = 'Salesprism';
         itCase.Status = 'New';
         itCase.IT_Assignment__c = UserInfo.getUserId();
         itCase.IT_BU_Reviewer__c = UserInfo.getUserId();
         itCase.IT_Track__c = 'Sprint';
         itCase.IT_Environment__c = 'Production';
         itCase.IT_Classification__c = 'Enhancement';
         //Added for S-425887[Case#00756096]
         itCase.IT_Production_Date__c = System.today();
         insert itCase;
Test.StartTest();
         itCase.IT_Production_Date__c = System.today().addDays(2);
         update itCase;
         //END S-425887[Case#00756096]

         List<Task> lstTask = [Select Id from Task where WhatId=:itCase.Id];
Test.stopTest();
         //System.assert(lstTask.size() == 0); //No task would be created when Track = 'Sprint'
     }
    //End S-377012 by Najma Ateeq

    //START S-425886[Case#00755567]
    static testMethod void ITCaseManagement_TC2()
    {
         Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
         Map<String,Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();

         Case irCase = new Case();
         if(CRMapByName.containsKey('IT Release'))
         irCase.recordTypeId = CRMapByName .get('IT Release').getRecordTypeId();
         irCase.Origin = 'Salesprism';
         irCase.Status = 'New';
         irCase.Subject = 'Sprint';
         irCase.Priority = '4-Low';
         irCase.Description = 'Production';
         irCase.IT_Production_Date__c = System.today().addDays(2);
         insert irCase;

         Case itCase = new Case();
         if(CRMapByName.containsKey('IT Cases'))
         itCase.recordTypeId = CRMapByName .get('IT Cases').getRecordTypeId();
         itCase.Origin = 'Salesprism';
         itCase.Status = 'New';
         itCase.IT_Assignment__c = UserInfo.getUserId();
         itCase.IT_BU_Reviewer__c = UserInfo.getUserId();
         itCase.IT_Track__c = 'Sprint';
         itCase.IT_Environment__c = 'Production';
         itCase.IT_Classification__c = 'Enhancement';
         itCase.Release_Parent__c = irCase.id;
         itCase.IT_Production_Date__c = System.today().addDays(2);
         insert itCase;

         itCase.Release_Parent__c = null;
         update itCase;

         System.assertnotEquals(0, [Select id from CaseComment where parentid =:irCase.id].size());


     }//END S-425886[Case#00755567]

    //Added by Najma Ateeq for Story #S-377005
    static testMethod void myUnitTest1() {
        Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
        
        //Case#00175758 --START--Hitesh[Aug 09, 2016]
        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        //Case#00175758 --END--Hitesh[Aug 09, 2016]
        
        List<case> cases = new List<case>();
        
        Case cs = new Case();
        cs.recordTypeId = CaseRecType.get('Work Request').getRecordTypeId();
        cs.WRF_Request_Type__c = 'Transition';
        cs.accountId = acc.id;      //Case#00175758 ----Hitesh [Aug, 09, 2016]
        cases.add(cs);

        Case cs1 = new Case();
        cs1.recordTypeId = CaseRecType.get('Work Request').getRecordTypeId();
        cs1.WRF_Request_Type__c = 'Transition';
        cs1.subject = 'Customer RFP Received Disposition Request';
        cs1.accountId = acc.id;     //Case#00175758 ----Hitesh [Aug, 09, 2016]
        //cases.add(cs1);           //Case#00175758 ----Hitesh [Aug, 09, 2016]

        Case cs2 = new Case();
        cs2.recordTypeId = CaseRecType.get('Work Request').getRecordTypeId();
        cs2.WRF_Request_Type__c = 'Transition';
        cs2.subject = 'Extend current OMX Agreement Disposition Request';
        cs2.accountId = acc.id;     //Case#00175758 ----Hitesh [Aug, 10, 2016]
        //cases.add(cs2);
        
        Test.startTest();       //Case#00175758 ----Hitesh [Aug, 09, 2016]
            insert cases;
        Test.stopTest();        //Case#00175758 ----Hitesh [Aug, 09, 2016]
    }
    static testMethod void myUnitTest2()
    {
 
         Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];
         List<User> insertuser= new List<User>();
         User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='xxyyOD123456',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive=true);
         insertuser.add(u1);
         User u2 = new User(alias = 'test123 ', email='proxy@proxy4567.officedepot.com',OD_Employee_ID__c='xxyyOD123457',emailencodingkey='UTF-8', lastname='test1234',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy457.com',isactive=true);
         insertuser.add(u2);
         insert insertuser;

         Schema.DescribeSObjectResult d1 = Schema.SObjectType.Case;
        //Schema.DescribeSObjectResult prcstep = Schema.SObjectType.ProcessInstanceStep ;
         Map<String,Schema.RecordTypeInfo> CaseRecType = d1.getRecordTypeInfosByName();

         List<Case> InsrtCseList = new List<Case>();
         Case WRCase1 = new Case();
         WRCase1.WRF_Source__c='GMILL';

         //WRCase1.WRF_Requestor__c=u1.id;
         WRCase1.recordTypeId = CaseRecType.get('Account Maintenance').getRecordTypeId();
         WRCase1.DUP_Acct_ID__c = '78906';
         WRCase1.DUP_Requestor_ID__c = '123456';
         WRCase1.AM_Assigned_TO__C=u1.id;
         WRCase1.DUP_Acct_Type__c = 'New Prospect';
         WRCase1.WRF_Request_Type__C='Catalog Update';
         //insert WRCase1;
         InsrtCseList.add(WRCase1);

         Case WRCase2 = new Case();
         WRCase2.recordTypeId = CaseRecType.get('Account Maintenance').getRecordTypeId();
         WRCase2.DUP_Acct_ID__c = '78907';
         WRCase2.DUP_Requestor_ID__c = '123456';
     // WRCase2.AM_Assigned_TO__C = null;
         WRCase2.Approval_Status__C='Pending Approval';
         WRCase2.WRF_Date_CPM_Launched__C=System.today();
         WRCase2.Related_Case_Number__C='12345';
         WRCase2.DUP_Acct_Type__c = 'New Prospect';
        // WRCase2.Compliance_Mgr_Action_Date__c=System.today()-1;
         //insert WRCase2;
         InsrtCseList.add(WRCase2);
          test.starttest();
         System.RunAs(u1){

            // insert InsrtCseList;

         }
         WRCase2.Approval_Status__C='Pending Approval';
         WRCase2.recordTypeId = CaseRecType.get('Work Request').getRecordTypeId();
         WRCase1.Approval_Status__C='Pending Approval';
         WRCase1.recordTypeId = CaseRecType.get('Work Request').getRecordTypeId();
         WRCase1.Next_ApproverId__c='Finance';
         InsrtCseList.clear();
         InsrtCseList.add(WRCase1);
         InsrtCseList.add(WRCase2);
         System.RunAs(u1){

        // update InsrtCseList;

         }
         test.stoptest();
       
    }
    static testMethod  void myUnitTest3 ()
    {

        Schema.DescribeSObjectResult d = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        List<Sobject> InsertList = new List<Sobject>();
        test.startTest();

        Case cs = new Case();
        cs.RecordTypeId = rtMapByName.get('Support').getRecordTypeId();
        cs.status = 'Closed';
        //insert cs;
        InsertList.add(cs);

        Task ts = new Task();
        ts.status ='New';
        ts.WhatId= cs.Id;
        InsertList.add(ts);
        insert InsertList;
        //insert ts;

        test.stopTest();

    }
    static testMethod  void myUnitTest4 ()
    {
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        List<QueueSobject> ITQueue = [Select Queue.ID from QueueSobject where Queue.Name='IT Queue' limit 1] ;
        
        //Case#00175758 --START--Hitesh[Aug 09, 2016]
        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        //Case#00175758 --END--Hitesh[Aug 09, 2016]
        Case cs = new Case();

        cs.status = 'New';
        cs.OwnerId = ITQueue.get(0).Queue.ID;
        cs.IT_BU_Reviewer__c = UserInfo.getUserId();
        cs.RecordTypeId = rtMapByName.get('Work Request').getRecordTypeId();
        cs.Approval_Status__c = 'Approved';
        cs.accountId = acc.id;      ////Case#00175758 ----Hitesh[Aug 09, 2016]
        insert cs;
        
        test.startTest();       ////Case#00175758 ----Hitesh[Aug 09, 2016]
        WRF_Task__c t = new WRF_Task__c();
        t.WRF__c = cs.Id;
        t.Disposition_Code__c = 'Bids';
        t.status__c = 'New';
        t.Assignment_Group__c = 'IT';
        insert t;
        test.stopTest();            ////Case#00175758 ----Hitesh[Aug 09, 2016]
        
        Task task1 = new Task();
        task1.whatId = cs.Id;
        task1.ownerId = UserInfo.getUserId();
        task1.Assignment_Group__c = 'IT';
        //task1.Name = 'test';
        task1.status = 'New';
        insert task1;
        
        //cs = [Select Id, Dummy_Age_In_Number__c from Case  where Id=: cs.Id limit 1];
        //system.assertEquals(cs.Dummy_Age_In_Number__c,0);
        
        //START JSCHILLING Case 175803 8/09/2016
        //Moved below update to separate method to fix test class failure
        /*
        cs.Status = 'In Progess';
        cs.Approval_Status__c = 'Pending Approval';
        cs.OwnerId = UserInfo.getUserId();
        update cs;
        */
        //END JSCHILLING Case 175803 8/09/2016
        
        //system.assertEquals(cs.Dummy_Age_In_Number__c,0);
    }
    //START JSCHILLING Case 175803 8/09/2016
    //Added below method to test updating a case, moved from method above
    static testMethod  void myUnitTest4Extension ()
    {
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        List<QueueSobject> ITQueue = [Select Queue.ID from QueueSobject where Queue.Name='IT Queue' limit 1] ;
        
        //Case#00175758 --START--Hitesh[Aug 09, 2016]
        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        //Case#00175758 --END--Hitesh[Aug 09, 2016]
        
        Case cs = new Case();
        cs.status = 'New';
        cs.OwnerId = ITQueue.get(0).Queue.ID;
        cs.IT_BU_Reviewer__c = UserInfo.getUserId();
        cs.RecordTypeId = rtMapByName.get('Work Request').getRecordTypeId();
        cs.Approval_Status__c = 'Approved';
        cs.accountId = acc.id;      ////Case#00175758 ----Hitesh[Aug 09, 2016]
        Test.StartTest();
        insert cs;
        
        cs.Status = 'In Progess';
        cs.Approval_Status__c = 'Pending Approval';
        cs.OwnerId = UserInfo.getUserId();
        update cs;
        Test.StopTest();
    }
    //END JSCHILLING Case 175803 8/09/2016
    static testMethod  void myUnitTest5 ()
    {
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        List<QueueSobject> ITQueue = [Select Queue.ID from QueueSobject where Queue.Name='IT Queue' limit 1] ;
        
        //Case#00175758 --START--Hitesh[Aug 09, 2016]
        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
       
        //Case#00175758 --END--Hitesh[Aug 09, 2016]
        Case cs = new Case();

        cs.status = 'New';
        cs.OwnerId = ITQueue.get(0).Queue.ID;
        cs.IT_BU_Reviewer__c = UserInfo.getUserId();
        cs.RecordTypeId = rtMapByName.get('Work Request').getRecordTypeId();
        cs.accountId = acc.id;      ////Case#00175758 ----Hitesh[Aug 09, 2016]
        insert cs;

        Task task1 = new Task();
        task1.whatId = cs.Id;
        task1.ownerId = UserInfo.getUserId();
        task1.Assignment_Group__c = 'IT';
        //task1.Name = 'test';
        task1.status = 'New';
        insert task1;
        //cs = [Select Id, Dummy_Age_In_Number__c from Case  where Id=: cs.Id limit 1];
        //system.assertEquals(cs.Dummy_Age_In_Number__c,0);
        cs.Status = 'In Progess';
        cs.Approval_Status__c = 'Pending Approval';
        cs.OwnerId = UserInfo.getUserId();
        update cs;
        
    }
    static testMethod  void myUnitTest6 ()
    {
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        List<QueueSobject> ITQueue = [Select Queue.ID from QueueSobject where Queue.Name='IT Queue' limit 1] ;
        
        //Case#00175758 --START--Hitesh[Aug 09, 2016]
        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        //Case#00175758 --END--Hitesh[Aug 09, 2016]
        Case cs = new Case();

        cs.status = 'New';
        cs.OwnerId = ITQueue.get(0).Queue.ID;
        cs.IT_BU_Reviewer__c = UserInfo.getUserId();
        cs.RecordTypeId = rtMapByName.get('Work Request').getRecordTypeId();
        cs.accountId = acc.id;      ////Case#00175758 ----Hitesh[Aug 09, 2016]
        insert cs;

        Task task1 = new Task();
        task1.whatId = cs.Id;
        task1.ownerId = UserInfo.getUserId();
        task1.Assignment_Group__c = 'IT';
        //task1.Name = 'test';
        task1.status = 'New';
        insert task1;
        
        Test.startTest();           ////Case#00175758 ----Hitesh[Aug 09, 2016]
        cs.Approval_Status__c = 'Approved';
        cs.Compliance_Mgr_Action_Date__c = date.today();
        cs.Next_ApproverId__c = Userinfo.getUserId();
        cs.Status = 'Closed';
        cs.OwnerId = ITQueue.get(0).Queue.ID;
        cs.IT_Action_Taken__c  = 'test';
        update cs;
        Test.stopTest();            ////Case#00175758 ----Hitesh[Aug 09, 2016]

    }
    static testMethod  void myUnitTest7 ()
    {
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        List<QueueSobject> ITQueue = [Select Queue.ID from QueueSobject where Queue.Name='IT Queue' limit 1] ;
        
        //Case#00175758 --START--Hitesh[Aug 09, 2016]
        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        //Case#00175758 --END--Hitesh[Aug 09, 2016]
        Case cs = new Case();

        cs.status = 'New';
        cs.OwnerId = ITQueue.get(0).Queue.ID;
        cs.IT_BU_Reviewer__c = UserInfo.getUserId();
        cs.RecordTypeId = rtMapByName.get('Work Request').getRecordTypeId();
        cs.accountId = acc.id;      ////Case#00175758 ----Hitesh[Aug 09, 2016]
        
        insert cs;
cs.Approval_Status__c ='Pending Approval';
        update cs;
        delete cs;
    }
    //End - Added by Najma Ateeq for Story #S-377005

    //Start - Added by Jyoti for Story #S-407215
    static testMethod  void myUnitTest8()
    {
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        List<QueueSobject> ITQueue = [Select Queue.ID from QueueSobject where Queue.Name='IT Queue' limit 1] ;
        
        contact cnt = new contact(LastName = 'New contact', email='test@test123.com');
        insert cnt;
        
        Case cs = new Case();

        cs.status = 'New';
        cs.OwnerId = ITQueue.get(0).Queue.ID;
        cs.IT_BU_Reviewer__c = UserInfo.getUserId();
        cs.RecordTypeId = rtMapByName.get('IT Cases').getRecordTypeId();
        cs.IT_Track__c  = 'Sprint';   
        cs.IT_Status__c = 'Assign';
        insert cs;
        Task tsk = new task();
        tsk.Subject = 'case task';
        tsk.IT_TASK_TYPE__c = 'Design';
        tsk.ActivityDate = date.today();
        tsk.WhatId = cs.id;
        tsk.OwnerId = userinfo.getUserId();//cnt.id;
        
        insert tsk;
        
        system.assertEquals('Not Started', [Select IT_Status__c From case where id =: cs.Id].IT_Status__c);
        cs.OwnerId = UserInfo.getUserId();
        cs.IT_Status__c = null;
        update cs;
        Test.startTest();
        cs.Assign_To__c = 'IT Queue';
        update cs;
        system.assertEquals('Not Started', [Select IT_Status__c From case where id =: cs.Id].IT_Status__c);
        cs.IT_Status__c = 'In ARB';
        update cs;
        cs.IT_Status__c = 'Not Started';
        update cs;
        system.assertEquals('In ARB', [Select IT_Status__c From case where id =: cs.Id].IT_Status__c);
        
        Test.stopTest();
    }
    //End - Added by Jyoti for Story #S-407215
    static testMethod  void myUnitTest9 ()
    {
        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];
         List<User> insertuser= new List<User>();
         User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='xxyyOD123456',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive=true);
         insertuser.add(u1);
        insert insertuser;
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        List<QueueSobject> ITQueue = [Select Queue.ID from QueueSobject where Queue.Name='IT Queue' limit 1] ;
        
        //Case#00175758 --START--Hitesh[Aug 09, 2016]
        Account acc = new Account (name = 'SUN Test Account',AOPS_Seq_ID__c = '123456',AOPS_Cust_Id__c = '123456',Oracle_Party_Id__c = '123456',Billingcountry = 'USA',BillingState = 'UT',BillingStreet = '1040 N 326 W',billingcity = 'Orem');
        insert acc;
        //Case#00175758 --END--Hitesh[Aug 09, 2016]
        Case cs = new Case();

        cs.status = 'New';
        cs.OwnerId = ITQueue.get(0).Queue.ID;
        cs.IT_BU_Reviewer__c = UserInfo.getUserId();
        cs.RecordTypeId = rtMapByName.get('Work Request').getRecordTypeId();
        cs.accountId = acc.id;      ////Case#00175758 ----Hitesh[Aug 09, 2016]
        cs.Approval_Status__c ='Pending Approval'; 
        cs.WRF_Request_Type__c = 'Early Pay Discount Terms Requests';
        insert cs;
        cs.DSM_Action_Date__c = date.today();
        cs.Next_ApproverId__c = insertuser[0].id;
        update cs;
        delete cs;
    }
   
     static testMethod  void myUnitTest10()
    {
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case;
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        List<QueueSobject> ITQueue = [Select Queue.ID from QueueSobject where Queue.Name='IT Queue' limit 1] ;
        
        contact cnt = new contact(LastName = 'New contact', email='test@test123.com');
        insert cnt;
        
       
       
       
       
       
          
       
       
       
        Case cs = new Case();

        cs.status = 'New';
        cs.OwnerId = ITQueue.get(0).Queue.ID;
        cs.IT_BU_Reviewer__c = UserInfo.getUserId();
        cs.RecordTypeId = rtMapByName.get('IT Cases').getRecordTypeId();
     //   cs.IT_Track__c  = 'Sprint';   
        cs.IT_Status__c = 'QA';
        insert cs;
        Task tsk = new task();
        tsk.Subject = 'case task';
        tsk.IT_TASK_TYPE__c = 'UAT';
        tsk.ActivityDate = date.today();
        tsk.WhatId = cs.id;
        tsk.OwnerId = userinfo.getUserId();//cnt.id;
        
        insert tsk;
        
       // system.assertEquals('Not Started', [Select IT_Status__c From case where id =: cs.Id].IT_Status__c);
        Test.startTest();
        Constants.HAS_PROCESSED = false;
        cs.OwnerId = UserInfo.getUserId();
         cs.IT_Status__c = 'In UAT';
        update cs;
        
        test.stopTest();
        
               
         Case cs1= new Case ();
         cs1.OwnerId = UserInfo.getUserId();
         cs1.IT_Status__c = 'In UAT';
         cs1.RecordTypeId = rtMapByName.get('IT Cases').getRecordTypeId();

         cs1.subject='Test';
        cs1.status='Closed';
         cs1.IT_Assignment__c =UserInfo.getUserId();
         cs1.IT_BU_Reviewer__c=UserInfo.getUserId();
         cs1.IT_Track__c='Fast Track';
cs1.WRF_Request_Type__c = 'Early Pay Discount Terms Requests';
cs1.DUP_Requestor_ID__c='000000';
         insert cs1;
        
        List<Case> newSet1= new List<Case>();
        newSet1.add(cs1);
        
        CaseManagement.updRVP(newSet1);

       
       

    }
    
    static testMethod void ITCaseManagement_TC_Else()
    {
         Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
         Map<String,Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();
        
        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];
         List<User> insertuser= new List<User>();
         User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='xxyyOD123456',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive=true);
         insertuser.add(u1);
         insert insertuser;
       
         Case itCase = new Case();
         if(CRMapByName.containsKey('IT Cases'))
         itCase.recordTypeId = CRMapByName .get('IT Cases').getRecordTypeId();
         itCase.Origin = 'Salesprism';
         itCase.Status = 'New';
         itCase.IT_Assignment__c = null;
         itCase.IT_BU_Reviewer__c = UserInfo.getUserId();

         itCase.IT_Track__c = 'Fast Track';
         itCase.IT_Environment__c = 'Production';
         itCase.IT_Classification__c = 'Enhancement';
         itCase.Assign_To__c =u1.id;
         insert itCase;
        
         Case itCase2 = [select id,status from Case where id=:itCase.id];
        itCase2.status = 'Closed';
        update itCase2;
        Set<Id> cList = new Set<Id>();
        cList.add(itCase2.id);
        try {
        CaseManagement.Support_CreateTask(cList);
        }catch(Exception e){}

         //System.assert(lstTask.size() > 0); //task would be created by trigger after insert.
        
     }
    static testMethod void ITCaseManagement_TC_Else1()
     {
           Schema.DescribeSObjectResult CR = Schema.SObjectType.Case;
         Map<String,Schema.RecordTypeInfo> CRMapByName = CR.getRecordTypeInfosByName();

        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];
         List<User> insertuser= new List<User>();
         User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='xxyyOD123456',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive=true);
     
         insert u1;
         u1.Title='VP';
       
         Case itCase = new Case();
         if(CRMapByName.containsKey('Work Request'))
         itCase.recordTypeId = CRMapByName .get('Work Request').getRecordTypeId();
         itCase.Origin = 'Salesprism';
         itCase.Status = 'New';
         itCase.IT_Assignment__c = null;
         itCase.IT_BU_Reviewer__c = UserInfo.getUserId();
         itCase.DUP_Requestor_ID__c='123456';
    
         itCase.IT_Track__c = 'Fast Track';
         itCase.IT_Environment__c = 'Production';
         itCase.IT_Classification__c = 'Enhancement';
         itCase.Assign_To__c =u1.id;
         insert itCase;
        
        // Case itCase2 = [select id,status from Case where id=:itCase.id];
   //     itCase2.status = 'Closed';
        //update itCase2;
           try {
        CaseManagement.updUserHierarchy();
                itCase.DSM__c=u1.id;
        }catch(Exception e){}
         
     }
    
}