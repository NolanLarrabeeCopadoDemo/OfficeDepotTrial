trigger PrimaryCaseTrigger on Case (before insert, after insert, before update, after update) {
    new CaseTriggerHandler().run();
}