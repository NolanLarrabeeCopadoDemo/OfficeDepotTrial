// Functionality  Sales Data
trigger SalesDataBeforeTrigger  on Sales_Data__c (before insert, before update) {
    if(trigger.isinsert&&trigger.isbefore)
    {
        SalesDataBeforeTrigger_handler.beforeinsert(trigger.new);
    }
    if(trigger.isupdate&&trigger.isbefore)
    {
         SalesDataBeforeTrigger_handler.beforeinsert(trigger.new);
        SalesDataBeforeTrigger_handler.beforeupdate(trigger.newmap,trigger.oldmap);
    }    
}