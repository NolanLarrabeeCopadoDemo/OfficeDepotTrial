public class AOPSAccountPreferencesProcessor {
    
    /**
     * Takes in key value pairs from a request for the AOPS Account
     * Preferences staging object, and upserts against that object.
     */
    public static boolean process(Map<String,Object> aopsDataMap) {
        if (aopsDataMap == null) {
            return false;
        }
        AOPS_Account_Preferences__c accountPreferences = new AOPS_Account_Preferences__c();
        
        populateObject(aopsDataMap, accountPreferences);
        
        Schema.SObjectField uniqueField = AOPS_Account_Preferences__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(accountPreferences, uniqueField, false);
        return upsertResult.isSuccess();
    }
    
    /**
     * Populates the AOPS Account Preferences staging record with data from the key value pairs.
     */
    private static void populateObject(Map<String,Object> source, AOPS_Account_Preferences__c target) {

        String aopsCustId = (String) source.get('CXTF370P_AOPS_KEY1');
        String uniqueKey = String.valueOf(Integer.valueOf(aopsCustId)) + ((String) source.get('CXTF370P_AOPS_KEY2'));
        target.Unique_Record_ID__c = uniqueKey;
        target.CXTF370P_TIMESTAMP__c = (String) source.get('CXTF370P_TIMESTAMP');
        target.CXTF370P_ACTION__c = (String) source.get('CXTF370P_ACTION');
        target.FCU370P_CUSTOMER_ID__c = (String) source.get('FCU370P_CUSTOMER_ID');
        target.FCU370P_VEHICLE_CODE__c = (String) source.get('FCU370P_VEHICLE_CODE');
        target.FCU370P_ENABLE_CNT_OPTIN__c = (String) source.get('FCU370P_ENABLE_CNT_OPTIN');
        target.FCU370P_CREATE_DATE__c = (String) source.get('FCU370P_CREATE_DATE');
        target.FCU370P_UPDATE_DATE__c = (String) source.get('FCU370P_UPDATE_DATE');
        target.FCU370P_CREATE_ID__c = (String) source.get('FCU370P_CREATE_ID');
        target.FCU370P_UPDATE_ID__c = (String) source.get('FCU370P_UPDATE_ID');
        target.FCU370P_FILLER1__c = (String) source.get('FCU370P_FILLER1');
        target.FCU370P_FILLER2__c = (String) source.get('FCU370P_FILLER2');
        target.FCU370P_FILLER3__c = (String) source.get('FCU370P_FILLER3');
        target.FCU370P_FILLER4__c = (String) source.get('FCU370P_FILLER4');
		target.FCU370P_FILLER5__c = (String) source.get('FCU370P_FILLER5');
        target.SYNC_STATUS_MESSAGE__c = '';
		target.Record_Updated__c = true;
    }
}