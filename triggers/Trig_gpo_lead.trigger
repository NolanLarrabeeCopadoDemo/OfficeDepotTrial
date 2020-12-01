trigger Trig_gpo_lead on gpo_lead__c (after insert, after update) {
et4ae5.triggerUtility.automate('gpo_lead__c');
}