public class AOPSContactOptInFinalProcessor implements Queueable {

    // The initial staging records that will be used to populate the final staging records.
    private List<AOPS_CONTACT_OPT_IN__c> initialStagingRecs;
    private Map<String, Contact_Final_Staging__c> finalStagingMap;
    Map<String, String> syncFailedMessageMap;

    public AOPSContactOptInFinalProcessor(List<AOPS_CONTACT_OPT_IN__c> initialStagingRecs) {
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
            // Populate the variable finalStagingMap.
            populateFinalStagingMap();
            // Generate final staging records to be updated.
            for(AOPS_CONTACT_OPT_IN__c initialStagingRec : initialStagingRecs) {
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
            System.debug(e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    /**
     * Populates the map of final staging records, Key: Unique_Record_ID__c, Value: the record.
     */
    private void populateFinalStagingMap() {
        Set<String> contactNumbers = new Set<String>();
        for(AOPS_CONTACT_OPT_IN__c initialStagingRec : initialStagingRecs) {
            contactNumbers.add(initialStagingRec.CCU380F_CONTACT_ID__c);
        }

        List<Contact_Final_Staging__c> finalStagingRecs = [SELECT Unique_Record_Id__c, AOPS_Contact_Number__c, Phone1_Type__c, Phone2_Type__c, Phone3_Type__c,
                                                    E_OptIn1__c, E_OptIn2__c, E_OptIn3__c from contact_final_staging__c where AOPS_Contact_Number__c IN: contactNumbers  ];
        for(Contact_Final_Staging__c finalStagingRec : finalStagingRecs) {
            finalStagingMap.put(finalStagingRec.AOPS_Contact_Number__c, finalStagingRec);
        }
    }

    /**
     * Generates a final staging record and populates it with data from the initial staging record.
    **/
    @TestVisible

    private Contact_Final_Staging__c getPopulatedFinalStagingRec(AOPS_CONTACT_OPT_IN__c initialStagingRec) {
        
        Contact_Final_Staging__c finalStagingRec = finalStagingMap.get(initialStagingRec.CCU380F_CONTACT_ID__c);
        if (finalStagingRec == null) {
            finalStagingRec = new Contact_Final_Staging__c();
            finalStagingRec.AOPS_Contact_Number__c = initialStagingRec.CCU380F_CONTACT_ID__c;
            finalStagingRec.AOPS_Account_Number__c = initialStagingRec.CCU380F_CUSTOMER_ID__c.leftPad(8, '0');
            finalStagingRec.Unique_Record_ID__c = finalStagingRec.AOPS_Account_Number__c + finalStagingRec.AOPS_Contact_Number__c;
        }
        
        String vehicleCode = initialStagingRec.CXTCNTO_AOPS_KEY3__c;
        String optInFlag = initialStagingRec.CCU380F_OPT_IN__c;
        Datetime chdt =AOPSSFDCFieldConversion.convertTimestamp(initialStagingRec.CXTCNTO_TIMESTAMP__c);
        // If the diff between update time and change time stamp is >48 hours, then use update date to fix the data conversion time issue.
        if(initialStagingRec.CCU380F_UPDATE_DATE__c != null)
        {
            Datetime updt = Date.valueOf(initialStagingRec.CCU380F_UPDATE_DATE__c);
            String convertedZone = updt.format('yyyy-MM-dd HH:mm:ss', 'GMT');
            Datetime updtfrmt = Datetime.valueOf(convertedZone);
            Long updtfrmtTime = updtfrmt.getTime();
            Long chdtTime= chdt.getTime();
            Long timediff = (chdtTime- updtfrmtTime)/(1000*60*60) ;
            if(timediff>48)
            {
                Date earliestSFDCDate = Date.newInstance(1700, 1, 1);
                if(updtfrmt > earliestSFDCDate) {
                    chdt = updtfrmt;
                }
            }
        }
            
        
        if (vehicleCode == 'MB') { // Mobile
            if(initialStagingRec.CXTCNTO_ACTION__c == 'D') {
                finalStagingRec.M_OptIn1__c = null;
                finalStagingRec.M_OptIn2__c = null;
                finalStagingRec.M_OptIn3__c = null;
            } else {
                finalStagingRec.M_OptIn1__c = optInFlag;
                finalStagingRec.M_OptIn2__c = optInFlag;
                finalStagingRec.M_OptIn3__c = optInFlag;
                finalStagingRec.Mobile_OptIn_Change_Timestamp__c = chdt ;
            }
        } else if (vehicleCode == 'PH') { // Phone
            if(initialStagingRec.CXTCNTO_ACTION__c == 'D') {
                finalStagingRec.P_OptIn1__c = null;
                finalStagingRec.P_OptIn2__c = null;
                finalStagingRec.P_OptIn3__c = null;
            } else {
                finalStagingRec.P_OptIn1__c = optInFlag;
                finalStagingRec.P_OptIn2__c = optInFlag;
                finalStagingRec.P_OptIn3__c = optInFlag;
                finalStagingRec.Phone_OptIn_Change_Timestamp__c = chdt ;
            }
        } else if (vehicleCode == 'ML') { // Mailing address
            if(initialStagingRec.CXTCNTO_ACTION__c == 'D') {               
                finalStagingRec.Mail_OptIn__c = null;
            } else {
                finalStagingRec.Mail_OptIn__c = optInFlag;    
                finalStagingRec.Mail_OptIn_Change_Timestamp__c = chdt ;            
            }
        } else if (vehicleCode == 'EM') { // Email
            if(initialStagingRec.CXTCNTO_ACTION__c == 'D') {
                finalStagingRec.E_OptIn1__c = null;
                finalStagingRec.E_OptIn2__c = null;
                finalStagingRec.E_OptIn3__c = null;
            } else {
                finalStagingRec.E_OptIn1__c = optInFlag;
                finalStagingRec.E_OptIn2__c = optInFlag;
                finalStagingRec.E_OptIn3__c = optInFlag;
                finalStagingRec.Email_OptIn_Change_Timestamp__c = chdt ;
                
            }
        }
        
        //finalStagingRec.OptIn_Change_Timestamp__c = AOPSSFDCFieldConversion.convertTimestamp(initialStagingRec.CXTCNTO_TIMESTAMP__c);
        finalStagingRec.Action__c = initialStagingRec.CXTCNTO_ACTION__c;
        finalStagingRec.Sync_Failed__c = false;
        finalStagingRec.Is_Contact_OptIn_Changed__c = true;
        
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

    private void markStagingRecordsWithSyncStatus(List<Contact_Final_Staging__c> successList, List<Contact_Final_Staging__c> failedList, List<AOPS_CONTACT_OPT_IN__c> syncedStagingRecList) {
        
        Map<String, AOPS_CONTACT_OPT_IN__c> syncedStagingRecMap = new Map<String, AOPS_CONTACT_OPT_IN__c>();                
        Map<String, List<AOPS_CONTACT_OPT_IN__c>> initialStageRecsSplitMap = splitInitialStageRecs(syncedStagingRecList);
        
        List<AOPS_CONTACT_OPT_IN__c> clonedRecords = new List<AOPS_CONTACT_OPT_IN__c>();
        
        for(Contact_Final_Staging__c finalStageRec : successList) {
            List<AOPS_CONTACT_OPT_IN__c> initStageRecList = initialStageRecsSplitMap.get(finalStageRec.AOPS_Contact_Number__c);
            for (AOPS_CONTACT_OPT_IN__c initStageRec : initStageRecList) {
                AOPS_CONTACT_OPT_IN__c clonedRecord = new AOPS_CONTACT_OPT_IN__c(Id=initStageRec.Id);
                clonedRecord.Record_Updated__c = false;
                clonedRecord.Sync_Status_Message__c = 'Success';
                clonedRecords.add(clonedRecord);
            }
        }
        String errorMsg = '';
        for(Contact_Final_Staging__c finalStageRec : failedList) {
            List<AOPS_CONTACT_OPT_IN__c> initStageRecList = initialStageRecsSplitMap.get(finalStageRec.AOPS_Contact_Number__c);
            for (AOPS_CONTACT_OPT_IN__c initStageRec : initStageRecList) {
                AOPS_CONTACT_OPT_IN__c clonedRecord = new AOPS_CONTACT_OPT_IN__c(Id=initStageRec.Id);
                errorMsg = syncFailedMessageMap.get(initStageRec.CCU380F_CONTACT_ID__c);
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

    private Map<String, List<AOPS_CONTACT_OPT_IN__c>> splitInitialStageRecs(List<AOPS_CONTACT_OPT_IN__c> syncedStagingRecList) {
        
        Map<String, List<AOPS_CONTACT_OPT_IN__c>> splitInitStageRecsMap = new Map<String, List<AOPS_CONTACT_OPT_IN__c>>();
        
        for (AOPS_CONTACT_OPT_IN__c initStageRec : syncedStagingRecList) {
            List<AOPS_CONTACT_OPT_IN__c> stageRecList = splitInitStageRecsMap.get(initStageRec.CCU380F_CONTACT_ID__c);
            if (stageRecList == null) {
                stageRecList = new List<AOPS_CONTACT_OPT_IN__c>();
                splitInitStageRecsMap.put(initStageRec.CCU380F_CONTACT_ID__c, stageRecList);
            }
            stageRecList.add(initStageRec);
        }
        return splitInitStageRecsMap;
    }
}