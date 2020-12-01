/******************************************************************************
Name            :  QuoteTriggerHandler
Created by      :  Hemant 11/4/2015
Story #         :  S-359750 [OD case # 00541425]
Description     :  To handle all trigger events of Quote object
******************************************************************************/
public class QuoteTriggerHandler {
  
  /****************************************************************************
    Method : Call on Before Insert on Quote 
  ****************************************************************************/
  public static void onBeforeInsert(List<Quote> newQuotesLst) {
    showErrorOnQuote_IU(newQuotesLst, null);
  }
  
  /****************************************************************************
  Method : Call on Before Update on Quote 
  ****************************************************************************/
  public static void onBeforeUpdate(List<Quote> newQuotesLst, Map<Id, Quote> quoteOldmap) {
    showErrorOnQuote_IU(newQuotesLst, quoteOldmap);
  }
  
  /****************************************************************************
    Method : Call on After Insert on Quote 
  ****************************************************************************/
  public static void onAfterInsert(List<Quote> newQuotesLst) {
    
    Notes_Create(newQuotesLst);
  }
  
  /** Method to show error message - 
  Ony one quote can be in Accpted status under an Opportunity. 
  When a quote is set to status as 'Accepted by Customer', then a check needs to be made to to see if any other quote under Opportunity already has status as 'Accepted by Customer'.
  If it does, then an error message needs to be thrown. */
  private static void showErrorOnQuote_IU(List<Quote> quoteLst, Map<Id, Quote> quoteOldmap){
  	
  	Set<id> opptyIds = new Set<id>();
    for(Quote q: quoteLst)
    {
      if(q.Status == Constants.STATUS_ACCEPTED_BY_CUSTOMER && q.OpportunityId != null)
        opptyIds.add(q.OpportunityId);
    }
    
    Map<Id, Quote> OpptyIdQuoteMap = new Map<Id, Quote>();
    for(Quote qot: [Select id, OpportunityId, Status from quote where OpportunityId in :opptyIds and Status =: Constants.STATUS_ACCEPTED_BY_CUSTOMER])
    {
        OpptyIdQuoteMap.put(qot.OpportunityId, qot);
    }
    
    for(Quote q: quoteLst)
    {
	    if(q.Status == Constants.STATUS_ACCEPTED_BY_CUSTOMER && OpptyIdQuoteMap.containsKey(q.OpportunityId))
	    {
	      if(quoteOldmap == null || q.Id != OpptyIdQuoteMap.get(q.OpportunityId).Id){
	        q.addError(Constants.QUOTETRIGGER_ERROR_MSG_ANOTHER_QUOTE_OPP);
	      }     
	    }
    }
  }
  
  /** Method to create exception Notes - 
  we are having the timing issue in SOA, GMIL to send the Notes and Create feed with delta in Time, 
  we are putting the exception Notes feed in the staging Table 
  and reading it back to process it once quote is created sucessfully. */
  private static void Notes_Create(List<Quote> quoteLst){
    
    for (Quote q: quoteLst) {
    	
      set<String> set_quoteID = new set<String> ();
      if(q.Quote_ID__c != '' && q.Quote_ID__c != null){
          set_quoteID .add(q.Quote_ID__c);
      }
      list<SOA_Exception__c> toDelete = new list<SOA_Exception__c>();
      if(set_quoteID.size() == 1){
      //avoid sending multiple Quote Note in one Go
	      list<SOA_Exception__c> soaexception_msg = [select id, SOAFeed__c,Quote_ID__c from SOA_Exception__c where Quote_ID__c =:set_quoteID order by createdDate desc]; 
	    
	      if(soaexception_msg .size()>0){              
	         QuoteUpdate.ServiceQuote obj = (QuoteUpdate.ServiceQuote) Json.deserialize(soaexception_msg[0].SOAFeed__c, QuoteUpdate.ServiceQuote.class);
	         if(!Test.isRunningTest())
	         QuoteUpdate.QuoteOperation(obj);
	         toDelete.add(soaexception_msg[0]);
	         System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@Deleted ID ::::'+soaexception_msg[0].id);
	      }
	      
	      if(toDelete.size()>0)
	        delete toDelete;
      }
    } 
  }
}