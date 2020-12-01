public class AOPSContactShipToFinalProcessor implements Queueable {

	// The initial staging records that will be used to populate the final staging records.
    private List<AOPS_Contact_Ship_Address__c> initialStagingRecs;
    Map<String, String> syncFailedMessageMap;

    public AOPSContactShipToFinalProcessor(List<AOPS_Contact_Ship_Address__c> initialStagingRecs) {
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
            List<SiteContacts_Final_Staging__c> finalStagingRecs = new List<SiteContacts_Final_Staging__c>();
            for(AOPS_Contact_Ship_Address__c initialStagingRec : initialStagingRecs) {
                SiteContacts_Final_Staging__c finalStagingRec = getPopulatedFinalStagingRec(initialStagingRec);
                finalStagingRecs.add(finalStagingRec);
            }
            
            // Persist final staging record changes.
            Schema.SObjectField keyField = SiteContacts_Final_Staging__c.Fields.Unique_Record_ID__c;
            List<Database.UpsertResult> upsertResults = Database.upsert(finalStagingRecs, keyField, false);

            List<SiteContacts_Final_Staging__c> stageRecSuccessList = getSuccessfulStagingRecList(upsertResults, finalStagingRecs);
            List<SiteContacts_Final_Staging__c> stageRecFailedList = getFailedStagingRecList(upsertResults, finalStagingRecs);
            markStagingRecordsWithSyncStatus(stageRecSuccessList, stageRecFailedList, initialStagingRecs);
        } catch(Exception e) {
            Database.rollback(sp);
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
    }

    /**
     * Generates a final staging record and populates it with data from the initial staging record.
    **/
    @TestVisible

    private SiteContacts_Final_Staging__c getPopulatedFinalStagingRec(AOPS_Contact_Ship_Address__c initialStagingRec) {
		        
        SiteContacts_Final_Staging__c finalStagingRec = new SiteContacts_Final_Staging__c();
        finalStagingRec.Unique_Record_ID__c = getFinalRecUniqueId(initialStagingRec);
        finalStagingRec.AOPS_Contact_Number__c = initialStagingRec.CCU310F_CONTACT_ID__c;
        finalStagingRec.AOPS_Account_Number__c = initialStagingRec.CCU310F_CUSTOMER_ID__c.leftPad(8, '0');
        finalStagingRec.Shipto_Addr_Seq__c = initialStagingRec.CCU310F_ADDR_SEQ__c;
        finalStagingRec.Default_Ship_Contact__c = initialStagingRec.CCU310F_DFT_SHIP_CONT__c;
        finalStagingRec.Allowed_To_Buy__c = initialStagingRec.CCU310F_ALLOW_BUY__c;
        finalStagingRec.Action__c = initialStagingRec.CXTCNTS_ACTION__c;
        
        finalStagingRec.Is_Changed__c = true;
        
        return finalStagingRec;
    }
@TestVisible

    private List<SiteContacts_Final_Staging__c> getSuccessfulStagingRecList(Database.UpsertResult[] upsertResultList, List<SiteContacts_Final_Staging__c> finalStageRecList) {
        
        List<SiteContacts_Final_Staging__c> successStageRecList = new List<SiteContacts_Final_Staging__c>();
        for(Integer i=0; i < upsertResultList.size(); i++) {
            if(upsertResultList[i].isSuccess()) {
                successStageRecList.add(finalStageRecList[i]);
            }            
        }
        return successStageRecList;
    }
    @TestVisible

    private List<SiteContacts_Final_Staging__c> getFailedStagingRecList(Database.UpsertResult[] upsertResultList, List<SiteContacts_Final_Staging__c> finalStageRecList) {
        
        List<SiteContacts_Final_Staging__c> failedStageRecList = new List<SiteContacts_Final_Staging__c>();
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
                syncFailedMessageMap.put(finalStageRecList[i].Unique_Record_ID__c, message);
            }
        }
        return failedStageRecList;
    }
    @TestVisible

    private void markStagingRecordsWithSyncStatus(List<SiteContacts_Final_Staging__c> successList, List<SiteContacts_Final_Staging__c> failedList, List<AOPS_Contact_Ship_Address__c> syncedStagingRecList) {
        
        Map<String, AOPS_Contact_Ship_Address__c> syncedStagingRecMap = new Map<String, AOPS_Contact_Ship_Address__c>();
        
        for (AOPS_Contact_Ship_Address__c afs : syncedStagingRecList) {
            syncedStagingRecMap.put(getFinalRecUniqueId(afs), afs);
        }
        
        List<AOPS_Contact_Ship_Address__c> clonedRecords = new List<AOPS_Contact_Ship_Address__c>();        
        AOPS_Contact_Ship_Address__c stagingRec;
        
        for(SiteContacts_Final_Staging__c stageRec : successList) {
            stagingRec = syncedStagingRecMap.get(stageRec.Unique_Record_ID__c);
            AOPS_Contact_Ship_Address__c clonedRecord = new AOPS_Contact_Ship_Address__c(Id=stagingRec.Id);
            clonedRecord.Record_Updated__c = false;
            clonedRecord.Sync_Status_Message__c = 'Success';
            clonedRecords.add(clonedRecord);
        }
        
        for(SiteContacts_Final_Staging__c stageRec : failedList) {
            stagingRec = syncedStagingRecMap.get(stageRec.Unique_Record_ID__c);
            AOPS_Contact_Ship_Address__c clonedRecord = new AOPS_Contact_Ship_Address__c(Id=stagingRec.Id);
            String errorMsg = syncFailedMessageMap.get(stageRec.Unique_Record_ID__c);
            
            if (String.isNotEmpty(errorMsg) && errorMsg.contains('UNABLE_TO_LOCK_ROW')) {
                clonedRecord.Record_Updated__c = true; // Retry for the lock.
            } else {
                clonedRecord.Record_Updated__c = false; // This is to avoid recursive processing. If there is an issue, do not process the same data recursively.
            }
            clonedRecord.Sync_Status_Message__c = syncFailedMessageMap.get(stageRec.Unique_Record_ID__c);
            clonedRecords.add(clonedRecord);
        }
        
        update clonedRecords;
    }
    @TestVisible

    private String getFinalRecUniqueId(AOPS_Contact_Ship_Address__c initialRec) {
        return initialRec.CCU310F_CUSTOMER_ID__c.leftPad(8, '0') +
                initialRec.CCU310F_CONTACT_ID__c +
                initialRec.CCU310F_ADDR_SEQ__c;
    }
}