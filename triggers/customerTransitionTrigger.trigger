// Appirio 2015 
// Universal trigger for Customer_Transition__c object
//
// NBOCK - Original - 7.15.2015 - S-335210

trigger customerTransitionTrigger on Customer_Transition__c(before insert, before update, before delete, after insert, after update, after delete, after undelete){ 

//populate collections used in event handler 
customerTransitionTriggerHandler handler = new customerTransitionTriggerHandler(trigger.new, trigger.old, trigger.newMap, trigger.oldMap); 

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
    //currently not in use
    /*
    else if(Trigger.isDelete){ 
        if(Trigger.isBefore){ 
            handler.onBeforeDelete();  
        } 
        else{ 
            handler.onAfterDelete(); 
        } 
    } */
}