/*************************************************************
*Name : ResyncAccountClass
*Created By : Himanshu Sharma
*Created Date :20-03-2020
*Purpose : Test class for ResyncAccountClass class
*JIRA: NAIT-125221
****************************************************************/
public class ResyncAccountClass {
@AuraEnabled
    public static String ResyncAccount(String addressSeq, String AOPSAccountId)
    {
        string addseq=addressSeq;
        string AopsAccID=AOPSAccountId;
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:trackAccountSetupCredential/resyncAccount'); //using named credential-trackAccountSetupCredential for hitting the EAI service
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        String body='{'+
        '\"AddressSequence\": \"'+addressSeq +'\",'+
        '\"AOPSAccountID\": \"'+AOPSAccountId+'\"'+
        '}';
        req.setBody(body);
        Http http = new Http();
        String response;
        HTTPResponse res;
        res=http.send(req);
        response=res.getBody();
        return response;
      }
    public class Setinfo{
      public String o_Rtn_Msg; 
    } 
}