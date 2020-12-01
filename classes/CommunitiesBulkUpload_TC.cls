@isTest
global class CommunitiesBulkUpload_TC {
    static testMethod void unitTest() {
        Account acct = new Account ();
        acct.name = 'SUN Test Account';
        acct.BillingStreet = '1040 N 326 W';
        acct.billingcity = 'Orem';
        acct.BillingState = 'UT';
        acct.Billingcountry = 'USA';
        acct.Oracle_Party_Id__c = '1234563456';
        acct.Oracle_Party_Site_Id__c = '1234563456';
        acct.AOPS_Cust_Id__c = '123456';
        acct.AOPS_Seq_ID__c = '127456';
        insert acct;
        
        GPO_Category__c cat = new GPO_Category__c(AOPS_Number__c = '123456', Company_Name__c = 'name1', Private__c = false);
        GPO_Template__c temp1 = new GPO_Template__c(Name = 'Communities v2');
        GPO_Group__c defGrp = new GPO_Group__c(Community_Name__c = 'Default Group', Welcome_Title__c = 'test');
        insert defGrp;
        insert cat;
        insert temp1;
        
        GPO_Group_Detail__c dtl = new GPO_Group_Detail__c(Name = 'Standard Message 3', Type__c = 'Greeting Message', GPO_Group__c = defGrp.id);
        insert dtl;
        
        Test.startTest();
        
        SchedulableContext sc = null;
        CommunitiesBulkUpload testRun = new CommunitiesBulkUpload();
        testRun.execute(sc);
        Database.executeBatch(testRun,20);
        
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        String jobId = System.schedule('testBasicScheduledApex',CRON_EXP ,new CommunitiesBulkUpload());
        //Database.BatchableContext bc = new Database.BatchableContext();
        
        Test.stopTest();
    }
}