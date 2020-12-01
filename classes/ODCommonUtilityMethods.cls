public class ODCommonUtilityMethods {
    public static List<String> getPicklistOptions(sObject objObject,
                                                  string fieldName) {
        List<String> allOptions = new List<String>();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Map <String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        List <Schema.PicklistEntry> values = fieldMap.get(fieldName).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            allOptions.add(a.getValue());
        }
        allOptions.sort();
        return allOptions;
    }
    // Goolge maps rest api method.
    public static string getGoogleMapsAPIKey() {
        string strKey = Label.Google_Place_Key;
        return strKey;
    }

    //Method Description : This method is used for showing pridicted value in address search bar  lightning page.
    @AuraEnabled
    public static string getAddressAutoComplete(String input, String types) {
        String url =
            'https://maps.googleapis.com/maps/api/place/autocomplete/json?input='
            +
            EncodingUtil.urlEncode(input, 'UTF-8') +
            '&types=' + types +
            '&key=' + ODCommonUtilityMethods.getGoogleMapsAPIKey();
        System.debug(url);
        return ODCommonUtilityMethods.getHttp(url);
    }

    //Method Description : This method is used for showing particular addrsss details based on placeid.
    @AuraEnabled
    public static string getAddressPlaceInfo(String input) {
        String url =
            'https://maps.googleapis.com/maps/api/place/details/json?placeid=' +
            EncodingUtil.urlEncode(input,
                                   'UTF-8') + '&key=' +
            ODCommonUtilityMethods.getGoogleMapsAPIKey();
        System.debug(url);
        return ODCommonUtilityMethods.getHttp(url);
    }

    //Method Description : HTTP method invoke Google api to fetch address details.
    public static string getHttp(string strURL) {
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setMethod('GET');
        req.setEndpoint(strURL);
        req.setTimeout(120000);
        res = h.send(req);
        String responseBody = res.getBody();
        System.debug('getting==> json response = ' + responseBody);
        return responseBody;
    }


    public static Map<Id, String> getRecordTypeIdToName(String objectApiName){

        Map<Id, String> IdToName = new Map<Id, String>();
        Schema.DescribeSObjectResult r =
            Schema.getGlobalDescribe().get(objectApiName).getDescribe();

        Map<String, RecordTypeInfo> devNameToRecordType =
            r.getRecordTypeInfosByDeveloperName();

        for (String developerName: devNameToRecordType.keySet()) {
            IdToName.put(devNameToRecordType.get(developerName).getRecordTypeId(), developerName);
        }

        return IdToName;
    }

    public static Map<String, Id> getRecordTypeDeveloperNameToId(String objectApiName){

        Map<String, Id> dev_name_recordtype_id = new Map<String, Id>();
        Schema.DescribeSObjectResult r =
            Schema.getGlobalDescribe().get(objectApiName).getDescribe();

        Map<String, RecordTypeInfo> devNameToRecordType =
            r.getRecordTypeInfosByDeveloperName();

        for (String developerName: devNameToRecordType.keySet()) {
            dev_name_recordtype_id.put(developerName, devNameToRecordType.get(developerName).getRecordTypeId());
        }

        return dev_name_recordtype_id;
    }

    public static Map<String, Object> generate_map_from_iterable(List<SObject> iterable, String key_field, String value_field){
        Map<String, Object> my_map = new Map<String,Object>();

        for(SObject item: iterable){
            my_map.put((String) item.get(key_field), (Object) item.get(value_field));
        }
        return my_map;
    }

    public static Map<String, Object> generate_map_from_iterable(Set<SObject> iterable, String key_field, String value_field){
        Map<String, Object> my_map = new Map<String,Object>();

        for(SObject item: iterable){
            my_map.put((String) item.get(key_field), (Object) item.get(value_field));
        }
        return my_map;
    }    

}