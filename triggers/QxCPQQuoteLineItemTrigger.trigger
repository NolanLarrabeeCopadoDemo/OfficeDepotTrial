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
trigger QxCPQQuoteLineItemTrigger on CameleonCPQ__QxQuoteLine__c (before insert,before update) {

    QxCPQQuoteLineItemTriggerHandler qliHandler = new QxCPQQuoteLineItemTriggerHandler();
    
    if(Trigger.isInsert && Trigger.isBefore){
        //On Before Insert trigger
        qliHandler.handleBeforeInsert(Trigger.new);
    }else if (Trigger.isUpdate && Trigger.isBefore){
        //On Before Insert update
        qliHandler.handleBeforeUpdate(Trigger.old,Trigger.new);
    }

}