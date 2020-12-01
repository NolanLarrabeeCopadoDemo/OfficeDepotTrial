trigger Primarychecking on Contract (before insert,before update,after insert,after update) {
    
   if(trigger.IsInsert && trigger.IsBefore)
    Primarychecking_handler.Pcheck(trigger.new);
    
    if(trigger.IsUpdate && trigger.IsBefore)
    Primarychecking_handler.pcheckaf(trigger.new,trigger.oldmap);
   
  if((((trigger.IsUpdate && trigger.IsAfter)||(trigger.IsInsert && trigger.IsAfter)))&& CloningContractRec.Flag)
    {
       CloningContractRec.Flag = false;
    CloningContractRec.beforeupdate(trigger.new);
    }
}