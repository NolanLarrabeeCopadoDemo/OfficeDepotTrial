/**
* CreatedBy: Shravya Channamadhavuni
* Date:12/07/2018
* Description: Partner signing up using Linkedin.
*/
public class PartnerRegistrationLinkedin {
    @AuraEnabled
    public static Map<String,String> getAccessTokenLinkedin(String tempcode) {
        system.debug('==>Temporary code that expires in 60 secs is:'+tempcode);
        Partner_Registration_Linkedin__mdt creds=partnerLeadC.LinkedinCred();
        String accesstoken;
        Map<String,Object> results = new Map<String,Object>();
        String endpoint=creds.tokenUrl__c+creds.ClientId__c+'&client_secret='+creds.Client_Secret__c+'&grant_type=authorization_code&redirect_uri='+creds.AuthURL__c+'&code='+tempCode;
        system.debug('==>endpoint of Linkedin loks like:'+endpoint);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        system.debug('==>end point is:'+endpoint);  
        req.setEndpoint(endpoint);
        req.setMethod('GET');
         
      if(!Test.IsRunningTest())
        {
            res=h.send(req);
            system.debug('==>response body is'+res.getBody());
            results = (Map<String,Object>)JSON.deserializeUntyped(res.getBody());
            }
            
            
            accesstoken=String.valueof(results.get('access_token'));
            system.debug('==>access token for Linkedin is:'+accesstoken);  
    
        Map<String,String> tmpmap= getUserDetails(accesstoken);
        system.debug('==>Return map came as:'+tmpmap);
        return tmpmap;
    }
    
    @AuraEnabled
    public Static Map<String,String> getUserDetails(String accessToken) {
        Partner_Registration_Linkedin__mdt creds=partnerLeadC.LinkedinCred();
        system.debug('==>access token came in as:'+accesstoken);  
        String spclchars='[!@#$%^&*(),.?":{}|<>]';
        String fname;
        String lname;
        String ttl;
        String cmpnynme;
        String headline;
        Map<String,String> rtrnmap= new Map<String,String>();
        String auth='Bearer'+' '+accesstoken;
        String endpoint=creds.endpoint__c;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        system.debug('==>bearer token looks like'+auth);
        req.setEndpoint(endpoint);
        req.setMethod('GET');   
        req.setHeader('Authorization',auth);
         if(!Test.IsRunningTest())
        {
   res=h.send(req);
   
            system.debug('==>response body is'+res.getBody());
            Dom.Document doc = res.getBodyDocument();
            Dom.XMLNode address = doc.getRootElement();
            fname = address.getChildElement('first-name', null).getText();
            lname = address.getChildElement('last-name', null).getText();
            headline = address.getChildElement('headline', null).getText();
            List<String> osplit=headline.split(' at ');
            system.debug('List contains:'+osplit);
            ttl=String.valueof(osplit).substringBefore(',').replaceAll(spclchars,'');
            cmpnynme=String.valueof(osplit).substringAfter(',').replaceAll(spclchars,'');
            system.debug('==>fanme:'+fname+'==>lname'+lname+'==>headline'+headline);
            system.debug('==>title is:'+ttl+'==>company is:'+cmpnynme);
            }
              else
        {
          Map<String,Object>  m = new Map<String, Object>();
            m.put('first_name', 'Given');
            m.put('last_name', 'Given');
            m.put('headline', 'Given');                        
        }
            rtrnmap.put('FirstName',fname);
            rtrnmap.put('LastName',lname);
            rtrnmap.put('Title',ttl);
            rtrnmap.put('CompanyName',cmpnynme);  
        
        system.debug('==>Return map is:'+rtrnmap);
        return rtrnmap;
    }
}