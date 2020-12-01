public class AOPSAccountMasterFinalProcessor implements Queueable {

    // The initial staging records that will be used to populate the final staging records.
    private List<AOPS_Account_Master__c> initialStagingRecs;
    private Map<String, String> segmentMappings;
    private Map<String, String> syncFailedMessageMap;
    Set<String> stateValues;

    public AOPSAccountMasterFinalProcessor(List<AOPS_Account_Master__c> initialStagingRecs) {
        this.initialStagingRecs = initialStagingRecs;
        this.segmentMappings = new Map<String, String>();
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
            retrieveMappingMetadata();
            // Generate final staging records to be updated.
            List<Account_Final_Staging__c> finalStagingRecs = new List<Account_Final_Staging__c>();
            for(AOPS_Account_Master__c initialStagingRec : initialStagingRecs) {
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

    private void retrieveMappingMetadata() {
        // Load Segment mapping metadata.
        List<Mapping__mdt> segmentMappingMetadata = [SELECT Id, Name__c, Abbreviation__c FROM Mapping__mdt WHERE Type__c = 'Segment'];
        for(Mapping__mdt mapping : segmentMappingMetadata)
            segmentMappings.put(mapping.Abbreviation__c, mapping.Name__c);

        // Load state mapping metadata. We only need the abbreviation field, so a Set is sufficient, rather than a map.
        List<Mapping__mdt> stateMappings = [SELECT Id, Abbreviation__c FROM Mapping__mdt WHERE Type__c = 'State'];
        for(Mapping__mdt mapping : stateMappings)
            stateValues.add(mapping.Abbreviation__c);
    }

    /**
     * Generates a final staging record and populates it with data from the initial staging record.
     */
    private Account_Final_Staging__c getPopulatedFinalStagingRec(AOPS_Account_Master__c initialStagingRec) {
        Account_Final_Staging__c finalStagingRec = new Account_Final_Staging__c();
        finalStagingRec = finalStagingRec.clone(true, true, true, true);
        finalStagingRec.AOPS_Cust_Id__c = initialStagingRec.FCU000P_CUSTOMER_ID__c.leftPad(8, '0');
        String sfdcKey1 = initialStagingRec.CXTF000P_SFDC_KEY1__c;
        if (String.isNotEmpty(sfdcKey1)) {
        	finalStagingRec.CXTF005P_SFDC_KEY1__c = sfdcKey1.trim();    
        }
        finalStagingRec.CONTRACT_RETAIL_CUST_CODE__c = initialStagingRec.FCU000P_CONT_RETAIL_CODE__c;
        finalStagingRec.Name = initialStagingRec.FCU000P_BUSINESS_NAME__c;
        finalStagingRec.Address1__c = initialStagingRec.FCU000P_STREET_ADDRESS1__c;
        finalStagingRec.Address2__c = initialStagingRec.FCU000P_STREET_ADDRESS2__c;
        finalStagingRec.City__c = initialStagingRec.FCU000P_CITY__c;
        finalStagingRec.State__c = stateValues.contains(initialStagingRec.FCU000P_STATE__c) ? initialStagingRec.FCU000P_STATE__c : null;
        finalStagingRec.Zip__c = initialStagingRec.FCU000P_ZIP__c;
        finalStagingRec.Country__c = initialStagingRec.FCU000P_COUNTRY_CODE__c;
        finalStagingRec.AOPS_Seq_ID__c = initialStagingRec.FCU000P_ADDRESS_SEQ__c;
        finalStagingRec.Tax_Exempt__c = initialStagingRec.FCU000P_TAX_EXEMPT_TYPE__c;
        finalStagingRec.Hierarchy__c = initialStagingRec.FCU000P_FAMILY_TYPE__c;
        finalStagingRec.GSA__c = initialStagingRec.FCU000P_RSV_1CHAR_2__c;
        if (initialStagingRec.FCU000P_DELETE_FLAG__c == 'P' || initialStagingRec.FCU000P_DELETE_FLAG__c == 'I') {
            finalStagingRec.Status__c = 'Inactive';
        } else {
            finalStagingRec.Status__c = 'Active';
        }
        if (initialStagingRec.FCU000P_CUST_TYPE__c == 'RG') { // Need to map two more values.
        	finalStagingRec.Loyalty_Type__c = 'Regular - No Loyalty Flag';
        } 
        
        // Need to map AOPS values to SFDC for segment.
        String segment = initialStagingRec.FCU000P_CUST_SUBTYPE__c;
        finalStagingRec.Segment__c = segmentMappings.get(segment); 
        //finalStagingRec.Sector__c = initialStagingRec.FCU000P_CUST_SUBTYPE__c; 
        //finalStagingRec.Deliver_Charge__c = initialStagingRec.FCU000P_RSV_2CHAR_2__c;
        String deliveryChargeFlag = initialStagingRec.FCU000P_RSV_2CHAR_2__c;
        if (deliveryChargeFlag == null || deliveryChargeFlag.substring(0,1) == '_' || deliveryChargeFlag.substring(0,1) == 'Y') {
            finalStagingRec.Deliver_Charge__c = 'Y';
        } else {
            finalStagingRec.Deliver_Charge__c = 'N';
        }

        String freightCharge = initialStagingRec.FCU000P_RSV_6CHAR_1__c;
        
        if (freightCharge == null || freightCharge.substring(4,5) == '_' || freightCharge.substring(4,5) == 'Y') {
            finalStagingRec.Freight_forwarder_account__c = 'Y';
        } else {
            finalStagingRec.Freight_forwarder_account__c = 'N';
        }
        
        if (initialStagingRec.FCU000P_CREATE_DATE__c != null) {// AOPS format to SFDC date.
            Datetime dt = Date.valueOf('1900-12-31').addDays(Integer.valueOf(initialStagingRec.FCU000P_CREATE_DATE__c));
            String convertedZone = dt.format('yyyy-MM-dd HH:mm:ss', 'GMT');
            finalStagingRec.Legacy_Created_Date__c = Datetime.valueOf(convertedZone);
        }
        finalStagingRec.Action__c = initialStagingRec.CXTF000P_ACTION__c;
        finalStagingRec.Sync_Failed__c = false;
        finalStagingRec.Is_Account_Master_Changed__c = true;
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
    
    private void markStagingRecordsWithSyncStatus(List<Account_Final_Staging__c> successList, List<Account_Final_Staging__c> failedList, List<AOPS_Account_Master__c> syncedStagingRecList) {
        
        Map<String, AOPS_Account_Master__c> syncedStagingRecMap = new Map<String, AOPS_Account_Master__c>();
        
        for (AOPS_Account_Master__c afs : syncedStagingRecList) {
            syncedStagingRecMap.put(afs.FCU000P_CUSTOMER_ID__c.leftPad(8, '0'), afs);
        }
        
        List<AOPS_Account_Master__c> clonedRecords = new List<AOPS_Account_Master__c>();        
        AOPS_Account_Master__c stagingRec;
        
        for(Account_Final_Staging__c stageRec : successList) {
            stagingRec = syncedStagingRecMap.get(stageRec.AOPS_Cust_Id__c);
            AOPS_Account_Master__c clonedRecord = new AOPS_Account_Master__c(Id=stagingRec.Id);
            clonedRecord.Record_Updated__c = false;
            clonedRecord.Sync_Status_Message__c = 'Success';
            clonedRecords.add(clonedRecord);
        }
        String errorMsg = '';
        for(Account_Final_Staging__c stageRec : failedList) {
            stagingRec = syncedStagingRecMap.get(stageRec.AOPS_Cust_Id__c);
            AOPS_Account_Master__c clonedRecord = new AOPS_Account_Master__c(Id=stagingRec.Id);
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