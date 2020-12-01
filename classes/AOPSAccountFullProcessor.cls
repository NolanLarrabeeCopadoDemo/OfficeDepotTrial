public class AOPSAccountFullProcessor implements Queueable {
    
    private List<String> accountIdList;
    private static Integer SITE_BATCH_SIZE = 50;

    public AOPSAccountFullProcessor(List<String> accountIdList) {
        this.accountIdList = accountIdList;
    }
    
    /**
     * The method executed when the job is started. Populates and upserts final staging records,
     * and updates the initial staging records by specifying they are no longer in the updated state.
     */
    public void execute(QueueableContext context) {
        Savepoint sp = Database.setSavepoint();
        System.debug(accountIdList);
        try {            
            
			List<AOPS_Account_Master__c> masterInitRecList = getAccountMasterList(accountIdList);
            AOPSAccountMasterFinalProcessor masterProcessor = new AOPSAccountMasterFinalProcessor(masterInitRecList);
            masterProcessor.process();
            
            List<AOPS_Account_Addendum_Community__c> communityInitRecList = getAccountAddendumCommunityList(accountIdList);
            AOPSAccountAddendumCommFinalProcessor communityProcessor = new AOPSAccountAddendumCommFinalProcessor(communityInitRecList);
            communityProcessor.process();
            
            List<AOPS_Account_Addendum_Legal_Other__c> legalInitRecList = getAccountLegalAddendumList(accountIdList);
            AOPSAccountLegalAddendumFinalProcessor legalProcessor = new AOPSAccountLegalAddendumFinalProcessor(legalInitRecList);
            legalProcessor.process();
            
            List<AOPS_Account_BSD_Addendum__c> bsdInitRecList = getAccountBSDAddendumList(accountIdList);
            AOPSAccountBSDAddendumFinalProcessor bsdProcessor = new AOPSAccountBSDAddendumFinalProcessor(bsdInitRecList);
            bsdProcessor.process();
            
            List<AOPS_Account_Child_Parent_Relationship__c> childParentInitRecList = getAccountChildParentRelList(accountIdList);
            AOPSAccountChildParentRelFinalProcessor childParentProcessor = new AOPSAccountChildParentRelFinalProcessor(childParentInitRecList);
            childParentProcessor.process();
            
            List<AOPS_Account_Preferences__c> preferenceInitRecList = getAccountPreferencesList(accountIdList);
            AOPSAccountPreferencesFinalProcessor preferenceProcessor = new AOPSAccountPreferencesFinalProcessor(preferenceInitRecList);
            preferenceProcessor.process();
            
            list<sync_batch_setting__mdt> sbs= [SELECT Id, batch_size__c, delay_next_job__c from sync_batch_setting__mdt where DeveloperName='Site' limit 1];
            if(sbs.size()>0) {
                SITE_BATCH_SIZE = sbs[0].batch_size__c.intValue();
            }
            List<AOPS_Address_Master__c> addrMasterInitRecList = getAccountAddressMasterList(accountIdList);
            AOPSAddressMasterFinalProcessor addrMasterProcessor = new AOPSAddressMasterFinalProcessor(addrMasterInitRecList);
            addrMasterProcessor.process();
            
            /*
            List<AOPS_Address_BSD_A__c> addrBsdInitRecList = getAccountAddressBSDAddendumList(accountIdList);
            AOPSAddressBSDAddendumFinalProcessor addrBsdProcessor = new AOPSAddressBSDAddendumFinalProcessor(addrBsdInitRecList);
            addrBsdProcessor.process();
            */
        } catch(Exception e) {
            Database.rollback(sp);
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
    }

    private List<AOPS_Account_Master__c> getAccountMasterList(List<String> accountIdList) {
        List<AOPS_Account_Master__c> initialRecs = [SELECT Id, Unique_Record_ID__c, Record_Updated__c, CXTF000P_ACCT_TYPE__c, CXTF000P_ACTION__c, CXTF000P_AOPS_KEY1__c,
            CXTF000P_EXT_CUSTOMER__c, CXTF000P_MSG_TYPE__c, CXTF000P_SFDC_KEY1__c, CXTF000P_STATUS_CHANGE__c, CXTF000P_TIMESTAMP__c, FCU000P_ADDL_ADDR_IND__c,
            FCU000P_ADDL_PHONE_CONT_IND__c, FCU000P_ADDR_COMM_IND__c, FCU000P_ADDR_HOURS_IND__c, FCU000P_ADDRESS_SEQ__c, FCU000P_ADV_CHK_APP_FLAG__c,
            FCU000P_AFFILIATION_CODE__c, FCU000P_ASSOCIATION_CODE__c, FCU000P_AUTO_SALES__c, FCU000P_BLOCK_DAILY_SPC__c, FCU000P_BO_IND__c, FCU000P_BRAND__c,
            FCU000P_BUSINESS_NAME__c, FCU000P_CANADIAN_TAXABLE_CODE__c, FCU000P_CATALOG_TYPE__c, FCU000P_CITY__c, FCU000P_CONT_RETAIL_CODE__c, FCU000P_CONTACT_NAME__c,
            FCU000P_COUNTRY_CODE__c, FCU000P_CREATE_DATE__c, FCU000P_CREATE_ID__c, FCU000P_CREDIT_IND__c, FCU000P_CUST_COMM_IND__c, FCU000P_CUST_DEMO_IND__c,
            FCU000P_CUST_SUBTYPE__c, FCU000P_CUST_TYPE__c, FCU000P_CUSTOMER_ID__c, FCU000P_DATE_STS_MOD__c, FCU000P_DEAL_REST_FLAG__c, FCU000P_DELETE_FLAG__c,
            FCU000P_DUNS_NBR__c, FCU000P_EMPLOYER_ID__c, FCU000P_FAMILY_TYPE__c, FCU000P_GEO_CODE__c, FCU000P_GRAY_LETTER_FLAG__c, FCU000P_HANDLING_FLAG__c,
            FCU000P_HLD_RTN_IND__c, FCU000P_LESS_EMAIL_FLAG__c, FCU000P_LESS_FAX_FLAG__c, FCU000P_LESS_MAIL_FLAG__c, FCU000P_LESS_PHONE_FLAG__c, FCU000P_OUTSIDE_CITY_FLAG__c,
            FCU000P_PHONE_CONT_SEQ__c, FCU000P_PO_IND__c, FCU000P_PO_REQ_OVER_AMT__c, FCU000P_POLYBAG_FLAG__c, FCU000P_PRES_NAME_IND__c, FCU000P_PRIMARY_EXTENSION__c,
            FCU000P_PRIMARY_PHONE__c, FCU000P_PRIVATE_SALE_FLAG__c, FCU000P_PROVINCE__c, FCU000P_RCV_DELINQ_LETTER__c, FCU000P_REBATE_CODE__c, FCU000P_RENT_NAME_FLAG__c,
            FCU000P_RESERVED_SPACE__c, FCU000P_RSV_10CHAR__c, FCU000P_RSV_10V2__c, FCU000P_RSV_1CHAR_1__c, FCU000P_RSV_1CHAR_2__c, FCU000P_RSV_2CHAR_1__c,
            FCU000P_RSV_2CHAR_2__c, FCU000P_RSV_4CHAR_1__c, FCU000P_RSV_6CHAR_1__c, FCU000P_SALUTATION__c, FCU000P_SIC_CODE__c, FCU000P_STATE__c, FCU000P_STREET_ADDRESS1__c,
            FCU000P_STREET_ADDRESS2__c, FCU000P_TAX_CERTIF_IND__c, FCU000P_TAX_EXEMPT_TYPE__c, FCU000P_TIME_STAMP__c, FCU000P_TITLE_IND__c, FCU000P_TSR_ID__c,
            FCU000P_VISIT_FREQUENCY__c, FCU000P_ZIP__c, SYNC_STATUS_MESSAGE__c
            FROM AOPS_Account_Master__c WHERE Record_Updated__c = true AND FCU000P_CUSTOMER_ID__c IN :accountIdList];

        return initialRecs;
    }

    private List<AOPS_Account_Addendum_Community__c> getAccountAddendumCommunityList(List<String> accountIdList) {
        List<AOPS_Account_Addendum_Community__c> initialRecs = [SELECT Id, Unique_Record_ID__c, Record_Updated__c, Action__c, CCU043F_AECD01__c, CCU043F_AECD02__c,
            CCU043F_AECD03__c, CCU043F_AECD04__c, CCU043F_AECD05__c, CCU043F_AECD06__c, CCU043F_AECD07__c, CCU043F_AECD08__c, CCU043F_AECD09__c, CCU043F_AECD10__c,
            CCU043F_AECD11__c, CCU043F_AECD12__c, CCU043F_AECD13__c, CCU043F_AECD14__c, CCU043F_AECD15__c, CCU043F_AECD16__c, CCU043F_AECD17__c, CCU043F_AECD18__c,
            CCU043F_AECD19__c, CCU043F_AECD20__c, CCU043F_AECD22__c, CCU043F_AECD33__c, CCU043F_AECD44__c, CCU043F_AECD55__c, CCU043F_AECDCO1__c, CCU043F_AECDCO2__c,
            CCU043F_AECUST__c, CCU043F_AENM01__c, CCU043F_AENM02__c, CCU043F_AENM03__c, CCU043F_AENM04__c, CCU043F_AENM05__c, CCU043F_AENM06__c, CCU043F_AENM07__c,
            CCU043F_AENM08__c, CCU043F_AENM09__c, CCU043F_AENM10__c, CCU043F_AEUD__c, CCU043F_AEUU__c, CXTC043F_ACTION__c, CXTC043F_AOPS_KEY1__c, CXTC043F_AOPS_KEY2__c,
            CXTC043F_AOPS_KEY3__c, CXTC043F_MSG_TYPE__c, CXTC043F_TIMESTAMP__c, SYNC_STATUS_MESSAGE__c
            FROM AOPS_Account_Addendum_Community__c WHERE Record_Updated__c = true AND CCU043F_AECUST__c IN :accountIdList];

        return initialRecs;
    }

    private List<AOPS_Account_Addendum_Legal_Other__c> getAccountLegalAddendumList(List<String> accountIdList) {
        List<AOPS_Account_Addendum_Legal_Other__c> initialRecs = [SELECT Id, Unique_Record_ID__c, Record_Updated__c, CCU044F_CODE10__c, CCU044F_CODE25__c, CCU044F_CODE33__c,
        CCU044F_CODE42__c, CCU044F_CODE51__c, CCU044F_CODE61__c, CCU044F_CURRENCY_ID__c, CCU044F_CUSTOMER_ID__c, CCU044F_UPDATE_BY__c, CCU044F_UPDATE_TS__c,
        CXTC044F_ACTION__c, CXTC044F_AOPS_KEY1__c, CXTC044F_MSG_TYPE__c, CXTC044F_TIMESTAMP__c, SYNC_STATUS_MESSAGE__c
        FROM AOPS_Account_Addendum_Legal_Other__c WHERE Record_Updated__c = true AND CCU044F_CUSTOMER_ID__c IN :accountIdList];

        return initialRecs;
    }

    private List<AOPS_Account_BSD_Addendum__c> getAccountBSDAddendumList(List<String> accountIdList) {
        List<AOPS_Account_BSD_Addendum__c> initialRecs = [SELECT Id, Unique_Record_ID__c, Record_Updated__c, CCU007F_6OR7_PRODUCT_IND__c, CCU007F_ABV_PROD_SRC_CODE__c,
            CCU007F_ADDL_SALESPERSON_IND__c, CCU007F_ADDR_CONTRACT_CODE__c, CCU007F_ADDR_ORDER_REST_IND__c, CCU007F_AOPD_FLAG__c, CCU007F_AR_FAX_CONT_SEQ__c, CCU007F_AR_FLAG__c,
            CCU007F_AR_PHONE_CONT_SEQ__c, CCU007F_AVAIL_CREDIT__c, CCU007F_BACKORDER_ALLOW_FLAG__c, CCU007F_BILL_TO_DOLLAR_EXPIRE__c, CCU007F_BILL_TO_DOLLARS__c,
            CCU007F_BILL_TO_LIMIT__c, CCU007F_BUYING_GROUP_IND__c, CCU007F_CANDO_FROM_XREF__c, CCU007F_COMMISSION_FLAG__c, CCU007F_CONTRACT_CODE__c, CCU007F_COST_CODE__c,
            CCU007F_CREATE_DATE__c, CCU007F_CREATE_ID__c, CCU007F_CREDIT_CODE__c, CCU007F_CUSTOMER_COMM__c, CCU007F_CUSTOMER_ID__c, CCU007F_DEPARTMENT_IND__c,
            CCU007F_DEPT_REQUIRED_CODE__c, CCU007F_FAX_INV_CODE__c, CCU007F_FAX_PO_CODE__c, CCU007F_FAX_REORDER_CODE__c, CCU007F_FAX_SHIP_CONFIRMATION__c,
            CCU007F_FIELD_HEADER_IND__c, CCU007F_FILLER__c, CCU007F_FISCAL_YEAR_END_MONTH__c, CCU007F_FORMS_FLAG__c, CCU007F_FREIGHT_CHG_REQ_FLAG__c, CCU007F_LINE_LIMIT__c,
            CCU007F_LOCATION_IND__c, CCU007F_LOCATION_REQ_CODE__c, CCU007F_MANAFEST_FLAG__c, CCU007F_MIN_DISCOUNT__c, CCU007F_MIN_GP_PERCENT__c, CCU007F_OFF_CATALOG_DATE__c,
            CCU007F_OFF_PRICE_CODE__c, CCU007F_OFF_PRICE_PC__c, CCU007F_OFF_PRICE_ZONE__c, CCU007F_ORDER_LIMIT__c, CCU007F_ORDER_REST_IND__c, CCU007F_PERIOD_END_TABLE__c,
            CCU007F_PO_REQUIRED_CODE__c, CCU007F_PRICE_PLAN__c, CCU007F_PRICE_PLAN_SEQ__c, CCU007F_PROC_DFT_DOLLAR_LIMIT__c, CCU007F_PROC_DFT_ORDER_LIMIT__c,
            CCU007F_PROC_DFT_TRAN_LIMIT__c, CCU007F_PRODUCT_XREF_NBR__c, CCU007F_PUR_FAX_CONT_SEQ__c, CCU007F_PUR_PHONE_CONT_SEQ__c, CCU007F_REBATE_IND__c,
            CCU007F_REGISTERED_ON_TIME__c, CCU007F_RELEASE_IND__c, CCU007F_RELEASE_REQUIRED_CODE__c, CCU007F_REPORT_DIST_FLAG__c, CCU007F_REPORTING_CONTACT__c,
            CCU007F_REPORTING_IND__c, CCU007F_REPORTING_LOC__c, CCU007F_REST_KEY_CODE__c, CCU007F_SALESPERSON_ID__c, CCU007F_SHIP_TO_REQUIRED_CODE__c, CCU007F_SIGNATURE_REQ__c,
            CCU007F_SPC_SERVICES_FLAG__c, CCU007F_SUBSTITUTE_ALLOWED__c, CCU007F_TAKE_BACK_FLAG__c, CCU007F_TERMS__c, CCU007F_TIME_STAMP__c, CCU007F_UPDATE_DATE__c,
            CCU007F_UPDATE_PROGRAM__c, CCU007F_WHL_PRICE_CODE__c, CCU007F_WHL_PRICE_PC__c, CXTC007F_ACTION__c, CXTC007F_AOPS_KEY1__c, CXTC007F_TIMESTAMP__c, SYNC_STATUS_MESSAGE__c
            FROM AOPS_Account_BSD_Addendum__c WHERE Record_Updated__c = true AND CCU007F_CUSTOMER_ID__c IN :accountIdList];

        return initialRecs;
    }

    private List<AOPS_Account_Child_Parent_Relationship__c> getAccountChildParentRelList(List<String> accountIdList) {
        List<AOPS_Account_Child_Parent_Relationship__c> initialRecs = [SELECT Id, Unique_Record_ID__c, Record_Updated__c, CXTF005P_ACTION__c, CXTF005P_AOPS_KEY1__c,
            CXTF005P_MSG_TYPE__c, CXTF005P_TIMESTAMP__c, FCU005P_CUSTOMER_ID__c, FCU005P_INCENTIVE_ACC__c, FCU005P_PARENT_ID__c, FCU005P_SALE_DETAIL_ACC__c, SYNC_STATUS_MESSAGE__c
            FROM AOPS_Account_Child_Parent_Relationship__c WHERE Record_Updated__c = true AND FCU005P_CUSTOMER_ID__c IN :accountIdList];

        return initialRecs;
    }

    private List<AOPS_Account_Preferences__c> getAccountPreferencesList(List<String> accountIdList) {
        List<AOPS_Account_Preferences__c> initialRecs = [SELECT Id, Unique_Record_ID__c, Record_Updated__c, CXTF370P_ACTION__c, CXTF370P_AOPS_KEY1__c, CXTF370P_AOPS_KEY2__c,
            CXTF370P_TIMESTAMP__c, FCU370P_CREATE_DATE__c, FCU370P_CREATE_ID__c, FCU370P_CUSTOMER_ID__c, FCU370P_ENABLE_CNT_OPTIN__c, FCU370P_FILLER1__c, FCU370P_FILLER2__c,
            FCU370P_FILLER3__c, FCU370P_FILLER4__c, FCU370P_FILLER5__c, FCU370P_UPDATE_DATE__c, FCU370P_UPDATE_ID__c, FCU370P_VEHICLE_CODE__c, SYNC_STATUS_MESSAGE__c
            FROM AOPS_Account_Preferences__c WHERE Record_Updated__c = true AND FCU370P_CUSTOMER_ID__c IN :accountIdList];

        return initialRecs;
    }

    private List<AOPS_Address_Master__c> getAccountAddressMasterList(List<String> accountIdList) {
        List<AOPS_Address_Master__c> initialRecs = [SELECT Id, Unique_Record_ID__c, Record_Updated__c, CXTF001P_ACTION__c, CXTF001P_AOPS_KEY1__c, CXTF001P_AOPS_KEY2__c,
            CXTF001P_CONTRAT_RETAIL__c, CXTF001P_COUNTY__c, CXTF001P_EXT_CUSTOMER__c, CXTF001P_INDIRECT_FLAG__c, CXTF001P_ORDER_LOCATION__c, CXTF001P_SALES_REP_ID__c,
            CXTF001P_SFDC_KEY1__c, CXTF001P_SFDC_KEY2__c, CXTF001P_TIMESTAMP__c, FCU001P_ADDL_PHONE_CONT_IND__c, FCU001P_ADDR_CNG_DATE__c, FCU001P_ADDR_CNG_HYGIENE__c,
            FCU001P_ADDR_COMM_IND__c, FCU001P_ADDR_ERROR_CODE__c, FCU001P_ADDR_HOURS_IND__c, FCU001P_ADDR_OVERRIDDEN__c, FCU001P_ADDR_VALID_DATE__c,
            FCU001P_ADDRESS_KEY__c, FCU001P_ADDRESS_SEQ__c, FCU001P_BILL_TO_YN__c, FCU001P_BRAND__c, FCU001P_BUSINESS_NAME__c, FCU001P_CHANGED_APPLICATION__c,
            FCU001P_CHANGED_CLIENT__c, FCU001P_CITY__c, FCU001P_COUNTRY_CODE__c, FCU001P_CREATE_DATE__c, FCU001P_CREATE_ID__c, FCU001P_CREATED_APPLICATION__c,
            FCU001P_CREATED_CLIENT__c, FCU001P_CUSTOMER_ID__c, FCU001P_DATE_STS_MOD__c, FCU001P_DLV_POINT_CODE__c, FCU001P_DUNS_NBR__c, FCU001P_GEO_CODE__c,
            FCU001P_GP1_VALIDATED__c, FCU001P_HYGIENE_CNG_STATUS__c, FCU001P_MAIL_FLAG__c, FCU001P_MAIL_TO_YN__c, FCU001P_NAME_CNG_DATE__c,
            FCU001P_OUTSIDE_CITY_FLAG__c, FCU001P_OVERRIDE_ROUTE__c, FCU001P_PHONE_CONT_SEQ__c, FCU001P_PO_BOX_FLAG__c, FCU001P_PROVINCE__c,
            FCU001P_PST_TAX_EXEMPT_FLAG__c, FCU001P_RDI__c, FCU001P_RESERVED_SPACE__c, FCU001P_ROUTING_FLAG__c, FCU001P_RSV_10CHAR__c, FCU001P_RSV_10V2__c,
            FCU001P_RSV_1CHAR_1__c, FCU001P_RSV_2CHAR_1__c, FCU001P_RSV_4CHAR_1__c, FCU001P_RSV_6CHAR_1__c, FCU001P_SHIP_TO_YN__c, FCU001P_SHIPTO_STS__c, FCU001P_STATE__c,
            FCU001P_STOP_NBR__c, FCU001P_STREET_ADDRESS1__c, FCU001P_STREET_ADDRESS2__c, FCU001P_TIME_STAMP__c, FCU001P_ZIP__c, SYNC_STATUS_MESSAGE__c
            FROM AOPS_Address_Master__c WHERE Record_Updated__c = true AND FCU001P_CUSTOMER_ID__c IN :accountIdList LIMIT :SITE_BATCH_SIZE];

        return initialRecs;
    }

    private List<AOPS_Address_BSD_A__c> getAccountAddressBSDAddendumList(List<String> accountIdList) {
        List<AOPS_Address_BSD_A__c> initialRecs = [SELECT Id, Unique_Record_ID__c, Record_Updated__c, CCU009F_ADDL_SALESPERSON_IND__c, CCU009F_ADDRESS_SEQ__c,
            CCU009F_AOPD_FLAG__c, CCU009F_BACKORDER_ALLOW_FLAG__c, CCU009F_CONTRACT_CODE__c, CCU009F_COST_CODE__c, CCU009F_CREATE_DATE__c, CCU009F_CREATE_ID__c,
            CCU009F_CUSTOMER_ID__c, CCU009F_FAX_INV_CODE__c, CCU009F_FAX_PO_CODE__c, CCU009F_FAX_SHIP_CONFIRMATION__c, CCU009F_FILLER__c, CCU009F_HEDBERG_ADDRESS_ID__c,
            CCU009F_LAST_USED_DATE__c, CCU009F_LINE_LIMIT__c, CCU009F_LOCATION_INDICATOR__c, CCU009F_LOCATION_REQ_CODE__c, CCU009F_MIN_DISCOUNT__c, CCU009F_MIN_GP_PERCENT__c,
            CCU009F_OFF_CATALOG_DATE__c, CCU009F_OFF_PRICE_CODE__c, CCU009F_OFF_PRICE_PC__c, CCU009F_OFF_PRICE_ZONE__c, CCU009F_ORDER_LIMIT__c, CCU009F_ORDER_REST_IND__c,
            CCU009F_PRICE_PLAN__c, CCU009F_PRICE_PLAN_SEQ__c, CCU009F_PUR_FAX_CONT_SEQ__c, CCU009F_PUR_PHONE_CONT_SEQ__c, CCU009F_REPORT_DIST_FLAG__c,
            CCU009F_REPORT_DIST_ID__c, CCU009F_SALESPERSON_ID__c, CCU009F_SHIP_TO_DOLLAR_EXPIRE__c, CCU009F_SHIP_TO_DOLLARS__c, CCU009F_SHIP_TO_LIMIT__c,
            CCU009F_TIME_STAMP__c, CCU009F_UPDATE_DATE__c, CCU009F_UPDATE_PROGRAM__c, CCU009F_WHL_PRICE_CODE__c, CCU009F_WHL_PRICE_PC__c, CXTC009F_ACTION__c,
            CXTC009F_AOPS_KEY1__c, CXTC009F_AOPS_KEY2__c, CXTC009F_TIMESTAMP__c, SYNC_STATUS_MESSAGE__c
            FROM AOPS_Address_BSD_A__c WHERE Record_Updated__c = true AND CCU009F_CUSTOMER_ID__c IN :accountIdList];

        return initialRecs;
    }
   
}