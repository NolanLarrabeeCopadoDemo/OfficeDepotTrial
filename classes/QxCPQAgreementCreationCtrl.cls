/*
 * Copyright (c) 2019 by PROS, Inc.  All Rights Reserved.
 * This software is the confidential and proprietary information of
 * PROS, Inc. ("Confidential Information").
 * You may not disclose such Confidential Information, and may only
 * use such Confidential Information in accordance with the terms of
 * the license agreement you entered into with PROS.
 *
 *
 *@author : Romain Derval 
 */
global class QxCPQAgreementCreationCtrl {

	 webservice static String createAgreement(ID qid){ 
		String result = 'OK';
		if(qid != null){
			
			List<CameleonCPQ__QxQuote__c> quotes = [SELECT Id,Name,PROSAgreement__AgreementStatus__c,CameleonCPQ__Status__c,CameleonCPQ__AccountId__r.AOPS_Cust_Id__c,Core_Id__c,PROSAgreement__StartDate__c,PROSAgreement__EndDate__c,Go_Live_Date__c FROM CameleonCPQ__QxQuote__c WHERE Id=: qid];
			
			if(quotes.size()>0){
                if(quotes[0].CameleonCPQ__AccountId__r.AOPS_Cust_Id__c != null && quotes[0].Core_Id__c != null){
                    if(quotes[0].PROSAgreement__AgreementStatus__c == null || (quotes[0].PROSAgreement__AgreementStatus__c != 'PendingPublish' && quotes[0].PROSAgreement__AgreementStatus__c != 'Published')){                        
                        if(quotes[0].CameleonCPQ__Status__c == 'Fully Approved'){
                            quotes[0].PROSAgreement__AgreementStatus__c='PendingPublish';
                            if(quotes[0].Go_Live_Date__c == null || quotes[0].Go_Live_Date__c < Date.today())
                                quotes[0].Go_Live_Date__c=Date.today();
                            quotes[0].PROSAgreement__StartDate__c = DateTime.newInstance(quotes[0].Go_Live_Date__c.year() ,quotes[0].Go_Live_Date__c.month() ,quotes[0].Go_Live_Date__c.day(),0,0,0).format('yyyy-MM-dd') ;
                            if(quotes[0].PROSAgreement__EndDate__c == null)
                                quotes[0].PROSAgreement__EndDate__c = DateTime.newInstance(2999 ,12 ,31).format('yyyy-MM-dd') ;
                            try {
                                update quotes[0];       
                            }
                            catch(Exception e) {
                                result = e.getMessage();
                            }                   
                            
                        }else{
                            result = 'Quote must be Fully Approved to publish Agreement' ;
                        }
                    }else{
                        result = 'Agreement already being created/published!' ; 
                    }
                }else{
                    result = 'Core not generated and/or Customer AOPS Id not existing (Prospect)' ;
                }
			}
			
		}
		return result;
	 }

}