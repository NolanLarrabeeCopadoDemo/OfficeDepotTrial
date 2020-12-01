// 
// (c) 2015 Appirio, Inc.
//
// Tier1_Extension Test Class
//
// 10 Feb 2015     Luke Slevin       Original
//
@isTest
private class MDR_BatchTest {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    @isTest static void test_MDRBatch() {
       
        String jobId = System.schedule('MDR 10 Batch',CRON_EXP,new MDR_Batch());
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        
        User u = new User(Alias = 'standt', Email='standarduserODAppirio@officedepot.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduserODAppirio@officedepot.com');

        insert u;

        mdr__c mRec = new mdr__c();
        mRec.name = 'MDR Child';
        mRec.OwnerId = u.id;
        mREc.PID__c = '000002';
        mRec.CMO_ParentPID__c = '000001';
        insert mRec;

        mdr__c mRec2 = new mdr__c();
        mRec2.name = 'MDR CMO Parent';
        mRec2.OwnerId = u.id;
        mREc2.PID__c = '000001';
        mRec2.txtParentPID__c = '000003';
        insert mRec2;
        
        mdr__c mRec3 = new mdr__c();
        mRec3.name = 'MDR Parent';
        mRec3.OwnerId = u.id;
        mREc3.PID__c = '000003';
        insert mRec3;
        
        Test.startTest();
            MDR_Batch tb = new MDR_Batch();
            database.executeBatch(tb);
        Test.stopTest();

    }
}