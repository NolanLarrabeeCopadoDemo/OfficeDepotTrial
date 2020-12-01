@isTest
public class ItemCrossRef_Test {
    
    @isTest
    static void saveFileTest() {
	
    	//Id idParent;
    	String strFileName;
        String base64Data;
        
        //idParent = new Id('TestId');
        strFileName = 'test.csv';
        base64Data = 'Test content here...';
        User owner          = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];
        ItemCrossRef.saveFile(owner.id , strFileName, base64Data);        
    }
    
    @isTest
    static void getControlRecordsByQuoteId_Test() {
	
    	//Id idParent;
    	String strFileName;
        String base64Data;
        
        //idParent = new Id('TestId');
        strFileName = 'test.csv';
        base64Data = 'Test content here...';
        User owner          = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];
        ItemCrossRef.getControlRecordsByQuoteId(owner.id);        
    }
    
    @isTest
    static void sendRefID() {
        Test.setMock(HttpCalloutMock.class, new ItemCrossRefMock('sendRefID'));
        Test.startTest();

        ItemCrossRef.sendRefIdToProcessMatch('1');
        Test.stopTest();
        
    } 
    
    /*
    @isTest
    static void addControlRecordTest() {
        Test.setMock(HttpCalloutMock.class, new ItemCrossRefMock('addControlRecord'));
        Test.startTest();
        ItemCrossRef.ControlRecord record1 = new ItemCrossRef.ControlRecord(); 
        
        	record1.quote_id = '1';
            record1.file_id = '2';
            record1.file_name = 'testfile';
            record1.file_source = 'Testsource';
            record1.status = 'testsource';
            record1.created_by_id = 'testuser';
            record1.sys_created_date = 'testdate';
            record1.reference_id = '101';
            record1.resultLink = 'testresult';
            record1.reason = 'testreason';
        ItemCrossRef.addControlRecord(record1);
        Test.stopTest();
    }
    
    
    @isTest
    static void getControlRecordsTest() {
        Test.setMock(HttpCalloutMock.class, new ItemCrossRefMock('getResults'));
        Test.startTest();

        ItemCrossRef.getControlRecordsByQuoteId('1');
        Test.stopTest();
    }

	@isTest
    static void sendRefID() {
        Test.setMock(HttpCalloutMock.class, new ItemCrossRefMock('sendRefID'));
        Test.startTest();

        ItemCrossRef.sendRefIdToProcessMatch('1');
        Test.stopTest();
        
    }     
    
    @isTest
    private static void testWrapper(){
        ItemCrossRef.ControlRecord record1 = new ItemCrossRef.ControlRecord(); 
        
        	record1.quote_id = '1';
            record1.file_id = '2';
            record1.file_name = 'testfile';
            record1.file_source = 'Testsource';
            record1.status = 'testsource';
            record1.created_by_id = 'testuser';
            record1.sys_created_date = 'testdate';
            record1.reference_id = '101';
            record1.resultLink = 'testresult';
            record1.reason = 'testreason';
    } 
*/

}