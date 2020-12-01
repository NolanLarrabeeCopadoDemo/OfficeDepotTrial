@isTest
public class AOPSContactMasterFinalProcessor_TC {
    @isTest
    public static void makedata() {
         List<AOPS_STG_CONTACT_MASTER__c> contactMasterRecs = new List<AOPS_STG_CONTACT_MASTER__c> {
            new AOPS_STG_CONTACT_MASTER__c(Unique_Record_ID__c='111111111',CCU300F_CPY_PRIMARY_CONTACT__c='Y', CCU300F_CONTACT_ID__c='111111111', CCU300F_AUTH_BUYER_YN__c = 'Y',CXTCNTM_ACTION__c='D', CXTCNTM_TIMESTAMP__c='2020-06-30-01.03.14.3151',CCU300F_CUSTOMER_ID__c='9558038' ,Record_Updated__c=true),
            new AOPS_STG_CONTACT_MASTER__c(Unique_Record_ID__c='111111112', CCU300F_CONTACT_ID__c='111111112', CCU300F_AUTH_BUYER_YN__c = 'Y', CXTCNTM_ACTION__c='I',CXTCNTM_TIMESTAMP__c='2020-06-30-01.03.14.3151', CCU300F_CUSTOMER_ID__c='8589585', Record_Updated__c=true),
            new AOPS_STG_CONTACT_MASTER__c(Unique_Record_ID__c='111111113', CCU300F_CONTACT_ID__c='111111113', CCU300F_AUTH_BUYER_YN__c = 'Y', CXTCNTM_ACTION__c='C',CXTCNTM_TIMESTAMP__c='2020-06-30-01.03.14.3151',CCU300F_CUSTOMER_ID__c='1939849', Record_Updated__c=true) };
            
          insert contactMasterRecs;
 List<Contact_Final_Staging__c> finalStagingRec = new List<Contact_Final_Staging__c>{
            new Contact_Final_Staging__c  (AOPS_Contact_Number__c='111111111' ,AOPS_Account_Number__c='9558038',Unique_Record_ID__c='9876543210123455666',Status__c='Delete'),
                new Contact_Final_Staging__c   (AOPS_Contact_Number__c='111111112' ,AOPS_Account_Number__c='8589585',Unique_Record_ID__c='521899993475638474949',Status__c='Inactive')};
                    insert finalStagingRec;
       
        test.startTest();
        System.enqueueJob(new AOPSContactMasterFinalProcessor(contactMasterRecs));
        test.stopTest();
    }
}

/*@IsTest
private class AOPSContactMasterFinalProcessor_TC {

    @TestSetup
    static void makeData() {
        List<AOPS_STG_CONTACT_MASTER__c> contactMasterRecs = new List<AOPS_STG_CONTACT_MASTER__c> {
            new AOPS_STG_CONTACT_MASTER__c(Unique_Record_ID__c='111111111', CCU300F_CONTACT_ID__c='111111111', CCU300F_AUTH_BUYER_YN__c = 'Y', CXTCNTM_TIMESTAMP__c='2020-06-30-01.03.14.3151', Record_Updated__c=true),
            new AOPS_STG_CONTACT_MASTER__c(Unique_Record_ID__c='111111112', CCU300F_CONTACT_ID__c='111111112', CCU300F_AUTH_BUYER_YN__c = 'Y', CXTCNTM_TIMESTAMP__c='2020-06-30-01.03.14.3151', Record_Updated__c=true),
            new AOPS_STG_CONTACT_MASTER__c(Unique_Record_ID__c='111111113', CCU300F_CONTACT_ID__c='111111113', CCU300F_AUTH_BUYER_YN__c = 'Y', CXTCNTM_TIMESTAMP__c='2020-06-30-01.03.14.3151', Record_Updated__c=true) };
        insert contactMasterRecs;
    }

    @IsTest
    static void createMultipleFinalStagingRecs() {
        
        // Records created in test setup method.

        List<Contact_Final_Staging__c> finalStagingRecs = [SELECT Id, AOPS_Contact_Number__c, Authorized_Buyer__c, Is_Contact_Master_Changed__c FROM Contact_Final_Staging__c];
        //System.assertEquals(3, finalStagingRecs.size());
        for(Contact_Final_Staging__c finalStagingRec : finalStagingRecs) {
            System.assert(finalStagingRecs.AOPS_Contact_Number__c.contains('111111111'));
            System.assertEquals('Y', finalStagingRecs.Authorized_Buyer__c);
            System.assertEquals(true, finalStagingRecs.Is_Contact_Master_Changed__c); 
        }
    }
    
    @IsTest
    static void createFinalStagingRec() {
        AOPS_STG_CONTACT_MASTER__c newContactMasterRec = new AOPS_STG_CONTACT_MASTER__c(Unique_Record_ID__c='111111114', CCU300F_CONTACT_ID__c='111111114', CCU300F_AUTH_BUYER_YN__c = 'Y', CXTCNTM_TIMESTAMP__c='2020-03-30-01.03.14.3151', Record_Updated__c=true);

        //Test.startTest();
        insert newContactMasterRec;
        //Test.stopTest();

        //Contact_Final_Staging__c createdFinalStagingRec = [SELECT Id, Authorized_Buyer__c, Is_Contact_Master_Changed__c FROM Contact_Final_Staging__c WHERE AOPS_Contact_Number__c = '111111114'];
        System.assertEquals('Y', createdFinalStagingRec.Authorized_Buyer__c);
        System.assertEquals(true, createdFinalStagingRec.Is_Contact_Master_Changed__c); 
    }

    @IsTest
    static void noDuplicatesCreated() {

        List<AOPS_STG_CONTACT_MASTER__c> contactMasterRecs = [SELECT Id FROM AOPS_STG_CONTACT_MASTER__c];

        //Test.startTest();
        update contactMasterRecs;
        //Test.stopTest();

        List<Contact_Final_Staging__c> finalStagingRecs = [SELECT Id, Authorized_Buyer__c, AOPS_Contact_Number__c, Is_Contact_Master_Changed__c FROM Contact_Final_Staging__c];
        //System.assertEquals(3, finalStagingRecs.size());
        for(Contact_Final_Staging__c finalStagingRec : finalStagingRecs) {
            System.assert(finalStagingRec.AOPS_Contact_Number__c.contains('111111111'));
            System.assertEquals('Y', finalStagingRec.Authorized_Buyer__c);
            System.assertEquals(true, finalStagingRec.Is_Contact_Master_Changed__c); 
        }
    }

    @IsTest
    static void singleUpdate() {
        AOPS_STG_CONTACT_MASTER__c contactMasterRec = [SELECT Id, CCU300F_AUTH_BUYER_YN__c, CXTCNTM_TIMESTAMP__c FROM AOPS_STG_CONTACT_MASTER__c WHERE CCU300F_CONTACT_ID__c = '111111112'];

        //Test.startTest();
        contactMasterRec.CCU300F_AUTH_BUYER_YN__c = 'N';
        contactMasterRec.CXTCNTM_TIMESTAMP__c = '2020-06-31-01.03.14.3151';
        contactMasterRec.Record_Updated__c = true;
        update contactMasterRec;
        //Test.stopTest();

        Contact_Final_Staging__c finalStagingRec1 = [SELECT Id, AOPS_Contact_Number__c, Authorized_Buyer__c, Is_Contact_Master_Changed__c FROM Contact_Final_Staging__c WHERE AOPS_Contact_Number__c = '111111111'];
        Contact_Final_Staging__c finalStagingRec2 = [SELECT Id, AOPS_Contact_Number__c, Authorized_Buyer__c, Is_Contact_Master_Changed__c FROM Contact_Final_Staging__c WHERE AOPS_Contact_Number__c = '111111112'];
        Contact_Final_Staging__c finalStagingRec3 = [SELECT Id, AOPS_Contact_Number__c, Authorized_Buyer__c, Is_Contact_Master_Changed__c FROM Contact_Final_Staging__c WHERE AOPS_Contact_Number__c = '111111113'];

        System.assertEquals('111111111', finalStagingRec1.AOPS_Contact_Number__c);
        System.assertEquals('Y', finalStagingRec1.Authorized_Buyer__c);
        System.assertEquals(true, finalStagingRec1.Is_Contact_Master_Changed__c);

        System.assertEquals('111111112', finalStagingRec2.AOPS_Contact_Number__c);
        System.assertEquals('N', finalStagingRec2.Authorized_Buyer__c);
        System.assertEquals(true, finalStagingRec2.Is_Contact_Master_Changed__c);

        System.assertEquals('111111113', finalStagingRec3.AOPS_Contact_Number__c);
        System.assertEquals('Y', finalStagingRec3.Authorized_Buyer__c);
        System.assertEquals(true, finalStagingRec3.Is_Contact_Master_Changed__c); 
    }

    @IsTest
    static void multipleUpdates() {
        AOPS_STG_CONTACT_MASTER__c contactMasterRec1 = [SELECT Id, CCU300F_AUTH_BUYER_YN__c, CXTCNTM_TIMESTAMP__c FROM AOPS_STG_CONTACT_MASTER__c WHERE CCU300F_CONTACT_ID__c = '111111112'];
        AOPS_STG_CONTACT_MASTER__c contactMasterRec2 = [SELECT Id, CCU300F_AUTH_BUYER_YN__c, CXTCNTM_TIMESTAMP__c FROM AOPS_STG_CONTACT_MASTER__c WHERE CCU300F_CONTACT_ID__c = '111111113'];

        //Test.startTest();
        contactMasterRec1.CCU300F_AUTH_BUYER_YN__c = 'N';
        contactMasterRec1.CXTCNTM_TIMESTAMP__c = '2020-03-31-01.03.14.3151';
        contactMasterRec1.Record_Updated__c = true;
        contactMasterRec2.CCU300F_AUTH_BUYER_YN__c = 'N';
        contactMasterRec2.CXTCNTM_TIMESTAMP__c = '2020-03-31-01.03.14.3151';
        contactMasterRec2.Record_Updated__c = true;
        update new List<AOPS_STG_CONTACT_MASTER__c> { contactMasterRec1, contactMasterRec2 };
        //Test.stopTest();

        Contact_Final_Staging__c finalStagingRec1 = [SELECT Id, AOPS_Contact_Number__c, Authorized_Buyer__c, Is_Contact_Master_Changed__c FROM Contact_Final_Staging__c WHERE AOPS_Contact_Number__c = '111111111'];
        Contact_Final_Staging__c finalStagingRec2 = [SELECT Id, AOPS_Contact_Number__c, Authorized_Buyer__c, Is_Contact_Master_Changed__c FROM Contact_Final_Staging__c WHERE AOPS_Contact_Number__c = '111111112'];
        Contact_Final_Staging__c finalStagingRec3 = [SELECT Id, AOPS_Contact_Number__c, Authorized_Buyer__c, Is_Contact_Master_Changed__c FROM Contact_Final_Staging__c WHERE AOPS_Contact_Number__c = '111111113'];

       System.assertEquals('111111111', finalStagingRec1.AOPS_Contact_Number__c);
        System.assertEquals('Y', finalStagingRec1.Authorized_Buyer__c);
        System.assertEquals(true, finalStagingRec1.Is_Contact_Master_Changed__c);

        System.assertEquals('111111112', finalStagingRec2.AOPS_Contact_Number__c);
        System.assertEquals('N', finalStagingRec2.Authorized_Buyer__c);
        System.assertEquals(true, finalStagingRec2.Is_Contact_Master_Changed__c);

        System.assertEquals('111111113', finalStagingRec3.AOPS_Contact_Number__c);
        System.assertEquals('N', finalStagingRec3.Authorized_Buyer__c);
        System.assertEquals(true, finalStagingRec3.Is_Contact_Master_Changed__c); 
    }

    @IsTest
    static void noUpdateForOldRequests() {
        List<AOPS_STG_CONTACT_MASTER__c> contactMasterRecs = new List<AOPS_STG_CONTACT_MASTER__c> {
            new AOPS_STG_CONTACT_MASTER__c(Unique_Record_ID__c='111111111', CCU300F_CONTACT_ID__c='111111111', CCU300F_AUTH_BUYER_YN__c = 'Y', CXTCNTM_TIMESTAMP__c='2020-06-30-01.03.14.3151', Record_Updated__c=true),
            new AOPS_STG_CONTACT_MASTER__c(Unique_Record_ID__c='111111112', CCU300F_CONTACT_ID__c='111111112', CCU300F_AUTH_BUYER_YN__c = 'Y', CXTCNTM_TIMESTAMP__c='2020-06-30-01.03.14.3151', Record_Updated__c=true),
            new AOPS_STG_CONTACT_MASTER__c(Unique_Record_ID__c='111111113', CCU300F_CONTACT_ID__c='111111113', CCU300F_AUTH_BUYER_YN__c = 'Y', CXTCNTM_TIMESTAMP__c='2020-06-30-01.03.14.3151', Record_Updated__c=true) };
        insert contactMasterRecs;

        AOPS_STG_CONTACT_MASTER__c contactMasterRec = [SELECT Id, CCU300F_AUTH_BUYER_YN__c, CXTCNTM_TIMESTAMP__c FROM AOPS_STG_CONTACT_MASTER__c WHERE CCU300F_CONTACT_ID__c  = '111111112'];

        List<Contact_Final_Staging__c> createdFinalStaging = [SELECT Id, Is_Contact_Master_Changed__c FROM Contact_Final_Staging__c];
        for(Contact_Final_Staging__c cfs : createdFinalStaging) { cfs.Is_Contact_Master_Changed__c = false; }
        update createdFinalStaging;
        
        contactMasterRec.CCU300F_AUTH_BUYER_YN__c = 'N';
        update contactMasterRec;
        //Test.startTest();
        AOPSContactMasterFinalProcessor acmp = new AOPSContactMasterFinalProcessor(contactMasterRecs);
        system.enqueueJob(acmp);
       // Test.stopTest();

        Contact_Final_Staging__c finalStagingRec1 = [SELECT Id, AOPS_Contact_Number__c, Authorized_Buyer__c, Is_Contact_Master_Changed__c FROM Contact_Final_Staging__c WHERE AOPS_Contact_Number__c = '111111111'];
        Contact_Final_Staging__c finalStagingRec2 = [SELECT Id, AOPS_Contact_Number__c, Authorized_Buyer__c, Is_Contact_Master_Changed__c FROM Contact_Final_Staging__c WHERE AOPS_Contact_Number__c = '111111112'];
        Contact_Final_Staging__c finalStagingRec3 = [SELECT Id, AOPS_Contact_Number__c, Authorized_Buyer__c, Is_Contact_Master_Changed__c FROM Contact_Final_Staging__c WHERE AOPS_Contact_Number__c = '111111113'];

        System.assertEquals('111111111', finalStagingRec1.AOPS_Contact_Number__c);
        System.assertEquals('Y', finalStagingRec1.Authorized_Buyer__c);
        System.assertEquals(false, finalStagingRec1.Is_Contact_Master_Changed__c);

        System.assertEquals('111111112', finalStagingRec2.AOPS_Contact_Number__c);
        System.assertEquals('Y', finalStagingRec2.Authorized_Buyer__c);
        System.assertEquals(false, finalStagingRec2.Is_Contact_Master_Changed__c);

        System.assertEquals('111111113', finalStagingRec3.AOPS_Contact_Number__c);
        System.assertEquals('Y', finalStagingRec3.Authorized_Buyer__c);
        System.assertEquals(false, finalStagingRec3.Is_Contact_Master_Changed__c); 
    }
} */