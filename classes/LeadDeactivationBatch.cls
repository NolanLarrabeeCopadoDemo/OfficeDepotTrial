/*******************************************************************************************************
 * @author Adam Albright, adam.albright@officedepot.com, 23 September 2019
 * @description This class is used to deactivate leads that have been inactive for a peroid of time.
 */

global class LeadDeactivationBatch implements Database.Batchable<sObject>, Database.Stateful {
    Integer recordsProcessed = 0;

    String buildStartMessage(String query) {
        String message = '';
        message += 'Starting Apex Job: ' +
        DateTime.now().format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'') +
        '\nQuery: ' +
        query;

        return message;
    }

    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com, 21 March 2019
     * @description Gets the configuartion paramaters for this job.
     * @param
     */
    Map<String, String> getProcessFlags() {
        Map<String, String> process_paramaters = new Map<String, String>();

        if (Test.isRunningTest()) {
            System.debug(
                LoggingLevel.DEBUG,
                'Metadata: ' +
                [
                    SELECT
                        Id,
                        Process_Name__c,
                        Property_Name__c,
                        Property_Value__c
                    FROM Auto_Process_Flags__mdt
                    WHERE Process_Name__c = 'LeadDeactivationBatch'
                ]
            );
            // Returning this in case meta data has not been set up in target env.
            process_paramaters.put(
                'RecordTypes',
                'Lead_US'
            );
        }

        for (Auto_Process_Flags__mdt flag: [
            SELECT Id, Process_Name__c, Property_Name__c, Property_Value__c
            FROM Auto_Process_Flags__mdt
            WHERE Process_Name__c = 'LeadDeactivationBatch'
        ]) {
            process_paramaters.put(
                flag.Property_Name__c,
                flag.Property_Value__c
            );
        }
        return process_paramaters;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        /*
         * Here we get the batches of objects we want to change or update.
         * Only get what you need.
         */

        Set<String> recordTypeDeveloperNameSet = new Set<String>(getProcessFlags().get(
            'RecordTypes'
        ).split(','));

        Integer lastYear = Date.today().year() - 1;
        Date myDate = Date.newInstance(
            lastYear,
            Date.today().month(),
            Date.today().day()
        );
        Time myTime = Time.newInstance(1, 2, 3, 4);
        DateTime dt = DateTime.newInstance(myDate, myTime);

        String query = 'SELECT Id, CreatedDate FROM Lead ' +
        'WHERE (NOT(Status=\'Contacted\' OR Status=\'Converted\' OR Status=\'Closed\')) ' +
        'AND CreatedDate < :dt ' +
        'AND RecordType.DeveloperName IN :recordTypeDeveloperNameSet' +
        (Test.isRunningTest() ? ' LIMIT 100' : '');

        if (Test.isRunningTest()) {
            System.debug(LoggingLevel.INFO, Database.query(query));
            System.debug(LoggingLevel.DEBUG, 'Date Time: ' + dt);
            System.debug(
                LoggingLevel.DEBUG,
                'RecordType Set: ' + recordTypeDeveloperNameSet
            );
            System.debug(LoggingLevel.DEBUG, 'Query is ' + query);
        }

        MyUtils_Logger.createApexJobLogEvent(
            'INFO',
            buildStartMessage(query),
            'LeadDeactivationBatch',
            'RAW'
        );

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Lead> lead_List) {
        for (Lead led: lead_List) {
            led.Sub_Status__c = 'Other';
            led.Close_Reason__c = 'Inactive';
            led.Status = 'Closed';
            led.Closed_Date__c = Date.today();
        }

        update lead_List;
        this.recordsProcessed += lead_List.size();
    }

    global void finish(Database.BatchableContext BC) {
        System.debug(recordsProcessed + ' records processed. Shazam!');
        AsyncApexJob job = [
            SELECT
                Id,
                Status,
                NumberOfErrors,
                JobItemsProcessed,
                TotalJobItems,
                CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :BC.getJobId()
        ];
        System.debug('job  ' + job);
        MyUtils_Logger.createApexJobLogEvent(
            'INFO',
            JSON.serialize(job),
            'LeadDeactivationBatch',
            'JSON'
        );
    }
}