public with sharing class DMLRelationTriggerHandler extends TriggerHandler {

    private List<DML_Relation__c> new_dml_relation_list;
    private List<DML_Relation__c> old_dml_relation_list;
    private Map<Id, DML_Relation__c> old_dml_relation_map;
    private Map<Id, DML_Relation__c> new_dml_relation_map;
    Map<Id, String> mapOfRecordTypes = new Map<Id, String>();
    //Control the trigger execution for DML tool(DMLRelationController)
    @TestVisible public static Boolean executeTrigger = True; 

    public DMLRelationTriggerHandler() {
        this.new_dml_relation_list = (List<DML_Relation__c>) Trigger.new;
        this.old_dml_relation_list = (List<DML_Relation__c>) Trigger.old;
        this.old_dml_relation_map = (Map<Id, DML_Relation__c>) Trigger.oldMap;
        this.new_dml_relation_map = (Map<Id, DML_Relation__c>) Trigger.newMap;
        mapOfRecordTypes = ODCommonUtilityMethods.getRecordTypeIdToName('DML_Relation__c');
    }

    public override void beforeInsert(){
        if(executeTrigger){
            DMLRelationController.EffectiveEnddate(this.new_dml_relation_list);
            DMLRelationController.AssociateAccountid(this.new_dml_relation_list);
        }       
    }
/*
    public override void afterInsert(){
        if(executeTrigger){
            // Returns a list of accounts. If this is being done here, does it need to take place in the immediate function, or vice versa?
            // DMLRelationController.set_accounts_related_dml_to_null(this.new_dml_relation_list);
        }
    }
*/    
    public override void afterUpdate(){
        DMLRelationController.DMLRHistoryPopulate(this.new_dml_relation_map, this.old_dml_relation_map);
    
    }
}