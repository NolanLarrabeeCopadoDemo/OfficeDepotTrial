public class CrossRefGetAccessToken {
    @AuraEnabled(cacheable=true)
    public static String getAccessToken()
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:SFDC_Alternates/api/v1/login/access-token');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody('username={!$Credential.Username}&password={!$Credential.Password}');
        HTTPResponse response = http.send(req);
        if (response.getStatusCode() > 204){
            System.debug(LoggingLevel.ERROR, response.getStatusCode() + ' ' + response.getBody());
            throw new AuraHandledException('Could not authenticate against product search service! Please create a case with subject Product Search is not available.');
        } else {
            System.debug(LoggingLevel.INFO, response.getStatusCode());
        }
        TokenResponse restoken = (TokenResponse)JSON.deserialize(response.getBody(), TokenResponse.class);
        return restoken.access_token;
        
    }
    
    public class TokenResponse {
        @AuraEnabled  public String access_token;
        @AuraEnabled  public String token_type;
    }

}