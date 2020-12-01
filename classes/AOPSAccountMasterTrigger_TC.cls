@IsTest
public class AOPSAccountMasterTrigger_TC {

    @IsTest
    static void insertRecord() {
        AOPS_Account_Master__c stagingRecord1 = new AOPS_Account_Master__c(Unique_Record_ID__c='12345678', FCU000P_BUSINESS_NAME__c='Test1', CXTF000P_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        Schema.SObjectField uniqueField = AOPS_Account_Master__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(stagingRecord1, uniqueField, false);
        
        AOPS_Account_Master__c stagingRecord2 = new AOPS_Account_Master__c(Unique_Record_ID__c='12345678', FCU000P_BUSINESS_NAME__c='Test1', CXTF000P_TIMESTAMP__c='2020-03-30-01.03.14.3150');
        uniqueField = AOPS_Account_Master__c.Fields.Unique_Record_ID__c;                
        upsertResult = Database.upsert(stagingRecord2, uniqueField, false);
    }
    
}