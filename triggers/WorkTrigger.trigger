/*****************************************************************
Author			: Appirio India (Hitesh Pareek)
Date(original)	: Jan 14, 2016
Purpose			: Consolidated trigger on user story - S-374368
******************************************************************/
trigger WorkTrigger on agf__ADM_Work__c (after update) {
	if(trigger.isUpdate && trigger.isAfter){
		WorkTriggerHandler.afterUpdateHandler(trigger.oldMap, trigger.newMap);
	}
}