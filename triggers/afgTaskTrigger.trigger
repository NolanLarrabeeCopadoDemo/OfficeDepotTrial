/*****************************************************************
Author			: Appirio India (Hitesh Pareek)
Date(original)	: Jan 19, 2016
Purpose			: Consolidated trigger on task - S-374370
Modifications   : 
	07 July, 2016	Nick Sharp    S-423436 - added before delete action
******************************************************************/
//START NSHARP S-423436 07.07.2016 - added before delete action
trigger afgTaskTrigger on agf__ADM_Task__c (after update, before delete) {
	if(trigger.isAfter && trigger.isUpdate){
		AFGTaskTriggerHandler.afterUpdateHandler(trigger.oldMap, trigger.newMap);
	}
	else if(Trigger.isDelete){
		if(Trigger.isBefore){
			AFGTaskTriggerHandler.onBeforeDelete(trigger.old);
		}
	}
	//END NSHARP S-423436 07.07.2016
}