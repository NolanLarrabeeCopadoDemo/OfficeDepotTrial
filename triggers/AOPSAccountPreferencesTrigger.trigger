trigger AOPSAccountPreferencesTrigger on AOPS_Account_Preferences__c (before update) {
    List<AOPS_Account_Preferences__c> newRecList = (List<AOPS_Account_Preferences__c>) Trigger.new;
    List<AOPS_Account_Preferences__c> oldRecList = (List<AOPS_Account_Preferences__c>) Trigger.old;

    Map<String, AOPS_Account_Preferences__c> newRecMap = new Map<String, AOPS_Account_Preferences__c>();
    for (AOPS_Account_Preferences__c rec : newRecList) {
        newRecMap.put(rec.Unique_Record_ID__c, rec);
    }
    
    for (AOPS_Account_Preferences__c oldRec : oldRecList) {
    
        AOPS_Account_Preferences__c newRec = newRecMap.get(oldRec.Unique_Record_ID__c);
        
        String newTS = newRec.CXTF370P_TIMESTAMP__c;
        String oldTS = oldRec.CXTF370P_TIMESTAMP__c;
        
        if (newTS.compareTo(oldTS) <= 0) {
            newRec.CXTF370P_TIMESTAMP__c = oldRec.CXTF370P_TIMESTAMP__c;
            newRec.CXTF370P_ACTION__c = oldRec.CXTF370P_ACTION__c;
            newRec.FCU370P_CUSTOMER_ID__c = oldRec.FCU370P_CUSTOMER_ID__c;
            newRec.FCU370P_VEHICLE_CODE__c = oldRec.FCU370P_VEHICLE_CODE__c;
            newRec.FCU370P_ENABLE_CNT_OPTIN__c = oldRec.FCU370P_ENABLE_CNT_OPTIN__c;
            newRec.FCU370P_CREATE_DATE__c = oldRec.FCU370P_CREATE_DATE__c;
            newRec.FCU370P_UPDATE_DATE__c = oldRec.FCU370P_UPDATE_DATE__c;
            newRec.FCU370P_CREATE_ID__c = oldRec.FCU370P_CREATE_ID__c;
            newRec.FCU370P_UPDATE_ID__c = oldRec.FCU370P_UPDATE_ID__c;
            newRec.FCU370P_FILLER1__c = oldRec.FCU370P_FILLER1__c;
            newRec.FCU370P_FILLER2__c = oldRec.FCU370P_FILLER2__c;
            newRec.FCU370P_FILLER3__c = oldRec.FCU370P_FILLER3__c;
            newRec.FCU370P_FILLER4__c = oldRec.FCU370P_FILLER4__c;
			newRec.FCU370P_FILLER5__c = oldRec.FCU370P_FILLER5__c;
			newRec.Record_Updated__c = false;
        }
    }
}