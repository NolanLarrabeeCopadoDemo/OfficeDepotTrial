trigger AOPSAddressMasterTrigger on AOPS_Address_Master__c (before update) {
    List<AOPS_Address_Master__c> newRecList = (List<AOPS_Address_Master__c>) Trigger.new;
    List<AOPS_Address_Master__c> oldRecList = (List<AOPS_Address_Master__c>) Trigger.old;

    Map<String, AOPS_Address_Master__c> newRecMap = new Map<String, AOPS_Address_Master__c>();
    for (AOPS_Address_Master__c rec : newRecList) {
        newRecMap.put(rec.Unique_Record_ID__c, rec);
    }
    System.debug('Total number of records in address master trigger........'+ newRecList.size() + ', '+ oldRecList.size());
    for (AOPS_Address_Master__c oldRec : oldRecList) {
    
        AOPS_Address_Master__c newRec = newRecMap.get(oldRec.Unique_Record_ID__c);
        
        String newTS = newRec.CXTF001P_TIMESTAMP__c;
        String oldTS = oldRec.CXTF001P_TIMESTAMP__c;
        
        if (newTS.compareTo(oldTS) <= 0) {
            newRec.CXTF001P_TIMESTAMP__c = oldRec.CXTF001P_TIMESTAMP__c;
            newRec.CXTF001P_ACTION__c = oldRec.CXTF001P_ACTION__c;
            newRec.FCU001P_CUSTOMER_ID__c = oldRec.FCU001P_CUSTOMER_ID__c;
            newRec.FCU001P_ADDRESS_SEQ__c = oldRec.FCU001P_ADDRESS_SEQ__c;
            newRec.FCU001P_ADDRESS_KEY__c = oldRec.FCU001P_ADDRESS_KEY__c;
            newRec.CXTF001P_SFDC_KEY1__c = oldRec.CXTF001P_SFDC_KEY1__c;
            newRec.CXTF001P_SFDC_KEY2__c = oldRec.CXTF001P_SFDC_KEY2__c;
            newRec.FCU001P_BUSINESS_NAME__c = oldRec.FCU001P_BUSINESS_NAME__c;
            newRec.FCU001P_STREET_ADDRESS1__c = oldRec.FCU001P_STREET_ADDRESS1__c;
            newRec.FCU001P_STREET_ADDRESS2__c = oldRec.FCU001P_STREET_ADDRESS2__c;
            newRec.FCU001P_CITY__c = oldRec.FCU001P_CITY__c;
            newRec.FCU001P_STATE__c = oldRec.FCU001P_STATE__c;
            newRec.FCU001P_PROVINCE__c = oldRec.FCU001P_PROVINCE__c;
            newRec.FCU001P_ZIP__c = oldRec.FCU001P_ZIP__c;
            newRec.FCU001P_COUNTRY_CODE__c = oldRec.FCU001P_COUNTRY_CODE__c;
            newRec.FCU001P_GEO_CODE__c = oldRec.FCU001P_GEO_CODE__c;
            newRec.FCU001P_PST_TAX_EXEMPT_FLAG__c = oldRec.FCU001P_PST_TAX_EXEMPT_FLAG__c;
            newRec.FCU001P_OUTSIDE_CITY_FLAG__c = oldRec.FCU001P_OUTSIDE_CITY_FLAG__c;
            newRec.FCU001P_PO_BOX_FLAG__c = oldRec.FCU001P_PO_BOX_FLAG__c;
            newRec.FCU001P_PHONE_CONT_SEQ__c = oldRec.FCU001P_PHONE_CONT_SEQ__c;
            newRec.FCU001P_ADDL_PHONE_CONT_IND__c = oldRec.FCU001P_ADDL_PHONE_CONT_IND__c;
            newRec.FCU001P_MAIL_FLAG__c = oldRec.FCU001P_MAIL_FLAG__c;
            newRec.FCU001P_ADDR_HOURS_IND__c = oldRec.FCU001P_ADDR_HOURS_IND__c;
            newRec.FCU001P_ADDR_COMM_IND__c = oldRec.FCU001P_ADDR_COMM_IND__c;
            newRec.FCU001P_ROUTING_FLAG__c = oldRec.FCU001P_ROUTING_FLAG__c;
            newRec.FCU001P_OVERRIDE_ROUTE__c = oldRec.FCU001P_OVERRIDE_ROUTE__c;
            newRec.FCU001P_STOP_NBR__c = oldRec.FCU001P_STOP_NBR__c;
            newRec.FCU001P_CREATE_DATE__c = oldRec.FCU001P_CREATE_DATE__c;
            newRec.FCU001P_CREATE_ID__c = oldRec.FCU001P_CREATE_ID__c;
            newRec.FCU001P_TIME_STAMP__c = oldRec.FCU001P_TIME_STAMP__c;
            newRec.FCU001P_RESERVED_SPACE__c = oldRec.FCU001P_RESERVED_SPACE__c;
            newRec.FCU001P_SHIPTO_STS__c = oldRec.FCU001P_SHIPTO_STS__c;
            newRec.FCU001P_DATE_STS_MOD__c = oldRec.FCU001P_DATE_STS_MOD__c;
            newRec.FCU001P_DLV_POINT_CODE__c = oldRec.FCU001P_DLV_POINT_CODE__c;
            newRec.FCU001P_GP1_VALIDATED__c = oldRec.FCU001P_GP1_VALIDATED__c;
            newRec.FCU001P_BRAND__c = oldRec.FCU001P_BRAND__c;
            newRec.FCU001P_BILL_TO_YN__c = oldRec.FCU001P_BILL_TO_YN__c;
            newRec.FCU001P_SHIP_TO_YN__c = oldRec.FCU001P_SHIP_TO_YN__c;
            newRec.FCU001P_MAIL_TO_YN__c = oldRec.FCU001P_MAIL_TO_YN__c;
            newRec.FCU001P_RSV_1CHAR_1__c = oldRec.FCU001P_RSV_1CHAR_1__c;
            newRec.FCU001P_RSV_2CHAR_1__c = oldRec.FCU001P_RSV_2CHAR_1__c;
            newRec.FCU001P_RSV_4CHAR_1__c = oldRec.FCU001P_RSV_4CHAR_1__c;
            newRec.FCU001P_RSV_6CHAR_1__c = oldRec.FCU001P_RSV_6CHAR_1__c;
            newRec.FCU001P_RSV_10CHAR__c = oldRec.FCU001P_RSV_10CHAR__c;
            newRec.FCU001P_RSV_10V2__c = oldRec.FCU001P_RSV_10V2__c;
            newRec.FCU001P_RDI__c = oldRec.FCU001P_RDI__c;
            newRec.FCU001P_DUNS_NBR__c = oldRec.FCU001P_DUNS_NBR__c;
            newRec.FCU001P_ADDR_VALID_DATE__c = oldRec.FCU001P_ADDR_VALID_DATE__c;
            newRec.FCU001P_ADDR_OVERRIDDEN__c = oldRec.FCU001P_ADDR_OVERRIDDEN__c;
            newRec.FCU001P_ADDR_ERROR_CODE__c = oldRec.FCU001P_ADDR_ERROR_CODE__c;
            newRec.FCU001P_ADDR_CNG_DATE__c = oldRec.FCU001P_ADDR_CNG_DATE__c;
            newRec.FCU001P_NAME_CNG_DATE__c = oldRec.FCU001P_NAME_CNG_DATE__c;
            newRec.FCU001P_ADDR_CNG_HYGIENE__c = oldRec.FCU001P_ADDR_CNG_HYGIENE__c;
            newRec.FCU001P_HYGIENE_CNG_STATUS__c = oldRec.FCU001P_HYGIENE_CNG_STATUS__c;
            newRec.FCU001P_CREATED_CLIENT__c = oldRec.FCU001P_CREATED_CLIENT__c;
            newRec.FCU001P_CHANGED_CLIENT__c = oldRec.FCU001P_CHANGED_CLIENT__c;
            newRec.FCU001P_CREATED_APPLICATION__c = oldRec.FCU001P_CREATED_APPLICATION__c;
            newRec.FCU001P_CHANGED_APPLICATION__c = oldRec.FCU001P_CHANGED_APPLICATION__c;
            newRec.CXTF001P_COUNTY__c = oldRec.CXTF001P_COUNTY__c;
            newRec.CXTF001P_CONTRAT_RETAIL__c = oldRec.CXTF001P_CONTRAT_RETAIL__c;
            newRec.CXTF001P_SALES_REP_ID__c = oldRec.CXTF001P_SALES_REP_ID__c;
            newRec.CXTF001P_INDIRECT_FLAG__c = oldRec.CXTF001P_INDIRECT_FLAG__c;
            newRec.CXTF001P_EXT_CUSTOMER__c = oldRec.CXTF001P_EXT_CUSTOMER__c;
            newRec.CXTF001P_ORDER_LOCATION__c = oldRec.CXTF001P_ORDER_LOCATION__c;
            newRec.Record_Updated__c = false;
        }
    }
}