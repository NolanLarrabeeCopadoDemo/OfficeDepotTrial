global with sharing class QxApiClientDebug implements CameleonCPQ.QxApiClient.IDebug {
    // Debug with given logging level
    global void debug(String level, String msg) {
        // level must be the converted String value of Force.com logging level
        // levels : ERROR, WARN, INFO, DEBUG, FINE, FINER, FINEST
        if('ERROR'.equals(level))
           System.debug(LoggingLevel.ERROR, msg);
        else
        if('WARN'.equals(level))
           System.debug(LoggingLevel.WARN, msg);
        else
        if('INFO'.equals(level))
           System.debug(LoggingLevel.INFO, msg);
        else
        if('DEBUG'.equals(level))
           System.debug(LoggingLevel.DEBUG, msg);
        else
        if('FINE'.equals(level))
           System.debug(LoggingLevel.FINE, msg);
        else
        if('FINER'.equals(level))
           System.debug(LoggingLevel.FINER, msg);
        else
        if('FINEST'.equals(level))
           System.debug(LoggingLevel.FINEST, msg);
        else
           System.debug(LoggingLevel.INFO, msg);
    }
    
    // Debug with default logging level
    global void debug(String msg) {
       System.debug(msg);
    }
    
    // Determine the logging level use to trace the synchronization trigger
    // Must return the string representation of one of the Force.com logging levels
    global String getLoggingLevel() {
       return LoggingLevel.INFO.name();
    }
    
    // Return the name of the APEX debug file created on CPQ server
    global String getLoggingFileName(Id quoteId) {
       return 'MyApexDebug.log';
    }
}