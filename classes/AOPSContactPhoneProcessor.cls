public class AOPSContactPhoneProcessor {

    public static boolean process(Map<String,Object> aopsDataMap) {
        
        if (aopsDataMap == null) {
            return false;
        }
        AOPS_CONTACT_PHONE__c contactPhone = new AOPS_CONTACT_PHONE__c();
        populateObject(aopsDataMap, contactPhone);
        
        Schema.SObjectField uniqueField = AOPS_CONTACT_PHONE__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(contactPhone, uniqueField, false);
        return upsertResult.isSuccess();
    }
    
    private static void populateObject(Map<String,Object> source, AOPS_CONTACT_PHONE__c target) {
        
        target.Unique_Record_ID__c = String.valueOf(Integer.valueOf((String)source.get('CXTCNTP_AOPS_KEY1'))) + 
            						 String.valueOf(Integer.valueOf((String)source.get('CXTCNTP_AOPS_KEY2'))) + 
                            		 String.valueOf(Integer.valueOf((String)source.get('CXTCNTP_AOPS_KEY3')));
        target.CXTCNTP_MSG_TYPE__c = (String) source.get('CXTCNTP_MSG_TYPE');
        target.CXTCNTP_AOPS_KEY1__c = String.valueOf(Integer.valueOf((String) source.get('CXTCNTP_AOPS_KEY1')));
        target.CXTCNTP_AOPS_KEY2__c = String.valueOf(Integer.valueOf((String) source.get('CXTCNTP_AOPS_KEY2')));
        target.CXTCNTP_AOPS_KEY3__c = String.valueOf(Integer.valueOf((String) source.get('CXTCNTP_AOPS_KEY3')));
        target.CXTCNTP_TIMESTAMP__c = (String) source.get('CXTCNTP_TIMESTAMP');
        target.CCU320F_PHONE_SEQ__c = String.valueOf(Integer.valueOf((String)source.get('CCU320F_PHONE_SEQ'))); 
        target.CCU320F_CONTACT_ID__c = String.valueOf(Integer.valueOf((String)source.get('CCU320F_CONTACT_ID')));
        target.CCU320F_CUSTOMER_ID__c = String.valueOf(Integer.valueOf((String)source.get('CCU320F_CUSTOMER_ID')));        
        target.CCU320F_CNTRY_CODE__c = (String) source.get('CCU320F_CNTRY_CODE');
        target.CCU320F_AREA_CODE__c = (String) source.get('CCU320F_AREA_CODE');
        target.CCU320F_PREFIX__c = (String) source.get('CCU320F_PREFIX');
        target.CCU320F_NUMBER__c = (String) source.get('CCU320F_NUMBER');
        target.CCU320F_EXTENSION__c = (String) source.get('CCU320F_EXTENSION');
        target.CCU320F_NBR_TYPE__c = (String) source.get('CCU320F_NBR_TYPE');
        target.CCU320F_CONTACT_DFT_NUMBER__c = (String) source.get('CCU320F_CONTACT_DFT_NUMBER');
        target.CCU320F_LESS_PHONE__c = (String) source.get('CCU320F_LESS_PHONE');
        target.CCU320F_INVALID_PHONE__c = (String) source.get('CCU320F_INVALID_PHONE');
        target.CCU320F_BRAND__c = (String) source.get('CCU320F_BRAND');
        target.CXTCNTP_ACTION__c = (String) source.get('CXTCNTP_ACTION');
        target.SYNC_STATUS_MESSAGE__c = '';
        // Specify that the record has been updated. Note that this will be reset
        // to false in a trigger if the request is not the most recent one.
        target.Record_Updated__c = true;
    }
}