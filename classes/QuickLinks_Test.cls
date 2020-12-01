@IsTest
public class QuickLinks_Test
{
	// Total links: 8
	// Total active links: 6
	// Links available to Sys Admin: 4
	// Links in Section Applications: 1
	// Links in Section Global: 1
	// Links in Section Reports: 1
	// Links in Section Marketing: 4
	// Links in Section Training: 1
	
	@TestSetup
	static void makeData()
	{
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@officedepot.com';
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User
		(
			Alias = 'Test', Email = 'test@officedepot.com.com',
			EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
			LocaleSidKey = 'en_US', ProfileId = p.Id,
			TimeZoneSidKey = 'America/Los_Angeles',
			UserName = uniqueUserName
		);

		List<QuickLink__c> quickLinks = new List<QuickLink__c>();

		// Inactive
		// Hidden from Sys Admin
		// Section A
		QuickLink__c ql1 = new QuickLink__c();
		ql1.Section__c = 'Applications';
		ql1.Name = 'A';
		ql1.Link__c = 'http://officedepot.com';
		ql1.Active__c = false;
		ql1.HideFromProfiles__c = 'System Administrator';
		quickLinks.add(ql1);

		// Inactive
		// Section B
		QuickLink__c ql2 = new QuickLink__c();
		ql2.Section__c = 'Global';
		ql2.Name = 'B';
		ql2.Link__c = 'http://officedepot.com';
		ql2.Active__c = false;
		quickLinks.add(ql2);

		// Active
		// Hidden from Sys Admin
		// Section C
		QuickLink__c ql3 = new QuickLink__c();
		ql3.Section__c = 'Reports';
		ql3.Name = 'C';
		ql3.Link__c = 'http://officedepot.com';
		ql3.Active__c = true;
		ql3.HideFromProfiles__c = 'System Administrator';
		quickLinks.add(ql3);

		// Active
		// Section D	
		QuickLink__c ql4 = new QuickLink__c();
		ql4.Section__c = 'Marketing';
		ql4.Name = 'A';
		ql4.Link__c = 'http://officedepot.com';
		ql4.Active__c = true;
		quickLinks.add(ql4);

		// Active
		// Section E
		QuickLink__c ql5 = new QuickLink__c();
		ql5.Section__c = 'Training';
		ql5.Name = 'E';
		ql5.Link__c = 'http://officedepot.com';
		ql5.Active__c = true;
		ql5.HideFromProfiles__c = 'System Administrator';
		quickLinks.add(ql5);

		// Active
		// Section D
		QuickLink__c ql6 = new QuickLink__c();
		ql6.Section__c = 'Marketing';
		ql6.Name = 'B';
		ql6.Link__c = 'http://officedepot.com';
		ql6.Active__c = true;
		quickLinks.add(ql6);

		// Active
		// Section D
		QuickLink__c ql7 = new QuickLink__c();
		ql7.Section__c = 'Marketing';
		ql7.Name = 'C';
		ql7.Link__c = 'http://officedepot.com';
		ql7.Active__c = true;
		quickLinks.add(ql7);

		// Active
		// Section D
		QuickLink__c ql8 = new QuickLink__c();
		ql8.Section__c = 'Marketing';
		ql8.Name = 'D';
		ql8.Link__c = 'http://officedepot.com';
		ql8.Active__c = true;
		quickLinks.add(ql8);

		insert quickLinks;
	}

	@IsTest
	static void testNumberOfActiveSections()
	{
		List<QuickLinks.FormattedSection> formattedSections;
		Test.startTest();
		String jsonResult = QuickLinks.getQuickLinks();
		Test.stopTest();
		formattedSections = (List<QuickLinks.FormattedSection>) JSON.deserialize(jsonResult, List<QuickLinks.FormattedSection>.class);
		System.assertEquals(1, formattedSections.size());
	}

	@IsTest
	static void testNumberOfActiveLinks()
	{
		List<QuickLinks.FormattedSection> formattedSections;
		Test.startTest();
		String jsonResult = QuickLinks.getQuickLinks();
		Test.stopTest();
		formattedSections = (List<QuickLinks.FormattedSection>) JSON.deserialize(jsonResult, List<QuickLinks.FormattedSection>.class);
		Integer numberOfLinks = 0;
		for (QuickLinks.FormattedSection formattedSection : formattedSections)
		{
			numberOfLinks += formattedSection.links.size();
		}
		System.assertEquals(4, numberOfLinks);
	}

	@IsTest
	static void testAreSectionsOrdered()
	{
		List<QuickLinks.FormattedSection> formattedSections;
		Test.startTest();
		String jsonResult = QuickLinks.getQuickLinks();
		Test.stopTest();
		formattedSections = (List<QuickLinks.FormattedSection>) JSON.deserialize(jsonResult, List<QuickLinks.FormattedSection>.class);
		List<QuickLinks.FormattedSection> orderedFormattedSections = formattedSections;
		orderedFormattedSections.sort();
		System.assertEquals(formattedSections, orderedFormattedSections);
	}

	@IsTest
	static void testAreLinksOrdered()
	{
		List<QuickLinks.FormattedSection> formattedSections;
		Test.startTest();
		String jsonResult = QuickLinks.getQuickLinks();
		Test.stopTest();
		formattedSections = (List<QuickLinks.FormattedSection>) JSON.deserialize(jsonResult, List<QuickLinks.FormattedSection>.class);
		for (QuickLinks.FormattedSection formattedSection : formattedSections)
		{
			List<QuickLinks.FormattedLink> orderedFormattedLinks = formattedSection.links;
			orderedFormattedLinks.sort();
			System.assertEquals(formattedSection.links, orderedFormattedLinks);
		}
	}

	@IsTest
	static void testAreLinksHidden()
	{
		User systemAdministrator = [SELECT Id, Profile.Name FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1];
		List<QuickLinks.FormattedSection> formattedSections;
		Test.startTest();
		String jsonResult = QuickLinks.getQuickLinks(systemAdministrator.Id);
		Test.stopTest();
		formattedSections = (List<QuickLinks.FormattedSection>) JSON.deserialize(jsonResult, List<QuickLinks.FormattedSection>.class);
		Integer numberOfLinks = 0;
		for (QuickLinks.FormattedSection formattedSection : formattedSections)
		{
			numberOfLinks += formattedSection.links.size();
		}
		System.assertEquals(4, numberOfLinks);
	}
}