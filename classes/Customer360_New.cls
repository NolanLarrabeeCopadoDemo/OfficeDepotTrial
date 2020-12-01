/**
 * This class handles the data formatting and callouts to the
 * EAI microservices to retrieve data for Customer360.
 */
public with sharing class Customer360_New
{
	/**
	 * These are the endpoints for each microservice, which will be appeneded to the base URL.
	 * The base URL is in the Named Credential.
	 */
	@TestVisible
	private static final String AOPSCustomerInstructions_ENDPOINT = 'selectAOPSCustInstructions';
	@TestVisible
	private static final String AOPSItemRestrictionCode_ENDPOINT = 'selectAOPSItemRestrictionCode';
	@TestVisible
	private static final String AOPSFreightCharge_ENDPOINT = 'selectAOPSFreightCharge';
	@TestVisible
	private static final String AOPSDeliveryChargeCode_ENDPOINT = 'selectAOPSDlvChargeCode';
	@TestVisible
	private static final String AOPSGhostCard_ENDPOINT = 'selectAOPSGhostCard';
	@TestVisible
	private static final String AOPSCustomerTierDiscounts_ENDPOINT = 'selectAOPSCustTierDisc';
	@TestVisible
	private static final String AOPSCorePricing_ENDPOINT = 'selectAOPSCorePricing';
	@TestVisible
	private static final String AOPSUniversalPricing_ENDPOINT = 'selectAOPSUnivPricing';
	@TestVisible
	private static final String AOPSCustomerVehicles_ENDPOINT = 'selectAOPSCustVhcls';
	@TestVisible
	private static final String AOPSCustomerMasterDetails_ENDPOINT = 'selectAOPSCustMstrDtls';
	@TestVisible
	private static final String AOPSTaxInformation_ENDPOINT = 'selectAOPSTaxInfo';
	@TestVisible
	private static final String AOPSStorePickup_ENDPOINT = 'selectAOPSStorePickup';
	@TestVisible
	private static final String AOPSAlternateSourcing_ENDPOINT = 'AOPSAlternateSourcing';
	@TestVisible
	private static final String AOPSCustomerPreferences_ENDPOINT = 'selectAOPSCustPrefs';
	@TestVisible
	private static final String EbizCustomerInformation_ENDPOINT = 'selectEbizGetCustomerInfo';

	/**
	 * This is the name of the Named Credential within Salesforce.
	 * The Named Credentials automatically attaches the authorization header to any HTTP Requests sent using it.
	 * It also contains the base URL for the microservices. We only need to append an
	 * endpoint name from the endpoints above to get the full request URL.
	 */
	private static final String NAMED_CREDENTIAL = 'Customer360';

	/**
	 * Returns the AOPS customer id from the given map if it is present, or if the record id
	 * is present and an account is found using it.
	 */
	@TestVisible
	private static String getAopsCustIdFromParams(Map<String, Object> params)
	{
		String recordId = (String) params.get('recordId');
		String aopsCustId = (String) params.get('aopsCustId');

		if (aopsCustId == null)
		{
			if (recordId != null)
			{
				Account acc = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Id =:recordId LIMIT 1];
				aopsCustId = acc.AOPS_Cust_Id__c;
			}
			else
			{
				throw new AuraHandledException('Unable to find account.');
			}
		}

		return aopsCustId;
	}

	/**
	 * Returns the record id from the given map if it is present, or if the AOPS
	 * customer id is present and an account is found using it.
	 */
	@TestVisible
	private static String getRecordIdFromParams(Map<String, Object> params)
	{
		String recordId = (String) params.get('recordId');
		String aopsCustId = (String) params.get('aopsCustId');

		if (recordId == null)
		{
			if (aopsCustId != null)
			{
				Account acc = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE AOPS_Cust_Id__c =:aopsCustId LIMIT 1];
				recordId = acc.Id;
			}
			else
			{
				throw new AuraHandledException('Unable to find account.');
			}
		}

		return recordId;
	}

	/**
	 * Retrieves the customer's fact sheet data from within SFDC.
	 */
	@AuraEnabled
	public static Fact_Sheet__c getFactSheetFields(String recordId)
	{
		try
		{
			Fact_Sheet__c factSheetData = [SELECT Account__c, Forms_of_Order_Entry__c, Can_Restrictions_Be_Overridden_Without_A__c,
										   Can_Customer_Care_Maintain_Account__c, Additional_Account_Handling_Comments__c,
										   Price_Variance__c, MISC__c, Tier_1__c, EDI_Customer_Name__c, EDI_Customer_Phone__c,
										   EDI_Customer_Email__c, EDI_Exceptions_Name__c, EDI_Exceptions_Phone__c, EDI_Exceptions_Email__c,
										   Ordering_Platform__c, EDI_Restrictions__c, Special_Instructions__c, Name__c,
                                           Custmustclearcreditpriortorebill__c, Proprietary_Flag__c, Price_Match__c
										   FROM Fact_Sheet__c WHERE Account__c =:recordId];
			return factSheetData;
		}
		catch (QueryException ex)
		{
			return null;
		}
	}

	/**
	 * Calls out to the EAI Microservice to retrieve the customer's delivery charge code.
	 */
	@AuraEnabled
	public static AOPSDeliveryChargeCode getDeliveryChargeCode(String aopsCustId)
	{
		Http http = new Http();
		HttpResponse response;
		HttpRequest request = new HttpRequest();

		request.setEndpoint('callout:' + NAMED_CREDENTIAL + '/' + AOPSDeliveryChargeCode_ENDPOINT);
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		request.setBody('{"CustomerID":' + aopsCustId + '}');
		request.setTimeout(30000);
		response = http.send(request);

		String JSONContent = response.getBody();
		JSONParser jsonParser = JSON.createParser(JSONContent);
		jsonParser.nextToken();
		jsonParser.nextToken();
		jsonParser.nextToken();

		List<AOPSDeliveryChargeCode> jsonArray = (List<AOPSDeliveryChargeCode>) jsonParser.readValueAs(List<AOPSDeliveryChargeCode>.class);

		if (jsonArray.size() > 0)
		{
			return jsonArray.get(0);
		}
		else
		{
			return null;
		}
	}

	/**
	 * Calls out to the EAI Microservice to retrieve whether the customer has a freight charge or not.
	 */
	@AuraEnabled
	public static AOPSFreightCharge getFreightCharge(String aopsCustId)
	{
		Http http = new Http();
		HttpResponse response;
		HttpRequest request = new HttpRequest();

		request.setEndpoint('callout:' + NAMED_CREDENTIAL + '/' + AOPSFreightCharge_ENDPOINT);
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		request.setBody('{"CustomerID":' + aopsCustId + '}');
		request.setTimeout(30000);
		response = http.send(request);

		String JSONContent = response.getBody();
		JSONParser jsonParser = JSON.createParser(JSONContent);
		jsonParser.nextToken();
		jsonParser.nextToken();
		jsonParser.nextToken();

		List<AOPSFreightCharge> jsonArray = (List<AOPSFreightCharge>) jsonParser.readValueAs(List<AOPSFreightCharge>.class);

		if (jsonArray.size() > 0)
		{
			return jsonArray.get(0);
		}
		else
		{
			return null;
		}
	}

	/**
	 * Calls out to the EAI Microservice to retrieve whether the customer's item restrictions.
	 */
	@AuraEnabled
	public static AOPSItemRestrictionCode getItemRestrictionCode(String aopsCustId)
	{
		Http http = new Http();
		HttpResponse response;
		HttpRequest request = new HttpRequest();

		request.setEndpoint('callout:' + NAMED_CREDENTIAL + '/' + AOPSItemRestrictionCode_ENDPOINT);
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		request.setBody('{"CustomerID":' + aopsCustId + '}');
		request.setTimeout(30000);
		response = http.send(request);

		String JSONContent = response.getBody();
		JSONParser jsonParser = JSON.createParser(JSONContent);
		jsonParser.nextToken();
		jsonParser.nextToken();
		jsonParser.nextToken();

		List<AOPSItemRestrictionCode> jsonArray = (List<AOPSItemRestrictionCode>) jsonParser.readValueAs(List<AOPSItemRestrictionCode>.class);

		if (jsonArray.size() > 0)
		{
			return jsonArray.get(0);
		}
		else
		{
			return null;
		}
	}

	/**
	 * Calls out to the EAI Microservice to retrieve whether the customer has a ghost card or not.
	 */
	@AuraEnabled
	public static AOPSGhostCard getGhostCard(String aopsCustId)
	{
		Http http = new Http();
		HttpResponse response;
		HttpRequest request = new HttpRequest();

		request.setEndpoint('callout:' + NAMED_CREDENTIAL + '/' + AOPSGhostCard_ENDPOINT);
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		request.setBody('{"CustomerID":' + aopsCustId + '}');
		request.setTimeout(30000);
		response = http.send(request);

		String JSONContent = response.getBody();
		JSONParser jsonParser = JSON.createParser(JSONContent);
		jsonParser.nextToken();
		jsonParser.nextToken();
		jsonParser.nextToken();

		List<AOPSGhostCard> jsonArray = (List<AOPSGhostCard>) jsonParser.readValueAs(List<AOPSGhostCard>.class);

		if (jsonArray.size() > 0)
		{
			return jsonArray.get(0);
		}
		else
		{
			return null;
		}
	}

	/**
	 * Calls out to the EAI Microservice to retrieve the customer's special instructions.
	 */
	@AuraEnabled
	public static List<AOPSCustomerInstruction> getCustomerInstructions(String aopsCustId)
	{
		Http http = new Http();
		HttpResponse response;
		HttpRequest request = new HttpRequest();

		request.setEndpoint('callout:' + NAMED_CREDENTIAL + '/' + AOPSCustomerInstructions_ENDPOINT);
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		request.setBody('{"CustomerID":' + aopsCustId + '}');
		request.setTimeout(30000);
		response = http.send(request);

		String JSONContent = response.getBody();
		JSONParser jsonParser = JSON.createParser(JSONContent);
		jsonParser.nextToken();
		jsonParser.nextToken();
		jsonParser.nextToken();

		List<AOPSCustomerInstruction> jsonArray = (List<AOPSCustomerInstruction>) jsonParser.readValueAs(List<AOPSCustomerInstruction>.class);
		return jsonArray;
	}

	/**
	 * Calls out to the EAI Microservice to retrieve the customer's dicsounts  data.
	 */
	@AuraEnabled
	public static List<AOPSCustomerTierDiscount> getCustomerTierDiscounts(String aopsCustId)
	{
		Http http = new Http();
		HttpResponse response;
		HttpRequest request = new HttpRequest();

		request.setEndpoint('callout:' + NAMED_CREDENTIAL + '/' + AOPSCustomerTierDiscounts_ENDPOINT);
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		request.setBody('{"CustomerID":' + aopsCustId + '}');
		request.setTimeout(30000);
		response = http.send(request);

		String JSONContent = response.getBody();
		JSONParser jsonParser = JSON.createParser(JSONContent);
		jsonParser.nextToken();
		jsonParser.nextToken();
		jsonParser.nextToken();

		List<AOPSCustomerTierDiscount> jsonArray = (List<AOPSCustomerTierDiscount>) jsonParser.readValueAs(List<AOPSCustomerTierDiscount>.class);
		return jsonArray;
	}

	/**
	 * Calls out to the EAI Microservice to retrieve the customer's universal core data.
	 */
	@AuraEnabled
	public static List<AOPSCorePricing> getCorePricing(String aopsCustId)
	{
		Http http = new Http();
		HttpResponse response;
		HttpRequest request = new HttpRequest();

		request.setEndpoint('callout:' + NAMED_CREDENTIAL + '/' + AOPSCorePricing_ENDPOINT);
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		request.setBody('{"CustomerID":' + aopsCustId + '}');
		request.setTimeout(30000);
		response = http.send(request);

		String JSONContent = response.getBody();
		JSONParser jsonParser = JSON.createParser(JSONContent);
		jsonParser.nextToken();
		jsonParser.nextToken();
		jsonParser.nextToken();

		List<AOPSCorePricing> jsonArray = (List<AOPSCorePricing>) jsonParser.readValueAs(List<AOPSCorePricing>.class);
		return jsonArray;
	}

	/**
	 * Calls out to the EAI Microservice to retrieve the customer's universal pricing data.
	 */
	@AuraEnabled
	public static List<AOPSUniversalPricing> getUniversalPricings(String aopsCustId)
	{
		Http http = new Http();
		HttpResponse response;
		HttpRequest request = new HttpRequest();

		request.setEndpoint('callout:' + NAMED_CREDENTIAL + '/' + AOPSUniversalPricing_ENDPOINT);
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		request.setBody('{"CustomerID": ' + aopsCustId + '}');
		request.setTimeout(30000);
		response = http.send(request);

		String JSONContent = response.getBody();
		JSONParser jsonParser = JSON.createParser(JSONContent);
		jsonParser.nextToken();
		jsonParser.nextToken();
		jsonParser.nextToken();

		List<AOPSUniversalPricing> jsonArray = (List<AOPSUniversalPricing>) jsonParser.readValueAs(List<AOPSUniversalPricing>.class);
		return jsonArray;
	}

	/**
	 * Calls out to the EAI Microservice to retrieve the customer vehicles.
	 */
	@AuraEnabled
	public static List<AOPSCustomerVehicle> getCustomerVehicles(String aopsCustId)
	{
		Http http = new Http();
		HttpResponse response;
		HttpRequest request = new HttpRequest();

		request.setEndpoint('callout:' + NAMED_CREDENTIAL + '/' + AOPSCustomerVehicles_ENDPOINT);
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		request.setBody('{"CustomerID": ' + aopsCustId + '}');
		request.setTimeout(30000);
		response = http.send(request);

		String JSONContent = response.getBody();
		JSONParser jsonParser = JSON.createParser(JSONContent);
		jsonParser.nextToken();
		jsonParser.nextToken();
		jsonParser.nextToken();

		List<AOPSCustomerVehicle> jsonArray = (List<AOPSCustomerVehicle>) jsonParser.readValueAs(List<AOPSCustomerVehicle>.class);
		return jsonArray;
	}

	/**
	 * Calls out to the EAI Microservice to retrieve the customer preferences.
	 */
	@AuraEnabled
	public static List<AOPSCustomerPreference> getCustomerPreferences(String aopsCustId)
	{
		Http http = new Http();
		HttpResponse response;
		HttpRequest request = new HttpRequest();

		request.setEndpoint('callout:' + NAMED_CREDENTIAL + '/' + AOPSCustomerPreferences_ENDPOINT);
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		request.setBody('{"CustomerID": ' + aopsCustId + '}');
		request.setTimeout(30000);
		response = http.send(request);

		String JSONContent = response.getBody();
		JSONParser jsonParser = JSON.createParser(JSONContent);
		jsonParser.nextToken();
		jsonParser.nextToken();
		jsonParser.nextToken();

		List<AOPSCustomerPreference> jsonArray = (List<AOPSCustomerPreference>) jsonParser.readValueAs(List<AOPSCustomerPreference>.class);
		return jsonArray;
	}

	/**
	 * Calls out to the EAI Microservice to retrieve customer tax information.
	 */
	@AuraEnabled
	public static List<AOPSTaxInformation> getTaxInformation(String aopsCustId)
	{
		Http http = new Http();
		HttpResponse response;
		HttpRequest request = new HttpRequest();

		request.setEndpoint('callout:' + NAMED_CREDENTIAL + '/' + AOPSTaxInformation_ENDPOINT);
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		request.setBody('{"CustomerID": ' + aopsCustId + '}');
		request.setTimeout(30000);
		response = http.send(request);

		String JSONContent = response.getBody();
		JSONParser jsonParser = JSON.createParser(JSONContent);
		jsonParser.nextToken();
		jsonParser.nextToken();
		jsonParser.nextToken();

		List<AOPSTaxInformation> jsonArray = (List<AOPSTaxInformation>) jsonParser.readValueAs(List<AOPSTaxInformation>.class);
		return jsonArray;
	}

	/**
	 * Calls out to the EAI Microservice to retrieve a bunch of important customer information (not specified).
	 */
	@AuraEnabled
	public static AOPSCustomerMasterDetails getCustomerMasterDetails(String aopsCustId)
	{
		Http http = new Http();
		HttpResponse response;
		HttpRequest request = new HttpRequest();

		request.setEndpoint('callout:' + NAMED_CREDENTIAL + '/' + AOPSCustomerMasterDetails_ENDPOINT);
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		request.setBody('{"CustomerID": ' + aopsCustId + '}');
		request.setTimeout(30000);
		response = http.send(request);

		String JSONContent = response.getBody();
		JSONParser jsonParser = JSON.createParser(JSONContent);
		jsonParser.nextToken();
		jsonParser.nextToken();
		jsonParser.nextToken();

		List<AOPSCustomerMasterDetails> jsonArray = (List<AOPSCustomerMasterDetails>) jsonParser.readValueAs(List<AOPSCustomerMasterDetails>.class);
		if (jsonArray.size() > 0)
		{
			return jsonArray.get(0);
		}
		else
		{
			return null;
		}
	}

	@AuraEnabled
	public static EbizCustomerInformation getEbizCustomerInformation(String aopsCustId)
	{
		Http http = new Http();
		HttpResponse response;
		HttpRequest request = new HttpRequest();

		request.setEndpoint('callout:' + NAMED_CREDENTIAL + '/' + EbizCustomerInformation_ENDPOINT);
		request.setMethod('POST');
		request.setHeader('Content-Type', 'application/json');
		request.setBody('{"CustomerID": ' + aopsCustId + '}');
		request.setTimeout(30000);
		response = http.send(request);
		system.debug('response : ' + response.getBody());
		String JSONContent = response.getBody();
		JSONParser jsonParser = JSON.createParser(JSONContent);
		jsonParser.nextToken();
		jsonParser.nextToken();
		jsonParser.nextToken();

		EbizCustomerInformation jsonObject = (EbizCustomerInformation) jsonParser.readValueAs(EbizCustomerInformation.class);
		return jsonObject;
	}

	/**
	 * Returns an aggregate map of all the data from the external services, collected
	 * into one method for easier calling.
	 * Must not return a serialized JSON string in order to respect the instance
	 * variable access modifiers.
	 */
	@AuraEnabled
	public static Map<String, Object> getCustomer360Data(Map<String, String> params)
	{
		String recordId = getRecordIdFromParams(params);
		String aopsCustId = getAopsCustIdFromParams(params);

		AOPSGhostCard ghostCard                                 = getGhostCard(aopsCustId);
		Fact_Sheet__c factSheetData                             = getFactSheetFields(recordId);
		List<AOPSCorePricing> corePricings                      = getCorePricing(aopsCustId);
		AOPSFreightCharge freightCharge                         = getFreightCharge(aopsCustId);
		List<AOPSCustomerVehicle> customerVehicles              = getCustomerVehicles(aopsCustId);
		List<AOPSUniversalPricing> universalPricings            = getUniversalPricings(aopsCustId);
		AOPSDeliveryChargeCode deliveryChargeCode               = getDeliveryChargeCode(aopsCustId);
		AOPSItemRestrictionCode itemRestrictionCode             = getItemRestrictionCode(aopsCustId);
		List<AOPSCustomerPreference> customerPreferences        = getCustomerPreferences(aopsCustId);
		List<AOPSCustomerInstruction> customerInstructions      = getCustomerInstructions(aopsCustId);
		List<AOPSCustomerTierDiscount> customerTierDiscounts    = getCustomerTierDiscounts(aopsCustId);
		List<AOPSTaxInformation> taxInformation                 = getTaxInformation(aopsCustId);
		AOPSCustomerMasterDetails customerMasterDetails         = getCustomerMasterDetails(aopsCustId);
		EbizCustomerInformation ebizCustomerInformation         = getEbizCustomerInformation(aopsCustId);

		Map<String, Object> customer360Data = new Map<String, Object>
		{
			'ghostCard'                 => ghostCard,
			'factSheetData'             => factSheetData,
			'corePricings'              => corePricings,
			'freightCharge'             => freightCharge,
			'customerVehicles'          => customerVehicles,
			'universalPricings'         => universalPricings,
			'deliveryChargeCode'        => deliveryChargeCode,
			'itemRestrictionCode'       => itemRestrictionCode,
			'customerPreferences'       => customerPreferences,
			'customerInstructions'      => customerInstructions,
			'customerTierDiscounts'     => customerTierDiscounts,
			'taxInformation'            => taxInformation,
			'customerMasterDetails'     => customerMasterDetails,
			'ebizCustomerInformation'   => ebizCustomerInformation,
            'recordId'					=> recordId
		};

		return customer360Data;
	}

	@TestVisible
	class AOPSItemRestrictionCode
	{
		/**
		 * The instance variables to hold the parsed JSON from JSONparser.readValueAs()
		 */
		private String REST_CODE_E_I;

		/**
		 * The instance variables to hold the parsed JSON from JSONparser.readValueAs()
		 */
		@AuraEnabled
		public String restrictionCode {
			get { return this.REST_CODE_E_I; }
			set { this.REST_CODE_E_I = value; }
		}
	}

	@TestVisible
	class AOPSFreightCharge
	{
		/**
		 * The instance variables to hold the parsed JSON from JSONparser.readValueAs()
		 */
		private String CCU007F_FREIGHT_CHG_REQ_FLAG;

		/**
		 * The public instance variables to hold the data with an appropriate human-readable name.
		 */
		@AuraEnabled
		public String freightFlag {
			get { return this.CCU007F_FREIGHT_CHG_REQ_FLAG; }
			set { this.CCU007F_FREIGHT_CHG_REQ_FLAG = value; }
		}
	}

	@TestVisible
	class AOPSDeliveryChargeCode
	{
		/**
		 * The instance variables to hold the parsed JSON from JSONparser.readValueAs()
		 */
		private String DLV_CODE;

		/**
		 * The public instance variables to hold the data with an appropriate human-readable name.
		 */
		@AuraEnabled
		public String deliveryChargeCode {
			get { return this.DLV_CODE; }
			set { this.DLV_CODE = value; }
		}
	}

	@TestVisible
	class AOPSGhostCard
	{
		/**
		 * The instance variables to hold the parsed JSON from JSONparser.readValueAs()
		 */
		private String HAS_GHOSTCARD;

		/**
		 * The public instance variables to hold the data with an appropriate human-readable name.
		 */
		@AuraEnabled
		public String hasGhostCard {
			get { return this.HAS_GHOSTCARD; }
			set { this.HAS_GHOSTCARD = value; }
		}
	}

	@TestVisible
	class AOPSCustomerInstruction
	{
		/**
		 * The instance variables to hold the parsed JSON from JSONparser.readValueAs()
		 */
		private String COMMENT_CODE;
		private String CODE_DESCRIPTION;

		/**
		 * The public instance variables to hold the data with an appropriate human-readable name.
		 */
		@AuraEnabled
		public String commentCode {
			get { return this.COMMENT_CODE; }
			set { this.COMMENT_CODE = value; }
		}
		@AuraEnabled
		public String codeDescription {
			get { return this.CODE_DESCRIPTION; }
			set { this.CODE_DESCRIPTION = value; }
		}
		@AuraEnabled
		public String comment;
	}

	@TestVisible
	class AOPSCustomerTierDiscount
	{
		/**
		 * The instance variables to hold the parsed JSON from JSONparser.readValueAs()
		 */
		private Double FROM_AMT;
		private Double TO_AMT;
		private Double PERCENT_DISC;

		/**
		 * The public instance variables to hold the data with an appropriate human-readable name.
		 */
		@AuraEnabled
		public Double fromAmount {
			get { return this.FROM_AMT; }
			set { this.FROM_AMT = value; }
		}
		@AuraEnabled
		public Double toAmount {
			get { return this.TO_AMT; }
			set { this.TO_AMT = value; }
		}
		@AuraEnabled
		public Double percentDiscount {
			get { return this.PERCENT_DISC; }
			set { this.PERCENT_DISC = value; }
		}
	}

	@TestVisible
	class AOPSCorePricing
	{
		/**
		 * The instance variables to hold the parsed JSON from JSONparser.readValueAs()
		 */
		private String CORE_ITEM_PRICE_LIST_ID;
		private String CORE_ITEM_PRICE_LIST_PRI_CODE;
		private String CORE_ITEM_PRICE_LIST_DESC;
		private Date START_DATE;
		private Date END_DATE;

		/**
		 * The public instance variables to hold the data with an appropriate human-readable name.
		 */
		@AuraEnabled
		public String itemId {
			get { return this.CORE_ITEM_PRICE_LIST_ID; }
			set { this.CORE_ITEM_PRICE_LIST_ID = value; }
		}
		@AuraEnabled
		public String itemPiceCode {
			get { return this.CORE_ITEM_PRICE_LIST_PRI_CODE; }
			set { this.CORE_ITEM_PRICE_LIST_PRI_CODE = value; }
		}
		@AuraEnabled
		public String itemDescription {
			get { return this.CORE_ITEM_PRICE_LIST_DESC; }
			set { this.CORE_ITEM_PRICE_LIST_DESC = value; }
		}
		@AuraEnabled
		public Date startDate {
			get { return this.START_DATE; }
			set { this.START_DATE = value; }
		}
		@AuraEnabled
		public Date endDate {
			get { return this.END_DATE; }
			set { this.END_DATE = value; }
		}
	}

	@TestVisible
	class AOPSUniversalPricing
	{
		/**
		 * The instance variables to hold the parsed JSON from JSONparser.readValueAs()
		 */
		private String UNIV_PRICING_PROG_CODE;
		private Double UNIV_PRICING_DISCOUNT;
		private String UNIV_PRICING_EXCLUDE;

		/**
		 * The public instance variables to hold the data with an appropriate human-readable name.
		 */
		@AuraEnabled
		public String programCode {
			get { return this.UNIV_PRICING_PROG_CODE; }
			set { this.UNIV_PRICING_PROG_CODE = value; }
		}
		@AuraEnabled
		public Double discount {
			get { return this.UNIV_PRICING_DISCOUNT; }
			set { this.UNIV_PRICING_DISCOUNT = value; }
		}
		@AuraEnabled
		public String isExcluded {
			get { return this.UNIV_PRICING_EXCLUDE; }
			set { this.UNIV_PRICING_EXCLUDE = value; }
		}
	}

	@TestVisible
	class AOPSCustomerVehicle
	{
		/**
		 * The instance variables to hold the parsed JSON from JSONparser.readValueAs()
		 */
		private String VHCL_CODE;
		private String VHCL_DESC;

		/**
		 * The public instance variables to hold the data with an appropriate human-readable name.
		 */
		@AuraEnabled
		public String vehicleCode {
			get { return this.VHCL_CODE; }
			set { this.VHCL_CODE = value; }
		}
		@AuraEnabled
		public String vehicleDescription {
			get { return this.VHCL_DESC; }
			set { this.VHCL_DESC = value; }
		}
	}

	@TestVisible
	class AOPSCustomerPreference
	{
		/**
		 * The instance variables to hold the parsed JSON from JSONparser.readValueAs()
		 */
		private String code;
		private String publicFlag;

		/**
		 * The public instance variables to hold the data with an appropriate human-readable name.
		 */
		@AuraEnabled
		public String preferenceCode {
			get { return this.code; }
			set { this.code = value; }
		}
		@AuraEnabled
		public String flag {
			get { return this.publicFlag; }
			set { this.publicFlag = value; }
		}
		@AuraEnabled
		public String value;
	}

	@TestVisible
	class AOPSTaxInformation
	{
		/**
		 * The instance variables to hold the parsed JSON from JSONparser.readValueAs()
		 */
		private String ADDRESS_STATE;
		private String COUNTRY_CODE;
		private String EXP_DATE;
		private String TAX_STATUS;
		private String FEDERAL_EXEMPT_FLAG;
		private String TAX_CERTIF_NBR;

		/**
		 * The public instance variables to hold the data with an appropriate human-readable name.
		 */
		@AuraEnabled
		public String state {
			get { return this.ADDRESS_STATE; }
			set { this.ADDRESS_STATE = value; }
		}
		@AuraEnabled
		public String country {
			get { return this.COUNTRY_CODE; }
			set { this.COUNTRY_CODE = value; }
		}
		@AuraEnabled
		public String expirationDate {
			get { return this.EXP_DATE; }
			set { this.EXP_DATE = value; }
		}
		@AuraEnabled
		public String taxStatus {
			get { return this.TAX_STATUS; }
			set { this.TAX_STATUS = value; }
		}
		@AuraEnabled
		public String federalExemptionFlag {
			get { return this.FEDERAL_EXEMPT_FLAG; }
			set { this.FEDERAL_EXEMPT_FLAG = value; }
		}
		@AuraEnabled
		public String taxCertificateNumber {
			get { return this.TAX_CERTIF_NBR; }
			set { this.TAX_CERTIF_NBR = value; }
		}
	}

	@TestVisible
	class AOPSCustomerMasterDetails
	{
		@AuraEnabled public String BUSINESS_NAME;
		@AuraEnabled public String STREET_ADDRESS1;
		@AuraEnabled public String STREET_ADDRESS2;
		@AuraEnabled public String CITY;
		@AuraEnabled public String STATE;
		@AuraEnabled public String PROVINCE;
		@AuraEnabled public String ZIP;
		@AuraEnabled public String COUNTRY_CODE;
		@AuraEnabled public Integer TAX_GEO_CODE;
		@AuraEnabled public String ADDL_ADDR_IND;
		@AuraEnabled public String CUST_COMM_IND;
		@AuraEnabled public String ADDR_COMM_IND;
		@AuraEnabled public String DELIVER_CHARGE_CODE;
		@AuraEnabled public String FURN_DLVRY_FEE;
		@AuraEnabled public Double MINIMUM_ORDER_VALUE;
		@AuraEnabled public String FREIGHT_CHG_REQ_FLAG;
		@AuraEnabled public String TAX_EXEMPT_TYPE;
		@AuraEnabled public String TAX_CERTIF_IND;
		@AuraEnabled public Integer DUNS_NBR;
		@AuraEnabled public String CREDIT_IND;
		@AuraEnabled public String CUST_TYPE;
		@AuraEnabled public String CONT_RETAIL_CODE;
		@AuraEnabled public String PO_IND;
		@AuraEnabled public String BRAND;
		@AuraEnabled public String LESS_MAIL_FLAG;
		@AuraEnabled public String REPORTING_LOC;
		@AuraEnabled public String SALESPERSON_ID;
		@AuraEnabled public String SALESPERSON_NAME;
		@AuraEnabled public String REPORTING_IND;
		@AuraEnabled public String BUYING_GROUP_IND;
		@AuraEnabled public String BACKORDER_ALLOW_FLAG;
		@AuraEnabled public String PO_REQUIRED_CODE;
		@AuraEnabled public String RELEASE_REQUIRED_CODE;
		@AuraEnabled public String LOCATION_REQ_CODE;
		@AuraEnabled public String SHIP_TO_REQUIRED_CODE;
		@AuraEnabled public String LOCATION_IND;
		@AuraEnabled public String DEPARTMENT_IND;
		@AuraEnabled public String RELEASE_IND;
		@AuraEnabled public String FIELD_HEADER_IND;
		@AuraEnabled public String REBATE_IND;
		@AuraEnabled public String SIGNATURE_REQ;
		@AuraEnabled public String CUSTOMER_COMM;
		@AuraEnabled public String CONTRACT_CODE;
		@AuraEnabled public Integer PRICE_PLAN;
		@AuraEnabled public Integer PRICE_PLAN_SEQ;
		@AuraEnabled public String PRICE_PLAN_DESCR;
		@AuraEnabled public String OFF_CONTRACT_PRICE_CODE;
		@AuraEnabled public Double OFF_CONTRAT_PRCT;
		@AuraEnabled public String WHOLESALER_PRICE_CODE;
		@AuraEnabled public Double WHOLESALER_PRICE_DISCOUNT_PRCT;
		@AuraEnabled public Double MINIMUM_DISCOUNT;
		@AuraEnabled public Double GP_FLOOR;
		@AuraEnabled public String COST_CODE;
		@AuraEnabled public String SUBSTITUTE_ALLOWED;
		@AuraEnabled public String FAX_SHIP_CONFIRMATION;
		@AuraEnabled public String FAX_PO_CODE;
		@AuraEnabled public String FAX_REORDER_CODE;
		@AuraEnabled public String FAX_INV_CODE;
		@AuraEnabled public String COMMISSION_FLAG;
		@AuraEnabled public String TAKE_BACK_FLAG;
		@AuraEnabled public Integer PRODUCT_XREF_NBR;
		@AuraEnabled public String REST_KEY_CODE;
		@AuraEnabled public String REPORTING_CONTACT;
		@AuraEnabled public String ORDER_REST_IND;
		@AuraEnabled public String DEPT_REQUIRED_CODE;
		@AuraEnabled public String SPC_SERVICES_FLAG;
		@AuraEnabled public String AR_FLAG;
		@AuraEnabled public String HEDBERG_FLAG;
		@AuraEnabled public String REGISTERED_ON_TIME;
		@AuraEnabled public String ADDL_SALESPERSON_IND;
		@AuraEnabled public String REPORT_DIST_FLAG;
		@AuraEnabled public String CUST_LEGAL_AGREEMENT_FLAG;
		@AuraEnabled public String PARENT_NAME;
		@AuraEnabled public Date CREATEDATE;
		@AuraEnabled public String STATUS;
		@AuraEnabled public String SIC_CODE;
		@AuraEnabled public String SEGMENTATION;
		@AuraEnabled public String SECTOR;
		@AuraEnabled public String CUST_COMMENT1;
		@AuraEnabled public String CUST_COMMENT2;
		@AuraEnabled public String CUST_COMMENT3;
		@AuraEnabled public Date COMMENTS_CREATEDATE;
		@AuraEnabled public Integer CUSTOMER_ID;
		@AuraEnabled public Integer PARENT_ID;
		@AuraEnabled public String PRMRY_CNTCT_SALUTATION;
		@AuraEnabled public String PRMRY_CNTCT_FNAME;
		@AuraEnabled public String PRMRY_CNTCT_LNAME;
		@AuraEnabled public Integer PRMRY_PHN_CTRY_CD;
		@AuraEnabled public Integer PRMRY_PHN_AREA_CD;
		@AuraEnabled public Integer PRMRY_PHN_PFX;
		@AuraEnabled public Integer PRMRY_PHN_NBR;
		@AuraEnabled public Integer PRMRY_PHN_EXT;
		@AuraEnabled public String PRMRY_CNTCT_AUTH_BUYER;
		@AuraEnabled public String HOLD_RETRN_IND;
		@AuraEnabled public String ALLOW_PRNT_ON_DMND;
		@AuraEnabled public String TECH_BLOCK;
		@AuraEnabled public Integer LINE_LIMIT;
		@AuraEnabled public Integer ORDER_LIMIT;
		@AuraEnabled public String PRICING_TIER;
		@AuraEnabled public String BSDFIN_BLOCK;
		@AuraEnabled public String PRO_CARDS;
		@AuraEnabled public String SPC_CARDS;
	}

	@TestVisible
	class EbizCustomerInformation
	{
		@AuraEnabled public ARCollectorTab arcollectortab;
		@AuraEnabled public GrandParentTab grandparenttab;
		@AuraEnabled public CreditLimitsTab creditlimtstab;
		@AuraEnabled public AgingBucketTab agingbuckettab;
		@AuraEnabled public EbillContactTab ebillcontacttab;
		@AuraEnabled public PaymentTermsTab paymenttermstab;
	}

	@TestVisible
	class ARCollectorTab
	{
		@AuraEnabled public List<ARCollectorTabItem> arcollectortabitem;
	}

	@TestVisible
	class ARCollectorTabItem
	{
	}

	@TestVisible
	class GrandParentTab
	{
		@AuraEnabled public List<GrandParentTabItem> grandparenttabitem;
	}

	@TestVisible
	class GrandParentTabItem
	{
		@AuraEnabled public Integer gpid;
		@AuraEnabled public String gpname;
		@AuraEnabled public String origsystemreference;
	}

	@TestVisible
	class CreditLimitsTab
	{
		@AuraEnabled public List<CreditLimitsTabItem> creditlimtstabitem;
	}

	@TestVisible
	class CreditLimitsTabItem
	{
		@AuraEnabled public String currencycode;
		@AuraEnabled public Decimal overallcreditlimit;
		@AuraEnabled public Decimal trxcreditlimit;
		@AuraEnabled public Decimal otbcreditlimit;
		@AuraEnabled public Decimal parenthiercreditlimit;
	}

	@TestVisible
	class AgingBucketTab
	{
		@AuraEnabled public List<AgingBucketTabItem> agingbuckettabitem;
	}

	@TestVisible
	class AgingBucketTabItem
	{
		@AuraEnabled public Integer custaccountid;
		@AuraEnabled public String partyname;
		@AuraEnabled public String accountnumber;
		@AuraEnabled public String partynumber;
		@AuraEnabled public String paymentterms;
		@AuraEnabled public Decimal totaldue;
		@AuraEnabled public Decimal curr;
		@AuraEnabled public Decimal pd130;
		@AuraEnabled public Decimal pd3160;
		@AuraEnabled public Decimal pd6190;
		@AuraEnabled public Decimal pd91180;
		@AuraEnabled public Decimal pd181365;
		@AuraEnabled public Decimal pd366;
		@AuraEnabled public Decimal disputedtotalaged;
		@AuraEnabled public String collectorcode;
		@AuraEnabled public String aopsnum;
		@AuraEnabled public String acctestdate;
		@AuraEnabled public Decimal creditlimit;
	}

	@TestVisible
	class EbillContactTab
	{
		@AuraEnabled public List<EbillContactTabItem> ebillcontacttabitem;
	}

	@TestVisible
	class EbillContactTabItem
	{
		@AuraEnabled public String resptype;
		@AuraEnabled public String contactpointid;
		@AuraEnabled public String salutation;
		@AuraEnabled public Integer partyid;
		@AuraEnabled public String firstname;
		@AuraEnabled public String lastname;
		@AuraEnabled public String jobtitle;
		@AuraEnabled public String contactpointtype;
		@AuraEnabled public String emailaddress;
		@AuraEnabled public String phonelntype;
		@AuraEnabled public String phonelntypedesc;
		@AuraEnabled public String phonecountrycode;
		@AuraEnabled public String phoneareacode;
		@AuraEnabled public String phonenumber;
		@AuraEnabled public String extension;
		@AuraEnabled public String primarycontactpoint;
		@AuraEnabled public String preferredflag;
	}

	@TestVisible
	class PaymentTermsTab
	{
		@AuraEnabled public List<PaymentTermsTabItem> paymenttermstabitem;
	}

	@TestVisible
	class PaymentTermsTabItem
	{
		@AuraEnabled public String abbillingflag;
		@AuraEnabled public String paymentterm;
		@AuraEnabled public String paytermfrequency;
		@AuraEnabled public String paytermreportingday;
		@AuraEnabled public String paytermpercentage;
		@AuraEnabled public String billdocsdoctype;
		@AuraEnabled public String billdocsdeliverymeth;
		@AuraEnabled public String billdocsspecialhandling;
		@AuraEnabled public String billdocssigreq;
		@AuraEnabled public String billdocsdirectflag;
		@AuraEnabled public String billdocsautoreprint;
		@AuraEnabled public String billdocscomments1;
		@AuraEnabled public String billdocscomments2;
		@AuraEnabled public String billdocscomments3;
		@AuraEnabled public String billdocscomments4;
		@AuraEnabled public String billdocsmailattention;
		@AuraEnabled public String billdocsefffromdate;
		@AuraEnabled public String billdocsefftodate;
		@AuraEnabled public Integer locationid;
		@AuraEnabled public String address1;
		@AuraEnabled public String address2;
		@AuraEnabled public String city;
		@AuraEnabled public String postalcode;
		@AuraEnabled public String state;
		@AuraEnabled public String province;
		@AuraEnabled public String county;
		@AuraEnabled public String country;
	}
}