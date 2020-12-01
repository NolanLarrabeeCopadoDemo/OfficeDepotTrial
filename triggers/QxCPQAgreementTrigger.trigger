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
trigger QxCPQAgreementTrigger on PROS_Agreement__c (before insert, before update, after insert, after update, before delete) {

    QxCPQAgreementTriggerHandler agHandler = new QxCPQAgreementTriggerHandler();
    
    if(Trigger.isInsert && Trigger.isBefore){
        //On Before Insert trigger
        //agHandler.handleBeforeInsert(Trigger.new);
    }
    else if(Trigger.isInsert && Trigger.isAfter){
        //agHandler.handleAfterInsert(Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isBefore){
        //On Before Update trigger
        //agHandler.handleBeforeUpdate(Trigger.old,Trigger.new);
    }
    else if(Trigger.isUpdate && Trigger.isAfter){
        //On Before Update trigger
        agHandler.handleAfterUpdate(Trigger.old,Trigger.new);
    }
    else if(Trigger.isDelete && Trigger.isBefore){
        //On Before Delete trigger
        //agHandler.handleBeforeDelete(Trigger.old);
    }
    
}