trigger PrimaryPotentialBandTrigger on Potential_Band__c (before insert, after insert, before update, after update) {
    new PotentialBandTriggerHandler().run();
}