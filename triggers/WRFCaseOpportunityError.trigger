trigger WRFCaseOpportunityError on Case (Before Update) {

    if(trigger.isBefore&&trigger.isUpdate)
        WRFCaseOpportunityError_Handler.getWRFCaseRecords(trigger.New,trigger.oldmap);
}