/**
* @author Adam Albright, adam.albright@officedepot.com
* @date 3/3/2018
*
* @group Utility
* @group-content /ApexDocContent/Index.htm
*
* @description This is a general utility class for Account Objects. 
*
* @coverage MyUtils_Test
*/
public class MyUtils_Account {
	private static Id BizBoxProspectRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect (BizBox)').getRecordTypeId();
	private static Id BizBoxCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer(BizBox)').getRecordTypeId();
	private static Id BusProCustomerRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (Business Pro)').getRecordTypeId();
	private static Id ProspectRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
	private static Id SiteRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();

	/*******************************************************************************************************
    * @description gets the BizBox Prospect RecordTypeId
    * Returns the BizBox RecordTypeId
    */
	public static Id BizBoxProspectRecordTypeId {
		get {return BizBoxProspectRecordType;}
	}

	/*******************************************************************************************************
    * @description gets the Business Pro Customer RecordTypeId
    * Returns the BizBox RecordTypeId
    */
	public static Id BizBoxCustomerRecordTypeId {
		get {return BizBoxCustomerRecordType;}
	}

	/*******************************************************************************************************
	* @description gets the Business Pro Customer RecordTypeId
	* Returns the BizBox RecordTypeId
	*/
	public static Id BusProCustomerRecordTypeId {
		get {return BusProCustomerRecordType;}
	}

	/*******************************************************************************************************
    * @description gets the ProspectRecordTypeId
    * Returns the ProspectRecordTypeId
    */
	public static Id ProspectRecordTypeId {
		get {return ProspectRecordType;}
	}

	/*******************************************************************************************************
	* @description gets the Account Site RecordTypeId
	* Returns the Account Site RecordTypeId
	*/
	public static Id SiteRecordTypeId {
		get {return SiteRecordType;}
	}

	/*******************************************************************************************************
	 * @author Adam Albright, adam.albright@officedepot.com
	 * @date 05-December-2018
	 *
	 * @description Retrieves the pricing template values for the account object
	 * @param None
	 *
	 */
	public static List<String> AccountPricingTemplates(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult accountPricingTemplates = Account.Pricing_template_cd__c.getDescribe();
        List<Schema.PicklistEntry> pickListValues = accountPricingTemplates.getPicklistValues();
        for( Schema.PicklistEntry entry : pickListValues) {
            options.add(entry.getValue());
        }       
        return options;
    }
}