trigger AOPSSyncToSiteContactTrigger on SiteContacts_Final_Staging__c (after insert, after update) {

    List<SiteContacts_Final_Staging__c> finalStagingRecords = Trigger.new;

    // To avoid infinite loops, we don't sync records that are in a failure state.
    List<SiteContacts_Final_Staging__c> recsToSync = new List<SiteContacts_Final_Staging__c>();
    for(SiteContacts_Final_Staging__c finalStagingRec : finalStagingRecords) {

        // TODO: Confirm we will be skipping records with a delete action. If so, add check here.
        
        if(AOPSSyncToSiteContactProcessor.isFailedRecord(finalStagingRec) == false) {
            recsToSync.add(finalStagingRec);
        }
    }

    AOPSSyncToSiteContactProcessor aopsSync = new AOPSSyncToSiteContactProcessor(recsToSync);
    aopsSync.sync();
}