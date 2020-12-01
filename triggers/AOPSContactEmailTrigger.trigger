trigger AOPSContactEmailTrigger on AOPS_Contact_Email__c (before update) {
    List<AOPS_Contact_Email__c> newRecList = (List<AOPS_Contact_Email__c>) Trigger.new;
    List<AOPS_Contact_Email__c> oldRecList = (List<AOPS_Contact_Email__c>) Trigger.old;

    Map<String, AOPS_Contact_Email__c> newRecMap = new Map<String, AOPS_Contact_Email__c>();
    for (AOPS_Contact_Email__c rec : newRecList) {
        newRecMap.put(rec.Unique_Record_ID__c, rec);
    }
    
    System.debug('In trigger....');
    for (AOPS_Contact_Email__c oldRec : oldRecList) {
    
        AOPS_Contact_Email__c newRec = newRecMap.get(oldRec.Unique_Record_ID__c);
        
        String newTS = newRec.CXTCNTE_TIMESTAMP__c;
        String oldTS = oldRec.CXTCNTE_TIMESTAMP__c;
        
        if (newTS.compareTo(oldTS) <= 0) {
            newRec.CXTCNTE_TIMESTAMP__c = oldRec.CXTCNTE_TIMESTAMP__c;
            newRec.CXTCNTE_ACTION__c = oldRec.CXTCNTE_ACTION__c;
            newRec.CCU340F_ADDRESS_SEQ__c = oldRec.CCU340F_ADDRESS_SEQ__c;
            newRec.CCU340F_CONTACT_ID__c = oldRec.CCU340F_CONTACT_ID__c;
            newRec.CCU340F_INTERNET_TYPE__c = oldRec.CCU340F_INTERNET_TYPE__c;
            newRec.CCU340F_ADDRESS__c = oldRec.CCU340F_ADDRESS__c;
            newRec.CCU340F_CONTACT_DFT_INTERNET__c = oldRec.CCU340F_CONTACT_DFT_INTERNET__c;
            newRec.CCU340F_USER_ROLE__c = oldRec.CCU340F_USER_ROLE__c;
            newRec.CCU340F_INVALID_ADDRESS__c = oldRec.CCU340F_INVALID_ADDRESS__c;
            newRec.CCU340F_EMAIL_OUT_TYPE__c = oldRec.CCU340F_EMAIL_OUT_TYPE__c;       
            newRec.Record_Updated__c = false;   
        }
    }
}