trigger PrimaryCaseMessageTrigger on Case_Message__c (after insert, after update) {
    new CaseMessageTriggerHandler().run();
}