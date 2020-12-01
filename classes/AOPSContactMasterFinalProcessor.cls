public class AOPSContactMasterFinalProcessor implements Queueable {

	// The initial staging records that will be used to populate the final staging records.
    private List<AOPS_STG_CONTACT_MASTER__c> initialStagingRecs;
    Map<String, String> syncFailedMessageMap;

    public AOPSContactMasterFinalProcessor(List<AOPS_STG_CONTACT_MASTER__c> initialStagingRecs) {
        this.initialStagingRecs = initialStagingRecs;
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
            // Generate final staging records to be updated.
            List<Contact_Final_Staging__c> finalStagingRecs = new List<Contact_Final_Staging__c>();
            for(AOPS_STG_CONTACT_MASTER__c initialStagingRec : initialStagingRecs) {
                Contact_Final_Staging__c finalStagingRec = getPopulatedFinalStagingRec(initialStagingRec);
                finalStagingRecs.add(finalStagingRec);
            }
            // Persist final staging record changes.
            Schema.SObjectField keyField = Contact_Final_Staging__c.Fields.Unique_Record_ID__c;
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

    /**
     * Generates a final staging record and populates it with data from the initial staging record.
     */
    @TestVisible

    private Contact_Final_Staging__c getPopulatedFinalStagingRec(AOPS_STG_CONTACT_MASTER__c initialStagingRec) {
        Contact_Final_Staging__c finalStagingRec = new Contact_Final_Staging__c();
        finalStagingRec.AOPS_Contact_Number__c = initialStagingRec.CCU300F_CONTACT_ID__c;
        finalStagingRec.AOPS_Account_Number__c = initialStagingRec.CCU300F_CUSTOMER_ID__c.leftPad(8, '0');
        finalStagingRec.Unique_Record_ID__c = finalStagingRec.AOPS_Account_Number__c + finalStagingRec.AOPS_Contact_Number__c;
        finalStagingRec.Default_Shipto__c = initialStagingRec.CCU300F_DFT_SHIP_ADDR__c;
        finalStagingRec.Default_Mailto__c = initialStagingRec.CCU300F_DFT_MAIL_ADDR__c;
        finalStagingRec.First_Name__c = initialStagingRec.CCU300F_NAME_1__c;
        finalStagingRec.Last_Name__c = String.isBlank(initialStagingRec.CCU300F_NAME_2__c) ? '-' : initialStagingRec.CCU300F_NAME_2__c;
        finalStagingRec.Middle_Name_Initial__c = initialStagingRec.CCU300F_MID_INITIAL__c;
        finalStagingRec.Salutation__c = initialStagingRec.CCU300F_SALUTATION__c;
        finalStagingRec.Contact_Type__c = initialStagingRec.CCU300F_TYPE__c;
        if (initialStagingRec.CXTCNTM_ACTION__c == 'D') {
            finalStagingRec.Status__c = 'Delete';
        } else if (initialStagingRec.CCU300F_STATUS__c == 'A') {
            finalStagingRec.Status__c = 'Active';
        } else {
            finalStagingRec.Status__c = 'InActive';
        }
        finalStagingRec.Primary_Contact__c = false;
        if (initialStagingRec.CCU300F_CPY_PRIMARY_CONTACT__c == 'Y') {
            finalStagingRec.Primary_Contact__c = true;
        }
        
        finalStagingRec.Title__c = initialStagingRec.CCU300F_TITLE__c;
        //finalStagingRec.Role__c = initialStagingRec.CCU300F_ROLE_1__c;
        finalStagingRec.AOPS_Role__c = initialStagingRec.CCU300F_ROLE_1__c;
        finalStagingRec.Authorized_Buyer__c = initialStagingRec.CCU300F_AUTH_BUYER_YN__c;
        finalStagingRec.Polybag_Green__c = initialStagingRec.CCU300F_POLYBAG_FLAG__c;
        finalStagingRec.Min_Order_Value_Ind__c = initialStagingRec.CCU300F_RSV_2CHAR__c;
        finalStagingRec.Contact_Master_Action__c = initialStagingRec.CXTCNTM_ACTION__c;
        finalStagingRec.Sync_Failed__c = false;
        finalStagingRec.Is_Contact_Master_Changed__c = true;

        if (initialStagingRec.CCU300F_CREATE_DT__c != null) {
            Datetime dt = Date.valueOf(initialStagingRec.CCU300F_CREATE_DT__c);
            String convertedZone = dt.format('yyyy-MM-dd HH:mm:ss', 'GMT');
            finalStagingRec.Legacy_CreatedDate__c = Datetime.valueOf(convertedZone);
        }

        if (initialStagingRec.CXTCNTM_ACTION__c == 'C') {
            // Set defaults on contact creation
            finalStagingRec.Mail_OptIn__c = 'Y';
            finalStagingRec.M_OptIn1__c = 'N';
            finalStagingRec.M_OptIn2__c = 'N';
            finalStagingRec.M_OptIn3__c = 'N';
        
            finalStagingRec.P_OptIn1__c = 'Y';
            finalStagingRec.P_OptIn2__c = 'Y';
            finalStagingRec.P_OptIn3__c = 'Y';

            finalStagingRec.E_OptIn1__c = 'Y';
            finalStagingRec.E_OptIn2__c = 'Y';
            finalStagingRec.E_OptIn3__c = 'Y';
        }

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

    private void markStagingRecordsWithSyncStatus(List<Contact_Final_Staging__c> successList, List<Contact_Final_Staging__c> failedList, List<AOPS_Stg_Contact_Master__c> syncedStagingRecList) {
        
        Map<String, AOPS_Stg_Contact_Master__c> syncedStagingRecMap = new Map<String, AOPS_Stg_Contact_Master__c>();
        
        for (AOPS_Stg_Contact_Master__c afs : syncedStagingRecList) {
            syncedStagingRecMap.put(afs.CCU300F_CONTACT_ID__c, afs);
        }
        
        List<AOPS_Stg_Contact_Master__c> clonedRecords = new List<AOPS_Stg_Contact_Master__c>();        
        AOPS_Stg_Contact_Master__c stagingRec;
        
        for(Contact_Final_Staging__c stageRec : successList) {
            stagingRec = syncedStagingRecMap.get(stageRec.AOPS_Contact_Number__c);
            AOPS_Stg_Contact_Master__c clonedRecord = new AOPS_Stg_Contact_Master__c(Id=stagingRec.Id);
            clonedRecord.Record_Updated__c = false;
            clonedRecord.Sync_Status_Message__c = 'Success';
            clonedRecords.add(clonedRecord);
        }
        
        String errorMsg;
        for(Contact_Final_Staging__c stageRec : failedList) {
            stagingRec = syncedStagingRecMap.get(stageRec.AOPS_Contact_Number__c);
            AOPS_Stg_Contact_Master__c clonedRecord = new AOPS_Stg_Contact_Master__c(Id=stagingRec.Id);
            // clonedRecord.Record_Updated__c = true;
            errorMsg = syncFailedMessageMap.get(stageRec.AOPS_Contact_Number__c);
            
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