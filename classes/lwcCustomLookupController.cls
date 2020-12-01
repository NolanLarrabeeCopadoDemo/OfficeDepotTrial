public class lwcCustomLookupController
{
    private final static Integer queryLimit = 10;

    @AuraEnabled (cacheable = true)
    public static String getResults(String objectApiName, String fieldApiName, String searchValue)
    {
        if (String.isBlank(objectApiName) || String.isBlank(fieldApiName) || String.isBlank(searchValue))
        {
            throw new AuraHandledException('Invalid value received.');
        }

        List<LookupResult> lookupResults = new List<LookupResult>();
        String rawQuery = 'SELECT Id,' + fieldApiName + ' FROM ' + objectApiName + ' WHERE ' + fieldApiName + ' LIKE \'' + String.escapeSingleQuotes(searchValue.trim()) + '%\' LIMIT ' + String.valueOf(queryLimit);
        List<SObject> queryResults = Database.Query(rawQuery);
        for (SObject result : queryResults)
        {
            String fieldValue = (String) result.get(fieldApiName);
            lookupResults.add(new LookupResult(fieldvalue, result.Id));
        }
        return JSON.serialize(lookupResults);
    }
    
    public class LookupResult
    {
        @AuraEnabled public String recordId;
        @AuraEnabled public String fieldValue;
        
        public LookupResult(String fieldValue, String recordId)
        {
            this.fieldValue = fieldValue;
            this.recordId = recordId;
        }
    }
}