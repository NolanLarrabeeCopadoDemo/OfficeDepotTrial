public class AOPSContactWebUserProcessor {
    
    /**
     * Takes in key value pairs from a request for the AOPS Contact
     * Web User staging object, and upserts against that object.
     */
    public static boolean process(Map<String,Object> aopsDataMap) {
        if (aopsDataMap == null) {
            return false;
        }
        AOPS_Contact_Web_User__c contactWebUser = new AOPS_Contact_Web_User__c();
        populateObject(aopsDataMap, contactWebUser);
        
        Schema.SObjectField uniqueField = AOPS_Contact_Web_User__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(contactWebUser, uniqueField, false);
        return upsertResult.isSuccess();
    }
    
    /**
     * Populates the AOPS Contact Web User staging record with data from the key value pairs.
     */
    private static void populateObject(Map<String,Object> source, AOPS_Contact_Web_User__c target) {

        String uniqueKey = String.valueOf(Integer.valueOf((String) source.get('CXTCNTW_AOPS_KEY1'))) +
            String.valueOf(Integer.valueOf((String) source.get('CXTCNTW_AOPS_KEY2'))) +
            String.valueOf(Integer.valueOf((String) source.get('CXTCNTW_AOPS_KEY3')));
        target.Unique_Record_ID__c = uniqueKey;
        target.CXTCNTW_TIMESTAMP__c = (String) source.get('CXTCNTW_TIMESTAMP');
        target.CXTCNTW_ACTION__c = (String) source.get('CXTCNTW_ACTION');
        target.CCS056F_CODE_AV__c = (String) source.get('CCS056F_CODE_AV');
        target.CCS056F_VALUE_AV__c = (String) source.get('CCS056F_VALUE_AV');
        target.CCU300F_MID_INITIAL__c = (String) source.get('CCU300F_MID_INITIAL');
        target.CCU300F_NAME_1__c = (String) source.get('CCU300F_NAME_1');
        target.CCU300F_NAME_2__c = (String) source.get('CCU300F_NAME_2');
        target.CCU330F_AB_FLG__c = (String) source.get('CCU330F_AB_FLG');
        target.CCU330F_CONTACT_ID__c = String.valueOf(Integer.valueOf((String) source.get('CCU330F_CONTACT_ID')));
        target.CCU330F_CUSTOMER_ID__c = (String) source.get('CCU330F_CUSTOMER_ID');
        target.CCU330F_DEFAULT_POSTAL_CODE__c = (String) source.get('CCU330F_DEFAULT_POSTAL_CODE');
        target.CCU330F_LAST_VISIT_DATE__c = (String) source.get('CCU330F_LAST_VISIT_DATE');
        target.CCU330F_ORDER_OK_FLG__c = (String) source.get('CCU330F_ORDER_OK_FLG');
        target.CCU330F_PASSWORD__c = (String) source.get('CCU330F_PASSWORD');
        target.CCU330F_USER_LOCKED_FLG__c = (String) source.get('CCU330F_USER_LOCKED_FLG');
        target.CCU330F_USER_SEQ__c = (String) source.get('CCU330F_USER_SEQ');
        target.CCU330F_USER_TYPE__c = (String) source.get('CCU330F_USER_TYPE');
        target.CCU330F_USERID__c = (String) source.get('CCU330F_USERID');
        target.CCU340F_ADDRESS__c = (String) source.get('CCU340F_ADDRESS');
        target.CCU330F_CREATE_DT__c = (String) source.get('CCU330F_CREATE_DT');
        target.SYNC_STATUS_MESSAGE__c = '';
        // Specify that the record has been updated. Note that this will be reset
        // to false in a trigger if the request is not the most recent one.
        target.Record_Updated__c = true;
    }
}