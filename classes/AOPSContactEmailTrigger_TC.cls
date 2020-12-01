@IsTest
public class AOPSContactEmailTrigger_TC {

    @IsTest
    static void insertRecord() {
     
        AOPS_Contact_Email__c stagingRecord1 = new AOPS_Contact_Email__c(Unique_Record_ID__c='12345678', CCU340F_EMAIL_OUT_TYPE__c='HTML', CXTCNTE_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        Schema.SObjectField uniqueField = AOPS_Contact_Email__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(stagingRecord1, uniqueField, false);
        
        AOPS_Contact_Email__c stagingRecord2 = new AOPS_Contact_Email__c(Unique_Record_ID__c='12345678', CCU340F_EMAIL_OUT_TYPE__c='HTML', CXTCNTE_TIMESTAMP__c='2020-03-30-01.03.14.3150');
        uniqueField = AOPS_Contact_Email__c.Fields.Unique_Record_ID__c;                
        upsertResult = Database.upsert(stagingRecord1, uniqueField, false);
    }
    
}