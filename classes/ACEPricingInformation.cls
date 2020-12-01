public with sharing class ACEPricingInformation
{
	private static String remediationTeamName = 'Remediation Team', hostedCatalogTeamName = 'Hosted Catalog Team';
	private static List<String> groupNames = new List<String> { remediationTeamName, hostedCatalogTeamName};

	@AuraEnabled
	public static Boolean isCurrentUserValidTeamMember()
	{
		Id currentUserId = UserInfo.getUserId();
		Map<String, Boolean> groupMembershipStatuses = getUserGroupMembershipStatuses(currentUserId);
		Boolean isRemeditationTeamMember = groupMembershipStatuses.get(remediationTeamName);
		Boolean isHostedCatalogTeamMember = groupMembershipStatuses.get(hostedCatalogTeamName);
		return isRemeditationTeamMember || isHostedCatalogTeamMember;
	}

	/**
	 * Returns a formatted summary of the ace batches for the current user.
	 */
	@AuraEnabled
	public static List<Map<String, Object> > getPricingInformationByGroup()
	{
		Id userId = UserInfo.getUserId();
		Map<String, Boolean> groupMembershipStatuses = getUserGroupMembershipStatuses(userId);
		List<Map<String, Object> > aceBatchesPricingInformation = new List<Map<String, Object> >();
		List<ACE_Batches__c> aceBatches = [SELECT Id, Batch__c FROM ACE_Batches__c ORDER BY CreatedDate DESC];

		for (ACE_Batches__c aceBatch : aceBatches)
		{
			String batch = getBatch(aceBatch);
			Map<String, Object> aceBatchPricingInformation = new Map<String, Object>();
			AggregateResult[] aggregateResults = getAggregateResults(batch, groupMembershipStatuses);
			aceBatchPricingInformation = getPricingInformation(aggregateResults, batch);
			aceBatchesPricingInformation.add(aceBatchPricingInformation);
		}

		return aceBatchesPricingInformation;
	}

	public static Map<String, Object> getPricingInformation(AggregateResult[] aggregateResults, String batch)
	{
		Map<String, Object> aceBatchPricingInformation = new Map<String, Object>();

		if (aggregateResults.size() > 0)
		{
			Decimal annualSpend = getAnnualSpend(aggregateResults);
			Decimal percentIncrease = getPercentIncrease(aggregateResults);
			Decimal summaryTotal = getSummaryTotal(aggregateResults);
			Integer customerCount = getCustomerCount(aggregateResults);
			Decimal spendImpactPercent = getSpendImpactPercent(aggregateResults);

			// Boolean isBatchValid = batch != null,
			// isAnnualSpendValid = annualSpend != null,
			// isPercentIncreaseValid = percentIncrease != null,
			// isSummaryTotalValid = summaryTotal != null,
			// isCustomerCountValid = customerCount != null,
			// isSpendImpactPercentValid = spendImpactPercent != null;

			// Boolean isValidResult = isBatchValid && isAnnualSpendValid && isPercentIncreaseValid && isSummaryTotalValid && isCustomerCountValid;

			// if (isValidResult)
			// {
			//     aceBatchPricingInformation.put('batch', batch);
			//     aceBatchPricingInformation.put('annualSpend', annualSpend);
			//     aceBatchPricingInformation.put('percentIncrease', percentIncrease);
			//     aceBatchPricingInformation.put('summaryTotal', summaryTotal);
			//     aceBatchPricingInformation.put('customerCount', customerCount);

			//     if (isSpendImpactPercentValid)
			//     {
			//         aceBatchPricingInformation.put('spendImpactPercent', spendImpactPercent);
			//     }
			// }
			// else
			// {
			//     // Invalid result handling. Currently don't need to do anything.
			// }

			aceBatchPricingInformation.put('batch', batch);
			aceBatchPricingInformation.put('annualSpend', annualSpend);
			aceBatchPricingInformation.put('percentIncrease', percentIncrease);
			aceBatchPricingInformation.put('summaryTotal', summaryTotal);
			aceBatchPricingInformation.put('customerCount', customerCount);
			aceBatchPricingInformation.put('spendImpactPercent', spendImpactPercent);
		}

		return aceBatchPricingInformation;
	}

	@TestVisible
	private static Map<String, Boolean> getUserGroupMembershipStatuses(String userId)
	{
		Map<String, Boolean> groupMembershipsStatuses = new Map<String, Boolean>();
		List<Group> groups = [SELECT Id, Name FROM Group WHERE Name IN:groupNames];
		Set<Id> groupIds = getIdsFromGroups(groups);
		List<GroupMember> groupMemberships = [SELECT Id, GroupId, UserOrGroupId FROM GroupMember WHERE GroupId IN:groupIds AND UserOrGroupId =:userId];

		/**
		 * Pre-populate the map with false values, since we're only going to get
		 * the GroupMembers that ARE for this user. Which means we'll only be adding 'True' values in the map.
		 */
		for (String groupName : groupNames)
		{
			groupMembershipsStatuses.put(groupName, false);
		}

		for (GroupMember groupMembership : groupMemberships)
		{
			String groupName;

			for (Group groupRecord : groups)
			{
				if (groupRecord.Id == groupMembership.GroupId)
				{
					groupName = groupRecord.Name;
					break;
				}
			}

			if (String.isNotBlank(groupName))
			{
				groupMembershipsStatuses.put(groupName, true);
			}
		}

		return groupMembershipsStatuses;
	}

	/**
	 * Returns the ids of the groups from the given list of groups.
	 */
	@TestVisible
	private static Set<Id> getIdsFromGroups(List<Group> groups)
	{
		Set<Id> groupIds = new Set<Id>();
		for (Group groupRecord : groups)
		{
			groupIds.add(groupRecord.Id);
		}
		return groupIds;
	}

	/**
	 * Gets the aggregate results with all the info for the front-end datatable.
	 */
	private static AggregateResult[] getAggregateResults(String batch, Map<String, Boolean> groupMembershipStatuses)
	{
		AggregateResult[] aggregateResults;
		Boolean isRemeditationTeamMember = groupMembershipStatuses.get(remediationTeamName);
		Boolean isHostedCatalogTeamMember = groupMembershipStatuses.get(hostedCatalogTeamName);
		String query = 'SELECT count(Id) customerCount, SUM(SRM_Differential__c) summary' +
					   ',  SUM(Item_12_Month_Qty__c) annualSpend' +
					   ', SUM(Approved_Proposed_Price__c) approvedProposedPrice' +
					   ', SUM(Current_Sell_Price__c) currentSellPrice' +
					   ', SUM(Total_Spend_Impact_12_Month__c) totalSpendImpact' +
					   ', AVG(Total_Spend_Impact_Percent__c) totalSpendImpactPercent' +
					   ' FROM ACE_Customer_Price_Changes__c WHERE Name = \'' + batch + '\'';

		if (isRemeditationTeamMember)
		{
			query += ' AND (IsRemediation__c = true OR Remedy_Status__c = \'Pending\')';
		}
		else if (isHostedCatalogTeamMember)
		{
			query += ' AND Hosted_Catalog__c = true';
		}
		else
		{
			query += ' AND Customer__r.OwnerId = \'' + Userinfo.getUserId() + '\' AND SFDC_Notification_Flag__c != null';
		}
		aggregateResults = Database.query(query);
		return aggregateResults;
	}

	private static String getBatch(ACE_Batches__c aceBatch)
	{
		return aceBatch.Batch__c;
	}

	/**
	 * Calculates and returns the annual spend amount.
	 */
	public static Decimal getAnnualSpend(AggregateResult[] aggregateResults)
	{
		Decimal annualSpend = 0;
        String annualSpendRawValue;

		try
		{
			annualSpendRawValue = String.valueOf(aggregateResults[0].get('totalSpendImpact'));
		}
		catch (SObjectException ex)
		{
		}

		if (annualSpendRawValue != null)
		{
			annualSpend = Decimal.valueOf(annualSpendRawValue);
		}

		return annualSpend;
	}

	/**
	 * Calculates and returns the spend impact percent.
	 */
	public static Decimal getSpendImpactPercent(AggregateResult[] aggregateResults)
	{
        Decimal spendImpactPercent = 0;
        String spendImpactPercentRawValue;
        
		try
		{
			spendImpactPercentRawValue = String.valueOf(aggregateResults[0].get('totalSpendImpactPercent'));
		}
		catch (SObjectException ex)
		{
		}

		if (spendImpactPercentRawValue != null)
		{
			spendImpactPercent = Decimal.valueOf(spendImpactPercentRawValue);
		}

		return spendImpactPercent;
	}

	public static Decimal getPercentIncrease(AggregateResult[] aggregateResults)
	{
        Decimal percentIncrease = 0;
        String approvedProposedPriceRawValue;
        String currentSellPriceRawValue;

		try
		{
			approvedProposedPriceRawValue = String.valueOf(aggregateResults[0].get('approvedProposedPrice'));
			currentSellPriceRawValue = String.valueOf(aggregateResults[0].get('currentSellPrice'));
		}
		catch (SObjectException ex)
		{
		}

		if (approvedProposedPriceRawValue != null && currentSellPriceRawValue != null)
		{
			Decimal approvedProposedPrice = Decimal.valueOf(approvedProposedPriceRawValue);
			Decimal currentSellPrice = Decimal.valueOf(currentSellPriceRawValue);
			try
			{
				percentIncrease = (approvedProposedPrice - currentSellPrice) * 100 / currentSellPrice;
			}
			catch (MathException ex)
			{
				percentIncrease = 0;
			}
		}

		return percentIncrease;
	}

	public static Decimal getSummaryTotal(AggregateResult[] aggregateResults)
	{
		Decimal summaryTotal = 0;
        String summaryTotalRawValue;

        try
		{
			summaryTotalRawValue = String.valueOf(aggregateResults[0].get('summary'));
		}
		catch (SObjectException ex)
		{
		}

		if (summaryTotalRawValue != null)
		{
			summaryTotal = Decimal.valueOf(summaryTotalRawValue);
		}

		return summaryTotal;
	}

	public static Integer getCustomerCount(AggregateResult[] aggregateResults)
	{
        Integer customerCount = 0;
        String customerCountRawValue;

		try
		{
			customerCountRawValue = String.valueOf(aggregateResults[0].get('customerCount'));
		}
		catch (SObjectException ex)
		{
		}

		if (customerCountRawValue != null)
		{
			customerCount = Integer.valueOf(customerCountRawValue);
		}

		return customerCount;
	}
}