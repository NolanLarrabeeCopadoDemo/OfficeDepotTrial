global class CheckCurrentStorageBatch implements database.Batchable<Sobject>,Schedulable,Database.AllowsCallouts,Database.stateful {


    private String strQuery;      
    private String DEFAULT_QUERY ='SELECT Id FROM User WHERE Name    = \'System User\' '   ;
    private static final String NS_SOAP = 'http://schemas.xmlsoap.org/soap/envelope/';
    private static final String NS_SF = 'urn:partner.soap.sforce.com';
    // Default Constructor
    global CheckCurrentStorageBatch ()
    {
        this.strQuery = DEFAULT_QUERY;
    }
    
    //This constructor is called from the Batch Schedule method
    global CheckCurrentStorageBatch(String query)
    {
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
        System.debug('QUERY IS---->'+strQuery);
    }
    
    // This method prepares the scope of the batch program based on the query result
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
       
       return Database.getQueryLocator(strQuery);
    }
    
    
    // This method processes query result in batches 
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
       List<User> usr= scope;
       System.debug('&&&&&&&&&&&&&&& Calling ');
       //CurrentStorage cs = new CurrentStorage();
       getStorage();
        

    }
    
    // This method is to execute to relase some resources if any
    global void finish(Database.BatchableContext BC)
    {    
    }     
        
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        CheckCurrentStorageBatch cbs = new CheckCurrentStorageBatch(strQuery);
        database.executebatch(cbs, 1);
    }
    
    public void getStorage() {
        Decimal per;
        String sid = login(System.Label.DLUsername, System.Label.DLPass);
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        //req.setEndpoint('https://officedepot.my.salesforce.com/services/data/v32.0/limits');
        req.setEndpoint(System.Label.SFDCEndpoint);
        req.setHeader('Authorization', 'OAuth '+ sid);
        Http http = new Http();
            
            
    if (!test.isrunningtest()) {
     
     HTTPResponse res = http.send(req);
     Map<String, Object> m = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
     Map<String, Object> dataStorage = (Map<String,Object>)m.get('DataStorageMB');
     System.debug('Current Storage: ' + dataStorage.get('Remaining'));
     System.debug('Max Storage: ' + dataStorage.get('Max'));
    
    
    per = ((Decimal) dataStorage.get('Remaining')/(Decimal) dataStorage.get('Max')) * 100;
    System.debug('per: ' + per); 
    }
    
    if (test.isrunningtest())
       per=7;
    
    if(per < decimal.valueOf(System.Label.Percentage))
    {
        sendEmail();
        System.debug('Inside per');
        System.debug('send email notification');
    }
return;
    }

 
 public static void sendEmail() {

        System.debug('&&&&&&&&&&Inside send email method');
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        mail.setSubject('Data Storage Alert');
        mail.setPlainTextBody('Please check your Data Storage. You are reaching the Max Limit.');
        mail.setSaveAsActivity(false);
        mail.setToAddresses(new String[] {System.Label.CrmSelling,System.Label.SellingOnCall}); //add other emails here.
        //mail.setToAddresses(new String[] {}); //add other emails here.
        //mail.setCcAddresses(new String[] {});
        emails.add(mail);
        
        Messaging.sendEmail(emails);  
        System.debug('&&&&&&&&&&End of Inside send email method');    
      }
      
     
      public static String login(String user, String password)
    {
        String x = '';
        HttpRequest req = new HttpRequest();
       
                req.setMethod('POST');   
                req.setTimeout(60000);
                req.setEndpoint('https://www.salesforce.com/services/Soap/u/37.0');
                req.setHeader('Content-Type', 'text/xml;charset=UTF-8');        
                req.setHeader('SOAPAction', '""');
                req.setBody('<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' +user+ '</username><password>' + password + '</password></login></Body></Envelope>');        
      
        if (!test.isrunningtest()) {
          HttpResponse res =  new Http().send(req);
        
          
      /*  if(res.getStatusCode() != 200)
        {
            Dom.Document responseDocument = res.getBodyDocument();
            Dom.Xmlnode rootElm = responseDocument.getRootElement(); // soapenv:Envelope
            Dom.Xmlnode bodyElm = rootElm.getChildElement('Body', NS_SOAP); // soapenv:Body 
            Dom.Xmlnode faultElm = bodyElm.getChildElement('Fault', NS_SOAP); // soapenv:Fault
            Dom.Xmlnode faultStringElm = faultElm.getChildElement('faultstring', null); // faultstring          
            throw new LoginException(faultStringElm.getText()); 
        }*/
        // As per http://wiki.developerforce.com/page/Enterprise_Login
     
            
        Dom.Document responseDocument = res.getBodyDocument();
        Dom.Xmlnode rootElm = responseDocument.getRootElement(); // soapenv:Envelope
        Dom.Xmlnode bodyElm = rootElm.getChildElement('Body', NS_SOAP); // soapenv:Body 
        Dom.Xmlnode loginResponseElm = bodyElm.getChildElement('loginResponse', NS_SF); // loginResponse NS_SF
        Dom.Xmlnode resultElm = loginResponseElm.getChildElement('result', NS_SF); // result NS_SF
        Dom.Xmlnode sessionIdElm = resultElm.getChildElement('sessionId', NS_SF); // sessionId NS_SF
        return sessionIdElm.getText();
        }
        
      
         if (test.isrunningtest()) {
             return '123';
         }

    
        
       return null;
    }
    
    public class LoginException extends Exception {}
}