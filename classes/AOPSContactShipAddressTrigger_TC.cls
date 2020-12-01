@IsTest
public class AOPSContactShipAddressTrigger_TC {

    @IsTest
    static void insertRecord() {
        AOPS_Contact_Ship_Address__c stagingRecord1 = new AOPS_Contact_Ship_Address__c(Unique_Record_ID__c='123456789010', CCU310F_ADDR_SEQ__c='Test1', CXTCNTS_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        Schema.SObjectField uniqueField = AOPS_Contact_Ship_Address__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(stagingRecord1, uniqueField, false);
        
        AOPS_Contact_Ship_Address__c stagingRecord2 = new AOPS_Contact_Ship_Address__c(Unique_Record_ID__c='123456789010', CCU310F_ADDR_SEQ__c='Test1', CXTCNTS_TIMESTAMP__c='2020-03-30-01.03.14.3150');
        uniqueField = AOPS_Contact_Ship_Address__c.Fields.Unique_Record_ID__c;                
        upsertResult = Database.upsert(stagingRecord2, uniqueField, false);
    }
    
}