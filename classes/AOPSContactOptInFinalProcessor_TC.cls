@IsTest
public class AOPSContactOptInFinalProcessor_TC {
    @isTest
    public static void makedata() {
         List<AOPS_CONTACT_OPT_IN__c> contactMasterRecs = new List<AOPS_CONTACT_OPT_IN__c> {
            new AOPS_CONTACT_OPT_IN__c(Unique_Record_ID__c='111111111', CCU380F_CONTACT_ID__c='111111111', CXTCNTO_AOPS_KEY3__c='EM', CXTCNTO_ACTION__c='D', CCU380F_UPDATE_DATE__c='2017-09-12', CXTCNTO_TIMESTAMP__c='2020-06-30-01.03.14.3151', CCU380F_CUSTOMER_ID__c='9558038' ,Record_Updated__c=true),
            new AOPS_CONTACT_OPT_IN__c(Unique_Record_ID__c='111111112', CCU380F_CONTACT_ID__c='111111112', CXTCNTO_AOPS_KEY3__c='PH', CXTCNTO_ACTION__c='C', CCU380F_UPDATE_DATE__c='2017-09-12', CXTCNTO_TIMESTAMP__c='2020-06-30-01.03.14.3151', CCU380F_CUSTOMER_ID__c='9558037' ,Record_Updated__c=true),
            new AOPS_CONTACT_OPT_IN__c(Unique_Record_ID__c='111111113', CCU380F_CONTACT_ID__c='111111113', CXTCNTO_AOPS_KEY3__c='MB', CXTCNTO_ACTION__c='U', CCU380F_UPDATE_DATE__c='2017-09-12', CXTCNTO_TIMESTAMP__c='2020-06-30-01.03.14.3151', CCU380F_CUSTOMER_ID__c='9558036' ,Record_Updated__c=true),
            new AOPS_CONTACT_OPT_IN__c(Unique_Record_ID__c='111111114', CCU380F_CONTACT_ID__c='111111114', CXTCNTO_AOPS_KEY3__c='MB', CXTCNTO_ACTION__c='D', CCU380F_UPDATE_DATE__c='2017-09-12', CXTCNTO_TIMESTAMP__c='2020-06-30-01.03.14.3151', CCU380F_CUSTOMER_ID__c='9558035' ,Record_Updated__c=true) };
            
          insert contactMasterRecs;

        List<Contact_Final_Staging__c> finalStagingRec = new List<Contact_Final_Staging__c>{
            new Contact_Final_Staging__c  (Unique_Record_ID__c='111111111', AOPS_Contact_Number__c='111111111' ,AOPS_Account_Number__c='9558038'),
            new Contact_Final_Staging__c  (Unique_Record_ID__c='111111112', AOPS_Contact_Number__c='111111112' ,AOPS_Account_Number__c='9558037'),
            new Contact_Final_Staging__c  (Unique_Record_ID__c='111111113', AOPS_Contact_Number__c='111111113' ,AOPS_Account_Number__c='9558036', Sync_Failed__c=true),
            new Contact_Final_Staging__c  (Unique_Record_ID__c='111111114', AOPS_Contact_Number__c='' ,AOPS_Account_Number__c='9558037')};
            
        insert finalStagingRec;
       
        test.startTest();
        System.enqueueJob(new AOPSContactOptInFinalProcessor(contactMasterRecs));
        test.stopTest();
    }
}