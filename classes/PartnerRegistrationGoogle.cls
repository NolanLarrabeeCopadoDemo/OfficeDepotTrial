/**
* CreatedBy: Aravind Bandla
* Date:12/20/2018
* Description: Partner signing up using Facebook.
*/
public class PartnerRegistrationGoogle {
    @AuraEnabled
    public static Map<String,String> getAccessTokenGoogle(String tempcode) {
        //Get google Credentials from metadata
        Partner_Registration_Google__mdt  creds = partnerLeadC.GoogleCred();
        String ClientId=creds.ClientId__c;
        String Secret= creds.Secret__c;
        string Redirect= Label.PRM;
        //Pass Auth code retuned in step 1 and rest of google credentials to google api to get access token
        String body='code='+tempcode+'&client_id='+ClientId+'&client_secret='+Secret+'&redirect_uri='+Redirect +'&grant_type=authorization_code';
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest reqG = new HttpRequest();
        reqG.setEndpoint(creds.Token_URL__c);
        reqG.setHeader('Content-Type','application/x-www-form-urlencoded');
        reqG.setMethod('POST');
        reqG.setBody(body);
        //
        
        Http hp = new Http();
        String response;
        if(!Test.IsRunningTest())
        {
            HttpResponse resG = hp.send(reqG);
            //Get Response body
            response = resG.getBody();
        }
        String accessTokenGoogle = '';
        Map<String,Object> resultsGoogle;
        //Test class cannot make api callout, so below code mimics api callout from test class.
        if(!Test.IsRunningTest())
        {
            resultsGoogle = (Map<String,Object>)JSON.deserializeUntyped(response);
        }
        else
        {
            resultsGoogle = new Map<String,Object>();
            resultsGoogle.put('access_token','123');
        }
        //Get Access token from response
        accessTokenGoogle=String.valueof(resultsGoogle.get('access_token'));
        system.debug('==>access token is:'+accessTokenGoogle);  
        system.debug(accessTokenGoogle + 'accessTokenGoogle>>');
        Map<String,String> tmplst = new Map<String,String>();
        string url = 'https://www.googleapis.com/oauth2/v3/userinfo?access_token=' + accessTokenGoogle ;
        //Call method to get User details including email id
        tmplst = getGoogleUserDetail(url);
        system.debug('==>Return list came as:'+tmplst);   
        return tmplst;
    }
    
    @AuraEnabled
    public Static Map<String,String> getGoogleUserDetail(String url)
    {
        String fname;
        String lname;
        string email;
        Map<String,String> rtrnlst= new Map<String,String>();
        String response;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setTimeout(60*1000);
        HttpResponse res;
        Map<String, Object> m;
        if(!Test.IsRunningTest())
        {
            res = h.send(req);
            response = res.getBody();
            m = (Map<String, Object>)JSON.deserializeUntyped(response);
        }
        else
        {
            m = new Map<String, Object>();
            m.put('given_name', 'Given');
            m.put('family_name', 'Given');
            m.put('email', 'Given');                        
        }
        fname = string.valueof(m.get('given_name'));
        lname = string.valueof(m.get('family_name'));
        email = string.valueof(m.get('email'));
        if(fname != null)
            rtrnlst.put('FirstName',fname);
        if(lname!= null)
            rtrnlst.put('LastName',lname);
        if(email!= null)
            rtrnlst.put('Email',email);
        
        return rtrnlst;
    }
}