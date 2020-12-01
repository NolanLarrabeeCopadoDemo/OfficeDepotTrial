@IsTest
public class RepQueueAssignment_Test
{
	@TestSetup
	static void makeData()
	{
		Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
		User user1 = new User(
			Alias = 'rqa1', Email = 'rqa1@officedepot.com',
			EmailEncodingKey = 'UTF-8', LastName = 'rqa1', LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US', ProfileId = profile.Id,
			TimeZoneSidKey = 'America/Los_Angeles', UserName = 'rqa1@officedepot.com'
			);
		insert user1;
		User user2 = new User(
			Alias = 'rqa2', Email = 'rqa2@officedepot.com',
			EmailEncodingKey = 'UTF-8', LastName = 'rqa2', LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US', ProfileId = profile.Id,
			TimeZoneSidKey = 'America/Los_Angeles', UserName = 'rqa2@officedepot.com', ManagerId = user1.Id
			);
		insert user2;

		List<QueueSobject> leadQueues = RepQueueAssignment.getLeadQueues();

		Rep_Queue_Assignment__c rqa2 = new Rep_Queue_Assignment__c(
			Queue_Name__c = leadQueues.get(0).Queue.Name,
			Sales_Rep__c = user2.Id,
			Priority__c = '1'
			);
		insert rqa2;
	}

	@IsTest
	public static void testGetUsersFromIdsSuccess()
	{
		User user1 = [SELECT Id FROM User WHERE LastName = 'rqa1' LIMIT 1];
		Set<Id> userIds = new Set<Id> { user1.Id };

		Test.startTest();
		List<User> usersFromIds = RepQueueAssignment.getUsersFromIds(userIds);
		Test.stopTest();

		System.assertEquals(1, usersFromIds.size());
		System.assertEquals(user1.Id, usersFromIds.get(0).Id);
	}

	@IsTest
	public static void testGetCurrentUserDirectReportsSuccess()
	{
		User user1 = [SELECT Id FROM User WHERE LastName = 'rqa1' LIMIT 1];
		User user2 = [SELECT Id FROM User WHERE LastName = 'rqa2' LIMIT 1];
		List<User> directReports = new List<User>();

		Test.startTest();
		System.runAs(user1)
		{
			directReports = RepQueueAssignment.getCurrentUserDirectReports();
		}
		Test.stopTest();
		System.assertEquals(1, directReports.size());
		System.assertEquals(user2.Id, directReports.get(0).Id);
	}

	@IsTest
	public static void testGetCurrentUserDirectReportsNamesSuccess()
	{
		User user1 = [SELECT Id, Name FROM User WHERE LastName = 'rqa1' LIMIT 1];
		User user2 = [SELECT Id, Name FROM User WHERE LastName = 'rqa2' LIMIT 1];
		List<String> directReportsNames = new List<String>();

		Test.startTest();
		System.runAs(user1)
		{
			directReportsNames = RepQueueAssignment.getCurrentUserDirectReportsNames();
		}
		Test.stopTest();
		System.assertEquals(1, directReportsNames.size());
		System.assertEquals(user2.Name, directReportsNames.get(0));
	}

	@IsTest
	public static void testGetQueueAssignmentsSuccess()
	{
		User user1 = [SELECT Id, Name FROM User WHERE LastName = 'rqa1' LIMIT 1];
		User user2 = [SELECT Id, Name FROM User WHERE LastName = 'rqa2' LIMIT 1];
		List<Map<String, Object> > queueAssignments = new List<Map<String, Object> >();

		Test.startTest();
		System.runAs(user1)
		{
			queueAssignments = RepQueueAssignment.getQueueAssignments();
		}
		Test.stopTest();
		System.assertEquals(1, queueAssignments.size());
		System.assertEquals(user2.Name, queueAssignments.get(0).get('repName'));
	}

	@IsTest
	public static void testGetQueueAssignmentsError()
	{
		User user1 = [SELECT Id, Name FROM User WHERE LastName = 'rqa1' LIMIT 1];
		User user2 = [SELECT Id, Name FROM User WHERE LastName = 'rqa2' LIMIT 1];
		List<Map<String, Object> > queueAssignments = new List<Map<String, Object> >();

		Test.startTest();
		System.runAs(user1)
		{
			try
			{
				queueAssignments = RepQueueAssignment.getQueueAssignments();
			}
			catch (AuraHandledException ex)
			{
				System.assert(ex != null);
			}
		}
		Test.stopTest();
	}

	@IsTest
	public static void testSetQueueAssignmentsSuccessCreateNewAssignment()
	{
		User user1 = [SELECT Id, Name FROM User WHERE LastName = 'rqa1' LIMIT 1];
		User user2 = [SELECT Id, Name FROM User WHERE LastName = 'rqa2' LIMIT 1];
		List<QueueSObject> leadQueues = RepQueueAssignment.getLeadQueues();
		List<Map<String, Object>> queueAssignments = new List<Map<String, Object>>();
		Boolean isSuccessful = false;

		String repId = user2.Id;
		String repName = user2.Name;
		String queueName = leadQueues.get(1).Queue.Name;
		String priority = '1';

		Map<String, Object> qa1 = new Map<String, Object>();
		qa1.put('repName', repName);
		qa1.put(queueName, priority);
		queueAssignments.add(qa1);

		Test.startTest();
		System.runAs(user1)
		{
			isSuccessful = RepQueueAssignment.setQueueAssignments(queueAssignments);
		}
		Test.stopTest();
		System.assertEquals(true, isSuccessful);
		Rep_Queue_Assignment__c rqa1 = [SELECT Id, Sales_Rep__c, Priority__c, Queue_Name__c FROM Rep_Queue_Assignment__c WHERE Sales_Rep__c = :repId AND Queue_Name__c = :queueName AND Priority__c = :priority LIMIT 1];
		System.assert(rqa1 != null);
	}

	@IsTest
	public static void testSetQueueAssignmentsSuccessUpdateAssignment()
	{
		User user1 = [SELECT Id, Name FROM User WHERE LastName = 'rqa1' LIMIT 1];
		User user2 = [SELECT Id, Name FROM User WHERE LastName = 'rqa2' LIMIT 1];
		List<QueueSObject> leadQueues = RepQueueAssignment.getLeadQueues();
		List<Map<String, Object>> queueAssignments = new List<Map<String, Object>>();
		Boolean isSuccessful = false;

		String repId = user2.Id;
		String repName = user2.Name;
		String queueName = leadQueues.get(0).Queue.Name;
		String priority = '5';

		Map<String, Object> qa1 = new Map<String, Object>();
		qa1.put('repName', repName);
		qa1.put(queueName, priority);
		queueAssignments.add(qa1);

		Test.startTest();
		System.runAs(user1)
		{
			isSuccessful = RepQueueAssignment.setQueueAssignments(queueAssignments);
		}
		Test.stopTest();
		System.assertEquals(true, isSuccessful);
		Rep_Queue_Assignment__c rqa1 = [SELECT Id, Sales_Rep__c, Priority__c, Queue_Name__c FROM Rep_Queue_Assignment__c WHERE Sales_Rep__c = :repId AND Queue_Name__c = :queueName AND Priority__c = :priority LIMIT 1];
		System.assert(rqa1 != null);
	}
}