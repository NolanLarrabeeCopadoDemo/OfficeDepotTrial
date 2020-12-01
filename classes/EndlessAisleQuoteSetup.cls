public class EndlessAisleQuoteSetup
{
	private static final Integer MAXIMUM_RESULTS = 5;
	
	@AuraEnabled
	public static String getFieldRestrictions(String quoteId)
	{
		try {
			
			Quote quote = [SELECT Id, AccountId, Account.Cust_Id__C, Desktop__c, Cost_Center__c, Release__c, Customer_PO_Number__c, Ship_To_Account__r.Name, Contact.Name FROM Quote WHERE Id = :quoteId];
			List<Account> account = [SELECT Id, PO_REQUIRED_CODE__c, DEPT_REQUIRED_CODE__c, RELEASE_REQUIRED_CODE__c, LOCATION_REQ_CODE_7__c FROM Account WHERE Id = :quote.AccountId LIMIT 1];
			return JSON.serialize(account);
		}
		catch (QueryException ex)
		{
			return '[]';
		}
		catch (Exception ex)
		{
			throw new AuraHandledException('An error occurred retrieving the initial wizard\'s resutsl: ' + ex.getMessage());
		}
	}
	@AuraEnabled
	public static String getTechQuoteWizardValues(String quoteId)
	{
		try
		{
			Map<String, Object> response = new Map<String, Object>();
			Quote quote = 	[SELECT Id, Ship_To_Account__r.Name, Contact.Name, Account.Cust_Id__C , Ship_To_Account__r.Cust_Id__C, Customer_PO_Number__c, Desktop__c, Release__c, Cost_Center__c
							FROM Quote
							WHERE Id = :quoteId LIMIT 1];
			
			response.put('costCenter', quote.Cost_Center__c);
			response.put('poNumber', quote.Customer_PO_Number__c);
			response.put('desktopNumber', quote.Desktop__c);
			response.put('releaseNumber', quote.Release__c);
			response.put('shipTo', new Map<String, Object>{'name' => quote.Ship_To_Account__r.Name, 'recordId' => quote.Ship_To_Account__r.Id});
			response.put('contact', new Map<String, Object>{'name' => quote.Contact.Name, 'recordId' => quote.Contact.Id});
			
			return JSON.serialize(response);
		}
		catch (QueryException ex)
		{
			return null;
		}
		catch (Exception ex)
		{
			throw new AuraHandledException('An error occurred retrieving the initial wizard\'s resutsl: ' + ex.getMessage());
		}
	}
	@AuraEnabled
	public static Boolean setTechQuoteWizardValues(String quoteId, Map<String, Object> params)
	{
		try
		{
			String costCenter 		= params.containsKey('costCenter') 		? (String) params.get('costCenter') 	: null;
			String poNumber 		= params.containsKey('poNumber') 		? (String) params.get('poNumber') 		: null;
			String desktopNumber 	= params.containsKey('desktopNumber') 	? (String) params.get('desktopNumber') 	: null;
			String releaseNumber 	= params.containsKey('releaseNumber') 	? (String) params.get('releaseNumber') 	: null;
			String shipTo 			= params.containsKey('shipTo') 			? (String) params.get('shipTo') 		: null;
			String contact 			= params.containsKey('contact') 		? (String) params.get('contact') 		: null;
	
			Quote quote = 	[SELECT Id, ContactId, Ship_To_Account__c, Customer_PO_Number__c, Desktop__c, Release__c, Cost_Center__c
							FROM Quote
							WHERE Id = :quoteId LIMIT 1];

			quote.Cost_Center__c = costCenter;
			quote.Customer_PO_Number__c = poNumber;
			quote.Desktop__c = desktopNumber;
			quote.Release__c = releaseNumber;
			quote.Ship_To_Account__c = shipTo;
			quote.ContactId = contact;
			
			update quote;

			return true;
		}
		catch (Exception ex)
		{
			return false;
		}
	}
	@AuraEnabled
	public static String getCostCenterResults(String quoteId, String searchTerm)
	{
		try
		{
			Quote quote = [SELECT Id, Account.Cust_Id__c FROM Quote WHERE Id = :quoteId];
			String accountCustomerId = quote.Account.Cust_Id__c;
			List <AOPS_DEPT_CCU001F__c> costCenters = 	Database.Query('SELECT Id, Search_Field__c, CCU001F_CUSTOMER_ID__c, CCU001F_CUSTOMER_DEPT_KEY__c ' +
														'FROM AOPS_DEPT_CCU001F__c ' +
														'WHERE CCU001F_CUSTOMER_ID__c = :accountCustomerId AND CCU001F_CUSTOMER_DEPT_KEY__c LIKE \'' + searchTerm + '%\' LIMIT :MAXIMUM_RESULTS');
			
			return JSON.serialize(costCenters);
		}
		catch (QueryException ex)
		{
			return '[]';
		}
		catch (Exception ex)
		{
			throw new AuraHandledException('An error occurred retrieving the Cost Centers: ' + ex.getMessage());
		}
	}
	@AuraEnabled
	public static String getPONumberResults(String quoteId, String searchTerm)
	{
		try
		{
			Quote quote = [SELECT Id, Account.Cust_Id__c FROM Quote WHERE Id = :quoteId];
			String accountCustomerId = quote.Account.Cust_Id__c;
			List <AOPS_PO_FCU009P__c> poNumbers = 	Database.Query('SELECT Id, Search_Field__c, FCU009P_CUSTOMER_ID__c, FCU009P_PO_NBR__c ' +
													'FROM AOPS_PO_FCU009P__c ' +
													'WHERE FCU009P_CUSTOMER_ID__c = :accountCustomerId AND FCU009P_PO_NBR__c LIKE \'' + searchTerm + '%\'');
			
			return JSON.serialize(poNumbers);
		}
		catch (QueryException ex)
		{
			return '[]';
		}
		catch (Exception ex)
		{
			throw new AuraHandledException('An error occurred retrieving the PO Numbers: ' + ex.getMessage());
		}
	}
	@AuraEnabled
	public static String getDesktopNumberResults(String quoteId, String searchTerm)
	{
		try
		{
			Quote quote = [SELECT Id, Account.Cust_Id__c, Ship_To_Account__r.AOPS_Seq_ID__c FROM Quote WHERE Id = :quoteId];
			String accountCustomerId = quote.Account.Cust_Id__c;
			String aopsSequenceIdText = String.valueOf(quote.Ship_To_Account__r.AOPS_Seq_Id__c);
			aopsSequenceIdText = aopsSequenceIdText.substring(aopsSequenceIdText.indexOf('-') + 1);
			Decimal aopsSequenceId = Decimal.valueOf(aopsSequenceIdText);
			List <AOPS_DESKTOP_CCU003F__c> desktopNumbers = Database.Query('SELECT Id, Search_Field__c, CCU003F_CUSTOMER_ID__c, CCU003F_CUST_LOCATION_KEY__c ' +
															'FROM AOPS_DESKTOP_CCU003F__c ' +
															'WHERE CCU003F_CUSTOMER_ID__c = :accountCustomerId AND CCU003F_ADDRESS_SEQ__c = :aopsSequenceId AND CCU003F_CUST_LOCATION_KEY__c LIKE \'' + searchTerm + '%\'');
			
			return JSON.serialize(desktopNumbers);
		}
		catch (QueryException ex)
		{
			return '[]';
		}
		catch (Exception ex)
		{
			throw new AuraHandledException('An error occurred retrieving the Desktop Numbers: ' + ex.getMessage());
		}
	}
	@AuraEnabled
	public static String getReleaseNumberResults(String quoteId, String searchTerm)
	{
		try
		{
			Quote quote = [SELECT Id, Account.Cust_Id__c FROM Quote WHERE Id = :quoteId];
			String accountCustomerId = quote.Account.Cust_Id__c;
			List <AOPS_RELEASE_CCU005F__c> releaseNumbers = Database.Query('SELECT Id, Search_Field__c, CCU005F_CUSTOMER_ID__c, CCU005F_RELEASE_NBR__c ' +
															'FROM AOPS_RELEASE_CCU005F__c ' +
															'WHERE CCU005F_CUSTOMER_ID__c = :accountCustomerId AND CCU005F_RELEASE_NBR__c LIKE \'' + searchTerm + '%\'');
			return JSON.serialize(releaseNumbers);
		}
		catch (QueryException ex)
		{
			return '[]';
		}
		catch (Exception ex)
		{
			throw new AuraHandledException('An error occurred retrieving the Release Numbers: ' + ex.getMessage());
		}
	}
	@AuraEnabled
	public static String getShipToResults(String quoteId, String searchTerm)
	{
		try {
			Quote quote = [SELECT Id, AccountId FROM Quote WHERE Id = :quoteId];
			String accountId = quote.AccountId;
			List <Account> accounts = 	Database.Query('SELECT Id, Cust_Id__c, AOPS_Cust_Id__c, RecordType.Name, Name ' +
										'FROM Account ' +
										'WHERE RecordType.Name = \'Site\' AND Related_Account__c = :accountId AND Name LIKE \'' + searchTerm + '%\' LIMIT :MAXIMUM_RESULTS');
			
			return JSON.serialize(accounts);
		}
		catch (QueryException ex)
		{
			return '[]';
		}
		catch (Exception ex)
		{
			throw new AuraHandledException('An error occurred retrieving the Ship To Addresses: ' + ex.getMessage());
		}
	}
	@AuraEnabled
	public static String getContactResults(String quoteId, String searchTerm)
	{
		try
		{
			Quote quote = [SELECT Id, AccountId FROM Quote WHERE Id = :quoteId];
			String accountId = quote.AccountId;
			List <Contact> contacts = 	Database.Query('SELECT Id, AccountId, Name, Email ' +
										'FROM Contact ' +
										'WHERE AccountId = :accountId AND Name LIKE \'' + searchTerm + '%\' LIMIT :MAXIMUM_RESULTS');
			return JSON.serialize(contacts);
		}
		catch (QueryException ex)
		{
			return '[]';
		}
		catch (Exception ex)
		{
			throw new AuraHandledException('An error occurred retrieving the Contacts: ' + ex.getMessage());
		}
	}
}