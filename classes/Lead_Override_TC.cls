/**
 * Created by Adam on 3/6/2018.
 */
@IsTest
public class Lead_Override_TC {

	@IsTest
	static void TestRecordType(){
		String Result;
		Test.startTest();
		Result = Lead_Override.getRecordTypenameFromID(MyUtils_Lead.BizBoxRecordTypeId);
		Test.stopTest();

		System.assert(Result =='Lead (BizBox)?Lead_BizBox', 'Retrieval Failed' );
	}
}