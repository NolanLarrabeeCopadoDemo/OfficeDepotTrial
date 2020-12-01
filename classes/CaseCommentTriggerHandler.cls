public with sharing class CaseCommentTriggerHandler extends TriggerHandler {
    private List<CaseComment> new_case_comment_list;
    private List<CaseComment> old_case_comment_list;
    private Map<Id, CaseComment> old_case_comment_map;
    private Map<Id, CaseComment> new_case_comment_map;


    public CaseCommentTriggerHandler() {
        this.new_case_comment_list = (List<CaseComment>) Trigger.new;
        this.old_case_comment_list = (List<CaseComment>) Trigger.old;
        this.old_case_comment_map = (Map<Id, CaseComment>) Trigger.oldMap;
        this.new_case_comment_map = (Map<Id, CaseComment>) Trigger.newMap;
    }

    public override void afterInsert(){
        System.debug(LoggingLevel.INFO, 'Just Trying the trigger out.');
        SingleTicketingCaseManagement.create_outbound_case_message_comment(new_case_comment_map);
        List<Case_Message__c> my_case_messages = SingleTicketingCaseManagement.create_outbound_case_message_comment(new_case_comment_map);
        insert my_case_messages;
    }
}