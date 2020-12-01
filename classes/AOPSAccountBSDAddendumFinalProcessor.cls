public class AOPSAccountBSDAddendumFinalProcessor implements Queueable {

    // The initial staging records that will be used to populate the final staging records.
    private List<AOPS_Account_BSD_Addendum__c> initialStagingRecs;
    private Map<String, String> syncFailedMessageMap;

    public AOPSAccountBSDAddendumFinalProcessor(List<AOPS_Account_BSD_Addendum__c> initialStagingRecs) {
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
            for(AOPS_Account_BSD_Addendum__c initialStagingRec : initialStagingRecs) {
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
            System.debug(e.getStackTraceString());
        }
    }

    /**
     * Generates a final staging record and populates it with data from the initial staging record.
     */
    private Account_Final_Staging__c getPopulatedFinalStagingRec(AOPS_Account_BSD_Addendum__c initialStagingRec) {
        Account_Final_Staging__c finalStagingRec = new Account_Final_Staging__c();
        finalStagingRec.AOPS_Cust_Id__c = initialStagingRec.CCU007F_CUSTOMER_ID__c.leftPad(8, '0');

        if(initialStagingRec.CXTC007F_ACTION__c == 'C' || initialStagingRec.CXTC007F_ACTION__c == 'U') {
            finalStagingRec.Forms_Customer_Flag__c = initialStagingRec.CCU007F_FORMS_FLAG__c;
            if (initialStagingRec.CCU007F_ORDER_LIMIT__c != null) {
                finalStagingRec.Max_Order_Limit__c = Decimal.valueOf(initialStagingRec.CCU007F_ORDER_LIMIT__c);
            }
            finalStagingRec.Freight_Charge__c = initialStagingRec.CCU007F_FREIGHT_CHG_REQ_FLAG__c;
            finalStagingRec.Dept_Req_Code__c = initialStagingRec.CCU007F_DEPT_REQUIRED_CODE__c;
            finalStagingRec.Location_Req_Code__c = initialStagingRec.CCU007F_LOCATION_REQ_CODE__c;
            finalStagingRec.PO_Req_Code__c = initialStagingRec.CCU007F_PO_REQUIRED_CODE__c;
            finalStagingRec.Release_Req_Code__c = initialStagingRec.CCU007F_RELEASE_REQUIRED_CODE__c;
            finalStagingRec.Future_Use_Reserved__c = initialStagingRec.CCU007F_FILLER__c;
        } else if(initialStagingRec.CXTC007F_ACTION__c == 'D') {
            finalStagingRec.Forms_Customer_Flag__c = null;
            finalStagingRec.Max_Order_Limit__c = null;
            finalStagingRec.Freight_Charge__c = null;
            finalStagingRec.Dept_Req_Code__c = null;
            finalStagingRec.Location_Req_Code__c = null;
            finalStagingRec.PO_Req_Code__c = null;
            finalStagingRec.Release_Req_Code__c = null;
            finalStagingRec.Future_Use_Reserved__c = null;
        }

        finalStagingRec.Action__c = initialStagingRec.CXTC007F_ACTION__c;
        finalStagingRec.Sync_Failed__c = false;
        finalStagingRec.Is_Account_BSD_Addendum_Changed__c = true;
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
    
    private void markStagingRecordsWithSyncStatus(List<Account_Final_Staging__c> successList, List<Account_Final_Staging__c> failedList, List<AOPS_Account_BSD_Addendum__c> syncedStagingRecList) {
        
        Map<String, AOPS_Account_BSD_Addendum__c> syncedStagingRecMap = new Map<String, AOPS_Account_BSD_Addendum__c>();
        
        for (AOPS_Account_BSD_Addendum__c afs : syncedStagingRecList) {
            syncedStagingRecMap.put(afs.CCU007F_CUSTOMER_ID__c.leftPad(8, '0'), afs);
        }
        
        List<AOPS_Account_BSD_Addendum__c> clonedRecords = new List<AOPS_Account_BSD_Addendum__c>();        
        AOPS_Account_BSD_Addendum__c stagingRec;
        
        for(Account_Final_Staging__c stageRec : successList) {
            stagingRec = syncedStagingRecMap.get(stageRec.AOPS_Cust_Id__c);
            AOPS_Account_BSD_Addendum__c clonedRecord = new AOPS_Account_BSD_Addendum__c(Id=stagingRec.Id);
            clonedRecord.Record_Updated__c = false;
            clonedRecord.Sync_Status_Message__c = 'Success';
            clonedRecords.add(clonedRecord);
        }
        String errorMsg = '';
        for(Account_Final_Staging__c stageRec : failedList) {
            stagingRec = syncedStagingRecMap.get(stageRec.AOPS_Cust_Id__c);
            AOPS_Account_BSD_Addendum__c clonedRecord = new AOPS_Account_BSD_Addendum__c(Id=stagingRec.Id);
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