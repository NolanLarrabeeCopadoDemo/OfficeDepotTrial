public without sharing class quoteAllHelperMeths {
    /* Update billing Address and shipping address
     * 
     * */
    public static void prefillAddressfiled(List<Quote> quoteLstRcvd) {
        List<Quote>  quoteLstToBInsrtd = new List<Quote> ([select id,Bill_To_Account__r.Address1__c,Bill_To_Account__r.City__c,Bill_To_Account__r.State__c,Bill_To_Account__r.Country__c,Bill_To_Account__r.Name,Ship_To_Account__r.Name,Ship_To_Account__r.Address1__c,Ship_To_Account__r.City__c,Ship_To_Account__r.State__c,Ship_To_Account__r.Country__c From quote where ID IN : quoteLstRcvd]);
        List<Quote> quoteLstTobUpdtd = new List<Quote> ();
      system.debug('After Insert- Quotes to updated Address'+quoteLstToBInsrtd);
        for(Quote q:quoteLstToBInsrtd) {
            system.debug('the bill to adress line 1 is:'+q.Bill_To_Account__r.Address1__c+'the ship to address line 1 is:'+q.Ship_To_Account__r.Address1__c);
            q.BillingName= q.Bill_To_Account__r.Name;
            q.ShippingName = q.Ship_To_Account__r.Name;
            q.BillingStreet=q.Bill_To_Account__r.Address1__c;
            q.BillingCity = q.Bill_To_Account__r.City__c ;
            q.BillingState = q.Bill_To_Account__r.State__c ;
            q.BillingCountry = q.Bill_To_Account__r.Country__c;
            q.ShippingStreet=q.Ship_To_Account__r.Address1__c;
            q.ShippingCity = q.Ship_To_Account__r.City__c ;
            q.ShippingState = q.Ship_To_Account__r.State__c ;
            q.ShippingCountry = q.Ship_To_Account__r.Country__c;
            quoteLstTobUpdtd.add(q);
        }
          system.debug('the list of quotes with bill to and ship to:'+quoteLstTobUpdtd);
        update quoteLstTobUpdtd;
    }
    /* Insert a quote with pricebook Id
     * 
     * */
    public static void updatePricebookId(List<Quote> quoteLstRcvd,String priceId) {
        system.debug('this is firing for before Insert to pricebook'+quoteLstRcvd);
        List<Quote> quoteLstTobUpdtd = new List<Quote> ();
        for(Quote q: quoteLstRcvd) {
           q.pricebook2id= priceId;
            quoteLstTobUpdtd.add(q);
        }
        system.debug('the list of quotes withprice quotes:'+quoteLstTobUpdtd);
        
    }
}