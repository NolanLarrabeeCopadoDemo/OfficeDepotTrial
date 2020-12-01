@IsTest
public class AOPSAccountPreferencesTrigger_TC {

    @IsTest
    static void insertRecord() {
        AOPS_Account_Preferences__c stagingRecord1 = new AOPS_Account_Preferences__c(Unique_Record_ID__c='1234567890', FCU370P_CREATE_ID__c='Test1', CXTF370P_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        Schema.SObjectField uniqueField = AOPS_Account_Preferences__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(stagingRecord1, uniqueField, false);
        
        AOPS_Account_Preferences__c stagingRecord2 = new AOPS_Account_Preferences__c(Unique_Record_ID__c='1234567890', FCU370P_CREATE_ID__c='Test1', CXTF370P_TIMESTAMP__c='2020-03-30-01.03.14.3150');
        uniqueField = AOPS_Account_Preferences__c.Fields.Unique_Record_ID__c;                
        upsertResult = Database.upsert(stagingRecord2, uniqueField, false);
    }
}