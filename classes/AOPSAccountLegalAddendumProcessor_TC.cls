@IsTest
private class AOPSAccountLegalAddendumProcessor_TC {

	@IsTest
    static void insertRecord() {
        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTC044F_AOPS_KEY1', '12345678');
        aopsDataMap.put('CCU044F_CODE51', 'E');
        aopsDataMap.put('CXTC044F_TIMESTAMP', '2020-03-30-01.03.14.3151');

        Test.startTest();
        AOPSAccountLegalAddendumProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Account_Addendum_Legal_Other__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU044F_CODE51__c, CXTC044F_TIMESTAMP__c, Record_Updated__c FROM AOPS_Account_Addendum_Legal_Other__c];
     /*   System.assertEquals(1, stagingRecords.size());
        System.assertEquals('12345678', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('E', stagingRecords.get(0).CCU044F_CODE51__c);
        System.assertEquals('2020-03-30-01.03.14.3151', stagingRecords.get(0).CXTC044F_TIMESTAMP__c);
        System.assertEquals(true, stagingRecords.get(0).Record_Updated__c);
*/
    }

    @IsTest
    static void updateRecord() {
        AOPS_Account_Addendum_Legal_Other__c stagingRecord = new AOPS_Account_Addendum_Legal_Other__c(Unique_Record_ID__c='12345678', CCU044F_CODE51__c='TE', CXTC044F_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTC044F_AOPS_KEY1', '12345678');
        aopsDataMap.put('CCU044F_CODE51', 'E');
        aopsDataMap.put('CXTC044F_TIMESTAMP', '2020-03-31-01.03.14.3151');

        Test.startTest();
        AOPSAccountLegalAddendumProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Account_Addendum_Legal_Other__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU044F_CODE51__c, CXTC044F_TIMESTAMP__c, Record_Updated__c FROM AOPS_Account_Addendum_Legal_Other__c];
     /*   System.assertEquals(1, stagingRecords.size());
        System.assertEquals('12345678', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('E', stagingRecords.get(0).CCU044F_CODE51__c);
        System.assertEquals('2020-03-31-01.03.14.3151', stagingRecords.get(0).CXTC044F_TIMESTAMP__c);
        System.assertEquals(true, stagingRecords.get(0).Record_Updated__c);
*/
    }

    @IsTest
    static void oldRecordOnUpdate() {
        AOPS_Account_Addendum_Legal_Other__c stagingRecord = new AOPS_Account_Addendum_Legal_Other__c(Unique_Record_ID__c='12345678', CCU044F_CODE51__c='TE', CXTC044F_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTC044F_AOPS_KEY1', '12345678');
        aopsDataMap.put('CCU044F_CODE51', 'E');
        aopsDataMap.put('CXTC044F_TIMESTAMP', '2020-03-29-01.03.14.3151');

        Test.startTest();
        AOPSAccountLegalAddendumProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Account_Addendum_Legal_Other__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU044F_CODE51__c, CXTC044F_TIMESTAMP__c, Record_Updated__c FROM AOPS_Account_Addendum_Legal_Other__c];
     /*   System.assertEquals(1, stagingRecords.size());
        System.assertEquals(stagingRecord.Unique_Record_ID__c, stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals(stagingRecord.CCU044F_CODE51__c, stagingRecords.get(0).CCU044F_CODE51__c);
        System.assertEquals(stagingRecord.CXTC044F_TIMESTAMP__c, stagingRecords.get(0).CXTC044F_TIMESTAMP__c);
        System.assertEquals(false, stagingRecords.get(0).Record_Updated__c);
*/
    }
}