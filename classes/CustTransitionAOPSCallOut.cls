// This code is to call the AOPS through SOA from Sales force Customer Transition Mod 2 Process
global class CustTransitionAOPSCallOut {
private static Integer responseCode;   
public static String constructXML(string sitecode,String sitevalue,  Id transId,string AOPSId){
    String parentXMLcode =  '<b2b:updateB2BAccountStatusRequest>' 
    + '<tran:transactionHeader>' 
       + '<tran:consumer>' 
            + '<tran:consumerName>' 
                +'SFDC'
            + '</tran:consumerName>' 
            + '<tran:consumerTransactionID>' 
                +transId
            + '</tran:consumerTransactionID>'                
    + '</tran:consumer>'      
    + '</tran:transactionHeader>'   
    +'<b2b:aopsAccountID>' 
        +AOPSId
    +'</b2b:aopsAccountID>' 
    +'<b2b:siteCode>' 
        +sitecode
    +'</b2b:siteCode>' 
    +'<b2b:siteValue>' 
        +sitevalue
    +'</b2b:siteValue>' 
     + '</b2b:updateB2BAccountStatusRequest>' ;
return parentXMLcode;
}

public static void callWebservice( String parentXML)
{
     String response;
  String domain,user,endPoint,fullXML,headerXML,footerXML, soapAction;
   CustTransParentChildLevel__c PCLevel2 = [select SOA_EndPoint__c,soa_user__c from CustTransParentChildLevel__c limit 1];
   fullXML=null;
   headerXML =null;
   footerXML =null;
   
    //endPoint='https://alliancebus.officedepot.com/osb-infra/updateB2BOMXAccountStatus';
    
       If (PCLevel2.SOA_EndPoint__c != null) {
       endPoint=PCLevel2.SOA_EndPoint__c+'osb-infra/updateB2BOMXAccountStatus';
       }
    System.debug('&&&&&&&&&&&&endPoint'+endPoint);
   //endPoint='https://osbdev01.officedepot.com/osb-infra/updateB2BOMXAccountStatus';
   soapAction=endPoint;
    
        If (PCLevel2.SOA_EndPoint__c != null) {
          system.debug('Debug trace1>>>>>>');
          //domain = PCLevel2.SOA_EndPoint__c;
          user = PCLevel2.soa_user__c;
        }

        headerXML = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:b2b="http://www.officedepot.com/model/B2BOMXAccountStatus" xmlns:tran="http://www.officedepot.com/model/transaction">'
                       + '<soapenv:Header/>'
                       + '<soapenv:Body>';
                                             
                   
        footerXML = '</soapenv:Body>'
                        + '</soapenv:Envelope>'; 
   String myData = user;                     
   String encodedusernameandpassword = 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(myData));
   HttpRequest req = new HttpRequest();
   fullXML =headerXML+parentXML+footerXML;
   
    System.debug('&&&&&&&&&&&&fullXML '+fullXML );
   req.setEndpoint(endPoint);
   req.setMethod('POST');
   req.setBody(fullXML);
   req.setHeader('Content-Type', 'text/xml');
   req.setHeader('SOAPAction', soapAction);
   req.setHeader('Authorization', encodedusernameandpassword);
   req.setTimeout(120000);
   Http http = new Http();


   if (!Test.isRunningTest()){
   HTTPResponse res = http.send(req);
   response = res.getBody(); 
   responseCode = res.getStatusCode();
   }
   
   if (Test.isRunningTest()){
       response = 'Dummy response';
       responseCode = 200;
   }
    
 System.debug('&&&&&&&&&&&&response '+response );
}

 public static void batchBasicAuthCallout(Id transId,string AOPSId, String SiteCode, String sitevalue){
   String parentXML,parentXMLwebUser,parentXMLorderHsty,parentXMLCSL =null;  
   
           //if(custRec.status__C=='Ready for eCom Mod'){
           parentXMLwebUser=constructXML(SiteCode,sitevalue,transId,AOPSId);          
           System.debug('&&&&&&&&&&&&parentXMLwebUser'+parentXMLwebUser);
           callWebservice(parentXMLwebUser);
            //return responseCode;
          // }
                         
   }

@Future(callout=true)
  public static  void basicAuthCallout(Id transId,string AOPSId, String SiteCode, String sitevalue){
   String parentXML,parentXMLwebUser,parentXMLorderHsty,parentXMLCSL =null;  
   
           //if(custRec.status__C=='Ready for eCom Mod'){
           parentXMLwebUser=constructXML(SiteCode,sitevalue,transId,AOPSId);          
           System.debug('&&&&&&&&&&&&parentXMLwebUser'+parentXMLwebUser);
           callWebservice(parentXMLwebUser);

          // }
                         
   }   
}