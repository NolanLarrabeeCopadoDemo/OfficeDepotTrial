@IsTest
private class AOPSAccountChildParentRelProcessor_TC {
    
    @IsTest
    static void insertRecord() {
        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTF005P_AOPS_KEY1', '12345678');
        aopsDataMap.put('FCU005P_PARENT_ID', 'Test2');
        aopsDataMap.put('CXTF005P_TIMESTAMP', '2020-03-30-01.03.14.3151');

        Test.startTest();
        AOPSAccountChildParentRelProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Account_Child_Parent_Relationship__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, FCU005P_PARENT_ID__c, CXTF005P_TIMESTAMP__c, Record_Updated__c FROM AOPS_Account_Child_Parent_Relationship__c];
      /*  System.assertEquals(1, stagingRecords.size());
        System.assertEquals('12345678', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('Test2', stagingRecords.get(0).FCU005P_PARENT_ID__c);
        System.assertEquals('2020-03-30-01.03.14.3151', stagingRecords.get(0).CXTF005P_TIMESTAMP__c);
        System.assertEquals(true, stagingRecords.get(0).Record_Updated__c);
*/
    }

    @IsTest
    static void updateRecord() {
        AOPS_Account_Child_Parent_Relationship__c stagingRecord = new AOPS_Account_Child_Parent_Relationship__c(Unique_Record_ID__c='12345678', FCU005P_PARENT_ID__c='Test1', CXTF005P_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTF005P_AOPS_KEY1', '12345678');
        aopsDataMap.put('FCU005P_PARENT_ID', 'Test2');
        aopsDataMap.put('CXTF005P_TIMESTAMP', '2020-03-31-01.03.14.3151');

        Test.startTest();
        AOPSAccountChildParentRelProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Account_Child_Parent_Relationship__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, FCU005P_PARENT_ID__c, CXTF005P_TIMESTAMP__c, Record_Updated__c FROM AOPS_Account_Child_Parent_Relationship__c];
    /*    System.assertEquals(1, stagingRecords.size());
        System.assertEquals('12345678', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('Test2', stagingRecords.get(0).FCU005P_PARENT_ID__c);
        System.assertEquals('2020-03-31-01.03.14.3151', stagingRecords.get(0).CXTF005P_TIMESTAMP__c);
        System.assertEquals(true, stagingRecords.get(0).Record_Updated__c);
*/
    }

    @IsTest
    static void oldRecordOnUpdate() {
        AOPS_Account_Child_Parent_Relationship__c stagingRecord = new AOPS_Account_Child_Parent_Relationship__c(Unique_Record_ID__c='12345678', FCU005P_PARENT_ID__c='Test1', CXTF005P_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTF005P_AOPS_KEY1', '12345678');
        aopsDataMap.put('FCU005P_PARENT_ID', 'Test2');
        aopsDataMap.put('CXTF005P_TIMESTAMP', '2020-03-29-01.03.14.3151');

        Test.startTest();
        AOPSAccountChildParentRelProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Account_Child_Parent_Relationship__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, FCU005P_PARENT_ID__c, CXTF005P_TIMESTAMP__c, Record_Updated__c FROM AOPS_Account_Child_Parent_Relationship__c];
    /*    System.assertEquals(1, stagingRecords.size());
        System.assertEquals(stagingRecord.Unique_Record_ID__c, stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals(stagingRecord.FCU005P_PARENT_ID__c, stagingRecords.get(0).FCU005P_PARENT_ID__c);
        System.assertEquals(stagingRecord.CXTF005P_TIMESTAMP__c, stagingRecords.get(0).CXTF005P_TIMESTAMP__c);
        System.assertEquals(false, stagingRecords.get(0).Record_Updated__c);
*/
    }
}