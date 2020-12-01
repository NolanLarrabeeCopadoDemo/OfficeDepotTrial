trigger AOPSAccountChildParentRelTrigger on AOPS_Account_Child_Parent_Relationship__c (before update) {
    List<AOPS_Account_Child_Parent_Relationship__c> newRecList = (List<AOPS_Account_Child_Parent_Relationship__c>) Trigger.new;
    List<AOPS_Account_Child_Parent_Relationship__c> oldRecList = (List<AOPS_Account_Child_Parent_Relationship__c>) Trigger.old;

    Map<String, AOPS_Account_Child_Parent_Relationship__c> newRecMap = new Map<String, AOPS_Account_Child_Parent_Relationship__c>();
    for (AOPS_Account_Child_Parent_Relationship__c rec : newRecList) {
        newRecMap.put(rec.Unique_Record_ID__c, rec);
    }
    
    for (AOPS_Account_Child_Parent_Relationship__c oldRec : oldRecList) {
    
        AOPS_Account_Child_Parent_Relationship__c newRec = newRecMap.get(oldRec.Unique_Record_ID__c);
        
        String newTS = newRec.CXTF005P_TIMESTAMP__c;
        String oldTS = oldRec.CXTF005P_TIMESTAMP__c;
        
        if (newTS.compareTo(oldTS) <= 0) {
            newRec.CXTF005P_TIMESTAMP__c = oldRec.CXTF005P_TIMESTAMP__c;
            newRec.CXTF005P_ACTION__c = oldRec.CXTF005P_ACTION__c;
            newRec.FCU005P_CUSTOMER_ID__c = oldRec.FCU005P_CUSTOMER_ID__c;
            newRec.FCU005P_PARENT_ID__c = oldRec.FCU005P_PARENT_ID__c;
            newRec.FCU005P_INCENTIVE_ACC__c = oldRec.FCU005P_INCENTIVE_ACC__c;
            newRec.FCU005P_SALE_DETAIL_ACC__c = oldRec.FCU005P_SALE_DETAIL_ACC__c;
            newRec.Record_Updated__c = false;
        }
    }
}