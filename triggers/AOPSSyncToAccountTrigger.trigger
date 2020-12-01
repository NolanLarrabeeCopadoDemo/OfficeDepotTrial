trigger AOPSSyncToAccountTrigger on Account_Final_Staging__c (after insert, after update) {

    List<Account_Final_Staging__c> finalStagingRecords = Trigger.new;

    // To avoid infinite loops, we don't sync records that are in a failure state.
    List<Account_Final_Staging__c> recsToSync = new List<Account_Final_Staging__c>();
    for(Account_Final_Staging__c finalStagingRec : finalStagingRecords) {
        if(AOPSSyncToAccountProcessor.isFailedRecord(finalStagingRec) == false) {
            recsToSync.add(finalStagingRec);
        }
    }

    AOPSSyncToAccountProcessor aopsSync = new AOPSSyncToAccountProcessor(recsToSync);
    aopsSync.sync();
}