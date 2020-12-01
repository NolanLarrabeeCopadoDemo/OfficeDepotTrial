/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class Alignment_Update_Account_Owners implements Database.Batchable<SObject> {
    global Set<Id> acctids;
    global TAV4.Alignment_Update_Manager aum;
    global String query;
    global Alignment_Update_Account_Owners(Set<Id> acctids) {

    }
    global Alignment_Update_Account_Owners(TAV4.Alignment_Update_Manager aum, Id aid) {

    }
    global Alignment_Update_Account_Owners(TAV4.Alignment_Update_Manager aum, Set<Id> acctids) {

    }
    global Alignment_Update_Account_Owners(TAV4.Alignment_Update_Manager aum, String updateId) {

    }
    global void execute(Database.BatchableContext BC, List<Account> scope) {

    }
    global void finish(Database.BatchableContext BC) {

    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return null;
    }
}
