trigger ageInITQueue on Case(before insert, before update)
{
	Map<Id, Case> oldCases = new Map<Id, Case>();
	List<Case> newCases = Trigger.new;
	DateTime dateTimeToday = DateTime.now();
	String salesOpsQueueName = 'SalesOps Queue';
	Group salesOpsQueueGroup = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name =:salesOpsQueueName LIMIT 1];

	if (Trigger.isInsert)
	{
		for (Case newCase : Trigger.New)
		{
			if (newCase.OwnerId == salesOpsQueueGroup.Id)
			{
				newCase.Dummy_Date_Sales_Ops_Queue__c = dateTimeToday;
			}
		}
	}

	if (Trigger.isUpdate)
	{
		for (Case oldCase: Trigger.old)
		{
			oldCases.put(oldCase.Id, oldCase);
		}

		for (Case newCase : Trigger.new)
		{
			if (newCase.OwnerId == salesOpsQueueGroup.Id)
			{
                if (newCase.OwnerId != oldCases.get(newCase.Id).OwnerId || newCase.Dummy_Date_Sales_Ops_Queue__c == null)
                {
                    newCase.Dummy_Date_Sales_Ops_Queue__c = dateTimeToday;
                }
			}
		}
	}
}