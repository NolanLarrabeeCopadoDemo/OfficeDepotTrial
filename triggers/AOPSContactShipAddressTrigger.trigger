trigger AOPSContactShipAddressTrigger on AOPS_Contact_Ship_Address__c (before update) {

    List<AOPS_Contact_Ship_Address__c> newRecList = (List<AOPS_Contact_Ship_Address__c>) Trigger.new;
    List<AOPS_Contact_Ship_Address__c> oldRecList = (List<AOPS_Contact_Ship_Address__c>) Trigger.old;

    Map<String, AOPS_Contact_Ship_Address__c> newRecMap = new Map<String, AOPS_Contact_Ship_Address__c>();
    for (AOPS_Contact_Ship_Address__c rec : newRecList) {
        newRecMap.put(rec.Unique_Record_ID__c, rec);
    }
    
    for (AOPS_Contact_Ship_Address__c oldRec : oldRecList) {
    
        AOPS_Contact_Ship_Address__c newRec = newRecMap.get(oldRec.Unique_Record_ID__c);
        
        String newTS = newRec.CXTCNTS_TIMESTAMP__c;
        String oldTS = oldRec.CXTCNTS_TIMESTAMP__c;
        
        if (newTS.compareTo(oldTS) <= 0) {
            newRec.Unique_Record_ID__c = oldRec.Unique_Record_ID__c;
            newRec.CXTCNTS_TIMESTAMP__c = oldRec.CXTCNTS_TIMESTAMP__c;
            newRec.CXTCNTS_ACTION__c = oldRec.CXTCNTS_ACTION__c;
            newRec.CCU310F_ADDR_SEQ__c = oldRec.CCU310F_ADDR_SEQ__c;
            newRec.CCU310F_ALLOW_BUY__c = oldRec.CCU310F_ALLOW_BUY__c;
            newRec.CCU310F_BRAND__c = oldRec.CCU310F_BRAND__c;
            newRec.CCU310F_CONTACT_ID__c = oldRec.CCU310F_CONTACT_ID__c;
            newRec.CCU310F_CUSTOMER_ID__c = oldRec.CCU310F_CUSTOMER_ID__c;
            newRec.CCU310F_DFT_SHIP_CONT__c = oldRec.CCU310F_DFT_SHIP_CONT__c;
            newRec.CCU310F_UPDATE_BY__c = oldRec.CCU310F_UPDATE_BY__c;
            newRec.CCU310F_UPDATE_DT__c = oldRec.CCU310F_UPDATE_DT__c;
            newRec.Record_Updated__c = false;
        }
    }
}