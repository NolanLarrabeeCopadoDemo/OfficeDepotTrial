trigger PrimaryCaseCommentTrigger on CaseComment (after insert) {
    new CaseCommentTriggerHandler().run();
}