public class AOPSContactShipAddressProcessor {
    
    /**
     * Takes in key value pairs from a request for the AOPS Contact
     * Ship Address staging object, and upserts against that object.
     */
    public static boolean process(Map<String,Object> aopsDataMap) {
        if (aopsDataMap == null) {
            return false;
        }
        AOPS_Contact_Ship_Address__c contactShipAddress = new AOPS_Contact_Ship_Address__c();
        populateObject(aopsDataMap, contactShipAddress);
        
        Schema.SObjectField uniqueField = AOPS_Contact_Ship_Address__c.Fields.Unique_Record_ID__c; 
        Database.UpsertResult upsertResult = Database.upsert(contactShipAddress, uniqueField, false);
        return upsertResult.isSuccess();
    }
    
    /**
     * Populates the AOPS Contact Ship Address staging record with data from the key value pairs.
     */
    private static void populateObject(Map<String,Object> source, AOPS_Contact_Ship_Address__c target) {

        String uniqueKey = String.valueOf(Integer.valueOf((String) source.get('CXTCNTS_AOPS_KEY1'))) 
                            + String.valueOf(Integer.valueOf((String) source.get('CXTCNTS_AOPS_KEY2'))) 
                            + String.valueOf(Integer.valueOf((String) source.get('CXTCNTS_AOPS_KEY3')));
        target.Unique_Record_ID__c = uniqueKey;
        target.CXTCNTS_TIMESTAMP__c = (String) source.get('CXTCNTS_TIMESTAMP');
        target.CXTCNTS_ACTION__c = (String) source.get('CXTCNTS_ACTION');
        target.CCU310F_ADDR_SEQ__c = (String) source.get('CCU310F_ADDR_SEQ');
        target.CCU310F_ALLOW_BUY__c = (String) source.get('CCU310F_ALLOW_BUY');
        target.CCU310F_BRAND__c = (String) source.get('CCU310F_BRAND');
        target.CCU310F_CONTACT_ID__c = String.valueOf(Integer.valueOf((String) source.get('CCU310F_CONTACT_ID')));
        target.CCU310F_CUSTOMER_ID__c = (String) source.get('CCU310F_CUSTOMER_ID');
        target.CCU310F_DFT_SHIP_CONT__c = (String) source.get('CCU310F_DFT_SHIP_CONT');
        target.CCU310F_UPDATE_BY__c = (String) source.get('CCU310F_UPDATE_BY');
        target.CCU310F_UPDATE_DT__c = (String) source.get('CCU310F_UPDATE_DT');
        target.SYNC_STATUS_MESSAGE__c = '';
        // Specify that the record has been updated. Note that this will be reset
        // to false in a trigger if the request is not the most recent one.
        target.Record_Updated__c = true;
    }
}