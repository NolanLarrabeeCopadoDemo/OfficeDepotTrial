public class AOPSAddressMasterFinalProcessor implements Queueable {

	// The initial staging records that will be used to populate the final staging records.
    private List<AOPS_Address_Master__c> initialStagingRecs;
    private Map<String, String> syncFailedMessageMap;
    Set<String> stateValues;

    public AOPSAddressMasterFinalProcessor(List<AOPS_Address_Master__c> initialStagingRecs) {
        this.initialStagingRecs = initialStagingRecs;
        this.stateValues = new Set<String>();
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
            loadStateValues();
            // Generate final staging records to be updated.
            List<Account_Site_Final_Staging__c> finalStagingRecs = new List<Account_Site_Final_Staging__c>();
            for(AOPS_Address_Master__c initialStagingRec : initialStagingRecs) {
                Account_Site_Final_Staging__c finalStagingRec = getPopulatedFinalStagingRec(initialStagingRec);
                finalStagingRecs.add(finalStagingRec);
            }
            // Persist final staging record changes.
            Schema.SObjectField keyField = Account_Site_Final_Staging__c.Fields.AOPS_Seq_Id__c;               
            List<Database.UpsertResult> upsertResults = Database.upsert(finalStagingRecs, keyField, false);
            
            List<Account_Site_Final_Staging__c> stageRecSuccessList = getSuccessfulStagingRecList(upsertResults, finalStagingRecs);
            List<Account_Site_Final_Staging__c> stageRecFailedList = getFailedStagingRecList(upsertResults, finalStagingRecs);
            markStagingRecordsWithSyncStatus(stageRecSuccessList, stageRecFailedList, initialStagingRecs);
        } catch(Exception e) {
            Database.rollback(sp);
            System.debug(e.getMessage() + ' ' + e.getStackTraceString());
        }
    }

    private void loadStateValues() {
        List<Mapping__mdt> stateMappings = [SELECT Id, Abbreviation__c FROM Mapping__mdt WHERE Type__c = 'State'];
        for(Mapping__mdt mapping : stateMappings)
            stateValues.add(mapping.Abbreviation__c);
    }

    /**
     * Generates a final staging record and populates it with data from the initial staging record.
     */
    private Account_Site_Final_Staging__c getPopulatedFinalStagingRec(AOPS_Address_Master__c initialStagingRec) {
        Account_Site_Final_Staging__c finalStagingRec = new Account_Site_Final_Staging__c();
        finalStagingRec = finalStagingRec.clone(true, true, true, true);
        String aopsCustId = initialStagingRec.FCU001P_CUSTOMER_ID__c.leftPad(8, '0');
        finalStagingRec.AOPS_Cust_Id__c = aopsCustId;
		finalStagingRec.AOPS_Seq_ID__c = aopsCustId + '-' +initialStagingRec.FCU001P_ADDRESS_SEQ__c.leftPad(5, '0');
        finalStagingRec.FCU001P_ADDRESS_SEQ__c = initialStagingRec.FCU001P_ADDRESS_SEQ__c.leftPad(5, '0');
        finalStagingRec.Address_Key__c = initialStagingRec.FCU001P_ADDRESS_KEY__c;
        finalStagingRec.CXTF001P_SFDC_KEY1__c = initialStagingRec.CXTF001P_SFDC_KEY1__c;
        finalStagingRec.CXTF001P_SFDC_KEY2__c = initialStagingRec.CXTF001P_SFDC_KEY2__c;
        finalStagingRec.Account_Name__c = initialStagingRec.FCU001P_BUSINESS_NAME__c;
        finalStagingRec.Address1__c = initialStagingRec.FCU001P_STREET_ADDRESS1__c;
        finalStagingRec.Address2__c = initialStagingRec.FCU001P_STREET_ADDRESS2__c;
        finalStagingRec.City__c = initialStagingRec.FCU001P_CITY__c;
        finalStagingRec.State__c = stateValues.contains(initialStagingRec.FCU001P_STATE__c) ? initialStagingRec.FCU001P_STATE__c : null;
        String zip = initialStagingRec.FCU001P_ZIP__c;
        if (String.isNotEmpty(zip) && zip.isNumeric()) {
            finalStagingRec.Zip__c = initialStagingRec.FCU001P_ZIP__c;
        }        
        String country = initialStagingRec.FCU001P_COUNTRY_CODE__c;
        if (String.isNotEmpty(country) && (country.toUpperCase() == 'USA' || country.toUpperCase() == 'CAN')) {
            finalStagingRec.Country__c = initialStagingRec.FCU001P_COUNTRY_CODE__c;    
        }  
        finalStagingRec.ShipTo_Status__c = initialStagingRec.FCU001P_SHIPTO_STS__c;
		finalStagingRec.Date_Status_Modified__c = initialStagingRec.FCU001P_DATE_STS_MOD__c;
        finalStagingRec.Bill_To__c = initialStagingRec.FCU001P_BILL_TO_YN__c;
		finalStagingRec.Ship_To__c = initialStagingRec.FCU001P_SHIP_TO_YN__c;
        finalStagingRec.Mail_To__c = initialStagingRec.FCU001P_MAIL_TO_YN__c;
        finalStagingRec.County__c = initialStagingRec.CXTF001P_COUNTY__c;
        finalStagingRec.Action__c = initialStagingRec.CXTF001P_ACTION__c;
        finalStagingRec.Is_Address_Master_Changed__c = true;
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
    
    private void markStagingRecordsWithSyncStatus(List<Account_Site_Final_Staging__c> successList, List<Account_Site_Final_Staging__c> failedList, List<AOPS_Address_Master__c> syncedStagingRecList) {
        
        Map<String, AOPS_Address_Master__c> syncedStagingRecMap = new Map<String, AOPS_Address_Master__c>();
        
        for (AOPS_Address_Master__c afs : syncedStagingRecList) {
            syncedStagingRecMap.put(afs.FCU001P_CUSTOMER_ID__c.leftPad(8, '0') + afs.FCU001P_ADDRESS_SEQ__c.leftPad(5, '0'), afs);
        }
        
        List<AOPS_Address_Master__c> clonedRecords = new List<AOPS_Address_Master__c>();        
        AOPS_Address_Master__c stagingRec;
        
        for(Account_Site_Final_Staging__c stageRec : successList) {
            stagingRec = syncedStagingRecMap.get(stageRec.AOPS_Cust_Id__c + stageRec.FCU001P_ADDRESS_SEQ__c);
            AOPS_Address_Master__c clonedRecord = new AOPS_Address_Master__c(Id=stagingRec.Id);
            clonedRecord.Record_Updated__c = false;
            clonedRecord.Sync_Status_Message__c = 'Success';
            clonedRecords.add(clonedRecord);
        }
        String errorMsg = '';
        for(Account_Site_Final_Staging__c stageRec : failedList) {
            stagingRec = syncedStagingRecMap.get(stageRec.AOPS_Cust_Id__c + stageRec.FCU001P_ADDRESS_SEQ__c);
            AOPS_Address_Master__c clonedRecord = new AOPS_Address_Master__c(Id=stagingRec.Id);
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