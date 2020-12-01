@IsTest

public class AOPSContactEmailProcessor_TC {
    
    @IsTest
    static void insertRecord() {
        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTCNTE_AOPS_KEY1', '123');
        aopsDataMap.put('CXTCNTE_AOPS_KEY2', '456');
        aopsDataMap.put('CXTCNTE_AOPS_KEY3', '789');
		aopsDataMap.put('CXTCNTE_TIMESTAMP', '2020-03-30-01.03.14.3151');
		aopsDataMap.put('CCU340F_CONTACT_ID', '123457');
		aopsDataMap.put('CCU340F_INTERNET_TYPE', 'WEM');
		aopsDataMap.put('CCU340F_ADDRESS', 'test@test.com');
		aopsDataMap.put('CCU340F_CONTACT_DFT_INTERNET', 'Y');
		aopsDataMap.put('CCU340F_USER_ROLE', '*PRIMARY');
		aopsDataMap.put('CCU340F_ADDRESS_SEQ', '154376637');

        Test.startTest();
        AOPSContactEmailProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Contact_Email__c> stagingRecords = [SELECT Id, Unique_Record_ID__c FROM AOPS_Contact_Email__c];
        /*System.assertEquals(1, stagingRecords.size());
        System.assertEquals('123456789', stagingRecords.get(0).Unique_Record_ID__c);*/
    }

    @IsTest
    static void updateRecord() {
        AOPS_Contact_Email__c stagingRecord = new AOPS_Contact_Email__c(Unique_Record_ID__c='12345678', CCU340F_EMAIL_OUT_TYPE__c ='HTML', CXTCNTE_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTCNTE_AOPS_KEY1', '123');
        aopsDataMap.put('CXTCNTE_AOPS_KEY2', '456');
        aopsDataMap.put('CXTCNTE_AOPS_KEY3', '789');
        aopsDataMap.put('CCU340F_EMAIL_OUT_TYPE', 'TEXT');
		aopsDataMap.put('CXTCNTE_TIMESTAMP', '2020-03-31-01.03.14.3151');
		aopsDataMap.put('CCU340F_CONTACT_ID', '5463524');
		aopsDataMap.put('CCU340F_INTERNET_TYPE', 'WEM');
		aopsDataMap.put('CCU340F_ADDRESS', 'test@test.com');
		aopsDataMap.put('CCU340F_CONTACT_DFT_INTERNET', 'Y');
		aopsDataMap.put('CCU340F_USER_ROLE', '*PRIMARY');
		aopsDataMap.put('CCU340F_ADDRESS_SEQ', '154376638');

        Test.startTest();
        AOPSContactEmailProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Contact_Email__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU340F_EMAIL_OUT_TYPE__c, CXTCNTE_TIMESTAMP__c FROM AOPS_Contact_Email__c];
        /*System.assertEquals(1, stagingRecords.size());
        System.assertEquals('123456789', stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals('TEXT', stagingRecords.get(0).CCU340F_EMAIL_OUT_TYPE__c);
        System.assertEquals('2020-03-31-01.03.14.3151', stagingRecords.get(0).CXTCNTE_TIMESTAMP__c);*/
    }

    @IsTest
    static void oldRecordOnUpdate() {
        AOPS_Contact_Email__c stagingRecord = new AOPS_Contact_Email__c(Unique_Record_ID__c='12345678', CCU340F_EMAIL_OUT_TYPE__c='HTML', CXTCNTE_TIMESTAMP__c='2020-03-30-01.03.14.3151');
        insert stagingRecord;

        Map<String, Object> aopsDataMap = new Map<String, Object>();
        aopsDataMap.put('CXTCNTE_AOPS_KEY1', '123');
        aopsDataMap.put('CXTCNTE_AOPS_KEY2', '456');
        aopsDataMap.put('CXTCNTE_AOPS_KEY3', '789');
        aopsDataMap.put('CCU340F_EMAIL_OUT_TYPE', 'TEXT');
		aopsDataMap.put('CXTCNTE_TIMESTAMP', '2020-03-29-01.03.14.3151');
		aopsDataMap.put('CCU340F_CONTACT_ID', '7894561');
		aopsDataMap.put('CCU340F_INTERNET_TYPE', 'WEM');
		aopsDataMap.put('CCU340F_ADDRESS', 'test@test.com');
		aopsDataMap.put('CCU340F_CONTACT_DFT_INTERNET', 'Y');
		aopsDataMap.put('CCU340F_USER_ROLE', '*PRIMARY');
		aopsDataMap.put('CCU340F_ADDRESS_SEQ', '154376639');

        Test.startTest();
        AOPSContactEmailProcessor.process(aopsDataMap);
        Test.stopTest();

        List<AOPS_Contact_Email__c> stagingRecords = [SELECT Id, Unique_Record_ID__c, CCU340F_EMAIL_OUT_TYPE__c, CXTCNTE_TIMESTAMP__c FROM AOPS_Contact_Email__c];
     /*   System.assertEquals(1, stagingRecords.size());
        System.assertEquals(stagingRecord.Unique_Record_ID__c, stagingRecords.get(0).Unique_Record_ID__c);
        System.assertEquals(stagingRecord.CCU340F_EMAIL_OUT_TYPE__c, stagingRecords.get(0).CCU340F_EMAIL_OUT_TYPE__c);
        System.assertEquals(stagingRecord.CXTCNTE_TIMESTAMP__c, stagingRecords.get(0).CXTCNTE_TIMESTAMP__c);*/
    }
}