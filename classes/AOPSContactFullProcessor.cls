public class AOPSContactFullProcessor implements Queueable {
  
    private List<String> contactIdList;
    private static Integer WEBUSER_BATCH_SIZE = 50;
    private static Integer SITECONTACT_BATCH_SIZE = 50;

    public AOPSContactFullProcessor(List<String> contactIdList) {
        this.contactIdList = contactIdList;
    }
    
    /**
     * The method executed when the job is started. Populates and upserts final staging records,
     * and updates the initial staging records by specifying they are no longer in the updated state.
     */
    public void execute(QueueableContext context) {
        Savepoint sp = Database.setSavepoint();
        try {            
            
			List<AOPS_STG_CONTACT_MASTER__c> masterInitRecList = getContactMasterList(contactIdList);
            AOPSContactMasterFinalProcessor masterProcessor = new AOPSContactMasterFinalProcessor(masterInitRecList);
            masterProcessor.process();
            
            List<AOPS_Contact_Email__c> emailInitRecList = getContactEmailList(contactIdList);
            AOPSContactEmailFinalProcessor emailProcessor = new AOPSContactEmailFinalProcessor(emailInitRecList);
            emailProcessor.process();
            
            List<AOPS_Contact_Phone__c> phoneInitRecList = getContactPhoneList(contactIdList);
            AOPSContactPhoneFinalProcessor phoneProcessor = new AOPSContactPhoneFinalProcessor(phoneInitRecList);
            phoneProcessor.process();
                        
            List<AOPS_Contact_Web_User__c> webUserInitRecList = getContactWebUserList(contactIdList);
            AOPSContactWebUserFinalProcessor webUserProcessor = new AOPSContactWebUserFinalProcessor(webUserInitRecList);
            webUserProcessor.process();
            
            List<AOPS_CONTACT_OPT_IN__c> optInInitRecList = getContactOptInList(contactIdList);
            AOPSContactOptInFinalProcessor optInProcessor = new AOPSContactOptInFinalProcessor(optInInitRecList);
          	optInProcessor.process();
                        
            List<AOPS_Contact_Ship_Address__c> contactShipToRecList = getContactShipToList(contactIdList);
            AOPSContactShipToFinalProcessor shipToProcessor = new AOPSContactShipToFinalProcessor(contactShipToRecList);
            shipToProcessor.process();

        } catch(Exception e) {
            Database.rollback(sp);
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
    }
    
    private List<AOPS_STG_CONTACT_MASTER__c> getContactMasterList(List<String> contactIdList) {
        List<AOPS_STG_CONTACT_MASTER__c> initialRecs = [SELECT Id, Unique_Record_ID__c, Record_Updated__c, CXTCNTM_TIMESTAMP__c, CCU300F_AUTH_BUYER_YN__c, CCU300F_BIRTHDAY__c,
            CCU300F_BRAND__c, CCU300F_CNT_SEQ__c, CCU300F_CONTACT_ID__c, CCU300F_CPY_PRIMARY_CONTACT__c, CCU300F_CREATE_BY__c, CCU300F_CREATE_DT__c, CCU300F_CUST_REQUEST_IND__c,
            CCU300F_CUSTOMER_ID__c, CCU300F_DESK_TOP__c, CCU300F_DFT_BILL_ADDR__c, CCU300F_DFT_MAIL_ADDR__c, CCU300F_DFT_SHIP_ADDR__c, CCU300F_INFO_SOURCE__c,
            CCU300F_LESS_MAIL__c, CCU300F_MID_INITIAL__c, CCU300F_NAME_1__c, CCU300F_NAME_2__c, CCU300F_PO_NBR__c, CCU300F_POLYBAG_FLAG__c, CCU300F_RELEASE_NBR__c,
            CCU300F_RENT_NAME_FLAG__c, CCU300F_ROLE_1__c, CCU300F_ROLE_2__c, CCU300F_RSV_10CHAR__c, CCU300F_RSV_10V2__c, CCU300F_RSV_1CHAR__c, CCU300F_RSV_2CHAR__c,
            CCU300F_RSV_4CHAR__c, CCU300F_SALUTATION__c, CCU300F_STATUS__c, CCU300F_TITLE__c, CCU300F_TYPE__c, CCU300F_UPDATE_BY__c, CCU300F_UPDATE_DT__c, CXTCNTM_ACTION__c,
            CXTCNTM_AOPS_KEY1__c, CXTCNTM_AOPS_KEY2__c, CXTCNTM_AOPS_KEY3__c, CXTCNTM_MSG_TYPE__c, CXTCNTM_REQ_ID__c, CXTCNTM_REQ_SOURCE__c, SYNC_STATUS_MESSAGE__c
            FROM AOPS_STG_CONTACT_MASTER__c WHERE Record_Updated__c = true and CCU300F_CONTACT_ID__c in :contactIdList];

        return initialRecs;
    }
    
    private List<AOPS_Contact_Email__c> getContactEmailList(List<String> contactIdList) {
        List<AOPS_Contact_Email__c> initialRecs = [SELECT Id, Unique_Record_ID__c, Record_Updated__c, CXTCNTE_TIMESTAMP__c, CCU340F_ADDRESS__c, CCU340F_ADDRESS_SEQ__c,
            CCU340F_CONTACT_DFT_INTERNET__c, CCU340F_CONTACT_ID__c, CCU340F_EMAIL_OUT_TYPE__c, CCU340F_INTERNET_TYPE__c, CCU340F_INVALID_ADDRESS__c, CCU340F_USER_ROLE__c,
            CXTCNTE_ACTION__c, CXTCNTE_AOPS_KEY1__c, CXTCNTE_AOPS_KEY2__c, CXTCNTE_AOPS_KEY3__c, SYNC_STATUS_MESSAGE__c
            FROM AOPS_Contact_Email__c WHERE Record_Updated__c = true and CCU340F_CONTACT_ID__c IN :contactIdList];
		return initialRecs;        
    }
    
    private List<AOPS_Contact_Phone__c> getContactPhoneList(List<String> contactIdList) {
        List<AOPS_Contact_Phone__c> initialRecs = [SELECT Id, Unique_Record_ID__c, Record_Updated__c, CCU320F_AREA_CODE__c, CCU320F_BRAND__c, CCU320F_CNTRY_CODE__c,
            CCU320F_CONTACT_DFT_NUMBER__c, CCU320F_CONTACT_ID__c, CCU320F_CUSTOMER_ID__c, CCU320F_EXTENSION__c, CCU320F_INVALID_PHONE__c, CCU320F_LESS_PHONE__c,
            CCU320F_NBR_TYPE__c, CCU320F_NUMBER__c, CCU320F_PHONE_SEQ__c, CCU320F_PREFIX__c, CXTCNTP_ACTION__c, CXTCNTP_AOPS_KEY1__c, CXTCNTP_AOPS_KEY2__c,
            CXTCNTP_AOPS_KEY3__c, CXTCNTP_MSG_TYPE__c, CXTCNTP_TIMESTAMP__c, SYNC_STATUS_MESSAGE__c
            FROM AOPS_Contact_Phone__c WHERE Record_Updated__c = true and CCU320F_CONTACT_ID__c IN :contactIdList];

        return initialRecs;
    }
    
    private List<AOPS_Contact_Web_User__c> getContactWebUserList(List<String> contactIdList) {
        list<sync_batch_setting__mdt> sbs= [SELECT Id, batch_size__c, delay_next_job__c from sync_batch_setting__mdt where DeveloperName='webuser' limit 1];
        if(sbs.size()>0) {
            WEBUSER_BATCH_SIZE = sbs[0].batch_size__c.intValue();
        }
        
        List<AOPS_Contact_Web_User__c> initialRecs = [SELECT Id, Unique_Record_ID__c, Record_Updated__c, CCS056F_CODE_AV__c, CCS056F_VALUE_AV__c, CCU300F_MID_INITIAL__c,
            CCU300F_NAME_1__c, CCU300F_NAME_2__c, CCU330F_AB_FLG__c, CCU330F_CONTACT_ID__c, CCU330F_CREATE_DT__c, CCU330F_CUSTOMER_ID__c, CCU330F_DEFAULT_POSTAL_CODE__c,
            CCU330F_LAST_VISIT_DATE__c, CCU330F_ORDER_OK_FLG__c, CCU330F_PASSWORD__c, CCU330F_USER_LOCKED_FLG__c, CCU330F_USER_SEQ__c, CCU330F_USER_TYPE__c, CCU330F_USERID__c,
            CCU340F_ADDRESS__c, CXTCNTW_ACTION__c, CXTCNTW_AOPS_KEY1__c, CXTCNTW_AOPS_KEY2__c, CXTCNTW_AOPS_KEY3__c, CXTCNTW_MSG_TYPE__c, CXTCNTW_TIMESTAMP__c, SYNC_STATUS_MESSAGE__c
            FROM AOPS_Contact_Web_User__c WHERE Record_Updated__c = true and CCU330F_CONTACT_ID__c IN :contactIdList LIMIT :WEBUSER_BATCH_SIZE];

        return initialRecs;
    }
    
    private List<AOPS_Contact_Ship_Address__c> getContactShipToList(List<String> contactIdList) {
        list<sync_batch_setting__mdt> sbs= [SELECT Id, batch_size__c, delay_next_job__c from sync_batch_setting__mdt where DeveloperName='sitecontact' limit 1];
        if(sbs.size()>0) {
            SITECONTACT_BATCH_SIZE = sbs[0].batch_size__c.intValue();
        }
        List<AOPS_Contact_Ship_Address__c> initialRecs = [SELECT Id, Unique_Record_ID__c, Record_Updated__c, CCU310F_ADDR_SEQ__c, CCU310F_ALLOW_BUY__c, CCU310F_BRAND__c,
            CCU310F_CONTACT_ID__c, CCU310F_CUSTOMER_ID__c, CCU310F_DFT_SHIP_CONT__c, CCU310F_UPDATE_BY__c, CCU310F_UPDATE_DT__c, CXTCNTS_ACTION__c, CXTCNTS_AOPS_KEY1__c,
            CXTCNTS_AOPS_KEY2__c, CXTCNTS_AOPS_KEY3__c, CXTCNTS_MSG_TYPE__c, CXTCNTS_TIMESTAMP__c, SYNC_STATUS_MESSAGE__c
            FROM AOPS_Contact_Ship_Address__c WHERE Record_Updated__c = true and CCU310F_CONTACT_ID__c IN :contactIdList LIMIT :SITECONTACT_BATCH_SIZE];

        return initialRecs;
    }

    private List<AOPS_CONTACT_OPT_IN__c> getContactOptInList(List<String> contactIdList) {
        List<AOPS_CONTACT_OPT_IN__c> initialRecs = [SELECT Id, Unique_Record_ID__c, Record_Updated__c, CCU380F_CONTACT_ID__c, CCU380F_CREATE_DATE__c, CCU380F_CREATE_ID__c,
            CCU380F_CUSTOMER_ID__c, CCU380F_FILLER1__c, CCU380F_FILLER2__c, CCU380F_FILLER3__c, CCU380F_FILLER4__c, CCU380F_FILLER5__c, CCU380F_OPT_IN__c,
            CCU380F_SEQUENCE_KEY__c, CCU380F_UPDATE_DATE__c, CCU380F_UPDATE_ID__c, CCU380F_VEHICLE_CODE__c, Create_Date__c, CXTCNTO_ACTION__c, CXTCNTO_AOPS_KEY1__c,
            CXTCNTO_AOPS_KEY2__c, CXTCNTO_AOPS_KEY3__c, CXTCNTO_TIMESTAMP__c, SYNC_STATUS_MESSAGE__c
            FROM AOPS_CONTACT_OPT_IN__c WHERE Record_Updated__c = true and CCU380F_CONTACT_ID__c IN :contactIdList];

        return initialRecs;
    }    
}