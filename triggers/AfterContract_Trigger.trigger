trigger AfterContract_Trigger on Contract (After Insert,After Update) {

   if(trigger.isAfter)
   {
       if(trigger.isInsert)
         GPOContract_Handler.AfterInsert(trigger.NewMap);
         
      if(trigger.isUpdate)
         GPOContract_Handler.AfterUpdate(trigger.NewMap,trigger.OldMap);   
   }
   

}