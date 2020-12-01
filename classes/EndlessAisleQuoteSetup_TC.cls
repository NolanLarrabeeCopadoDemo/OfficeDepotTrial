@IsTest
public class EndlessAisleQuoteSetup_TC
{
	public EndlessAisleQuoteSetup_TC()
	{

	}

	@TestSetup
	static void makeData()
	{
		Account account1 = new Account();
		account1.Name = 'TestAccount1';
		account1.AOPS_Cust_Id__c = '1';
		account1.PO_REQUIRED_CODE__c = '1';
		account1.DEPT_REQUIRED_CODE__c = '1';
		account1.RELEASE_REQUIRED_CODE__c = '1';
		account1.LOCATION_REQ_CODE_7__c = '1';
		account1.RecordTypeId = [SELECT Id, Name FROM RecordType WHERE Name = 'Customer'].Id;
		insert account1;

		Account site1 = new Account();
		site1.Name = 'TestAccount2';
		site1.RecordTypeId = [SELECT Id, Name FROM RecordType WHERE Name = 'Site'].Id;
		site1.Related_Account__c = account1.Id;
		site1.AOPS_Seq_Id__c = '1';
		insert site1;

		Opportunity opp1 = new Opportunity();
		opp1.Name = 'TestOpp1';
		opp1.StageName = 'Propose';
		opp1.CloseDate = Date.today();
		opp1.AccountId = account1.Id;
		insert opp1;

		Contact contact1 = new Contact();
		contact1.FirstName = 'moe';
		contact1.LastName = 'moe';
		contact1.Email = 'moe@moe.com';
		contact1.AccountId = account1.Id;
		insert contact1;

		Quote quote1 = new Quote();
		quote1.OpportunityId = opp1.Id;
		quote1.Ship_To_Account__c = site1.Id;
		quote1.Name = 'TestQuote1';
		quote1.Desktop__c = '1';
		quote1.Cost_Center__c = '1';
		quote1.Release__c = '1';
		quote1.Customer_PO_Number__c = '1';
		insert quote1;

		Quote q = [SELECT Id, Ship_To_Account__r.AOPS_Seq_Id__c, AccountId, Account.Cust_Id__c FROM Quote WHERE Id = :quote1.Id];

		AOPS_DEPT_CCU001F__c costCenter = new AOPS_DEPT_CCU001F__c();
		costCenter.CCU001F_CUSTOMER_ID__c = q.Account.Cust_Id__c;
		costCenter.CCU001F_CUSTOMER_DEPT_KEY__c = '1';
		costCenter.KEY__c = '1';
		insert costCenter;

		AOPS_PO_FCU009P__c poNumber = new AOPS_PO_FCU009P__c();
		poNumber.FCU009P_CUSTOMER_ID__c = q.Account.Cust_Id__c;
		poNumber.FCU009P_PO_NBR__c = '1';
		poNumber.KEY__c = '1';
		insert poNumber;

		AOPS_DESKTOP_CCU003F__c desktopNumber = new AOPS_DESKTOP_CCU003F__c();
		desktopNumber.CCU003F_CUSTOMER_ID__c = q.Account.Cust_Id__c;
		desktopNumber.CCU003F_ADDRESS_SEQ__c = Decimal.valueOf(q.Ship_To_Account__r.AOPS_Seq_Id__c);
		desktopNumber.CCU003F_CUST_LOCATION_KEY__c = '1';
		desktopNumber.KEY__c = '1';
		insert desktopNumber;

		AOPS_RELEASE_CCU005F__c releaseNumber = new AOPS_RELEASE_CCU005F__c();
		releaseNumber.CCU005F_CUSTOMER_ID__c = q.Account.Cust_Id__c;
		releaseNumber.CCU005F_RELEASE_NBR__c = '1';
		releaseNumber.KEY__c = '1';
		insert releaseNumber;
	}

	@IsTest
	public static void testFieldRestrictions()
	{
		Quote q = [SELECT Id, AccountId FROM Quote WHERE Name = 'TestQuote1'];

		Test.startTest();
		String response = EndlessAisleQuoteSetup.getFieldRestrictions(q.Id);
		List<Account> accounts = (List<Account>)JSON.deserialize(response, List<Account>.class);
		System.assertEquals(accounts.size(), 1);
		Test.stopTest();
	}

	@IsTest
	public static void testQuoteWizardValues()
	{
		Quote q = [SELECT Id, Ship_To_Account__r.Id, Contact.Id FROM Quote WHERE Name = 'TestQuote1'];

		Test.startTest();
		String response = EndlessAisleQuoteSetup.getTechQuoteWizardValues(q.Id);
		Map<String, Object> responses = (Map<String, Object>)JSON.deserializeUntyped(response);
		System.assertEquals(responses.get('costCenter'), '1');
		System.assertEquals(responses.get('poNumber'), '1');
		System.assertEquals(responses.get('desktopNumber'), '1');
		System.assertEquals(responses.get('releaseNumber'), '1');
		System.assertEquals(((Map<String, Object>)responses.get('shipTo')).get('recordId'), q.Ship_To_Account__r.Id);
		System.assertEquals(((Map<String, Object>)responses.get('contact')).get('recordId'), q.Contact.Id);
		Test.stopTest();
	}

	@IsTest
	public static void testCostCenterResults()
	{
		Quote q = [SELECT Id, Name FROM Quote WHERE Name = 'TestQuote1'];

		Test.startTest();
		String response = EndlessAisleQuoteSetup.getCostCenterResults(q.Id, '');
		System.debug(response);
		List<AOPS_DEPT_CCU001F__c> responses = (List<AOPS_DEPT_CCU001F__c>)JSON.deserialize(response, List<AOPS_DEPT_CCU001F__c>.class);
		System.assertEquals(responses.size(), 1);
		Test.stopTest();
	}

	@IsTest
	public static void testCostCenterResultsFail()
	{
		Test.startTest();
		String response = EndlessAisleQuoteSetup.getCostCenterResults('zzz', '');
		System.debug(response);
		List<AOPS_DEPT_CCU001F__c> responses = (List<AOPS_DEPT_CCU001F__c>)JSON.deserialize(response, List<AOPS_DEPT_CCU001F__c>.class);
		System.assertEquals(responses.size(), 0);
		Test.stopTest();
	}

	@IsTest
	public static void testPONumberResults()
	{
		Quote q = [SELECT Id, Name FROM Quote WHERE Name = 'TestQuote1'];

		Test.startTest();
		String response = EndlessAisleQuoteSetup.getPONumberResults(q.Id, '');
		List<AOPS_PO_FCU009P__c> responses = (List<AOPS_PO_FCU009P__c>)JSON.deserialize(response, List<AOPS_PO_FCU009P__c>.class);
		System.assertEquals(responses.size(), 1);
		Test.stopTest();
	}

	@IsTest
	public static void testPONumberResultsFail()
	{
		Test.startTest();
		String response = EndlessAisleQuoteSetup.getPONumberResults('zzz', '');
		List<AOPS_PO_FCU009P__c> responses = (List<AOPS_PO_FCU009P__c>)JSON.deserialize(response, List<AOPS_PO_FCU009P__c>.class);
		System.assertEquals(responses.size(), 0);
		Test.stopTest();
	}

	@IsTest
	public static void testDesktopNumberResults()
	{
		Quote q = [SELECT Id, Name FROM Quote WHERE Name = 'TestQuote1'];

		Test.startTest();
		String response = EndlessAisleQuoteSetup.getDesktopNumberResults(q.Id, '');
		List<AOPS_DESKTOP_CCU003F__c> responses = (List<AOPS_DESKTOP_CCU003F__c>)JSON.deserialize(response, List<AOPS_DESKTOP_CCU003F__c>.class);
		System.assertEquals(responses.size(), 1);
		Test.stopTest();
	}

	@IsTest
	public static void testDesktopNumberResultsFail()
	{
		Test.startTest();
		String response = EndlessAisleQuoteSetup.getDesktopNumberResults('zzz', '');
		List<AOPS_DESKTOP_CCU003F__c> responses = (List<AOPS_DESKTOP_CCU003F__c>)JSON.deserialize(response, List<AOPS_DESKTOP_CCU003F__c>.class);
		System.assertEquals(responses.size(), 0);
		Test.stopTest();
	}

	@IsTest
	public static void testReleaseNumberResults()
	{
		Quote q = [SELECT Id, Name FROM Quote WHERE Name = 'TestQuote1'];

		Test.startTest();
		String response = EndlessAisleQuoteSetup.getReleaseNumberResults(q.Id, '');
		List<AOPS_RELEASE_CCU005F__c> responses = (List<AOPS_RELEASE_CCU005F__c>)JSON.deserialize(response, List<AOPS_RELEASE_CCU005F__c>.class);
		System.assertEquals(responses.size(), 1);
		Test.stopTest();
	}

	@IsTest
	public static void testReleaseNumberResultsFail()
	{
		Test.startTest();
		String response = EndlessAisleQuoteSetup.getReleaseNumberResults('zzz', '');
		List<AOPS_RELEASE_CCU005F__c> responses = (List<AOPS_RELEASE_CCU005F__c>)JSON.deserialize(response, List<AOPS_RELEASE_CCU005F__c>.class);
		System.assertEquals(responses.size(), 0);
		Test.stopTest();
	}

	@IsTest
	public static void testShipToResults()
	{
		Quote q = [SELECT Id, Name FROM Quote WHERE Name = 'TestQuote1'];

		Test.startTest();
		String response = EndlessAisleQuoteSetup.getShipToResults(q.Id, '');
		List<Account> responses = (List<Account>)JSON.deserialize(response, List<Account>.class);
		System.assertEquals(responses.size(), 1);
		Test.stopTest();
	}

	@IsTest
	public static void testShipToResultsFail()
	{
		Test.startTest();
		String response = EndlessAisleQuoteSetup.getShipToResults('zzz', '');
		List<Account> responses = (List<Account>)JSON.deserialize(response, List<Account>.class);
		System.assertEquals(responses.size(), 0);
		Test.stopTest();
	}

	@IsTest
	public static void testContactResults()
	{
		Quote q = [SELECT Id, Name FROM Quote WHERE Name = 'TestQuote1'];

		Test.startTest();
		String response = EndlessAisleQuoteSetup.getContactResults(q.Id, '');
		List<Contact> responses = (List<Contact>)JSON.deserialize(response, List<Contact>.class);
		System.assertEquals(responses.size(), 1);
		Test.stopTest();
	}

	@IsTest
	public static void testContactResultsFail()
	{
		Test.startTest();
		String response = EndlessAisleQuoteSetup.getContactResults('zzz', '');
		List<Contact> responses = (List<Contact>)JSON.deserialize(response, List<Contact>.class);
		System.assertEquals(responses.size(), 0);
		Test.stopTest();
	}

	@IsTest
	public static void testSetTechQuoteWizardValues()
	{
		Quote q = [SELECT Id, Name FROM Quote WHERE Name = 'TestQuote1'];
		Account shipTo = [SELECT Id FROM Account WHERE Name = 'TestAccount2'];
		Contact contact = [SELECT Id FROM Contact WHERE FirstName = 'moe'];

		Map<String, Object> params = new Map<String, Object>();
		params.put('costCenter', '1');
		params.put('poNumber', '1');
		params.put('desktopNumber', '1');
		params.put('releaseNumber', '1');
		params.put('shipTo', shipTo.Id);
		params.put('contact', contact.Id);

		Test.startTest();
		Boolean didUpdate = EndlessAisleQuoteSetup.setTechQuoteWizardValues(q.Id, params);
		System.assertEquals(didUpdate, true);
		Test.stopTest();
	}
}