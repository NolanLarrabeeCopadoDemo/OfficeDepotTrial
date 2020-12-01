trigger EventLog_Trigger on EventLog__e (after insert) {
    List<Log__c> myLogs = new List<Log__c>();
    Id ApexRecordTypeId = Schema.SObjectType.Log__c.getRecordTypeInfosByName().get('Apex').getRecordTypeId();
    for (EventLog__e myEventLog: Trigger.New){
        Log__c myLog = new Log__c
            (   Severity__c = myEventLog.Log_Level__c,
                RecordTypeId= ApexRecordTypeId,
                Timestamp__c = myEventLog.CreatedDate,
                Message__c = myEventLog.Full_Message__c,
                Service_Name__c = myEventLog.Source__c
            );
        myLogs.add(myLog);
    }
    Insert myLogs;
}