public class AOPSAccountMasterProcessor {

    /**
     * Takes in key value pairs from a request for the AOPS Account
     * Master staging object, and upserts against that object.
     */
    public static boolean process(Map<String,Object> aopsDataMap) {
        if (aopsDataMap == null) {
            return false;
        }
        AOPS_Account_Master__c accountMaster = new AOPS_Account_Master__c();
        
        populateObject(aopsDataMap, accountMaster);
        
        Schema.SObjectField uniqueField = AOPS_Account_Master__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(accountMaster, uniqueField, false);
        return upsertResult.isSuccess();
    }
    
    /**
     * Populates the AOPS Account Master staging record with data from the key value pairs.
     */
    private static void populateObject(Map<String,Object> source, AOPS_Account_Master__c target) {
        String uniqueKey = (String) source.get('CXTF000P_AOPS_KEY1');
        target.Unique_Record_ID__c = String.valueOf(Integer.valueOf(uniqueKey));
        target.CXTF000P_SFDC_KEY1__c = (String) source.get('CXTF000P_SFDC_KEY1');
        target.CXTF000P_TIMESTAMP__c = (String) source.get('CXTF000P_TIMESTAMP');
        target.CXTF000P_ACTION__c = (String) source.get('CXTF000P_ACTION');
        target.FCU000P_CUSTOMER_ID__c = String.valueOf(Integer.valueOf((String) source.get('FCU000P_CUSTOMER_ID')));
        target.FCU000P_CONT_RETAIL_CODE__c = (String) source.get('FCU000P_CONT_RETAIL_CODE');
        target.FCU000P_BUSINESS_NAME__c = (String) source.get('FCU000P_BUSINESS_NAME');
        target.FCU000P_CONTACT_NAME__c = (String) source.get('FCU000P_CONTACT_NAME');
        target.FCU000P_SALUTATION__c = (String) source.get('FCU000P_SALUTATION');
        target.FCU000P_TITLE_IND__c = (String) source.get('FCU000P_TITLE_IND');
        target.FCU000P_PRIMARY_PHONE__c = (String) source.get('FCU000P_PRIMARY_PHONE');
        target.FCU000P_PRIMARY_EXTENSION__c = (String) source.get('FCU000P_PRIMARY_EXTENSION');
        target.FCU000P_PHONE_CONT_SEQ__c = (String) source.get('FCU000P_PHONE_CONT_SEQ');
        target.FCU000P_ADDL_PHONE_CONT_IND__c = (String) source.get('FCU000P_ADDL_PHONE_CONT_IND');
        target.FCU000P_STREET_ADDRESS1__c = (String) source.get('FCU000P_STREET_ADDRESS1');
        target.FCU000P_STREET_ADDRESS2__c = (String) source.get('FCU000P_STREET_ADDRESS2');
        target.FCU000P_CITY__c = (String) source.get('FCU000P_CITY');
        target.FCU000P_STATE__c = (String) source.get('FCU000P_STATE');
        target.FCU000P_PROVINCE__c = (String) source.get('FCU000P_PROVINCE');
        target.FCU000P_ZIP__c = (String) source.get('FCU000P_ZIP');
        target.FCU000P_COUNTRY_CODE__c = (String) source.get('FCU000P_COUNTRY_CODE');
        target.FCU000P_GEO_CODE__c = (String) source.get('FCU000P_GEO_CODE');
        target.FCU000P_OUTSIDE_CITY_FLAG__c = (String) source.get('FCU000P_OUTSIDE_CITY_FLAG');
        target.FCU000P_ADDRESS_SEQ__c = (String) source.get('FCU000P_ADDRESS_SEQ');
        target.FCU000P_ADDL_ADDR_IND__c = (String) source.get('FCU000P_ADDL_ADDR_IND');
        target.FCU000P_CUST_COMM_IND__c = (String) source.get('FCU000P_CUST_COMM_IND');
        target.FCU000P_ADDR_COMM_IND__c = (String) source.get('FCU000P_ADDR_COMM_IND');
        target.FCU000P_ADDR_HOURS_IND__c = (String) source.get('FCU000P_ADDR_HOURS_IND');
        target.FCU000P_TSR_ID__c = (String) source.get('FCU000P_TSR_ID');
        target.FCU000P_PO_IND__c = (String) source.get('FCU000P_PO_IND');
        target.FCU000P_PO_REQ_OVER_AMT__c = (String) source.get('FCU000P_PO_REQ_OVER_AMT');
        target.FCU000P_TAX_EXEMPT_TYPE__c = (String) source.get('FCU000P_TAX_EXEMPT_TYPE');
        target.FCU000P_TAX_CERTIF_IND__c = (String) source.get('FCU000P_TAX_CERTIF_IND');
        target.FCU000P_CANADIAN_TAXABLE_CODE__c = (String) source.get('FCU000P_CANADIAN_TAXABLE_CODE');
        target.FCU000P_CREDIT_IND__c = (String) source.get('FCU000P_CREDIT_IND');
        target.FCU000P_PRES_NAME_IND__c = (String) source.get('FCU000P_PRES_NAME_IND');
        target.FCU000P_CUST_DEMO_IND__c = (String) source.get('FCU000P_CUST_DEMO_IND');
        target.FCU000P_FAMILY_TYPE__c = (String) source.get('FCU000P_FAMILY_TYPE');
        target.FCU000P_ADV_CHK_APP_FLAG__c = (String) source.get('FCU000P_ADV_CHK_APP_FLAG');
        target.FCU000P_DELETE_FLAG__c = (String) source.get('FCU000P_DELETE_FLAG');
        target.FCU000P_SIC_CODE__c = (String) source.get('FCU000P_SIC_CODE');
        target.FCU000P_DUNS_NBR__c = (String) source.get('FCU000P_DUNS_NBR');
        target.FCU000P_CREATE_DATE__c = (String) source.get('FCU000P_CREATE_DATE');
        target.FCU000P_CREATE_ID__c = (String) source.get('FCU000P_CREATE_ID');
        target.FCU000P_TIME_STAMP__c = (String) source.get('FCU000P_TIME_STAMP');
        target.FCU000P_RESERVED_SPACE__c = (String) source.get('FCU000P_RESERVED_SPACE');
        target.FCU000P_CATALOG_TYPE__c = (String) source.get('FCU000P_CATALOG_TYPE');
        target.FCU000P_BO_IND__c = (String) source.get('FCU000P_BO_IND');
        target.FCU000P_HLD_RTN_IND__c = (String) source.get('FCU000P_HLD_RTN_IND');
        target.FCU000P_DATE_STS_MOD__c = (String) source.get('FCU000P_DATE_STS_MOD');
        target.FCU000P_BRAND__c = (String) source.get('FCU000P_BRAND');
        target.FCU000P_ASSOCIATION_CODE__c = (String) source.get('FCU000P_ASSOCIATION_CODE');
        target.FCU000P_AFFILIATION_CODE__c = (String) source.get('FCU000P_AFFILIATION_CODE');
        target.FCU000P_CUST_TYPE__c = (String) source.get('FCU000P_CUST_TYPE');
        target.FCU000P_CUST_SUBTYPE__c = (String) source.get('FCU000P_CUST_SUBTYPE');
        target.FCU000P_AUTO_SALES__c = (String) source.get('FCU000P_AUTO_SALES');
        target.FCU000P_PRIVATE_SALE_FLAG__c = (String) source.get('FCU000P_PRIVATE_SALE_FLAG');
        target.FCU000P_REBATE_CODE__c = (String) source.get('FCU000P_REBATE_CODE');
        target.FCU000P_HANDLING_FLAG__c = (String) source.get('FCU000P_HANDLING_FLAG');
        target.FCU000P_DEAL_REST_FLAG__c = (String) source.get('FCU000P_DEAL_REST_FLAG');
        target.FCU000P_VISIT_FREQUENCY__c = (String) source.get('FCU000P_VISIT_FREQUENCY');
        target.FCU000P_POLYBAG_FLAG__c = (String) source.get('FCU000P_POLYBAG_FLAG');
        target.FCU000P_LESS_MAIL_FLAG__c = (String) source.get('FCU000P_LESS_MAIL_FLAG');
        target.FCU000P_LESS_PHONE_FLAG__c = (String) source.get('FCU000P_LESS_PHONE_FLAG');
        target.FCU000P_LESS_FAX_FLAG__c = (String) source.get('FCU000P_LESS_FAX_FLAG');
        target.FCU000P_LESS_EMAIL_FLAG__c = (String) source.get('FCU000P_LESS_EMAIL_FLAG');
        target.FCU000P_RENT_NAME_FLAG__c = (String) source.get('FCU000P_RENT_NAME_FLAG');
        target.FCU000P_RCV_DELINQ_LETTER__c = (String) source.get('FCU000P_RCV_DELINQ_LETTER');
        target.FCU000P_GRAY_LETTER_FLAG__c = (String) source.get('FCU000P_GRAY_LETTER_FLAG');
        target.FCU000P_BLOCK_DAILY_SPC__c = (String) source.get('FCU000P_BLOCK_DAILY_SPC');
        target.FCU000P_EMPLOYER_ID__c = (String) source.get('FCU000P_EMPLOYER_ID');
        target.FCU000P_RSV_1CHAR_2__c = (String) source.get('FCU000P_RSV_1CHAR_2');
        target.FCU000P_RSV_2CHAR_1__c = (String) source.get('FCU000P_RSV_2CHAR_1');
        target.FCU000P_RSV_2CHAR_2__c = (String) source.get('FCU000P_RSV_2CHAR_2');
        target.FCU000P_RSV_4CHAR_1__c = (String) source.get('FCU000P_RSV_4CHAR_1');
        target.FCU000P_RSV_6CHAR_1__c = (String) source.get('FCU000P_RSV_6CHAR_1');
        target.FCU000P_RSV_10CHAR__c = (String) source.get('FCU000P_RSV_10CHAR');
        target.FCU000P_RSV_10V2__c = (String) source.get('FCU000P_RSV_10V2');
        target.CXTF000P_EXT_CUSTOMER__c = (String) source.get('CXTF000P_EXT_CUSTOMER');
        target.CXTF000P_ACCT_TYPE__c = (String) source.get('CXTF000P_ACCT_TYPE');
        target.CXTF000P_STATUS_CHANGE__c = (String) source.get('CXTF000P_STATUS_CHANGE');
        target.SYNC_STATUS_MESSAGE__c = '';
        // Specify that the record has been updated. Note that this will be reset
        // to false in a trigger if the request is not the most recent one.
        target.Record_Updated__c = true;
    }
    
}