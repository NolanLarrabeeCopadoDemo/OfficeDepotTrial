public class AOPSContactOptInProcessor {
    
    public static boolean process(Map<String,Object> aopsDataMap) {
        
        if (aopsDataMap == null) {
            return false;
        }
        AOPS_CONTACT_OPT_IN__c contactOptIn = new AOPS_CONTACT_OPT_IN__c();
        populateObject(aopsDataMap, contactOptIn);
        
        Schema.SObjectField uniqueField = AOPS_CONTACT_OPT_IN__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(contactOptIn, uniqueField, false);
        return upsertResult.isSuccess();
    }
    
    private static void populateObject(Map<String,Object> source, AOPS_CONTACT_OPT_IN__c target) {
                
        target.CXTCNTO_AOPS_KEY1__c = String.valueOf(Integer.valueOf((String) source.get('CXTCNTO_AOPS_KEY1')));
        target.CXTCNTO_AOPS_KEY2__c = String.valueOf(Integer.valueOf((String) source.get('CXTCNTO_AOPS_KEY2')));
        target.CXTCNTO_AOPS_KEY3__c = String.valueOf(source.get('CXTCNTO_AOPS_KEY3'));
        target.Unique_Record_ID__c = target.CXTCNTO_AOPS_KEY1__c + target.CXTCNTO_AOPS_KEY2__c + target.CXTCNTO_AOPS_KEY3__c;
        target.CXTCNTO_TIMESTAMP__c = (String) source.get('CXTCNTO_TIMESTAMP');
        target.CXTCNTO_ACTION__c = (String) source.get('CXTCNTO_ACTION');
        target.CCU380F_CUSTOMER_ID__c = (String) source.get('CCU380F_CUSTOMER_ID');
        target.CCU380F_CONTACT_ID__c = String.valueOf(Integer.valueOf((String) source.get('CCU380F_CONTACT_ID')));
        target.CCU380F_VEHICLE_CODE__c = (String) source.get('CCU380F_VEHICLE_CODE');
        target.CCU380F_SEQUENCE_KEY__c = (String) source.get('CCU380F_SEQUENCE_KEY');
        target.CCU380F_OPT_IN__c = (String) source.get('CCU380F_OPT_IN');
        target.CCU380F_CREATE_DATE__c = (String) source.get('CCU380F_CREATE_DATE');
        target.CCU380F_UPDATE_DATE__c = (String) source.get('CCU380F_UPDATE_DATE');
        target.CCU380F_CREATE_ID__c = (String) source.get('CCU380F_CREATE_ID');
        target.CCU380F_UPDATE_ID__c = (String) source.get('CCU380F_UPDATE_ID');
        target.CCU380F_FILLER1__c = (String) source.get('CCU380F_FILLER1');
        target.CCU380F_FILLER2__c = (String) source.get('CCU380F_FILLER2');
        target.CCU380F_FILLER3__c = (String) source.get('CCU380F_FILLER3');
        target.CCU380F_FILLER4__c = (String) source.get('CCU380F_FILLER4');
        target.CCU380F_FILLER5__c = (String) source.get('CCU380F_FILLER5');
        target.SYNC_STATUS_MESSAGE__c = '';
        // Specify that the record has been updated. Note that this will be reset
        // to false in a trigger if the request is not the most recent one.
        target.Record_Updated__c = true;
    }
}