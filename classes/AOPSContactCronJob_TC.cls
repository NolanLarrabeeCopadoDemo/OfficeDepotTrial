@IsTest
public class AOPSContactCronJob_TC {

    @IsTest
    static void launchesJob() {
        AOPS_STG_CONTACT_MASTER__c masterRec = new AOPS_STG_CONTACT_MASTER__c(Unique_Record_ID__c='11111111', CCU300F_CONTACT_ID__c='11111111', Record_Updated__c=true);
        insert masterRec;
        AOPS_STG_CONTACT_MASTER__c cm = new AOPS_STG_CONTACT_MASTER__c(Unique_Record_ID__c='66666666', CCU300F_CONTACT_ID__c='66666666', CXTCNTM_TIMESTAMP__c='2020-07-17-09.24.19.799200', Number_Of_Attempts__c = null, Sync_Status_Message__c = null,  Record_Updated__c=false);
        insert cm;
        AOPS_Contact_Email__c ce = new AOPS_Contact_Email__c(Unique_Record_ID__c='22222222', CCU340F_CONTACT_ID__c='22222222', CXTCNTE_AOPS_KEY1__c='22222222', Record_Updated__c=true);
        insert ce;
        AOPS_CONTACT_PHONE__c cp = new AOPS_CONTACT_PHONE__c(Unique_Record_ID__c='33333333', CCU320F_CONTACT_ID__c='33333333', CCU320F_CUSTOMER_ID__c='12345678', Record_Updated__c=true);
        insert cp;
        AOPS_Contact_Web_User__c cwu = new AOPS_Contact_Web_User__c(Unique_Record_ID__c='44444444', CCU330F_CONTACT_ID__c='44444444',CCU330F_CUSTOMER_ID__c='12345677', Record_Updated__c=true);
        insert cwu;
        AOPS_Contact_Ship_Address__c csa = new AOPS_Contact_Ship_Address__c(Unique_Record_ID__c='44444444', CCU310F_CONTACT_ID__c='44444444',CCU310F_CUSTOMER_ID__c='12345666', Record_Updated__c=true);
        insert csa;
        AOPS_CONTACT_OPT_IN__c coi = new AOPS_CONTACT_OPT_IN__c(Unique_Record_ID__c='55555555', CCU380F_CONTACT_ID__c='55555555',CCU380F_CUSTOMER_ID__c='12345555', Record_Updated__c=true);
        insert coi;
        Test.startTest();
        AOPSContactCronJob cron = new AOPSContactCronJob();
        cron.run();

        List<AsyncApexJob> jobs = [SELECT Id FROM AsyncApexJob
            WHERE ApexClass.Name = 'AOPSContactFullProcessor' AND Status IN ('Holding', 'Queued', 'Preparing', 'Processing')];
        Test.stopTest();
            
        System.assertEquals(1, jobs.size());
    }
}