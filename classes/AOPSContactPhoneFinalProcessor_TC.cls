@IsTest
public class AOPSContactPhoneFinalProcessor_TC {
    @isTest
    public static void makedata() {
         List<AOPS_Contact_Phone__c> contactMasterRecs = new List<AOPS_Contact_Phone__c> {
            new AOPS_Contact_Phone__c(Unique_Record_ID__c='111111111', CCU320F_CONTACT_ID__c='111111111', CCU320F_NBR_TYPE__c = 'HMB', CXTCNTP_ACTION__c='U', CCU320F_PHONE_SEQ__c = '8346374', CCU320F_CONTACT_DFT_NUMBER__c = 'Y', CXTCNTP_TIMESTAMP__c='2020-06-30-01.03.14.3151',CCU320F_CUSTOMER_ID__c='9558038' ,Record_Updated__c=true),
            new AOPS_Contact_Phone__c(Unique_Record_ID__c='111111112', CCU320F_CONTACT_ID__c='111111112', CCU320F_NBR_TYPE__c = 'WMB', CXTCNTP_ACTION__c='C', CCU320F_PHONE_SEQ__c = '8346074', CCU320F_CONTACT_DFT_NUMBER__c = 'Y', CXTCNTP_TIMESTAMP__c='2020-06-30-01.03.14.3151', CCU320F_CUSTOMER_ID__c='8589585', Record_Updated__c=true),
            new AOPS_Contact_Phone__c(Unique_Record_ID__c='111111113', CCU320F_CONTACT_ID__c='111111113', CCU320F_NBR_TYPE__c = 'HPG', CXTCNTP_ACTION__c='C', CCU320F_PHONE_SEQ__c = '8346073', CCU320F_CONTACT_DFT_NUMBER__c = 'Y', CXTCNTP_TIMESTAMP__c='2020-06-30-01.03.14.3151',CCU320F_CUSTOMER_ID__c='1939849', Record_Updated__c=true),
            new AOPS_Contact_Phone__c(Unique_Record_ID__c='111111114', CCU320F_CONTACT_ID__c='111111114', CCU320F_NBR_TYPE__c = 'HPG', CXTCNTP_ACTION__c='D', CCU320F_PHONE_SEQ__c = '8346072', CCU320F_CONTACT_DFT_NUMBER__c = 'Y', CXTCNTP_TIMESTAMP__c='2020-06-30-01.03.14.3151',CCU320F_CUSTOMER_ID__c='1939848', Record_Updated__c=true) };
            
          insert contactMasterRecs;

        List<Contact_Final_Staging__c> finalStagingRec = new List<Contact_Final_Staging__c>{
            new Contact_Final_Staging__c  (Unique_Record_ID__c='111111111', AOPS_Contact_Number__c='111111111' ,AOPS_Account_Number__c='9558038', Phone1_AOPS_Seq__c = '8346374'),
            new Contact_Final_Staging__c   (Unique_Record_ID__c='111111112', AOPS_Contact_Number__c='111111112' ,AOPS_Account_Number__c='8589585', Phone2_AOPS_Seq__c = '8346074'),
            new Contact_Final_Staging__c   (Unique_Record_ID__c='111111113', AOPS_Contact_Number__c='111111113' ,AOPS_Account_Number__c='1939849', Phone3_AOPS_Seq__c = '8346073'),
            new Contact_Final_Staging__c   (Unique_Record_ID__c='111111114', AOPS_Contact_Number__c='111111114' ,AOPS_Account_Number__c='1939848', Phone3_AOPS_Seq__c = '8346072')};
            
        insert finalStagingRec;
       
        test.startTest();
        System.enqueueJob(new AOPSContactPhoneFinalProcessor(contactMasterRecs));
        test.stopTest();
    }
}