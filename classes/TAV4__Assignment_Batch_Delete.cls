/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class Assignment_Batch_Delete implements Database.Batchable<SObject> {
    global Id alignmentId;
    global Set<Id> areas;
    global TAV4.Alignment_Update_Manager aum;
    global String query;
    global Assignment_Batch_Delete(TAV4.Alignment_Update_Manager aum, TAV4.Assignment_Batch_Delete.AssignmentType atype, Id alignmentId, Set<Id> areas) {

    }
    global void execute(Database.BatchableContext BC, List<SObject> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
global enum AssignmentType {ACCOUNT, GEOUNIT, SALESREP}
}
