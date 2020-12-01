public class PartnerRegistrationFacebook {
    @AuraEnabled
    public static map<string,string> getAccessTokenFacebook (string tempCode){
        Facebook_Registration__mdt creds = partnerLeadC.FacebookCred();
        String clientId= creds.Facebook_ClientId__c;
        String secret= creds.Facebook_Secret__c;
        String urls = Label.PRM;
        String auth = creds.Auth_Url__c;
        String tokenURI = auth+clientId+'&redirect_uri='+urls+'&client_secret='+secret+'&code='+tempCode;

         System.debug('tokenURI is:'+tokenURI);
        //Get request to get access token
        HttpRequest reqfb = new HttpRequest();
        reqfb.setEndpoint(tokenURI);
        reqfb.setMethod('GET');
        reqfb.setTimeout(60*1000);
        
        Http hp = new Http();
        String response;
        if(!Test.IsRunningTest())
        {
        HttpResponse resFb = hp.send(reqfb);
        response = resFb.getBody();
        }
        String accessTokenfb = '';
         Map<String,Object> resultsfb;
        if(!Test.IsRunningTest())
        {
        resultsfb = (Map<String,Object>)JSON.deserializeUntyped(response);
            
        }else{
          resultsfb = new Map<String,Object>();
          resultsfb.put('access_token','123');
            
        }
        accessTokenfb = String.valueof(resultsfb.get('access_token'));
        system.debug('==>Facebook access token is:'+accessTokenfb);  
        system.debug(accessTokenfb + 'accessTokenfb>>');
        Map<String,String> tmplst = new Map<String,String>();
        //string url = 'https://graph.facebook.com/me?fields=id,first_name,last_name,email&redirect=false&access_token=' + accessTokenfb;
        String aUrl = creds.Access_Token_Url__c;
        String  url = aUrl+'fields=id,first_name,last_name,email&redirect=false&access_token=' + accessTokenfb;
        //Get user information 
        tmplst = getFBUserDetail(url);
        system.debug('==>Return list came as:'+tmplst);   
        return tmplst;
    }

    @AuraEnabled
    public Static Map<String,String> getFBUserDetail(String url)
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
       
        //rtrnlst.add(response);
        String JSONContent = response;
        system.debug('Facebook response>>' +response );
         m = (Map<String, Object>)JSON.deserializeUntyped(JSONContent);
            
        }   else
        {
            m = new Map<String, Object>();
            m.put('first_name', 'Given');
            m.put('first_name', 'Given');
            m.put('email', 'Given');                        
        }
        
        fname = string.valueof(m.get('first_name'));
        lname = string.valueof(m.get('first_name'));
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