/*
-- +======================================================================================+
-- |                       Office Depot                                                   |
-- +======================================================================================+
-- | Name             : Test_TaskEvents                                                   |
-- |                                                                                      |
-- | Description      : To test TaskEvents trigger                                        |
   |                                                                                      |
-- |                                                                                      |
-- |Change History:                                                                       |
-- |---------------                                                                       |
-- |                                                                                      |
-- |Version  Date          Author           Remarks                                       |
-- |-------  -----------   ---------------  ----------------------------------------------|
-- |1        14-Sep-2011   Akash (Appirio)  Initial Version                               |
-- |1.1      02-Dec-2011   Kishore Jena     Added Price Escltn. email logic               |
-- |1.2      01-Jun-2012   Ankur Pradhan    Deleted total tasks and closed tasks for cases|
-- +======================================================================================+
*/

@isTest
private class Test_TaskEvents {
  //Task Type is null and Call Disposition is null,Disposition code and Task Type shuld be set to Email
  @isTest
  private static void Test_TaskTypeSetToEmailDisposition() {
    Task task = Test_Utils.GenerateBasicTask();
    insert task;
    task = [SELECT Disposition_Code__c,Call_Disposition__c,Task_Type__c FROM task WHERE Id = :task.Id];
    
    //Assert the Task Disposition Code and Task Type should be set to Email
    //System.assertEquals(task.Disposition_Code__c,'Email');
    //System.assertEquals(task.Task_Type__c,'Email');    
    
    /************************************************************************************************************
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    DELETED THIS PEACE OF CODE AS WRF_TASK__C IS USED INSTEAD OF THE TASK OBJECT FOR THIS FUNCTIONALITY
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // Update task type and status so that it will update totaltask and total
    // completed task on related case object
    task.Task_Type__c = 'Other';
    task.Status = 'Completed';
    update task;
    
    // Create a Case and associate it with task
    Case caseForTask = Test_Utils.createCase();    
    task.WhatId = caseForTask.Id;
    update task;
    
    // Test that TotalTask and TotalCompletedTask is being updated
    Case caseToValidate = [Select Id, Total_Tasks__c, Total_Completed_Tasks__c From Case Where Id = :caseForTask.Id];
    //System.assertEquals(caseToValidate.Total_Tasks__c, 1);
    //System.assertEquals(caseToValidate.Total_Completed_Tasks__c, 1);
    ************************************************************************************************************/      
  } 
  
  @isTest
  private static void Test_UpdateAccountCadenceCallDate() {
    
    //Since the Life Style stage 'SOW' is coded in trigger, need to ensure, it exists in db        
    List<Cadence__c> lstCadence = [select Lifecycle_Stage__c, Cadence__c from Cadence__c where Lifecycle_Stage__c = 'SOW'];
    //System.assertEquals(lstCadence.size(),1);
    
    Cadence__c candence1 = new Cadence__c(Name = 'teststage',Cadence__c = 0, Lifecycle_Stage__c = 'teststage');
    insert candence1; 
    
    //Making cadence list used to verify Cadence_Call_Date__c         
    List<Cadence__c> lstCandence = [select Lifecycle_Stage__c, Cadence__c from Cadence__c where Lifecycle_Stage__c = 'SOW'];
    if(lstCandence.size() == 0) {
      Cadence__c candence2 = new Cadence__c(Name = 'teststage',Cadence__c = 0, Lifecycle_Stage__c = 'SOW');
      insert candence2;        
    }
    
    Account relatedAccount =  Test_Utils.CreateAccount('Prospect');
    insert relatedAccount;
    
    Account account =  Test_Utils.CreateAccountForRelatedAccount(relatedAccount.Id);
    insert account;
    
    Contact cont = Test_Utils.CreateContact(relatedAccount.Id);
    
    account.Site_Primary_Contact__c = cont.Id;
    account.Site_Contact2__c = cont.Id;
    account.Site_Contact3__c = cont.Id;
    account.Site_Contact4__c = cont.Id;
    account.Site_Contact5__c = cont.Id;
    account.Site_Contact6__c = cont.Id;
   
    update account;
    Task task = Test_Utils.CreateSalesDispositionTask(account.id);
   
    Test.startTest(); 
    Account acc = [select Cadence_Call_Date__c, Site_Contact3__c,Site_Primary_Contact__c, Site_Contact2__c from Account where id = :account.id ];
    Date tempDate = System.today();
    if(acc.Site_Contact2__c != null){
      //System.assertEquals(acc.Cadence_Call_Date__c,tempDate.addDays((lstCandence[0].Cadence__c).intValue()));
    }
    if(acc.Site_Primary_Contact__c != null){
     // System.assertEquals(acc.Cadence_Call_Date__c,tempDate.addDays((lstCandence[0].Cadence__c).intValue()));
    }
    if(acc.Site_Contact3__c != null){
      //System.assertEquals(acc.Cadence_Call_Date__c,tempDate.addDays((lstCandence[0].Cadence__c).intValue()));
    }
    
    //Update Task for price escalation changes
    task.Call_Disposition__c = 'Pricing Maintenance';
    task.Disposition_Code__c = 'Pricing escalation';
    update task;
    
    Test.stopTest();    
  }
  
  // Test that Cadence_Call_Date__c is properly being updated for site account
  @isTest
  private static void Test_CadenceCallDate() {      
    Account prospectAccount = Test_Utils.CreateAccount();    
    Account siteAccount =  Test_Utils.CreateAccount('Site');
    siteAccount.Related_Account__c = prospectAccount.id;
    insert siteAccount;
        
    Contact cont = Test_Utils.CreateContact(prospectAccount.Id);
    Cadence__c cadence = Test_Utils.createCadence();
    
    siteAccount.Site_Primary_Contact__c = cont.Id;
    siteAccount.Site_Contact2__c = cont.Id;
    siteAccount.Site_Contact3__c = cont.Id;
    siteAccount.Site_Contact4__c = cont.Id;
    siteAccount.Site_Contact5__c = cont.Id;
    siteAccount.Site_Contact6__c = cont.Id;
    siteAccount.Stage__c = 'New';   
    update siteAccount;
    Test_TaskEvents taskEvent = new Test_TaskEvents();
    List<Account> siteAccountList = taskEvent.getSiteAccountList(prospectAccount, cont); 
    insert siteAccountList;
    
    Test.startTest();
    Task task = Test_Utils.CreateSalesDispositionTask(siteAccount.id);
    Date tempDate = System.today();
    tempDate = tempDate.addDays(cadence.Cadence__c.intValue());
    
    // Test that Cadence_Call_Date__c is set on site account
    List<Account> accountListToTestCadenceDate = [Select Cadence_Call_Date__c, Id From Account Where Id IN :siteAccountList];    
    //System.assertEquals(accountListToTestCadenceDate[0].Cadence_Call_Date__c, tempDate);
    //System.assertEquals(accountListToTestCadenceDate[1].Cadence_Call_Date__c, tempDate);
    //System.assertEquals(accountListToTestCadenceDate[2].Cadence_Call_Date__c, tempDate);
    //System.assertEquals(accountListToTestCadenceDate[3].Cadence_Call_Date__c, tempDate);
    //System.assertEquals(accountListToTestCadenceDate[4].Cadence_Call_Date__c, tempDate);
    //System.assertEquals(accountListToTestCadenceDate[5].Cadence_Call_Date__c, tempDate);
    Test.stopTest(); 
  }
  
  // Create site accounts with 6 contact fields
  private List<Account> getSiteAccountList(Account prospectAccount, Contact cont){ 
    List<Account> siteAccountList = new List<Account>();   
    Account siteAccount1 = Test_Utils.CreateAccount('Site');
    siteAccount1.Related_Account__c = prospectAccount.Id;
    siteAccount1.Site_Contact2__c = cont.Id;
    siteAccountList.add(siteAccount1);
    
    Account siteAccount2 = Test_Utils.CreateAccount('Site');
    siteAccount2.Related_Account__c = prospectAccount.Id;
    siteAccount2.Site_Contact3__c = cont.Id;
    siteAccountList.add(siteAccount2);
    
    Account siteAccount3 = Test_Utils.CreateAccount('Site');
    siteAccount3.Related_Account__c = prospectAccount.Id;
    siteAccount3.Site_Contact4__c = cont.Id;
    siteAccountList.add(siteAccount3);
    
    Account siteAccount4 = Test_Utils.CreateAccount('Site');
    siteAccount4.Related_Account__c = prospectAccount.Id;
    siteAccount4.Site_Contact5__c = cont.Id;
    siteAccountList.add(siteAccount4);
    
    Account siteAccount5 = Test_Utils.CreateAccount('Site');
    siteAccount5.Related_Account__c = prospectAccount.Id;
    siteAccount5.Site_Contact6__c = cont.Id;
    siteAccountList.add(siteAccount5);
    
    Account siteAccount6 =  Test_Utils.CreateAccount('Site');
    siteAccount6.Related_Account__c = prospectAccount.id;
    siteAccount6.Site_Primary_Contact__c = cont.Id;
    siteAccountList.add(siteAccount6);
    return siteAccountList;
  }

private static testMethod void Test_TaskEvents()
    {

        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='456218',emailencodingkey='UTF-8', lastname='Anand',FirstName='Guha',languagelocalekey='en_US',localesidkey='en_US', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive=true, Region__c='M',Market__c='M');
        insert u1; 
        system.runAs(u1){

        Schema.DescribeSobjectResult r = Schema.SobjectType.Task;
        Map<String,schema.RecordtypeInfo> TskRecType = r.getRecordTypeInfosByName();
        Id supTskRecTypeid = TskRecType.get('Support Task').getRecordTypeId();

        Schema.DescribeSobjectResult cr = Schema.SobjectType.Case;
        Map<String,schema.RecordtypeInfo> CseRecType = cr.getRecordTypeInfosByName();
        Id ItCaseRecTypeid = CseRecType.get('IT Cases').getRecordTypeId();



        List<Task> list_tasks = new List<Task>();

        Case cse = new Case();
        cse.Subject='Test Case';
        cse.Description='Description';
        cse.status='New';
        cse.Origin='Email';
        cse.RecordTypeId=ItCaseRecTypeid;
        cse.IT_BU_Reviewer__c = u1.id;
        cse.IT_Assignment__c = u1.id;
        cse.IT_Track__c='Fast Track';
        insert cse;
        Test.startTest();
        Task t = new Task();
        t.RecordTypeId = supTskRecTypeid ;
        t.whatId = cse.id;
        t.status='Completed';
        t.ActivityDate=System.today();
        t.subject='Test';
        t.outcome__c = 'Validate(Business)';
        t.ownerid = u1.id;
        t.description = 'description of this particular task is supposed to contain more than 3500 characters... but am not sure if this will help';
        list_tasks.add(t);


        Task t1 = new Task();
        t1.RecordTypeId = supTskRecTypeid ;
        t1.whatId = cse.id;
        t1.status='New';
        t1.subject='Test';
        t1.ActivityDate=System.today();
        t1.outcome__c = 'Approved';
        t1.Ownerid= u1.id;
        list_tasks.add(t1);

        insert list_tasks;
        list_tasks.clear();
        t1.status='Completed';
        t1.ownerid = u1.id;
        t1.Actual_LOE__c=5;
        update t1;

        Test.stopTest();
        }
    }
 
  
}