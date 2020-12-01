public class RequestforQuoteUpdate_Ctrl {

Public CameleonCPQ__QxQuote__c Q{set;get;}
Public  QxQuote_Note__c N{set;get;}
Public  List<CameleonCPQ__QxQuote__c> quote{set;get;}
String QuoteId=Apexpages.currentPage().getParameters().get('Id');
    public RequestforQuoteUpdate_Ctrl(ApexPages.StandardController stdController) {
            Q=New CameleonCPQ__QxQuote__c();
             N=New QxQuote_Note__c();
       quote =[select id,owner.name 
                                             from CameleonCPQ__QxQuote__c 
                                             where id=:QuoteId and ownerid=:userinfo.getUserId()];
         if(quote.size()>0)  
         {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Quote cannot Request for Update.');
              ApexPages.addMessage(myMsg);
         }
        
    }
    
    Public Pagereference RequestforQuoteUpdate()
    {
     
     Q.id=QuoteId;
        
        N.QxQuote__c=Q.id;
        //N.Comment__c=Q.Request_For_Quote_Update_Types__c+' - Notes';
        
        Insert N;
        
          
      // Id PricingAnalyst = [Select PricingAnalyst__c from CameleonCPQ__QxQuote__c where id =:QuoteId].PricingAnalyst__c;
        //String Emailaddress =[select email FROM USER where id =:PricingAnalyst].email;
        //Update Q;
    Pagereference pg=New Pagereference('/'+QuoteId);
        Return pg;
        
        
    }
    
      Public class quotenotes{
        @AuraEnabled
        Public String Message {get;set;}
        @AuraEnabled
        Public List<String> Picklst {get;set;}        
        Public quotenotes(String Message,List<String> Picklst)
        {
            this.Message=Message;
            this.Picklst=Picklst;
            
        }   
    }
    
    
    @AuraEnabled
     Public static  Map<String, Object> RequestforQuoteUpdate(String quoteId,String notes,String quopicklist)
    {
        Map<String, Object> MyMap = new Map<String, Object>();
     CameleonCPQ__QxQuote__c Q = New CameleonCPQ__QxQuote__c();   
        CameleonCPQ__QxQuote__c quoteN = [Select Id,Request_for_quote_update_email_trigger__c,PricingAnalyst__c, Pricing_Analyst_Manager__c,Request_For_Quote_Update_Types__c from CameleonCPQ__QxQuote__c where Id =: quoteId];
     QxQuote_Note__c N=New QxQuote_Note__c();
     N.QxQuote__c = quoteId;
     N.Comment__c = notes;
     Q.Id=quoteId;
     Q.Request_For_Quote_Update_Types__c=quopicklist;
     if(quoteN.PricingAnalyst__c != null)
     N.Pricing_Analyst__c = quoteN.PricingAnalyst__c;
     if(quoteN.Pricing_Analyst_Manager__c != null)
     N.Pricing_Analyst_Manager__c = quoteN.Pricing_Analyst_Manager__c;
     
     
        if(quoteN.Request_for_quote_update_email_trigger__c != null){
            Q.Request_for_quote_update_email_trigger__c = quoteN.Request_for_quote_update_email_trigger__c + 1;
        }else{
            Q.Request_for_quote_update_email_trigger__c = 1;
        }
        
        try{
        update Q;
            Insert N;
             MyMap.put('StatusCode', 1);
        }
        catch(Exception e){
             MyMap.put('Status', e.getMessage());
                MyMap.put('StatusCode', -1);
                system.debug('ee****'+e.getStackTraceString());
                system.debug('ee**'+e.getMessage());
        }
        return MyMap;
    }
    
    @AuraEnabled
    
    Public Static quotenotes Onload(String RecId)
    {
       
       //public List<CameleonCPQ__QxQuote__c> quote{set;get;}
        
      List<CameleonCPQ__QxQuote__c> quote1 = new List<CameleonCPQ__QxQuote__c>();
      // String QuoteId1=Apexpages.currentPage().getParameters().get('Id');
       quote1 =[select id,owner.name from CameleonCPQ__QxQuote__c where id=:RecId and ownerid=:userinfo.getUserId()];

       String Message;
  List<String> Picklst= new  List<String>();
 
 
         if(quote1.size()>0)  
         {
              Message='Quote cannot Request for Update';
           
         }
        else{
            Message='Can Request';
              // Get the object type of the SObject.
  Schema.sObjectType objType = CameleonCPQ__QxQuote__c.getSObjectType();
  Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
  map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
  list < Schema.PicklistEntry > values =
   fieldMap.get('Request_For_Quote_Update_Types__c').getDescribe().getPickListValues();
  for (Schema.PicklistEntry a: values) {
   Picklst.add(a.getValue());
  }

        }

     quotenotes  wrpobj =  new quotenotes(Message,Picklst);
        return wrpobj;
}
 
}