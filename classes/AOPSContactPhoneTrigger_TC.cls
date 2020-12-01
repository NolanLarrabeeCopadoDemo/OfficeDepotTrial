@IsTest
public class AOPSContactPhoneTrigger_TC {
    @IsTest
    static void insertRecord() {
        
        AOPS_Contact_Phone__c stagingRecord1 = new AOPS_Contact_Phone__c(Unique_Record_ID__c='12345678', CCU320F_NBR_TYPE__c='Y', CXTCNTP_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        Schema.SObjectField uniqueField = AOPS_CONTACT_PHONE__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(stagingRecord1, uniqueField, false);
        
        AOPS_Contact_Phone__c stagingRecord2 = new AOPS_Contact_Phone__c(Unique_Record_ID__c='12345678', CCU320F_NBR_TYPE__c='Y', CXTCNTP_TIMESTAMP__c='2020-03-30-01.03.14.3150');
        uniqueField = AOPS_CONTACT_PHONE__c.Fields.Unique_Record_ID__c;                
        upsertResult = Database.upsert(stagingRecord2, uniqueField, false);
    }
}