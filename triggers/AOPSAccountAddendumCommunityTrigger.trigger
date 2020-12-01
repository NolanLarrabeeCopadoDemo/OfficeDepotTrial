trigger AOPSAccountAddendumCommunityTrigger on AOPS_Account_Addendum_Community__c (before update) {

    List<AOPS_Account_Addendum_Community__c> newRecList = (List<AOPS_Account_Addendum_Community__c>) Trigger.new;
    List<AOPS_Account_Addendum_Community__c> oldRecList = (List<AOPS_Account_Addendum_Community__c>) Trigger.old;

    Map<String, AOPS_Account_Addendum_Community__c> newRecMap = new Map<String, AOPS_Account_Addendum_Community__c>();
    for (AOPS_Account_Addendum_Community__c rec : newRecList) {
        newRecMap.put(rec.Unique_Record_ID__c, rec);
    }
    
    for (AOPS_Account_Addendum_Community__c oldRec : oldRecList) {
    
        AOPS_Account_Addendum_Community__c newRec = newRecMap.get(oldRec.Unique_Record_ID__c);
        
        String newTS = newRec.CXTC043F_TIMESTAMP__c;
        String oldTS = oldRec.CXTC043F_TIMESTAMP__c;
        
        if (newTS.compareTo(oldTS) <= 0) {
            newRec.CXTC043F_MSG_TYPE__c = oldRec.CXTC043F_MSG_TYPE__c;
            newRec.CXTC043F_AOPS_KEY1__c = oldRec.CXTC043F_AOPS_KEY1__c;
            newRec.CXTC043F_AOPS_KEY2__c = oldRec.CXTC043F_AOPS_KEY2__c;
            newRec.CXTC043F_AOPS_KEY3__c = oldRec.CXTC043F_AOPS_KEY3__c;
            newRec.CXTC043F_TIMESTAMP__c = oldRec.CXTC043F_TIMESTAMP__c;
            newRec.CXTC043F_ACTION__c = oldRec.CXTC043F_ACTION__c;
            newRec.CCU043F_AECUST__c = oldRec.CCU043F_AECUST__c;
            newRec.CCU043F_AECD01__c = oldRec.CCU043F_AECD01__c;
            newRec.CCU043F_AECD02__c = oldRec.CCU043F_AECD02__c;
            newRec.CCU043F_AECD03__c = oldRec.CCU043F_AECD03__c;
            newRec.CCU043F_AECD04__c = oldRec.CCU043F_AECD04__c;
            newRec.CCU043F_AECD05__c = oldRec.CCU043F_AECD05__c;
            newRec.CCU043F_AECD06__c = oldRec.CCU043F_AECD06__c;
            newRec.CCU043F_AECD07__c = oldRec.CCU043F_AECD07__c;
            newRec.CCU043F_AECD08__c = oldRec.CCU043F_AECD08__c;
            newRec.CCU043F_AECD09__c = oldRec.CCU043F_AECD09__c;
            newRec.CCU043F_AECD10__c = oldRec.CCU043F_AECD10__c;
            newRec.CCU043F_AECD11__c = oldRec.CCU043F_AECD11__c;
            newRec.CCU043F_AECD12__c = oldRec.CCU043F_AECD12__c;
            newRec.CCU043F_AECD13__c = oldRec.CCU043F_AECD13__c;
            newRec.CCU043F_AECD14__c = oldRec.CCU043F_AECD14__c;
            newRec.CCU043F_AECD15__c = oldRec.CCU043F_AECD15__c;
            newRec.CCU043F_AECD16__c = oldRec.CCU043F_AECD16__c;
            newRec.CCU043F_AECD17__c = oldRec.CCU043F_AECD17__c;
            newRec.CCU043F_AECD18__c = oldRec.CCU043F_AECD18__c;
            newRec.CCU043F_AECD19__c = oldRec.CCU043F_AECD19__c;
            newRec.CCU043F_AECD20__c = oldRec.CCU043F_AECD20__c;
            newRec.CCU043F_AECD55__c = oldRec.CCU043F_AECD55__c;
            newRec.CCU043F_AECD44__c = oldRec.CCU043F_AECD44__c;
            newRec.CCU043F_AECD33__c = oldRec.CCU043F_AECD33__c;
            newRec.CCU043F_AECD22__c = oldRec.CCU043F_AECD22__c;
            newRec.CCU043F_AECDCO1__c = oldRec.CCU043F_AECDCO1__c;
            newRec.CCU043F_AECDCO2__c = oldRec.CCU043F_AECDCO2__c;
            newRec.CCU043F_AENM01__c = oldRec.CCU043F_AENM01__c;
            newRec.CCU043F_AENM02__c = oldRec.CCU043F_AENM02__c;
            newRec.CCU043F_AENM03__c = oldRec.CCU043F_AENM03__c;
            newRec.CCU043F_AENM04__c = oldRec.CCU043F_AENM04__c;
            newRec.CCU043F_AENM05__c = oldRec.CCU043F_AENM05__c;
            newRec.CCU043F_AENM06__c = oldRec.CCU043F_AENM06__c;
            newRec.CCU043F_AENM07__c = oldRec.CCU043F_AENM07__c;
            newRec.CCU043F_AENM08__c = oldRec.CCU043F_AENM08__c;
            newRec.Record_Updated__c = false;
        }
    }
}