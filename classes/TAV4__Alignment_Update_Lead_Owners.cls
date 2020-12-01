/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class Alignment_Update_Lead_Owners implements Database.Batchable<SObject> {
    global Id alignmentId;
    global TAV4.Alignment_Update_Manager aum;
    global List<Id> leads;
    global String query;
    global Id updateId;
    global Alignment_Update_Lead_Owners(TAV4.Alignment_Update_Manager aum) {

    }
    global Alignment_Update_Lead_Owners(List<Id> leads) {

    }
    global Alignment_Update_Lead_Owners(TAV4.Alignment_Update_Manager aum, Id aid) {

    }
    global Alignment_Update_Lead_Owners(TAV4.Alignment_Update_Manager aum, List<Id> ids) {

    }
    global void execute(Database.BatchableContext BC, List<Lead> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
