/**
* @author Adam Albright, adam.albright@officedepot.com
* @date 2/20/2018
*
* @group Overrides
* @group-content /ApexDocContent/Index.htm
*
* @description This is a lightning override for bypassing the visual force page we have used to override several buttons in classic.
*
*/
public class Lead_Override {
	@auraEnabled
	public static String getRecordTypenameFromID(String RecordTypeID){
		RecordType myRecord = [SELECT Id, Name, DeveloperName FROM RecordType WHERE Id=:RecordTypeID];
		return myRecord.name + '?' + myRecord.DeveloperName;
	}

}