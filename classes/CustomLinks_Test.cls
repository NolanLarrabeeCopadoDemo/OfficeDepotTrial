@IsTest
public class CustomLinks_Test
{
	@TestSetup
	static void makeData()
	{
		List<CustomLink__c> customLinks = new List<CustomLink__c>();
		List<Account> accounts = new List<Account>();

		CustomLink__c customLink1 =
			new CustomLink__c
			(
				Name = 'customLink1',
				Custom_Link_API_Name__c = 'webLink1',
				Object_API_Name__c = 'Account',
				IsActive__c = true
			);

		CustomLink__c customLink2 =
			new CustomLink__c
			(
				Name = 'customLink2',
				Custom_Link_API_Name__c = 'webLink2',
				Object_API_Name__c = 'Account',
				IsActive__c = false
			);

		CustomLink__c customLink3 =
			new CustomLink__c
			(
				Name = 'customLink3',
				Custom_Link_API_Name__c = 'webLink3',
				Object_API_Name__c = 'Account',
				IsActive__c = true
			);

		CustomLink__c customLink4 =
			new CustomLink__c
			(
				Name = 'customLink4',
				Custom_Link_API_Name__c = 'webLink4',
				Object_API_Name__c = 'Account',
				IsActive__c = true
			);

		customLinks.add(customLink1);
		customLinks.add(customLink2);
		customLinks.add(customLink3);
		customLinks.add(customLink4);
		insert customLinks;

		Account account1 =
			new Account
			(
				Name = 'SomeName',
				AOPS_Cust_Id__c = '1'
			);

		accounts.add(account1);
		insert accounts;
	}

	// Ensures we are handling inactive/active links properly
	@IsTest
	public static void testNumberOfSections()
	{
		List<CustomLinks.FormattedSection> formattedSections;
		String objectName = 'Account';
		Account account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'SomeName'];
		String recordId = String.valueOf(account.Id);

		Test.startTest();
		String jsonResult = CustomLinks.getCustomLinks(objectName, recordId);
		Test.stopTest();

		formattedSections = (List<CustomLinks.FormattedSection>) JSON.deserialize(jsonResult, List<CustomLinks.FormattedSection>.class);
		System.assertEquals(2, formattedSections.size());
	}

	// Ensures we are handling inactive/active links properly
	@IsTest
	public static void testNumberOfLinks()
	{
		List<CustomLinks.FormattedSection> formattedSections;
		String objectName = 'Account';
		Account account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'SomeName'];
		String recordId = String.valueOf(account.Id);
		Integer numberOfLinks = 0;

		Test.startTest();
		String jsonResult = CustomLinks.getCustomLinks(objectName, recordId);
		Test.stopTest();

		formattedSections = (List<CustomLinks.FormattedSection>) JSON.deserialize(jsonResult, List<CustomLinks.FormattedSection>.class);
		for (CustomLinks.FormattedSection formattedSection : formattedSections)
		{
			numberOfLinks += formattedSection.links.size();
		}

		System.assertEquals(3, numberOfLinks);
	}

	// Ensures we are replacing the merge fields with actual values
	@IsTest
	public static void testReplacesMergeFields()
	{
		List<CustomLinks.FormattedSection> formattedSections;
		String objectName = 'Account';
		Account account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'SomeName'];
		String recordId = String.valueOf(account.Id);

		Test.startTest();
		String jsonResult = CustomLinks.getCustomLinks(objectName, recordId);
		Test.stopTest();

		formattedSections = (List<CustomLinks.FormattedSection>) JSON.deserialize(jsonResult, List<CustomLinks.FormattedSection>.class);
		for (CustomLinks.FormattedSection formattedSection : formattedSections)
		{
			for (CustomLinks.FormattedLink formattedLink : formattedSection.links)
			{
				String mergeField = formattedLink.href.substringBetween('{!', '}');
				System.assertEquals(null, mergeField);
			}
		}
	}

	// Ensures we are replacing the merge fields with the correct actual values
	@IsTest
	public static void testCorrectlyReplacesMergeFields()
	{
		List<CustomLinks.FormattedSection> formattedSections;
		String objectName = 'Account';
		Account account = [SELECT Id, AOPS_Cust_Id__c, Name FROM Account WHERE Name = 'SomeName'];
		String recordId = String.valueOf(account.Id);

		Test.startTest();
		String jsonResult = CustomLinks.getCustomLinks(objectName, recordId);
		Test.stopTest();

		formattedSections = (List<CustomLinks.FormattedSection>) JSON.deserialize(jsonResult, List<CustomLinks.FormattedSection>.class);
		for (CustomLinks.FormattedSection formattedSection : formattedSections)
		{
			for (CustomLinks.FormattedLink formattedLink : formattedSection.links)
			{
				Boolean hasAccountName = formattedLink.href.contains('AccountName=') == true;
				if (hasAccountName)
				{
					String expectedValue = account.Name;
					String actualValue = formattedLink.href.substringBetween('AccountName=','&');
					if (actualValue == null)
					{
						actualValue = formattedLink.href.substringAfter('AccountName=');
					}
					System.assertEquals(expectedValue, actualValue);
				}

				Boolean hasAopsCustId = formattedLink.href.contains('AccountAopsCustId=') == true;
				if (hasAopsCustId)
				{
					String expectedValue = account.AOPS_Cust_Id__c;
					String actualValue = formattedLink.href.substringBetween('AccountAopsCustId=','&');
					if (actualValue == null)
					{
						actualValue = formattedLink.href.substringAfter('AccountAopsCustId=');
					}
					System.assertEquals(expectedValue, actualValue);
				}

				Boolean hasUserId = formattedLink.href.contains('UserId=') == true;
				if (hasUserId)
				{
					String expectedValue = UserInfo.getUserId();
					String actualValue = formattedLink.href.substringBetween('UserId=','&');
					if (actualValue == null)
					{
						actualValue = formattedLink.href.substringAfter('UserId=');
					}
					System.assertEquals(expectedValue, actualValue);
				}
			}
		}
	}

	// // NOTE: No need to test sorting at the moment, as we're
	// // using the standard Salesforce method (.sort()).
	// // Ensures we are sorting sections and links properly
	// @IsTest
	// public static void testSectionsAndLinksAlphabeticallyOrdered()
	// {
	// 	List<CustomLinks.FormattedSection> formattedSections;
	// 	List<CustomLinks.FormattedSection> orderedFormattedSections;
	// 	String objectName = 'Account';
	// 	Account account = [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE Name = 'SomeName'];
	// 	String recordId = String.valueOf(account.Id);

	// 	Test.startTest();
	// 	String jsonResult = CustomLinks.getCustomLinks(objectName, recordId);
	// 	Test.stopTest();

	// 	formattedSections = (List<CustomLinks.FormattedSection>) JSON.deserialize(jsonResult, List<CustomLinks.FormattedSection>.class);
	// 	orderedFormattedSections = new List<CustomLinks.FormattedSection>();
	// 	orderedFormattedSections = cloneFormattedSections(formattedSections);
	// 	orderedFormattedSections.sort();

	// 	for (CustomLinks.FormattedSection orderedFormattedSection : orderedFormattedSections)
	// 	{
			
	// 	}

	// 	System.assertEquals(orderedFormattedSections, formattedSections);
	// }

	// private static List<CustomLinks.FormattedSection> cloneFormattedSections (List<CustomLinks.FormattedSection> formattedSectionsToClone)
	// {
	// 	List<CustomLinks.FormattedSection> clonedFormattedSections = new List<CustomLinks.FormattedSection>();
	// 	for (CustomLinks.FormattedSection formattedSection : formattedSectionsToClone)
	// 	{
	// 		String sectionId = formattedSection.id;
	// 		String sectionLabel = formattedSection.label;
	// 		CustomLinks.FormattedSection clonedFormattedSection = new CustomLinks.FormattedSection(sectionId, sectionLabel);

	// 		for (CustomLinks.FormattedLink formattedLinkToClone : formattedSection.links)
	// 		{
	// 			String linkId = formattedLinkToClone.id;
	// 			String linkLabel = formattedLinkToClone.label;
	// 			String href = formattedLinkToClone.href;
	// 			CustomLinks.FormattedLink clonedFormattedLink = new CustomLinks.FormattedLink(linkId, linkLabel, href);
	// 			clonedFormattedSection.links.add(clonedFormattedLink);
	// 		}

	// 		clonedFormattedSections.add(clonedFormattedSection);
	// 	}

	// 	return clonedFormattedSections;
	// }
}