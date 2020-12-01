@IsTest
public class AOPSContactWebUserTrigger_TC {

    @IsTest
    static void insertRecord() {
        AOPS_Contact_Web_User__c stagingRecord1 = new AOPS_Contact_Web_User__c(Unique_Record_ID__c='123456789010', CCU300F_NAME_1__c='Test1', CXTCNTW_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        Schema.SObjectField uniqueField = AOPS_Contact_Web_User__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(stagingRecord1, uniqueField, false);
        
        AOPS_Contact_Web_User__c stagingRecord2 = new AOPS_Contact_Web_User__c(Unique_Record_ID__c='123456789010', CCU300F_NAME_1__c='Test1', CXTCNTW_TIMESTAMP__c='2020-03-30-01.03.14.3150');
        uniqueField = AOPS_Contact_Web_User__c.Fields.Unique_Record_ID__c;                
        upsertResult = Database.upsert(stagingRecord2, uniqueField, false);
    }
    
}