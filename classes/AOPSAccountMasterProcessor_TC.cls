@IsTest
private class AOPSAccountMasterProcessor_TC {
    
    @IsTest
    static void insertRecord() {
        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTF000P_AOPS_KEY1', '12345678');
        aopsDataMap.put('FCU000P_CUSTOMER_ID', '12345678');
        aopsDataMap.put('FCU000P_BUSINESS_NAME', 'Test2');
        aopsDataMap.put('CXTF000P_TIMESTAMP', '2020-03-30-01.03.14.3151');

        Test.startTest();
        AOPSAccountMasterProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Account_Master__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, FCU000P_BUSINESS_NAME__c, CXTF000P_TIMESTAMP__c, Record_Updated__c FROM AOPS_Account_Master__c];
      /*  System.assertEquals(1, stagingRecords.size());
        System.assertEquals('12345678', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('Test2', stagingRecords.get(0).FCU000P_BUSINESS_NAME__c);
        System.assertEquals('2020-03-30-01.03.14.3151', stagingRecords.get(0).CXTF000P_TIMESTAMP__c);
        System.assertEquals(true, stagingRecords.get(0).Record_Updated__c);
*/
    }

    @IsTest
    static void updateRecord() {
        AOPS_Account_Master__c stagingRecord = new AOPS_Account_Master__c(Unique_Record_ID__c='12345678', FCU000P_BUSINESS_NAME__c='Test1', CXTF000P_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTF000P_AOPS_KEY1', '12345678');
        aopsDataMap.put('FCU000P_CUSTOMER_ID', '12345678');
        aopsDataMap.put('FCU000P_BUSINESS_NAME', 'Test2');
        aopsDataMap.put('CXTF000P_TIMESTAMP', '2020-03-31-01.03.14.3151');

        Test.startTest();
        AOPSAccountMasterProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Account_Master__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, FCU000P_BUSINESS_NAME__c, CXTF000P_TIMESTAMP__c, Record_Updated__c FROM AOPS_Account_Master__c];
    /*    System.assertEquals(1, stagingRecords.size());
        System.assertEquals('12345678', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('Test2', stagingRecords.get(0).FCU000P_BUSINESS_NAME__c);
        System.assertEquals('2020-03-31-01.03.14.3151', stagingRecords.get(0).CXTF000P_TIMESTAMP__c);
        System.assertEquals(true, stagingRecords.get(0).Record_Updated__c);
*/
    }

    @IsTest
    static void oldRecordOnUpdate() {
        AOPS_Account_Master__c stagingRecord = new AOPS_Account_Master__c(Unique_Record_ID__c='12345678', FCU000P_BUSINESS_NAME__c='Test1', CXTF000P_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTF000P_AOPS_KEY1', '12345678');
        aopsDataMap.put('FCU000P_CUSTOMER_ID', '12345678');
        aopsDataMap.put('FCU000P_BUSINESS_NAME', 'Test2');
        aopsDataMap.put('CXTF000P_TIMESTAMP', '2020-03-29-01.03.14.3151');

        Test.startTest();
        AOPSAccountMasterProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Account_Master__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, FCU000P_BUSINESS_NAME__c, CXTF000P_TIMESTAMP__c, Record_Updated__c FROM AOPS_Account_Master__c];
     /*   System.assertEquals(1, stagingRecords.size());
        System.assertEquals(stagingRecord.Unique_Record_ID__c, stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals(stagingRecord.FCU000P_BUSINESS_NAME__c, stagingRecords.get(0).FCU000P_BUSINESS_NAME__c);
        System.assertEquals(stagingRecord.CXTF000P_TIMESTAMP__c, stagingRecords.get(0).CXTF000P_TIMESTAMP__c);
        System.assertEquals(false, stagingRecords.get(0).Record_Updated__c);
*/
    }

}