trigger DMLTrigger on DML__c ( before update,After Update) 
{
  if(Trigger.Isupdate&&Trigger.IsBefore)
  {
        System.debug('Forloop');
      DMLTrigger_Handler.beforeupdate(Trigger.new,Trigger.oldmap);
  }
if(trigger.IsUpdate&&trigger.IsAfter)
    {
              System.debug('Ifloop');
    DMLTrigger_Handler.DMLHistoryPopulate(Trigger.NewMap,Trigger.OldMap);
    }   
}