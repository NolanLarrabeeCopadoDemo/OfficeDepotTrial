trigger PrimaryDMLRelationTrigger on DML_Relation__c (before insert, after insert, after update,
                                                      before update, before delete, after undelete,
                                                      after delete) {

    new DMLRelationTriggerHandler().run();
}