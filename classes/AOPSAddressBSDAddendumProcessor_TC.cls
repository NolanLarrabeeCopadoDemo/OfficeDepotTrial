@IsTest
private class AOPSAddressBSDAddendumProcessor_TC {
    
    @IsTest
    static void insertRecord() {
        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTC009F_AOPS_KEY1', '12345678');
        aopsDataMap.put('CCU009F_CUSTOMER_ID', '12345678');
        aopsDataMap.put('CXTC009F_AOPS_KEY2', '90');
        aopsDataMap.put('CCU009F_ADDRESS_SEQ', '90');
        aopsDataMap.put('CCU009F_SALESPERSON_ID', 'Test2');
        aopsDataMap.put('CXTC009F_TIMESTAMP', '2020-03-30-01.03.14.3151');

        Test.startTest();
        AOPSAddressBSDAddendumProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Address_BSD_A__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU009F_SALESPERSON_ID__c, CXTC009F_TIMESTAMP__c, Record_Updated__c FROM AOPS_Address_BSD_A__c];
     /*   System.assertEquals(1, stagingRecords.size());
        System.assertEquals('1234567890', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('Test2', stagingRecords.get(0).CCU009F_SALESPERSON_ID__c);
        System.assertEquals('2020-03-30-01.03.14.3151', stagingRecords.get(0).CXTC009F_TIMESTAMP__c);
        System.assertEquals(true, stagingRecords.get(0).Record_Updated__c);
*/
    }

    @IsTest
    static void updateRecord() {
        AOPS_Address_BSD_A__c stagingRecord = new AOPS_Address_BSD_A__c(Unique_Record_ID__c='1234567890', CCU009F_SALESPERSON_ID__c='Test1', CXTC009F_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTC009F_AOPS_KEY1', '12345678');
        aopsDataMap.put('CCU009F_CUSTOMER_ID', '12345678');
        aopsDataMap.put('CXTC009F_AOPS_KEY2', '90');
        aopsDataMap.put('CCU009F_ADDRESS_SEQ', '90');
        aopsDataMap.put('CCU009F_SALESPERSON_ID', 'Test2');
        aopsDataMap.put('CXTC009F_TIMESTAMP', '2020-03-31-01.03.14.3151');

        Test.startTest();
        AOPSAddressBSDAddendumProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Address_BSD_A__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU009F_SALESPERSON_ID__c, CXTC009F_TIMESTAMP__c, Record_Updated__c FROM AOPS_Address_BSD_A__c];
      /*  System.assertEquals(1, stagingRecords.size());
        System.assertEquals('1234567890', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('Test2', stagingRecords.get(0).CCU009F_SALESPERSON_ID__c);
        System.assertEquals('2020-03-31-01.03.14.3151', stagingRecords.get(0).CXTC009F_TIMESTAMP__c);
        System.assertEquals(true, stagingRecords.get(0).Record_Updated__c);
*/
    }

    @IsTest
    static void oldRecordOnUpdate() {
        AOPS_Address_BSD_A__c stagingRecord = new AOPS_Address_BSD_A__c(Unique_Record_ID__c='1234567890', CCU009F_SALESPERSON_ID__c='Test1', CXTC009F_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTC009F_AOPS_KEY1', '12345678');
        aopsDataMap.put('CCU009F_CUSTOMER_ID', '12345678');
        aopsDataMap.put('CXTC009F_AOPS_KEY2', '90');
        aopsDataMap.put('CCU009F_ADDRESS_SEQ', '90');
        aopsDataMap.put('CCU009F_SALESPERSON_ID', 'Test2');
        aopsDataMap.put('CXTC009F_TIMESTAMP', '2020-03-29-01.03.14.3151');

        Test.startTest();
        AOPSAddressBSDAddendumProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Address_BSD_A__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU009F_SALESPERSON_ID__c, CXTC009F_TIMESTAMP__c, Record_Updated__c FROM AOPS_Address_BSD_A__c];
      /*  System.assertEquals(1, stagingRecords.size());
        System.assertEquals(stagingRecord.Unique_Record_ID__c, stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals(stagingRecord.CCU009F_SALESPERSON_ID__c, stagingRecords.get(0).CCU009F_SALESPERSON_ID__c);
        System.assertEquals(stagingRecord.CXTC009F_TIMESTAMP__c, stagingRecords.get(0).CXTC009F_TIMESTAMP__c);
        System.assertEquals(false, stagingRecords.get(0).Record_Updated__c);
*/
    }
}