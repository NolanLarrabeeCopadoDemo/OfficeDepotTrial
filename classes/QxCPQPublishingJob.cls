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
 * Job to start agreement publishing on Fully Approved Post Customer Approval quotes
 */
global class QxCPQPublishingJob implements Schedulable{
    
    global void execute(SchedulableContext sc) {
        String result = 'N/A';
        //Get the Fully approved quotes with the agreement process still in Draft
        List<CameleonCPQ__QxQuote__c> quotes = [SELECT Id,
                                                	   Name,
                                                	   Quote_Number__c,
                                                	   PROSAgreement__AgreementStatus__c,
                                                	   CameleonCPQ__SyncStatus__c
                                                FROM CameleonCPQ__QxQuote__c 
                                                WHERE (PROSAgreement__AgreementStatus__c = null OR PROSAgreement__AgreementStatus__c='Drafting')
                                                AND CameleonCPQ__Status__c = 'Fully Approved' 
                                                AND CameleonCPQ__SyncStatus__c = 'COMPLETE'
                                                LIMIT 25];
       for (CameleonCPQ__QxQuote__c quote : quotes) {
           System.debug('Starting Agreement Publishing process for ' + quote.Quote_Number__c + ' - ' + quote.Name);
           result = QxCPQAgreementCreationCtrl.createAgreement(quote.Id);
           System.debug('Agreement Publishing process for ' + quote.Quote_Number__c + ' - ' + quote.Name + ' : ' + result);
       }
    }

}