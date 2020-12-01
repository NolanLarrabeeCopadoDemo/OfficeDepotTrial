public class AOPSContactEmailProcessor {        
     public static boolean process(Map<String,Object> aopsDataMap) {    
        if (aopsDataMap == null) {
            return false;
        }
        AOPS_CONTACT_EMAIL__c contactOptIn = new AOPS_CONTACT_EMAIL__c();
        populateObject(aopsDataMap, contactOptIn);
        
        Schema.SObjectField uniqueField = AOPS_CONTACT_EMAIL__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(contactOptIn, uniqueField, false);
        return upsertResult.isSuccess();
    }
        
    private static void populateObject(Map<String,Object> source, AOPS_CONTACT_EMAIL__c target) {
            
        target.Unique_Record_ID__c = String.valueOf(Integer.valueOf((String)source.get('CXTCNTE_AOPS_KEY1'))) + 
                            String.valueOf(Integer.valueOf((String)source.get('CXTCNTE_AOPS_KEY2')) + 
                            String.valueOf(Integer.valueOf((String)source.get('CXTCNTE_AOPS_KEY3'))));
        target.CXTCNTE_AOPS_KEY1__c = String.valueOf(Integer.valueOf((String)source.get('CXTCNTE_AOPS_KEY1')));
        target.CXTCNTE_TIMESTAMP__c = (String) source.get('CXTCNTE_TIMESTAMP');  
        target.CXTCNTE_ACTION__c = (String) source.get('CXTCNTE_ACTION');    
        target.CCU340F_ADDRESS_SEQ__c = String.valueOf(Integer.valueOf((String)source.get('CCU340F_ADDRESS_SEQ')));
        target.CCU340F_CONTACT_ID__c = String.valueOf(Integer.valueOf((String) source.get('CCU340F_CONTACT_ID')));
        target.CCU340F_INTERNET_TYPE__c = (String) source.get('CCU340F_INTERNET_TYPE'); 
        target.CCU340F_ADDRESS__c = (String) source.get('CCU340F_ADDRESS');
        target.CCU340F_CONTACT_DFT_INTERNET__c = (String) source.get('CCU340F_CONTACT_DFT_INTERNET'); 
        target.CCU340F_USER_ROLE__c = (String) source.get('CCU340F_USER_ROLE');
        target.CCU340F_INVALID_ADDRESS__c = (String) source.get('CCU340F_INVALID_ADDRESS');
        target.CCU340F_EMAIL_OUT_TYPE__c = (String) source.get('CCU340F_EMAIL_OUT_TYPE');
        target.SYNC_STATUS_MESSAGE__c = '';
        // Specify that the record has been updated. Note that this will be reset
        // to false in a trigger if the request is not the most recent one.
        target.Record_Updated__c = true;
    }
}