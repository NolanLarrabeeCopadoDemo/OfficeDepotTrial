trigger CaseCloseTask on Case (after update) {
    if (executeoncetest.Closetaskonce)
    {
        List<Id> caseIds = new List<Id>();
        List<Task> updatedTasks = new List<task>();
        Schema.DescribeSObjectResult d = Schema.SObjectType.Case; 
        Map<String, Schema.RecordTypeInfo> recordTypeMap = d.getRecordTypeInfosByName();

        for (Case newCase : Trigger.New)
        {
            if (newCase.status =='Closed'
            && (newCase.RecordTypeId == recordTypeMap.get('Support').getRecordTypeId()
                || newCase.RecordTypeId == recordTypeMap.get('IT Cases').getRecordTypeId()))
            {
                caseIds.add(newCase.id);
            }
        }

        List<Task> tasks = [SELECT Id, CallDisposition, Task_Type__c, Status, Description, Outcome__c, Action__c
                            from task
                            where status not in ('Completed', 'Cancelled') and whatid in :caseIds ];

        for (Task currentTask : tasks)
        {
            currentTask.status ='Completed';
            if (currentTask.Description == null)
                currentTask.Description = 'Task auto closed by the system since the parent Case is closed';
            if (currentTask.Outcome__c == null)
            {
                currentTask.Action__c = 'Other';
                currentTask.Outcome__c = 'No Action Required';
            }
            updatedTasks.add(currentTask);
        }
        executeoncetest.Closetaskonce = false;
        update updatedTasks;
    }
}