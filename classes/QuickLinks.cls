public without sharing class QuickLinks
{
	public QuickLinks()
	{
	}

	@AuraEnabled
	public static String getQuickLinks()
	{
		Map<String, FormattedSection> formattedSectionsMap;
		List<QuickLink__c> quickLinks;

		User user = [SELECT Id, Profile.Name FROM User WHERE Id =:UserInfo.getUserId()];
		quickLinks = [SELECT Id, Section__c, Name, Link__c, Active__c, HideFromProfiles__c FROM QuickLink__c WHERE HideFromProfiles__c EXCLUDES (:user.Profile.Name) AND Active__c = true];

		formattedSectionsMap = populateSections(quickLinks);
		formattedSectionsMap = populateLinks(quickLinks, formattedSectionsMap);
		formattedSectionsMap = orderSections(formattedSectionsMap);
		formattedSectionsMap = orderLinks(formattedSectionsMap);

		return JSON.serialize(formattedSectionsMap.values());
	}

	@AuraEnabled
	public static String getQuickLinks(String userId)
	{
		Map<String, FormattedSection> formattedSectionsMap;
		List<QuickLink__c> quickLinks;

		User user = [SELECT Id, Profile.Name FROM User WHERE Id =:userId];
		quickLinks = [SELECT Id, Section__c, Name, Link__c, Active__c, HideFromProfiles__c FROM QuickLink__c WHERE HideFromProfiles__c excludes (:user.Profile.Name) AND Active__c = true];

		formattedSectionsMap = populateSections(quickLinks);
		formattedSectionsMap = populateLinks(quickLinks, formattedSectionsMap);
		formattedSectionsMap = orderSections(formattedSectionsMap);
		formattedSectionsMap = orderLinks(formattedSectionsMap);

		return JSON.serialize(formattedSectionsMap.values());
	}

	// Given a list of quick links, returns a map of unique sections
	@AuraEnabled
	public static Map<String, FormattedSection> populateSections(List<QuickLink__c> quickLinks)
	{
		Map<String, FormattedSection> formattedSectionsMap = new Map<String, FormattedSection>();
		for (QuickLink__c quickLink : quickLinks)
		{
			// If we have the section's name, and it isn't already in the map, put it in the map
			String section = quickLink.Section__c;

			if (section != null && !formattedSectionsMap.containsKey(section))
			{
				// Using the section's name as the ID, since we are making
				// sure the section name will only appear in the map once.
				String id = section.replace(' ', '');
				formattedSectionsMap.put(section, new FormattedSection(id, section));
			}
		}
		return formattedSectionsMap;
	}

	// Given a list of quick links and a populated map of unique sections,
	// returns a populated map of unique sections with links inside
	@AuraEnabled
	public static Map<String, FormattedSection> populateLinks(List<QuickLink__c> quickLinks, Map<String, FormattedSection> formattedSectionsMap)
	{
		for (QuickLink__c quickLink : quickLinks)
		{
			String section = quickLink.Section__c;
			String link = quickLink.Link__c;
			String linkLabel = quickLink.Name;
			String id = quickLink.Id;
			Boolean isLinkValid = section != null && link != null && linkLabel != null && id != null;

			if (isLinkValid && formattedSectionsMap.containsKey(section))
			{
				FormattedLink formattedLink = new FormattedLink(id, linkLabel, link);
				FormattedSection formattedSection = (FormattedSection) formattedSectionsMap.get(section);
				formattedSection.links.add(formattedLink);
			}
		}

		return formattedSectionsMap;
	}

	public static Map<String, FormattedSection> orderSections(Map<String, FormattedSection> formattedSectionsMap)
	{
		List<FormattedSection> orderedSections = formattedSectionsMap.values();
		orderedSections.sort();
		Map<String, FormattedSection> orderedFormattedSectionsMap = new Map<String, FormattedSection>();

		for (FormattedSection orderedSection : orderedSections)
		{
			orderedFormattedSectionsMap.put(orderedSection.label, orderedSection);
		}

		return orderedFormattedSectionsMap;
	}

	public static Map<String, FormattedSection> orderLinks(Map<String, FormattedSection> formattedSectionsMap)
	{
		for (FormattedSection formattedSection : formattedSectionsMap.values())
		{
			formattedSection.links.sort();
		}
		return formattedSectionsMap;
	}

	public class FormattedLink implements Comparable
	{
		@AuraEnabled public String id;
		@AuraEnabled public String label;
		@AuraEnabled public String href;

		public FormattedLink(String id, String label, String href)
		{
			this.label = label;
			this.href = href;
			this.id = id;
		}

		public Integer compareTo(Object compareTo)
		{
			FormattedLink comparisonFormattedLabel = (FormattedLink) compareTo;
			return label.compareTo(comparisonFormattedLabel.label);
		}
	}

	public class FormattedSection implements Comparable
	{
		@AuraEnabled public String id;
		@AuraEnabled public String label;
		@AuraEnabled public List<FormattedLink> links;

		public FormattedSection(String id, String label)
		{
			this.id = id;
			this.label = label;
			this.links = new List<FormattedLink>();
		}

		public Integer compareTo(Object compareTo)
		{
			FormattedSection comparisonFormattedSection = (FormattedSection) compareTo;
			return label.compareTo(comparisonFormattedSection.label);
		}
	}
}