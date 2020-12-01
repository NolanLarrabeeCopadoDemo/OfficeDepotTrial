/**
* @author Adam Albright, adam.albright@officedepot.com
* @date 3/3/2018
*
* @group Utility
* @group-content /ApexDocContent/Index.htm
*
* @description This is a general utility class for Contact Objects.
*
*/
public class MyUtils_Contact {
	private static Id BizBoxContactRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact(BizBox)').getRecordTypeId();
	private static Id BusProContactRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact (Business Pro)').getRecordTypeId();

	/*******************************************************************************************************
    * @description gets the BizBox Contact RecordTypeId
    * Returns the BizBox RecordTypeId
    */
	public static Id BizBoxContactRecordTypeId {
		get {return BizBoxContactRecordType;}
	}

	/*******************************************************************************************************
    * @description gets the Business Pro Contact RecordTypeId
    * Returns the BizBox RecordTypeId
    */
	public static Id BusProContactRecordTypeId {
		get {return BusProContactRecordType;}
	}
}