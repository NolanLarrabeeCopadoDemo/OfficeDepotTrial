trigger AOPSContactMasterTrigger on AOPS_STG_CONTACT_MASTER__c (before update) {

    List<AOPS_STG_CONTACT_MASTER__c> newRecList = (List<AOPS_STG_CONTACT_MASTER__c>) Trigger.new;
    List<AOPS_STG_CONTACT_MASTER__c> oldRecList = (List<AOPS_STG_CONTACT_MASTER__c>) Trigger.old;

    Map<String, AOPS_STG_CONTACT_MASTER__c> newRecMap = new Map<String, AOPS_STG_CONTACT_MASTER__c>();
    for (AOPS_STG_CONTACT_MASTER__c rec : newRecList) {
        newRecMap.put(rec.Unique_Record_ID__c, rec);
    }
    
    for (AOPS_STG_CONTACT_MASTER__c oldRec : oldRecList) {
    
        AOPS_STG_CONTACT_MASTER__c newRec = newRecMap.get(oldRec.Unique_Record_ID__c);
        
        String newTS = newRec.CXTCNTM_TIMESTAMP__c;
        String oldTS = oldRec.CXTCNTM_TIMESTAMP__c;
        
        if (newTS.compareTo(oldTS) <= 0) {
            newRec.CXTCNTM_MSG_TYPE__c = oldRec.CXTCNTM_MSG_TYPE__c;
            newRec.CXTCNTM_AOPS_KEY1__c = oldRec.CXTCNTM_AOPS_KEY1__c;
            newRec.CXTCNTM_AOPS_KEY2__c = oldRec.CXTCNTM_AOPS_KEY2__c;
            newRec.CXTCNTM_AOPS_KEY3__c = oldRec.CXTCNTM_AOPS_KEY3__c;
            newRec.CXTCNTM_TIMESTAMP__c = oldRec.CXTCNTM_TIMESTAMP__c;
            newRec.CXTCNTM_ACTION__c = oldRec.CXTCNTM_ACTION__c;
            newRec.CXTCNTM_REQ_SOURCE__c = oldRec.CXTCNTM_REQ_SOURCE__c;
            newRec.CXTCNTM_REQ_ID__c = oldRec.CXTCNTM_REQ_ID__c;
            newRec.CCU300F_CONTACT_ID__c = oldRec.CCU300F_CONTACT_ID__c;
            newRec.CCU300F_CUSTOMER_ID__c = oldRec.CCU300F_CUSTOMER_ID__c;
            newRec.CCU300F_DFT_BILL_ADDR__c = oldRec.CCU300F_DFT_BILL_ADDR__c;
            newRec.CCU300F_CNT_SEQ__c = oldRec.CCU300F_CNT_SEQ__c;
            newRec.CCU300F_DFT_SHIP_ADDR__c = oldRec.CCU300F_DFT_SHIP_ADDR__c;
            newRec.CCU300F_DFT_MAIL_ADDR__c = oldRec.CCU300F_DFT_MAIL_ADDR__c;
            newRec.CCU300F_BRAND__c = oldRec.CCU300F_BRAND__c;
            newRec.CCU300F_NAME_1__c = oldRec.CCU300F_NAME_1__c;
            newRec.CCU300F_NAME_2__c = oldRec.CCU300F_NAME_2__c;
            newRec.CCU300F_MID_INITIAL__c = oldRec.CCU300F_MID_INITIAL__c;
            newRec.CCU300F_SALUTATION__c = oldRec.CCU300F_SALUTATION__c;
            newRec.CCU300F_TYPE__c = oldRec.CCU300F_TYPE__c;
            newRec.CCU300F_BIRTHDAY__c = oldRec.CCU300F_BIRTHDAY__c;
            newRec.CCU300F_STATUS__c = oldRec.CCU300F_STATUS__c;
            newRec.CCU300F_CPY_PRIMARY_CONTACT__c = oldRec.CCU300F_CPY_PRIMARY_CONTACT__c;
            newRec.CCU300F_TITLE__c = oldRec.CCU300F_TITLE__c;
            newRec.CCU300F_ROLE_1__c = oldRec.CCU300F_ROLE_1__c;
            newRec.CCU300F_ROLE_2__c = oldRec.CCU300F_ROLE_2__c;
            newRec.CCU300F_AUTH_BUYER_YN__c = oldRec.CCU300F_AUTH_BUYER_YN__c;
            newRec.CCU300F_PO_NBR__c = oldRec.CCU300F_PO_NBR__c;
            newRec.CCU300F_RELEASE_NBR__c = oldRec.CCU300F_RELEASE_NBR__c;
            newRec.CCU300F_DESK_TOP__c = oldRec.CCU300F_DESK_TOP__c;
            newRec.CCU300F_CUST_REQUEST_IND__c = oldRec.CCU300F_CUST_REQUEST_IND__c;
            newRec.CCU300F_LESS_MAIL__c = oldRec.CCU300F_LESS_MAIL__c;
            newRec.CCU300F_RENT_NAME_FLAG__c = oldRec.CCU300F_RENT_NAME_FLAG__c;
            newRec.CCU300F_POLYBAG_FLAG__c = oldRec.CCU300F_POLYBAG_FLAG__c;
            newRec.CCU300F_RSV_1CHAR__c = oldRec.CCU300F_RSV_1CHAR__c;
            newRec.CCU300F_RSV_2CHAR__c = oldRec.CCU300F_RSV_2CHAR__c;
            newRec.CCU300F_RSV_4CHAR__c = oldRec.CCU300F_RSV_4CHAR__c;
            newRec.CCU300F_RSV_10CHAR__c = oldRec.CCU300F_RSV_10CHAR__c;
            newRec.CCU300F_RSV_10V2__c = oldRec.CCU300F_RSV_10V2__c;
            newRec.CCU300F_INFO_SOURCE__c = oldRec.CCU300F_INFO_SOURCE__c;
            newRec.CCU300F_CREATE_DT__c = oldRec.CCU300F_CREATE_DT__c;
            newRec.CCU300F_CREATE_BY__c = oldRec.CCU300F_CREATE_BY__c;
            newRec.CCU300F_UPDATE_DT__c = oldRec.CCU300F_UPDATE_DT__c;
            newRec.CCU300F_UPDATE_BY__c = oldRec.CCU300F_UPDATE_BY__c;
            newRec.Record_Updated__c = false;
        }
    }
}