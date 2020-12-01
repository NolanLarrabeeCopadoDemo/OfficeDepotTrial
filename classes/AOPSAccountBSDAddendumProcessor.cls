public class AOPSAccountBSDAddendumProcessor {
    
    /**
     * Takes in key value pairs from a request for the AOPS Account
     * BSD Addendum staging object, and upserts against that object.
     */
    public static boolean process(Map<String,Object> aopsDataMap) {
        if (aopsDataMap == null) {
            return false;
        }
        AOPS_Account_BSD_Addendum__c accountBsdAddendum = new AOPS_Account_BSD_Addendum__c();
        
        populateObject(aopsDataMap, accountBsdAddendum);
        
        Schema.SObjectField uniqueField = AOPS_Account_BSD_Addendum__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(accountBsdAddendum, uniqueField, false);
        return upsertResult.isSuccess();
    }
    
    /**
     * Populates the AOPS Account BSD Addendum staging record with data from the key value pairs.
     */
    private static void populateObject(Map<String,Object> source, AOPS_Account_BSD_Addendum__c target) {

        String aopsCustId = (String) source.get('CXTC007F_AOPS_KEY1');
        aopsCustId = String.valueOf(Integer.valueOf(aopsCustId));
        target.Unique_Record_ID__c = aopsCustId;
        target.CXTC007F_TIMESTAMP__c = (String) source.get('CXTC007F_TIMESTAMP');
        target.CXTC007F_ACTION__c = (String) source.get('CXTC007F_ACTION');
        target.CCU007F_CUSTOMER_ID__c = String.valueOf(Integer.valueOf(aopsCustId));
        target.CCU007F_REPORTING_LOC__c = (String) source.get('CCU007F_REPORTING_LOC');
        target.CCU007F_REPORTING_CONTACT__c = (String) source.get('CCU007F_REPORTING_CONTACT');
        target.CCU007F_REPORT_DIST_FLAG__c = (String) source.get('CCU007F_REPORT_DIST_FLAG');
        target.CCU007F_SALESPERSON_ID__c = (String) source.get('CCU007F_SALESPERSON_ID');
        target.CCU007F_ADDL_SALESPERSON_IND__c = (String) source.get('CCU007F_ADDL_SALESPERSON_IND');
        target.CCU007F_REPORTING_IND__c = (String) source.get('CCU007F_REPORTING_IND');
        target.CCU007F_BUYING_GROUP_IND__c = (String) source.get('CCU007F_BUYING_GROUP_IND');
        target.CCU007F_FORMS_FLAG__c = (String) source.get('CCU007F_FORMS_FLAG');
        target.CCU007F_REGISTERED_ON_TIME__c = (String) source.get('CCU007F_REGISTERED_ON_TIME');
        target.CCU007F_AOPD_FLAG__c = (String) source.get('CCU007F_AOPD_FLAG');
        target.CCU007F_AR_FLAG__c = (String) source.get('CCU007F_AR_FLAG');
        target.CCU007F_CREDIT_CODE__c = (String) source.get('CCU007F_CREDIT_CODE');
        target.CCU007F_AVAIL_CREDIT__c = (String) source.get('CCU007F_AVAIL_CREDIT');
        target.CCU007F_FISCAL_YEAR_END_MONTH__c = (String) source.get('CCU007F_FISCAL_YEAR_END_MONTH');
        target.CCU007F_PERIOD_END_TABLE__c = (String) source.get('CCU007F_PERIOD_END_TABLE');
        target.CCU007F_BILL_TO_LIMIT__c = (String) source.get('CCU007F_BILL_TO_LIMIT');
        target.CCU007F_BILL_TO_DOLLARS__c = (String) source.get('CCU007F_BILL_TO_DOLLARS');
        target.CCU007F_BILL_TO_DOLLAR_EXPIRE__c = (String) source.get('CCU007F_BILL_TO_DOLLAR_EXPIRE');
        target.CCU007F_ORDER_LIMIT__c = (String) source.get('CCU007F_ORDER_LIMIT');
        target.CCU007F_LINE_LIMIT__c = (String) source.get('CCU007F_LINE_LIMIT');
        target.CCU007F_ORDER_REST_IND__c = (String) source.get('CCU007F_ORDER_REST_IND');
        target.CCU007F_ADDR_ORDER_REST_IND__c = (String) source.get('CCU007F_ADDR_ORDER_REST_IND');
        target.CCU007F_REST_KEY_CODE__c = (String) source.get('CCU007F_REST_KEY_CODE');
        target.CCU007F_BACKORDER_ALLOW_FLAG__c = (String) source.get('CCU007F_BACKORDER_ALLOW_FLAG');
        target.CCU007F_FREIGHT_CHG_REQ_FLAG__c = (String) source.get('CCU007F_FREIGHT_CHG_REQ_FLAG');
        target.CCU007F_DEPT_REQUIRED_CODE__c = (String) source.get('CCU007F_DEPT_REQUIRED_CODE');
        target.CCU007F_LOCATION_REQ_CODE__c = (String) source.get('CCU007F_LOCATION_REQ_CODE');
        target.CCU007F_PO_REQUIRED_CODE__c = (String) source.get('CCU007F_PO_REQUIRED_CODE');
        target.CCU007F_RELEASE_REQUIRED_CODE__c = (String) source.get('CCU007F_RELEASE_REQUIRED_CODE');
        target.CCU007F_SHIP_TO_REQUIRED_CODE__c = (String) source.get('CCU007F_SHIP_TO_REQUIRED_CODE');
        target.CCU007F_DEPARTMENT_IND__c = (String) source.get('CCU007F_DEPARTMENT_IND');
        target.CCU007F_LOCATION_IND__c = (String) source.get('CCU007F_LOCATION_IND');
        target.CCU007F_RELEASE_IND__c = (String) source.get('CCU007F_RELEASE_IND');
        target.CCU007F_FIELD_HEADER_IND__c = (String) source.get('CCU007F_FIELD_HEADER_IND');
        target.CCU007F_REBATE_IND__c = (String) source.get('CCU007F_REBATE_IND');
        target.CCU007F_CUSTOMER_COMM__c = (String) source.get('CCU007F_CUSTOMER_COMM');
        target.CCU007F_SIGNATURE_REQ__c = (String) source.get('CCU007F_SIGNATURE_REQ');
        target.CCU007F_SPC_SERVICES_FLAG__c = (String) source.get('CCU007F_SPC_SERVICES_FLAG');
        target.CCU007F_CONTRACT_CODE__c = (String) source.get('CCU007F_CONTRACT_CODE');
        target.CCU007F_ADDR_CONTRACT_CODE__c = (String) source.get('CCU007F_ADDR_CONTRACT_CODE');
        target.CCU007F_OFF_PRICE_CODE__c = (String) source.get('CCU007F_OFF_PRICE_CODE');
        target.CCU007F_OFF_PRICE_PC__c = (String) source.get('CCU007F_OFF_PRICE_PC');
        target.CCU007F_OFF_CATALOG_DATE__c = (String) source.get('CCU007F_OFF_CATALOG_DATE');
        target.CCU007F_OFF_PRICE_ZONE__c = (String) source.get('CCU007F_OFF_PRICE_ZONE');
        target.CCU007F_WHL_PRICE_CODE__c = (String) source.get('CCU007F_WHL_PRICE_CODE');
        target.CCU007F_WHL_PRICE_PC__c = (String) source.get('CCU007F_WHL_PRICE_PC');
        target.CCU007F_MIN_GP_PERCENT__c = (String) source.get('CCU007F_MIN_GP_PERCENT');
        target.CCU007F_MIN_DISCOUNT__c = (String) source.get('CCU007F_MIN_DISCOUNT');
        target.CCU007F_COST_CODE__c = (String) source.get('CCU007F_COST_CODE');
        target.CCU007F_TERMS__c = (String) source.get('CCU007F_TERMS');
        target.CCU007F_SUBSTITUTE_ALLOWED__c = (String) source.get('CCU007F_SUBSTITUTE_ALLOWED');
        target.CCU007F_ABV_PROD_SRC_CODE__c = (String) source.get('CCU007F_ABV_PROD_SRC_CODE');
        target.CCU007F_6OR7_PRODUCT_IND__c = (String) source.get('CCU007F_6OR7_PRODUCT_IND');
        target.CCU007F_PRODUCT_XREF_NBR__c = (String) source.get('CCU007F_PRODUCT_XREF_NBR');
        target.CCU007F_CANDO_FROM_XREF__c = (String) source.get('CCU007F_CANDO_FROM_XREF');
        target.CCU007F_PRICE_PLAN__c = (String) source.get('CCU007F_PRICE_PLAN');
        target.CCU007F_PRICE_PLAN_SEQ__c = (String) source.get('CCU007F_PRICE_PLAN_SEQ');
        target.CCU007F_MANAFEST_FLAG__c = (String) source.get('CCU007F_MANAFEST_FLAG');
        target.CCU007F_FAX_SHIP_CONFIRMATION__c = (String) source.get('CCU007F_FAX_SHIP_CONFIRMATION');
        target.CCU007F_FAX_PO_CODE__c = (String) source.get('CCU007F_FAX_PO_CODE');
        target.CCU007F_FAX_INV_CODE__c = (String) source.get('CCU007F_FAX_INV_CODE');
        target.CCU007F_FAX_REORDER_CODE__c = (String) source.get('CCU007F_FAX_REORDER_CODE');
        target.CCU007F_COMMISSION_FLAG__c = (String) source.get('CCU007F_COMMISSION_FLAG');
        target.CCU007F_TAKE_BACK_FLAG__c = (String) source.get('CCU007F_TAKE_BACK_FLAG');
        target.CCU007F_AR_PHONE_CONT_SEQ__c = (String) source.get('CCU007F_AR_PHONE_CONT_SEQ');
        target.CCU007F_AR_FAX_CONT_SEQ__c = (String) source.get('CCU007F_AR_FAX_CONT_SEQ');
        target.CCU007F_PUR_PHONE_CONT_SEQ__c = (String) source.get('CCU007F_PUR_PHONE_CONT_SEQ');
        target.CCU007F_PUR_FAX_CONT_SEQ__c = (String) source.get('CCU007F_PUR_FAX_CONT_SEQ');
        target.CCU007F_PROC_DFT_DOLLAR_LIMIT__c = (String) source.get('CCU007F_PROC_DFT_DOLLAR_LIMIT');
        target.CCU007F_PROC_DFT_TRAN_LIMIT__c = (String) source.get('CCU007F_PROC_DFT_TRAN_LIMIT');
        target.CCU007F_PROC_DFT_ORDER_LIMIT__c = (String) source.get('CCU007F_PROC_DFT_ORDER_LIMIT');
        target.CCU007F_CREATE_DATE__c = (String) source.get('CCU007F_CREATE_DATE');
        target.CCU007F_UPDATE_DATE__c = (String) source.get('CCU007F_UPDATE_DATE');
        target.CCU007F_CREATE_ID__c = (String) source.get('CCU007F_CREATE_ID');
        target.CCU007F_UPDATE_PROGRAM__c = (String) source.get('CCU007F_UPDATE_PROGRAM');
        target.CCU007F_TIME_STAMP__c = (String) source.get('CCU007F_TIME_STAMP');
        target.CCU007F_FILLER__c = (String) source.get('CCU007F_FILLER');
        target.SYNC_STATUS_MESSAGE__c = '';
        // Specify that the record has been updated. Note that this will be reset
        // to false in a trigger if the request is not the most recent one.
        target.Record_Updated__c = true;
    }
}