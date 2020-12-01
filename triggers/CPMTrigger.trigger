// Appirio 2015 
// Universal trigger for CPM__c object
//
// NBOCK - Original - S-364743 - consolidation of CPM_Trigger and caseApprovalStatus trigger on CPM object

trigger CPMTrigger on CPM__c(before insert, before update, before delete, after insert, after update, after delete, after undelete){ 

//populate collections used in event handler 
CPMTriggerHandler handler = new CPMTriggerHandler(trigger.new, trigger.old, trigger.newMap, trigger.oldMap); 

    //call event handler methods 
    
    // Common actions to be taken for insert and update
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        handler.onBeforeUpsert(Trigger.New);
    }
  
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
  } */
}