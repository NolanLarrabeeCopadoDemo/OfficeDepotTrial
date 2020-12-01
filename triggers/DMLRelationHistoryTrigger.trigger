trigger DMLRelationHistoryTrigger on DML_Relation_History__c (before insert) {
        DMLRelationHistoryClass.updateDates(Trigger.New);
}