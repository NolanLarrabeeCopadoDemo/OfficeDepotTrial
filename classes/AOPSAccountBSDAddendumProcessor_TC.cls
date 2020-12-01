@IsTest
private class AOPSAccountBSDAddendumProcessor_TC {

    @IsTest
    static void insertRecord() {
        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTC007F_AOPS_KEY1', '12345678');
        aopsDataMap.put('CCU007F_REPORTING_CONTACT', 'Test2');
        aopsDataMap.put('CXTC007F_TIMESTAMP', '2020-03-30-01.03.14.3151');

        Test.startTest();
        AOPSAccountBSDAddendumProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Account_BSD_Addendum__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU007F_REPORTING_CONTACT__c, CXTC007F_TIMESTAMP__c, Record_Updated__c FROM AOPS_Account_BSD_Addendum__c];
      /*  System.assertEquals(1, stagingRecords.size());
        System.assertEquals('12345678', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('Test2', stagingRecords.get(0).CCU007F_REPORTING_CONTACT__c);
        System.assertEquals('2020-03-30-01.03.14.3151', stagingRecords.get(0).CXTC007F_TIMESTAMP__c);
        System.assertEquals(true, stagingRecords.get(0).Record_Updated__c); */
    }

    @IsTest
    static void updateRecord() {
        AOPS_Account_BSD_Addendum__c stagingRecord = new AOPS_Account_BSD_Addendum__c(Unique_Record_ID__c='12345678', CCU007F_REPORTING_CONTACT__c='Test1', CXTC007F_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTC007F_AOPS_KEY1', '12345678');
        aopsDataMap.put('CCU007F_REPORTING_CONTACT', 'Test2');
        aopsDataMap.put('CXTC007F_TIMESTAMP', '2020-03-31-01.03.14.3151');

        Test.startTest();
        AOPSAccountBSDAddendumProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Account_BSD_Addendum__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU007F_REPORTING_CONTACT__c, CXTC007F_TIMESTAMP__c, Record_Updated__c FROM AOPS_Account_BSD_Addendum__c];
     /*   System.assertEquals(1, stagingRecords.size());
        System.assertEquals('12345678', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('Test2', stagingRecords.get(0).CCU007F_REPORTING_CONTACT__c);
        System.assertEquals('2020-03-31-01.03.14.3151', stagingRecords.get(0).CXTC007F_TIMESTAMP__c);
        System.assertEquals(true, stagingRecords.get(0).Record_Updated__c); */
    }

    @IsTest
    static void oldRecordOnUpdate() {
        AOPS_Account_BSD_Addendum__c stagingRecord = new AOPS_Account_BSD_Addendum__c(Unique_Record_ID__c='12345678', CCU007F_REPORTING_CONTACT__c='Test1', CXTC007F_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTC007F_AOPS_KEY1', '12345678');
        aopsDataMap.put('CCU007F_REPORTING_CONTACT', 'Test2');
        aopsDataMap.put('CXTC007F_TIMESTAMP', '2020-03-29-01.03.14.3151');

        Test.startTest();
        AOPSAccountBSDAddendumProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Account_BSD_Addendum__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU007F_REPORTING_CONTACT__c, CXTC007F_TIMESTAMP__c, Record_Updated__c FROM AOPS_Account_BSD_Addendum__c];
    /*    System.assertEquals(1, stagingRecords.size());
        System.assertEquals(stagingRecord.Unique_Record_ID__c, stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals(stagingRecord.CCU007F_REPORTING_CONTACT__c, stagingRecords.get(0).CCU007F_REPORTING_CONTACT__c);
        System.assertEquals(stagingRecord.CXTC007F_TIMESTAMP__c, stagingRecords.get(0).CXTC007F_TIMESTAMP__c);
        System.assertEquals(false, stagingRecords.get(0).Record_Updated__c);
*/
    }
}