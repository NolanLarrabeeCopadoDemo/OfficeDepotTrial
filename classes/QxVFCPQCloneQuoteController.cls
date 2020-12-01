/*
 * Copyright (c) 2015 - 2018 by PROS, Inc.  All Rights Reserved.
 * This software is the confidential and proprietary information of
 * PROS, Inc. ("Confidential Information").
 * You may not disclose such Confidential Information, and may only
 * use such Confidential Information in accordance with the terms of
 * the license agreement you entered into with PROS.
 */
 
/**
 * Clone Quote - Lightning/Classic controller.
 *
 * @author rderval
 */
public class QxVFCPQCloneQuoteController {
	
    /** The debugging service */
    //public static final CameleonCPQ.QxApiClient.IDebug IDebug = new CameleonCPQ.QxApiClient.DebugFactory().newInstance();
	
    /*Global variables*/
    private static final String QX_CLONE_LABEL_PREFIX = 'Clone of ';
    private static final String QX_CLONE_LABEL_SUFFIX = '';
    //public static String cloneQuoteName{get;set;}
    /** 
     * Constructor
     *
     * @param stdController The Salesforce standard controller
     */
    public QxVFCPQCloneQuoteController(ApexPages.StandardController stdController) {
         // Empty
    }

    /** 
     * Clone the Salesforce quote object (QxQuote__c)
     *
     * @param quoteId The source quote identifier.
     * @return CloneQuoteResult The result of the clone quote operation.
     * @throws QuoteCloneException Any error catched during the clone operation.
     */
    @RemoteAction
    public static CloneQuoteResult cloneSfdcQuote(String quoteId, String qtName) {
        CloneQuoteResult result = new CloneQuoteResult();
        System.debug('1');
        final Map<String, Schema.SObjectField> flds = Schema.SObjectType.CameleonCPQ__QxQuote__c.fields.getMap();
        final List<String> fieldList = new List<String>();
        System.debug('2');
        fieldList.addAll(flds.keySet());
        String quoFlds = '';
        for(integer i=0; i<fieldList.size(); i++)
          if (flds.get(fieldList[i]).getDescribe().IsCreateable() && fieldList[i] != 'PROSAgreement__Agreement_Id__c')
              quoFlds = quoFlds + (quoFlds.length()>0?', ':'') + fieldList[i];
        
        quoFlds = (quoFlds == '' ?  'Name, CameleonCPQ__Status__c' : quoFlds) ;  
        
        if(!quoFlds.containsIgnoreCase('PricingAnalyst__c'))
        	quoFlds =  quoFlds+', PricingAnalyst__c';
        
        final String qry = 'SELECT '+quoFlds+' FROM CameleonCPQ__QxQuote__c where Id=\''+quoteId+'\'';
        System.debug('Query'+qry);
        System.debug('3');
        SObject[] queryObject;
        try {
            System.debug('4');
           queryObject = Database.query(qry);       
        }
        catch(Exception e) {
            System.debug('5'+e);
            System.debug('5'+e.getStackTraceString());
           //CameleonCPQ.QxApiClient.IDebug.debug(Logginglevel.ERROR.name(),'Exception raised when executing query ['+qry+'] :'+e.getMessage());
           throw new QuoteCloneException(e.getMessage());
        }
        if(queryObject!=null && queryObject.size()>0) {
           CameleonCPQ__QxQuote__c[] oriQuoteList = new CameleonCPQ__QxQuote__c[]{ (CameleonCPQ__QxQuote__c)queryObject[0] };
           CameleonCPQ__QxQuote__c[] newQuoteList = oriQuoteList.deepClone(false);
           String name = (String)newQuoteList[0].get('Name');
            if(name!=null ){
                qtName = qtName != null && qtName.trim() != '' ? qtName.trim() :QX_CLONE_LABEL_PREFIX+(name.length()>71?name.substring(0,70):name)+QX_CLONE_LABEL_SUFFIX;
                System.debug('qtName :'+qtName);
                //System.debug('qtName :'+cloneQuoteName);
               newQuoteList[0].put('Name',qtName);
            }
            newQuoteList[0].put('OwnerId',UserInfo.getUserId());
            QxCPQQuoteHelper.cloneQuoteProcess(oriQuoteList[0],newQuoteList[0]);
           try {
               System.debug('6 :'+newQuoteList);
               if(!QxCPQQuoteCheckAccess.checkPricingAnalyst(oriQuoteList[0])){
                   insert newQuoteList[0];
               }
               else{
                   throw new QuoteCloneException('Can not edit when Pricing Analyst populated');
               }
           } catch (DmlException e) {
              throw new QuoteCloneException(e.getDmlMessage(0));
           }
           result.targetId = newQuoteList[0].Id;
        }
        return result; 
    }

    /** 
     * Clone the quote-x quote
     *
     * @param oriQuoteId The source quote identifier.
     * @param newQuoteId The target quote identifier.
     * @return CloneQuoteResult The result of the clone quote operation.
     * @throws CloneQuoteException Any error catched during the clone operation.
     */
    @RemoteAction
    public static CloneQuoteResult cloneQxQuote(final String oriQuoteId, final String newQuoteId) {
        CloneQuoteResult result = new CloneQuoteResult();

        final Map<Id,CameleonCPQ__QxQuote__c> q = new Map<Id, CameleonCPQ__QxQuote__c>(
            [SELECT Id, Name, CameleonCPQ__ExternalQuoteId__c FROM CameleonCPQ__QxQuote__c WHERE Id IN: new String[]{oriQuoteId, newQuoteId}]);         

        if (q.get(oriQuoteId)==null) {
            System.debug('1');
            throw new QuoteCloneException('Source quote does not exist');
        }
        if (q.get(newQuoteId)==null) {
            System.debug('2');
            throw new QuoteCloneException('Target quote does not exist');
        }

        // Step 1 :Initialize a quote-x session
        final CameleonCPQ.QxApiClient.InitSessionResponse apiResponse1 = CameleonCPQ.QxApiClient.InitSession(new CameleonCPQ.QxApiClient.InitSessionRequest());
        if(apiResponse1.qxException!=null) {
            System.debug('3'+apiResponse1.qxException);
           throw new QuoteCloneException(apiResponse1.qxException);
        }    

        // Step 2 :Clone the quote-x quote
        final CameleonCPQ.QxApiClient.CloneQuoteRequest apiRequest2 = new CameleonCPQ.QxApiClient.CloneQuoteRequest();
        final CameleonCPQ.QxApiClient.QxRequestContext qxReqCtx = new CameleonCPQ.QxApiClient.QxRequestContext();
        qxReqCtx.sessionId = apiResponse1.sessionId;
        qxReqCtx.crmQuoteId = oriQuoteId;
        qxReqCtx.qxQuoteId = q.get(oriQuoteId).CameleonCPQ__ExternalQuoteId__c;
        apiRequest2.qxReqCtx = qxReqCtx;
        CameleonCPQ.QxApiClient.CloneQuoteRequestBody requestBody = new CameleonCPQ.QxApiClient.CloneQuoteRequestBody();
        requestBody.description = q.get(newQuoteId).Name;
        apiRequest2.requestBody = requestBody;

        final CameleonCPQ.QxApiClient.CloneQuoteResponse apiResponse2 = CameleonCPQ.QxApiClient.cloneQuote(apiRequest2);
        if (apiResponse2.statusCode >= 400) {
            System.debug('4'+apiResponse2);
            System.debug('4'+qxReqCtx);
           throw new QuoteCloneException(apiResponse2.qxException);
        }
        else {
           q.get(newQuoteId).CameleonCPQ__ExternalQuoteId__c = apiResponse2.id;
            QxCPQQuoteCheckAccess.isClone = true;
           update q.get(newQuoteId);
           result.targetId = apiResponse2.id;
        }
        return result; 

    }

    /**
     * The result of a cloneQuote operation.
     */
    public class CloneQuoteResult {

        /** The ID of the cloned quote */
        public String targetId { get; set; }
    }

    /**
     * Exception class.
     */
    public class QuoteCloneException extends Exception {}


   
    /** 
     * Create & Publih the quote agreement
     *
     * @param qId The source Quote Id
     * @return Result The result of the publish quote operation.
     */
    @RemoteAction
    public static String createAgreement(ID qid){ 
		String result = 'OK';
		if(qid != null){
			
			List<CameleonCPQ__QxQuote__c> quotes = [SELECT Id,Name,PROSAgreement__AgreementStatus__c,CameleonCPQ__Status__c,CameleonCPQ__AccountId__r.AOPS_Cust_Id__c,Core_Id__c,PROSAgreement__StartDate__c,PROSAgreement__EndDate__c,Go_Live_Date__c FROM CameleonCPQ__QxQuote__c WHERE Id=: qid];
			
			if(quotes.size()>0){
                if(quotes[0].CameleonCPQ__AccountId__r.AOPS_Cust_Id__c != null && quotes[0].Core_Id__c != null){
                    if(quotes[0].PROSAgreement__AgreementStatus__c == null || (quotes[0].PROSAgreement__AgreementStatus__c != 'PendingPublish' && quotes[0].PROSAgreement__AgreementStatus__c != 'Published')){
                        if(quotes[0].CameleonCPQ__Status__c == 'Fully Approved'){
                            quotes[0].PROSAgreement__AgreementStatus__c='PendingPublish';
                            quotes[0].Quote_Accepted_Timestamp__c=DateTime.now();
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

    
    /*
     * Refresh Contract Terms
     * 
     * @param qId The source Quote Id
     * @return Result The result of the refresh contract terms operation.
     */
    @RemoteAction
    public static String refreshContractTerms(ID qid){ 
		String result = 'OK';
		if(qid != null){
			
			List<CameleonCPQ__QxQuote__c> quotes = [SELECT Id,Name,CameleonCPQ__Status__c,Contract_Term_Refresh_Trigger__c FROM CameleonCPQ__QxQuote__c WHERE Id=: qid];
			
			if(quotes.size()>0){

				if(quotes[0].CameleonCPQ__Status__c == 'Draft'){
					quotes[0].Contract_Term_Refresh_Trigger__c = !quotes[0].Contract_Term_Refresh_Trigger__c;
					try {
						update quotes[0];       
					}
					catch(Exception e) {
						result = e.getMessage();
					}  
				}else{
					result = 'Quote must be Draft to refresh contract terms.' ;
				}
 
			}
			
		}
		return result;
	 }

}