trigger BeforeInsert on Sales_History__c (before insert) {
    SalesHistoryTriggers.beforeInsert(Trigger.New);
}