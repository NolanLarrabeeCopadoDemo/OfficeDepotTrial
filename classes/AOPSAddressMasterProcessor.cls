public class AOPSAddressMasterProcessor {
    
    /**
     * Takes in key value pairs from a request for the AOPS Address
     * Master staging object, and upserts against that object.
     */
    public static boolean process(Map<String,Object> aopsDataMap) {
        if (aopsDataMap == null) {
            return false;
        }
        AOPS_Address_Master__c addressMaster = new AOPS_Address_Master__c();
        
        populateObject(aopsDataMap, addressMaster);
        
        Schema.SObjectField uniqueField = AOPS_Address_Master__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(addressMaster, uniqueField, false);
        return upsertResult.isSuccess();
    }
    
    /**
     * Populates the AOPS Address Master staging record with data from the key value pairs.
     */
    private static void populateObject(Map<String,Object> source, AOPS_Address_Master__c target) {

        String aopsCustId = (String) source.get('CXTF001P_AOPS_KEY1');
        aopsCustId = String.valueOf(Integer.valueOf(aopsCustId));
        String uniqueKey = aopsCustId + String.valueOf(Integer.valueOf((String)source.get('CXTF001P_AOPS_KEY2')));
        target.Unique_Record_ID__c = uniqueKey;
        target.CXTF001P_SFDC_KEY1__c = (String) source.get('CXTF001P_SFDC_KEY1');
        target.CXTF001P_SFDC_KEY2__c = (String) source.get('CXTF001P_SFDC_KEY2');
        target.CXTF001P_TIMESTAMP__c = (String) source.get('CXTF001P_TIMESTAMP');
        target.CXTF001P_ACTION__c = (String) source.get('CXTF001P_ACTION');
        target.FCU001P_CUSTOMER_ID__c = aopsCustId;
        target.FCU001P_ADDRESS_SEQ__c = (String) source.get('FCU001P_ADDRESS_SEQ');
        target.FCU001P_ADDRESS_KEY__c = (String) source.get('FCU001P_ADDRESS_KEY');
        target.FCU001P_BUSINESS_NAME__c = (String) source.get('FCU001P_BUSINESS_NAME');
        target.FCU001P_STREET_ADDRESS1__c = (String) source.get('FCU001P_STREET_ADDRESS1');
        target.FCU001P_STREET_ADDRESS2__c = (String) source.get('FCU001P_STREET_ADDRESS2');
        target.FCU001P_CITY__c = (String) source.get('FCU001P_CITY');
        target.FCU001P_STATE__c = (String) source.get('FCU001P_STATE');
        target.FCU001P_PROVINCE__c = (String) source.get('FCU001P_PROVINCE');
        target.FCU001P_ZIP__c = (String) source.get('FCU001P_ZIP');
        target.FCU001P_COUNTRY_CODE__c = (String) source.get('FCU001P_COUNTRY_CODE');
        target.FCU001P_GEO_CODE__c = (String) source.get('FCU001P_GEO_CODE');
        target.FCU001P_PST_TAX_EXEMPT_FLAG__c = (String) source.get('FCU001P_PST_TAX_EXEMPT_FLAG');
        target.FCU001P_OUTSIDE_CITY_FLAG__c = (String) source.get('FCU001P_OUTSIDE_CITY_FLAG');
        target.FCU001P_PO_BOX_FLAG__c = (String) source.get('FCU001P_PO_BOX_FLAG');
        target.FCU001P_PHONE_CONT_SEQ__c = (String) source.get('FCU001P_PHONE_CONT_SEQ');
        target.FCU001P_ADDL_PHONE_CONT_IND__c = (String) source.get('FCU001P_ADDL_PHONE_CONT_IND');
        target.FCU001P_MAIL_FLAG__c = (String) source.get('FCU001P_MAIL_FLAG');
        target.FCU001P_ADDR_HOURS_IND__c = (String) source.get('FCU001P_ADDR_HOURS_IND');
        target.FCU001P_ADDR_COMM_IND__c = (String) source.get('FCU001P_ADDR_COMM_IND');
        target.FCU001P_ROUTING_FLAG__c = (String) source.get('FCU001P_ROUTING_FLAG');
        target.FCU001P_OVERRIDE_ROUTE__c = (String) source.get('FCU001P_OVERRIDE_ROUTE');
        target.FCU001P_STOP_NBR__c = (String) source.get('FCU001P_STOP_NBR');
        target.FCU001P_CREATE_DATE__c = (String) source.get('FCU001P_CREATE_DATE');
        target.FCU001P_CREATE_ID__c = (String) source.get('FCU001P_CREATE_ID');
        target.FCU001P_TIME_STAMP__c = (String) source.get('FCU001P_TIME_STAMP');
        target.FCU001P_RESERVED_SPACE__c = (String) source.get('FCU001P_RESERVED_SPACE');
        target.FCU001P_SHIPTO_STS__c = (String) source.get('FCU001P_SHIPTO_STS');
        target.FCU001P_DATE_STS_MOD__c = (String) source.get('FCU001P_DATE_STS_MOD');
        target.FCU001P_DLV_POINT_CODE__c = (String) source.get('FCU001P_DLV_POINT_CODE');
        target.FCU001P_GP1_VALIDATED__c = (String) source.get('FCU001P_GP1_VALIDATED');
        target.FCU001P_BRAND__c = (String) source.get('FCU001P_BRAND');
        target.FCU001P_BILL_TO_YN__c = (String) source.get('FCU001P_BILL_TO_YN');
        target.FCU001P_SHIP_TO_YN__c = (String) source.get('FCU001P_SHIP_TO_YN');
        target.FCU001P_MAIL_TO_YN__c = (String) source.get('FCU001P_MAIL_TO_YN');
        target.FCU001P_RSV_1CHAR_1__c = (String) source.get('FCU001P_RSV_1CHAR_1');
        target.FCU001P_RSV_2CHAR_1__c = (String) source.get('FCU001P_RSV_2CHAR_1');
        target.FCU001P_RSV_4CHAR_1__c = (String) source.get('FCU001P_RSV_4CHAR_1');
        target.FCU001P_RSV_6CHAR_1__c = (String) source.get('FCU001P_RSV_6CHAR_1');
        target.FCU001P_RSV_10CHAR__c = (String) source.get('FCU001P_RSV_10CHAR');
        target.FCU001P_RSV_10V2__c = (String) source.get('FCU001P_RSV_10V2');
        target.FCU001P_RDI__c = (String) source.get('FCU001P_RDI');
        target.FCU001P_DUNS_NBR__c = (String) source.get('FCU001P_DUNS_NBR');
        target.FCU001P_ADDR_VALID_DATE__c = (String) source.get('FCU001P_ADDR_VALID_DATE');
        target.FCU001P_ADDR_OVERRIDDEN__c = (String) source.get('FCU001P_ADDR_OVERRIDDEN');
        target.FCU001P_ADDR_ERROR_CODE__c = (String) source.get('FCU001P_ADDR_ERROR_CODE');
        target.FCU001P_ADDR_CNG_DATE__c = (String) source.get('FCU001P_ADDR_CNG_DATE');
        target.FCU001P_NAME_CNG_DATE__c = (String) source.get('FCU001P_NAME_CNG_DATE');
        target.FCU001P_ADDR_CNG_HYGIENE__c = (String) source.get('FCU001P_ADDR_CNG_HYGIENE');
        target.FCU001P_HYGIENE_CNG_STATUS__c = (String) source.get('FCU001P_HYGIENE_CNG_STATUS');
        target.FCU001P_CREATED_CLIENT__c = (String) source.get('FCU001P_CREATED_CLIENT');
        target.FCU001P_CHANGED_CLIENT__c = (String) source.get('FCU001P_CHANGED_CLIENT');
        target.FCU001P_CREATED_APPLICATION__c = (String) source.get('FCU001P_CREATED_APPLICATION');
        target.FCU001P_CHANGED_APPLICATION__c = (String) source.get('FCU001P_CHANGED_APPLICATION');
        target.CXTF001P_COUNTY__c = (String) source.get('CXTF001P_COUNTY');
        target.CXTF001P_CONTRAT_RETAIL__c = (String) source.get('CXTF001P_CONTRAT_RETAIL');
        target.CXTF001P_SALES_REP_ID__c = (String) source.get('CXTF001P_SALES_REP_ID');
        target.CXTF001P_INDIRECT_FLAG__c = (String) source.get('CXTF001P_INDIRECT_FLAG');
        target.CXTF001P_EXT_CUSTOMER__c = (String) source.get('CXTF001P_EXT_CUSTOMER');
        target.CXTF001P_ORDER_LOCATION__c = (String) source.get('CXTF001P_ORDER_LOCATION');
        target.SYNC_STATUS_MESSAGE__c = '';
        // Specify that the record has been updated. Note that this will be reset
        // to false in a trigger if the request is not the most recent one.
        target.Record_Updated__c = true;
    }
}