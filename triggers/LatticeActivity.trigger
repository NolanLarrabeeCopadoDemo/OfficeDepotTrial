trigger LatticeActivity on LBI__Activity__c (after insert) {
	// Call future method to query for Activity and create the necessary tasks
	if(!system.isFuture() && !system.isBatch() && !system.isQueueable() && !system.isScheduled()) ODP_TaskCreation.createTasks(trigger.newMap.keyset());
    else{
        //LBI__Activity__c[] activities = [select id from LBI__Activity__c where id in:trigger.newmap.keyset()];
		//delete activities;
        
    }
}