public class AOPSAddressBSDAddendumFinalProcessor implements Queueable {

	// The initial staging records that will be used to populate the final staging records.
    private List<AOPS_Address_BSD_A__c> initialStagingRecs;
    private Map<String, String> syncFailedMessageMap;

    public AOPSAddressBSDAddendumFinalProcessor(List<AOPS_Address_BSD_A__c> initialStagingRecs) {
        this.initialStagingRecs = initialStagingRecs;
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
            // Generate final staging records to be updated.
            List<Account_Site_Final_Staging__c> finalStagingRecs = new List<Account_Site_Final_Staging__c>();
            for(AOPS_Address_BSD_A__c initialStagingRec : initialStagingRecs) {
                Account_Site_Final_Staging__c finalStagingRec = getPopulatedFinalStagingRec(initialStagingRec);
                finalStagingRecs.add(finalStagingRec);
            }
            // Persist final staging record changes.
            Schema.SObjectField keyField = Account_Site_Final_Staging__c.Fields.AOPS_Seq_ID__c;
            List<Database.UpsertResult> upsertResults = Database.upsert(finalStagingRecs, keyField, false);
            
            List<Account_Site_Final_Staging__c> stageRecSuccessList = getSuccessfulStagingRecList(upsertResults, finalStagingRecs);
            List<Account_Site_Final_Staging__c> stageRecFailedList = getFailedStagingRecList(upsertResults, finalStagingRecs);
            markStagingRecordsWithSyncStatus(stageRecSuccessList, stageRecFailedList, initialStagingRecs);
        } catch(Exception e) {
            Database.rollback(sp);
            System.debug(e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    /**
     * Generates a final staging record and populates it with data from the initial staging record.
     */
    private Account_Site_Final_Staging__c getPopulatedFinalStagingRec(AOPS_Address_BSD_A__c initialStagingRec) {
        Account_Site_Final_Staging__c finalStagingRec = new Account_Site_Final_Staging__c();
        finalStagingRec = finalStagingRec.clone(true, true, true, true);
        finalStagingRec.AOPS_Cust_Id__c = initialStagingRec.CCU009F_CUSTOMER_ID__c.leftPad(8, '0');
		finalStagingRec.AOPS_Seq_ID__c = finalStagingRec.AOPS_Cust_Id__c + '-' +initialStagingRec.CCU009F_ADDRESS_SEQ__c.leftPad(5, '0');
        finalStagingRec.FCU001P_ADDRESS_SEQ__c = initialStagingRec.CCU009F_ADDRESS_SEQ__c.leftPad(5, '0');
        finalStagingRec.Action__c = initialStagingRec.CXTC009F_ACTION__c;
        finalStagingRec.Is_Address_Addendum_Changed__c = true;
        finalStagingRec.Sync_Failed__c = false;
        return finalStagingRec;
    }
    
    private List<Account_Site_Final_Staging__c> getSuccessfulStagingRecList(Database.UpsertResult[] upsertResultList, List<Account_Site_Final_Staging__c> finalStageRecList) {
        
        List<Account_Site_Final_Staging__c> successStageRecList = new List<Account_Site_Final_Staging__c>();
        for(Integer i=0; i < upsertResultList.size(); i++) {
            if(upsertResultList[i].isSuccess()) {
                successStageRecList.add(finalStageRecList[i]);
            }            
        }
        return successStageRecList;
    }
    
    private List<Account_Site_Final_Staging__c> getFailedStagingRecList(Database.UpsertResult[] upsertResultList, List<Account_Site_Final_Staging__c> finalStageRecList) {
        
        List<Account_Site_Final_Staging__c> failedStageRecList = new List<Account_Site_Final_Staging__c>();
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
                syncFailedMessageMap.put(finalStageRecList[i].AOPS_Cust_Id__c + finalStageRecList[i].FCU001P_ADDRESS_SEQ__c, message);
            }
        }
        return failedStageRecList;
    }
    
    private void markStagingRecordsWithSyncStatus(List<Account_Site_Final_Staging__c> successList, List<Account_Site_Final_Staging__c> failedList, List<AOPS_Address_BSD_A__c> syncedStagingRecList) {
        
        Map<String, AOPS_Address_BSD_A__c> syncedStagingRecMap = new Map<String, AOPS_Address_BSD_A__c>();
        
        for (AOPS_Address_BSD_A__c afs : syncedStagingRecList) {
            syncedStagingRecMap.put(afs.CCU009F_CUSTOMER_ID__c.leftPad(8, '0') + afs.CCU009F_ADDRESS_SEQ__c.leftPad(5, '0'), afs);
        }
        
        List<AOPS_Address_BSD_A__c> clonedRecords = new List<AOPS_Address_BSD_A__c>();        
        AOPS_Address_BSD_A__c stagingRec;
        
        for(Account_Site_Final_Staging__c stageRec : successList) {
            stagingRec = syncedStagingRecMap.get(stageRec.AOPS_Cust_Id__c + stageRec.FCU001P_ADDRESS_SEQ__c);
            AOPS_Address_BSD_A__c clonedRecord = new AOPS_Address_BSD_A__c(Id=stagingRec.Id);
            clonedRecord.Record_Updated__c = false;
            clonedRecord.Sync_Status_Message__c = 'Success';
            clonedRecords.add(clonedRecord);
        }
        String errorMsg = '';
        for(Account_Site_Final_Staging__c stageRec : failedList) {
            stagingRec = syncedStagingRecMap.get(stageRec.AOPS_Cust_Id__c + stageRec.FCU001P_ADDRESS_SEQ__c);
            AOPS_Address_BSD_A__c clonedRecord = new AOPS_Address_BSD_A__c(Id=stagingRec.Id);
            errorMsg = syncFailedMessageMap.get(stageRec.AOPS_Cust_Id__c + stageRec.FCU001P_ADDRESS_SEQ__c);
            if (String.isNotEmpty(errorMsg) && errorMsg.contains('UNABLE_TO_LOCK_ROW')) {
                clonedRecord.Record_Updated__c = true; // Retry for the lock.
            } else {
                clonedRecord.Record_Updated__c = false; // This is to avoid recursive processing. If there is an issue, do not process the same data recursively.
            }            
            clonedRecord.Sync_Status_Message__c = errorMsg;
            clonedRecords.add(clonedRecord);
        }
        
        update clonedRecords;
    }
}