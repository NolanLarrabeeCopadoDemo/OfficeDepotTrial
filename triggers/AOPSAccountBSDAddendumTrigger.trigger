trigger AOPSAccountBSDAddendumTrigger on AOPS_Account_BSD_Addendum__c (before update) {
    List<AOPS_Account_BSD_Addendum__c> newRecList = (List<AOPS_Account_BSD_Addendum__c>) Trigger.new;
    List<AOPS_Account_BSD_Addendum__c> oldRecList = (List<AOPS_Account_BSD_Addendum__c>) Trigger.old;

    Map<String, AOPS_Account_BSD_Addendum__c> newRecMap = new Map<String, AOPS_Account_BSD_Addendum__c>();
    for (AOPS_Account_BSD_Addendum__c rec : newRecList) {
        newRecMap.put(rec.Unique_Record_ID__c, rec);
    }
    
    for (AOPS_Account_BSD_Addendum__c oldRec : oldRecList) {
    
        AOPS_Account_BSD_Addendum__c newRec = newRecMap.get(oldRec.Unique_Record_ID__c);
        
        String newTS = newRec.CXTC007F_TIMESTAMP__c;
        String oldTS = oldRec.CXTC007F_TIMESTAMP__c;
        
        if (newTS.compareTo(oldTS) <= 0) {
            newRec.CXTC007F_TIMESTAMP__c = oldRec.CXTC007F_TIMESTAMP__c;
            newRec.CXTC007F_ACTION__c = oldRec.CXTC007F_ACTION__c;
            newRec.CCU007F_CUSTOMER_ID__c = oldRec.CCU007F_CUSTOMER_ID__c;
            newRec.CCU007F_REPORTING_LOC__c = oldRec.CCU007F_REPORTING_LOC__c;
            newRec.CCU007F_REPORTING_CONTACT__c = oldRec.CCU007F_REPORTING_CONTACT__c;
            newRec.CCU007F_REPORT_DIST_FLAG__c = oldRec.CCU007F_REPORT_DIST_FLAG__c;
            newRec.CCU007F_SALESPERSON_ID__c = oldRec.CCU007F_SALESPERSON_ID__c;
            newRec.CCU007F_ADDL_SALESPERSON_IND__c = oldRec.CCU007F_ADDL_SALESPERSON_IND__c;
            newRec.CCU007F_REPORTING_IND__c = oldRec.CCU007F_REPORTING_IND__c;
            newRec.CCU007F_BUYING_GROUP_IND__c = oldRec.CCU007F_BUYING_GROUP_IND__c;
            newRec.CCU007F_FORMS_FLAG__c = oldRec.CCU007F_FORMS_FLAG__c;
            newRec.CCU007F_REGISTERED_ON_TIME__c = oldRec.CCU007F_REGISTERED_ON_TIME__c;
            newRec.CCU007F_AOPD_FLAG__c = oldRec.CCU007F_AOPD_FLAG__c;
            newRec.CCU007F_AR_FLAG__c = oldRec.CCU007F_AR_FLAG__c;
            newRec.CCU007F_CREDIT_CODE__c = oldRec.CCU007F_CREDIT_CODE__c;
            newRec.CCU007F_AVAIL_CREDIT__c = oldRec.CCU007F_AVAIL_CREDIT__c;
            newRec.CCU007F_FISCAL_YEAR_END_MONTH__c = oldRec.CCU007F_FISCAL_YEAR_END_MONTH__c;
            newRec.CCU007F_PERIOD_END_TABLE__c = oldRec.CCU007F_PERIOD_END_TABLE__c;
            newRec.CCU007F_BILL_TO_LIMIT__c = oldRec.CCU007F_BILL_TO_LIMIT__c;
            newRec.CCU007F_BILL_TO_DOLLARS__c = oldRec.CCU007F_BILL_TO_DOLLARS__c;
            newRec.CCU007F_BILL_TO_DOLLAR_EXPIRE__c = oldRec.CCU007F_BILL_TO_DOLLAR_EXPIRE__c;
            newRec.CCU007F_ORDER_LIMIT__c = oldRec.CCU007F_ORDER_LIMIT__c;
            newRec.CCU007F_LINE_LIMIT__c = oldRec.CCU007F_LINE_LIMIT__c;
            newRec.CCU007F_ORDER_REST_IND__c = oldRec.CCU007F_ORDER_REST_IND__c;
            newRec.CCU007F_ADDR_ORDER_REST_IND__c = oldRec.CCU007F_ADDR_ORDER_REST_IND__c;
            newRec.CCU007F_REST_KEY_CODE__c = oldRec.CCU007F_REST_KEY_CODE__c;
            newRec.CCU007F_BACKORDER_ALLOW_FLAG__c = oldRec.CCU007F_BACKORDER_ALLOW_FLAG__c;
            newRec.CCU007F_FREIGHT_CHG_REQ_FLAG__c = oldRec.CCU007F_FREIGHT_CHG_REQ_FLAG__c;
            newRec.CCU007F_DEPT_REQUIRED_CODE__c = oldRec.CCU007F_DEPT_REQUIRED_CODE__c;
            newRec.CCU007F_LOCATION_REQ_CODE__c = oldRec.CCU007F_LOCATION_REQ_CODE__c;
            newRec.CCU007F_PO_REQUIRED_CODE__c = oldRec.CCU007F_PO_REQUIRED_CODE__c;
            newRec.CCU007F_RELEASE_REQUIRED_CODE__c = oldRec.CCU007F_RELEASE_REQUIRED_CODE__c;
            newRec.CCU007F_SHIP_TO_REQUIRED_CODE__c = oldRec.CCU007F_SHIP_TO_REQUIRED_CODE__c;
            newRec.CCU007F_DEPARTMENT_IND__c = oldRec.CCU007F_DEPARTMENT_IND__c;
            newRec.CCU007F_LOCATION_IND__c = oldRec.CCU007F_LOCATION_IND__c;
            newRec.CCU007F_RELEASE_IND__c = oldRec.CCU007F_RELEASE_IND__c;
            newRec.CCU007F_FIELD_HEADER_IND__c = oldRec.CCU007F_FIELD_HEADER_IND__c;
            newRec.CCU007F_REBATE_IND__c = oldRec.CCU007F_REBATE_IND__c;
            newRec.CCU007F_CUSTOMER_COMM__c = oldRec.CCU007F_CUSTOMER_COMM__c;
            newRec.CCU007F_SIGNATURE_REQ__c = oldRec.CCU007F_SIGNATURE_REQ__c;
            newRec.CCU007F_SPC_SERVICES_FLAG__c = oldRec.CCU007F_SPC_SERVICES_FLAG__c;
            newRec.CCU007F_CONTRACT_CODE__c = oldRec.CCU007F_CONTRACT_CODE__c;
            newRec.CCU007F_ADDR_CONTRACT_CODE__c = oldRec.CCU007F_ADDR_CONTRACT_CODE__c;
            newRec.CCU007F_OFF_PRICE_CODE__c = oldRec.CCU007F_OFF_PRICE_CODE__c;
            newRec.CCU007F_OFF_PRICE_PC__c = oldRec.CCU007F_OFF_PRICE_PC__c;
            newRec.CCU007F_OFF_CATALOG_DATE__c = oldRec.CCU007F_OFF_CATALOG_DATE__c;
            newRec.CCU007F_OFF_PRICE_ZONE__c = oldRec.CCU007F_OFF_PRICE_ZONE__c;
            newRec.CCU007F_WHL_PRICE_CODE__c = oldRec.CCU007F_WHL_PRICE_CODE__c;
            newRec.CCU007F_WHL_PRICE_PC__c = oldRec.CCU007F_WHL_PRICE_PC__c;
            newRec.CCU007F_MIN_GP_PERCENT__c = oldRec.CCU007F_MIN_GP_PERCENT__c;
            newRec.CCU007F_MIN_DISCOUNT__c = oldRec.CCU007F_MIN_DISCOUNT__c;
            newRec.CCU007F_COST_CODE__c = oldRec.CCU007F_COST_CODE__c;
            newRec.CCU007F_TERMS__c = oldRec.CCU007F_TERMS__c;
            newRec.CCU007F_SUBSTITUTE_ALLOWED__c = oldRec.CCU007F_SUBSTITUTE_ALLOWED__c;
            newRec.CCU007F_ABV_PROD_SRC_CODE__c = oldRec.CCU007F_ABV_PROD_SRC_CODE__c;
            newRec.CCU007F_6OR7_PRODUCT_IND__c = oldRec.CCU007F_6OR7_PRODUCT_IND__c;
            newRec.CCU007F_PRODUCT_XREF_NBR__c = oldRec.CCU007F_PRODUCT_XREF_NBR__c;
            newRec.CCU007F_CANDO_FROM_XREF__c = oldRec.CCU007F_CANDO_FROM_XREF__c;
            newRec.CCU007F_PRICE_PLAN__c = oldRec.CCU007F_PRICE_PLAN__c;
            newRec.CCU007F_PRICE_PLAN_SEQ__c = oldRec.CCU007F_PRICE_PLAN_SEQ__c;
            newRec.CCU007F_MANAFEST_FLAG__c = oldRec.CCU007F_MANAFEST_FLAG__c;
            newRec.CCU007F_FAX_SHIP_CONFIRMATION__c = oldRec.CCU007F_FAX_SHIP_CONFIRMATION__c;
            newRec.CCU007F_FAX_PO_CODE__c = oldRec.CCU007F_FAX_PO_CODE__c;
            newRec.CCU007F_FAX_INV_CODE__c = oldRec.CCU007F_FAX_INV_CODE__c;
            newRec.CCU007F_FAX_REORDER_CODE__c = oldRec.CCU007F_FAX_REORDER_CODE__c;
            newRec.CCU007F_COMMISSION_FLAG__c = oldRec.CCU007F_COMMISSION_FLAG__c;
            newRec.CCU007F_TAKE_BACK_FLAG__c = oldRec.CCU007F_TAKE_BACK_FLAG__c;
            newRec.CCU007F_AR_PHONE_CONT_SEQ__c = oldRec.CCU007F_AR_PHONE_CONT_SEQ__c;
            newRec.CCU007F_AR_FAX_CONT_SEQ__c = oldRec.CCU007F_AR_FAX_CONT_SEQ__c;
            newRec.CCU007F_PUR_PHONE_CONT_SEQ__c = oldRec.CCU007F_PUR_PHONE_CONT_SEQ__c;
            newRec.CCU007F_PUR_FAX_CONT_SEQ__c = oldRec.CCU007F_PUR_FAX_CONT_SEQ__c;
            newRec.CCU007F_PROC_DFT_DOLLAR_LIMIT__c = oldRec.CCU007F_PROC_DFT_DOLLAR_LIMIT__c;
            newRec.CCU007F_PROC_DFT_TRAN_LIMIT__c = oldRec.CCU007F_PROC_DFT_TRAN_LIMIT__c;
            newRec.CCU007F_PROC_DFT_ORDER_LIMIT__c = oldRec.CCU007F_PROC_DFT_ORDER_LIMIT__c;
            newRec.CCU007F_CREATE_DATE__c = oldRec.CCU007F_CREATE_DATE__c;
            newRec.CCU007F_UPDATE_DATE__c = oldRec.CCU007F_UPDATE_DATE__c;
            newRec.CCU007F_CREATE_ID__c = oldRec.CCU007F_CREATE_ID__c;
            newRec.CCU007F_UPDATE_PROGRAM__c = oldRec.CCU007F_UPDATE_PROGRAM__c;
            newRec.CCU007F_TIME_STAMP__c = oldRec.CCU007F_TIME_STAMP__c;
            newRec.CCU007F_FILLER__c = oldRec.CCU007F_FILLER__c;
            newRec.Record_Updated__c = false;
        }
    }
}