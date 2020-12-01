public class AOPSAddressBSDAddendumProcessor {
    
    /**
     * Takes in key value pairs from a request for the AOPS Address
     * BSD Addendum staging object, and upserts against that object.
     */
    public static boolean process(Map<String,Object> aopsDataMap) {
        if (aopsDataMap == null) {
            return false;
        }
        AOPS_Address_BSD_A__c addressBsdAddendum = new AOPS_Address_BSD_A__c();
        
        populateObject(aopsDataMap, addressBsdAddendum);
        
        Schema.SObjectField uniqueField = AOPS_Address_BSD_A__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(addressBsdAddendum, uniqueField, false);
        return upsertResult.isSuccess();
    }
    
    /**
     * Populates the AOPS Address BSD Addendum staging record with data from the key value pairs.
     */
    private static void populateObject(Map<String,Object> source, AOPS_Address_BSD_A__c target) {

        String aopsCustId = (String) source.get('CCU009F_CUSTOMER_ID');
        String uniqueKey = aopsCustId + ((String) source.get('CCU009F_ADDRESS_SEQ'));
        target.Unique_Record_ID__c = uniqueKey;
        target.CXTC009F_TIMESTAMP__c = (String) source.get('CXTC009F_TIMESTAMP');
        target.CXTC009F_ACTION__c = (String) source.get('CXTC009F_ACTION');
        target.CCU009F_CUSTOMER_ID__c = aopsCustId;
        target.CCU009F_ADDRESS_SEQ__c = (String) source.get('CCU009F_ADDRESS_SEQ');
        target.CCU009F_SALESPERSON_ID__c = (String) source.get('CCU009F_SALESPERSON_ID');
        target.CCU009F_ADDL_SALESPERSON_IND__c = (String) source.get('CCU009F_ADDL_SALESPERSON_IND');
        target.CCU009F_AOPD_FLAG__c = (String) source.get('CCU009F_AOPD_FLAG');
        target.CCU009F_HEDBERG_ADDRESS_ID__c = (String) source.get('CCU009F_HEDBERG_ADDRESS_ID');
        target.CCU009F_SHIP_TO_LIMIT__c = (String) source.get('CCU009F_SHIP_TO_LIMIT');
        target.CCU009F_SHIP_TO_DOLLARS__c = (String) source.get('CCU009F_SHIP_TO_DOLLARS');
        target.CCU009F_SHIP_TO_DOLLAR_EXPIRE__c = (String) source.get('CCU009F_SHIP_TO_DOLLAR_EXPIRE');
        target.CCU009F_ORDER_LIMIT__c = (String) source.get('CCU009F_ORDER_LIMIT');
        target.CCU009F_LINE_LIMIT__c = (String) source.get('CCU009F_LINE_LIMIT');
        target.CCU009F_ORDER_REST_IND__c = (String) source.get('CCU009F_ORDER_REST_IND');
        target.CCU009F_BACKORDER_ALLOW_FLAG__c = (String) source.get('CCU009F_BACKORDER_ALLOW_FLAG');
        target.CCU009F_LOCATION_REQ_CODE__c = (String) source.get('CCU009F_LOCATION_REQ_CODE');
        target.CCU009F_LOCATION_INDICATOR__c = (String) source.get('CCU009F_LOCATION_INDICATOR');
        target.CCU009F_REPORT_DIST_FLAG__c = (String) source.get('CCU009F_REPORT_DIST_FLAG');
        target.CCU009F_REPORT_DIST_ID__c = (String) source.get('CCU009F_REPORT_DIST_ID');
        target.CCU009F_FAX_SHIP_CONFIRMATION__c = (String) source.get('CCU009F_FAX_SHIP_CONFIRMATION');
        target.CCU009F_FAX_PO_CODE__c = (String) source.get('CCU009F_FAX_PO_CODE');
        target.CCU009F_FAX_INV_CODE__c = (String) source.get('CCU009F_FAX_INV_CODE');
        target.CCU009F_CONTRACT_CODE__c = (String) source.get('CCU009F_CONTRACT_CODE');
        target.CCU009F_OFF_PRICE_CODE__c = (String) source.get('CCU009F_OFF_PRICE_CODE');
        target.CCU009F_OFF_PRICE_PC__c = (String) source.get('CCU009F_OFF_PRICE_PC');
        target.CCU009F_OFF_CATALOG_DATE__c = (String) source.get('CCU009F_OFF_CATALOG_DATE');
        target.CCU009F_OFF_PRICE_ZONE__c = (String) source.get('CCU009F_OFF_PRICE_ZONE');
        target.CCU009F_WHL_PRICE_CODE__c = (String) source.get('CCU009F_WHL_PRICE_CODE');
        target.CCU009F_WHL_PRICE_PC__c = (String) source.get('CCU009F_WHL_PRICE_PC');
        target.CCU009F_MIN_GP_PERCENT__c = (String) source.get('CCU009F_MIN_GP_PERCENT');
        target.CCU009F_MIN_DISCOUNT__c = (String) source.get('CCU009F_MIN_DISCOUNT');
        target.CCU009F_COST_CODE__c = (String) source.get('CCU009F_COST_CODE');
        target.CCU009F_PRICE_PLAN__c = (String) source.get('CCU009F_PRICE_PLAN');
        target.CCU009F_PRICE_PLAN_SEQ__c = (String) source.get('CCU009F_PRICE_PLAN_SEQ');
        target.CCU009F_PUR_PHONE_CONT_SEQ__c = (String) source.get('CCU009F_PUR_PHONE_CONT_SEQ');
        target.CCU009F_PUR_FAX_CONT_SEQ__c = (String) source.get('CCU009F_PUR_FAX_CONT_SEQ');
        target.CCU009F_LAST_USED_DATE__c = (String) source.get('CCU009F_LAST_USED_DATE');
        target.CCU009F_CREATE_DATE__c = (String) source.get('CCU009F_CREATE_DATE');
        target.CCU009F_UPDATE_DATE__c = (String) source.get('CCU009F_UPDATE_DATE');
        target.CCU009F_CREATE_ID__c = (String) source.get('CCU009F_CREATE_ID');
        target.CCU009F_UPDATE_PROGRAM__c = (String) source.get('CCU009F_UPDATE_PROGRAM');
        target.CCU009F_TIME_STAMP__c = (String) source.get('CCU009F_TIME_STAMP');
        target.CCU009F_FILLER__c = (String) source.get('CCU009F_FILLER');
        target.SYNC_STATUS_MESSAGE__c = '';
        // Specify that the record has been updated. Note that this will be reset
        // to false in a trigger if the request is not the most recent one.
        target.Record_Updated__c = true;
    }
}