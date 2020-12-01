global with sharing virtual class WebRequester {
    Map<String,String> headers=new Map<String,String>();
    public WebRequester(){
        
    }
    
    public void clear(){
        headers.clear();
    }
    
    public void setHeader(String header,String value){
        headers.put(header,value);
    }
    
    public virtual String post(String url, String body){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setbody(body);
        req.setTimeout(120000);
        for (String key : headers.keySet()){
            req.setHeader(key, headers.get(key));

        }
        Http http = new Http();
        HTTPResponse res = http.send(req);
        if (res.getStatusCode()!=200){
            System.debug('Snowflake error response body: '+res.getBody());
            throw new ExternalObjectException('Error status returned from Snowflake: "'+res.getStatusCode());
        }

        return res.getBody();
    }
}