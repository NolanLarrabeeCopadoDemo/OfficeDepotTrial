public class AOPSContactWebUserFinalProcessor implements Queueable {

	// The initial staging records that will be used to populate the final staging records.
    private List<AOPS_Contact_Web_User__c> initialStagingRecs;
    private Map<String, Contact_Final_Staging__c> finalStagingMap;
    Map<String, String> syncFailedMessageMap;

    public AOPSContactWebUserFinalProcessor(List<AOPS_Contact_Web_User__c> initialStagingRecs) {
        this.initialStagingRecs = initialStagingRecs;
        this.finalStagingMap = new Map<String, Contact_Final_Staging__c>();
    }
    
    /**
     * The method executed when the job is started. Populates and upserts final staging records,
     * and updates the initial staging records by specifying they are no longer in the updated state.
     */
    public void execute(QueueableContext context) {
        process();
    }

    public void process() {
        Savepoint sp = Database.setSavepoint();
        try {
            populateFinalStagingMap();
            // Generate final staging records to be updated.
            for(AOPS_Contact_Web_User__c initialStagingRec : initialStagingRecs) {
                Contact_Final_Staging__c finalStagingRec = getPopulatedFinalStagingRec(initialStagingRec);
                finalStagingMap.put(finalStagingRec.AOPS_Contact_Number__c, finalStagingRec);
            }
            
            // Persist final staging record changes.
            Schema.SObjectField keyField = Contact_Final_Staging__c.Fields.Unique_Record_ID__c;
            List<Contact_Final_Staging__c> finalStagingRecs = finalStagingMap.values();
            List<Database.UpsertResult> upsertResults = Database.upsert(finalStagingRecs, keyField, false);

            List<Contact_Final_Staging__c> stageRecSuccessList = getSuccessfulStagingRecList(upsertResults, finalStagingRecs);
            List<Contact_Final_Staging__c> stageRecFailedList = getFailedStagingRecList(upsertResults, finalStagingRecs);
            markStagingRecordsWithSyncStatus(stageRecSuccessList, stageRecFailedList, initialStagingRecs);
        } catch(Exception e) {
            Database.rollback(sp);
            System.debug(e.getMessage());
            System.debug(e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    private void populateFinalStagingMap() {
        Set<String> contactNumbers = new Set<String>();
        for(AOPS_Contact_Web_User__c initialStagingRec : initialStagingRecs) {
            contactNumbers.add(initialStagingRec.CCU330F_CONTACT_ID__c);
        }
        
        List<Contact_Final_Staging__c> finalStagingRecs = [SELECT Id, AOPS_Contact_Number__c, AOPS_Account_Number__c, Unique_Record_ID__c, Web_User_Seq__c
                                                          FROM Contact_Final_Staging__c WHERE AOPS_Contact_Number__c IN: contactNumbers];
        for(Contact_Final_Staging__c finalStagingRec : finalStagingRecs) {
            finalStagingMap.put(finalStagingRec.AOPS_Contact_Number__c, finalStagingRec);
        }
    }

    /**
     * Generates a final staging record and populates it with data from the initial staging record.
    **/
    @TestVisible
    private Contact_Final_Staging__c getPopulatedFinalStagingRec(AOPS_Contact_Web_User__c initialStagingRec) {
        Contact_Final_Staging__c finalStagingRec = finalStagingMap.get(initialStagingRec.CCU330F_CONTACT_ID__c);
        if(finalStagingRec == null) finalStagingRec = new Contact_Final_Staging__c();

        finalStagingRec.AOPS_Contact_Number__c = initialStagingRec.CCU330F_CONTACT_ID__c;
        finalStagingRec.AOPS_Account_Number__c = initialStagingRec.CCU330F_CUSTOMER_ID__c.leftPad(8, '0');
        finalStagingRec.Unique_Record_ID__c = finalStagingRec.AOPS_Account_Number__c + finalStagingRec.AOPS_Contact_Number__c;

        if(initialStagingRec.CXTCNTW_ACTION__c == 'C' || initialStagingRec.CXTCNTW_ACTION__c == 'U') {
            finalStagingRec.Web_User_Seq__c = initialStagingRec.CXTCNTW_AOPS_KEY3__c;
            finalStagingRec.Web_User_Acct_Code__c = initialStagingRec.CCS056F_CODE_AV__c;
            finalStagingRec.Acct_Code_Value__c = initialStagingRec.CCS056F_VALUE_AV__c;
            finalStagingRec.Web_Username__c = initialStagingRec.CCU330F_USERID__c;
            finalStagingRec.User_Type__c = initialStagingRec.CCU330F_USER_TYPE__c;
            finalStagingRec.AB_Flag__c = initialStagingRec.CCU330F_AB_FLG__c;
            finalStagingRec.Default_Postal_Code__c = initialStagingRec.CCU330F_DEFAULT_POSTAL_CODE__c;
            if (String.isNotEmpty(initialStagingRec.CCU330F_LAST_VISIT_DATE__c)) {
                Date dt = Date.valueOf(initialStagingRec.CCU330F_LAST_VISIT_DATE__c);
                Date earliestSFDCDate = Date.newInstance(1700, 1, 1);
                if(dt > earliestSFDCDate) {
                    Datetime dtv = Date.valueOf(initialStagingRec.CCU330F_LAST_VISIT_DATE__c);
                    String convertedZone = dtv.format('yyyy-MM-dd HH:mm:ss', 'GMT');
                    finalStagingRec.Last_Website_Visit__c = Datetime.valueOf(convertedZone);
                }
            }
            /*
            if (initialStagingRec.CCU330F_CREATE_DT__c != null) {
                Datetime dt = Date.valueOf(initialStagingRec.CCU330F_CREATE_DT__c);
                String convertedZone = dt.format('yyyy-MM-dd HH:mm:ss', 'GMT');
                finalStagingRec.Legacy_CreatedDate__c = Datetime.valueOf(convertedZone);
            }*/
        } else if(initialStagingRec.CXTCNTW_ACTION__c == 'D') {
            finalStagingRec.Web_User_Seq__c = null;
            finalStagingRec.Web_User_Acct_Code__c = null;
            finalStagingRec.Acct_Code_Value__c = null;
            finalStagingRec.Web_Username__c = null;
            finalStagingRec.User_Type__c = null;
            finalStagingRec.AB_Flag__c = null;
            finalStagingRec.Default_Postal_Code__c = null;
            finalStagingRec.Last_Website_Visit__c = null;
            finalStagingRec.Legacy_CreatedDate__c = null;
        }

        finalStagingRec.Action__c = initialStagingRec.CXTCNTW_ACTION__c;
        
        finalStagingRec.Sync_Failed__c = false;
        finalStagingRec.Is_Contact_WebUser_Changed__c = true;
        
        return finalStagingRec;
    }
@TestVisible

    private List<Contact_Final_Staging__c> getSuccessfulStagingRecList(Database.UpsertResult[] upsertResultList, List<Contact_Final_Staging__c> finalStageRecList) {
        
        List<Contact_Final_Staging__c> successStageRecList = new List<Contact_Final_Staging__c>();
        for(Integer i=0; i < upsertResultList.size(); i++) {
            if(upsertResultList[i].isSuccess()) {
                successStageRecList.add(finalStageRecList[i]);
            }            
        }
        return successStageRecList;
    }
    @TestVisible

    private List<Contact_Final_Staging__c> getFailedStagingRecList(Database.UpsertResult[] upsertResultList, List<Contact_Final_Staging__c> finalStageRecList) {
        
        List<Contact_Final_Staging__c> failedStageRecList = new List<Contact_Final_Staging__c>();
        syncFailedMessageMap = new Map<String,String>();
        
        for(Integer i=0; i < upsertResultList.size(); i++) {
            if(!upsertResultList[i].isSuccess()) {
                failedStageRecList.add(finalStageRecList[i]);
            }
            String message = '';
            if(!upsertResultList[i].isSuccess()) {
                Database.Error[] errors = upsertResultList[i].getErrors();
                for (Database.Error err : errors) {
                    message = message + ':' + err.statuscode + ':' + err.message;
                }
                syncFailedMessageMap.put(finalStageRecList[i].AOPS_Contact_Number__c, message);
            }
        }
        return failedStageRecList;
    }
    @TestVisible

    private void markStagingRecordsWithSyncStatus(List<Contact_Final_Staging__c> successList, List<Contact_Final_Staging__c> failedList, List<AOPS_Contact_Web_User__c> syncedStagingRecList) {
        
        Map<String, AOPS_Contact_Web_User__c> syncedStagingRecMap = new Map<String, AOPS_Contact_Web_User__c>();
        Map<String, List<AOPS_Contact_Web_User__c>> initialStageRecsSplitMap = splitInitialStageRecs(syncedStagingRecList);
        
        for (AOPS_Contact_Web_User__c afs : syncedStagingRecList) {
            syncedStagingRecMap.put(afs.CCU330F_CONTACT_ID__c, afs);
        }
        
        List<AOPS_Contact_Web_User__c> clonedRecords = new List<AOPS_Contact_Web_User__c>();
        
        for(Contact_Final_Staging__c finalStageRec : successList) {
            List<AOPS_Contact_Web_User__c> initStageRecList = initialStageRecsSplitMap.get(finalStageRec.AOPS_Contact_Number__c);
            for (AOPS_Contact_Web_User__c initStageRec : initStageRecList) {
                AOPS_Contact_Web_User__c clonedRecord = new AOPS_Contact_Web_User__c(Id=initStageRec.Id);
                clonedRecord.Record_Updated__c = false;
                clonedRecord.Sync_Status_Message__c = 'Success';
                clonedRecords.add(clonedRecord);
            }
        }
        
        for(Contact_Final_Staging__c finalStageRec : failedList) {
            List<AOPS_Contact_Web_User__c> initStageRecList = initialStageRecsSplitMap.get(finalStageRec.AOPS_Contact_Number__c);
            for (AOPS_Contact_Web_User__c initStageRec : initStageRecList) {
                AOPS_Contact_Web_User__c clonedRecord = new AOPS_Contact_Web_User__c(Id=initStageRec.Id);
                String errorMsg = syncFailedMessageMap.get(initStageRec.CCU330F_CONTACT_ID__c);
                if (String.isNotEmpty(errorMsg) && errorMsg.contains('UNABLE_TO_LOCK_ROW')) {
                    clonedRecord.Record_Updated__c = true; // Retry for the lock.
                } else {
                    clonedRecord.Record_Updated__c = false; // This is to avoid recursive processing. If there is an issue, do not process the same data recursively.
                }
                clonedRecord.Sync_Status_Message__c = errorMsg;
                clonedRecords.add(clonedRecord);
            }
        }
        
        update clonedRecords;
    }
@TestVisible

    private Map<String, List<AOPS_Contact_Web_User__c>> splitInitialStageRecs(List<AOPS_Contact_Web_User__c> syncedStagingRecList) {
        
        Map<String, List<AOPS_Contact_Web_User__c>> splitInitStageRecsMap = new Map<String, List<AOPS_Contact_Web_User__c>>();
        
        for (AOPS_Contact_Web_User__c initStageRec : syncedStagingRecList) {
            List<AOPS_Contact_Web_User__c> stageRecList = splitInitStageRecsMap.get(initStageRec.CCU330F_CONTACT_ID__c);
            if (stageRecList == null) {
                stageRecList = new List<AOPS_Contact_Web_User__c>();
                splitInitStageRecsMap.put(initStageRec.CCU330F_CONTACT_ID__c, stageRecList);
            }
            stageRecList.add(initStageRec);
        }
        return splitInitStageRecsMap;
    }
}