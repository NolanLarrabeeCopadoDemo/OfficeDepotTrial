public class QuoteTriggerHelper extends TriggerHandler {
    private List<Quote> newQuoteList;
    private Map<Id, Quote> oldQuoteMap;
    private Map<Id, Quote> newQuoteMap;
    @TestVisible static Boolean bypassTrigger = True;
    
    public QuoteTriggerHelper() {
        this.newQuoteList = (List<Quote>) Trigger.New;
        this.oldQuoteMap = (Map<Id, Quote>) Trigger.OldMap;
        this.newQuoteMap = (Map<Id, Quote>) Trigger.NewMap;
    }
    /* Update the price book id before inserting a quote trigger
* Secondary purpose: Using QuoteTriggerHandler for SOA connection process
* */
    public override void beforeInsert(){
        ID pricebookId;
        List<Quote> lstOfQuotesToBUpdtdForPB = new List<Quote> ();
        List<Quote> lstOfQuotesToBUpdtdBySOA = new List<Quote> ();
        if(Test.isRunningTest()) {
            pricebookId = Test.getStandardPricebookId();
        } else {
            PriceBook2 p= [SELECT Id FROM PriceBook2 WHERE IsStandard = true];
            pricebookId = p.Id;
        }
        //For SOA connection
        RecordType rtCust   = [SELECT Id FROM RecordType WHERE sObjectType = : label.QuoteSoaconnection	 AND Name = :label.QuoteSoaconnectionRecType];
        system.debug('The recordtypeid is:'+rtCust.Id);
        for(Quote q:newQuoteList) {
            if(q.RecordTypeId == rtCust.Id) {
                lstOfQuotesToBUpdtdBySOA.add(q); 
            } else
            {
                lstOfQuotesToBUpdtdForPB.add(q);    
            }
    }
           //For SOA connection
        QuoteTriggerHandler.onBeforeInsert(lstOfQuotesToBUpdtdBySOA);
        //for TechSales Project
        quoteAllHelperMeths.updatePricebookId (lstOfQuotesToBUpdtdForPB,pricebookId);
    }
    /* Fetch address from bill To Account and ship to account and update it to Billinaddress and shippingaddress
     * * Secondary purpose: Using QuoteTriggerHandler for SOA connection process
**/
    public override void afterInsert(){
        system.debug('Quote Trigger-After Insert-Tech Sales');
        List<Quote> lstOfQuotesToBUpdtd = new List<Quote> ();
        List<Quote> lstOfQuotesToBUpdtdBySOA = new List<Quote> ();
         //For SOA connection
        RecordType rtCust   = [SELECT Id FROM RecordType WHERE sObjectType = : label.QuoteSoaconnection	 AND Name = :label.QuoteSoaconnectionRecType];
        system.debug('The recordtypeid is:'+rtCust.Id);
        for(Quote q:newQuoteList) {
            if(q.RecordTypeId == rtCust.Id) {
                lstOfQuotesToBUpdtdBySOA.add(q);                
            } else if(q.Bill_To_Account__c != null || q.Ship_To_Account__c != null) {
                lstOfQuotesToBUpdtd.add(q);
            }
        }
        system.debug('list of quotes for updating Address'+lstOfQuotesToBUpdtd);
         //for TechSales Project
        quoteAllHelperMeths.prefillAddressfiled (lstOfQuotesToBUpdtd);
         //For SOA connection
        QuoteTriggerHandler.onAfterInsert(lstOfQuotesToBUpdtdBySOA);
    }
}