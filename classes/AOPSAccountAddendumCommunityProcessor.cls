public class AOPSAccountAddendumCommunityProcessor {
    
    public static boolean process(Map<String,Object> aopsDataMap) {
        
        if (aopsDataMap == null) {
            return false;
        }
        AOPS_Account_Addendum_Community__c accountCommunity = new AOPS_Account_Addendum_Community__c();
        populateObject(aopsDataMap, accountCommunity);
        
        Schema.SObjectField uniqueField = AOPS_Account_Addendum_Community__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(accountCommunity, uniqueField, false);
        return upsertResult.isSuccess();
    }
    
    private static void populateObject(Map<String,Object> source, AOPS_Account_Addendum_Community__c target) {
        
        String aopsCustId = (String) source.get('CXTC043F_AOPS_KEY1');
        aopsCustId = String.valueOf(Integer.valueOf(aopsCustId));
        target.Unique_Record_ID__c = aopsCustId;
        target.CXTC043F_MSG_TYPE__c = (String) source.get('CXTC043F_MSG_TYPE');
        target.CXTC043F_AOPS_KEY1__c = aopsCustId;
        target.CXTC043F_AOPS_KEY2__c = (String) source.get('CXTC043F_AOPS_KEY2');
        target.CXTC043F_AOPS_KEY3__c = (String) source.get('CXTC043F_AOPS_KEY3');
        target.CXTC043F_TIMESTAMP__c = (String) source.get('CXTC043F_TIMESTAMP');
        target.CXTC043F_ACTION__c = (String) source.get('CXTC043F_ACTION');
        target.CCU043F_AECUST__c = aopsCustId;
        target.CCU043F_AECD01__c = (String) source.get('CCU043F_AECD01');
        target.CCU043F_AECD02__c = (String) source.get('CCU043F_AECD02');
        target.CCU043F_AECD03__c = (String) source.get('CCU043F_AECD03');
        target.CCU043F_AECD04__c = (String) source.get('CCU043F_AECD04');
        target.CCU043F_AECD05__c = (String) source.get('CCU043F_AECD05');
        target.CCU043F_AECD06__c = (String) source.get('CCU043F_AECD06');
        target.CCU043F_AECD07__c = (String) source.get('CCU043F_AECD07');
        target.CCU043F_AECD08__c = (String) source.get('CCU043F_AECD08');
        target.CCU043F_AECD09__c = (String) source.get('CCU043F_AECD09');
        target.CCU043F_AECD10__c = (String) source.get('CCU043F_AECD10');
        target.CCU043F_AECD11__c = (String) source.get('CCU043F_AECD11');
        target.CCU043F_AECD12__c = (String) source.get('CCU043F_AECD12');
        target.CCU043F_AECD13__c = (String) source.get('CCU043F_AECD13');
        target.CCU043F_AECD14__c = (String) source.get('CCU043F_AECD14');
        target.CCU043F_AECD15__c = (String) source.get('CCU043F_AECD15');
        target.CCU043F_AECD16__c = (String) source.get('CCU043F_AECD16');
        target.CCU043F_AECD17__c = (String) source.get('CCU043F_AECD17');
        target.CCU043F_AECD18__c = (String) source.get('CCU043F_AECD18');
        target.CCU043F_AECD19__c = (String) source.get('CCU043F_AECD19');
        target.CCU043F_AECD20__c = (String) source.get('CCU043F_AECD20');
        target.CCU043F_AECD55__c = (String) source.get('CCU043F_AECD55');
        target.CCU043F_AECD44__c = (String) source.get('CCU043F_AECD44');
        target.CCU043F_AECD33__c = (String) source.get('CCU043F_AECD33');
        target.CCU043F_AECD22__c = (String) source.get('CCU043F_AECD22');
        target.CCU043F_AECDCO1__c = (String) source.get('CCU043F_AECDCO1');
        target.CCU043F_AECDCO2__c = (String) source.get('CCU043F_AECDCO2');
        target.CCU043F_AENM01__c = (String) source.get('CCU043F_AENM01');
        target.CCU043F_AENM02__c = (String) source.get('CCU043F_AENM02');
        target.CCU043F_AENM03__c = (String) source.get('CCU043F_AENM03');
        target.CCU043F_AENM04__c = (String) source.get('CCU043F_AENM04');
        target.CCU043F_AENM05__c = (String) source.get('CCU043F_AENM05');
        target.CCU043F_AENM06__c = (String) source.get('CCU043F_AENM06');
        target.CCU043F_AENM07__c = (String) source.get('CCU043F_AENM07');
        target.CCU043F_AENM08__c = (String) source.get('CCU043F_AENM08');
        target.CCU043F_AENM09__c = (String) source.get('CCU043F_AENM09');
        target.CCU043F_AENM10__c = (String) source.get('CCU043F_AENM10');
        target.CCU043F_AEUD__c = (String) source.get('CCU043F_AEUD');
        target.CCU043F_AEUU__c = (String) source.get('CCU043F_AEUU');
        target.SYNC_STATUS_MESSAGE__c = '';
        // Specify that the record has been updated. Note that this will be reset
        // to false in a trigger if the request is not the most recent one.
        target.Record_Updated__c = true;
    }
}