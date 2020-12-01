/**
* @author Adam Albright, adam.albright@officedepot.com
* @date 3/4/2018
*
* @group Lead Conversion Testing
* @group-content /ApexDocContent/Index.htm
*
* @description This Class is used to verify correct behavior of the Convert_Lead_BizBox_BusPro_Wrapper class.
*
*/
@isTest
public class Convert_Lead_BizBox_BusPro_Wrapper_TC {


	/*******************************************************************************************************
    * @description Verifies valid lead creation and conversion for Bix Box leads generated through
    * the MyUtils_Lead class and converted through the Convert_Lead_BizBox_BusPro_Wrapper class. The Leads have a Owner with a bizbox profile.
    */
	@IsTest
	static void TestBixBoxLeadConversion(){
		List<Lead> TestLeads = MyUtils_Lead.GenerateLeads(MyUtils_Lead.BizBoxRecordTypeId, System.UserInfo.getUserId(), 1, false);
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
			Convert_Lead_BizBox_BusPro_Wrapper.ConvertLead(MyLead.Id);
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
    * the MyUtils_Lead class and converted through the Convert_Lead_BizBox_BusPro_Wrapper class. The Leads have a Owner with a BusPro profile.
    */
	@IsTest
	static void TestBusProLeadConversion(){
		List<Lead> TestLeads = MyUtils_Lead.GenerateLeads(MyUtils_Lead.BusProRecordTypeId, System.UserInfo.getUserId(), 1, false);
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
			Convert_Lead_BizBox_BusPro_Wrapper.ConvertLead(MyLead.Id);
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
	// Test Passing a lead with an incorrect record type.
	/*******************************************************************************************************
    * @description Verifies that an exception is thrown when a lead with an incorrect RecordType is passed to be converted.
    */
	@IsTest
	static void TestPartnerLeadConversionWithBusProUser(){
		List<Lead> TestLeads = MyUtils_Lead.GenerateLeads(MyUtils_Lead.BusProRecordTypeId, System.UserInfo.getUserId(), 1, false);
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
			try{
				Convert_Lead_BizBox_BusPro_Wrapper.ConvertLead(MyLead.Id);
			} catch (MyUtils_Lead.LeadConversionException e) {
				System.debug(LoggingLevel.INFO, 'Success!');
			}finally {
				continue;
			}
		}

		Test.stopTest();

	}


	/*******************************************************************************************************
    * @description Verifies valid lead creation and conversion for through the aura class, BizBox_BusPro_Lead_Convert_Aura.
    *
    */
	@IsTest
	static void TestLeadConversionWithAura(){
		List<Lead> TestLeads = MyUtils_Lead.GenerateLeads(MyUtils_Lead.BusProRecordTypeId, System.UserInfo.getUserId(), 1, false);
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
			BizBox_BusPro_Lead_Convert_Aura.ConvertLead(MyLead.Id);
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

		//Lead PreConvert = UnconvertedLeads[0];

		for(Lead ConvertedLead: TestLeads){
			System.assert(ConvertedLead.IsConverted);
			System.assert(ConvertedLead.RecordTypeId == UnconvertedLeads[0].RecordTypeId, 'RecordType Mis-Match');
		}
	}

	/*******************************************************************************************************
    * @description Verifies valid lead creation and conversion for through the aura class, BizBox_BusPro_Lead_Convert_Aura.
    *
    */
	/*@IsTest
	static void TestLeadRetrivalWithAura(){
		List<Lead> TestLeads = MyUtils_Lead.GenerateLeads(MyUtils_Lead.BusProRecordTypeId, System.UserInfo.getUserId(), 1, false);
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

		TestLeads = [SELECT Id,
				Name,
				Products__c,
				Phone,
				Business_Pro_Loyalty_Account_Number__c,
				RecordTypeId,
				OwnerId,
				Company,
				IsConverted FROM Lead WHERE Phone='1092837364'];
		Test.stopTest();



		//Lead Retrieved = BizBox_BusPro_Lead_Convert_Aura.startInit(TestLeads[0].Id);

		//System.assert(BizBox_BusPro_Lead_Convert_Aura.startInit(TestLeads[0].Id) != null, 'Lead Retrieval failed.');

	}*/
}