public class AOPSContactEmailFinalProcessor implements Queueable {
    
    //The initial staging records that will be used to populate the final staging records.
    private List<AOPS_Contact_Email__c> initialStagingRecs;
    private Map<String, Contact_Final_Staging__c> finalStagingMap;
    Map<String, String> syncFailedMessageMap;

    public AOPSContactEmailFinalProcessor(List<AOPS_Contact_Email__c> initialStagingRecs) {
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
            //Generate final staging records to be updated.
            for(AOPS_Contact_Email__c initialStagingRec : initialStagingRecs) {
                Contact_Final_Staging__c finalStagingRec = getPopulatedFinalStagingRec(initialStagingRec);
                finalStagingMap.put(finalStagingRec.AOPS_Contact_Number__c, finalStagingRec);
            }
            // Persist final staging record changes.
            Schema.SObjectField keyField = Contact_Final_Staging__c.Fields.Unique_Record_ID__c;
            List<Contact_Final_Staging__c> finalStagingRecs = finalStagingMap.values();
            System.debug(finalStagingRecs);
            List<Database.UpsertResult> upsertResults = Database.upsert(finalStagingRecs, keyField, false);
            
            List<Contact_Final_Staging__c> stageRecSuccessList = getSuccessfulStagingRecList(upsertResults, finalStagingRecs);
            List<Contact_Final_Staging__c> stageRecFailedList = getFailedStagingRecList(upsertResults, finalStagingRecs);
            markStagingRecordsWithSyncStatus(stageRecSuccessList, stageRecFailedList, initialStagingRecs);
        } catch(Exception e) {
            Database.rollback(sp);
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
        }
    }
    
    private void populateFinalStagingMap() {
        Set<String> contactNumbers = new Set<String>();
        for(AOPS_Contact_Email__c initialStagingRec : initialStagingRecs) {
            contactNumbers.add(initialStagingRec.CCU340F_CONTACT_ID__c);
        }
        
        List<Contact_Final_Staging__c> finalStagingRecs = [SELECT Id, Email1_AOPS_Seq__c, Email2_AOPS_Seq__c, Email3_AOPS_Seq__c, AOPS_Contact_Number__c
                                                          FROM Contact_Final_Staging__c WHERE AOPS_Contact_Number__c IN: contactNumbers];
        for(Contact_Final_Staging__c finalStagingRec : finalStagingRecs) {
            finalStagingMap.put(finalStagingRec.AOPS_Contact_Number__c, finalStagingRec);
        }
    }

    /**
     * Generates a final staging record and populates it with data from the initial staging record.
     */
     public Contact_Final_Staging__c getPopulatedFinalStagingRec(AOPS_Contact_Email__c initialStagingRec) {
        Boolean finalStagingRecExists = finalStagingMap.containsKey(initialStagingRec.CCU340F_CONTACT_ID__c);
        Contact_Final_Staging__c finalStagingRec = finalStagingMap.get(initialStagingRec.CCU340F_CONTACT_ID__c);
        if(finalStagingRec == null) finalStagingRec = new Contact_Final_Staging__c();
        
        finalStagingRec.AOPS_Account_Number__c = initialStagingRec.CXTCNTE_AOPS_KEY1__c.leftPad(8, '0');
        finalStagingRec.AOPS_Contact_Number__c = initialStagingRec.CCU340F_CONTACT_ID__c;
        finalStagingRec.Unique_Record_ID__c = finalStagingRec.AOPS_Account_Number__c + finalStagingRec.AOPS_Contact_Number__c;
        
        if (finalStagingRec.Email1_AOPS_Seq__c == initialStagingRec.CCU340F_ADDRESS_SEQ__c){
            setEmail1Info(finalStagingRec, initialStagingRec);
        }
        else if (finalStagingRec.Email2_AOPS_Seq__c == initialStagingRec.CCU340F_ADDRESS_SEQ__c){
            setEmail2Info(finalStagingRec, initialStagingRec);
        }
        else if (finalStagingRec.Email3_AOPS_Seq__c == initialStagingRec.CCU340F_ADDRESS_SEQ__c){
            setEmail3Info(finalStagingRec, initialStagingRec);
        } else {
            if(String.isBlank(finalStagingRec.Email1_AOPS_Seq__c)) {
                setEmail1Info(finalStagingRec, initialStagingRec);
            } else if(String.isBlank(finalStagingRec.Email2_AOPS_Seq__c)) {
                setEmail2Info(finalStagingRec, initialStagingRec);
            } else if(String.isBlank(finalStagingRec.Email3_AOPS_Seq__c)) {
                setEmail3Info(finalStagingRec, initialStagingRec);
            }
        }
        
        if(initialStagingRec.CCU340F_INTERNET_TYPE__c == 'HUR' || initialStagingRec.CCU340F_INTERNET_TYPE__c == 'WUR')
        {
            finalStagingRec.Website__c = initialStagingRec.CCU340F_ADDRESS__c;
        }

        finalStagingRec.Action__c = initialStagingRec.CXTCNTE_ACTION__c;
        finalStagingRec.Email_Format_Preference__c = initialStagingRec.CCU340F_EMAIL_OUT_TYPE__c;
        finalStagingRec.Sync_Failed__c = false;
        finalStagingRec.Is_Contact_Email_Changed__c = true;

        return finalStagingRec;
    }
@TestVisible
    private void setEmail1Info(Contact_Final_Staging__c finalStagingRec, AOPS_Contact_Email__c initialStagingRec) {
        if(initialStagingRec.CXTCNTE_ACTION__c == 'C' || initialStagingRec.CXTCNTE_ACTION__c == 'U'){
            updateEmail1Info(finalStagingRec, initialStagingRec);
        } else if(initialStagingRec.CXTCNTE_ACTION__c == 'D'){
            removeEmail1Info(finalStagingRec);
        }
    }
@TestVisible
    private void setEmail2Info(Contact_Final_Staging__c finalStagingRec, AOPS_Contact_Email__c initialStagingRec) {
        if(initialStagingRec.CXTCNTE_ACTION__c == 'C' || initialStagingRec.CXTCNTE_ACTION__c == 'U'){
            updateEmail2Info(finalStagingRec, initialStagingRec);
        } else if(initialStagingRec.CXTCNTE_ACTION__c == 'D'){
            removeEmail2Info(finalStagingRec);
        }
    }
@TestVisible
    private void setEmail3Info(Contact_Final_Staging__c finalStagingRec, AOPS_Contact_Email__c initialStagingRec) {
        if(initialStagingRec.CXTCNTE_ACTION__c == 'C' || initialStagingRec.CXTCNTE_ACTION__c == 'U'){
            updateEmail3Info(finalStagingRec, initialStagingRec);
        } else if(initialStagingRec.CXTCNTE_ACTION__c == 'D'){
            removeEmail3Info(finalStagingRec);
        }
    }
@TestVisible

    private void updateEmail1Info(Contact_Final_Staging__c finalStagingRec, AOPS_Contact_Email__c initialStagingRec) {
        finalStagingRec.Email1_AOPS_Seq__c = initialStagingRec.CCU340F_ADDRESS_SEQ__c;
        if(initialStagingRec.CCU340F_INTERNET_TYPE__c == 'HEM' || initialStagingRec.CCU340F_INTERNET_TYPE__c == 'WEM'){
            finalStagingRec.Email1_Type__c = initialStagingRec.CCU340F_INTERNET_TYPE__c;
            finalStagingRec.Email1__c = initialStagingRec.CCU340F_ADDRESS__c;
        }
        if(initialStagingRec.CCU340F_CONTACT_DFT_INTERNET__c == 'Y')
            setEmail1AsDefault(finalStagingRec);
    }
@TestVisible

    private void updateEmail2Info(Contact_Final_Staging__c finalStagingRec, AOPS_Contact_Email__c initialStagingRec) {
        finalStagingRec.Email2_AOPS_Seq__c = initialStagingRec.CCU340F_ADDRESS_SEQ__c;
        if(initialStagingRec.CCU340F_INTERNET_TYPE__c == 'HEM' || initialStagingRec.CCU340F_INTERNET_TYPE__c == 'WEM'){
            finalStagingRec.Email2_Type__c = initialStagingRec.CCU340F_INTERNET_TYPE__c;
            finalStagingRec.Email2__c = initialStagingRec.CCU340F_ADDRESS__c; 
        }
        if(initialStagingRec.CCU340F_CONTACT_DFT_INTERNET__c == 'Y')
            setEmail2AsDefault(finalStagingRec);    
    }
@TestVisible

    private void updateEmail3Info(Contact_Final_Staging__c finalStagingRec, AOPS_Contact_Email__c initialStagingRec) {
        finalStagingRec.Email3_AOPS_Seq__c = initialStagingRec.CCU340F_ADDRESS_SEQ__c;
        if(initialStagingRec.CCU340F_INTERNET_TYPE__c == 'HEM' || initialStagingRec.CCU340F_INTERNET_TYPE__c == 'WEM'){
            finalStagingRec.Email3_Type__c = initialStagingRec.CCU340F_INTERNET_TYPE__c;
            finalStagingRec.Email3__c = initialStagingRec.CCU340F_ADDRESS__c; 
        }
        if(initialStagingRec.CCU340F_CONTACT_DFT_INTERNET__c == 'Y')
            setEmail3AsDefault(finalStagingRec);
    }
@TestVisible

    private void removeEmail1Info(Contact_Final_Staging__c finalStagingRec) {
        finalStagingRec.Email1_AOPS_Seq__c = '';
        finalStagingRec.Email1__c = '';
        finalStagingRec.Email1_Type__c = '';
        // Do not remove default flag. We need this in final sync to identify whether to delete contact.email.
        //finalStagingRec.Default_Email1__c = '';
    }
@TestVisible

    private void removeEmail2Info(Contact_Final_Staging__c finalStagingRec) {
        finalStagingRec.Email2_AOPS_Seq__c = '';
        finalStagingRec.Email2__c = '';
        finalStagingRec.Email2_Type__c = '';
        // Do not remove default flag. We need this in final sync to identify whether to delete contact.email.
        //finalStagingRec.Default_Email2__c = '';
    }
@TestVisible

    private void removeEmail3Info(Contact_Final_Staging__c finalStagingRec) {
        finalStagingRec.Email3_AOPS_Seq__c = '';
        finalStagingRec.Email3__c = '';
        finalStagingRec.Email3_Type__c = '';
        // Do not remove default flag. We need this in final sync to identify whether to delete contact.email.
        //finalStagingRec.Default_Email3__c = '';
    }
@TestVisible

    private void setEmail1AsDefault(Contact_Final_Staging__c finalStagingRec) {
         finalStagingRec.Default_Email1__c = 'Y';
         finalStagingRec.Default_Email2__c = 'N';
         finalStagingRec.Default_Email3__c = 'N';
    }
@TestVisible

    private void setEmail2AsDefault(Contact_Final_Staging__c finalStagingRec) {
        finalStagingRec.Default_Email1__c = 'N';
        finalStagingRec.Default_Email2__c = 'Y';
        finalStagingRec.Default_Email3__c = 'N';
    }
@TestVisible

    private void setEmail3AsDefault(Contact_Final_Staging__c finalStagingRec) {
        finalStagingRec.Default_Email1__c = 'N';
        finalStagingRec.Default_Email2__c = 'N';
        finalStagingRec.Default_Email3__c = 'Y';
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

    private void markStagingRecordsWithSyncStatus(List<Contact_Final_Staging__c> successList, List<Contact_Final_Staging__c> failedList, List<AOPS_Contact_Email__c> syncedStagingRecList) {
        
        Map<String, AOPS_Contact_Email__c> syncedStagingRecMap = new Map<String, AOPS_Contact_Email__c>();                
        Map<String, List<AOPS_Contact_Email__c>> initialStageRecsSplitMap = splitInitialStageRecs(syncedStagingRecList);
        
        List<AOPS_Contact_Email__c> clonedRecords = new List<AOPS_Contact_Email__c>();
        
        for(Contact_Final_Staging__c finalStageRec : successList) {
            List<AOPS_Contact_Email__c> initStageRecList = initialStageRecsSplitMap.get(finalStageRec.AOPS_Contact_Number__c);
            for (AOPS_Contact_Email__c initStageRec : initStageRecList) {
                AOPS_Contact_Email__c clonedRecord = new AOPS_Contact_Email__c(Id=initStageRec.Id);
                clonedRecord.Record_Updated__c = false;
                clonedRecord.Sync_Status_Message__c = 'Success';
                clonedRecords.add(clonedRecord);
            }
        }
        String errorMsg = '';
        for(Contact_Final_Staging__c finalStageRec : failedList) {
            List<AOPS_Contact_Email__c> initStageRecList = initialStageRecsSplitMap.get(finalStageRec.AOPS_Contact_Number__c);
            for (AOPS_Contact_Email__c initStageRec : initStageRecList) {
                AOPS_Contact_Email__c clonedRecord = new AOPS_Contact_Email__c(Id=initStageRec.Id);
                errorMsg = syncFailedMessageMap.get(initStageRec.CCU340F_CONTACT_ID__c);
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
  
    private Map<String, List<AOPS_Contact_Email__c>> splitInitialStageRecs(List<AOPS_Contact_Email__c> syncedStagingRecList) {
        
        Map<String, List<AOPS_Contact_Email__c>> splitInitStageRecsMap = new Map<String, List<AOPS_Contact_Email__c>>();
        
        for (AOPS_Contact_Email__c initStageRec : syncedStagingRecList) {
            List<AOPS_Contact_Email__c> stageRecList = splitInitStageRecsMap.get(initStageRec.CCU340F_CONTACT_ID__c);
            if (stageRecList == null) {
                stageRecList = new List<AOPS_Contact_Email__c>();
                splitInitStageRecsMap.put(initStageRec.CCU340F_CONTACT_ID__c, stageRecList);
            }
            stageRecList.add(initStageRec);
        }
        return splitInitStageRecsMap;
    }
}