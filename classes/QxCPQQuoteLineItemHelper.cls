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
public class QxCPQQuoteLineItemHelper {
   
    /*
    * Assign Quote Line Item Record Type & Filtered Quote Look Up
    */ 
    public static void assignQuoteLineType(List<CameleonCPQ__QxQuoteLine__c> qlis){
        //Retrieve Quote Line Items Record Type List
        Id productRTId = Schema.SObjectType.CameleonCPQ__QxQuoteLine__c.getRecordTypeInfosByName().get('Product').getRecordTypeId();
        Id rebateRTId = Schema.SObjectType.CameleonCPQ__QxQuoteLine__c.getRecordTypeInfosByName().get('Rebate').getRecordTypeId();
        Id cptRTId = Schema.SObjectType.CameleonCPQ__QxQuoteLine__c.getRecordTypeInfosByName().get('CPT').getRecordTypeId();
        Id complianceViolationRTId = Schema.SObjectType.CameleonCPQ__QxQuoteLine__c.getRecordTypeInfosByName().get('Compliance Violation').getRecordTypeId();
        Id executiveSummaryRTId = Schema.SObjectType.CameleonCPQ__QxQuoteLine__c.getRecordTypeInfosByName().get('Executive Summary').getRecordTypeId();        
        Id inheritedCPTRTId = Schema.SObjectType.CameleonCPQ__QxQuoteLine__c.getRecordTypeInfosByName().get('InheritedCPT').getRecordTypeId();
        
        for(CameleonCPQ__QxQuoteLine__c qli : qlis){
            
            if(qli.CameleonCPQ__LineTemplateId__c!=null){
                if(qli.CameleonCPQ__LineTemplateId__c =='ComplianceViolationLT'){
                    qli.RecordTypeId = complianceViolationRTId;
                    qli.Compliance_Quote__c = null;
                    qli.Product_Quote__c = null;
                    qli.Rebate_Quote__c = null;
                    qli.Compliance_Violation_Quote__c=qli.CameleonCPQ__QuoteId__c;
                    qli.Executive_Summary_Quote__c=null;
                }else if(qli.CameleonCPQ__LineTemplateId__c =='ComplianceLT'){
                    qli.RecordTypeId = cptRTId;
                    qli.Compliance_Quote__c = qli.CameleonCPQ__QuoteId__c;
                    qli.Product_Quote__c = null;
                    qli.Rebate_Quote__c = null;
                    qli.Compliance_Violation_Quote__c=null;
                    qli.Executive_Summary_Quote__c=null;
                }else if(qli.CameleonCPQ__LineTemplateId__c =='InheritedComplianceLT' || qli.CameleonCPQ__LineTemplateId__c =='InheritedCompliancePerDeptLT' ){
                    qli.RecordTypeId = inheritedCPTRTId;
                    qli.Compliance_Quote__c = null;
                    qli.Product_Quote__c = null;
                    qli.Rebate_Quote__c = null;
                    qli.Compliance_Violation_Quote__c=null;
                    qli.Executive_Summary_Quote__c=null;
                }else if(qli.CameleonCPQ__LineTemplateId__c =='ExecutiveSummaryLT'){
                    qli.RecordTypeId = executiveSummaryRTId;
                    qli.Compliance_Quote__c = null;
                    qli.Product_Quote__c = null;
                    qli.Rebate_Quote__c = null;
                    qli.Compliance_Violation_Quote__c=null;
                    qli.Executive_Summary_Quote__c=qli.CameleonCPQ__QuoteId__c; 
                }else if(qli.CameleonCPQ__LineTemplateId__c =='ProductLineTemplate'){
                    qli.RecordTypeId = productRTId;
                    qli.Product_Quote__c = qli.CameleonCPQ__QuoteId__c;
                    qli.Rebate_Quote__c = null;
                    qli.Compliance_Quote__c = null;
                    qli.Compliance_Violation_Quote__c=null;
                    qli.Executive_Summary_Quote__c=null;
                    
                    //Assign Error Message
                    if(qli.Pricing_Type__c == 'Core' && qli.Core_Ineligible__c=='Y'){
                        qli.Error_Message__c='The product is not eligible for core';
                    }else if (qli.Sync_Proposed__c < 0.01){
                        qli.Error_Message__c='Cannot price below $0.01';
                    }
                }else if(qli.CameleonCPQ__LineTemplateId__c =='RebateLT'){
                    qli.RecordTypeId = rebateRTId;
                    qli.Rebate_Quote__c = qli.CameleonCPQ__QuoteId__c;
                    qli.Product_Quote__c = null;
                    qli.Compliance_Quote__c = null;
                    qli.Compliance_Violation_Quote__c=null;
                    qli.Executive_Summary_Quote__c=null;
                }
            }

            }
        }
 

}