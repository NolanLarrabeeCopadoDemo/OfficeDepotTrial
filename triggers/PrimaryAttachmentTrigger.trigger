trigger PrimaryAttachmentTrigger on Attachment (after insert) {
    new AttachmentTriggerHandler().run();
}