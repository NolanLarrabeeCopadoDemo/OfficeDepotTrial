public class AOPSSyncFinalStagingToOptInOut {

    List<Contact_Final_Staging__c> stagingRecordsToSync; // The staging records that have changed to be synced.
    private Map<String, Contact_Final_Staging__c> stagingRecsMap; // The staging records mapped by their contact number.
    List<Contact_Final_Staging__c> syncedStagingRecords;
    List<Contact_Final_Staging__c> failedStagingRecords;
    List<AOPSContactOptInOut__c> optInOutRecsToInsert;
    List<AOPSContactOptInOut__c> optInOutRecsToUpdate;

    public AOPSSyncFinalStagingToOptInOut(List<Contact_Final_Staging__c> stagingRecs) {
        this.stagingRecordsToSync = getStagingRecordsWithOptInOutChanges(stagingRecs);
        this.stagingRecsMap = new Map<String, Contact_Final_Staging__c>();
        this.syncedStagingRecords = new List<Contact_Final_Staging__c>();
        this.failedStagingRecords = new List<Contact_Final_Staging__c>();
        this.optInOutRecsToInsert = new List<AOPSContactOptInOut__c>();
        this.optInOutRecsToUpdate = new List<AOPSContactOptInOut__c>();
    }

    /**
     * Filters the list of staging records to include only those with
     * changes relevant to OptInOut records Returns the filtered list.
     */
    private List<Contact_Final_Staging__c> getStagingRecordsWithOptInOutChanges(List<Contact_Final_Staging__c> stagingRecs) {
        List<Contact_Final_Staging__c> stagingRecordsWithChanges = new List<Contact_Final_Staging__c>();
        for(Contact_Final_Staging__c stagingRec : stagingRecs) {
            if(stagingRec.Is_Contact_OptIn_Changed__c == true || stagingRec.Is_Contact_Phone_Changed__c == true || stagingRec.Is_Contact_Email_Changed__c == true) {
                stagingRecordsWithChanges.add(stagingRec);
            }
        }
        return stagingRecordsWithChanges;
    }

    public List<Contact_Final_Staging__c> getSyncedStagingRecs() {
        return syncedStagingRecords;
    }

    public List<Contact_Final_Staging__c> getFailedStagingRecs() {
        return failedStagingRecords;
    }

    /**
     * Syncs the staging records to corresponding OptInOut records.
     */
    public void sync() {
        mapStagingRecsByContactNumber();
        generateOptInOutRecords();
        upsertOptInOutRecords();
    }

    private void mapStagingRecsByContactNumber() {
        for(Contact_Final_Staging__c stagingRec : stagingRecordsToSync) {
            stagingRecsMap.put(stagingRec.AOPS_Contact_Number__c, stagingRec);
        }
    }

    /**
     * Divides the staging records into OptInOut records that need to be inserted and
     * updated. Populates the OptInOut records with information from the staging records.
     */
    private void generateOptInOutRecords() {
        Map<String, AOPSContactOptInOut__c> existingOptInOutRecs = getExistingOptInOutMappedByContactNumber();
        Map<String, Contact> existingContacts = getExistingContactsMappedByContactNumber();
        
        for(Contact_Final_Staging__c stagingRec : stagingRecordsToSync) {
            AOPSContactOptInOut__c optInOut = existingOptInOutRecs.get(stagingRec.AOPS_Contact_Number__c);
            Contact cntct = existingContacts.get(stagingRec.AOPS_Contact_Number__c);
            // We don't move forward with the sync if there is no corresponding Contact.
            if(cntct == null) continue;

            if(optInOut != null) {
                optInOutRecsToUpdate.add(populateOptInOut(optInOut, stagingRec, cntct));
            } else {
                AOPSContactOptInOut__c voptin = new AOPSContactOptInOut__c();
                Datetime optdt = cntct.CreatedDate;
                if(cntct.Legacy_CreatedDate__c != null)
                  {
                      optdt=cntct.Legacy_CreatedDate__c;
                  }
                voptin.Email_1_Opt_Date__c = optdt;
                voptin.Email_2_Opt_Date__c = optdt;
                voptin.Email_3_Opt_Date__c = optdt;
                
                
                optInOutRecsToInsert.add(populateOptInOut(voptin, stagingRec, cntct));
            }
        }
    }

    /**
     * Retrieves OptInOut records corresponding to the staging records.
     * Then maps them by the AOPS Contact Number of their related Contacts.
     */
    private Map<String, AOPSContactOptInOut__c> getExistingOptInOutMappedByContactNumber() {
        Set<String> contactNumbers = getContactNumbersFromStagingRecords();
        List<AOPSContactOptInOut__c> existingOptInOutRecs = [SELECT Id, Email_1_AOPS__c, Email_1_OptIn_AOPS__c, Email_2_AOPS__c, Email_2_OptIn_AOPS__c,
                            Email_3_AOPS__c, Email_3_OptIn_AOPS__c, Phone_1_AOPS__c, Phone_1_OptIn_AOPS__c, Phone_2_AOPS__c, Phone_2_OptIn_AOPS__c,
                            Phone_3_AOPS__c, Phone_3_OptIn_AOPS__c, M_OptIn1__c, M_OptIn2__c, M_OptIn3__c, AOPS_Contact_Number__c, Contact_ID__r.AOPS_Contact_Number__c, Mail_OptIn_AOPS__c
                            FROM AOPSContactOptInOut__c WHERE Contact_ID__r.AOPS_Contact_Number__c IN: contactNumbers];

        Map<String, AOPSContactOptInOut__c> optInOutRecsMappedByContactNumber = new Map<String, AOPSContactOptInOut__c>();
        for(AOPSContactOptInOut__c optInOut : existingOptInOutRecs)
            optInOutRecsMappedByContactNumber.put(optInOut.Contact_ID__r.AOPS_Contact_Number__c, optInOut);
        return optInOutRecsMappedByContactNumber;
    }

    /**
     * Retrieves Contacts corresponding to the staging records.
     * Then maps them by their AOPS Contact Numbers.
     */
    private Map<String, Contact> getExistingContactsMappedByContactNumber() {
        Set<String> contactNumbers = getContactNumbersFromStagingRecords();
        List<Contact> cntcts = [SELECT Id, AOPS_Contact_Number__c, Legacy_CreatedDate__c,CreatedDate FROM Contact WHERE AOPS_Contact_Number__c IN: contactNumbers];

        Map<String, Contact> contactsMappedByContactNumber = new Map<String, Contact>();
        for(Contact cntct : cntcts)
            contactsMappedByContactNumber.put(cntct.AOPS_Contact_Number__c, cntct);
        return contactsMappedByContactNumber;
    }

    private Set<String> getContactNumbersFromStagingRecords() {
        Set<String> contactNumbers = new Set<String>();
        for(Contact_Final_Staging__c stagingRec : stagingRecordsToSync)
            contactNumbers.add(stagingRec.AOPS_Contact_Number__c);
        return contactNumbers;
    }

    /**
     * Populates an OptInOut record with data from the staging record and the Contact.
     */
    private AOPSContactOptInOut__c populateOptInOut(AOPSContactOptInOut__c optInOut, Contact_Final_Staging__c stagingRec, Contact cntct) {
        if(optInOut.Contact_ID__c == null) optInOut.Contact_ID__c = cntct.Id;
        if(stagingRec.Is_Contact_Phone_Changed__c == true) setOptInOutPhoneFields(optInOut, stagingRec);
        if(stagingRec.Is_Contact_Email_Changed__c == true) setOptInOutEmailFields(optInOut, stagingRec);
        // Note that this must go last, to overwrite any defaults set in the previous methods.
        if(stagingRec.Is_Contact_OptIn_Changed__c == true) setOptInOutFields(optInOut, stagingRec);

        if(String.isBlank(optInOut.AOPS_Contact_Number__c)) optInOut.AOPS_Contact_Number__c = stagingRec.AOPS_Contact_Number__c;

        return optInOut;
    }

    private void setOptInOutFields(AOPSContactOptInOut__c optInOut, Contact_Final_Staging__c stagingRec) {
        

        if(stagingRec.E_OptIn1__c != null && stagingRec.E_OptIn1__c != optInOut.Email_1_OptIn_AOPS__c) {
            optInOut.Email_1_OptIn_AOPS__c = stagingRec.E_OptIn1__c;
            optInOut.Email_1_Opt_Date__c = stagingRec.Email_OptIn_Change_Timestamp__c;
        } 
        if(stagingRec.E_OptIn2__c != null && stagingRec.E_OptIn2__c != optInOut.Email_2_OptIn_AOPS__c) {
            optInOut.Email_2_OptIn_AOPS__c = stagingRec.E_OptIn2__c;
            optInOut.Email_2_Opt_Date__c = stagingRec.Email_OptIn_Change_Timestamp__c;
        }
        if(stagingRec.E_OptIn3__c != null && stagingRec.E_OptIn3__c != optInOut.Email_3_OptIn_AOPS__c) {
            optInOut.Email_3_OptIn_AOPS__c = stagingRec.E_OptIn3__c;
            optInOut.Email_3_Opt_Date__c = stagingRec.Email_OptIn_Change_Timestamp__c;
        }
        if(stagingRec.P_OptIn1__c != null && stagingRec.P_OptIn1__c != optInOut.Phone_1_OptIn_AOPS__c) {
            optInOut.Phone_1_OptIn_AOPS__c = stagingRec.P_OptIn1__c;
            optInOut.Phone_1_Opt_Date__c = stagingRec.Phone_OptIn_Change_Timestamp__c;
        }
        if(stagingRec.P_OptIn2__c != null && stagingRec.P_OptIn2__c != optInOut.Phone_2_OptIn_AOPS__c) {
            optInOut.Phone_2_OptIn_AOPS__c = stagingRec.P_OptIn2__c;
            optInOut.Phone_2_Opt_Date__c = stagingRec.Phone_OptIn_Change_Timestamp__c;
        }
        if(stagingRec.P_OptIn3__c != null && stagingRec.P_OptIn3__c != optInOut.Phone_3_OptIn_AOPS__c) {
            optInOut.Phone_3_OptIn_AOPS__c = stagingRec.P_OptIn3__c;
            optInOut.Phone_3_Opt_Date__c = stagingRec.Phone_OptIn_Change_Timestamp__c;
        }
        /* Mobile opt-in is out of scope for now.
        if(stagingRec.M_OptIn1__c != null) {
            optInOut.M_OptIn1__c = stagingRec.M_OptIn1__c;
            optInOut.Mobile_1_Opt_Date__c = stagingRec.Mobile_OptIn_Change_Timestamp__c;
        }
        if(stagingRec.M_OptIn2__c != null) {
            optInOut.M_OptIn2__c = stagingRec.M_OptIn2__c;
            optInOut.Mobile_2_Opt_Date__c = stagingRec.Mobile_OptIn_Change_Timestamp__c;
        }
        if(stagingRec.M_OptIn3__c != null) {
            optInOut.M_OptIn3__c = stagingRec.M_OptIn3__c;
            optInOut.Mobile_3_Opt_Date__c = stagingRec.Mobile_OptIn_Change_Timestamp__c;
        }
        */
        if(stagingRec.Mail_OptIn__c != null && stagingRec.Mail_OptIn__c != optInOut.Mail_OptIn_AOPS__c) {
            optInOut.Mail_OptIn_AOPS__c = stagingRec.Mail_OptIn__c;
            optInOut.Mail_Opt_Date__c = stagingRec.Mail_OptIn_Change_Timestamp__c;
        }

    }


    private void setOptInOutPhoneFields(AOPSContactOptInOut__c optInOut, Contact_Final_Staging__c stagingRec) {
        optInOut.Default_Phone_1_AOPS__c = stagingRec.Default_Phone1__c;
        optInOut.Default_Phone_2_AOPS__c = stagingRec.Default_Phone2__c;
        optInOut.Default_Phone_3_AOPS__c = stagingRec.Default_Phone3__c;
        
        if(optInOut.Phone_1_AOPS__c != stagingRec.Phone1__c) { // Set default if necessary.
            //optInOut.Phone_1_OptIn_AOPS__c = 'Y';
            //optInOut.M_OptIn1__c = 'Y';
            optInOut.Phone_1_Opt_Date__c = Datetime.now();
            //optInOut.Mobile_1_Opt_Date__c = Datetime.now();
        }
        optInOut.Phone_1_AOPS__c = stagingRec.Phone1__c;
        optInOut.Phone_1_AOPS_Seq__c = stagingRec.Phone1_AOPS_Seq__c;
        optInOut.Phone_1_Ext_AOPS__c = stagingRec.Phone_EXT__c;
        optInOut.Phone_1_Type_AOPS__c = stagingRec.Phone1_Type__c;

        if(optInOut.Phone_2_AOPS__c != stagingRec.Phone2__c) { // Set default if necessary.
            //optInOut.Phone_2_OptIn_AOPS__c = 'Y';
            //optInOut.M_OptIn2__c = 'Y';
            optInOut.Phone_2_Opt_Date__c = Datetime.now();
            //optInOut.Mobile_2_Opt_Date__c = Datetime.now();
        }
        optInOut.Phone_2_AOPS__c = stagingRec.Phone2__c;
        optInOut.Phone_2_AOPS_Seq__c = stagingRec.Phone2_AOPS_Seq__c;
        optInOut.Phone_2_Ext_AOPS__c = stagingRec.Phone_2_Ext__c;
        optInOut.Phone_2_Type_AOPS__c = stagingRec.Phone2_Type__c;

        if(optInOut.Phone_3_AOPS__c != stagingRec.Phone3__c) { // Set default if necessary.
            //optInOut.Phone_3_OptIn_AOPS__c = 'Y';
            //optInOut.M_OptIn3__c = 'Y';
            optInOut.Phone_3_Opt_Date__c = Datetime.now();
            //optInOut.Mobile_3_Opt_Date__c = Datetime.now();
        }
        optInOut.Phone_3_AOPS__c = stagingRec.Phone3__c;
        optInOut.Phone_3_AOPS_Seq__c = stagingRec.Phone3_AOPS_Seq__c;
        optInOut.Phone_3_Ext_AOPS__c = stagingRec.Phone_3_Ext__c;
        optInOut.Phone_3_Type_AOPS__c = stagingRec.Phone3_Type__c;
    }

    private void setOptInOutEmailFields(AOPSContactOptInOut__c optInOut, Contact_Final_Staging__c stagingRec) {
        optInOut.Default_Email_1_AOPS__c = stagingRec.Default_Email1__c;
        optInOut.Default_Email_2_AOPS__c = stagingRec.Default_Email2__c;
        optInOut.Default_Email_3_AOPS__c = stagingRec.Default_Email3__c;

        if(optInOut.Email_1_AOPS__c != stagingRec.Email1__c) { // Set default if necessary.
            //optInOut.Email_1_OptIn_AOPS__c = 'Y';
          //  optInOut.Email_1_Opt_Date__c = Datetime.now();
        }
        optInOut.Email_1_AOPS__c = stagingRec.Email1__c;
        optInOut.Email_1_AOPS_Seq__c = stagingRec.Email1_AOPS_Seq__c;
        optInOut.Email_1_Type_AOPS__c = stagingRec.Email1_Type__c;

        if(optInOut.Email_2_AOPS__c != stagingRec.Email2__c) { // Set default if necessary.
            //optInOut.Email_2_OptIn_AOPS__c = 'Y';
          //  optInOut.Email_2_Opt_Date__c = Datetime.now();
        }
        optInOut.Email_2_AOPS__c = stagingRec.Email2__c;
        optInOut.Email_2_AOPS_Seq__c = stagingRec.Email2_AOPS_Seq__c;
        optInOut.Email_2_Type_AOPS__c = stagingRec.Email2_Type__c;

        if(optInOut.Email_3_AOPS__c != stagingRec.Email3__c) { // Set default if necessary.
            //optInOut.Email_3_OptIn_AOPS__c = 'Y';
           // optInOut.Email_3_Opt_Date__c = Datetime.now();
        }
        optInOut.Email_3_AOPS__c = stagingRec.Email3__c;
        optInOut.Email_3_AOPS_Seq__c = stagingRec.Email3_AOPS_Seq__c;
        optInOut.Email_3_Type_AOPS__c = stagingRec.Email3_Type__c;
    }

    /**
     * Persists the OptInOut records.
     */
    private void upsertOptInOutRecords() {
        Database.DMLOptions options = new Database.DMLOptions();
        options.OptAllOrNone = false;
        if(optInOutRecsToInsert.size() > 0) {
            Database.SaveResult[] insertResults = Database.insert(optInOutRecsToInsert, options);
            addToSyncResults(insertResults, optInOutRecsToInsert);
        }
        if(optInOutRecsToUpdate.size() > 0) {
            Database.SaveResult[] insertResults = Database.update(optInOutRecsToUpdate, options);
            addToSyncResults(insertResults, optInOutRecsToUpdate);
        }
    }

    private void addToSyncResults(Database.SaveResult[] saveResults, List<AOPSContactOptInOut__c> correspondingOptInOuts) {
        for(Integer i = 0; i < saveResults.size(); i++) {
            Contact_Final_Staging__c finalStagingRec = stagingRecsMap.get(correspondingOptInOuts[i].AOPS_Contact_Number__c);
            if(saveResults[i].isSuccess()) {
                syncedStagingRecords.add(finalStagingRec);
            } else {
                addToFailureList(finalStagingRec, getFailureMessage(saveResults[i]));
            }
        }
    }

    private String getFailureMessage(Database.SaveResult result) {
        String err = '';
        for(Database.Error e : result.getErrors()) {
            if(String.isBlank(err) == false) err += ' ';
            err += e.getMessage();
        }
        return err;
    }

    private void addToFailureList(Contact_Final_Staging__c finalStagingRec, String errorMessage) {
        Contact_Final_Staging__c clonedRec = new Contact_Final_Staging__c(Id=finalStagingRec.Id);
        clonedRec.Contact_Sync_Message__c = errorMessage;
        failedStagingRecords.add(clonedRec);
    }
}