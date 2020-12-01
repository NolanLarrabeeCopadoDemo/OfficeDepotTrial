public with sharing class AttachmentTriggerHandler extends TriggerHandler {
    private List<Attachment> new_attachment_list;
    private List<Attachment> old_attachment_list;
    private Map<Id, Attachment> old_attachment_map;
    private Map<Id, Attachment> new_attachment_map;


    public AttachmentTriggerHandler() {
        this.new_attachment_list = (List<Attachment>) Trigger.new;
        this.old_attachment_list = (List<Attachment>) Trigger.old;
        this.old_attachment_map = (Map<Id, Attachment>) Trigger.oldMap;
        this.new_attachment_map = (Map<Id, Attachment>) Trigger.newMap;
    }

    public override void afterInsert(){
        System.debug(LoggingLevel.INFO, 'Just Trying the after trigger out.');
        List<Case_Message__c> my_case_messages = SingleTicketingCaseManagement.create_outbound_case_message_attachment(new_attachment_map);
        insert my_case_messages;
    }
}