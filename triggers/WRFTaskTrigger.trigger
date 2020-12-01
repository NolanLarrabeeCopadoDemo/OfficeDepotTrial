trigger WRFTaskTrigger on WRF_Task__c (before delete, before insert, before update,
after delete, after insert, after update) 
{
    if (Util.bypassTriggers('WRFTaskTrigger')) 
    {
        Util.DEBUG('Bypassing trigger WRFTaskEvents');
        return;
    }
    if(Trigger.IsBefore && (Trigger.IsInsert || Trigger.IsUpdate))
    {
        WRFTaskManagement.beforeinsertupdatelogic();
    }
    if(Trigger.IsAfter && (Trigger.IsInsert || Trigger.IsUpdate))
    {
        WRFTaskManagement.afterinsertupdatelogic();
    }
    if(Trigger.IsBefore && Trigger.IsDelete)
    {
        WRFTaskManagement.beforedeletelogic();
    }
    if(Trigger.IsAfter && Trigger.IsDelete)
    {
        WRFTaskManagement.afterdeletelogic();
    }
}