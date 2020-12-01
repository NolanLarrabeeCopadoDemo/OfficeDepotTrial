/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class QxSynchroUtils {
    global QxSynchroUtils() {

    }
    global static CameleonCPQ.QxSynchroUtils.SyncOppResult cleanOppLines(Id entityId, Id opportunityId) {
        return null;
    }
    global static CameleonCPQ.QxSynchroUtils.SyncOppResult syncOppLines(Id entityId, Id opportunityId, Boolean synchronous, Integer chunkSize) {
        return null;
    }
global class SyncOppResult {
    global String errorMessage {
        get;
        set;
    }
    global Id jobID {
        get;
        set;
    }
    global CameleonCPQ.QxSynchroUtils.OppSyncStatus status {
        get;
        set;
    }
    global SyncOppResult() {

    }
}
global class SynchronizationException extends Exception {
}
}
