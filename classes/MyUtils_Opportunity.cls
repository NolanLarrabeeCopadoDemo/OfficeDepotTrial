/**
* @author Adam Albright, adam.albright@officedepot.com
* @date 3/4/2018
*
* @group Utility
* @group-content /ApexDocContent/Index.htm
*
* @description This is a general utility class for opportunities.
*
*/
public class MyUtils_Opportunity {

	private static Id BizBoxRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity(BizBox)').getRecordTypeId();
	//private static Id BusProRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity (Business Pro)').getRecordTypeId();

	/*******************************************************************************************************
    * @description gets the BizBox RecordTypeId
    * Returns the BizBox RecordTypeId
    */
	public static Id BizBoxRecordTypeId {
		get {return BizBoxRecordType;}
	}

	/*******************************************************************************************************
    * @description gets the BizBox RecordTypeId
    * Returns the BizBox RecordTypeId

	public static Id BusProRecordTypeId {
		get {return BusProRecordType;}
	} */
}