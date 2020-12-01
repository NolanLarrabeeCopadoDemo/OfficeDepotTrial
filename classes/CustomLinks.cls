public without sharing class CustomLinks
{
	public CustomLinks()
	{
	}

	// Given an object name and a record id, returns List<FormattedSection> serialized into json
	// the List<FormattedSection> will contain ordered, formatted, populated sections with
	// ordered, formatted, populated links
	@AuraEnabled
	public static String getCustomLinks (String objectApiName, String recordId)
	{
		Map<String, List<String> > objectsAndFields = new Map<String, List<String> >();
		Map<String, Schema.SObjectType> availableObjects = Schema.getGlobalDescribe();
		Map<String, sObject> records;
		List<WebLink> webLinks = new List<Weblink>();
		List<FormattedSection> formattedSections = new List<FormattedSection>();
		List<CustomLink__c> customLinks;
		List<String> customLinksApiNames;

		// Query for the Custom Links,
		// collect all the proper merge fields from within those links,
		// query for the record and get the values of those fields,
		// replace the merge fields with the actual values
		// return the result
		try
		{
			// Get the Custom Links names that we've defined to be used for this component
			// and collect the API names of those Custom Links
			customLinks = [SELECT Id, Name, Custom_Link_API_Name__c, Object_API_Name__c, IsActive__c FROM CustomLink__c WHERE Object_API_Name__c =:objectApiName AND IsActive__c = true];
			customLinksApiNames = new List<String>();
			for (CustomLink__c customLink : customLinks)
			{
				customLinksApiNames.add(customLink.Name);
			}

			// Get the WebLinks whose API name matches what we've collected
			// We have to provide test data in here because it is not possible to insert
			// WebLinks in test classes at the moment.
			if (!Test.isRunningTest())
			{
				webLinks = [SELECT Id, PageOrSobjectType, Name, Url, LinkType, MasterLabel FROM WebLink WHERE PageOrSobjectType =:objectApiName AND LinkType = 'url' AND Name IN:customLinksApiNames];
			}
			else
			{
				WebLink webLink1 =
					new WebLink
					(
						PageOrSobjectType = 'Account',
						Name = 'webLink1',
						Url = 'https://officedepot.my.salesforce.com/?AccountName={!Account.Name}&AccountAopsCustId={!Account.AOPS_Cust_Id__c}&UserId={!User.Id}',
						LinkType = 'url',
						MasterLabel = 'A WebLink 1'
					);

				WebLink webLink2 =
					new WebLink
					(
						PageOrSobjectType = 'Account',
						Name = 'webLink2',
						Url = 'https://officedepot.my.salesforce.com/?AccountName={!Account.Name}&AccountAopsCustId={!Account.AOPS_Cust_Id__c}&UserId={!User.Id}',
						LinkType = 'url',
						MasterLabel = 'B WebLink 2'
					);

				WebLink webLink3 =
					new WebLink
					(
						PageOrSobjectType = 'Account',
						Name = 'webLink3',
						Url = 'https://officedepot.my.salesforce.com/?AccountName={!Account_Name}&UserId={!User.Id}',
						LinkType = 'url',
						MasterLabel = 'A WebLink 3'
					);

				WebLink webLink4 =
					new WebLink
					(
						PageOrSobjectType = 'Account',
						Name = 'webLink4',
						Url = 'https://officedepot.my.salesforce.com/?AccountName={!Account.Name}',
						LinkType = 'url',
						MasterLabel = 'Bee WebLink 4'
					);

				webLinks.add(webLink1);
				webLinks.add(webLink2);
				webLinks.add(webLink3);
				webLinks.add(webLink4);
			}

			objectsAndFields = extractMergeFields(webLinks, availableObjects);
			records = getRecords(objectsAndFields, recordId);
			formattedSections = generateCustomLinks(webLinks, objectsAndFields, records, availableObjects);
			return JSON.serialize(formattedSections);
		}
		// If this is a 'No such column' exception, then
		// remove the field from the query and try again
		catch (QueryException ex)
		{
			String exceptionMessage = ex.getMessage();
			Boolean hasInvalidField = exceptionMessage.indexOf('No such column') != -1;

			while (hasInvalidField)
			{
				String objectName = exceptionMessage.substringBetween('on entity \'', '\'');
				String invalidFieldName = exceptionMessage.substringBetween('No such column\'', '\'');
				Boolean isValidError = objectName != null && invalidFieldName != null && objectsAndFields.containsKey(objectName);

				if (isValidError)
				{
					List<String> fields = objectsAndFields.get(objectName);
					Integer indexOfInvalidFieldInList = fields.indexOf(invalidFieldName);

					// If we have this field in the list, remove it
					if (indexOfInvalidFieldInList != -1)
					{
						fields.remove(indexOfInvalidFieldInList);
					}

					// Then, try again
					try
					{
						records = getRecords(objectsAndFields, recordId);
						formattedSections = generateCustomLinks(webLinks, objectsAndFields, records, availableObjects);
						return JSON.serialize(formattedSections);
					}
					catch (QueryException qex)
					{
						exceptionMessage = qex.getMessage();
						hasInvalidField = exceptionMessage.indexOf('No such column') != -1;
					}
				}
			}

			// If we were unable to perform correctly, throw an error
			throw new AuraHandledException(ex.getMessage());
		}
	}

	// Returns a list of the field names extracted from the provided custom links
	private static Map<String, List<String>> extractMergeFields (List<WebLink> webLinks, Map<String, Schema.SObjectType> availableObjects)
	{
		Map<String, List<String> > objectsAndFields = new Map<String, List<String> >();

		for (WebLink webLink : webLinks)
		{
			String link = webLink.Url;
			String mergeField = link.substringBetween('{!', '}');

			// While there is a merge field
			// Get the name of the object and the field from the merge field
			// Add the name of the object as they key, and the field to the list in the map
			// Remove the merge field we just worked on, from the string
			// Try to find the next merge field and repeat
			while (mergeField != null)
			{
				String objectName = mergeField.substringBefore('.');
				String fieldName = mergeField.substringAfter('.');
				Boolean isValidMergeField = fieldName != null && objectName != null && availableObjects.containsKey(objectName.toLowerCase());

				if (isValidMergeField)
				{
					// Change to lower case because Apex is case-insensitive which
					// means other devs can write the field and object names in mixed cases
					objectName = objectName.toLowerCase();
					fieldName = fieldName.toLowerCase();

					// If we don't have this object in our map, add it and instantiate
					// the list with the field name
					// Otherwise just add the field to the list
					if (!objectsAndFields.containsKey(objectName))
					{
						objectsAndFields.put(objectName, new List<String> { fieldName });
					}
					else
					{
						List<String> fields = ((List<String>) objectsAndFields.get(objectName));
						Boolean alreadyHasValue = fields.contains(fieldName);
						if (!alreadyHasValue)
						{
							fields.add(fieldName);
						}
					}
				}

				link = link.remove('{!' + mergeField + '}');
				mergeField = link.substringBetween('{!', '}');
			}
		}

		return objectsAndFields;
	}

	// Queries the specified fields of the specified object
	// Uses 'recordId' when applicable
	private static Map<String, sObject> getRecords (Map<String, List<String>> objectsAndFields, String recordId)
	{
		Map<String, sObject> records = new Map<String, sObject>();

		if (objectsAndFields.keySet().size() > 0)
		{
			for (String objectName : objectsAndFields.keySet())
			{
				List<String> fields = objectsAndFields.get(objectName);
				if (fields.size() > 0)
				{
					sObject record = getRecordWithFields(objectName, recordId, fields);
					System.debug(record);
					records.put(objectName, record);
				}
			}
		}

		return records;
	}

	// Queries the specified fields of the specified object where
	// the id is 'recordId'
	private static sObject getRecordWithFields (String objectApiName, String recordId, List<String> fields)
	{
		if (objectApiName.toLowerCase() == 'User'.toLowerCase())
		{
			recordId = UserInfo.getUserId();
		}

		if (fields.size() > 0)
		{
			String query = 'SELECT ';

			query += fields[0];

			for (Integer i = 1; i < fields.size(); i++)
			{
				query += ', ' + fields[i];
			}

			query += ' FROM ' + objectApiName;
			query += ' WHERE Id = \'' + recordId + '\'';
			query += ' LIMIT 1';

			sObject record = Database.query(query);
			return record;
		}

		return null;
	}

	// Returns a list of ordered sections which contain ordered links
	private static List<FormattedSection> generateCustomLinks (List<WebLink> webLinks, Map<String, List<String>> objectsAndFields, Map<String, sObject> records, Map<String, Schema.SObjectType> availableObjects)
	{
		// Create a map with the structure:
		// Object Name -> { Field Name -> Field Value }
		List<FormattedLink> formattedLinks = new List<FormattedLink>();
		Map<String, FormattedSection> formattedSections = new Map<String, FormattedSection>();
		Map<String, Map<String, Object> > objectsAndFieldsAndValues = new Map<String, Map<String, Object> >();
		
		// Convert all field names to lower case and map the
		// fields and values to the object
		for (String objectName : records.keySet())
		{
			Map<String, Object> fieldsAndValues = records.get(objectName).getPopulatedFieldsAsMap();
			Map<String, Object> lowerCaseFieldsAndValues = new Map<String, Object>();
			for (String fieldName : fieldsAndValues.keySet())
			{
				Object value = fieldsAndValues.get(fieldName);
				fieldName = fieldName.toLowerCase();
				lowerCaseFieldsAndValues.put(fieldName, value);
			}
			objectsAndFieldsAndValues.put(objectName, lowerCaseFieldsAndValues);
		}

		for (WebLink webLink : webLinks)
		{
			FormattedLink formattedLink = new FormattedLink();
			formattedLink.id = webLink.Id;
			formattedLink.label = webLink.MasterLabel;
			formattedLink.href = webLink.Url;

			String link = webLink.Url;
			String mergeField = link.substringBetween('{!', '}');

			// While there is a merge field
			// Get the name of the object and the field from the merge field
			// Replace the merge field with the actual value from the record
			// Try to find the next merge field and repeat
			while (mergeField != null)
			{
				String objectName = mergeField.substringBefore('.');
				String fieldName = mergeField.substringAfter('.');
				Boolean isValidMergeField = fieldName != null && objectName != null && availableObjects.containsKey(objectName.toLowerCase());

				if (isValidMergeField)
				{
					// Change to lower case because Apex is case-insensitive which
					// means other devs can write the field and object names in mixed cases
					objectName = objectName.toLowerCase();
					fieldName = fieldName.toLowerCase();
					
					Map<String, Object> fieldsAndValues = objectsAndFieldsAndValues.get(objectName);
					Boolean hasFieldAndValue = fieldsAndValues.containsKey(fieldName.toLowerCase()) == true;

					if (hasFieldAndValue)
					{
						String fieldValue = String.valueOf(fieldsAndValues.get(fieldName));
						formattedLink.href = formattedLink.href.replace('{!' + mergeField + '}', fieldValue);
					}
				}

				link = link.remove('{!' + mergeField + '}');
				mergeField = link.substringBetween('{!', '}');
			}

			// Include this link in the list only if it has no more merge fields
			// if it has more merge fields, that means we failed to parse it
			if (!formattedLink.href.contains('{!') && !formattedLink.href.contains('}'))
			{
				formattedLinks.add(formattedLink);
			}
			else
			{
				System.debug('QuickLinks.cls @ generateCustomLinks: Found an invalid Custom Link: ' + formattedLink.href);
			}
		}

		formattedSections = populateSections(formattedLinks);
		formattedSections = populateLinks(formattedLinks, formattedSections);
		formattedSections = orderSections(formattedSections);
		formattedSections = orderLinks(formattedSections);

		return formattedSections.values();
	}

	// Given a list of formatted links returns a map of formatted sections with labels
	private static Map<String, FormattedSection> populateSections (List<FormattedLink> formattedLinks)
	{
		Map<String, FormattedSection> formattedSectionsMap = new Map<String, FormattedSection>();
		for (FormattedLink formattedLink : formattedLinks)
		{
			String label = formattedLink.label;
			if (label != null && label.length() > 0)
			{
				String sectionName = formattedLink.label.substring(0, 1).toUpperCase();
				if (!formattedSectionsMap.containsKey(sectionName))
				{
					FormattedSection formattedSection = new FormattedSection(sectionName, sectionName);
					formattedSectionsMap.put(sectionName, formattedSection);
				}
			}
		}

		return formattedSectionsMap;
	}

	// Given a list of formatted links and formatted sections with labels, returns formatted sections populated with links
	private static Map<String, FormattedSection> populateLinks (List<FormattedLink> formattedLinks, Map<String, FormattedSection> formattedSectionsMap)
	{
		for (FormattedLink formattedLink : formattedLinks)
		{
			String label = formattedLink.label;
			if (label != null && label.length() > 0)
			{
				String sectionName = formattedLink.label.substring(0, 1).toUpperCase();
				if (!formattedSectionsMap.containsKey(sectionName))
				{
					FormattedSection formattedSection = new FormattedSection(sectionName, sectionName);
					formattedSection.links.add(formattedLink);
					formattedSectionsMap.put(sectionName, formattedSection);
				}
				else
				{
					FormattedSection formattedSection = (FormattedSection) formattedSectionsMap.get(sectionName);
					formattedSection.links.add(formattedLink);
				}
			}
		}

		return formattedSectionsMap;
	}

	// Given formatted sections, return ordered formatted sections
	private static Map<String, FormattedSection> orderSections (Map<String, FormattedSection> formattedSectionsMap)
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

	// Given formatted sections, return formatted sections with ordered links
	private static Map<String, FormattedSection> orderLinks (Map<String, FormattedSection> formattedSections)
	{
		for (FormattedSection formattedSection : formattedSections.values())
		{
			formattedSection.links.sort();
		}

		return formattedSections;
	}

	public class FormattedLink implements Comparable
	{
		@AuraEnabled public String id;
		@AuraEnabled public String label;
		@AuraEnabled public String href;

		public FormattedLink()
		{
			this.label = '';
			this.href = '';
			this.id = '';
		}

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

		public FormattedSection()
		{
			this.id = '';
			this.label = '';
			this.links = new List<FormattedLink>();
		}

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