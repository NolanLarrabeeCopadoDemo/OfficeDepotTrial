public with sharing class QuoteServiceManual {
 // public ServiceQuote qotw { get; set;}
  public Boolean VisibleTable{get;set;}
  public Boolean BlockVisible {get;set;}
  
  Public List<Quote> QuoteObj{get;set;}
  public String str{get;set;}
  public String AOPS_CUSTOMER_ID {get; set;}
  public String QUOTE_NAME{get; set;}
  public String QUOTE_ID{get; set;}
  public String STATUS{get; set;}
  public String CREATION_DATE{get; set;}
  public String LAST_UPDATE_DATE{get; set;}
  public String CLOSE_DATE{get; set;}
  public String QUANTITY{get; set;}
  public String TOTAL_AMOUNT{get; set;}
  public String COST{get; set;}
  public String NOTES{get; set;}
  public String REMARKS{get; set;}
  public String FNAME{get; set;}
  public String LNAME{get; set;}
  public String PHONE{get; set;}
  public String EMAIL{get; set;}
  public String ROLE{get; set;}
  public String A0PS_CONTACT_NUMBER{get; set;}
  public String USERNAME{get; set;}
  public String SUBMITTER_FNAME{get; set;}
  public String SUBMITTER_LNAME{get; set;}
  public String SUBMITTER_EMAIL{get; set;}
  public String SUBMITTER_CONTACT{get; set;}
  public String COMMENT{get;set;}
  public String CUSTOMER_SHIP_ID{get;set;}
  //public soapQuoteupdate.ServiceQuote qotw{get;set;}
 
 
  public soapQuoteupdate2.ServiceQuote qot = new  soapQuoteupdate2.ServiceQuote ();
 

   partnerSoapSforceCom.Soap sp = new partnerSoapSforceCom.Soap();
    
 public QuoteServiceManual (){
 VisibleTable=false;
 BlockVisible=true;

}
     public PageReference save(){
      
        qot.AOPS_CUSTOMER_ID=AOPS_CUSTOMER_ID ;
        qot.QUOTE_NAME  =QUOTE_NAME;
        qot.QUOTE_ID    =QUOTE_ID;
        qot.STATUS  =STATUS;
        qot.CREATION_DATE =CREATION_DATE;
        qot.LAST_UPDATE_DATE    =LAST_UPDATE_DATE;
        qot.CLOSE_DATE  =CLOSE_DATE;
        qot.QUANTITY    =QUANTITY;
        qot.TOTAL_AMOUNT    =TOTAL_AMOUNT;
        qot.REMARKS   =REMARKS;
        qot.CONTACT_FNAME   =FNAME;
        qot.CONTACT_LNAME   =LNAME;
        qot.CONTACT_PHONE   =PHONE;
        qot.CONTACT_EMAIL   =EMAIL;
        qot.COMMENT = COMMENT;
        qot.A0PS_CONTACT_NUMBER =A0PS_CONTACT_NUMBER;
        qot.SUBMITTER_FNAME =SUBMITTER_FNAME;
        qot.SUBMITTER_LNAME =SUBMITTER_LNAME;
        qot.SUBMITTER_EMAIL =SUBMITTER_EMAIL;
        qot.CUSTOMER_SHIP_ID    =CUSTOMER_SHIP_ID;
        qot.TOTAL_COST    =COST;
        System.Debug('AopsId'+AOPS_CUSTOMER_ID);
        //BlockVisible=false;
        try{

            partnerSoapSforceCom.LoginResult loginResult = sp.login('jasmeet.singh1@wipro.com.uat', 'J@ssi1131a3D0BEPV7OpmrwOrk3VYn8CLg');
            system.debug('   loginResult ' + loginResult);
            soapQuoteupdate2.QuoteUpdate apexWebSvc = new soapQuoteupdate2.QuoteUpdate();
            soapQuoteupdate2.SessionHeader_element sessionHeader = new soapQuoteupdate2.SessionHeader_element();
            sessionHeader.sessionId = loginResult.sessionId;
            // The Web services have a maximum timeout of 2 minutes. The timeout value
            // is in milliseconds.
            apexWebSvc.timeout_x = 120000;
            apexWebSvc.SessionHeader = sessionHeader;
            String cid;
            if (!test.isRunningTest()){
            cid = apexWebSvc.QuoteOperation(qot);
            }
            QuoteObj =[Select Id,Name from Quote where Id =: cid];
            
            VisibleTable= true;
      
            return null;
        }
        catch (Exception e) {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Unexpected Exception:' + e));
           return null;
        }

      }

}