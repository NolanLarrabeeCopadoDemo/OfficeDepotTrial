/*
we are having the timing issue in SOA, GMIL to send the Notes and Create feed with delta in Time, 
we are putting the exception Notes feed in the staging Table 
and reading it back to process it once quote is created sucessfully.
*/
trigger Notes_Create on Quote (after insert) {
  for (Quote q: Trigger.new) {
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