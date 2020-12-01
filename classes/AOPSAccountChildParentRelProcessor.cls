public class AOPSAccountChildParentRelProcessor {
    
    /**
     * Takes in key value pairs from a request for the AOPS Account Child
     * Parent Relationship staging object, and upserts against that object.
     */
    public static boolean process(Map<String,Object> aopsDataMap) {
        if (aopsDataMap == null) {
            return false;
        }
        AOPS_Account_Child_Parent_Relationship__c accountChildParentRel = new AOPS_Account_Child_Parent_Relationship__c();
        
        populateObject(aopsDataMap, accountChildParentRel);
        
        Schema.SObjectField uniqueField = AOPS_Account_Child_Parent_Relationship__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(accountChildParentRel, uniqueField, false);
        return upsertResult.isSuccess();
    }
    
    /**
     * Populates the AOPS Account Child Parent Relationship staging record with data from the key value pairs.
     */
    private static void populateObject(Map<String,Object> source, AOPS_Account_Child_Parent_Relationship__c target) {

        String uniqueKey = (String) source.get('CXTF005P_AOPS_KEY1');
        target.Unique_Record_ID__c = String.valueOf(Integer.valueOf(uniqueKey));
        target.CXTF005P_TIMESTAMP__c = (String) source.get('CXTF005P_TIMESTAMP');
        target.CXTF005P_ACTION__c = (String) source.get('CXTF005P_ACTION');
       	target.FCU005P_CUSTOMER_ID__c = (String) source.get('FCU005P_CUSTOMER_ID');   
        target.FCU005P_PARENT_ID__c = (String) source.get('FCU005P_PARENT_ID');
        target.FCU005P_INCENTIVE_ACC__c = (String) source.get('FCU005P_INCENTIVE_ACC');
        target.FCU005P_SALE_DETAIL_ACC__c = (String) source.get('FCU005P_SALE_DETAIL_ACC');
        target.SYNC_STATUS_MESSAGE__c = '';
        // Specify that the record has been updated. Note that this will be reset
        // to false in a trigger if the request is not the most recent one.
        target.Record_Updated__c = true;
    }
}