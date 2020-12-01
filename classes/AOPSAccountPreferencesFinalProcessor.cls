public class AOPSAccountPreferencesFinalProcessor implements Queueable {

	// The initial staging records that will be used to populate the final staging records.
    private List<AOPS_Account_Preferences__c> initialStagingRecs;
    private Map<String, Account_Final_Staging__c> finalStagingMap;
    Map<String, String> syncFailedMessageMap;

    public AOPSAccountPreferencesFinalProcessor(List<AOPS_Account_Preferences__c> initialStagingRecs) {
        this.initialStagingRecs = initialStagingRecs;
        this.finalStagingMap = new Map<String, Account_Final_Staging__c>();
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
            for(AOPS_Account_Preferences__c initialStagingRec : initialStagingRecs) {
                Account_Final_Staging__c finalStagingRec = getPopulatedFinalStagingRec(initialStagingRec);
                finalStagingMap.put(finalStagingRec.AOPS_Cust_ID__c, finalStagingRec);
            }
            
            // Persist final staging record changes.
            Schema.SObjectField keyField = Account_Final_Staging__c.Fields.AOPS_Cust_Id__c;
            List<Account_Final_Staging__c> finalStagingRecs = finalStagingMap.values();
            List<Database.UpsertResult> upsertResults = Database.upsert(finalStagingRecs, keyField, false);
            
            List<Account_Final_Staging__c> stageRecSuccessList = getSuccessfulStagingRecList(upsertResults, finalStagingRecs);
            List<Account_Final_Staging__c> stageRecFailedList = getFailedStagingRecList(upsertResults, finalStagingRecs);
            markStagingRecordsWithSyncStatus(stageRecSuccessList, stageRecFailedList, initialStagingRecs);
        } catch(Exception e) {
            Database.rollback(sp);
            System.debug(e.getStackTraceString());
        }
    }

    private void populateFinalStagingMap() {
        Set<String> accountNumbers = new Set<String>();
        for(AOPS_Account_Preferences__c initialStagingRec : initialStagingRecs)
            accountNumbers.add(initialStagingRec.FCU370P_CUSTOMER_ID__c.leftPad(8, '0'));
        
        List<Account_Final_Staging__c> finalStagingRecs = [SELECT Id, AOPS_Cust_ID__c
                                                          FROM Account_Final_Staging__c WHERE AOPS_Cust_ID__c IN: accountNumbers];
        for(Account_Final_Staging__c finalStagingRec : finalStagingRecs)
            finalStagingMap.put(finalStagingRec.AOPS_Cust_Id__c, finalStagingRec);
    }

    /**
     * Generates a final staging record and populates it with data from the initial staging record.
    **/
    private Account_Final_Staging__c getPopulatedFinalStagingRec(AOPS_Account_Preferences__c initialStagingRec) {
        Account_Final_Staging__c finalStagingRec = finalStagingMap.get(initialStagingRec.FCU370P_CUSTOMER_ID__c.leftPad(8, '0'));
		if(finalStagingRec == null) finalStagingRec = new Account_Final_Staging__c();
        finalStagingRec.AOPS_Cust_Id__c = initialStagingRec.FCU370P_CUSTOMER_ID__c.leftPad(8, '0');
        finalStagingRec.Action__c = initialStagingRec.CXTF370P_ACTION__c;
		String vehicleCode = initialStagingRec.FCU370P_VEHICLE_CODE__c;
        String optInFlag = initialStagingRec.FCU370P_ENABLE_CNT_OPTIN__c;
        
        if (vehicleCode == 'MB') { // Mobile
            if(initialStagingRec.CXTF370P_ACTION__c == 'D')
                finalStagingRec.Mobile_Opt_In__c = null;
            else
                finalStagingRec.Mobile_Opt_In__c = optInFlag;
        } else if (vehicleCode == 'PH') { // Phone
            if(initialStagingRec.CXTF370P_ACTION__c == 'D')
                finalStagingRec.Phone_Opt_In__c = null;
            else
                finalStagingRec.Phone_Opt_In__c = optInFlag;       
        } else if (vehicleCode == 'ML') { // Mailing address
            if(initialStagingRec.CXTF370P_ACTION__c == 'D')
                finalStagingRec.Mail_Opt_In__c = null;
            else
			    finalStagingRec.Mail_Opt_In__c = optInFlag;          
        } else if (vehicleCode == 'EM') { // Email
            if(initialStagingRec.CXTF370P_ACTION__c == 'D')
                finalStagingRec.Email_Opt_In__c = null;
            else
                finalStagingRec.Email_Opt_In__c = optInFlag;
        }
        finalStagingRec.OptIn_Change_Timestamp__c = AOPSSFDCFieldConversion.convertTimestamp(initialStagingRec.CXTF370P_TIMESTAMP__c);
        finalStagingRec.Sync_Failed__c = false;
        finalStagingRec.Is_Account_OptIn_Changed__c = true;
        
        return finalStagingRec;
    }
    
    private List<Account_Final_Staging__c> getSuccessfulStagingRecList(Database.UpsertResult[] upsertResultList, List<Account_Final_Staging__c> finalStageRecList) {
        
        List<Account_Final_Staging__c> successStageRecList = new List<Account_Final_Staging__c>();
        for(Integer i=0; i < upsertResultList.size(); i++) {
            if(upsertResultList[i].isSuccess()) {
                successStageRecList.add(finalStageRecList[i]);
            }            
        }
        return successStageRecList;
    }
    
    private List<Account_Final_Staging__c> getFailedStagingRecList(Database.UpsertResult[] upsertResultList, List<Account_Final_Staging__c> finalStageRecList) {
        
        List<Account_Final_Staging__c> failedStageRecList = new List<Account_Final_Staging__c>();
        syncFailedMessageMap = new Map<String,String>();
        
        String message;
        for(Integer i=0; i < upsertResultList.size(); i++) {
            if(!upsertResultList[i].isSuccess()) {
                failedStageRecList.add(finalStageRecList[i]);
            }
            message = '';
            if(!upsertResultList[i].isSuccess()) {
                Database.Error[] errors = upsertResultList[i].getErrors();
                for (Database.Error err : errors) {
                    message = message + ':' + err.statuscode + ':' + err.message;
                }
                syncFailedMessageMap.put(finalStageRecList[i].AOPS_Cust_Id__c, message);
            }
        }
        return failedStageRecList;
    }
    
    private void markStagingRecordsWithSyncStatus(List<Account_Final_Staging__c> successList, List<Account_Final_Staging__c> failedList, List<AOPS_Account_Preferences__c> syncedStagingRecList) {
        
        Map<String, AOPS_Account_Preferences__c> syncedStagingRecMap = new Map<String, AOPS_Account_Preferences__c>();
        Map<String, List<AOPS_Account_Preferences__c>> initialStageRecsSplitMap = splitInitialStageRecs(syncedStagingRecList);
        
        for (AOPS_Account_Preferences__c afs : syncedStagingRecList) {
            syncedStagingRecMap.put(afs.FCU370P_CUSTOMER_ID__c.leftPad(8, '0'), afs);
        }
        
        List<AOPS_Account_Preferences__c> clonedRecords = new List<AOPS_Account_Preferences__c>();
        
        for(Account_Final_Staging__c finalStageRec : successList) {
            List<AOPS_Account_Preferences__c> initStageRecList = initialStageRecsSplitMap.get(finalStageRec.AOPS_Cust_ID__c);
            for(AOPS_Account_Preferences__c stagingRec : initStageRecList) {
                AOPS_Account_Preferences__c clonedRecord = new AOPS_Account_Preferences__c(Id=stagingRec.Id);
                clonedRecord.Record_Updated__c = false;
                clonedRecord.Sync_Status_Message__c = 'Success';
                clonedRecords.add(clonedRecord);
            }
        }
        String errorMsg = '';
        for(Account_Final_Staging__c finalStageRec : failedList) {
            List<AOPS_Account_Preferences__c> initStageRecList = initialStageRecsSplitMap.get(finalStageRec.AOPS_Cust_ID__c);
            for(AOPS_Account_Preferences__c stagingRec : initStageRecList) {
                AOPS_Account_Preferences__c clonedRecord = new AOPS_Account_Preferences__c(Id=stagingRec.Id);
                errorMsg = syncFailedMessageMap.get(finalStageRec.AOPS_Cust_Id__c);
                if (String.isNotEmpty(errorMsg) && errorMsg.contains(':UNABLE_TO_LOCK_ROW')) {
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

    private Map<String, List<AOPS_Account_Preferences__c>> splitInitialStageRecs(List<AOPS_Account_Preferences__c> syncedStagingRecList) {
        
        Map<String, List<AOPS_Account_Preferences__c>> splitInitStageRecsMap = new Map<String, List<AOPS_Account_Preferences__c>>();
        
        for (AOPS_Account_Preferences__c initStageRec : syncedStagingRecList) {
            List<AOPS_Account_Preferences__c> stageRecList = splitInitStageRecsMap.get(initStageRec.FCU370P_CUSTOMER_ID__c.leftPad(8, '0'));
            if (stageRecList == null) {
                stageRecList = new List<AOPS_Account_Preferences__c>();
                splitInitStageRecsMap.put(initStageRec.FCU370P_CUSTOMER_ID__c.leftPad(8, '0'), stageRecList);
            }
            stageRecList.add(initStageRec);
        }
        return splitInitStageRecsMap;
    }
}