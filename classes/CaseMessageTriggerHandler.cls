public with sharing class CaseMessageTriggerHandler extends TriggerHandler {
    private List<Case_Message__c> new_case_message_list;
    private List<Case_Message__c> old_case_message_list;
    private Map<Id, Case_Message__c> old_case_message_map;
    private Map<Id, Case_Message__c> new_case_message_map;


    public CaseMessageTriggerHandler() {
        this.new_case_message_list = (List<Case_Message__c>) Trigger.new;
        this.old_case_message_list = (List<Case_Message__c>) Trigger.old;
        this.old_case_message_map = (Map<Id, Case_Message__c>) Trigger.oldMap;
        this.new_case_message_map = (Map<Id, Case_Message__c>) Trigger.newMap;
    }

    public override void afterInsert(){
        SingleTicketingCaseManagement.start_case_message_job();
    }

    public override void afterUpdate(){
        SingleTicketingCaseManagement.start_case_message_job();
    }
}