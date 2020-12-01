@IsTest
public with sharing class Customer360_New_Test
{
	@TestSetup
	static void makeData()
	{
		Account a1 = new Account
					 (
						 Name = 'c360moetest',
						 AOPS_Cust_Id__c = '2828282'
					 );
		insert a1;

		Fact_Sheet__c f1 = new Fact_Sheet__c
						   (
							   Account__c = a1.Id,
							   Price_Match__c = 'Price_Match__c'
						   );
		insert f1;
	}

	@IsTest
	public static void testGetAopsCustId()
	{
		Account a1 = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE AOPS_Cust_Id__c = '2828282'];
		Map<String, String> params = new Map<String, String>
		{
			'recordId' => a1.Id
		};

		Test.setMock(HttpCalloutMock.class, new Customer360_New_Mock());
		Test.startTest();
		String aopsCustId = Customer360_New.getAopsCustIdFromParams(params);
		Test.stopTest();

		System.assert (aopsCustId != null);
		System.assertEquals(a1.AOPS_Cust_Id__c, aopsCustId);
	}

	@IsTest
	public static void testGetRecordId()
	{
		Account a1 = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE AOPS_Cust_Id__c = '2828282'];
		Map<String, String> params = new Map<String, String>
		{
			'aopsCustId' => a1.AOPS_Cust_Id__c
		};

		Test.setMock(HttpCalloutMock.class, new Customer360_New_Mock());
		Test.startTest();
		String recordId = Customer360_New.getRecordIdFromParams(params);
		Test.stopTest();

		System.assert (recordId != null);
		System.assertEquals(a1.Id, recordId);
	}

	@IsTest
	public static void testGetFactSheetFields()
	{
		Account a1 = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Aops_Cust_Id__c = '2828282'];
		final String recordId = a1.Id;

		Test.startTest();
		Fact_Sheet__c response = Customer360_New.getFactSheetFields(recordId);
		Test.stopTest();

		System.assert (response != null);
		System.assertEquals(a1.Id, response.Account__c);
	}

	@IsTest
	public static void testGetDeliveryChargeCode()
	{
		final String aopsCustId = '2828282';

		Test.setMock(HttpCalloutMock.class, new Customer360_New_Mock());
		Test.startTest();
		Customer360_New.AOPSDeliveryChargeCode response = Customer360_New.getDeliveryChargeCode(aopsCustId);
		Test.stopTest();

		System.assert (response != null);
		System.assertEquals('061', response.deliveryChargeCode);
	}

	@IsTest
	public static void testGetFreightCharge()
	{
		final String aopsCustId = '2828282';

		Test.setMock(HttpCalloutMock.class, new Customer360_New_Mock());
		Test.startTest();
		Customer360_New.AOPSFreightCharge response = Customer360_New.getFreightCharge(aopsCustId);
		Test.stopTest();

		System.assert (response != null);
		System.assertEquals('N', response.freightFlag);
	}

	@IsTest
	public static void testGetItemRestrictionCode()
	{
		final String aopsCustId = '2828282';

		Test.setMock(HttpCalloutMock.class, new Customer360_New_Mock());
		Test.startTest();
		Customer360_New.AOPSItemRestrictionCode response = Customer360_New.getItemRestrictionCode(aopsCustId);
		Test.stopTest();

		System.assert (response != null);
		System.assertEquals('E', response.restrictionCode);
	}

	@IsTest
	public static void testGetGhostCard()
	{
		final String aopsCustId = '2828282';

		Test.setMock(HttpCalloutMock.class, new Customer360_New_Mock());
		Test.startTest();
		Customer360_New.AOPSGhostCard response = Customer360_New.getGhostCard(aopsCustId);
		Test.stopTest();

		System.assert (response != null);
		System.assertEquals('N', response.hasGhostCard);
	}

	@IsTest
	public static void testGetCustomerInstructions()
	{
		final String aopsCustId = '2828282';

		Test.setMock(HttpCalloutMock.class, new Customer360_New_Mock());
		Test.startTest();
		List<Customer360_New.AOPSCustomerInstruction> response = Customer360_New.getCustomerInstructions(aopsCustId);
		Test.stopTest();

		System.assert (response != null);
		System.assert (response.size() > 0);
		System.assertEquals('MFS', response.get(0).commentCode);
	}

	@IsTest
	public static void testGetCustomerTierDiscounts()
	{
		final String aopsCustId = '2828282';

		Test.setMock(HttpCalloutMock.class, new Customer360_New_Mock());
		Test.startTest();
		List<Customer360_New.AOPSCustomerTierDiscount> response = Customer360_New.getCustomerTierDiscounts(aopsCustId);
		Test.stopTest();

		System.assert (response != null);
		System.assert (response.size() > 0);
		System.assertEquals(100, response.get(0).fromAmount);
	}

	@IsTest
	public static void testGetCorePricing()
	{
		final String aopsCustId = '2828282';

		Test.setMock(HttpCalloutMock.class, new Customer360_New_Mock());
		Test.startTest();
		List<Customer360_New.AOPSCorePricing> response = Customer360_New.getCorePricing(aopsCustId);
		Test.stopTest();

		System.assert (response != null);
		System.assert (response.size() > 0);
		System.assertEquals('2013676-0', response.get(0).itemId);
	}

	@IsTest
	public static void testGetUniversalPricing()
	{
		final String aopsCustId = '2828282';

		Test.setMock(HttpCalloutMock.class, new Customer360_New_Mock());
		Test.startTest();
		List<Customer360_New.AOPSUniversalPricing> response = Customer360_New.getUniversalPricings(aopsCustId);
		Test.stopTest();

		System.assert (response != null);
		System.assert (response.size() > 0);
		System.assertEquals('Y', response.get(0).isExcluded);
	}

	@IsTest
	public static void testGetCustomerVehicles()
	{
		final String aopsCustId = '2828282';

		Test.setMock(HttpCalloutMock.class, new Customer360_New_Mock());
		Test.startTest();
		List<Customer360_New.AOPSCustomerVehicle> response = Customer360_New.getCustomerVehicles(aopsCustId);
		Test.stopTest();

		System.assert (response != null);
		System.assert (response.size() > 0);
		System.assertEquals('ML', response.get(0).vehicleCode);
	}

	@IsTest
	public static void testGetCustomerPreferences()
	{
		final String aopsCustId = '2828282';

		Test.setMock(HttpCalloutMock.class, new Customer360_New_Mock());
		Test.startTest();
		List<Customer360_New.AOPSCustomerPreference> response = Customer360_New.getCustomerPreferences(aopsCustId);
		Test.stopTest();

		System.assert (response != null);
		System.assert (response.size() > 0);
		System.assertEquals('BSDADS', response.get(0).preferenceCode);
	}

	@IsTest
	public static void testGetTaxInformation()
	{
		final String aopsCustId = '2828282';

		Test.setMock(HttpCalloutMock.class, new Customer360_New_Mock());
		Test.startTest();
		List<Customer360_New.AOPSTaxInformation> response = Customer360_New.getTaxInformation(aopsCustId);
		Test.stopTest();

		System.assert (response != null);
		System.assert (response.size() > 0);
		System.assertEquals('USA', response.get(0).country);
	}

	@IsTest
	public static void testGetCustomerMasterDetails()
	{
		final String aopsCustId = '2828282';

		Test.setMock(HttpCalloutMock.class, new Customer360_New_Mock());
		Test.startTest();
		Customer360_New.AOPSCustomerMasterDetails response = Customer360_New.getCustomerMasterDetails(aopsCustId);
		Test.stopTest();

		System.assert (response != null);
		System.assertEquals('DELRAY BEACH', response.CITY);
	}

	@IsTest
	public static void testGetEbizCustomerInformation()
	{
		final String aopsCustId = '2828282';

		Test.setMock(HttpCalloutMock.class, new Customer360_New_Mock());
		Test.startTest();
		Customer360_New.EbizCustomerInformation response = Customer360_New.getEbizCustomerInformation(aopsCustId);
		Test.stopTest();

		System.assert (response != null);
		System.debug(response);
		System.assert (response.grandparenttab != null);
		System.assert (response.grandparenttab.grandparenttabitem.size() > 0);
		System.assertEquals('Google', response.grandparenttab.grandparenttabitem.get(0).gpname);
	}

	@IsTest
	public static void testGetCustomer360Data()
	{
		Account a1 = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE AOPS_Cust_Id__c = '2828282'];
		Map<String, String> params = new Map<String, String>
		{
			'recordId'      => a1.Id,
			'aopsCustId'    => a1.AOPS_Cust_Id__c
		};

		Test.setMock(HttpCalloutMock.class, new Customer360_New_Mock());
		Test.startTest();
		Map<String, Object> response = Customer360_New.getCustomer360Data(params);
		Test.stopTest();

		System.assert (response != null);
	}
}