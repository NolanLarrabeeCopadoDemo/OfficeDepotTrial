public class AOPSAccountChildParentRelFinalProcessor implements Queueable {

    // The initial staging records that will be used to populate the final staging records.
    private List<AOPS_Account_Child_Parent_Relationship__c> initialStagingRecs;
    Map<String, String> syncFailedMessageMap;

    public AOPSAccountChildParentRelFinalProcessor(List<AOPS_Account_Child_Parent_Relationship__c> initialStagingRecs) {
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
            List<Account_Final_Staging__c> finalStagingRecs = new List<Account_Final_Staging__c>();
            for(AOPS_Account_Child_Parent_Relationship__c initialStagingRec : initialStagingRecs) {
                Account_Final_Staging__c finalStagingRec = getPopulatedFinalStagingRec(initialStagingRec);
                finalStagingRecs.add(finalStagingRec);
            }
            // Persist final staging record changes.
            Schema.SObjectField keyField = Account_Final_Staging__c.Fields.AOPS_Cust_Id__c;                
            List<Database.UpsertResult> upsertResults = Database.upsert(finalStagingRecs, keyField, false);

            List<Account_Final_Staging__c> stageRecSuccessList = getSuccessfulStagingRecList(upsertResults, finalStagingRecs);
            List<Account_Final_Staging__c> stageRecFailedList = getFailedStagingRecList(upsertResults, finalStagingRecs);
            markStagingRecordsWithSyncStatus(stageRecSuccessList, stageRecFailedList, initialStagingRecs);
        } catch(Exception e) {
            Database.rollback(sp);
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
    }

    /**
     * Generates a final staging record and populates it with data from the initial staging record.
     */
    private Account_Final_Staging__c getPopulatedFinalStagingRec(AOPS_Account_Child_Parent_Relationship__c initialStagingRec) {
        Account_Final_Staging__c finalStagingRec = new Account_Final_Staging__c();
        finalStagingRec.AOPS_Cust_Id__c = initialStagingRec.FCU005P_CUSTOMER_ID__c.leftPad(8, '0');
        finalStagingRec.PARENT_ID__c = initialStagingRec.FCU005P_PARENT_ID__c;
        finalStagingRec.Parent_Account_Changed_Action__c = initialStagingRec.CXTF005P_ACTION__c;
        finalStagingRec.Sync_Failed__c = false;
        finalStagingRec.Is_Parent_Account_Changed__c = true;
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
                syncFailedMessageMap.put(finalStageRecList[i].AOPS_Cust_Id__c, message);
            }
        }
        return failedStageRecList;
    }
    
    private void markStagingRecordsWithSyncStatus(List<Account_Final_Staging__c> successList, List<Account_Final_Staging__c> failedList, List<AOPS_Account_Child_Parent_Relationship__c> syncedStagingRecList) {
        
        Map<String, AOPS_Account_Child_Parent_Relationship__c> syncedStagingRecMap = new Map<String, AOPS_Account_Child_Parent_Relationship__c>();
        
        for (AOPS_Account_Child_Parent_Relationship__c afs : syncedStagingRecList) {
            syncedStagingRecMap.put(afs.FCU005P_CUSTOMER_ID__c.leftPad(8, '0'), afs);
        }
        
        List<AOPS_Account_Child_Parent_Relationship__c> clonedRecords = new List<AOPS_Account_Child_Parent_Relationship__c>();        
        AOPS_Account_Child_Parent_Relationship__c stagingRec;
        
        for(Account_Final_Staging__c stageRec : successList) {
            stagingRec = syncedStagingRecMap.get(stageRec.AOPS_Cust_Id__c);
            AOPS_Account_Child_Parent_Relationship__c clonedRecord = new AOPS_Account_Child_Parent_Relationship__c(Id=stagingRec.Id);
            clonedRecord.Record_Updated__c = false;
            clonedRecord.Sync_Status_Message__c = 'Success';
            clonedRecords.add(clonedRecord);
        }
        String errorMsg = '';
        for(Account_Final_Staging__c stageRec : failedList) {
            stagingRec = syncedStagingRecMap.get(stageRec.AOPS_Cust_Id__c);
            AOPS_Account_Child_Parent_Relationship__c clonedRecord = new AOPS_Account_Child_Parent_Relationship__c(Id=stagingRec.Id);
            errorMsg = syncFailedMessageMap.get(stageRec.AOPS_Cust_Id__c);
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