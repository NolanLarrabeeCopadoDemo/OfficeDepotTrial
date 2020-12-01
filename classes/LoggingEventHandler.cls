/*******************************************************************************************************
 * @author Adam Albright, adam.albright@officedepot.com, 11 April 2019
 * @description Covered by MyUtils_Test
 */

public without sharing class LoggingEventHandler extends TriggerHandler {
    public override void afterInsert() {
        // If the event log is valid, creat an entry. If it is not,
        if (Test.isRunningTest()) {
            System.debug(LoggingLevel.INFO, 'Before Insert Testing.');
        }
        List<Log__c> myLogs = new List<Log__c>();
        Map<String, Schema.RecordTypeInfo> log_record_types = Schema.SObjectType.Log__c.getRecordTypeInfosByDeveloperName();
        for (LoggingEvent__e myEventLog: (List<LoggingEvent__e>) Trigger.New) {
            if (log_record_types.keySet().contains(myEventLog.RecordType__c)) {
                Log__c myLog = new Log__c(
                    Severity__c = myEventLog.Log_Level__c,
                    RecordTypeId = log_record_types.get(
                        myEventLog.RecordType__c
                    ).getRecordTypeId(),
                    Timestamp__c = myEventLog.CreatedDate,
                    Full_Message__c = myEventLog.Full_Message__c,
                    Service_Name__c = myEventLog.Source__c,
                    UserId__c = myEventLog.UserId__c
                );
                myLogs.add(myLog);
            } else {
                Log__c myLog = new Log__c(
                    Severity__c = 'ERROR',
                    RecordTypeId = log_record_types.get(
                        'Apex'
                    ).getRecordTypeId(),
                    Timestamp__c = System.now(),
                    Full_Message__c = JSON.serialize(myEventLog),
                    Service_Name__c = 'LoggingEventHandler',
                    UserId__c = UserInfo.getUserId()
                );
                myLogs.add(myLog);
            }
        }
        if (Test.isRunningTest()) {
            System.debug(LoggingLevel.INFO, 'Logs: ' + myLogs);
        }
        insert myLogs;
    }
}