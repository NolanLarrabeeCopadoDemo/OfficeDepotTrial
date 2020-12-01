public with sharing class RepQueueAssignment
{
    private static final Integer MINIMUM_PRIORITY = 1, MAXIMUM_PRIORITY = 10;
	/**
	 * Returns a map of the rep's name to a map of the queue name and the priority.
	 */
	@AuraEnabled
	public static List<Map<String, Object> > getQueueAssignments()
	{
		List<String> directReportNames = getCurrentUserDirectReportsNames();
		Map<String, Map<String, Object> > directReportToQueueMap = new Map<String, Map<String, Object> >();
		List<Rep_Queue_Assignment__c> repQueueAssignments = getRepQueueAssignments();
		List<Map<String, Object>> formattedQueueAssignment = new List<Map<String, Object>>();

		/**
		 * Error handling
		 */
		if (directReportNames.isEmpty())
		{
			throw new AuraHandledException('You have no direct reports.');
		}


		/**
		 * Fill the map with all the user's direct reports
		 */
		for (String directReportName : directReportNames)
		{
			directReportToQueueMap.put(directReportName, new Map<String, Object>());
		}

		for (Rep_Queue_Assignment__c repQueueAssignment : repQueueAssignments)
		{
			Map<String, Object> queueAssignment = new Map<String, Object>();
			String repName = repQueueAssignment.Sales_Rep__r.Name;
			String queueName = repQueueAssignment.Queue_Name__c;
			Integer priority;

			if (repQueueAssignment.Priority__c != null && repQueueAssignment.Priority__c.isNumeric())
			{
				priority = Integer.valueOf(repQueueAssignment.Priority__c);
			}

			if (repName != null && queueName != null)
			{
				/**
				 * Checking if the key exists to make sure this rep is a 
				 * direct report of the current user.
				 */
				if (directReportToQueueMap.containsKey(repName))
				{
					Map<String, Object> queueAssignments = directReportToQueueMap.get(repName);
					queueAssignments.put(queueName, priority);
				}
			}
		}

		formattedQueueAssignment = formatQueueAssignments(directReportToQueueMap);
		return formattedQueueAssignment;
	}

	/**
	 * Called from the front-end LWC to set the queue assignments.
	 * Returns true if everything went OK. Otherwise, false.
	 */
	@AuraEnabled
	public static Boolean setQueueAssignments(List<Map<String, Object> > queueAssignments)
	{
		List<Rep_Queue_Assignment__c> allQueueAssignments = new List<Rep_Queue_Assignment__c>();
		List<Rep_Queue_Assignment__c> newQueueAssignments = new List<Rep_Queue_Assignment__c>();
		List<Rep_Queue_Assignment__c> updatedQueueAssignments = new List<Rep_Queue_Assignment__c>();
		List<Rep_Queue_Assignment__c> currentQueueAssignments = getRepQueueAssignments();
        currentQueueAssignments = filterDirectReportsQueueAssignments(currentQueueAssignments);
        
		for (Map<String, Object> queueAssignment : queueAssignments)
		{
			String repName = String.valueOf(queueAssignment.get('repName'));

			for (String key : queueAssignment.keySet())
			{
				if (key != 'repName')
				{
					String queueName = key;
					String priority = String.valueOf(queueAssignment.get(key));
                    Boolean isExisting = isExistingQueueAssignment(currentQueueAssignments, repName, queueName, priority);
                    
					if (isExisting)
					{
                        Boolean isChanged = isPriorityChanged(currentQueueAssignments, repName, queueName, priority);
                        Boolean isValid = isPriorityValid(priority);

						if (isChanged && isValid)
						{
							Rep_Queue_Assignment__c updatedQueueAssignment = updateQueueAssignment(currentQueueAssignments, repName, queueName, priority);
							updatedQueueAssignments.add(updatedQueueAssignment);
						}
					}
					else
					{
						if (priority != null)
						{
							User rep = [SELECT Id, Name, ManagerId FROM User WHERE Name =:repName LIMIT 1];
							Rep_Queue_Assignment__c newQueueAssignment = createQueueAssignment(rep, queueName, priority);
							newQueueAssignments.add(newQueueAssignment);
						}
					}
				}
			}
		}

		allQueueAssignments.addAll(newQueueAssignments);
		allQueueAssignments.addAll(updatedQueueAssignments);

		upsert allQueueAssignments;
		return true;
	}

	/**
	 * Returns a list of QueueSobjects that are mapped to the Lead Sobject.
	 */
	@AuraEnabled
	public static List<QueueSobject> getLeadQueues()
	{
		return [SELECT Id, SobjectType, QueueId, Queue.Name, Queue.Email FROM QueueSobject WHERE SobjectType = 'Lead' ORDER BY Queue.Name];
	}

	/**
	 * Formats the response for the front end.
	 */
	@TestVisible
	private static List<Map<String, Object>> formatQueueAssignments(Map<String, Map<String, Object>> queueAssignments)
	{
		List<Map<String, Object>> formattedQueueAssignments = new List<Map<String, Object>>();
		for (String repName : queueAssignments.keySet())
		{
			Map<String, Object> formattedMap = new Map<String, Object>();
			formattedMap.put('repName', repName);
			formattedMap.putAll(queueAssignments.get(repName));
			formattedQueueAssignments.add(formattedMap);
		}

		return formattedQueueAssignments;
	}

	/**
	 * Returns whether the queue assignment exists in the provided list already with the same priority.
	 */
	@TestVisible
	private static Boolean isExistingQueueAssignment(List<Rep_Queue_Assignment__c> queueAssignments, String repName, String queueName, String priority)
	{
		Boolean isExisting = false;

		for (Rep_Queue_Assignment__c queueAssignment : queueAssignments)
		{
			Boolean isSameRep = queueAssignment.Sales_Rep__r.Name == repName;
			Boolean isSameQueue = queueAssignment.Queue_Name__c == queueName;

			if (isSameRep && isSameQueue)
			{
				isExisting = true;
				break;
			}
		}

		return isExisting;
    }

	/**
	 * Returns whether the queue assignment's priority was changed.
	 */
	@TestVisible
	private static Boolean isPriorityChanged(List<Rep_Queue_Assignment__c> queueAssignments, String repName, String queueName, String priority)
	{
		Boolean isChanged = false;

		for (Rep_Queue_Assignment__c queueAssignment : queueAssignments)
		{
			Boolean isSameRep = queueAssignment.Sales_Rep__r.Name == repName;
			Boolean isSameQueue = queueAssignment.Queue_Name__c == queueName;
			Boolean isSamePriority = queueAssignment.Priority__c == priority;

			if (isSameRep && isSameQueue && !isSamePriority)
			{
				isChanged = true;
				break;
			}
		}

		return isChanged;
    }
    
    private static Boolean isPriorityValid(String priority)
    {
        Integer parsedPriority;

        if (String.isNotBlank(priority))
        {
            try
            {
                parsedPriority = Integer.valueOf(priority);
            }
            catch (TypeException ex)
            {
                return false;
            }
        }

        return String.isBlank(priority) || parsedPriority >= MINIMUM_PRIORITY && parsedPriority <= MAXIMUM_PRIORITY;
    }

	/**
	 * Given a list of req queue assignments, modifies the list in place and
	 * sets the given priority on the given queue name.
	 * Returns the modified rep queue assignment.
	 */
	private static Rep_Queue_Assignment__c updateQueueAssignment(List<Rep_Queue_Assignment__c> queueAssignments, String repName, String queueName, String priority)
	{
		for (Rep_Queue_Assignment__c queueAssignment : queueAssignments)
		{
			Boolean isSameRep = queueAssignment.Sales_Rep__r.Name == repName;
			Boolean isSameQueue = queueAssignment.Queue_Name__c == queueName;
			if (isSameRep && isSameQueue)
			{
				queueAssignment.Priority__c = priority;
				return queueAssignment;
			}
		}

		return null;
	}

	/**
	 * Creates a new queue assignment and returns it.
	 */
	@TestVisible
	private static Rep_Queue_Assignment__c createQueueAssignment(User rep, String queueName, String priority)
	{
		Rep_Queue_Assignment__c newQueueAssignment = new Rep_Queue_Assignment__c();
		newQueueAssignment.Queue_Name__c = queueName;
		newQueueAssignment.Sales_Rep__c = rep.Id;
		newQueueAssignment.Priority__c = priority;
		newQueueAssignment.Manager__c = rep.ManagerId;

		return newQueueAssignment;
	}

	/**
	 * Returns a filtered list of the queue assignments.
	 * Deletes rows that aren't editable by this user.
	 */
	@TestVisible
	private static List<Rep_Queue_Assignment__c> filterDirectReportsQueueAssignments(List<Rep_Queue_Assignment__c> queueAssignments)
	{
		List<String> currentUserDirectReportNames = getCurrentUserDirectReportsNames();
		List<Rep_Queue_Assignment__c> filteredQueueAssignments = new List<Rep_Queue_Assignment__c>();

		for (Rep_Queue_Assignment__c queueAssignment : queueAssignments)
		{
			String repName = queueAssignment.Sales_Rep__r.Name;
			Boolean repIsDirectReport = currentUserDirectReportNames.contains(repName);
			if (repIsDirectReport)
			{
				filteredQueueAssignments.add(queueAssignment);
			}
		}

		return filteredQueueAssignments;
	}

	/**
	 * Given a list of all the records in the Rep_Queue_Assignment__c object,
	 * returns the ones that are only Lead queues.
	 */
	@TestVisible
	private static List<Rep_Queue_Assignment__c> getRepQueueAssignments()
	{
		List<Rep_Queue_Assignment__c> repQueueAssignments = [SELECT Id, Queue_Name__c, Priority__c, Sales_Rep__c, Sales_Rep__r.Name FROM Rep_Queue_Assignment__c];
		List<Rep_Queue_Assignment__c> filteredRepQueueAssignments = new List<Rep_Queue_Assignment__c>();
		List<String> leadQueues = getLeadQueueNames();

		for (Rep_Queue_Assignment__c repQueueAssignment : repQueueAssignments)
		{
			if (leadQueues.contains(repQueueAssignment.Queue_Name__c))
			{
				filteredRepQueueAssignments.add(repQueueAssignment);
			}
		}

		return filteredRepQueueAssignments;
	}

	/**
	 * Returns the current user's direct reports' users as List<User>.
	 */
	@TestVisible
	private static List<User> getCurrentUserDirectReports()
	{
		// Id currentUserId = '005E0000000vZLXIA2';
		Id currentUserId = UserInfo.getUserId();
		Set<Id> userId = new Set<Id> {currentUserId};
		Boolean isRepQueueUser = getIsRepQueueUser(currentUserId);
		Set<Id> directReportUserIds = getDirectReportUserIds(userId, isRepQueueUser);
		List<User> activeDirectReports = getUsersFromIds(directReportUserIds);

		return activeDirectReports;
	}

	/**
	 * Gets a List<String> of the user's direct reports' names (recursive).
	 */
	@TestVisible
	private static List<String> getCurrentUserDirectReportsNames()
	{
		List<User> directReports = getCurrentUserDirectReports();
		List<String> directReportNames = new List<String>();

		for (User directReport : directReports)
		{
			directReportNames.add(directReport.Name);
		}

		return directReportNames;
	}

	/**
	 * Returns a string list of names of the QueueSobjects that are mapped to the Lead Sobject.
	 */
	@TestVisible
	private static List<String> getLeadQueueNames()
	{
		List<QueueSobject> leadQueues = getLeadQueues();
		List<String> leadQueueNames = new List<String>();
		for (QueueSobject queue : leadQueues)
		{
			leadQueueNames.add(queue.Queue.Name);
		}
		return leadQueueNames;
	}

	/**
	 * Returns whether the user with id userId is allowed to use the rep queue assignment functionality.
	 */
	@TestVisible
	private static Boolean getIsRepQueueUser(String userId)
	{
		List<Rep_Queue_Assignment_Users__mdt> repQueueUsers = [SELECT MasterLabel, DeveloperName, Id FROM Rep_Queue_Assignment_Users__mdt];
		User user;

		try
		{
			user = [SELECT Id, Name FROM User WHERE Id =:userId LIMIT 1];
		}
		catch (QueryException ex)
		{
			return false;
		}

		for (Rep_Queue_Assignment_Users__mdt repQueueUser : repQueueUsers)
		{
			if (repQueueUser.MasterLabel == user.Name)
			{
				return true;
			}
		}

		return false;
	}

	/**
	 * Returns the current user's direct reports' user ids  as a Set<Id>
	 */
	@TestVisible
	private static Set<Id> internal_getDirectReportUserIds(Set<Id> userIds)
	{
		Set<Id> directReportUserIds = new Set<Id>();
		List<User> directReports = [SELECT Id FROM User WHERE ManagerId IN :userIds];

		for (User directReport : directReports)
		{
			directReportUserIds.add(directReport.Id);
		}

		return directReportUserIds;
	}

	/**
	 * Returns the current user's direct reports' (and, recuresively, their
	 * direct reports) user ids as a Set<Id>.
	 */
	@TestVisible
	private static Set<Id> getDirectReportUserIds(Set<Id> userIds, Boolean isRepQueueUser)
	{
		Set<Id> directReportUserIds = internal_getDirectReportUserIds(userIds);

		if (directReportUserIds.size() > 0 && isRepQueueUser)
		{
			directReportUserIds.addAll(getDirectReportUserIds(directReportUserIds, isRepQueueUser));
		}

		return directReportUserIds;
	}

	/**
	 * Returns a List<User> of active users given a Set<Id> of users.
	 */
	@TestVisible
	private static List<User> getUsersFromIds(Set<Id> userIds)
	{
		return [SELECT Id, Name FROM User WHERE Id IN : userIds AND IsActive = true];
	}
}