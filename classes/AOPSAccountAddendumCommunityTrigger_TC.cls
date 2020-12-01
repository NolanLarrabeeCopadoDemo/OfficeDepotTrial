@IsTest
public class AOPSAccountAddendumCommunityTrigger_TC {

    @IsTest
    static void insertRecord() {
        AOPS_Account_Addendum_Community__c stagingRecord1 = new AOPS_Account_Addendum_Community__c(Unique_Record_ID__c='12345678', CCU043F_AECDCO1__c='Test1', CXTC043F_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        Schema.SObjectField uniqueField = AOPS_Account_Addendum_Community__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(stagingRecord1, uniqueField, false);
        
        AOPS_Account_Addendum_Community__c stagingRecord2 = new AOPS_Account_Addendum_Community__c(Unique_Record_ID__c='12345678', CCU043F_AECDCO1__c='Test1', CXTC043F_TIMESTAMP__c='2020-03-30-01.03.14.3150');
        uniqueField = AOPS_Account_Addendum_Community__c.Fields.Unique_Record_ID__c;                
        upsertResult = Database.upsert(stagingRecord2, uniqueField, false);
    }
    
}