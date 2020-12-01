@isTest
public class AOPSAddressMasterFinalProcessor_TC {
    @isTest
    public static void makedata() {
         List<AOPS_Address_Master__c> accountMasterRecs = new List<AOPS_Address_Master__c> {
            new AOPS_Address_Master__c(Unique_Record_ID__c='11111111', FCU001P_CUSTOMER_ID__c='11111111', FCU001P_STATE__c = 'FL', FCU001P_ADDRESS_SEQ__c = '0001', CXTF001P_TIMESTAMP__c='2020-03-30-01.03.14.3151', Record_Updated__c=true),
            new AOPS_Address_Master__c(Unique_Record_ID__c='11111112', FCU001P_CUSTOMER_ID__c='11111112', FCU001P_STATE__c = 'CA', FCU001P_ADDRESS_SEQ__c = '0002', CXTF001P_TIMESTAMP__c='2020-03-30-01.03.14.3151', Record_Updated__c=true),
            new AOPS_Address_Master__c(Unique_Record_ID__c='11111113', FCU001P_CUSTOMER_ID__c='11111113', FCU001P_STATE__c = 'GA', FCU001P_ADDRESS_SEQ__c = '0003', FCU001P_ADDRESS_KEY__c='2', CXTF001P_SFDC_KEY1__c='A', CXTF001P_SFDC_KEY2__c='B', FCU001P_BUSINESS_NAME__c='Bizz', FCU001P_STREET_ADDRESS1__c ='123 street abc', CXTF001P_TIMESTAMP__c='2020-03-30-01.03.14.3151', Record_Updated__c=true) };
        insert accountMasterRecs;
        /*
                List<Account_Final_Staging__c> finalStagingRecs = [SELECT Id, AOPS_Cust_Id__c, CONTRACT_RETAIL_CUST_CODE__c, Is_Account_Master_Changed__c FROM Account_Final_Staging__c];
        AOPS_Account_Master__c newAccountMasterRec = new AOPS_Account_Master__c(Unique_Record_ID__c='11111114', FCU000P_CUSTOMER_ID__c='11111114', FCU000P_CONT_RETAIL_CODE__c='C', CXTF000P_TIMESTAMP__c='2020-03-30-01.03.14.3151', Record_Updated__c=true);
        Account_Final_Staging__c createdFinalStagingRec = [SELECT Id, CONTRACT_RETAIL_CUST_CODE__c, Is_Account_Master_Changed__c FROM Account_Final_Staging__c /*WHERE AOPS_Cust_Id__c = '11111114'8]; */

        test.startTest();
        System.enqueueJob(new AOPSAddressMasterFinalProcessor(accountMasterRecs));
        test.stopTest();
    }
}