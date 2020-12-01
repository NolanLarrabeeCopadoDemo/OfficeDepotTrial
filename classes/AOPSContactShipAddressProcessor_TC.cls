@IsTest
private class AOPSContactShipAddressProcessor_TC {
    
    @IsTest
    static void insertRecord() {
        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTCNTS_AOPS_KEY1', '12345678');
        aopsDataMap.put('CXTCNTS_AOPS_KEY2', '90');
        aopsDataMap.put('CCU310F_CONTACT_ID', '90');
        aopsDataMap.put('CXTCNTS_AOPS_KEY3', '10');
        aopsDataMap.put('CCU310F_ADDR_SEQ', 'Test2');
        aopsDataMap.put('CXTCNTS_TIMESTAMP', '2020-03-30-01.03.14.3151');

        Test.startTest();
        AOPSContactShipAddressProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Contact_Ship_Address__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU310F_ADDR_SEQ__c, CXTCNTS_TIMESTAMP__c, Record_Updated__c FROM AOPS_Contact_Ship_Address__c];
        /*System.assertEquals(1, stagingRecords.size());
        System.assertEquals('123456789010', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('Test2', stagingRecords.get(0).CCU310F_ADDR_SEQ__c);
        System.assertEquals('2020-03-30-01.03.14.3151', stagingRecords.get(0).CXTCNTS_TIMESTAMP__c);
        System.assertEquals(true, stagingRecords.get(0).Record_Updated__c);*/
    }

    @IsTest
    static void updateRecord() {
        AOPS_Contact_Ship_Address__c stagingRecord = new AOPS_Contact_Ship_Address__c(Unique_Record_ID__c='123456789010', CCU310F_ADDR_SEQ__c='Test1', CXTCNTS_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTCNTS_AOPS_KEY1', '12345678');
        aopsDataMap.put('CXTCNTS_AOPS_KEY2', '90');
        aopsDataMap.put('CCU310F_CONTACT_ID', '90');
        aopsDataMap.put('CXTCNTS_AOPS_KEY3', '10');
        aopsDataMap.put('CCU310F_ADDR_SEQ', 'Test2');
        aopsDataMap.put('CXTCNTS_TIMESTAMP', '2020-03-31-01.03.14.3151');

        Test.startTest();
        AOPSContactShipAddressProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Contact_Ship_Address__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU310F_ADDR_SEQ__c, CXTCNTS_TIMESTAMP__c, Record_Updated__c FROM AOPS_Contact_Ship_Address__c];
        /*System.assertEquals(1, stagingRecords.size());
        System.assertEquals('123456789010', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('Test2', stagingRecords.get(0).CCU310F_ADDR_SEQ__c);
        System.assertEquals('2020-03-31-01.03.14.3151', stagingRecords.get(0).CXTCNTS_TIMESTAMP__c);
        System.assertEquals(true, stagingRecords.get(0).Record_Updated__c);*/
    }

    @IsTest
    static void oldRecordOnUpdate() {
        AOPS_Contact_Ship_Address__c stagingRecord = new AOPS_Contact_Ship_Address__c(Unique_Record_ID__c='123456789010', CCU310F_ADDR_SEQ__c='Test1', CXTCNTS_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTCNTS_AOPS_KEY1', '12345678');
        aopsDataMap.put('CXTCNTS_AOPS_KEY2', '90');
        aopsDataMap.put('CCU310F_CONTACT_ID', '90');
        aopsDataMap.put('CXTCNTS_AOPS_KEY3', '10');
        aopsDataMap.put('CCU310F_ADDR_SEQ', 'Test2');
        aopsDataMap.put('CXTCNTS_TIMESTAMP', '2020-03-29-01.03.14.3151');

        Test.startTest();
        AOPSContactShipAddressProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Contact_Ship_Address__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU310F_ADDR_SEQ__c, CXTCNTS_TIMESTAMP__c, Record_Updated__c FROM AOPS_Contact_Ship_Address__c];
        /*System.assertEquals(1, stagingRecords.size());
        System.assertEquals(stagingRecord.Unique_Record_ID__c, stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals(stagingRecord.CCU310F_ADDR_SEQ__c, stagingRecords.get(0).CCU310F_ADDR_SEQ__c);
        System.assertEquals(stagingRecord.CXTCNTS_TIMESTAMP__c, stagingRecords.get(0).CXTCNTS_TIMESTAMP__c);
        System.assertEquals(false, stagingRecords.get(0).Record_Updated__c);*/
    }
}