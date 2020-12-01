trigger AOPSAccountMasterTrigger on AOPS_Account_Master__c (before update) {

    List<AOPS_Account_Master__c> newRecList = (List<AOPS_Account_Master__c>) Trigger.new;
    List<AOPS_Account_Master__c> oldRecList = (List<AOPS_Account_Master__c>) Trigger.old;

    Map<String, AOPS_Account_Master__c> newRecMap = new Map<String, AOPS_Account_Master__c>();
    for (AOPS_Account_Master__c rec : newRecList) {
        newRecMap.put(rec.Unique_Record_ID__c, rec);
    }
    
    for (AOPS_Account_Master__c oldRec : oldRecList) {
    
        AOPS_Account_Master__c newRec = newRecMap.get(oldRec.Unique_Record_ID__c);
        
        String newTS = newRec.CXTF000P_TIMESTAMP__c;
        String oldTS = oldRec.CXTF000P_TIMESTAMP__c;
        
        if (newTS.compareTo(oldTS) <= 0) {
            newRec.CXTF000P_TIMESTAMP__c = oldRec.CXTF000P_TIMESTAMP__c;
            newRec.CXTF000P_SFDC_KEY1__c = oldRec.CXTF000P_SFDC_KEY1__c;
            newRec.CXTF000P_ACTION__c = oldRec.CXTF000P_ACTION__c;
            newRec.FCU000P_CUSTOMER_ID__c = oldRec.FCU000P_CUSTOMER_ID__c;
            newRec.FCU000P_CONT_RETAIL_CODE__c = oldRec.FCU000P_CONT_RETAIL_CODE__c;
            newRec.FCU000P_BUSINESS_NAME__c = oldRec.FCU000P_BUSINESS_NAME__c;
            newRec.FCU000P_CONTACT_NAME__c = oldRec.FCU000P_CONTACT_NAME__c;
            newRec.FCU000P_SALUTATION__c = oldRec.FCU000P_SALUTATION__c;
            newRec.FCU000P_TITLE_IND__c = oldRec.FCU000P_TITLE_IND__c;
            newRec.FCU000P_PRIMARY_PHONE__c = oldRec.FCU000P_PRIMARY_PHONE__c;
            newRec.FCU000P_PRIMARY_EXTENSION__c = oldRec.FCU000P_PRIMARY_EXTENSION__c;
            newRec.FCU000P_PHONE_CONT_SEQ__c = oldRec.FCU000P_PHONE_CONT_SEQ__c;
            newRec.FCU000P_ADDL_PHONE_CONT_IND__c = oldRec.FCU000P_ADDL_PHONE_CONT_IND__c;
            newRec.FCU000P_STREET_ADDRESS1__c = oldRec.FCU000P_STREET_ADDRESS1__c;
            newRec.FCU000P_STREET_ADDRESS2__c = oldRec.FCU000P_STREET_ADDRESS2__c;
            newRec.FCU000P_CITY__c = oldRec.FCU000P_CITY__c;
            newRec.FCU000P_STATE__c = oldRec.FCU000P_STATE__c;
            newRec.FCU000P_PROVINCE__c = oldRec.FCU000P_PROVINCE__c;
            newRec.FCU000P_ZIP__c = oldRec.FCU000P_ZIP__c;
            newRec.FCU000P_COUNTRY_CODE__c = oldRec.FCU000P_COUNTRY_CODE__c;
            newRec.FCU000P_GEO_CODE__c = oldRec.FCU000P_GEO_CODE__c;
            newRec.FCU000P_OUTSIDE_CITY_FLAG__c = oldRec.FCU000P_OUTSIDE_CITY_FLAG__c;
            newRec.FCU000P_ADDRESS_SEQ__c = oldRec.FCU000P_ADDRESS_SEQ__c;
            newRec.FCU000P_ADDL_ADDR_IND__c = oldRec.FCU000P_ADDL_ADDR_IND__c;
            newRec.FCU000P_CUST_COMM_IND__c = oldRec.FCU000P_CUST_COMM_IND__c;
            newRec.FCU000P_ADDR_COMM_IND__c = oldRec.FCU000P_ADDR_COMM_IND__c;
            newRec.FCU000P_ADDR_HOURS_IND__c = oldRec.FCU000P_ADDR_HOURS_IND__c;
            newRec.FCU000P_TSR_ID__c = oldRec.FCU000P_TSR_ID__c;
            newRec.FCU000P_PO_IND__c = oldRec.FCU000P_PO_IND__c;
            newRec.FCU000P_PO_REQ_OVER_AMT__c = oldRec.FCU000P_PO_REQ_OVER_AMT__c;
            newRec.FCU000P_TAX_EXEMPT_TYPE__c = oldRec.FCU000P_TAX_EXEMPT_TYPE__c;
            newRec.FCU000P_TAX_CERTIF_IND__c = oldRec.FCU000P_TAX_CERTIF_IND__c;
            newRec.FCU000P_CANADIAN_TAXABLE_CODE__c = oldRec.FCU000P_CANADIAN_TAXABLE_CODE__c;
            newRec.FCU000P_CREDIT_IND__c = oldRec.FCU000P_CREDIT_IND__c;
            newRec.FCU000P_PRES_NAME_IND__c = oldRec.FCU000P_PRES_NAME_IND__c;
            newRec.FCU000P_CUST_DEMO_IND__c = oldRec.FCU000P_CUST_DEMO_IND__c;
            newRec.FCU000P_FAMILY_TYPE__c = oldRec.FCU000P_FAMILY_TYPE__c;
            newRec.FCU000P_ADV_CHK_APP_FLAG__c = oldRec.FCU000P_ADV_CHK_APP_FLAG__c;
            newRec.FCU000P_DELETE_FLAG__c = oldRec.FCU000P_DELETE_FLAG__c;
            newRec.FCU000P_SIC_CODE__c = oldRec.FCU000P_SIC_CODE__c;
            newRec.FCU000P_DUNS_NBR__c = oldRec.FCU000P_DUNS_NBR__c;
            newRec.FCU000P_CREATE_DATE__c = oldRec.FCU000P_CREATE_DATE__c;
            newRec.FCU000P_CREATE_ID__c = oldRec.FCU000P_CREATE_ID__c;
            newRec.FCU000P_TIME_STAMP__c = oldRec.FCU000P_TIME_STAMP__c;
            newRec.FCU000P_RESERVED_SPACE__c = oldRec.FCU000P_RESERVED_SPACE__c;
            newRec.FCU000P_CATALOG_TYPE__c = oldRec.FCU000P_CATALOG_TYPE__c;
            newRec.FCU000P_BO_IND__c = oldRec.FCU000P_BO_IND__c;
            newRec.FCU000P_HLD_RTN_IND__c = oldRec.FCU000P_HLD_RTN_IND__c;
            newRec.FCU000P_DATE_STS_MOD__c = oldRec.FCU000P_DATE_STS_MOD__c;
            newRec.FCU000P_BRAND__c = oldRec.FCU000P_BRAND__c;
            newRec.FCU000P_ASSOCIATION_CODE__c = oldRec.FCU000P_ASSOCIATION_CODE__c;
            newRec.FCU000P_AFFILIATION_CODE__c = oldRec.FCU000P_AFFILIATION_CODE__c;
            newRec.FCU000P_CUST_TYPE__c = oldRec.FCU000P_CUST_TYPE__c;
            newRec.FCU000P_CUST_SUBTYPE__c = oldRec.FCU000P_CUST_SUBTYPE__c;
            newRec.FCU000P_AUTO_SALES__c = oldRec.FCU000P_AUTO_SALES__c;
            newRec.FCU000P_PRIVATE_SALE_FLAG__c = oldRec.FCU000P_PRIVATE_SALE_FLAG__c;
            newRec.FCU000P_REBATE_CODE__c = oldRec.FCU000P_REBATE_CODE__c;
            newRec.FCU000P_HANDLING_FLAG__c = oldRec.FCU000P_HANDLING_FLAG__c;
            newRec.FCU000P_DEAL_REST_FLAG__c = oldRec.FCU000P_DEAL_REST_FLAG__c;
            newRec.FCU000P_VISIT_FREQUENCY__c = oldRec.FCU000P_VISIT_FREQUENCY__c;
            newRec.FCU000P_POLYBAG_FLAG__c = oldRec.FCU000P_POLYBAG_FLAG__c;
            newRec.FCU000P_LESS_MAIL_FLAG__c = oldRec.FCU000P_LESS_MAIL_FLAG__c;
            newRec.FCU000P_LESS_PHONE_FLAG__c = oldRec.FCU000P_LESS_PHONE_FLAG__c;
            newRec.FCU000P_LESS_FAX_FLAG__c = oldRec.FCU000P_LESS_FAX_FLAG__c;
            newRec.FCU000P_LESS_EMAIL_FLAG__c = oldRec.FCU000P_LESS_EMAIL_FLAG__c;
            newRec.FCU000P_RENT_NAME_FLAG__c = oldRec.FCU000P_RENT_NAME_FLAG__c;
            newRec.FCU000P_RCV_DELINQ_LETTER__c = oldRec.FCU000P_RCV_DELINQ_LETTER__c;
            newRec.FCU000P_GRAY_LETTER_FLAG__c = oldRec.FCU000P_GRAY_LETTER_FLAG__c;
            newRec.FCU000P_BLOCK_DAILY_SPC__c = oldRec.FCU000P_BLOCK_DAILY_SPC__c;
            newRec.FCU000P_EMPLOYER_ID__c = oldRec.FCU000P_EMPLOYER_ID__c;
            newRec.FCU000P_RSV_1CHAR_1__c = oldRec.FCU000P_RSV_1CHAR_1__c;
            newRec.FCU000P_RSV_1CHAR_2__c = oldRec.FCU000P_RSV_1CHAR_2__c;
            newRec.FCU000P_RSV_2CHAR_1__c = oldRec.FCU000P_RSV_2CHAR_1__c;
            newRec.FCU000P_RSV_2CHAR_2__c = oldRec.FCU000P_RSV_2CHAR_2__c;
            newRec.FCU000P_RSV_4CHAR_1__c = oldRec.FCU000P_RSV_4CHAR_1__c;
            newRec.FCU000P_RSV_6CHAR_1__c = oldRec.FCU000P_RSV_6CHAR_1__c;
            newRec.FCU000P_RSV_10CHAR__c = oldRec.FCU000P_RSV_10CHAR__c;
            newRec.FCU000P_RSV_10V2__c = oldRec.FCU000P_RSV_10V2__c;
            newRec.CXTF000P_EXT_CUSTOMER__c = oldRec.CXTF000P_EXT_CUSTOMER__c;
            newRec.CXTF000P_ACCT_TYPE__c = oldRec.CXTF000P_ACCT_TYPE__c;
            newRec.CXTF000P_STATUS_CHANGE__c = oldRec.CXTF000P_STATUS_CHANGE__c;
            newRec.Record_Updated__c = false;
        }
    }
}