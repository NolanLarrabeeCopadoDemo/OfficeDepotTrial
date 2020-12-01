trigger DMLHistoryTrigger on DML_History__c (before insert) {
	DMLHistoryClass.updateDates(Trigger.New);
}