trigger AOPSContactOptInTrigger on AOPS_CONTACT_OPT_IN__c (before update) {

    List<AOPS_CONTACT_OPT_IN__c> newRecList = (List<AOPS_CONTACT_OPT_IN__c>) Trigger.new;
    List<AOPS_CONTACT_OPT_IN__c> oldRecList = (List<AOPS_CONTACT_OPT_IN__c>) Trigger.old;

    Map<String, AOPS_CONTACT_OPT_IN__c> newRecMap = new Map<String, AOPS_CONTACT_OPT_IN__c>();
    for (AOPS_CONTACT_OPT_IN__c rec : newRecList) {
        newRecMap.put(rec.Unique_Record_ID__c, rec);
    }
    
    for (AOPS_CONTACT_OPT_IN__c oldRec : oldRecList) {
    
        AOPS_CONTACT_OPT_IN__c newRec = newRecMap.get(oldRec.Unique_Record_ID__c);
        
        String newTS = newRec.CXTCNTO_TIMESTAMP__c;
        String oldTS = oldRec.CXTCNTO_TIMESTAMP__c;
        
        if (newTS.compareTo(oldTS) <= 0) {
            newRec.CXTCNTO_AOPS_KEY1__c = oldRec.CXTCNTO_AOPS_KEY1__c;
            newRec.CXTCNTO_AOPS_KEY2__c = oldRec.CXTCNTO_AOPS_KEY2__c;
            newRec.CXTCNTO_AOPS_KEY3__c = oldRec.CXTCNTO_AOPS_KEY3__c;
            newRec.CXTCNTO_TIMESTAMP__c = oldRec.CXTCNTO_TIMESTAMP__c;
            newRec.CXTCNTO_ACTION__c = oldRec.CXTCNTO_ACTION__c;
            newRec.CCU380F_CUSTOMER_ID__c = oldRec.CCU380F_CUSTOMER_ID__c;
            newRec.CCU380F_CONTACT_ID__c = oldRec.CCU380F_CONTACT_ID__c;
            newRec.CCU380F_VEHICLE_CODE__c = oldRec.CCU380F_VEHICLE_CODE__c;
            newRec.CCU380F_SEQUENCE_KEY__c = oldRec.CCU380F_SEQUENCE_KEY__c;
            newRec.CCU380F_OPT_IN__c = oldRec.CCU380F_OPT_IN__c;
            newRec.CCU380F_CREATE_DATE__c = oldRec.CCU380F_CREATE_DATE__c;
            newRec.CCU380F_UPDATE_DATE__c = oldRec.CCU380F_UPDATE_DATE__c;
            newRec.CCU380F_CREATE_ID__c = oldRec.CCU380F_CREATE_ID__c;
            newRec.CCU380F_UPDATE_ID__c = oldRec.CCU380F_UPDATE_ID__c;
            newRec.CCU380F_FILLER1__c = oldRec.CCU380F_FILLER1__c;
            newRec.CCU380F_FILLER2__c = oldRec.CCU380F_FILLER2__c;
            newRec.CCU380F_FILLER3__c = oldRec.CCU380F_FILLER3__c;
            newRec.CCU380F_FILLER4__c = oldRec.CCU380F_FILLER4__c;
            newRec.CCU380F_FILLER5__c = oldRec.CCU380F_FILLER5__c;
            newRec.Record_Updated__c = false;
        }
    }
}