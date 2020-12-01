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
public class QxCPQQuoteLineItemTriggerHandler {

    /**
    * Main method called on a before insert trigger on the CameleonCPQ__QxQuoteLine__c object (PROS Quote Line Item)
    */
    public void handleBeforeInsert(List<CameleonCPQ__QxQuoteLine__c > qlis)
    {
        //Detemrine the Type of Quote Line Items upon creation : Product/Rebate/CPT
        QxCPQQuoteLineItemHelper.assignQuoteLineType(qlis);
    }
    
        /**
    * Main method called on a before insert trigger on the CameleonCPQ__QxQuoteLine__c object (PROS Quote Line Item)
    */
    public void handleBeforeUpdate(List<CameleonCPQ__QxQuoteLine__c > qlisOld,List<CameleonCPQ__QxQuoteLine__c > qlisNew)
    {
        String errorMsg = 'Cannot price below $0.01';
        //Reset Count for compliance items        
        for(CameleonCPQ__QxQuoteLine__c qli : qlisNew){
            if(qli.Violation_Requirement__c == 'No' && qli.Violation_Count__c != null)
                qli.Violation_Count__c = null;
            if(qli.CameleonCPQ__LineTemplateId__c =='ProductLineTemplate' && (qli.Core_Ineligible__c == 'Y' || qli.Sync_Proposed__c < 0.01)){
                if(qli.Core_Ineligible__c == 'Y')
                    errorMsg='The product is not eligible for core';
                qli.Error_Message__c=errorMsg;
            }else{
               qli.Error_Message__c=null; 
            }
                
        }

    }
}