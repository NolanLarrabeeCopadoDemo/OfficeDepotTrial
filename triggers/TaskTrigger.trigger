// Appirio 2015 
// Universal trigger for Task object
//
// NBOCK - Original - S-364742 - trigger consolidation

trigger TaskTrigger on Task(before insert, before update, before delete, after insert, after update, after delete, after undelete){
    //Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone)
    
    if (Util.bypassTriggers('TaskTrigger')) {
        Util.DEBUG('Bypassing trigger TaskTrigger');
        return;
    }
    if(Trigger.New != null)
    {
          for(Task newTask : Trigger.New) {
        // Case 01442425 - Skip everything if the lead is of recordtype BizBox 
        if (newTask.RecordTypeId == Schema.SobjectType.Task.getRecordTypeInfosByName().get('BizBox').getRecordTypeId()||
           util.checkRT('Task').contains(newTask.recordtypeId)) {
            return;
        } 
         
         }
    }
//populate collections used in event handler 
TaskTriggerHandler handler = new TaskTriggerHandler(trigger.new, trigger.old, trigger.newMap, trigger.oldMap); 

    //call event handler methods 
    if(Trigger.IsInsert){ 
        if(Trigger.isBefore){ 
            handler.onBeforeInsert(); 
        } 
        else{ 
            handler.onAfterInsert(); 
        } 
    } 
    else if (Trigger.IsUpdate){ 
        if(Trigger.isBefore){ 
            handler.onBeforeUpdate(); 
        } 
        else{ 
            handler.onAfterUpdate(); 
        } 
    } 
    //no delete or undelete methods defined at this time
    /*else if(Trigger.isDelete){ 
        if(Trigger.isBefore){ 
            handler.onBeforeDelete();  
        } 
        else{ 
            handler.onAfterDelete(); 
        } 
    } 
    else if(Trigger.isUnDelete){ 
        handler.onAfterUnDelete(); 
    }*/
}