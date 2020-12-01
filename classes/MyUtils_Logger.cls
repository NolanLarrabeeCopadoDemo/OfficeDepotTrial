public without sharing class MyUtils_Logger {
    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @date 06-December-2018
     *
     * @description Creates an log entry with an Apex RecordType
     * @param String log_name_80 - Name of this log entry. Has a lenght limit of 80 Characters
     * @param String log_message_255 - Message for this log entry. Has a lenght limit of 255 Characters
     * @param String log_message_30k - Extended Message for this log entry. Has a lenght limit of 30k Characters
     * @param String className_255 - The Apex class name that generated this log. Has a lenght limit of 255 Characters
     *
     */
    public static void createApexLogEntry(String criticality, String log_name_80, String log_message_255, String log_message_30k, String className_255) {
        Id ApexRecordTypeId = Schema.SObjectType.Log__c.getRecordTypeInfosByName().get(
            'Apex'
        ).getRecordTypeId();
        Datetime log_timestamp = System.now();
        System.debug(LoggingLEvel.INFO, 'Log Created at: ' + log_timestamp);

        enterLog(
            criticality.trim(),
            log_name_80.trim(),
            log_timestamp,
            log_message_255.trim(),
            log_message_30k.trim(),
            ApexRecordTypeId,
            className_255.trim()
        );
    }

    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com, 17-December-2018
     * @description Creates an log entry with an Apex RecordType
     * @param String criticality - How critical is the message? INFO, WARNING, ERROR, CRITICAL
     * @param String log_message_30k - Extended Message for this log entry. Has a length limit of 30k Characters
     * @param String className_255 - The Apex class name that generated this log. Has a length limit of 255 Characters
     *
     */
    public static Database.SaveResult createApexLogEvent(String criticality, String log_message_30k, String className_255) {
        LoggingEvent__e myEventLog = new LoggingEvent__e(
            Source__c = className_255,
            Full_Message__c = log_message_30k,
            Log_Level__c = criticality,
            RecordType__c = 'Apex'
        );

        System.debug(LoggingLevel.INFO, 'Event Log: ' + myEventLog);
        Database.SaveResult sr = EventBus.publish(myEventLog);
        // Inspect publishing result
        if (sr.isSuccess()) {
            System.debug('Successfully published event.');
        } else {
            for (Database.Error err: sr.getErrors()) {
                System.debug(
                    'Error returned: ' + err.getStatusCode() + ' - ' +
                    err.getMessage()
                );
            }
        }
        return sr;
    }

    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com, 07 March 2019
     * @description Apex Job Logging
     * @description Creates an log entry with an Apex RecordType
     * @param String criticality - How critical is the message? INFO, WARNING, ERROR, CRITICAL
     * @param String log_message_30k - Extended Message for this log entry. Has a length limit of 30k Characters
     * @param String className_255 - The Apex class name that generated this log. Has a length limit of 255 Characters
     *
     */
    public static Database.SaveResult createApexJobLogEvent(String criticality, String log_message_30k, String className_255, String format) {
        LoggingEvent__e myEventLog = new LoggingEvent__e(
            Source__c = className_255,
            Full_Message__c = log_message_30k,
            Log_Level__c = criticality,
            RecordType__c = 'Batch',
            Format__c = format,
            UserId__c = UserInfo.getUserId()
        );

        System.debug(LoggingLevel.INFO, myEventLog);
        Database.SaveResult sr = EventBus.publish(myEventLog);
        // Inspect publishing result
        if (sr.isSuccess()) {
            System.debug('Successfully published event.');
        } else {
            for (Database.Error err: sr.getErrors()) {
                System.debug(
                    'Error returned: ' + err.getStatusCode() + ' - ' +
                    err.getMessage()
                );
            }
        }
        return sr;
    }

    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @date 06-December-2018
     *
     * @description Inserts a new log entry through a future method. Should only be called through a wrapper.
     * @param
     *
     */
    @future
    public static void enterlog(String criticality, String log_name_80, Datetime log_timestamp, String log_message_255, String log_message_30k, Id RecordType_Id, String className_255) {
        Log__c myLog = new Log__c(
            Severity__c = criticality,
            Name = log_name_80,
            RecordTypeId = RecordType_Id,
            Timestamp__c = log_timestamp,
            Message__c = log_message_255,
            Full_Message__c = log_message_30k,
            Class_Name__c = className_255
        );
        try {
            insert myLog;
        } catch (DmlException e) {
            System.debug(LoggingLEvel.ERROR, 'Logger failed to create log.');
            System.debug(LoggingLEvel.ERROR, e);
        }
    }
}