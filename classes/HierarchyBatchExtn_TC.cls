// 10/17/2016       Jessica Schilling       S-445702        Added method to test Great Grandparents
//
@isTest(SeeAllData=False)
private class HierarchyBatchExtn_TC 
{

  static testMethod void myUnitTest() 
    {
    
       String query=  'select id,hierarchy__c from account_Extension__C where recordtype.developername=\'Customer\'';
        Account acc = new Account ();
        acc.name='Test 1';
        acc.Hierarchy__c='C';
        acc.RecordTypeId='012E00000008dTa';
        acc.AOPS_Cust_Id__c = '010223';
        insert acc;
        
        
        Account acc1 = new Account ();
        acc1.name='Test 1';
        acc1.Hierarchy__c='C';
        acc1.RecordTypeId='012E00000008dTa';
        acc1.AOPS_Cust_Id__c = '123456';
        acc1.ParentId=acc.id;
        insert acc1;
        
        HierarchyBatchExtn Hb = new HierarchyBatchExtn(query);
        HierarchyBatchExtn Hb2 = new HierarchyBatchExtn(''); 
        HierarchyBatchExtn Hb3 = new HierarchyBatchExtn(); 
        
       Test.startTest();
       Database.executeBatch(Hb,100);
       Database.executeBatch(Hb2,100);
       Database.executeBatch(Hb3,100);
       Test.stopTest();
       
      }

  //START JSCHILLING S-445702 10/17/2016
  //OD Story number 00781061 Added test method
  static testMethod void testHierarchy(){
    List<Account> accounts = new List<Account>();

    Account accGG = new Account();
    accGG.Name = 'Account GG';
    accGG.RecordTypeId = '012E00000008dTa';
    accGG.AOPS_Cust_Id__c = '123451';
    accounts.add(accGG);

    Account accGP = new Account();
    accGP.Name = 'Account GP';
    accGP.RecordTypeId = '012E00000008dTa';
    accGP.AOPS_Cust_Id__c = '12342';
    accounts.add(accGP);

    Account accP = new Account();
    accP.Name = 'Account P';
    accP.RecordTypeId = '012E00000008dTa';
    accP.AOPS_Cust_Id__c = '123453';
    accounts.add(accP);

    Account accC = new Account();
    accC.Name = 'Account C';
    accC.RecordTypeId = '012E00000008dTa';
    accC.AOPS_Cust_Id__c = '123454';
    accounts.add(accC);

    insert accounts;

    accGP.ParentId = accGG.Id;
    accP.ParentId = accGP.Id;
    accC.ParentId = accP.Id;

    update accounts;
        
    Test.startTest();
    HierarchyBatchExtn testBatch = new HierarchyBatchExtn(); 
    Database.executeBatch(testBatch,100);

    Test.stopTest();

  
  }

  static testMethod void testSchedule(){
    Test.startTest();
    String CRON_EXP = '0 0 0 15 3 ? 2050';
    String jobId = System.schedule('ScheduleHierarchyBatchTest',CRON_EXP,new HierarchyBatchExtn());

    // Get the information from the CronTrigger API object
    CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

    // Verify the expressions are the same
    System.assertEquals(CRON_EXP, ct.CronExpression);

    // Verify the job has not run
    System.assertEquals(0, ct.TimesTriggered);

    // Verify the next time the job will run
    System.assertEquals('2050-03-15 00:00:00', String.valueOf(ct.NextFireTime));
    Test.stopTest();
  }
  //END JSCHILLING S-445702 10/17/2016
}