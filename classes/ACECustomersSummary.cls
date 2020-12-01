public without sharing class ACECustomersSummary
{
	/**
	 * Returns a list of customer price changes for the given batch with the given notification flag,
	 * which also belong to a user with id in the given list of user ids.
	 */
	@TestVisible
	private static List<ACE_Customer_Price_Changes__c> getCustomerPriceChanges(String batch, String notificationFlag, Set<Id> userIds)
	{
		List<ACE_Customer_Price_Changes__c> customerPriceChanges = [SELECT Id, Customer_Annual_Spend__c, Price_Not_Calculated__c, Customer__r.Remediation_Required__c,
																	Owning_Customer_ID__c, Customer_Notification_Date__c, Remedy_Status__c, Sales_Price_Change_Effective_Date_Min__c,
																	Name, Customer__r.Name, Record_Lock__c, Customer__r.OwnerId, Customer__r.Owner.Name,
																	Customer__r.Owner.Short_Title__c, Customer__r.Id, Customer__r.AOPS_Cust_Id__c, Item_12_Month_Qty__c, Item_12_Month_Sales__c,
																	Total_Spend_Impact_12_Month__c, SRM_Differential__c, SFDC_Notification_Flag__c,
																	Exception_Date_Lock__c, Notification_Status__c, Implementation_Status__c, Implementation_Status3__c,
																	implementation_status_code__c, Implementation_Status_Image__c, Notification_Status_Image__c, Notification_Status3__c,
																	Requirement_Window__c, Sales_Price_Change_Effective_Date_Rep__c, Sales_Price_Change_Effective_Date__c,
																	Sales_Price_Change_Effective_Date_Approv__c, Customer_Notification_Date_Approved__c, CoreCount__c, New_Gross_IGM__c,
																	New_Gross_IGM1__c, IsRemediation__c, NoOfSKUGovernedByActiveWrittenAgreement__c
																	FROM ACE_Customer_Price_Changes__c
																	WHERE NAME =:batch AND SFDC_Notification_Flag__c =:notificationFlag AND Customer__r.OwnerId IN:userIds];
		return customerPriceChanges;
	}

	/**
	 * Returns a list of users that are subordinates of the given user.
	 */
	public static List<User> getSubordinates(User user)
	{
		List<Id> userIds = new List<Id>();
		List<User> subordinates = new List<user>();

		userIds.add(user.Id);

		while (!userIds.isEmpty())
		{
			List<User> furtherSubordinates = [SELECT Id FROM User WHERE Manager.Id =:userIds];
			userIds.clear();

			for (User subordinate : furtherSubordinates)
			{
				userIds.add(subordinate.Id);
				subordinates.add(subordinate);
			}
		}

		return subordinates;
	}

	/**
	 * Returns a list of users that are subordinates of the current user.
	 * This method is not inclusive. It will not include the current user in the result.
	 */
	public static List<User> getCurrentUserSubordinates()
	{
		User currentUser = [SELECT Id FROM User WHERE Id =:UserInfo.getUserId()];
		return getSubordinates(currentUser);
	}

	/**
	 * Returns a set of ids constructed from the users' ids in the given list.
	 */
	public static Set<Id> getIdsFromUsers(List<User> users)
	{
		Set<Id> ids = new Set<Id>();

		for (User thisUser : users)
		{
			ids.add(thisUser.Id);
		}

		return ids;
	}

	/**
	 * Returns the corresponding user ids based on the ownership type.
	 */
	@TestVisible
	private static Set<Id> getUserIdsBasedOnOwnership(String ownership)
	{
		List<User> users = new List<User>();
		Set<Id> userIds = new Set<Id>();

		switch on ownership {
			when 'all' {
				users = getCurrentUserSubordinates();
				userIds = getIdsFromUsers(users);
				userIds.add(UserInfo.getUserId());
			}
			when 'ownedByMe' {
				userIds.add(UserInfo.getUserId());
			}
			when 'ownedByMyTeam' {
				users = getCurrentUserSubordinates();
				userIds = getIdsFromUsers(users);
			}
			when else
			{
				users = getCurrentUserSubordinates();
				userIds = getIdsFromUsers(users);
				userIds.add(UserInfo.getUserId());
			}
		}

		return userIds;
	}

	/**
	 * Returns a list of customer price changes that require approval for the given batch.
	 */
	@AuraEnabled(cacheable = true)
	public static String getCustomersApprovalRequired(String batch, String ownership)
	{
		final String notificationFlag = '3';
		Set<Id> userIds = getUserIdsBasedOnOwnership(ownership);
		List<ACE_Customer_Price_Changes__c> customerPriceChanges = getCustomerPriceChanges(batch, notificationFlag, userIds);
		List<ACECustomer> aceCustomersSummary = formatCustomerPriceChanges(customerPriceChanges);
		return JSON.serialize(aceCustomersSummary);
	}

	/**
	 * Returns a list of customer price changes that require approval for the given batch.
	 */
	@AuraEnabled(cacheable = true)
	public static String getCustomersNotificationRequired(String batch, String ownership)
	{
		final String notificationFlag = '2';
		Set<Id> userIds = getUserIdsBasedOnOwnership(ownership);
		List<ACE_Customer_Price_Changes__c> customerPriceChanges = getCustomerPriceChanges(batch, notificationFlag, userIds);
		List<ACECustomer> aceCustomersSummary = formatCustomerPriceChanges(customerPriceChanges);
		return JSON.serialize(aceCustomersSummary);
	}

	/**
	 * Returns a list of customer price changes that require approval for the given batch.
	 */
	@AuraEnabled(cacheable = true)
	public static String getCustomersNoRequirements(String batch, String ownership)
	{
		final String notificationFlag = '1';
		Set<Id> userIds = getUserIdsBasedOnOwnership(ownership);
		List<ACE_Customer_Price_Changes__c> customerPriceChanges = getCustomerPriceChanges(batch, notificationFlag, userIds);
		List<ACECustomer> aceCustomersSummary = formatCustomerPriceChanges(customerPriceChanges);
		return JSON.serialize(aceCustomersSummary);
	}

	/**
	 * Gets the summary data for the Approval Required section.
	 */
	@AuraEnabled(cacheable = true)
	public static String getCustomersApprovalRequiredSummary(String batch, String ownership)
	{
		final String notificationFlag = '3';
		Set<Id> userIds = getUserIdsBasedOnOwnership(ownership);
		AggregateResult[] aggregateResults = getAggregateResults(batch, notificationFlag, userIds);
		Map<String, Object> aceCustomersSummary = ACEPricingInformation.getPricingInformation(aggregateResults, batch);
		return JSON.serialize(aceCustomersSummary);
	}

	/**
	 * Gets the summary data for the Notification Required section.
	 */
	@AuraEnabled(cacheable = true)
	public static String getCustomersNotificationRequiredSummary(String batch, String ownership)
	{
		final String notificationFlag = '2';
		Set<Id> userIds = getUserIdsBasedOnOwnership(ownership);
		AggregateResult[] aggregateResults = getAggregateResults(batch, notificationFlag, userIds);
		Map<String, Object> aceCustomersSummary = ACEPricingInformation.getPricingInformation(aggregateResults, batch);
		return JSON.serialize(aceCustomersSummary);
	}

	/**
	 * Gets the summary data for the No Requirements section.
	 */
	@AuraEnabled(cacheable = true)
	public static String getCustomersNoRequirementsSummary(String batch, String ownership)
	{
		final String notificationFlag = '1';
		Set<Id> userIds = getUserIdsBasedOnOwnership(ownership);
		AggregateResult[] aggregateResults = getAggregateResults(batch, notificationFlag, userIds);
		Map<String, Object> aceCustomersSummary = ACEPricingInformation.getPricingInformation(aggregateResults, batch);
		return JSON.serialize(aceCustomersSummary);
	}

	/**
	 * This class is used to format the output for the front-end component to digest.
	 */
	@TestVisible
	class ACECustomer
	{
		public String customerId;
		public String customerName;
		public Double numberOfImpactedCores;
		public Double numberOfSkusGovernedByActiveWrittenAgreement;
		public Double averageSkuIncrease;
		public Double annualSpend;
		public Double estimatedTotalAnnualSpendChange;
		public Double estimatedAverageAnnualSpendImpact;
		public Double totalSrmImpact;
		public String notificationStatus;
		public Date notificationDate;
		public String priceChangeStatus;
		public Date priceChangeEffectiveDate;
		public String repName;
	}

	/**
	 * Used to create instances of the ACECustomer class from a single instance of ACE_Customer_Price_Changes__c.
	 */
	@TestVisible
	private static ACECustomer formatCustomerPriceChange(ACE_Customer_Price_Changes__c customerPriceChange)
	{
		ACECustomer aceCustomer = new ACECustomer();
		aceCustomer.customerId = customerPriceChange.Customer__r.AOPS_Cust_Id__c;
		aceCustomer.customerName = customerPriceChange.Customer__r.Name;
		aceCustomer.numberOfImpactedCores = customerPriceChange.CoreCount__c;
		aceCustomer.numberOfSkusGovernedByActiveWrittenAgreement = customerPriceChange.NoOfSKUGovernedByActiveWrittenAgreement__c;
		aceCustomer.annualSpend = customerPriceChange.Customer_Annual_Spend__c;
		aceCustomer.estimatedTotalAnnualSpendChange = customerPriceChange.Total_Spend_Impact_12_Month__c;
		aceCustomer.totalSrmImpact = customerPriceChange.SRM_Differential__c;
		aceCustomer.notificationStatus = customerPriceChange.Notification_Status3__c;
		aceCustomer.notificationDate = customerPriceChange.Customer_Notification_Date_Approved__c;
		aceCustomer.priceChangeStatus = customerPriceChange.Implementation_Status3__c;
		aceCustomer.priceChangeEffectiveDate = customerPriceChange.Sales_Price_Change_Effective_Date_Min__c;
		aceCustomer.repName = customerPriceChange.Customer__r.Owner.Name;

		if (customerPriceChange.Total_Spend_Impact_12_Month__c != null && customerPriceChange.Item_12_Month_Sales__c != null && customerPriceChange.Item_12_Month_Sales__c != 0)
		{
			aceCustomer.averageSkuIncrease = ((customerPriceChange.Total_Spend_Impact_12_Month__c / customerPriceChange.Item_12_Month_Sales__c) * 100).setScale(2);
		}
		else
		{
			aceCustomer.averageSkuIncrease = 0;
		}

		if (customerPriceChange.Total_Spend_Impact_12_Month__c != null && customerPriceChange.Item_12_Month_Qty__c != null && customerPriceChange.Item_12_Month_Qty__c != 0)
		{
			aceCustomer.estimatedAverageAnnualSpendImpact = (customerPriceChange.Total_Spend_Impact_12_Month__c / customerPriceChange.Item_12_Month_Qty__c).setScale(2);
		}
		else
		{
			aceCustomer.estimatedAverageAnnualSpendImpact = 0;
		}

		return aceCustomer;
	}

	/**
	 * Used to create instances of the ACECustomer class from a list of ACE_Customer_Price_Changes__c.
	 */
	@TestVisible
	private static List<ACECustomer> formatCustomerPriceChanges(List<ACE_Customer_Price_Changes__c> customerPriceChanges)
	{
		List<ACECustomer> aceCustomersSummary = new List<ACECustomer>();
		for (ACE_Customer_Price_Changes__c customerPriceChange : customerPriceChanges)
		{
			ACECustomer aceCustomer = formatCustomerPriceChange(customerPriceChange);
			aceCustomersSummary.add(aceCustomer);
		}
		return aceCustomersSummary;
	}

	/**
	 * Gets the aggregate results with all the info for the front-end datatable.
	 */
	private static AggregateResult[] getAggregateResults(String batch, String notificationFlag, Set<Id> userIds)
	{
		AggregateResult[] aggregateResults = [SELECT count(Id) customerCount,
											  SUM(SRM_Differential__c) summary,
											  SUM(Item_12_Month_Qty__c) annualSpend,
											  SUM(Approved_Proposed_Price__c) approvedProposedPrice,
											  SUM(Current_Sell_Price__c) currentSellPrice,
											  SUM(Total_Spend_Impact_12_Month__c) totalSpendImpact,
											  AVG(Total_Spend_Impact_Percent__c) totalSpendImpactPercent
											  FROM ACE_Customer_Price_Changes__c
											  WHERE Name =:batch
														   AND SFDC_Notification_Flag__c =:notificationFlag
																						   AND Customer__r.OwnerId IN:userIds];
		return aggregateResults;
	}
}