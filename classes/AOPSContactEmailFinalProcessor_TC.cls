@isTest
public class AOPSContactEmailFinalProcessor_TC {
    @isTest
    public static void makedata() {
        Map<String, Contact_Final_Staging__c> finalStagingMap = new Map<String, Contact_Final_Staging__c>();
        List<AOPS_Contact_Email__c> contactMasterRecs = new List<AOPS_Contact_Email__c> {
            new AOPS_Contact_Email__c(CXTCNTE_ACTION__c='C',Unique_Record_ID__c='111111111',CCU340F_ADDRESS_SEQ__c='154364337',CCU340F_CONTACT_DFT_INTERNET__c='Y',CCU340F_INTERNET_TYPE__c='WEM',CXTCNTE_AOPS_KEY1__c='124666', CCU340F_CONTACT_ID__c='111111111', CCU340F_EMAIL_OUT_TYPE__C = 'HTML',CCU340F_ADDRESS__c='hfhfhf@ii.com', CXTCNTE_TIMESTAMP__c='2020-06-30-01.03.14.3151'),
                new AOPS_Contact_Email__c(CXTCNTE_ACTION__c='D',Unique_Record_ID__c='111111112',CCU340F_ADDRESS_SEQ__c='8475858',CCU340F_INTERNET_TYPE__c='HEM',CCU340F_CONTACT_DFT_INTERNET__c='Y',CXTCNTE_AOPS_KEY1__c='75638474', CCU340F_CONTACT_ID__c='111111112', CCU340F_EMAIL_OUT_TYPE__C = 'HTML',CCU340F_ADDRESS__c='kdkkf@jj.com', CXTCNTE_TIMESTAMP__c='2020-06-30-01.03.14.3151'),
                new AOPS_Contact_Email__c(CXTCNTE_AOPS_KEY1__c='75759859',CXTCNTE_ACTION__c='U',CCU340F_ADDRESS_SEQ__c='7447498',Unique_Record_ID__c='111111113', CCU340F_INTERNET_TYPE__c='WEM',CCU340F_CONTACT_DFT_INTERNET__c='Y', CCU340F_EMAIL_OUT_TYPE__C = 'HTML', CXTCNTE_TIMESTAMP__c='2020-06-30-01.03.14.3151',CCU340F_CONTACT_ID__c='111111113',CCU340F_ADDRESS__c='laldl@ii.com' ) };
                    insert contactMasterRecs;
        List<Contact_Final_Staging__c> finalStagingRec = new List<Contact_Final_Staging__c>{
            new Contact_Final_Staging__c  (Email2_AOPS_Seq__c='154364337',AOPS_Contact_Number__c='111111111' ,AOPS_Account_Number__c='124666',Unique_Record_ID__c='111111111124666',Email2__c='hfhfhf@ii.com',Email2_Type__c='WEM'),
                new Contact_Final_Staging__c   (Email1_AOPS_Seq__c='8475858',Email1__c='',Email1_Type__c='',AOPS_Contact_Number__c='111111112' ,AOPS_Account_Number__c='75638474',Unique_Record_ID__c='11111111275638474'),new Contact_Final_Staging__c   (Email3_AOPS_Seq__c='7447498',AOPS_Contact_Number__c='111111113' ,AOPS_Account_Number__c='75759859',Unique_Record_ID__c='11111111375759859')};
                    insert finalStagingRec;
               test.startTest();
        System.enqueueJob(new AOPSContactEmailFinalProcessor(contactMasterRecs));
        test.stopTest();
    }
}