@IsTest
public class AOPSContactOptInTrigger_TC {

    @IsTest
    static void insertRecord() {
        AOPS_CONTACT_OPT_IN__c stagingRecord1 = new AOPS_CONTACT_OPT_IN__c(Unique_Record_ID__c='1234567890MB', CCU380F_OPT_IN__c='Y', CXTCNTO_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        Schema.SObjectField uniqueField = AOPS_CONTACT_OPT_IN__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(stagingRecord1, uniqueField, false);
        
        AOPS_CONTACT_OPT_IN__c stagingRecord2 = new AOPS_CONTACT_OPT_IN__c(Unique_Record_ID__c='1234567890MB', CCU380F_OPT_IN__c='Y', CXTCNTO_TIMESTAMP__c='2020-03-30-01.03.14.3150');
        uniqueField = AOPS_CONTACT_OPT_IN__c.Fields.Unique_Record_ID__c;                
        upsertResult = Database.upsert(stagingRecord2, uniqueField, false);
    }
}