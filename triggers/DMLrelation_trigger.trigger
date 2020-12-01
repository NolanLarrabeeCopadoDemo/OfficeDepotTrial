trigger DMLrelation_trigger on DML_Relation__c (before insert, after insert,After Update) {
    if(trigger.isinsert&&trigger.isbefore)
    {
        DMLrelation_handler.EffectiveEnddate(trigger.new);
        DMLrelation_handler.AssociateAccountid(trigger.new);
    }
    if(trigger.isinsert&&trigger.isafter)
    {
        DMLrelation_handler.RemoveRelatedDML(trigger.new);
    }    
    if(trigger.IsUpdate&&trigger.IsAfter)
    {          
      DMLrelation_handler.DMLRHistoryPopulate(Trigger.NewMap, Trigger.OldMap);
    }   
    
}