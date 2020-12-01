/**
* @author Adam Albright, adam.albright@officedepot.com
* @date 3/4/2018
*
* @group Lead Conversion
* @group-content /ApexDocContent/Index.htm
*
* @description This Class Converts a Lead with a RecordType of 'Lead (Business Pro)'. If a Lead with an incorrect
* RecordType is passed, an exception is thrown.
*
*/
public class Convert_Lead_BusPro {
	private static Id AcceptedRecordType = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Lead (Business Pro)').getRecordTypeId();

	/*******************************************************************************************************
	* @description The RecordTypeID this class will accept.
	* returns RecordTypeID for Biz Box Leads
	*/
	public static Id AcceptedRecordTypeId {
		get {return AcceptedRecordType;}
	}


	public static Map<String, sObject> ConvertLead(Lead UnconvertedLead){
		if(UnconvertedLead.IsConverted)
			throw new MyUtils_Lead.ConvertedLeadException(UnconvertedLead);

		if(UnconvertedLead==null){
			System.debug(LoggingLevel.ERROR, 'Lead Cannot be Null');
			throw new NullPointerException();
		}


		// TODO: Convert Ready Check Here
		Map<String, sObject> UpdateList = new Map<String, sObject>();
		Boolean Converted = false;
		Id LeadId = UnconvertedLead.Id;
		Id OldOwnerId = UnconvertedLead.OwnerId;
		try{
			Converted = ConvertLeadAndGetResult(UnconvertedLead.Id, MyUtils.SuperUser_BusPro().Id);
		}catch(DmlException e){
			System.debug(LoggingLevel.ERROR, 'Lead Conversion Failed.');
			throw new MyUtils_Lead.LeadConversionException(e.getMessage(), e);
		}
		Lead ConvertedLead;
		Account GeneratedAccount;
		Contact GeneratedContact;
		if(Converted){
			// TODO: Add the Missing Fields.
			ConvertedLead = [SELECT
					Id,
					OwnerId,
					ConvertedContactId,
					ConvertedAccountId,
					Products__c,
					IsConverted,
					LeadSource,
					Decision_Maker__c,
					Amount__c,
					Campaign_Source_URL__c,
					WCW_Count__c,
					Marketing_Opt_In__c,
					Address1__c,
					Address2__c,
					City__c,
					State__c,
					Zip__c,
					Country__c,
					Business_Pro_Loyalty_Account_Number__c,
					Comments__c FROM Lead WHERE Id=:LeadId LIMIT 1];

			GeneratedAccount = [SELECT
					Id,
					Name,
					OwnerId,
					RecordTypeId,
					Loyatly_Number__c,
					Campaign_Source_URL__c,
					Org_WCW_Count_Rep__c,
					Address1__c,
					Address2__c,
					City__c,
					State__c,
					Zip__c,
					Country__c FROM Account WHERE Id=:ConvertedLead.ConvertedAccountId LIMIT 1];

			GeneratedContact = [SELECT
					Id,
					Name,
					OwnerId,
					RecordTypeId,
					Decision_Maker__c,
					BizBox_Marketing_OptIn__c,
					MailingStreet,
					MailingCity,
					MailingState,
					MailingPostalCode,
					MailingCountry FROM Contact WHERE Id=:ConvertedLead.ConvertedContactId LIMIT 1];

			// Account
			//GeneratedAccount.Opportunity_Amt__c = ConvertedLead.Amount__c;
			GeneratedAccount.OwnerId = OldOwnerId;
			GeneratedAccount.Address1__c = ConvertedLead.Address1__c;
			GeneratedAccount.Address2__c = ConvertedLead.Address2__c;
			GeneratedAccount.City__c = ConvertedLead.City__c;
			GeneratedAccount.State__c = ConvertedLead.State__c;
			GeneratedAccount.Zip__c = ConvertedLead.Zip__c;
			GeneratedAccount.Country__c = ConvertedLead.Country__c;
			GeneratedAccount.Status__c = 'Active';

			GeneratedAccount.Org_WCW_Count_Rep__c = ConvertedLead.WCW_Count__c;
			GeneratedAccount.RecordTypeId = MyUtils_Account.BusProCustomerRecordTypeId;
			GeneratedAccount.Loyatly_Number__c = ConvertedLead.Business_Pro_Loyalty_Account_Number__c;
			GeneratedAccount.Campaign_Source_URL__c = ConvertedLead.Campaign_Source_URL__c;

			// Contact
			GeneratedContact.Decision_Maker__c = ConvertedLead.Decision_Maker__c;
			GeneratedContact.OwnerId = OldOwnerId;
			GeneratedContact.RecordTypeId = MyUtils_Contact.BusProContactRecordTypeId;
			GeneratedContact.MailingStreet = ConvertedLead.Address1__c +', ' + ConvertedLead.Address2__c;
			GeneratedContact.MailingCity = ConvertedLead.City__c;
			GeneratedContact.MailingState = ConvertedLead.State__c;
			GeneratedContact.MailingPostalCode = ConvertedLead.Zip__c;
			GeneratedContact.MailingCountry = ConvertedLead.Country__c;




			UpdateList.put('Account', GeneratedAccount);
			UpdateList.put('Contact', GeneratedContact);


			update UpdateList.values();
			//UpdateList.put('Note', myNote);

			return UpdateList;
		}
		return null;
	}

	//Convert Lead
	/*******************************************************************************************************
    * @description Gets the RecordType Id this will accept for the conversion.
    * @param myLead the Id of the lead we want ot convert.
    * @return The RecordType Id this class will accept.
    */
	public static Boolean ConvertLeadAndGetResult(Id myLead, Id UserId){

		Database.LeadConvert lc = new Database.LeadConvert();
		lc.setDoNotCreateOpportunity(true);
		lc.setOwnerId(System.UserInfo.getUserId());
		lc.setLeadId(myLead);
		// Might need to switch the lead status.
		LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
		lc.setConvertedStatus(convertStatus.MasterLabel);
		try{
			Database.LeadConvertResult lcr = Database.convertLead(lc);
			return lcr.isSuccess();
		}catch(DmlException e){
			System.debug('Message: ' + e.getMessage());
			System.debug('Cause: ' + e.getCause());
			System.debug('Line number: ' + e.getLineNumber());
			throw new MyUtils_Lead.LeadConversionException(e.getMessage(), e);
		}

		return false;
	}

}