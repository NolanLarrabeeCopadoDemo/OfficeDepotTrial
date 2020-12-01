trigger AOPSSyncToSiteTrigger on Account_Site_Final_Staging__c (after insert, after update) {

    List<Account_Site_Final_Staging__c> finalStagingRecords = Trigger.new;

    // To avoid infinite loops, we don't sync records that are in a failure state.
    List<Account_Site_Final_Staging__c> recsToSync = new List<Account_Site_Final_Staging__c>();
    for(Account_Site_Final_Staging__c finalStagingRec : finalStagingRecords) {
        if(AOPSSyncToSiteProcessor.isFailedRecord(finalStagingRec) == false) {
            recsToSync.add(finalStagingRec);
        }
    }

    AOPSSyncToSiteProcessor aopsSync = new AOPSSyncToSiteProcessor(recsToSync);
    aopsSync.sync();
}