public class AOPSContactPhoneFinalProcessor implements Queueable {

	// The initial staging records that will be used to populate the final staging records.
    private List<AOPS_Contact_Phone__c> initialStagingRecs;
    private Map<String, Contact_Final_Staging__c> finalStagingMap;
    Map<String, String> syncFailedMessageMap;

    public AOPSContactPhoneFinalProcessor(List<AOPS_Contact_Phone__c> initialStagingRecs) {
        this.initialStagingRecs = initialStagingRecs;
        this.finalStagingMap = new Map<String, Contact_Final_Staging__c>();
    }
    
    /**
     * The method executed when the job is started. Populates and upserts final staging records,
     * and updates the initial staging records by specifying they are no longer in the updated state.
     */
    public void execute(QueueableContext context) {
        Process();
    }

    public void Process() {
        Savepoint sp = Database.setSavepoint();
        try {
            populateFinalStagingMap();
            // Generate final staging records to be updated.
            for(AOPS_Contact_Phone__c initialStagingRec : initialStagingRecs) {
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
            System.debug(e.getStackTraceString());
        }
    }

    private void populateFinalStagingMap() {
        Set<String> contactNumbers = new Set<String>();
        for(AOPS_Contact_Phone__c initialStagingRec : initialStagingRecs) {
            contactNumbers.add(initialStagingRec.CCU320F_CONTACT_ID__c);
        }
        
        List<Contact_Final_Staging__c> finalStagingRecs = [SELECT Id, Phone1_AOPS_Seq__c, Phone2_AOPS_Seq__c, Phone3_AOPS_Seq__c, AOPS_Contact_Number__c
                                                          FROM Contact_Final_Staging__c WHERE AOPS_Contact_Number__c IN: contactNumbers];
        for(Contact_Final_Staging__c finalStagingRec : finalStagingRecs) {
            finalStagingMap.put(finalStagingRec.AOPS_Contact_Number__c, finalStagingRec);
        }
    }

    /**
     * Generates a final staging record and populates it with data from the initial staging record.
    **/
    @TestVisible

    private Contact_Final_Staging__c getPopulatedFinalStagingRec(AOPS_Contact_Phone__c initialStagingRec) {
        Contact_Final_Staging__c finalStagingRec = finalStagingMap.get(initialStagingRec.CCU320F_CONTACT_ID__c);
        if(finalStagingRec == null) finalStagingRec = new Contact_Final_Staging__c();
        
        finalStagingRec.AOPS_Contact_Number__c = initialStagingRec.CCU320F_CONTACT_ID__c;
		finalStagingRec.AOPS_Account_Number__c = initialStagingRec.CCU320F_CUSTOMER_ID__c.leftPad(8, '0'); 
		finalStagingRec.Unique_Record_ID__c = finalStagingRec.AOPS_Account_Number__c + finalStagingRec.AOPS_Contact_Number__c;
        
        if (initialStagingRec.CCU320F_NBR_TYPE__c == 'WFX' || initialStagingRec.CCU320F_NBR_TYPE__c == 'HFX') {
			finalStagingRec.fax__c = initialStagingRec.CCU320F_AREA_CODE__c + initialStagingRec.CCU320F_PREFIX__c +initialStagingRec.CCU320F_NUMBER__c;
		}
		else {
            if (finalStagingRec.Phone1_AOPS_Seq__c == initialStagingRec.CCU320F_PHONE_SEQ__c) {
                setPhone1Info(finalStagingRec, initialStagingRec);
            } else if (finalStagingRec.Phone2_AOPS_Seq__c == initialStagingRec.CCU320F_PHONE_SEQ__c) {
                setPhone2Info(finalStagingRec, initialStagingRec);
            } else if (finalStagingRec.Phone3_AOPS_Seq__c == initialStagingRec.CCU320F_PHONE_SEQ__c) {
                setPhone3Info(finalStagingRec, initialStagingRec);
            } else {
                if(String.isBlank(finalStagingRec.Phone1_AOPS_Seq__c)) {
                    setPhone1Info(finalStagingRec, initialStagingRec);
                } else if(String.isBlank(finalStagingRec.Phone2_AOPS_Seq__c)) {
                    setPhone2Info(finalStagingRec, initialStagingRec);
                } else if(String.isBlank(finalStagingRec.Phone3_AOPS_Seq__c)) {
                    setPhone3Info(finalStagingRec, initialStagingRec);
                }
            }
        }
        
        finalStagingRec.Action__c = initialStagingRec.CXTCNTP_ACTION__c;
        finalStagingRec.Sync_Failed__c = false;
        finalStagingRec.Is_Contact_Phone_Changed__c = true;
        return finalStagingRec;
    }
@TestVisible

    private void setPhone1Info(Contact_Final_Staging__c finalStagingRec, AOPS_Contact_Phone__c initialStagingRec) {
        if (initialStagingRec.CXTCNTP_ACTION__c == 'C' || initialStagingRec.CXTCNTP_ACTION__c == 'U') {
            updatePhone1Info(finalStagingRec, initialStagingRec);
        }
        else if (initialStagingRec.CXTCNTP_ACTION__c == 'D') {
            removePhone1Info(finalStagingRec);
        }
    }
@TestVisible

    private void setPhone2Info(Contact_Final_Staging__c finalStagingRec, AOPS_Contact_Phone__c initialStagingRec) {
        if (initialStagingRec.CXTCNTP_ACTION__c == 'C' || initialStagingRec.CXTCNTP_ACTION__c == 'U') {
            updatePhone2Info(finalStagingRec, initialStagingRec);
        }
        else if (initialStagingRec.CXTCNTP_ACTION__c == 'D') {
            removePhone2Info(finalStagingRec);
        }
    }
@TestVisible

    private void setPhone3Info(Contact_Final_Staging__c finalStagingRec, AOPS_Contact_Phone__c initialStagingRec) {
        if (initialStagingRec.CXTCNTP_ACTION__c == 'C' || initialStagingRec.CXTCNTP_ACTION__c == 'U') {
            updatePhone3Info(finalStagingRec, initialStagingRec);
        }
        else if (initialStagingRec.CXTCNTP_ACTION__c == 'D') {
            removePhone3Info(finalStagingRec);
        }
    }
@TestVisible

    private void updatePhone1Info(Contact_Final_Staging__c finalStagingRec, AOPS_Contact_Phone__c initialStagingRec) {
        finalStagingRec.Phone1_AOPS_Seq__c = initialStagingRec.CCU320F_PHONE_SEQ__c;
        finalStagingRec.phone1__c = initialStagingRec.CCU320F_AREA_CODE__c + initialStagingRec.CCU320F_PREFIX__c +initialStagingRec.CCU320F_NUMBER__c;
        finalStagingRec.Phone_EXT__c = initialStagingRec.CCU320F_EXTENSION__c;
        finalStagingRec.Default_Phone1__c = initialStagingRec.CCU320F_CONTACT_DFT_NUMBER__c;

        if(initialStagingRec.CCU320F_CONTACT_DFT_NUMBER__c == 'Y')
            setPhone1AsDefault(finalStagingRec);

        if (initialStagingRec.CCU320F_NBR_TYPE__c == 'HPG' || initialStagingRec.CCU320F_NBR_TYPE__c == 'HPH') {
            finalStagingRec.Phone1_Type__c = 'Home';
        } else if (initialStagingRec.CCU320F_NBR_TYPE__c == 'HMB' || initialStagingRec.CCU320F_NBR_TYPE__c == 'WMB' || initialStagingRec.CCU320F_NBR_TYPE__c == 'TXT') {
            finalStagingRec.Phone1_Type__c = 'Mobile';
        } else if (initialStagingRec.CCU320F_NBR_TYPE__c == 'WPG' || initialStagingRec.CCU320F_NBR_TYPE__c == 'WPH') {
            finalStagingRec.Phone1_Type__c = 'Work';
        }
    }
@TestVisible

    private void updatePhone2Info(Contact_Final_Staging__c finalStagingRec, AOPS_Contact_Phone__c initialStagingRec) {
        finalStagingRec.Phone2_AOPS_Seq__c = initialStagingRec.CCU320F_PHONE_SEQ__c;
        finalStagingRec.Phone2__c = initialStagingRec.CCU320F_AREA_CODE__c + initialStagingRec.CCU320F_PREFIX__c +initialStagingRec.CCU320F_NUMBER__c;
        finalStagingRec.Phone_2_Ext__c = initialStagingRec.CCU320F_EXTENSION__c;
        finalStagingRec.Default_Phone2__c = initialStagingRec.CCU320F_CONTACT_DFT_NUMBER__c;
        if(initialStagingRec.CCU320F_CONTACT_DFT_NUMBER__c == 'Y') {
            setPhone2AsDefault(finalStagingRec);
        }
        if (initialStagingRec.CCU320F_NBR_TYPE__c == 'HPG' || initialStagingRec.CCU320F_NBR_TYPE__c == 'HPH') {
            finalStagingRec.Phone2_Type__c = 'Home';
        } else if (initialStagingRec.CCU320F_NBR_TYPE__c == 'HMB' || initialStagingRec.CCU320F_NBR_TYPE__c == 'WMB' || initialStagingRec.CCU320F_NBR_TYPE__c == 'TXT') {
            finalStagingRec.Phone2_Type__c = 'Mobile';
        } else if (initialStagingRec.CCU320F_NBR_TYPE__c == 'WPG' || initialStagingRec.CCU320F_NBR_TYPE__c == 'WPH') {
            finalStagingRec.Phone2_Type__c = 'Work';
        }
    }
    @TestVisible

    private void updatePhone3Info(Contact_Final_Staging__c finalStagingRec, AOPS_Contact_Phone__c initialStagingRec) {
        finalStagingRec.Phone3_AOPS_Seq__c = initialStagingRec.CCU320F_PHONE_SEQ__c;
        finalStagingRec.phone3__c = initialStagingRec.CCU320F_AREA_CODE__c + initialStagingRec.CCU320F_PREFIX__c +initialStagingRec.CCU320F_NUMBER__c;
        finalStagingRec.Phone_3_Ext__c = initialStagingRec.CCU320F_EXTENSION__c;
        finalStagingRec.Default_Phone3__c = initialStagingRec.CCU320F_CONTACT_DFT_NUMBER__c;
        if(initialStagingRec.CCU320F_CONTACT_DFT_NUMBER__c == 'Y') {
            setPhone3AsDefault(finalStagingRec);
        } 
        if (initialStagingRec.CCU320F_NBR_TYPE__c == 'HPG' || initialStagingRec.CCU320F_NBR_TYPE__c == 'HPH') {
            finalStagingRec.Phone3_Type__c = 'Home';
        } else if (initialStagingRec.CCU320F_NBR_TYPE__c == 'HMB' || initialStagingRec.CCU320F_NBR_TYPE__c == 'WMB' || initialStagingRec.CCU320F_NBR_TYPE__c == 'TXT') {
            finalStagingRec.Phone3_Type__c = 'Mobile';
        } else if (initialStagingRec.CCU320F_NBR_TYPE__c == 'WPG' || initialStagingRec.CCU320F_NBR_TYPE__c == 'WPH') {
            finalStagingRec.Phone3_Type__c = 'Work';
        }
    }
@TestVisible

    private void removePhone1Info(Contact_Final_Staging__c finalStagingRec) {
        finalStagingRec.Phone1_AOPS_Seq__c = '';
        finalStagingRec.phone1__c = '';
        finalStagingRec.Phone_EXT__c = '';
        finalStagingRec.Default_Phone1__c = '';
        finalStagingRec.Phone1_Type__c = '';
    }
@TestVisible

    private void removePhone2Info(Contact_Final_Staging__c finalStagingRec) {
        finalStagingRec.Phone2_AOPS_Seq__c = '';
        finalStagingRec.phone2__c = '';
        finalStagingRec.Phone_2_Ext__c = '';
        finalStagingRec.Default_Phone2__c = '';
        finalStagingRec.Phone2_Type__c = '';
    }
@TestVisible

    private void removePhone3Info(Contact_Final_Staging__c finalStagingRec) {
        finalStagingRec.Phone3_AOPS_Seq__c = '';
        finalStagingRec.phone3__c = '';
        finalStagingRec.Phone_3_Ext__c = '';
        finalStagingRec.Default_Phone3__c = '';
        finalStagingRec.Phone3_Type__c = '';
    }
@TestVisible

    private void setPhone1AsDefault(Contact_Final_Staging__c finalStagingRec) {
        finalStagingRec.Default_Phone1__c = 'Y';
        finalStagingRec.Default_Phone2__c = 'N';
        finalStagingRec.Default_Phone3__c = 'N';
    }
@TestVisible

    private void setPhone2AsDefault(Contact_Final_Staging__c finalStagingRec) {
        finalStagingRec.Default_Phone1__c = 'N';
        finalStagingRec.Default_Phone2__c = 'Y';
        finalStagingRec.Default_Phone3__c = 'N';
    }
@TestVisible

    private void setPhone3AsDefault(Contact_Final_Staging__c finalStagingRec) {
        finalStagingRec.Default_Phone1__c = 'N';
        finalStagingRec.Default_Phone2__c = 'N';
        finalStagingRec.Default_Phone3__c = 'Y';
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

    private void markStagingRecordsWithSyncStatus(List<Contact_Final_Staging__c> successList, List<Contact_Final_Staging__c> failedList, List<AOPS_Contact_Phone__c> syncedStagingRecList) {
        
        Map<String, AOPS_Contact_Phone__c> syncedStagingRecMap = new Map<String, AOPS_Contact_Phone__c>();                
        Map<String, List<AOPS_Contact_Phone__c>> initialStageRecsSplitMap = splitInitialStageRecs(syncedStagingRecList);
        
        List<AOPS_Contact_Phone__c> clonedRecords = new List<AOPS_Contact_Phone__c>();
        
        for(Contact_Final_Staging__c finalStageRec : successList) {
            List<AOPS_Contact_Phone__c> initStageRecList = initialStageRecsSplitMap.get(finalStageRec.AOPS_Contact_Number__c);
            for (AOPS_Contact_Phone__c initStageRec : initStageRecList) {
                AOPS_Contact_Phone__c clonedRecord = new AOPS_Contact_Phone__c(Id=initStageRec.Id);
                clonedRecord.Record_Updated__c = false;
                clonedRecord.Sync_Status_Message__c = 'Success';
                clonedRecords.add(clonedRecord);
            }
        }
        String errorMsg = '';
        for(Contact_Final_Staging__c finalStageRec : failedList) {
            List<AOPS_Contact_Phone__c> initStageRecList = initialStageRecsSplitMap.get(finalStageRec.AOPS_Contact_Number__c);
            for (AOPS_Contact_Phone__c initStageRec : initStageRecList) {
                AOPS_Contact_Phone__c clonedRecord = new AOPS_Contact_Phone__c(Id=initStageRec.Id);
                errorMsg = syncFailedMessageMap.get(initStageRec.CCU320F_CONTACT_ID__c);
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

    private Map<String, List<AOPS_Contact_Phone__c>> splitInitialStageRecs(List<AOPS_Contact_Phone__c> syncedStagingRecList) {
        
        Map<String, List<AOPS_Contact_Phone__c>> splitInitStageRecsMap = new Map<String, List<AOPS_Contact_Phone__c>>();
        
        for (AOPS_Contact_Phone__c initStageRec : syncedStagingRecList) {
            List<AOPS_Contact_Phone__c> stageRecList = splitInitStageRecsMap.get(initStageRec.CCU320F_CONTACT_ID__c);
            if (stageRecList == null) {
                stageRecList = new List<AOPS_Contact_Phone__c>();
                splitInitStageRecsMap.put(initStageRec.CCU320F_CONTACT_ID__c, stageRecList);
            }
            stageRecList.add(initStageRec);
        }
        return splitInitStageRecsMap;
    }
}