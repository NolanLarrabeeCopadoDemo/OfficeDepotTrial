@IsTest
private class AOPSContactOptInProcessor_TC {

	@IsTest
    static void insertRecord() {
        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTCNTO_AOPS_KEY1', '12345');
        aopsDataMap.put('CXTCNTO_AOPS_KEY2', '67890');
        aopsDataMap.put('CCU380F_CONTACT_ID', '67890');
        aopsDataMap.put('CXTCNTO_AOPS_KEY3', 'MB');
        aopsDataMap.put('CCU380F_OPT_IN', 'Y');
        aopsDataMap.put('CXTCNTO_TIMESTAMP', '2020-03-30-01.03.14.3151');

        Test.startTest();
        AOPSContactOptInProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_CONTACT_OPT_IN__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU380F_OPT_IN__c, CXTCNTO_TIMESTAMP__c, Record_Updated__c FROM AOPS_CONTACT_OPT_IN__c];
        // System.assertEquals(1, stagingRecords.size());
        // System.assertEquals('1234567890MB', stagingRecords.get(0).Unique_Record_ID__c);
        // System.assertEquals('Y', stagingRecords.get(0).CCU380F_OPT_IN__c);
        // System.assertEquals('2020-03-30-01.03.14.3151', stagingRecords.get(0).CXTCNTO_TIMESTAMP__c);
        // System.assertEquals(true, stagingRecords.get(0).Record_Updated__c);
    }

    @IsTest
    static void updateRecord() {
        AOPS_CONTACT_OPT_IN__c stagingRecord = new AOPS_CONTACT_OPT_IN__c(Unique_Record_ID__c='1234567890MB', CCU380F_OPT_IN__c='Y', CXTCNTO_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTCNTO_AOPS_KEY1', '12345');
        aopsDataMap.put('CXTCNTO_AOPS_KEY2', '67890');
        aopsDataMap.put('CCU380F_CONTACT_ID', '67890');
        aopsDataMap.put('CXTCNTO_AOPS_KEY3', 'MB');
        aopsDataMap.put('CCU380F_OPT_IN', 'N');
        aopsDataMap.put('CXTCNTO_TIMESTAMP', '2020-03-31-01.03.14.3151');

        Test.startTest();
        AOPSContactOptInProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_CONTACT_OPT_IN__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU380F_OPT_IN__c, CXTCNTO_TIMESTAMP__c, Record_Updated__c FROM AOPS_CONTACT_OPT_IN__c];
        // System.assertEquals(1, stagingRecords.size());
        // System.assertEquals('1234567890MB', stagingRecords.get(0).Unique_Record_ID__c);
        // System.assertEquals('N', stagingRecords.get(0).CCU380F_OPT_IN__c);
        // System.assertEquals('2020-03-31-01.03.14.3151', stagingRecords.get(0).CXTCNTO_TIMESTAMP__c);
        // System.assertEquals(true, stagingRecords.get(0).Record_Updated__c);
    }

    @IsTest
    static void oldRecordOnUpdate() {
        AOPS_CONTACT_OPT_IN__c stagingRecord = new AOPS_CONTACT_OPT_IN__c(Unique_Record_ID__c='1234567890MB', CCU380F_OPT_IN__c='Y', CXTCNTO_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTCNTO_AOPS_KEY1', '12345');
        aopsDataMap.put('CXTCNTO_AOPS_KEY2', '67890');
        aopsDataMap.put('CCU380F_CONTACT_ID', '67890');
        aopsDataMap.put('CXTCNTO_AOPS_KEY3', 'MB');
        aopsDataMap.put('CCU380F_OPT_IN', 'N');
        aopsDataMap.put('CXTCNTO_TIMESTAMP', '2020-03-29-01.03.14.3151');

        Test.startTest();
        AOPSContactOptInProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_CONTACT_OPT_IN__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU380F_OPT_IN__c, CXTCNTO_TIMESTAMP__c, Record_Updated__c FROM AOPS_CONTACT_OPT_IN__c];
        // System.assertEquals(1, stagingRecords.size());
        // System.assertEquals(stagingRecord.Unique_Record_ID__c, stagingRecords.get(0).Unique_Record_ID__c);
        // System.assertEquals(stagingRecord.CCU380F_OPT_IN__c, stagingRecords.get(0).CCU380F_OPT_IN__c);
        // System.assertEquals(stagingRecord.CXTCNTO_TIMESTAMP__c, stagingRecords.get(0).CXTCNTO_TIMESTAMP__c);
        // System.assertEquals(false, stagingRecords.get(0).Record_Updated__c);
    }
}