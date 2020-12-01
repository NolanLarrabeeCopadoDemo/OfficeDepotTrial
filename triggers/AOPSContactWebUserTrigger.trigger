trigger AOPSContactWebUserTrigger on AOPS_Contact_Web_User__c (before update) {
    List<AOPS_Contact_Web_User__c> newRecList = (List<AOPS_Contact_Web_User__c>) Trigger.new;
    List<AOPS_Contact_Web_User__c> oldRecList = (List<AOPS_Contact_Web_User__c>) Trigger.old;

    Map<String, AOPS_Contact_Web_User__c> newRecMap = new Map<String, AOPS_Contact_Web_User__c>();
    for (AOPS_Contact_Web_User__c rec : newRecList) {
        newRecMap.put(rec.Unique_Record_ID__c, rec);
    }
    
    for (AOPS_Contact_Web_User__c oldRec : oldRecList) {
    
        AOPS_Contact_Web_User__c newRec = newRecMap.get(oldRec.Unique_Record_ID__c);
        
        String newTS = newRec.CXTCNTW_TIMESTAMP__c;
        String oldTS = oldRec.CXTCNTW_TIMESTAMP__c;
        
        if (newTS.compareTo(oldTS) <= 0) {
            newRec.CXTCNTW_TIMESTAMP__c = oldRec.CXTCNTW_TIMESTAMP__c;
            newRec.CXTCNTW_ACTION__c = oldRec.CXTCNTW_ACTION__c;
            newRec.CCS056F_CODE_AV__c = oldRec.CCS056F_CODE_AV__c;
            newRec.CCS056F_VALUE_AV__c = oldRec.CCS056F_VALUE_AV__c;
            newRec.CCU300F_MID_INITIAL__c = oldRec.CCU300F_MID_INITIAL__c;
            newRec.CCU300F_NAME_1__c = oldRec.CCU300F_NAME_1__c;
            newRec.CCU300F_NAME_2__c = oldRec.CCU300F_NAME_2__c;
            newRec.CCU330F_AB_FLG__c = oldRec.CCU330F_AB_FLG__c;
            newRec.CCU330F_CONTACT_ID__c = oldRec.CCU330F_CONTACT_ID__c;
            newRec.CCU330F_CUSTOMER_ID__c = oldRec.CCU330F_CUSTOMER_ID__c;
            newRec.CCU330F_DEFAULT_POSTAL_CODE__c = oldRec.CCU330F_DEFAULT_POSTAL_CODE__c;
            newRec.CCU330F_LAST_VISIT_DATE__c = oldRec.CCU330F_LAST_VISIT_DATE__c;
            newRec.CCU330F_ORDER_OK_FLG__c = oldRec.CCU330F_ORDER_OK_FLG__c;
            newRec.CCU330F_PASSWORD__c = oldRec.CCU330F_PASSWORD__c;
            newRec.CCU330F_USER_LOCKED_FLG__c = oldRec.CCU330F_USER_LOCKED_FLG__c;
            newRec.CCU330F_USER_SEQ__c = oldRec.CCU330F_USER_SEQ__c;
            newRec.CCU330F_USER_TYPE__c = oldRec.CCU330F_USER_TYPE__c;
            newRec.CCU330F_USERID__c = oldRec.CCU330F_USERID__c;
            newRec.CCU340F_ADDRESS__c = oldRec.CCU340F_ADDRESS__c;
            newRec.Record_Updated__c = false;
        }
    }
}