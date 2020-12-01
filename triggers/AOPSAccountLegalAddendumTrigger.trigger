trigger AOPSAccountLegalAddendumTrigger on AOPS_Account_Addendum_Legal_Other__c (before update) {

    List<AOPS_Account_Addendum_Legal_Other__c> newRecList = (List<AOPS_Account_Addendum_Legal_Other__c>) Trigger.new;
    List<AOPS_Account_Addendum_Legal_Other__c> oldRecList = (List<AOPS_Account_Addendum_Legal_Other__c>) Trigger.old;

    Map<String, AOPS_Account_Addendum_Legal_Other__c> newRecMap = new Map<String, AOPS_Account_Addendum_Legal_Other__c>();
    for (AOPS_Account_Addendum_Legal_Other__c rec : newRecList) {
        newRecMap.put(rec.Unique_Record_ID__c, rec);
    }
    
    for (AOPS_Account_Addendum_Legal_Other__c oldRec : oldRecList) {
    
        AOPS_Account_Addendum_Legal_Other__c newRec = newRecMap.get(oldRec.Unique_Record_ID__c);
        
        String newTS = newRec.CXTC044F_TIMESTAMP__c;
        String oldTS = oldRec.CXTC044F_TIMESTAMP__c;
        
        if (newTS.compareTo(oldTS) <= 0) {
            newRec.CXTC044F_TIMESTAMP__c = oldRec.CXTC044F_TIMESTAMP__c;
            newRec.CXTC044F_ACTION__c = oldRec.CXTC044F_ACTION__c;
            newRec.CCU044F_CUSTOMER_ID__c = oldRec.CCU044F_CUSTOMER_ID__c;
            newRec.CCU044F_CURRENCY_ID__c = oldRec.CCU044F_CURRENCY_ID__c;
            newRec.CCU044F_CODE10__c = oldRec.CCU044F_CODE10__c;
            newRec.CCU044F_CODE25__c = oldRec.CCU044F_CODE25__c;
            newRec.CCU044F_CODE33__c = oldRec.CCU044F_CODE33__c;
            newRec.CCU044F_CODE42__c = oldRec.CCU044F_CODE42__c;
            newRec.CCU044F_CODE51__c = oldRec.CCU044F_CODE51__c;
            newRec.CCU044F_CODE61__c = oldRec.CCU044F_CODE61__c;
            newRec.CCU044F_UPDATE_TS__c = oldRec.CCU044F_UPDATE_TS__c;
			newRec.CCU044F_UPDATE_BY__c = oldRec.CCU044F_UPDATE_BY__c;
			newRec.Record_Updated__c = false;
        }
    }
}