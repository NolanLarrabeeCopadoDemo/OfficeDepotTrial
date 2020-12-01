// 10/17/2016       Jessica Schilling       S-445702        Added method to test Great Grandparents
//
@isTest(SeeAllData=False)
private class HierarchyBatch_TC 
{

  static testMethod void myUnitTest() 
    {
    
    
            Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Id GP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();


    
       String query=  'select id,hierarchy__c from account where recordtype.name=\'Customer\'';
        Account acc = new Account ();
        acc.name='Test 1';
        acc.Hierarchy__c='C';
        acc.RecordTypeId=Customer;
        acc.AOPS_Cust_Id__c = '010223';
        insert acc;
        
        
        Account acc1 = new Account ();
        acc1.name='Test 1';
        acc1.Hierarchy__c='C';
        acc1.RecordTypeId=Customer;
        acc1.AOPS_Cust_Id__c = '123456';
        acc1.ParentId=acc.id;
        insert acc1;
        
        HierarchyBatch Hb = new HierarchyBatch(query);
        HierarchyBatch Hb2 = new HierarchyBatch(''); 
        HierarchyBatch Hb3 = new HierarchyBatch(); 
        
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

            Id Customer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Id GP = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();

    Account accGG = new Account();
    accGG.Name = 'Account GG';
    accGG.RecordTypeId = GP;
    accGG.AOPS_Cust_Id__c = '123451';
    accGG.Hierarchy__c='GP';
    accounts.add(accGG);

    Account accGP = new Account();
    accGP.Name = 'Account GP';
    accGP.RecordTypeId = GP;
    accGP.AOPS_Cust_Id__c = '12342';
    accounts.add(accGP);

    Account accP = new Account();
    accP.Name = 'Account P';
    accP.RecordTypeId = Customer ;
    accP.AOPS_Cust_Id__c = '123453';
    accounts.add(accP);

    Account accC = new Account();
    accC.Name = 'Account C';
    accC.RecordTypeId = Customer ;
    accC.AOPS_Cust_Id__c = '123454';
    accounts.add(accC);

    insert accounts;

    accGP.ParentId = accGG.Id;
    accP.ParentId = accGP.Id;
    accC.ParentId = accP.Id;

    update accounts;
        
    Test.startTest();
    HierarchyBatch testBatch = new HierarchyBatch(); 
    Database.executeBatch(testBatch,100);

    Test.stopTest();

    Map<Id, Account> testAccountMap = new Map<Id, Account>([Select Id, Hierarchy__c From Account Where Id in : accounts]);

    //System.assertEquals('GG', testAccountMap.get(accGG.Id).Hierarchy__c);
    //System.assertEquals('GP', testAccountMap.get(accGP.Id).Hierarchy__c);
    //System.assertEquals('P', testAccountMap.get(accP.Id).Hierarchy__c);
    //System.assertEquals('C', testAccountMap.get(accC.Id).Hierarchy__c);
  }

  static testMethod void testSchedule(){
    Test.startTest();
    String CRON_EXP = '0 0 0 15 3 ? 2050';
    String jobId = System.schedule('ScheduleHierarchyBatchTest',CRON_EXP,new HierarchyBatch());

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