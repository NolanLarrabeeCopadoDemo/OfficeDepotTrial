@isTest
public class AOPSAddressBSDAddendumFinalProcessor_TC {
    @isTest
    public static void makedata() {
         List<AOPS_Address_BSD_A__c> accountMasterRecs = new List<AOPS_Address_BSD_A__c> {
            new AOPS_Address_BSD_A__c(Unique_Record_ID__c='11111111', CCU009F_CUSTOMER_ID__c='11111111', CCU009F_ADDRESS_SEQ__c = '00001', CXTC009F_TIMESTAMP__c='2020-03-30-01.03.14.3151', Record_Updated__c=true),
            new AOPS_Address_BSD_A__c(Unique_Record_ID__c='11111112', CCU009F_CUSTOMER_ID__c='11111112', CCU009F_ADDRESS_SEQ__c = '00002', CXTC009F_TIMESTAMP__c='2020-03-30-01.03.14.3151', Record_Updated__c=true),
            new AOPS_Address_BSD_A__c(Unique_Record_ID__c='11111113', CCU009F_CUSTOMER_ID__c='11111113', CCU009F_ADDRESS_SEQ__c = '00003', CXTC009F_TIMESTAMP__c='2020-03-30-01.03.14.3151', Record_Updated__c=true) };
        insert accountMasterRecs;
        /*
                List<Account_Final_Staging__c> finalStagingRecs = [SELECT Id, AOPS_Cust_Id__c, CONTRACT_RETAIL_CUST_CODE__c, Is_Account_Master_Changed__c FROM Account_Final_Staging__c];
        AOPS_Account_Master__c newAccountMasterRec = new AOPS_Account_Master__c(Unique_Record_ID__c='11111114', FCU000P_CUSTOMER_ID__c='11111114', FCU000P_CONT_RETAIL_CODE__c='C', CXTF000P_TIMESTAMP__c='2020-03-30-01.03.14.3151', Record_Updated__c=true);
        Account_Final_Staging__c createdFinalStagingRec = [SELECT Id, CONTRACT_RETAIL_CUST_CODE__c, Is_Account_Master_Changed__c FROM Account_Final_Staging__c /*WHERE AOPS_Cust_Id__c = '11111114'8]; */

        test.startTest();
        System.enqueueJob(new AOPSAddressBSDAddendumFinalProcessor(accountMasterRecs));
        test.stopTest();
    }
}