/**
* @author Adam Albright, adam.albright@officedepot.com
* @date 3/3/2018
*
* @group Lead Conversion
* @group-content /ApexDocContent/Index.htm
*
* @description This is a Test Class for verifying the proper behavior of the Convert_Lead_BizBox class.
*
*/
@IsTest
public class Convert_Lead_BizBox_TC {


	/*******************************************************************************************************
    * @description Verifies valid lead creation and conversion for Bix Box leads generated through
    * the MyUtils_Lead class and converted through the Convert_Lead_BizBox class.
    */
	@IsTest
	static void TestLeadConversionWithBizBoxUser(){
		List<Lead> TestLeads = MyUtils_Lead.GenerateLeads(MyUtils_Lead.BizBoxRecordTypeId, MyUtils.SuperUser_BizBox().Id, 1, false);
		Test.startTest();
			insert TestLeads;
			List<Lead> UnconvertedLeads = [
					SELECT 	Id,
							Name,
							Products__c,
							Phone,
							Business_Pro_Loyalty_Account_Number__c,
							RecordTypeId,
							OwnerId,
							Company,
							IsConverted FROM Lead WHERE Phone='1092837364'];

			for(Lead MyLead: UnconvertedLeads){
				Convert_Lead_BizBox.ConvertLead(MyLead);
			}

		Test.stopTest();

		TestLeads = [SELECT Id,
							Name,
							Products__c,
							Phone,
							Business_Pro_Loyalty_Account_Number__c,
							RecordTypeId,
							OwnerId,
							Company,
							IsConverted FROM Lead WHERE Phone='1092837364'];

		for(Lead ConvertedLead: TestLeads){
			System.assert(ConvertedLead.IsConverted);
			System.assert(ConvertedLead.RecordTypeId == MyUtils_Lead.BizBoxRecordTypeId, 'RecordType Mis-Match');
		}
	}

	/*******************************************************************************************************
* @description Verifies valid lead creation and conversion for Bix Box leads generated through
* the MyUtils_Lead class and converted through the Convert_Lead_BizBox class.
*/
	@IsTest
	static void TestLeadConversionWitNoProducts(){
		List<Lead> TestLeads = MyUtils_Lead.GenerateLeads(MyUtils_Lead.BizBoxRecordTypeId, MyUtils.SuperUser_BizBox().Id, 1, false);
		for(Lead myLead: TestLeads){
			myLead.Products__c ='';
		}

		Test.startTest();
		insert TestLeads;
		List<Lead> UnconvertedLeads = [
				SELECT 	Id,
				Name,
				Products__c,
				Phone,
				Business_Pro_Loyalty_Account_Number__c,
				RecordTypeId,
				OwnerId,
				Company,
				IsConverted FROM Lead WHERE Phone='1092837364'];

		for(Lead MyLead: UnconvertedLeads){
			Convert_Lead_BizBox.ConvertLead(MyLead);
		}

		Test.stopTest();

		TestLeads = [SELECT Id,
				Name,
				Products__c,
				Phone,
				Business_Pro_Loyalty_Account_Number__c,
				RecordTypeId,
				OwnerId,
				Company,
				IsConverted FROM Lead WHERE Phone='1092837364'];

		for(Lead ConvertedLead: TestLeads){
			System.assert(ConvertedLead.IsConverted);
			System.assert(ConvertedLead.RecordTypeId == MyUtils_Lead.BizBoxRecordTypeId, 'RecordType Mis-Match');
		}
	}

	/*******************************************************************************************************
    * @description Verifies the correct Account Record type after lead conversion.
    * the MyUtils_Lead class and converted through the Convert_Lead_BizBox class.
    */
	@IsTest
	static void VerifyAccountRecordTypeWithBizBoxUser(){
		List<Lead> TestLeads = MyUtils_Lead.GenerateBizBoxLeads(MyUtils.SuperUser_BizBox().Id, 1, false);
		Test.startTest();
		insert TestLeads;
		List<Lead> UnconvertedLeads = [
				SELECT 	Id,
				Name,
				Products__c,
				Phone,
				Business_Pro_Loyalty_Account_Number__c,
				RecordTypeId,
				OwnerId,
				Company,
				IsConverted FROM Lead WHERE Phone='1092837364'];

		for(Lead MyLead: UnconvertedLeads){
			Convert_Lead_BizBox.ConvertLead(MyLead);
		}

		Test.stopTest();

		TestLeads = [SELECT Id,
				Name,
				ConvertedAccountId,
				Products__c,
				Phone,
				Business_Pro_Loyalty_Account_Number__c,
				RecordTypeId,
				OwnerId,
				Company,
				IsConverted FROM Lead WHERE Phone='1092837364'];
		List<Id> AccountIds = new List<Id>();
		for(Lead ConvertedLead: TestLeads){
			AccountIds.add(ConvertedLead.ConvertedAccountId);
		}

		List<Account> GeneratedAccounts = [SELECT Id, RecordTypeId FROM Account WHERE Id IN :AccountIds];

		for(Account acc: GeneratedAccounts){
			System.assert(acc.RecordTypeId == MyUtils_Account.BizBoxProspectRecordTypeId, 'Generated Account RecordType Mis-Match. Expected '
					+ MyUtils_Account.BizBoxProspectRecordTypeId + ', got ' + acc.RecordTypeId
					+ '. This may be the result of the User Profile having the incorrect default RecordType.');
		}
	}

	/*******************************************************************************************************
    * @description Verifies the correct Contact Record type after lead conversion.
    *
    */
	@IsTest
	static void VerifyContactRecordTypeWithBizBoxUser(){
		List<Lead> TestLeads = MyUtils_Lead.GenerateBizBoxLeads(MyUtils.SuperUser_BizBox().Id, 1, false);
		Test.startTest();
		insert TestLeads;
		List<Lead> UnconvertedLeads = [
				SELECT 	Id,
				Name,
				Products__c,
				Phone,
				Business_Pro_Loyalty_Account_Number__c,
				RecordTypeId,
				OwnerId,
				Company,
				IsConverted FROM Lead WHERE Phone='1092837364'];

		for(Lead MyLead: UnconvertedLeads){
			Convert_Lead_BizBox.ConvertLead(MyLead);
		}

		Test.stopTest();

		TestLeads = [SELECT Id,
				Name,
				ConvertedContactId,
				Products__c,
				Phone,
				Business_Pro_Loyalty_Account_Number__c,
				RecordTypeId,
				OwnerId,
				Company,
				IsConverted FROM Lead WHERE Phone='1092837364'];
		List<Id> ContactIds = new List<Id>();
		for(Lead ConvertedLead: TestLeads){
			ContactIds.add(ConvertedLead.ConvertedContactId);
		}

		List<Contact> GeneratedContacts = [SELECT Id, RecordTypeId FROM Contact WHERE Id IN :ContactIds];

		for(Contact contact: GeneratedContacts){
			System.assert(contact.RecordTypeId == MyUtils_Contact.BizBoxContactRecordTypeId, 'Generated Account RecordType Mis-Match. Expected '
					+ MyUtils_Contact.BusProContactRecordTypeId + ', got ' + contact.RecordTypeId
					+ '. This may be the result of the User Profile having the incorrect default RecordType.');
		}
	}

	/*******************************************************************************************************
    * @description Verifies valid lead creation and conversion for Bix Box leads when the user making the
    * conversion is not on a profile that defaults to bizbox record types.
    */
	@IsTest
	static void TestLeadConversionWithStandardUser(){
		List<Lead> TestLeads = MyUtils_Lead.GenerateBizBoxLeads(MyUtils.SuperUser().Id, 1, false);
		Test.startTest();
		insert TestLeads;
		List<Lead> UnconvertedLeads = [
				SELECT 	Id,
				Name,
				Products__c,
				Phone,
				Business_Pro_Loyalty_Account_Number__c,
				RecordTypeId,
				OwnerId,
				Company,
				IsConverted FROM Lead WHERE Phone='1092837364'];

		for(Lead MyLead: UnconvertedLeads){
			Convert_Lead_BizBox.ConvertLead(MyLead);
		}

		Test.stopTest();

		TestLeads = [SELECT Id,
				Name,
				Products__c,
				Phone,
				Business_Pro_Loyalty_Account_Number__c,
				RecordTypeId,
				OwnerId,
				Company,
				IsConverted FROM Lead WHERE Phone='1092837364'];

		for(Lead ConvertedLead: TestLeads){
			System.assert(ConvertedLead.IsConverted);
			System.assert(ConvertedLead.RecordTypeId == MyUtils_Lead.BizBoxRecordTypeId, 'RecordType Mis-Match');
		}
	}


	/*******************************************************************************************************
    * @description Verifies the correct Account Record type after lead conversion when the user making the
    * conversion is not on a profile that defaults to bizbox record types.
    */
	@IsTest
	static void VerifyAccountRecordTypeWithStandardUser(){
		List<Lead> TestLeads = MyUtils_Lead.GenerateBizBoxLeads(MyUtils.SuperUser().Id, 1, false);
		Test.startTest();
		insert TestLeads;
		List<Lead> UnconvertedLeads = [
				SELECT 	Id,
				Name,
				Products__c,
				Phone,
				Business_Pro_Loyalty_Account_Number__c,
				RecordTypeId,
				OwnerId,
				Company,
				IsConverted FROM Lead WHERE Phone='1092837364'];

		for(Lead MyLead: UnconvertedLeads){
			Convert_Lead_BizBox.ConvertLead(MyLead);
		}

		Test.stopTest();

		TestLeads = [SELECT Id,
				Name,
				ConvertedAccountId,
				Products__c,
				Phone,
				Business_Pro_Loyalty_Account_Number__c,
				RecordTypeId,
				OwnerId,
				Company,
				IsConverted FROM Lead WHERE Phone='1092837364'];
		List<Id> AccountIds = new List<Id>();
		for(Lead ConvertedLead: TestLeads){
			AccountIds.add(ConvertedLead.ConvertedAccountId);
		}

		List<Account> GeneratedAccounts = [SELECT Id, RecordTypeId FROM Account WHERE Id IN :AccountIds];

		for(Account acc: GeneratedAccounts){
			System.assert(acc.RecordTypeId == MyUtils_Account.BizBoxProspectRecordTypeId, 'Generated Account RecordType Mis-Match. Expected '
					+ MyUtils_Account.BizBoxProspectRecordTypeId + ', got ' + acc.RecordTypeId
					+ '. This may be the result of the User Profile having the incorrect default RecordType.');
		}
	}

	/*******************************************************************************************************
    * @description Verifies the correct Contact Record type after lead conversion when the user making the
    * conversion is not on a profile that defaults to bizbox record types.
    *
    */
	@IsTest
	static void VerifyContactRecordTypeWithStandardUser(){
		List<Lead> TestLeads = MyUtils_Lead.GenerateBizBoxLeads(MyUtils.SuperUser().Id, 1, false);
		Test.startTest();
		insert TestLeads;
		List<Lead> UnconvertedLeads = [
				SELECT 	Id,
				Name,
				Products__c,
				Phone,
				Business_Pro_Loyalty_Account_Number__c,
				RecordTypeId,
				OwnerId,
				Company,
				IsConverted FROM Lead WHERE Phone='1092837364'];

		for(Lead MyLead: UnconvertedLeads){
			Convert_Lead_BizBox.ConvertLead(MyLead);
		}

		Test.stopTest();

		TestLeads = [SELECT Id,
				Name,
				ConvertedContactId,
				Products__c,
				Phone,
				Business_Pro_Loyalty_Account_Number__c,
				RecordTypeId,
				OwnerId,
				Company,
				IsConverted FROM Lead WHERE Phone='1092837364'];
		List<Id> ContactIds = new List<Id>();
		for(Lead ConvertedLead: TestLeads){
			ContactIds.add(ConvertedLead.ConvertedContactId);
		}

		List<Contact> GeneratedContacts = [SELECT Id, RecordTypeId FROM Contact WHERE Id IN :ContactIds];

		for(Contact contact: GeneratedContacts){
			System.assert(contact.RecordTypeId == MyUtils_Contact.BizBoxContactRecordTypeId, 'Generated Account RecordType Mis-Match. Expected '
					+ MyUtils_Account.BizBoxProspectRecordTypeId + ', got ' + contact.RecordTypeId
					+ '. This may be the result of the User Profile having the incorrect default RecordType.');
		}
	}


	/*******************************************************************************************************
    * @description Verifies the Opportunities are generated for the converted lead and that they are the correcy type.
    *
    */
	@IsTest
	static  void VerifyOpportunityGeneration(){
		List<Lead> TestLeads = MyUtils_Lead.GenerateBizBoxLeads(MyUtils.SuperUser().Id, 1, false);
		List<Id> AccountIds = new List<Id>();
		Test.startTest();
		insert TestLeads;
		List<Lead> UnconvertedLeads = [
				SELECT 	Id,
				Name,
				Products__c,
				Phone,
				Business_Pro_Loyalty_Account_Number__c,
				RecordTypeId,
				OwnerId,
				Company,
				IsConverted FROM Lead WHERE Phone='1092837364'];

		for(Lead MyLead: UnconvertedLeads){
			Convert_Lead_BizBox.ConvertLead(MyLead);
		}

		Test.stopTest();

		TestLeads = [SELECT Id,
				Name,
				ConvertedAccountId,
				Products__c,
				Phone,
				Business_Pro_Loyalty_Account_Number__c,
				RecordTypeId,
				OwnerId,
				Company,
				IsConverted FROM Lead WHERE Phone='1092837364'];

		for(Lead MyLead: TestLeads){
			AccountIds.add(MyLead.ConvertedAccountId);
		}
		List<Opportunity> BizBoxOpportunities = [SELECT Id, RecordTypeId, AccountId FROM Opportunity WHERE AccountId IN :AccountIds];

		System.assert(BizBoxOpportunities.size() == TestLeads.size()*2, 'Incorrect number of Opportunities, Found:'
				+BizBoxOpportunities.size() +', Expected: ' + TestLeads.size()*2);
		for(Opportunity opp : BizBoxOpportunities){
			System.assert(opp.RecordTypeId==MyUtils_Opportunity.BizBoxRecordTypeId, 'Opportunity RecordType mis-match, Found: '
			+ opp.RecordTypeId +', Expected: ' + MyUtils_Opportunity.BizBoxRecordTypeId);
		}

	}

	/*******************************************************************************************************
    * @description Verifies new owner assignment after conversion for the generated opportunities, contact, and account.
    *
    */
	@IsTest
	static void VerifyOwnershipAfterConvert(){
		List<Lead> TestLeads = MyUtils_Lead.GenerateBizBoxLeads(MyUtils.SuperUser().Id, 1, false);
		List<Id> AccountIds = new List<Id>();
		List<Id> ContactIds = new List<Id>();
		Test.startTest();
		insert TestLeads;
		List<Lead> UnconvertedLeads = [
				SELECT 	Id,
				Name,
				Products__c,
				Phone,
				Business_Pro_Loyalty_Account_Number__c,
				RecordTypeId,
				OwnerId,
				Company,
				IsConverted FROM Lead WHERE Phone='1092837364'];

		for(Lead MyLead: UnconvertedLeads){
			Convert_Lead_BizBox.ConvertLeadAndGetResult(MyLead.Id, MyUtils.SuperUser_BizBox().Id);
		}

		Test.stopTest();

		TestLeads = [SELECT Id,
				Name,
				ConvertedAccountId,
				ConvertedContactId,
				Products__c,
				Phone,
				Business_Pro_Loyalty_Account_Number__c,
				RecordTypeId,
				OwnerId,
				Company,
				IsConverted FROM Lead WHERE Phone='1092837364'];

		for(Lead MyLead: TestLeads){
			AccountIds.add(MyLead.ConvertedAccountId);
			ContactIds.add(MyLead.ConvertedContactId);
			//System.assert(MyLead.OwnerId==MyUtils.SuperUser_BizBox().Id, 'OwnerId Mis-match on converted lead. Found: '
			//		+ MyLead.OwnerId + ' Expected: ' + MyUtils.SuperUser_BizBox().Id +'.');
		}
		List<Opportunity> BizBoxOpportunities = [SELECT Id, RecordTypeId, AccountId FROM Opportunity WHERE AccountId IN :AccountIds];
		for(Opportunity BizBoxOpportunity: BizBoxOpportunities){
			System.assert(BizBoxOpportunity.OwnerId==MyUtils.SuperUser_BizBox().Id, 'OwnerId Mis-match on Opportunity. Found: '
					+ BizBoxOpportunity.OwnerId + ' Expected: ' + MyUtils.SuperUser_BizBox().Id +'.');
		}

		List<Account> BizBoxProspects = [SELECT Id, RecordTypeId, OwnerId FROM Account WHERE Id IN :AccountIds];
		for(Account BizBoxProspect: BizBoxProspects){
			System.assert(BizBoxProspect.OwnerId==MyUtils.SuperUser_BizBox().Id, 'OwnerId Mis-match on Prospect. Found: '
					+ BizBoxProspect.OwnerId + ' Expected: ' + MyUtils.SuperUser_BizBox().Id +'.');
		}

		List<Contact> BizBoxContacts = [SELECT Id, RecordTypeId, OwnerId FROM Contact WHERE Id IN :ContactIds];
		for(Contact BizBoxContact: BizBoxContacts){
			System.assert(BizBoxContact.OwnerId==MyUtils.SuperUser_BizBox().Id, 'OwnerId Mis-match on Contact. Found: '
					+ BizBoxContact.OwnerId + ' Expected: ' + MyUtils.SuperUser_BizBox().Id +'.');
		}


	}



	/*******************************************************************************************************
    * @description Verifies an exception is thrown when a user tries to convert an already converted lead.
    *	IsTest
	*	TODO: static void VerifyExceptionOnConvertedLead(){}
    */


}