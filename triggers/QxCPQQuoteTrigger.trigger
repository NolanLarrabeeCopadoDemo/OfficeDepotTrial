/*
* Copyright (c) 2018 by PROS, Inc.  All Rights Reserved.
* This software is the confidential and proprietary information of
* PROS, Inc. ("Confidential Information").
* You may not disclose such Confidential Information, and may only
* use such Confidential Information in accordance with the terms of
* the license agreement you entered into with PROS.
*
*
*@author : Romain Derval
*/
trigger QxCPQQuoteTrigger on CameleonCPQ__QxQuote__c (before insert, before update, after insert, after update, before delete) {
    List<CameleonCPQ__QxQuote__c>  lstOfNewTrigger = new List<CameleonCPQ__QxQuote__c>() ;
    List<CameleonCPQ__QxQuote__c>  lstOfOldTrigger = new List<CameleonCPQ__QxQuote__c>() ;
    List<CameleonCPQ__QxQuote__c>  lstOfQuotesToBUpdtd = new List<CameleonCPQ__QxQuote__c>() ;
    List<Id> lstOFQuotesFordocument = new List<Id> ();
    QxCPQQuoteTriggerHandler quoteHandler = new QxCPQQuoteTriggerHandler();
    // shravya trigger code start
     QxCPQQuoteTrigger_CustApprovalHandler QxCAH=New QxCPQQuoteTrigger_CustApprovalHandler();
    Salesrepupdate_handler Sah=new Salesrepupdate_handler();
    PROSWRFTaskCreation prostask=new PROSWRFTaskCreation();
    //shravya trigger code end
    if(Trigger.isInsert && Trigger.isBefore){
        //On Before Insert trigger
        quoteHandler.handleBeforeInsert(Trigger.new);
       Salesrepupdate_handler.AccOwner(Trigger.new);

    }
    else if(Trigger.isInsert && Trigger.isAfter){
        quoteHandler.handleAfterInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
        //On Before Update trigger
        quoteHandler.handleBeforeUpdate(Trigger.old,Trigger.new);
        //shravya trigger code start
        QxCAH.BeforeUpdate(trigger.New,trigger.oldmap);
        DOA_Approval_Rejcted_Handler.isBeforeUpdate(trigger.new,trigger.oldmap); 
              
        //shravya trigger code end
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        //On Before Update trigger
        quoteHandler.handleAfterUpdate(Trigger.old,Trigger.new);
        //shravya trigger code start
        for(CameleonCPQ__QxQuote__c prosQuote: Trigger.New) {
            if(trigger.oldMap.get(prosQuote.ID).CameleonCPQ__AccountId__r.Sales_PersonID__c != trigger.newMap.get(prosQuote.ID).CameleonCPQ__AccountId__r.Sales_PersonID__c ) {
            system.debug('the sales rep change');
            }
                if(trigger.newMap.get(prosQuote.ID).Account_Level__c == 'C' && trigger.oldMap.get(prosQuote.ID).BSD_Pricing_Approval_Status__c != trigger.newMap.get(prosQuote.ID).BSD_Pricing_Approval_Status__c && trigger.newMap.get(prosQuote.ID).Default_Account__c != null && trigger.newMap.get(prosQuote.ID).Default_Account__c != trigger.newMap.get(prosQuote.ID).Parent__c && trigger.newMap.get(prosQuote.ID).BSD_Pricing_Approval_Status__c == 'Submitted' && trigger.newMap.get(prosQuote.ID).CameleonCPQ__Status__c == 'In Review Internally (Post-Customer)') {
                    system.debug('Inheritance Account is changed');
                    lstOfNewTrigger.add(prosQuote);
                    Salesrepupdate_handler.createSCOEParent(lstOfNewTrigger);
                }
                else if(trigger.newMap.get(prosQuote.ID).Account_Level__c == 'P' && trigger.oldMap.get(prosQuote.ID).BSD_Pricing_Approval_Status__c != trigger.newMap.get(prosQuote.ID).BSD_Pricing_Approval_Status__c && trigger.newMap.get(prosQuote.ID).Default_Grandparent__c != null && trigger.newMap.get(prosQuote.ID).Default_Grandparent__c != trigger.newMap.get(prosQuote.ID).Grandparent__c && trigger.newMap.get(prosQuote.ID).BSD_Pricing_Approval_Status__c == 'Submitted' && trigger.newMap.get(prosQuote.ID).CameleonCPQ__Status__c == 'In Review Internally (Post-Customer)') {
                    system.debug('Grand parent is changed');
                    lstOfNewTrigger.add(prosQuote);
                    Salesrepupdate_handler.createSCOEGrandParent(lstOfNewTrigger);
                }
               else if(trigger.newMap.get(prosQuote.ID).Account_Level__c == 'GP' && trigger.oldMap.get(prosQuote.ID).BSD_Pricing_Approval_Status__c != trigger.newMap.get(prosQuote.ID).BSD_Pricing_Approval_Status__c && trigger.newMap.get(prosQuote.ID).Default_Great_Grandparent__c != null && trigger.newMap.get(prosQuote.ID).Default_Great_Grandparent__c != trigger.newMap.get(prosQuote.ID).Great_Grandparent__c && trigger.newMap.get(prosQuote.ID).BSD_Pricing_Approval_Status__c == 'Submitted' && trigger.newMap.get(prosQuote.ID).CameleonCPQ__Status__c == 'In Review Internally (Post-Customer)') {
                    system.debug('Great Grand parent is changed');
                    lstOfNewTrigger.add(prosQuote);
                    Salesrepupdate_handler.createSCOEGreatGrandParent(lstOfNewTrigger);
                }
         
            }
       // 
         Salesrepupdate_handler.Taskfrrep(Trigger.New,trigger.oldmap);
            // Functionality to create WRF Task
            QxCAH.AfterUpdate(trigger.New,trigger.oldmap);
            prostask.createTask(Trigger.New,Trigger.oldMap);
        //shravya trigger code end
    }
    else if(Trigger.isDelete && Trigger.isBefore){
        //On Before Delete trigger
        quoteHandler.handleBeforeDelete(Trigger.old);
    }
}