@isTest
public class AOPSAccountChildParentFinalProcessor_TC {
    @isTest
    public static void makedata() {
         List<AOPS_Account_Child_Parent_Relationship__c> accountMasterRecs = new List<AOPS_Account_Child_Parent_Relationship__c> {
            new AOPS_Account_Child_Parent_Relationship__c(Unique_Record_ID__c='11111111', FCU005P_CUSTOMER_ID__c='11111111', FCU005P_PARENT_ID__c = '22222222', CXTF005P_TIMESTAMP__c='2020-03-30-01.03.14.3151', Record_Updated__c=true),
            new AOPS_Account_Child_Parent_Relationship__c(Unique_Record_ID__c='11111112', FCU005P_CUSTOMER_ID__c='11111112', FCU005P_PARENT_ID__c = '22222223', CXTF005P_TIMESTAMP__c='2020-03-30-01.03.14.3151', Record_Updated__c=true),
            new AOPS_Account_Child_Parent_Relationship__c(Unique_Record_ID__c='11111113', FCU005P_CUSTOMER_ID__c='11111113', FCU005P_PARENT_ID__c = '22222224', CXTF005P_TIMESTAMP__c='2020-03-30-01.03.14.3151', Record_Updated__c=true) };
        insert accountMasterRecs;
        /*
                List<Account_Final_Staging__c> finalStagingRecs = [SELECT Id, AOPS_Cust_Id__c, CONTRACT_RETAIL_CUST_CODE__c, Is_Account_Master_Changed__c FROM Account_Final_Staging__c];
        AOPS_Account_Master__c newAccountMasterRec = new AOPS_Account_Master__c(Unique_Record_ID__c='11111114', FCU000P_CUSTOMER_ID__c='11111114', FCU000P_CONT_RETAIL_CODE__c='C', CXTF000P_TIMESTAMP__c='2020-03-30-01.03.14.3151', Record_Updated__c=true);
        Account_Final_Staging__c createdFinalStagingRec = [SELECT Id, CONTRACT_RETAIL_CUST_CODE__c, Is_Account_Master_Changed__c FROM Account_Final_Staging__c /*WHERE AOPS_Cust_Id__c = '11111114'8]; */

        test.startTest();
        System.enqueueJob(new AOPSAccountChildParentRelFinalProcessor(accountMasterRecs));
        test.stopTest();
    }
}