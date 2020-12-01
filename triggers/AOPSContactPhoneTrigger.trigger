trigger AOPSContactPhoneTrigger on AOPS_Contact_Phone__c (before update) {

   List<AOPS_Contact_Phone__c> newRecList = (List<AOPS_Contact_Phone__c>) Trigger.new;
    List<AOPS_Contact_Phone__c> oldRecList = (List<AOPS_Contact_Phone__c>) Trigger.old;

    Map<String, AOPS_Contact_Phone__c> newRecMap = new Map<String, AOPS_Contact_Phone__c>();
    for (AOPS_Contact_Phone__c rec : newRecList) {
        newRecMap.put(rec.Unique_Record_ID__c, rec);
    }
    
    for (AOPS_Contact_Phone__c oldRec : oldRecList) {
    
        AOPS_Contact_Phone__c newRec = newRecMap.get(oldRec.Unique_Record_ID__c);
        
        String newTS = newRec.CXTCNTP_TIMESTAMP__c;
        String oldTS = oldRec.CXTCNTP_TIMESTAMP__c;
        
        if (newTS.compareTo(oldTS) <= 0) {
            newRec.CXTCNTP_MSG_TYPE__c = oldRec.CXTCNTP_MSG_TYPE__c;
            newRec.CXTCNTP_AOPS_KEY1__c = oldRec.CXTCNTP_AOPS_KEY1__c;
            newRec.CXTCNTP_AOPS_KEY2__c = oldRec.CXTCNTP_AOPS_KEY2__c;
            newRec.CXTCNTP_AOPS_KEY3__c = oldRec.CXTCNTP_AOPS_KEY3__c;
            newRec.CXTCNTP_TIMESTAMP__c = oldRec.CXTCNTP_TIMESTAMP__c;
            newRec.CXTCNTP_ACTION__c = oldRec.CXTCNTP_ACTION__c;
            newRec.CCU320F_PHONE_SEQ__c = oldRec.CCU320F_PHONE_SEQ__c;
            newRec.CCU320F_CONTACT_ID__c = oldRec.CCU320F_CONTACT_ID__c;
            newRec.CCU320F_CUSTOMER_ID__c = oldRec.CCU320F_CUSTOMER_ID__c;
            newRec.CCU320F_CNTRY_CODE__c = oldRec.CCU320F_CNTRY_CODE__c;
            newRec.CCU320F_AREA_CODE__c = oldRec.CCU320F_AREA_CODE__c;
            newRec.CCU320F_PREFIX__c = oldRec.CCU320F_PREFIX__c;
            newRec.CCU320F_NUMBER__c = oldRec.CCU320F_NUMBER__c;
            newRec.CCU320F_EXTENSION__c = oldRec.CCU320F_EXTENSION__c;
            newRec.CCU320F_NBR_TYPE__c = oldRec.CCU320F_NBR_TYPE__c;
            newRec.CCU320F_CONTACT_DFT_NUMBER__c = oldRec.CCU320F_CONTACT_DFT_NUMBER__c;
            newRec.CCU320F_LESS_PHONE__c = oldRec.CCU320F_LESS_PHONE__c;
            newRec.CCU320F_INVALID_PHONE__c = oldRec.CCU320F_INVALID_PHONE__c;
            newRec.CCU320F_BRAND__c = oldRec.CCU320F_BRAND__c;
            newRec.Record_Updated__c = false;
        }
    }
}