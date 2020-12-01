/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class Alignment_Update_Assignments implements Database.Batchable<SObject> {
    global Id alignmentId;
    global TAV4.Alignment_Update_Manager aum;
    global String query;
    global Id updateId;
    global String utype;
    global Alignment_Update_Assignments(TAV4.Alignment_Update_Manager aum, Id aid, Id uid, String utype) {

    }
    global void execute(Database.BatchableContext BC, List<TAV4__Alignment_Update_Detail__c> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
