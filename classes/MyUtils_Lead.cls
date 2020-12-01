/**
* @author Adam Albright, adam.albright@officedepot.com
* @date 3/3/2018
*
* @group Utility
* @group-content /ApexDocContent/Index.htm
*
* @description This is a general utility class for generating individual or collections of leads.
*
* TODO: Set up converted lead generation.
*/
public class MyUtils_Lead {
	/**
	* @author Adam Albright, adam.albright@officedepot.com
	* @date 3/3/2018
	* @group Exceptions
	* @group-content /ApexDocContent/Index.htm
	* @description This is a Exception class for generating useful error messages of lead generation.
	*/
	public class LeadGenerationException extends Exception{}
	public class LeadConversionException extends Exception {}
	public class NonConvertedLeadException extends Exception{
		public NonConvertedLeadException(Lead NonConvertedLead){
			System.debug(LoggingLevel.ERROR, 'This Action can only be called on converted leads. Lead '
					+ NonConvertedLead.Id
					+ ' does not appear to be converted.');
		}
	}
	public class ConvertedLeadException extends Exception{
		public ConvertedLeadException(Lead ConvertedLead){
		System.debug(LoggingLevel.ERROR, 'This Action can only be called on nonconverted leads. Lead '
				+ ConvertedLead.Id
				+ ' appears to already be converted.');
	}
	}

	private static Id BizBoxRecordType = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead (BizBox)').getRecordTypeId();
	private static Id BusProRecordType = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead (Business Pro)').getRecordTypeId();
	//private static Id PartnerRecordType = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead (Partner)').getRecordTypeId();


	/*******************************************************************************************************
    * @description gets the BizBox RecordTypeId
    * Returns the BizBox RecordTypeId
    */
	public static Id BizBoxRecordTypeId {
		get {return BizBoxRecordType;}
	}

	/*******************************************************************************************************
    * @description gets the Business Pro Lead RecordTypeId
    * Returns the Business Pro RecordTypeId
    */
	public static Id BusProRecordTypeId {
		get {return BusProRecordType;}
	}

	/*******************************************************************************************************
    * @description gets the Partner Lead RecordTypeId
    * Returns the Partner RecordTypeId

	public static Id PartnerRecordTypeId {
		get {return PartnerRecordType;}
	}
	*/
	// Create Leads
	/*******************************************************************************************************
    * @description Creates Standard Leads a specified RecordType and owner. Owner can be null in which the current user will
    * used instead.
    * @param RecordTypeId is the type of lead to be gererated.
    * @param OwnerId is the Id of the User Object that the leads will be assigned to. if null is passed, the current system user will be assigned.
    * @param Count is the numbers of leads to be generated. It must be a positive non-zero number.
    * @return A list of leads of the specified record type is returned.
    */
	public static List<Lead> GenerateLeads(Id RecordTypeId, Id OwnerId, Integer Count, Boolean isConverted){
		Id UserID;

		// Set OwnerId for Leads
		try{
			if(OwnerId == null)
				throw new LeadGenerationException('No Owner ID Specified. Using Current System User.');
			UserID = OwnerId;
		}catch (LeadGenerationException e) {
			System.debug(LoggingLevel.INFO, 'Message: ' + e.getMessage());
			UserID = System.UserInfo.getUserId();
		}

		// Cannot generate negative leads.
		if(Count<=0)
			throw new LeadGenerationException('Count must be greater than 0');

		if(RecordTypeId==null)
			throw new LeadGenerationException('RecordTypeId must be specified and cannot be not null.');

		// TODO: Replace with Switch when it comes out in Summer 18 release.
		if (RecordTypeId == BizBoxRecordTypeId){
			return GenerateBizBoxLeads(OwnerId, Count, isConverted);
		}else if(RecordTypeId == BusProRecordTypeId){
			return GenerateBusProLeads(OwnerId, Count, isConverted);
		//}else if(RecordTypeId == PartnerRecordTypeId){
		//	return GeneratePartnerLeads(OwnerId, Count, isConverted);
		}else{
			throw new LeadGenerationException('The Lead RecordType Specified is not currently available for generation yet. Try Implementing it in MyUtils_Lead');
		}
	}

	/*******************************************************************************************************
    * @description Generates a list of BizBox Leads Owned by the user of the specified ownerID. BizBox Leads require Email,
    * Lastname, a Phone number, and company name for conversion. Products__c is a semicolon delimited string of values from the Products__c picklist field.
    * @param RecordTypeId is the type of lead to be generated.
    * @param OwnerId is the Id of the User Object that the leads will be assigned to. if null is passed, the current system user will be assigned.
    * @param Count is the numbers of Biz Box Leads to be generated. It must be a positive non-zero number.
    * @return A list of BizBox Leads.
    */
	public static list<Lead> GenerateBizBoxLeads(Id OwnerId, Integer Count, Boolean Converted){

		if(OwnerId==null)
			throw new LeadGenerationException('OwnerId must be specified.');
		if(Count<=0)
			throw new LeadGenerationException('Count must be a positive non-zero number.');

		List<Lead> BizBoxLeads = new List<Lead>();
		for(Integer i = 0; i < Count; i++){
			BizBoxLeads.add(
							// Fields Required for conversion include
					new Lead(
							FirstName ='Gen_Lead_First_Name_' + i,
							LastName ='Gen_Lead_Last_Name_' + i,
							Company = 'The BizBox Company_' + i,
							Email = 'MyBBoxLead'+i+'@Email.Com',
							Phone = '1092837364',
							RecordTypeId = BizBoxRecordTypeId,
							OwnerId = OwnerId,
							Products__c = 'Social_Media_Marketing;Pay_Per_Click_Marketing',
							IsConverted = Converted,
							Comments__c ='These are some Comments!'));
		}
		return BizBoxLeads;
	}


	/*******************************************************************************************************
    * @description Generates a list of Business Pro Leads Owned by the user of the specified ownerID.
    * @param RecordTypeId is the type of lead to be generated.
    * @param OwnerId is the Id of the User Object that the leads will be assigned to. If null is passed, the current system user will be assigned.
    * @param Count is the numbers of Business Pro Leads to be generated. It must be a positive non-zero number.
    * @return A list of Business Pro Leads.
    */
	public static list<Lead> GenerateBusProLeads(Id OwnerId, Integer Count, Boolean Converted){

		if(OwnerId==null)
			throw new LeadGenerationException('OwnerId must be specified.');
		if(Count<=0)
			throw new LeadGenerationException('Count must be a positive non-zero number.');

		List<Lead> BisProLeads = new List<Lead>();
		for(Integer i = 0; i < Count; i++){
			BisProLeads.add(
					new Lead(
							FirstName ='Gen_Lead_First_Name_' + i,
							LastName ='Gen_Lead_Last_Name_' + i,
							Company = 'The BisPro Company_' + i,
							Email = 'MyBProLead'+i+'@Email.Com',
							Phone = '1092837364',
							RecordTypeId = BusProRecordTypeId,
							OwnerId = OwnerId,
							Business_Pro_Loyalty_Account_Number__c = '0'+ i +'a'+ i+'1'+ Datetime.now().millisecond(),
							IsConverted = Converted));
		}
		return BisProLeads;
	}

	// TODO: Get Deepak to set this up.
	/*******************************************************************************************************
    * @description Generates a list of Partner Leads Owned by the user of the specified ownerID.
    * @param RecordTypeId is the type of lead to be generated.
    * @param OwnerId is the Id of the User Object that the leads will be assigned to. If null is passed, the current system user will be assigned.
    * @param Count is the numbers of Business Pro Leads to be generated. It must be a positive non-zero number.
    * @return A list of Partner Leads.

	public static list<Lead> GeneratePartnerLeads(Id OwnerId, Integer Count, Boolean Converted){

		if(OwnerId==null)
			throw new LeadGenerationException('OwnerId must be specified.');
		if(Count<=0)
			throw new LeadGenerationException('Count must be a positive non-zero number.');

		List<Lead> PartnerLeads = new List<Lead>();
		for(Integer i = 0; i < Count; i++){
			PartnerLeads.add(
					new Lead(
							FirstName ='Gen_Lead_First_Name_' + i,
							LastName ='Gen_Lead_Last_Name_' + i,
							Company = 'The Partner Company_' + i,
							Email = 'MyPartner'+i+'@Email.Com',
							Phone = '1092837364',
							RecordTypeId = PartnerRecordType,
							OwnerId = OwnerId,
							IsConverted = Converted));
		}
		return PartnerLeads;
	} */
}