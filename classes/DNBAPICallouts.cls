public class DNBAPICallouts{
    public static  HTTPResponse getAccessToken(String endpoint, String key){
        HTTPRequest request = new HTTPRequest();
        request.setEndPoint(endpoint); //'https://plus.dnb.com/v2/token'
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'Basic '+key);
        request.setMethod('POST');
        request.setBody('{ "grant_type" : "client_credentials" }');
        HTTP hp = new HTTP();
        HTTPResponse response = hp.send(request);
        return response;
    }
    
    public static HTTPResponse getSearchResults(String endpoint, String key, String content){
        //String url = 'https://plus.dnb.com/v1/search/criteria';           
        HTTPRequest req = new HTTPRequest();
        req.setEndPoint(endpoint);
        req.setHeader('Authorization', 'Bearer '+key);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        req.setBody(content);
        HTTP h = new HTTP();
        HTTPResponse response = h.send(req);
        return response;
    }
}