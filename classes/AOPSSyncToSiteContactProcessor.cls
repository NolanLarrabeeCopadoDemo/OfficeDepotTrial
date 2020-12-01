public class AOPSSyncToSiteContactProcessor {

    List<SiteContacts_Final_Staging__c> stagingRecordsToSync;
    private Map<String, SiteContacts_Final_Staging__c> stagingRecsMap; // The staging records mapped by their contact number.
    Map<String, Id> mappedAccountIds; // Accounts mapped by the AOPS sequence number.
    Map<String, Id> mappedContactIds; // Contacts mapped by the AOPS contact number.
    List<SiteContacts_Final_Staging__c> syncedStagingRecords;
    List<SiteContacts_Final_Staging__c> failedStagingRecords;
    List<SiteContacts__c> siteContactsToInsert;
    List<SiteContacts__c> siteContactsToUpdate;
    List<SiteContacts__c> siteContactsToDelete;

    public AOPSSyncToSiteContactProcessor(List<SiteContacts_Final_Staging__c> stagingRecordsToSync) {
        this.stagingRecordsToSync = getStagingRecsWithChanges(stagingRecordsToSync);
        this.stagingRecsMap = new Map<String, SiteContacts_Final_Staging__c>();
        this.mappedAccountIds = new Map<String, Id>();
        this.mappedContactIds = new Map<String, Id>();
        this.syncedStagingRecords = new List<SiteContacts_Final_Staging__c>();
        this.failedStagingRecords = new List<SiteContacts_Final_Staging__c>();
        this.siteContactsToInsert = new List<SiteContacts__c>();
        this.siteContactsToUpdate = new List<SiteContacts__c>();
        this.siteContactsToDelete = new List<SiteContacts__c>();
    }

    private List<SiteContacts_Final_Staging__c> getStagingRecsWithChanges(List<SiteContacts_Final_Staging__c> stagingRecs) {
        List<SiteContacts_Final_Staging__c> stagingRecsWithChanges = new List<SiteContacts_Final_Staging__c>();
        for(SiteContacts_Final_Staging__c stagingRec : stagingRecs) {
            if(stagingRec.Is_Changed__c)
                stagingRecsWithChanges.add(stagingRec);
        }
        return stagingRecsWithChanges;
    }

    public static Boolean isFailedRecord(SiteContacts_Final_Staging__c finalStagingRec) {
        return finalStagingRec.Sync_Failed__c;
    }

    /**
     * Syncs the staging records to the Site Contacts object.
     */
    public void sync() {
        Savepoint sp = Database.setSavepoint();
        try {
            // Must be called before divideStagingRecords.
            populateRecordMaps();
            divideStagingRecords();
            persistSiteContactChanges();
            markSyncStatus();
        } catch(Exception ex) {
            Database.rollback(sp);
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
            handleException(ex);
        }
    }

    private void populateRecordMaps() {
        mapStagingRecsByContactNumber();
        mapAccountIdsByAopsSequence();
        mapContactIdsByAopsNumber();
    }
    
    private void mapStagingRecsByContactNumber() {
        for(SiteContacts_Final_Staging__c stagingRec : stagingRecordsToSync) {
            stagingRecsMap.put(getStagingRecKey(stagingRec), stagingRec);
        }
    }

    /**
     * Queries the Accounts that should be associated with any new Site Contacts
     * (the ones being inserted) and then maps the Accounts by their AOPS Sequence IDs.
     */
    private void mapAccountIdsByAopsSequence() {
        Set<String> aopsSeqIds = new Set<String>();
        for(SiteContacts_Final_Staging__c stagingRec : stagingRecordsToSync)
            aopsSeqIds.add(getAopsSeqId(stagingRec));
        
        List<Account> accts = [SELECT Id, AOPS_Seq_ID__c FROM Account WHERE AOPS_Seq_ID__c IN: aopsSeqIds];
        for(Account acct : accts)
            mappedAccountIds.put(acct.AOPS_Seq_ID__c, acct.Id);
    }

    /**
     * Queries the Contacts that should be associated with any new Site Contacts
     * (the ones being inserted) and then maps the Contacts by their AOPS Contact Numbers.
     */
    private void mapContactIdsByAopsNumber() {
        Set<String> aopsNumbers = new Set<String>();
        for(SiteContacts_Final_Staging__c stagingRec : stagingRecordsToSync)
            aopsNumbers.add(stagingRec.AOPS_Contact_Number__c);

        List<Contact> cntcts = [SELECT Id, AOPS_Contact_Number__c FROM Contact WHERE AOPS_Contact_Number__c IN: aopsNumbers];
        for(Contact cntct : cntcts)
            mappedContactIds.put(cntct.AOPS_Contact_Number__c, cntct.Id);
    }

    /**
     * Divides the staging records into two Lists of Site Contacts, one for inserts and
     * one for updates. Also populates the Site Contacts with data from the staging records.
     */
    private void divideStagingRecords() {
        List<SiteContacts__c> possibleSiteContactMatches = getPossibleMatches();
        for(SiteContacts_Final_Staging__c stagingRec : stagingRecordsToSync) {
            try {
                SiteContacts__c matchingSiteContact = getMatch(stagingRec, possibleSiteContactMatches);
                if(stagingRec.Action__c == 'D') {
                    if(matchingSiteContact != null)
                        siteContactsToDelete.add(matchingSiteContact);
                } else if(matchingSiteContact != null) {
                    siteContactsToUpdate.add(populateSiteContact(matchingSiteContact, stagingRec));
                } else {
                    siteContactsToInsert.add(populateSiteContact(new SiteContacts__c(), stagingRec));
                }
            } catch(Exception e) {
                String errorMessage = e.getMessage();
                addToFailureList(stagingRec, errorMessage);
            }
        }
    }

    /**
     * Gets Site Contacts that may be matches for the staging records based on AOPS Sequence IDs and Contact Numbers.
     */
    private List<SiteContacts__c> getPossibleMatches() {
        Set<String> aopsSeqIds = getAopsSeqIds();
        Set<String> aopsContactNumbers = getAopsContactNumbers();
        List<SiteContacts__c> possibleMatches = [
                SELECT Id, Account__c, Account__r.AOPS_Seq_ID__c, Contact__c, AOPS_Contact_Number__c, AOPS_Account_Number__c, Contact__r.AOPS_Contact_Number__c, Shipto_Addr_Seq__c
                FROM SiteContacts__c
                WHERE Account__r.AOPS_Seq_ID__c IN: aopsSeqIds AND Contact__r.AOPS_Contact_Number__c IN: aopsContactNumbers
            ];
        return possibleMatches;
    }

    /**
     * Returns a Set of all AOPS Sequence IDs from the staging records.
     */
    private Set<String> getAopsSeqIds() {
        Set<String> aopsSeqIds = new Set<String>();
        for(SiteContacts_Final_Staging__c stagingRec : stagingRecordsToSync) {
            String aopsSeqId = getAopsSeqId(stagingRec);
            aopsSeqIds.add(aopsSeqId);
        }
        return aopsSeqIds;
    }

    /**
     * Returns a Set of all AOPS Contact Numbers from the staging records.
     */
    private Set<String> getAopsContactNumbers() {
        Set<String> aopsContactNumbers = new Set<String>();
        for(SiteContacts_Final_Staging__c stagingRec : stagingRecordsToSync) {
            aopsContactNumbers.add(stagingRec.AOPS_Contact_Number__c);
        }
        return aopsContactNumbers;
    }

    /**
     * Given a staging record and a List of Site Contacts, returns a Site Contact
     * that is a match for the staging record. If not match exists, returns null.
     */
    private SiteContacts__c getMatch(SiteContacts_Final_Staging__c stagingRec, List<SiteContacts__c> possibleSiteContactMatches) {
        for(SiteContacts__c siteContact : possibleSiteContactMatches) {
            String stagingRecAopsSeqId = getAopsSeqId(stagingRec);
            String stagingContactNum = stagingRec.AOPS_Contact_Number__c;
            if(siteContact.Account__r.AOPS_Seq_ID__c == stagingRecAopsSeqId && siteContact.Contact__r.AOPS_Contact_Number__c == stagingContactNum) {
                return siteContact;
            }
        }
        return null;
    }

    /**
     * Populates the given Site Contact with data from the staging record. Returns the Site Contact.
     */
    private SiteContacts__c populateSiteContact(SiteContacts__c siteContact, SiteContacts_Final_Staging__c stagingRec) {
        siteContact.Shipto_Addr_Seq__c = stagingRec.Shipto_Addr_Seq__c.leftPad(5, '0');
        siteContact.AOPS_Contact_Number__c = stagingRec.AOPS_Contact_Number__c;
        siteContact.AOPS_Account_Number__c = stagingRec.AOPS_Account_Number__c;
        siteContact.Default_Ship_Contact__c = stagingRec.Default_Ship_Contact__c;
        siteContact.Allowed_To_Buy__c = stagingRec.Allowed_To_Buy__c;
        siteContact.Purpose__c = stagingRec.Purpose__c;
        siteContact.Type__c = 'Order';

        addLookupsToSiteContact(siteContact);

        return siteContact;
    }

    /**
     * Adds Account and Contact lookups to the Site Contact.
     */
    private void addLookupsToSiteContact(SiteContacts__c siteContact) {
        String aopsSeqId = getAopsSeqId(siteContact);
        String contactNumber = siteContact.AOPS_Contact_Number__c;

        // Handle situations where and associated Account or Contact was not found.
        if(mappedAccountIds.containsKey(aopsSeqId) == false) {
            throw new NotFoundException('No Account with Sequence ID ' + aopsSeqId + ' was found.');
        }
        if(mappedContactIds.containsKey(contactNumber) == false) {
            throw new NotFoundException('No Contact with Contact Number ' + contactNumber + ' was found.');
        }

        siteContact.Account__c = mappedAccountIds.get(aopsSeqId);
        siteContact.Contact__c = mappedContactIds.get(contactNumber);
    }

    private void persistSiteContactChanges() {
        Database.DMLOptions options = new Database.DMLOptions();
        options.OptAllOrNone = false;
        if(siteContactsToInsert.size() > 0) {
            Database.SaveResult[] insertResults = Database.insert(siteContactsToInsert, options);
            addToSyncResults(insertResults, siteContactsToInsert);
        }
        if(siteContactsToUpdate.size() > 0) {
            Database.SaveResult[] insertResults = Database.update(siteContactsToUpdate, options);
            addToSyncResults(insertResults, siteContactsToUpdate);
        }
        if(siteContactsToDelete.size() > 0) {
            Database.DeleteResult[] deleteResults = Database.delete(siteContactsToDelete, false);
            addToDeleteResults(deleteResults, siteContactsToDelete);
        }
    }

    private void addToSyncResults(Database.SaveResult[] saveResults, List<SiteContacts__c> correspondingContacts) {
        for(Integer i = 0; i < saveResults.size(); i++) {
            SiteContacts_Final_Staging__c finalStagingRec = stagingRecsMap.get(getStagingRecKey(correspondingContacts[i]));
            if(saveResults[i].isSuccess()) {
                syncedStagingRecords.add(finalStagingRec);
            } else {
                addToFailureList(finalStagingRec, getFailureMessage(saveResults[i].getErrors()));
            }
        }
    }

    private void addToDeleteResults(Database.DeleteResult[] deleteResults, List<SiteContacts__c> correspondingContacts) {
        for(Integer i = 0; i < deleteResults.size(); i++) {
            SiteContacts_Final_Staging__c finalStagingRec = stagingRecsMap.get(getStagingRecKey(correspondingContacts[i]));
            if(deleteResults[i].isSuccess()) {
                syncedStagingRecords.add(finalStagingRec);
            } else {
                addToFailureList(finalStagingRec, getFailureMessage(deleteResults[i].getErrors()));
            }
        }
    }

    private String getStagingRecKey(SiteContacts_Final_Staging__c stagingRec) {
        return stagingRec.AOPS_Contact_Number__c + getAopsSeqId(stagingRec);
    }

    private String getStagingRecKey(SiteContacts__c siteContact) {
        return siteContact.AOPS_Contact_Number__c + getAopsSeqId(siteContact);
    }

    private String getAopsSeqId(SiteContacts_Final_Staging__c stagingRec) {
        return stagingRec.AOPS_Account_Number__c + '-' + stagingRec.Shipto_Addr_Seq__c.leftPad(5, '0');
    }

    private String getAopsSeqId(SiteContacts__c siteContact) {
        return siteContact.AOPS_Account_Number__c + '-' + siteContact.Shipto_Addr_Seq__c;
    }

    private String getFailureMessage(Database.Error[] errors) {
        String err = '';
        for(Database.Error e : errors) {
            if(String.isBlank(err) == false) err += ' ';
            err += e.getMessage();
        }
        return err;
    }
    
    public void addToFailureList(SiteContacts_Final_Staging__c finalStagingRec, String errorMessage) {
        SiteContacts_Final_Staging__c clonedRec = new SiteContacts_Final_Staging__c(Id=finalStagingRec.Id);
        clonedRec.Sync_Failed__c = true;
        clonedRec.Sync_Message__c = errorMessage;
        failedStagingRecords.add(clonedRec);
    }

    private void markSyncStatus() {
        updateSyncedRecords();
        updateFailedRecords();
    }

    private void updateSyncedRecords() {
        List<SiteContacts_Final_Staging__c> clonedRecords = new List<SiteContacts_Final_Staging__c>();
        for(SiteContacts_Final_Staging__c stagingRec : syncedStagingRecords) {
            SiteContacts_Final_Staging__c clonedRecord = new SiteContacts_Final_Staging__c(Id=stagingRec.Id);
            clonedRecord.Sync_Failed__c = false;
            clonedRecord.Sync_Message__c = '';
            clonedRecord.Is_Changed__c = false;
            clonedRecord.Number_Of_Attempts__c = 0;
            clonedRecords.add(clonedRecord);
        }
        if(clonedRecords.size() > 0)
            update clonedRecords;
    }

    private void updateFailedRecords() {
        if(failedStagingRecords.size() > 0)
            update failedStagingRecords;
    }

    /**
     * If an exception occurs, we want to make sure the staging records are marked as failed.
     */
    public void handleException(Exception ex) {
        List<SiteContacts_Final_Staging__c> clonedRecs = new List<SiteContacts_Final_Staging__c>();
        for(SiteContacts_Final_Staging__c stagingRec : stagingRecordsToSync) {
            SiteContacts_Final_Staging__c clonedRec = new SiteContacts_Final_Staging__c(Id=stagingRec.Id);
            clonedRec.Sync_Failed__c = true;
            clonedRec.Sync_Message__c = ex.getMessage();
            clonedRecs.add(clonedRec);
        }
        update clonedRecs;
    }

    class NotFoundException extends Exception {}
}