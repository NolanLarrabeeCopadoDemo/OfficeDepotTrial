trigger SalesHistoryTriggers on Sales_History__c (before insert, before update) {

    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        SalesHistoryTriggers.beforeUpsert(Trigger.New);
    }
}