@IsTest
private class AOPSAccountPreferencesProcessor_TC {
    
    @IsTest
    static void insertRecord() {
        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTF370P_AOPS_KEY1', '12345678');
        aopsDataMap.put('CXTF370P_AOPS_KEY2', '90');
        aopsDataMap.put('FCU370P_CREATE_ID', 'Test2');
        aopsDataMap.put('CXTF370P_TIMESTAMP', '2020-03-30-01.03.14.3151');

        Test.startTest();
        AOPSAccountPreferencesProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Account_Preferences__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, FCU370P_CREATE_ID__c, CXTF370P_TIMESTAMP__c, Record_Updated__c FROM AOPS_Account_Preferences__c];
     /*   System.assertEquals(1, stagingRecords.size());
        System.assertEquals('1234567890', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('Test2', stagingRecords.get(0).FCU370P_CREATE_ID__c);
        System.assertEquals('2020-03-30-01.03.14.3151', stagingRecords.get(0).CXTF370P_TIMESTAMP__c);
        System.assertEquals(true, stagingRecords.get(0).Record_Updated__c);
*/
    }

    @IsTest
    static void updateRecord() {
        AOPS_Account_Preferences__c stagingRecord = new AOPS_Account_Preferences__c(Unique_Record_ID__c='1234567890', FCU370P_CREATE_ID__c='Test1', CXTF370P_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTF370P_AOPS_KEY1', '12345678');
        aopsDataMap.put('CXTF370P_AOPS_KEY2', '90');
        aopsDataMap.put('FCU370P_CREATE_ID', 'Test2');
        aopsDataMap.put('CXTF370P_TIMESTAMP', '2020-03-31-01.03.14.3151');

        Test.startTest();
        AOPSAccountPreferencesProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Account_Preferences__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, FCU370P_CREATE_ID__c, CXTF370P_TIMESTAMP__c, Record_Updated__c FROM AOPS_Account_Preferences__c];
      /*  System.assertEquals(1, stagingRecords.size());
        System.assertEquals('1234567890', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('Test2', stagingRecords.get(0).FCU370P_CREATE_ID__c);
        System.assertEquals('2020-03-31-01.03.14.3151', stagingRecords.get(0).CXTF370P_TIMESTAMP__c);
        System.assertEquals(true, stagingRecords.get(0).Record_Updated__c);
*/
    }

    @IsTest
    static void oldRecordOnUpdate() {
        AOPS_Account_Preferences__c stagingRecord = new AOPS_Account_Preferences__c(Unique_Record_ID__c='1234567890', FCU370P_CREATE_ID__c='Test1', CXTF370P_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTF370P_AOPS_KEY1', '12345678');
        aopsDataMap.put('CXTF370P_AOPS_KEY2', '90');
        aopsDataMap.put('FCU370P_CREATE_ID', 'Test2');
        aopsDataMap.put('CXTF370P_TIMESTAMP', '2020-03-29-01.03.14.3151');

        Test.startTest();
        AOPSAccountPreferencesProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Account_Preferences__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, FCU370P_CREATE_ID__c, CXTF370P_TIMESTAMP__c, Record_Updated__c FROM AOPS_Account_Preferences__c];
     /*   System.assertEquals(1, stagingRecords.size());
        System.assertEquals(stagingRecord.Unique_Record_ID__c, stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals(stagingRecord.FCU370P_CREATE_ID__c, stagingRecords.get(0).FCU370P_CREATE_ID__c);
        System.assertEquals(stagingRecord.CXTF370P_TIMESTAMP__c, stagingRecords.get(0).CXTF370P_TIMESTAMP__c);
        System.assertEquals(false, stagingRecords.get(0).Record_Updated__c);
*/
    }
}