public class AOPSSyncToContactProcessor {

    List<Contact_Final_Staging__c> stagingRecordsToSync; // The staging records that have changed to be synced.

    public AOPSSyncToContactProcessor(List<Contact_Final_Staging__c> stagingRecordsToSync) {
        this.stagingRecordsToSync = stagingRecordsToSync;
    }

    public static Boolean isFailedRecord(Contact_Final_Staging__c finalStagingRec) {
        return finalStagingRec.Sync_Failed__c;
    }

    /**
     * Syncs the staging records to corresponding Contact and OptInOut records.
     * Additionally, the staging records are marked as having been synced.
     */
    public void sync() {
        Savepoint sp = Database.setSavepoint();
        try {
            AOPSSyncFinalStagingToContact contactSync = new AOPSSyncFinalStagingToContact(stagingRecordsToSync);
            contactSync.sync();

            AOPSSyncFinalStagingToOptInOut optInOutSync = new AOPSSyncFinalStagingToOptInOut(stagingRecordsToSync);
            optInOutSync.sync();

            List<Contact_Final_Staging__c> failedStagingRecs = mergeFailedRecords(contactSync.getFailedStagingRecs(), optInOutSync.getFailedStagingRecs());
            Set<String> syncedStagingRecIds = getSyncedStagingRecordIds(contactSync.getSyncedStagingRecs(), optInOutSync.getSyncedStagingRecs(), failedStagingRecs);
            updateFailedStagingRecs(failedStagingRecs);
            markStagingRecordsAsSynced(syncedStagingRecIds);

        } catch(Exception e) {
            Database.rollback(sp);
            handleSyncFailure(e);
        }
    }

    private List<Contact_Final_Staging__c> mergeFailedRecords(List<Contact_Final_Staging__c> failedContactSyncRecs, List<Contact_Final_Staging__c> failedOptInSyncRecs) {
        Map<String, Contact_Final_Staging__c> failedRecMap = new Map<String, Contact_Final_Staging__c>();
        for(Contact_Final_Staging__c stagingRec : failedContactSyncRecs)
            failedRecMap.put(stagingRec.Id, stagingRec);
        
        for(Contact_Final_Staging__c stagingRec : failedOptInSyncRecs) {
            if(failedRecMap.containsKey(stagingRec.Id)) {
                failedRecMap.get(stagingRec.Id).OptIn_Sync_Message__c = stagingRec.OptIn_Sync_Message__c;
            } else {
                failedRecMap.put(stagingRec.Id, stagingRec);
            }
        }
        return failedRecMap.values();
    }

    private Set<String> getSyncedStagingRecordIds(List<Contact_Final_Staging__c> contactSyncedRecs, List<Contact_Final_Staging__c> optInSyncedRecs, List<Contact_Final_Staging__c> failedRecs) {
        Set<String> failedIds = new Set<String>();
        for(Contact_Final_Staging__c failedRec : failedRecs)
            failedIds.add(failedRec.Id);
        
        Set<String> syncedRecIds = new Set<String>();
        for(Contact_Final_Staging__c contactSyncedRec : contactSyncedRecs) {
            String id = contactSyncedRec.Id;
            if(failedIds.contains(id) == false)
                syncedRecIds.add(id);
        }
        for(Contact_Final_Staging__c optInSyncedRec : optInSyncedRecs) {
            String id = optInSyncedRec.Id;
            if(failedIds.contains(id) == false)
                syncedRecIds.add(id);
        }
        
        return syncedRecIds;
    }

    private void updateFailedStagingRecs(List<Contact_Final_Staging__c> failedStagingRecs) {
        for(Contact_Final_Staging__c stagingRec : failedStagingRecs)
            stagingRec.Sync_Failed__c = true;
        if(failedStagingRecs.size() > 0) update failedStagingRecs;
    }

    /**
     * Sets the "Is Changed" fields on the staging records to false, effectively
     * marking them as in sync with their corresponding Contact and OptInOut records.
     */
    private void markStagingRecordsAsSynced(Set<String> syncedRecIds) {
        List<Contact_Final_Staging__c> clonedRecords = new List<Contact_Final_Staging__c>();
        for(String id : syncedRecIds) {
            Contact_Final_Staging__c clonedRecord = new Contact_Final_Staging__c(Id=id);
            clonedRecord.Is_Contact_Master_Changed__c = false;
            clonedRecord.Is_Contact_Phone_Changed__c = false;
            clonedRecord.Is_Contact_Email_Changed__c = false;
            clonedRecord.Is_Contact_OptIn_Changed__c = false;
            clonedRecord.Is_Contact_WebUser_Changed__c = false;
            clonedRecord.Sync_Failed__c = false;
            clonedRecord.Sync_Status_Message__c = 'Success';
            clonedRecord.Contact_Sync_Message__c = null;
            clonedRecord.OptIn_Sync_Message__c = null;
            clonedRecord.Number_Of_Attempts__c = 0;
            clonedRecords.add(clonedRecord);
        }
        if(clonedRecords.size() > 0) update clonedRecords;
    }

    private void handleSyncFailure(Exception e) {
        System.debug(e.getMessage());
        System.debug(e.getStackTraceString());
        List<Contact_Final_Staging__c> clonedRecords = new List<Contact_Final_Staging__c>();
        for(Contact_Final_Staging__c stagingRec : stagingRecordsToSync) {
            Contact_Final_Staging__c clonedRec = new Contact_Final_Staging__c(Id=stagingRec.Id, Sync_Failed__c=true);
            clonedRec.Sync_Failed__c = true;
            clonedRec.Sync_Status_Message__c = e.getMessage();
            clonedRecords.add(clonedRec);
        }
        update clonedRecords;
    }
}