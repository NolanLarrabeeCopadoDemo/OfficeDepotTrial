@IsTest
public class AOPSContactPhoneProcessor_TC {

	@IsTest
    static void insertRecord() {
        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTCNTP_AOPS_KEY1', '123');
        aopsDataMap.put('CXTCNTP_AOPS_KEY2', '456');
        aopsDataMap.put('CXTCNTP_AOPS_KEY3', '789');
        aopsDataMap.put('CXTCNTP_TIMESTAMP', '2020-03-30-01.03.14.3151');
        aopsDataMap.put('CCU320F_PHONE_SEQ', '1234');
        aopsDataMap.put('CCU320F_CONTACT_ID', '12345');
        aopsDataMap.put('CCU320F_CUSTOMER_ID', '1234');
        Test.startTest();
        AOPSContactPhoneProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Contact_Phone__c> stagingRecords = [SELECT Id, Unique_Record_ID__c FROM AOPS_Contact_Phone__c];
        /*System.assertEquals(1, stagingRecords.size());
        System.assertEquals('123456789', stagingRecords.get(0).Unique_Record_ID__c);*/
    }

    @IsTest
    static void updateRecord() {
        AOPS_Contact_Phone__c stagingRecord = new AOPS_Contact_Phone__c(Unique_Record_ID__c='12345678', CCU320F_NBR_TYPE__c='HFX', CXTCNTP_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTCNTP_AOPS_KEY1', '123');
        aopsDataMap.put('CXTCNTP_AOPS_KEY2', '456');
        aopsDataMap.put('CXTCNTP_AOPS_KEY3', '789');
        aopsDataMap.put('CCU320F_NBR_TYPE', 'HMB');
        aopsDataMap.put('CXTCNTP_TIMESTAMP', '2020-03-31-01.03.14.3151');
        aopsDataMap.put('CCU320F_PHONE_SEQ', '1234');
        aopsDataMap.put('CCU320F_CONTACT_ID', '12345');
        aopsDataMap.put('CCU320F_CUSTOMER_ID', '1234');

        Test.startTest();
        AOPSContactPhoneProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Contact_Phone__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU320F_NBR_TYPE__c, CXTCNTP_TIMESTAMP__c FROM AOPS_Contact_Phone__c];
       /* System.assertEquals(1, stagingRecords.size());
        System.assertEquals('123456789', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('HMB', stagingRecords.get(0).CCU320F_NBR_TYPE__c);
        System.assertEquals('2020-03-31-01.03.14.3151', stagingRecords.get(0).CXTCNTP_TIMESTAMP__c); */
    }

    @IsTest
    static void oldRecordOnUpdate() {
        AOPS_Contact_Phone__c stagingRecord = new AOPS_Contact_Phone__c(Unique_Record_ID__c='12345678', CCU320F_NBR_TYPE__c='Y', CXTCNTP_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTCNTP_AOPS_KEY1', '123');
        aopsDataMap.put('CXTCNTP_AOPS_KEY2', '456');
        aopsDataMap.put('CXTCNTP_AOPS_KEY3', '789');
        aopsDataMap.put('CCU320F_NBR_TYPE', 'HFB');
        aopsDataMap.put('CXTCNTP_TIMESTAMP', '2020-03-29-01.03.14.3151');
        aopsDataMap.put('CCU320F_PHONE_SEQ', '1234');
        aopsDataMap.put('CCU320F_CONTACT_ID', '12345');
        aopsDataMap.put('CCU320F_CUSTOMER_ID', '1234');

        Test.startTest();
        AOPSContactPhoneProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Contact_Phone__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU320F_NBR_TYPE__c, CXTCNTP_TIMESTAMP__c FROM AOPS_Contact_Phone__c];
      /*  System.assertEquals(1, stagingRecords.size());
        System.assertEquals(stagingRecord.Unique_Record_ID__c, stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals(stagingRecord.CCU320F_NBR_TYPE__c, stagingRecords.get(0).CCU320F_NBR_TYPE__c);
        System.assertEquals(stagingRecord.CXTCNTP_TIMESTAMP__c, stagingRecords.get(0).CXTCNTP_TIMESTAMP__c); */
    }
}