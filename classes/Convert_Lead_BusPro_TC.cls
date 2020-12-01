/**
* @author Adam Albright, adam.albright@officedepot.com
* @date 3/4/2018
*
* @group Lead Conversion
* @group-content /ApexDocContent/Index.htm
*
* @description This is a Test Class for verifying the proper behavior of the Convert_Lead_BusPro class.
*
*/
@isTest
public class Convert_Lead_BusPro_TC {
/*******************************************************************************************************
    * @description Verifies valid lead creation and conversion for Bus Pro leads generated through
    * the MyUtils_Lead class and converted through the Convert_Lead_BusPro class.
    */
	@IsTest
	static void TestLeadConversionWithBusProUser(){
		List<Lead> TestLeads = MyUtils_Lead.GenerateLeads(MyUtils_Lead.BusProRecordTypeId, MyUtils.SuperUser_BusPro().Id, 1, false);
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
			Convert_Lead_BusPro.ConvertLead(MyLead);
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
			System.assert(ConvertedLead.RecordTypeId == MyUtils_Lead.BusProRecordTypeId, 'RecordType Mis-Match');
		}
	}

	/*******************************************************************************************************
    * @description Verifies the correct Account Record type after lead conversion.
    * the MyUtils_Lead class and converted through the Convert_Lead_BizBox class.
    */
	@IsTest
	static void VerifyAccountRecordTypeWithBusProUser(){
		List<Lead> TestLeads =  MyUtils_Lead.GenerateLeads(MyUtils_Lead.BusProRecordTypeId, MyUtils.SuperUser_BusPro().Id, 1, false);
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
			Convert_Lead_BusPro.ConvertLead(MyLead);
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
			System.assert(acc.RecordTypeId == MyUtils_Account.BusProCustomerRecordTypeId, 'Generated Account RecordType Mis-Match. Expected '
					+ MyUtils_Account.BusProCustomerRecordTypeId + ', got ' + acc.RecordTypeId
					+ '. This may be the result of the User Profile having the incorrect default RecordType.');
		}
	}

	/*******************************************************************************************************
    * @description Verifies the correct Contact Record type after lead conversion.
    *
    */
	@IsTest
	static void VerifyContactRecordTypeWithBusProUser(){
		List<Lead> TestLeads =  MyUtils_Lead.GenerateLeads(MyUtils_Lead.BusProRecordTypeId, MyUtils.SuperUser_BusPro().Id, 1, false);
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
			Convert_Lead_BusPro.ConvertLead(MyLead);
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
			System.assert(contact.RecordTypeId == MyUtils_Contact.BusProContactRecordTypeId, 'Generated Account RecordType Mis-Match. Expected '
					+ MyUtils_Contact.BusProContactRecordTypeId + ', got ' + contact.RecordTypeId
					+ '. This may be the result of the User Profile having the incorrect default RecordType.');
		}
	}

	@IsTest
	static void VerifyOwnershipAfterConvert(){
		List<Lead> TestLeads = MyUtils_Lead.GenerateBusProLeads(MyUtils.SuperUser_BusPro().Id, 1, false);
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
			Convert_Lead_BizBox.ConvertLeadAndGetResult(MyLead.Id, MyUtils.SuperUser_BusPro().Id);
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
		}
		List<Account> BizBoxProspects = [SELECT Id, RecordTypeId, OwnerId FROM Account WHERE Id IN :AccountIds];
		for(Account BizBoxProspect: BizBoxProspects){
			System.assert(BizBoxProspect.OwnerId==MyUtils.SuperUser_BusPro().Id, 'OwnerId Mis-match on Prospect. Found: '
					+ BizBoxProspect.OwnerId + ' Expected: ' + MyUtils.SuperUser_BusPro().Id +'.');
		}

		List<Contact> BizBoxContacts = [SELECT Id, RecordTypeId, OwnerId FROM Contact WHERE Id IN :ContactIds];
		for(Contact BizBoxContact: BizBoxContacts){
			System.assert(BizBoxContact.OwnerId==MyUtils.SuperUser_BusPro().Id, 'OwnerId Mis-match on Contact. Found: '
					+ BizBoxContact.OwnerId + ' Expected: ' + MyUtils.SuperUser_BusPro().Id +'.');
		}


	}
}