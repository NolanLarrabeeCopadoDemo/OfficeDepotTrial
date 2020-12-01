trigger PrimaryOrgTrigger on Org__c (before insert, after insert, before update, after update) {
    new OrgTriggerHandler().run();
}