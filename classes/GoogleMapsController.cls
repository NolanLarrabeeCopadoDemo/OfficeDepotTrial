//Using GoogleMapsControllerTC
public class GoogleMapsController{
    public static string getGoogleMapsAPIKey() {
       //string strKey = Label.Google_Place_Key;
       string strKey = Label.Google_Address_Search_Key;
        
       // string strKey=Label.GeoKeyUAT;
        return strKey;
    }

    @AuraEnabled
    public static string getAddressAutoComplete(String input, String types) {
        String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=' +
                EncodingUtil.urlEncode(input, 'UTF-8') +
               '&fields=name,formatted_address,address_component,geometry' +
                '&types=' +types + //'establishment' + //
               '&key=' + GoogleMapsController.getGoogleMapsAPIKey();
               

        System.debug(url);
        return GoogleMapsController.getHttp(url);
    }

    @AuraEnabled
    public static string getAddressPlaceInfo(String input) {
        String url = 'https://maps.googleapis.com/maps/api/place/details/json?placeid=' + 
                EncodingUtil.urlEncode(input, 'UTF-8') +'&fields=name,formatted_address,address_component,geometry'                   + '&key=' + GoogleMapsController.getGoogleMapsAPIKey();
        System.debug(url);
        //+ '&fields=adr_address,alt_id,formatted_address,geometry.viewport,geometry.location,icon,name,permanently_closed,photos,place_id,plus_code,scope,type,url,utc_offset,vicinity'
        return GoogleMapsController.getHttp(url);
    }

    public static string getHttp(string strURL) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setMethod('GET');
        req.setEndpoint(strURL);
        req.setTimeout(120000);
        res = h.send(req);
        String responseBody = res.getBody();
        //  System.debug(responseBody);
        return responseBody;
    }
}