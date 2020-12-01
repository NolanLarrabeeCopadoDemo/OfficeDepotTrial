public without sharing class MultiSelectPicklistController
{   
    @AuraEnabled
    public static List<String> getAvailablePicklistValues(String objName, String fieldName)
	{
        List<String> plValues = new List<String>();
         
        //Get the object type from object name. Here I've used custom object Book.
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objName);
         
        //Describe the sObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
         
        //Get the specific field information from field name. Here I've used custom field Genre__c of Book object.
        Schema.DescribeFieldResult objFieldInfo = objDescribe.fields.getMap().get(fieldName).getDescribe();
         
        //Get the picklist field values.
        List<Schema.PicklistEntry> picklistvalues = objFieldInfo.getPicklistValues();
         
        //Add the picklist values to list.
        for(Schema.PicklistEntry plv: picklistvalues) {
            plValues.add(plv.getValue());
        }
        plValues.sort();
        return plValues;
    }

	// Given an object API name, field API name, record id, and a value,
	// Saves the value in the specified field of the given record id.
	@AuraEnabled
	public static void savePicklistValue (String objName, string fieldName, String recId, String value)
	{
		if (String.isBlank(objName) || String.isBlank(fieldName) || String.isBlank(recId) || value == null)
		{
			return;
		}

		sObject record;
		String query;
		
		query = 'SELECT Id';
		query += ' FROM ' + objName;
		query += ' WHERE Id = \'' + recId + '\'';
		query += ' LIMIT 1';

		record = Database.query(query);

		if (record != null)
		{
			record.put(fieldName, value);
			update record;
		}
	}

	// Given an object API name, field API name, record id,
	// Returns the picklist values saved in the field, as a List<String>.
	@AuraEnabled
	public static List<String> getCurrentPicklistValues (String objName, String fieldName, string recId)
	{
		if (String.isBlank(objName) || String.isBlank(fieldName) || String.isBlank(recId))
		{
			return null;
		}

		sObject record;
		String query;
		String rawFieldValue;
		List<String> separatedFieldValues;
		
		query = 'SELECT Id, ' + fieldName;
		query += ' FROM ' + objName;
		query += ' WHERE Id = \'' + recId + '\'';
		query += ' LIMIT 1';

		record = Database.query(query);
		rawFieldValue = String.valueOf(record.get(fieldName));
		if (String.isNotBlank(rawFieldValue))
		{
			separatedFieldValues = rawFieldValue.split(';');
		}
		return separatedFieldValues;
	}
}