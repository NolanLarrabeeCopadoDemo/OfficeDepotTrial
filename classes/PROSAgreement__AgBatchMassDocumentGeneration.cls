/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class AgBatchMassDocumentGeneration implements Database.AllowsCallouts, Database.Batchable<SObject>, Database.Stateful {
    global Integer batchCount;
    global AgBatchMassDocumentGeneration(List<PROSAgreement__MPCI__c> mpciList, String reportActionLabel) {

    }
    global void execute(Database.BatchableContext bc, List<PROSAgreement__MPCI__c> pendingMpcis) {

    }
    global void finish(Database.BatchableContext bc) {

    }
    global List<PROSAgreement__MPCI__c> start(Database.BatchableContext bc) {
        return null;
    }
}
