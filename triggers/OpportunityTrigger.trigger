/***************************************************************************
Name            :  OpportunityTrigger
Created by      :  Hemant 11/4/2015
Story #         :  S-359752 [OD case # 00541429]
Description     :  To handle all triggers of Opportunity
******************************************************************************/
trigger OpportunityTrigger on Opportunity (before insert, before update, after insert, after update) {
    
    //code for PRM permissions - starts
      if (trigger.isafter && (trigger.isupdate || trigger.isinsert)) {

          opportunitydealShare.shareOpportunitywithPartner(Trigger.new,Trigger.oldMap);
      }
    //Code for PRM permissions - ends
    
    //Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone)
    for(Opportunity o: trigger.new)
    {
        if(util.checkRT('Opportunity').contains(o.recordtypeId))
            return;
    }
    // added for ticket 01474559
       if (Trigger.New != null) {
         for (Opportunity myOpp: Trigger.new) {
          if (Util.bizBoxRTIdsByObject('Opportunity').contains(myOpp.RecordTypeId)) {
           return;
          }
         }
        }

    // Common actions to be taken for insert and update
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        System.debug('OpportunityTrigger > Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)');
        System.debug('OpportunityTrigger > Trigger.New.size() = ' + Trigger.New.size());
        OpportunityTriggerHandler.onBeforeUpsert(Trigger.New);
    }
    
    //before insert
    if (trigger.isBefore && trigger.isInsert) {
        OpportunityTriggerHandler.onBeforeInsert(trigger.new);
    }
    
    //before update
    if (trigger.isBefore && trigger.isUpdate) {
        OpportunityTriggerHandler.onBeforeUpdate(trigger.new, trigger.oldMap);
    }
    
    
    // code for K-12 starts from here 
    List<Opportunity> OpptyList = new List<Opportunity>();
    
    //before update
    if (trigger.isafter) {
        // Calling the Opportunity Hostory populating logic 
        OpportunityTriggerHandler newRec = new OpportunityTriggerHandler();
        //newRec.processOpportunityHistory(Trigger.New, Trigger.OldMap);
    }
}