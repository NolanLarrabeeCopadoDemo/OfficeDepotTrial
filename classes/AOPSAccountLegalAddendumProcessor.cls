public class AOPSAccountLegalAddendumProcessor {
    
    public static boolean process(Map<String,Object> aopsDataMap) {
        
        if (aopsDataMap == null) {
            return false;
        }
        AOPS_Account_Addendum_Legal_Other__c legalAddendum = new AOPS_Account_Addendum_Legal_Other__c();
        populateObject(aopsDataMap, legalAddendum);
        
        Schema.SObjectField uniqueField = AOPS_Account_Addendum_Legal_Other__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(legalAddendum, uniqueField, false);
        return upsertResult.isSuccess();
    }
    
    private static void populateObject(Map<String,Object> source, AOPS_Account_Addendum_Legal_Other__c target) {
        String aopsCustId = (String) source.get('CXTC044F_AOPS_KEY1');
        aopsCustId = String.valueOf(Integer.valueOf(aopsCustId));
        target.Unique_Record_ID__c = aopsCustId;
        target.CXTC044F_MSG_TYPE__c = (String) source.get('CXTC044F_MSG_TYPE');
        target.CXTC044F_AOPS_KEY1__c = aopsCustId;
        target.CXTC044F_TIMESTAMP__c = (String) source.get('CXTC044F_TIMESTAMP');
        target.CXTC044F_ACTION__c = (String) source.get('CXTC044F_ACTION');
        target.CCU044F_CUSTOMER_ID__c = aopsCustId;
        target.CCU044F_CURRENCY_ID__c = (String) source.get('CCU044F_CURRENCY_ID');
        target.CCU044F_CODE10__c = (String) source.get('CCU044F_CODE10');
        target.CCU044F_CODE25__c = (String) source.get('CCU044F_CODE25');
        target.CCU044F_CODE33__c = (String) source.get('CCU044F_CODE33');
        target.CCU044F_CODE42__c = (String) source.get('CCU044F_CODE42');
        target.CCU044F_CODE51__c = (String) source.get('CCU044F_CODE51');
        target.CCU044F_CODE61__c = (String) source.get('CCU044F_CODE61');
        target.CCU044F_UPDATE_TS__c = (String) source.get('CCU044F_UPDATE_TS');
		target.CCU044F_UPDATE_BY__c = (String) source.get('CCU044F_UPDATE_BY');
        target.SYNC_STATUS_MESSAGE__c = '';
		// Specify that the record has been updated. Note that this will be reset
        // to false in a trigger if the request is not the most recent one.
        target.Record_Updated__c = true;
    }
}