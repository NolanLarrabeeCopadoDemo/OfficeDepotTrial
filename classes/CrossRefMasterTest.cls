@isTest
private class CrossRefMasterTest {
    @isTest
    static void getCrossRefRecordsTest() {
        Test.setMock(HttpCalloutMock.class, new CrossRefMasterMock('getResults'));
        Test.startTest();

        CrossRefMaster.getCrossRefRecords('1');
        Test.stopTest();
    }
    
    @isTest
    static void updateCrossRefRecordsTest() {
        Test.setMock(HttpCalloutMock.class, new CrossRefMasterMock('getResults'));
        Test.startTest();

        CrossRefMaster.updateCrossRefRecords('1');
        Test.stopTest();
    }
    
    @isTest
    static void deleteCrossRefRecordsTest() {
        Test.setMock(HttpCalloutMock.class, new CrossRefMasterMock('getResults'));
        Test.startTest();

        CrossRefMaster.deleteCrossRefRecords('1');
        Test.stopTest();
    }
    
    @isTest
    static void addCrossRefRecordsTest() {
        Test.setMock(HttpCalloutMock.class, new CrossRefMasterMock('getResults'));
        Test.startTest();

        CrossRefMaster.addCrossRefRecords('1');
        Test.setMock(HttpCalloutMock.class, new CrossRefMasterMock('getResultsWithDuplicateError'));
        CrossRefMaster.addCrossRefRecords('1');
        Test.setMock(HttpCalloutMock.class, new CrossRefMasterMock('getResultsUnconsumed'));
        CrossRefMaster.addCrossRefRecords('1');
        Test.setMock(HttpCalloutMock.class, new CrossRefMasterMock('getResultsNullConstraint'));
        CrossRefMaster.addCrossRefRecords('1');
        Test.stopTest();
    }
    
    @isTest
    static void getControlRecordsTest() {
        Test.setMock(HttpCalloutMock.class, new CrossRefMasterMock('getResults'));
        Test.startTest();

        CrossRefMaster.getControlRecords();
        Test.stopTest();
    }
    
    @isTest
    static void sendRefIdToProcessMasterTest() {
        Test.setMock(HttpCalloutMock.class, new CrossRefMasterMock('getResults'));
        Test.startTest();

        CrossRefMaster.sendRefIdToProcessMaster('1');
        Test.stopTest();
    }
    
    @isTest
    static void getErrorRecordsTest() {
        Test.setMock(HttpCalloutMock.class, new CrossRefMasterMock('getResults'));
        Test.startTest();

        CrossRefMaster.getErrorRecords('1');
        Test.stopTest();
    }
    @isTest
    static void saveFileTest() {
	
    	//Id idParent;
    	String strFileName;
        String base64Data;
        
        //idParent = new Id('TestId');
        strFileName = 'test.csv';
        base64Data = 'Test content here...';
        User owner          = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];
        CrossRefMaster.saveFile(strFileName, base64Data);        
    }
    
    @isTest
    static void addControlRecordTest() {
        Test.setMock(HttpCalloutMock.class, new CrossRefMasterMock('getResults'));
        Test.startTest();
        CrossRefMaster.ControlRecord record2 = new CrossRefMaster.ControlRecord(); 
        
        	
            record2.file_id = 'Test';
            record2.file_name = 'test';
            record2.file_source = 'Test';
            record2.status = '12';
            record2.created_by_id = '12';
            record2.sys_created_date = '12';
            record2.reference_id = 'xrefNotes';
            record2.resultLink = 'compSource';

        CrossRefMaster.addControlRecord(record2);
        Test.stopTest();
    }
    
    
}