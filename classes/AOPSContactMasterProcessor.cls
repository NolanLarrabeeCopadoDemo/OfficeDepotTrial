public class AOPSContactMasterProcessor {

    public static boolean process(Map<String,Object> aopsDataMap) {
        
        if (aopsDataMap == null) {
            return false;
        }
        AOPS_STG_CONTACT_MASTER__c contactMaster = new AOPS_STG_CONTACT_MASTER__c();
        populateObject(aopsDataMap, contactMaster);
        
        Schema.SObjectField uniqueField = AOPS_STG_CONTACT_MASTER__c.Fields.Unique_Record_ID__c;                
        Database.UpsertResult upsertResult = Database.upsert(contactMaster, uniqueField, false);
        return upsertResult.isSuccess();
    }
    
    private static void populateObject(Map<String,Object> source, AOPS_STG_CONTACT_MASTER__c target) {
        
        String uniqueKey = String.valueOf(Integer.valueOf((String)source.get('CXTCNTM_AOPS_KEY1'))) +
            String.valueOf(Integer.valueOf((String)source.get('CXTCNTM_AOPS_KEY2')));
        target.Unique_Record_ID__c = uniqueKey;
        target.CXTCNTM_ACTION__c = (String) source.get('CXTCNTM_ACTION');
        target.CCU300F_AUTH_BUYER_YN__c = (String) source.get('CCU300F_AUTH_BUYER_YN');
        target.CCU300F_CONTACT_ID__c = String.valueOf(Integer.valueOf((String)source.get('CCU300F_CONTACT_ID')));
        target.CCU300F_CUSTOMER_ID__c = (String) source.get('CCU300F_CUSTOMER_ID');//
        target.CCU300F_DFT_BILL_ADDR__c = (String) source.get('CCU300F_DFT_BILL_ADDR');//
        target.CCU300F_CNT_SEQ__c = (String) source.get('CCU300F_CNT_SEQ__c');//
        target.CCU300F_DFT_SHIP_ADDR__c = (String) source.get('CCU300F_DFT_SHIP_ADDR');
        target.CCU300F_DFT_MAIL_ADDR__c = (String) source.get('CCU300F_DFT_MAIL_ADDR');
        target.CCU300F_BRAND__c = (String) source.get('CCU300F_BRAND');
        target.CCU300F_NAME_1__c = (String) source.get('CCU300F_NAME_1');
        target.CCU300F_NAME_2__c = (String) source.get('CCU300F_NAME_2');
        String midInitial = (String) source.get('CCU300F_MID_INITIAL');
        if (midInitial != null && midInitial.length() > 0) {
            target.CCU300F_MID_INITIAL__c = midInitial.substring(0, 1);
        }        
        target.CCU300F_SALUTATION__c = (String) source.get('CCU300F_SALUTATION');
        target.CCU300F_TYPE__c = (String) source.get('CCU300F_TYPE');
        target.CCU300F_BIRTHDAY__c = (String) source.get('CCU300F_BIRTHDAY');
        target.CCU300F_STATUS__c = (String) source.get('CCU300F_STATUS');
        target.CCU300F_CPY_PRIMARY_CONTACT__c = (String) source.get('CCU300F_CPY_PRIMARY_CONTACT');
        target.CCU300F_TITLE__c = (String) source.get('CCU300F_TITLE');
        target.CCU300F_ROLE_1__c = (String) source.get('CCU300F_ROLE_1');
        target.CCU300F_ROLE_2__c = (String) source.get('CCU300F_ROLE_2');
        target.CCU300F_AUTH_BUYER_YN__c = (String) source.get('CCU300F_AUTH_BUYER_YN');
        target.CCU300F_PO_NBR__c = (String) source.get('CCU300F_PO_NBR');
        target.CCU300F_RELEASE_NBR__c = (String) source.get('CCU300F_RELEASE_NBR');
        target.CCU300F_DESK_TOP__c = (String) source.get('CCU300F_DESK_TOP__c');
        target.CCU300F_CUST_REQUEST_IND__c = (String) source.get('CCU300F_CUST_REQUEST_IND');
        target.CCU300F_LESS_MAIL__c = (String) source.get('CCU300F_LESS_MAIL');
        target.CCU300F_RENT_NAME_FLAG__c = (String) source.get('CCU300F_RENT_NAME_FLAG');
        target.CCU300F_POLYBAG_FLAG__c = (String) source.get('CCU300F_POLYBAG_FLAG');
        target.CCU300F_RSV_1CHAR__c = (String) source.get('CCU300F_RSV_1CHAR');
        target.CCU300F_RSV_2CHAR__c = (String) source.get('CCU300F_RSV_2CHAR');    
        target.CXTCNTM_TIMESTAMP__c = (String) source.get('CXTCNTM_TIMESTAMP');

        String createdDate = (String) source.get('CCU300F_CREATE_DT');
        
        Integer year = Integer.valueOf(createdDate.split('-').get(0));
        Integer month = Integer.valueOf(createdDate.split('-').get(1));
        Integer day = Integer.valueOf(createdDate.split('-').get(2));
        Date d = Date.newInstance(year, month, day);

        target.CCU300F_CREATE_DT__c = d;
        target.SYNC_STATUS_MESSAGE__c = '';
        // Specify that the record has been updated. Note that this will be reset
        // to false in a trigger if the request is not the most recent one.
        target.Record_Updated__c = true;
    }
}