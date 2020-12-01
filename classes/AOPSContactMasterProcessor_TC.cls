@IsTest
public class AOPSContactMasterProcessor_TC {
    @IsTest
    static void insertRecord() {
        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTCNTM_AOPS_KEY1', '123');
        aopsDataMap.put('CXTCNTM_AOPS_KEY2', '456');
        aopsDataMap.put('CCU300F_CONTACT_ID', '456');
        aopsDataMap.put('CCU300F_NAME_1', 'Test');
        aopsDataMap.put('CCU300F_CREATE_DT', '2017-07-21');
        aopsDataMap.put('CXTCNTM_TIMESTAMP', '2020-03-30-01.03.14.3151');

        Test.startTest();
        AOPSContactMasterProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_STG_CONTACT_MASTER__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU300F_NAME_1__c, CXTCNTM_TIMESTAMP__c, Record_Updated__c FROM AOPS_STG_CONTACT_MASTER__c];
       /* System.assertEquals(1, stagingRecords.size());
        System.assertEquals('123456', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('Test', stagingRecords.get(0).CCU300F_NAME_1__c);
        System.assertEquals('2020-03-30-01.03.14.3151', stagingRecords.get(0).CXTCNTM_TIMESTAMP__c);
        System.assertEquals(true, stagingRecords.get(0).Record_Updated__c); */
    }

    @IsTest
    static void updateRecord() {
        AOPS_STG_CONTACT_MASTER__c stagingRecord = new AOPS_STG_CONTACT_MASTER__c(Unique_Record_ID__c='123456', CCU300F_NAME_1__c ='Te', CXTCNTM_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTCNTM_AOPS_KEY1', '123');
        aopsDataMap.put('CXTCNTM_AOPS_KEY2', '456');
        aopsDataMap.put('CCU300F_CONTACT_ID', '456');
        aopsDataMap.put('CCU300F_NAME_1', 'Test');
        aopsDataMap.put('CCU300F_CREATE_DT', '2017-07-21');
        aopsDataMap.put('CXTCNTM_TIMESTAMP', '2020-03-31-01.03.14.3151');

        Test.startTest();
        AOPSContactMasterProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_STG_CONTACT_MASTER__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU300F_NAME_1__c, CXTCNTM_TIMESTAMP__c, Record_Updated__c FROM AOPS_STG_CONTACT_MASTER__c];
       /* System.assertEquals(1, stagingRecords.size());
        System.assertEquals('123456', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('Test', stagingRecords.get(0).CCU300F_NAME_1__c);
        System.assertEquals('2020-03-31-01.03.14.3151', stagingRecords.get(0).CXTCNTM_TIMESTAMP__c);
        System.assertEquals(true, stagingRecords.get(0).Record_Updated__c); */
    }

    @IsTest
    static void oldRecordOnUpdate() {
        AOPS_STG_CONTACT_MASTER__c stagingRecord = new AOPS_STG_CONTACT_MASTER__c(Unique_Record_ID__c='123456', CCU300F_NAME_1__c='Te', CXTCNTM_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTCNTM_AOPS_KEY1', '123');
        aopsDataMap.put('CXTCNTM_AOPS_KEY2', '456');
        aopsDataMap.put('CCU300F_CONTACT_ID', '456');
        aopsDataMap.put('CCU300F_NAME_1', 'Test');
        aopsDataMap.put('CCU300F_CREATE_DT', '2017-07-21');
        aopsDataMap.put('CXTCNTM_TIMESTAMP', '2020-03-29-01.03.14.3151');

        Test.startTest();
        AOPSContactMasterProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_STG_CONTACT_MASTER__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU300F_NAME_1__c, CXTCNTM_TIMESTAMP__c, Record_Updated__c FROM AOPS_STG_CONTACT_MASTER__c];
        /*System.assertEquals(1, stagingRecords.size());
        System.assertEquals(stagingRecord.Unique_Record_ID__c, stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals(stagingRecord.CCU300F_NAME_1__c, stagingRecords.get(0).CCU300F_NAME_1__c);
        System.assertEquals(stagingRecord.CXTCNTM_TIMESTAMP__c, stagingRecords.get(0).CXTCNTM_TIMESTAMP__c);
        System.assertEquals(false, stagingRecords.get(0).Record_Updated__c);*/
    }
}