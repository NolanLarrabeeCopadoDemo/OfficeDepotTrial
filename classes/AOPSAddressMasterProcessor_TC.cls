@IsTest
private class AOPSAddressMasterProcessor_TC {
    
    @IsTest
    static void insertRecord() {
        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTF001P_AOPS_KEY1', '12345678');
        aopsDataMap.put('CXTF001P_AOPS_KEY2', '90');
        aopsDataMap.put('FCU001P_BUSINESS_NAME', 'Test2');
        aopsDataMap.put('CXTF001P_TIMESTAMP', '2020-03-30-01.03.14.3151');

        Test.startTest();
        AOPSAddressMasterProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Address_Master__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, FCU001P_BUSINESS_NAME__c, CXTF001P_TIMESTAMP__c, Record_Updated__c FROM AOPS_Address_Master__c];
     /*   System.assertEquals(1, stagingRecords.size());
        System.assertEquals('1234567890', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('Test2', stagingRecords.get(0).FCU001P_BUSINESS_NAME__c);
        System.assertEquals('2020-03-30-01.03.14.3151', stagingRecords.get(0).CXTF001P_TIMESTAMP__c);
        System.assertEquals(true, stagingRecords.get(0).Record_Updated__c);
*/
    }

    @IsTest
    static void updateRecord() {
        AOPS_Address_Master__c stagingRecord = new AOPS_Address_Master__c(Unique_Record_ID__c='1234567890', FCU001P_BUSINESS_NAME__c='Test1', CXTF001P_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTF001P_AOPS_KEY1', '12345678');
        aopsDataMap.put('CXTF001P_AOPS_KEY2', '90');
        aopsDataMap.put('FCU001P_BUSINESS_NAME', 'Test2');
        aopsDataMap.put('CXTF001P_TIMESTAMP', '2020-03-31-01.03.14.3151');

        Test.startTest();
        AOPSAddressMasterProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Address_Master__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, FCU001P_BUSINESS_NAME__c, CXTF001P_TIMESTAMP__c, Record_Updated__c FROM AOPS_Address_Master__c];
      /*  System.assertEquals(1, stagingRecords.size());
        System.assertEquals('1234567890', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('Test2', stagingRecords.get(0).FCU001P_BUSINESS_NAME__c);
        System.assertEquals('2020-03-31-01.03.14.3151', stagingRecords.get(0).CXTF001P_TIMESTAMP__c);
        System.assertEquals(true, stagingRecords.get(0).Record_Updated__c);
*/
    }

    @IsTest
    static void oldRecordOnUpdate() {
        AOPS_Address_Master__c stagingRecord = new AOPS_Address_Master__c(Unique_Record_ID__c='1234567890', FCU001P_BUSINESS_NAME__c='Test1', CXTF001P_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTF001P_AOPS_KEY1', '12345678');
        aopsDataMap.put('CXTF001P_AOPS_KEY2', '90');
        aopsDataMap.put('FCU001P_BUSINESS_NAME', 'Test2');
        aopsDataMap.put('CXTF001P_TIMESTAMP', '2020-03-29-01.03.14.3151');

        Test.startTest();
        AOPSAddressMasterProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Address_Master__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, FCU001P_BUSINESS_NAME__c, CXTF001P_TIMESTAMP__c, Record_Updated__c FROM AOPS_Address_Master__c];
   /*     System.assertEquals(1, stagingRecords.size());
        System.assertEquals(stagingRecord.Unique_Record_ID__c, stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals(stagingRecord.FCU001P_BUSINESS_NAME__c, stagingRecords.get(0).FCU001P_BUSINESS_NAME__c);
        System.assertEquals(stagingRecord.CXTF001P_TIMESTAMP__c, stagingRecords.get(0).CXTF001P_TIMESTAMP__c);
        System.assertEquals(false, stagingRecords.get(0).Record_Updated__c);
*/
    }
}