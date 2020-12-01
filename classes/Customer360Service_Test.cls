@isTest
public class Customer360Service_Test {
	@TestSetup
	static void makeData()
	{
		RecordType prospectRecordType = [SELECT Id, Name FROM RecordType WHERE Name = 'Prospect' LIMIT 1];
		RecordType customerRecordType = [SELECT Id, Name FROM RecordType WHERE Name = 'Customer' LIMIT 1];
		RecordType gpRecordType = [SELECT Id, Name FROM RecordType WHERE Name = 'GrandParent' LIMIT 1];

		Account grandParent = new Account(
			Name = 'grandParentMoeTest',
			RecordTypeId = gpRecordType.Id,
			AOPS_Cust_Id__c = '1231231234'
			);
		insert grandParent;
		Account customer = new Account(
			Name = 'customerMoeTest',
			ParentId = grandParent.Id,
			RecordTypeId = customerRecordType.Id,
			AOPS_Cust_Id__c = '1231231231'
			);
		insert customer;
		Account prospect = new Account(
			Name = 'prospectMoeTest',
			ParentId = customer.Id,
			RecordTypeId = prospectRecordType.Id,
			AOPS_Cust_Id__c = '1231231235'
			);
		insert prospect;

		Lead lead1 = new Lead(
			Company = 'c360test',
			LastName = 'c360test'
			);
		insert lead1;
	}

	@IsTest
	public static void testPrimaryAccountToTrue()
	{
		executeoncetest.BypassAccountTrigger = true;
		ProspectSynchService.prospectSynchServiceRunning = true;
		String accSiteRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();

		Account acc = new Account();
		acc.Name = 'Test Account';
		acc.recordTypeId = accSiteRecId;
		acc.Primary_Site__c = false;
		acc.AOPS_Seq_ID__c = '02581234-00001';
		acc.AOPS_Cust_ID__c = '33168058';
		insert acc;

		Test.StartTest();
		Test.setMock(WebServiceMock.class, new Customer360MockImpl());
		Map<String, Object> mp = new Map <String, Object> ();
		mp.put('recordId', acc.Id);

		Map<String, Object> params = new Map<String, Object>();
		params.put('aopsCustId', acc.AOPS_Cust_Id__c);

		Customer360Service.ErrorMessageOutput_element erlo = new Customer360Service.ErrorMessageOutput_element();
		erlo.AdapterName = 'Test';
		erlo.ErrorCode = 'Test';
		erlo.ErrorSummary = 'Test';
		erlo.ErrorDetails = 'Test';
		erlo.ErrorType = 'Test';
		erlo.ErrorSeverity = 'Test';
		erlo.ErrorDate = System.now();

		List <Customer360Service.ErrorMessageOutput_element> erlolst = new List <Customer360Service.ErrorMessageOutput_element> ();
		erlolst.add(erlo);

		Customer360Service.ErrorMessage_element erl = new Customer360Service.ErrorMessage_element();
		erl.ErrorMessageOutput = erlolst;

		Customer360Service.SelectAOPSTaxInfoOutput_element serlo = new Customer360Service.SelectAOPSTaxInfoOutput_element();
		serlo.address_state = 'Test';
		serlo.country_code = 'Test';
		serlo.exp_date = 'Test';
		serlo.tax_status = 'Test';
		serlo.federal_exempt_flag = 'Test';
		serlo.tax_certif_nbr = 'Test';

		Customer360Service.SelectAOPSTaxInfoOutput_element[] serlolst = new List <Customer360Service.SelectAOPSTaxInfoOutput_element> ();
		serlolst.add(serlo);

		Customer360Service.AOPSTaxInfo_element serl = new Customer360Service.AOPSTaxInfo_element();
		serl.SelectAOPSTaxInfoOutput = serlolst;

		Customer360Service.DbSelectCustMstrDtlsOutput_element dserlo = new Customer360Service.DbSelectCustMstrDtlsOutput_element();
		Customer360Service.AOPSCustMstrDtls_element dserl = new Customer360Service.AOPSCustMstrDtls_element();
		dserl.DbSelectCustMstrDtlsOutput = dserlo;

		Customer360Service.DbSelectAOPSPricingOutput_element dberlo = new Customer360Service.DbSelectAOPSPricingOutput_element();
		dberlo.core_item_price_list_id = 'Test';
		dberlo.core_item_price_list_pri_code = 'Test';
		dberlo.core_item_price_list_desc = 'Test';
		dberlo.start_date = System.today();
		dberlo.end_date = System.today() + 4;

		List <Customer360Service.DbSelectAOPSPricingOutput_element> dberlolst = new List <Customer360Service.DbSelectAOPSPricingOutput_element> ();
		dberlolst.add(dberlo);

		Customer360Service.AOPSCorePricing_element dberl = new Customer360Service.AOPSCorePricing_element();
		dberl.DbSelectAOPSPricingOutput = dberlolst;

		Customer360Service.DbSelectEbizBillContactsOutput_element dbsele = new Customer360Service.DbSelectEbizBillContactsOutput_element();
		Customer360Service.AOPSCustInstructions_element dbacc = new Customer360Service.AOPSCustInstructions_element();
		Customer360Service.DbSelectAOPSCustInstructionsOutput_element dbacc12 = new Customer360Service.DbSelectAOPSCustInstructionsOutput_element();
		Customer360Service.DbSelectEbizBillTermsOutput_element dbacc13 = new Customer360Service.DbSelectEbizBillTermsOutput_element();
		Customer360Service.DbSelectEbizARCollectorOutput_element dbacc124 = new Customer360Service.DbSelectEbizARCollectorOutput_element();
		Customer360Service.AOPSCustPrefs_element dbacc123 = new Customer360Service.AOPSCustPrefs_element();
		Customer360Service.EbizARBalances_element dbacc122 = new Customer360Service.EbizARBalances_element();
		Customer360Service.EbizGparent_element dbacc121 = new Customer360Service.EbizGparent_element();
		Customer360Service.AOPSUniversalPricing_element dbacc120 = new Customer360Service.AOPSUniversalPricing_element();
		Customer360Service.EbizBillTerms_element dbacc129 = new Customer360Service.EbizBillTerms_element();
		Customer360Service.DbCallAOPSCustPrefsOutput_element dbacc130 = new Customer360Service.DbCallAOPSCustPrefsOutput_element();
		Customer360Service.EbizARCollector_element dbacc139 = new Customer360Service.EbizARCollector_element();
		Customer360Service.DbSelectUnivPricingOutput_element dbacc140 = new Customer360Service.DbSelectUnivPricingOutput_element();
		Customer360Service.DbSelectAOPSCustVhclsOutput_element dbacc149 = new Customer360Service.DbSelectAOPSCustVhclsOutput_element();
		Customer360Service.DbSelectAOPSCustTierDiscOutput_element dbacc147 = new Customer360Service.DbSelectAOPSCustTierDiscOutput_element();
		Customer360Service.EbizBillContacts_element dbacc148 = new Customer360Service.EbizBillContacts_element();
		Customer360Service.DbSelectEbizGparentOutput_element db11 = new Customer360Service.DbSelectEbizGparentOutput_element();
		Customer360Service.DbSelectEbizARBalancesOutput_element db22 = new Customer360Service.DbSelectEbizARBalancesOutput_element();
		Customer360Service.DbSelectEbizCreditLimitsOutput_element db33 = new Customer360Service.DbSelectEbizCreditLimitsOutput_element();
		Customer360Service.AOPSCustVhcls_element db44 = new Customer360Service.AOPSCustVhcls_element();
		Customer360Service.AOPSCustTierDisc_element db332 = new Customer360Service.AOPSCustTierDisc_element();
		Customer360Service.EbizCreditLimits_element db442 = new Customer360Service.EbizCreditLimits_element();
		Customer360Service.processResponse_element db440 = new Customer360Service.processResponse_element();
		Customer360Service.process_element db448 = new Customer360Service.process_element();

		Customer360Service.getRecordType(params);
		Customer360Service.processMethod(mp);
		Test.stopTest();
	}

	@IsTest
	public static void testGetGrandParent()
	{
		Account prospect = [SELECT Id, AOPS_Cust_Id__c, Name FROM Account WHERE Name = 'prospectMoeTest' LIMIT 1];
		Account grandParent = [SELECT Id, AOPS_Cust_Id__c, Name FROM Account WHERE Name = 'grandParentMoeTest' LIMIT 1];
		Map<String, Object> params = new Map<String, Object> { 'recordId' => prospect.Id };

		Test.startTest();
		Account gp = Customer360Service.getGrandParent(params);
		System.assert (gp != null);
		System.assertEquals(grandParent.AOPS_Cust_Id__c, gp.AOPS_Cust_Id__c);
		Test.stopTest();
	}

	@IsTest
	public static void testGetGrandParentWrongObjectType()
	{
		Lead lead = [SELECT Id FROM Lead WHERE Company = 'c360test'];
		Map<String, Object> params = new Map<String, Object> { 'recordId' => lead.Id };

		Test.startTest();
		Account gp = Customer360Service.getGrandParent(params);
		System.assert (gp == null);
		Test.stopTest();
	}

	@IsTest
	public static void testGetGrandParentNonExistentRecord()
	{
		String fakeId = '123';
		Map<String, Object> params = new Map<String, Object> { 'recordId' => fakeId };
		Test.startTest();
		Account gp = Customer360Service.getGrandParent(params);
		System.assert (gp == null);
		Test.stopTest();
	}
}