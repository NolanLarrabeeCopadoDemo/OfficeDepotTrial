trigger AOPSSyncToContactTrigger on Contact_Final_Staging__c (after insert, after update) {
    
    List<Contact_Final_Staging__c> finalStagingRecords = Trigger.new;

    // To avoid infinite loops, we don't sync records that are in a failure state.
    List<Contact_Final_Staging__c> recsToSync = new List<Contact_Final_Staging__c>();
    for(Contact_Final_Staging__c finalStagingRec : finalStagingRecords) {
        if(AOPSSyncToContactProcessor.isFailedRecord(finalStagingRec) == false) {
            recsToSync.add(finalStagingRec);
        }
    }

    AOPSSyncToContactProcessor aopsSync = new AOPSSyncToContactProcessor(recsToSync);
    aopsSync.sync();
}