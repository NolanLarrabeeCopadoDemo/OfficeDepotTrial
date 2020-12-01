/*
 * Created by Adam on 8/8/2018.
 *
 * @description This class is used to make an external request to the aggro for the token
 *
 * @group Aggro
 *
 * @group-content /ApexDocContent/Index.htm
 */
public with sharing class AggroService {
    class Aggro_Service_Exception extends Exception {
    }

    static Aggro_Service__mdt aggro_service_token =
    [SELECT Aggro_Access_Token__c,
     Aggro_Service_URL__c FROM Aggro_Service__mdt WHERE DeveloperName = 'Service_Details'];

    static Set<String> ALLOWED_METHODS = new Set<String> {'GET', 'POST'};

    static HttpRequest buildRequest(String url, Map<String, String> headers, String method, String endpoint) {
        if (!ALLOWED_METHODS.contains(method))
            throw new Aggro_Service_Exception('Method must be one of the following:' + ALLOWED_METHODS);


        HttpRequest request = new HttpRequest();

        for (String key : headers.keySet()) {
            request.setHeader(key, headers.get(key));
        }
        request.setMethod(method);
        request.setTimeout(20000);
        request.setEndpoint(aggro_service_token.Aggro_Service_URL__c + endpoint);

        return request;
    }

    public static String getTokenRequest(String username, String password){
        Map<String, String> creds = new Map<String, String> {
            'username'=> username,
            'password'=> password
        };

        Map<String, String> headers = new Map<String, String> {
            'accept' => 'application/json',
            'content-type' => 'application/json'
        };
        HttpRequest myReq = buildRequest(aggro_service_token.Aggro_Service_URL__c, headers, 'POST',
                                         '/api/token/');
        myReq.setBody(JSON.serialize(creds));
        Http http = new Http();
        HTTPResponse res = http.send(myReq);
        System.debug(LoggingLevel.INFO, res.getBody());
        if (res.getStatusCode() != 201 && res.getStatusCode() != 200) {
            System.debug(LoggingLevel.ERROR,
                         'Callout to Aggro Service Failed with code ' + String.valueOf(
                             res.getStatusCode()) +
                         ' ' + res.getBody());
        } else {
            return res.getBody();
        }

        return null;
    }

    public static Boolean checkAggroServiceHealth() {

        HttpRequest request = new HttpRequest();

        request.setEndpoint(aggro_service_token.Aggro_Service_URL__c + '/health');
        request.setHeader('accept', 'application/json');
        request.setMethod('GET');

        Http http = new Http();
        HTTPResponse res = http.send(request);
        System.debug(LoggingLevel.INFO, res.getBody());
        return '{"health":"ok"}'.equals(res.getBody());
    }

    public static String getAccountsWithToken(String name,
                                              String street_1,
                                              String street_2,
                                              String city,
                                              String state,
                                              String zip_5) {

        Aggro_Service__mdt aggro_token =
        [SELECT Aggro_Access_Token__c FROM Aggro_Service__mdt WHERE DeveloperName = 'Dev_Token'];

        String responseBody;

        Map<String, String> headers = new Map<String, String> {
            'accept' => 'application/json',
            'content-type' => 'application/json',
            'Authorization' => 'Bearer ' + aggro_service_token.Aggro_Access_Token__c
        };

        HttpRequest request =
            buildRequest(aggro_service_token.Aggro_Service_URL__c, headers, 'POST',
                         '/lookup/search/account/');


        Map<String, String> body = new Map<String, String>();
        body.put('duns_number', '');
        body.put('name', name);
        body.put('street_1', street_1);
        body.put('street_2', '');
        body.put('city', city);
        body.put('state', state);
        body.put('zip_code', zip_5);
        body.put('recordtype', 'Customer');

        Map<String, Object> record = new Map<String, Object>();
        record.put('record', body);

        request.setBody(JSON.serialize(record));
        System.debug(LoggingLevel.INFO, JSON.serialize(record));
        System.debug(LoggingLevel.INFO, aggro_service_token.Aggro_Service_URL__c);

        Http http = new Http();
        try {
            HTTPResponse res = http.send(request);
            System.debug(LoggingLevel.INFO, res.getBody());
            if (res.getStatusCode() != 201 && res.getStatusCode() != 200) {
                System.debug(LoggingLevel.ERROR,
                             'Callout to Aggro Service Failed with code ' + String.valueOf(
                                 res.getStatusCode()) +
                             ' ' + res.getBody());
                responseBody = null;
            } else {
                responseBody = res.getBody();
            }
        } catch (CalloutException e) {
            System.debug('Callout to Aggro Service Failed: ' + e.getMessage());
        }
        return responseBody;
    }

    public static String getSiteAndUltimate(String duns) {

        Aggro_Service__mdt aggro_token =
        [SELECT Aggro_Access_Token__c FROM Aggro_Service__mdt WHERE DeveloperName = 'Dev_Token'];
        HttpRequest request = new HttpRequest();
        String responseBody;

        request.setEndpoint(Label.Aggro_Service_Endpoint + '/gazetteer/duns/');
        request.setHeader('content-type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + aggro_token.Aggro_Access_Token__c);
        request.setMethod('POST');

        Map<String, String> body = new Map<String, String>();
        body.put('duns_number', duns);

        Map<String, Object> record = new Map<String, Object>();
        record.put('record', body);

        request.setBody(JSON.serialize(record));
        System.debug(LoggingLevel.INFO, JSON.serialize(record));


        Http http = new Http();
        try {
            HTTPResponse res = http.send(request);
            System.debug(LoggingLevel.INFO, res.getBody());
            if (res.getStatusCode() != 201 || res.getStatusCode() != 200) {
                System.debug(LoggingLevel.ERROR,
                             'Callout to Aggro Service Failed with code ' + String.valueOf(
                                 res.getStatusCode()) +
                             ' ' + res.getBody());
                responseBody = null;
            }
            responseBody = res.getBody();
        } catch (CalloutException e) {
            System.debug('Callout to Aggro Service Failed: ' + e.getMessage());
        }
        return responseBody;
    }

    public static String getAlternateLinkage(String duns_number) {

        Aggro_Service__mdt aggro_token =
        [SELECT Aggro_Access_Token__c FROM Aggro_Service__mdt WHERE DeveloperName = 'Dev_Token'];

        HttpRequest request = new HttpRequest();
        String responseBody;


        request.setEndpoint(Label.Aggro_Service_Endpoint + '/lookup/dnb_operational/');
        request.setHeader('content-type', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + aggro_token.Aggro_Access_Token__c);
        request.setMethod('POST');

        String body = '{"request":{"duns_id": "' + duns_number + '"}';
        request.setBody(body);
        Http http = new Http();

        try {
            HTTPResponse res = http.send(request);
            System.debug(LoggingLevel.INFO, res.getBody());
            if (res.getStatusCode() != 201 || res.getStatusCode() != 200) {
                System.debug(LoggingLevel.ERROR,
                             'Callout to Aggro Service Failed with code ' + String.valueOf(
                                 res.getStatusCode()) +
                             ' ' + res.getBody());
                responseBody = null;
            }
            responseBody = res.getBody();
        } catch (CalloutException e) {
            System.debug('Callout to Aggro Service Failed: ' + e.getMessage());
        }
        return responseBody;
    }


    /*
     * *****************************************************************************************************
     *
     * @author Adam Albright, adam.albright@officedepot.com, 21 May 2019
     *
     * @description
     *
     * @param
     */
    public static String aggroSearchV2(String name, String street_1, String city, String state,
                                       String zip_5) {

        HttpRequest request = new HttpRequest();
        String responseBody;

        request.setEndpoint(aggro_service_token.Aggro_Service_URL__c + '/lookup/search/dnb/');
        request.setHeader('content-type', 'application/json');
        request.setHeader('accept', 'application/json');
        request.setHeader('Authorization', 'Bearer ' + aggro_service_token.Aggro_Access_Token__c);
        request.setMethod('POST');

        Map<String, String> body = new Map<String, String>();
        body.put('name', name);
        body.put('street_1', street_1);
        body.put('city', city);
        body.put('state', state);
        body.put('zip_code', zip_5);

        Map<String, Object> record = new Map<String, Object>();
        record.put('record', body);

        request.setBody(JSON.serialize(record));
        System.debug(LoggingLevel.INFO, JSON.serialize(record));
        System.debug(LoggingLevel.INFO, aggro_service_token.Aggro_Service_URL__c);

        Http http = new Http();
        try {
            HTTPResponse res = http.send(request);
            System.debug(LoggingLevel.INFO, res.getBody());
            if (res.getStatusCode() != 201 && res.getStatusCode() != 200) {
                System.debug(LoggingLevel.ERROR,
                             'Callout to Aggro Service Failed with code ' + String.valueOf(
                                 res.getStatusCode()) +
                             ' ' + res.getBody());
                responseBody = null;
            } else {
                responseBody = res.getBody();
            }
        } catch (CalloutException e) {
            // Add an error event here
            System.debug('Callout to Aggro Service Failed: ' + e.getMessage());
        }
        return responseBody;
    }

    /*
     * *****************************************************************************************************
     *
     * @author Adam Albright, adam.albright@officedepot.com, 21 May 2019
     *
     * @description
     *
     * @param
     */
    public static String aggroAccountSearch(String name, String street_1, String city, String state,
                                            String zip_5) {

        String responseBody;
        Map<String, String> headers = new Map<String, String> {
            'accept' => 'application/json',
            'content-type' => 'application/json',
            'Authorization' => 'Bearer ' + aggro_service_token.Aggro_Access_Token__c
        };

        HttpRequest request =
            buildRequest(aggro_service_token.Aggro_Service_URL__c, headers, 'POST',
                         '/lookup/search/account/');

        Map<String, String> body = new Map<String, String> {
            'name' => name,
            'street_1' => street_1,
            'city' => city,
            'state' => state,
            'zip_code' => zip_5
        };

        Map<String, Object> record = new Map<String, Object> {
            'record' => body
        };

        request.setBody(JSON.serialize(record));
        System.debug(LoggingLevel.INFO, JSON.serialize(record));
        System.debug(LoggingLevel.INFO, aggro_service_token.Aggro_Service_URL__c);

        Http http = new Http();
        try {
            HTTPResponse res = http.send(request);
            System.debug(LoggingLevel.INFO, res.getBody());
            if (res.getStatusCode() != 201 && res.getStatusCode() != 200) {
                System.debug(LoggingLevel.ERROR,
                             'Callout to Aggro Service Failed with code ' + String.valueOf(
                                 res.getStatusCode()) +
                             ' ' + res.getBody());
                responseBody = null;
            } else {
                responseBody = res.getBody();
            }
        } catch (CalloutException e) {
            // Add an error event here
            System.debug('Callout to Aggro Service Failed: ' + e.getMessage());
        }
        return responseBody;
    }


    @future(callout = True)
    public static void aggroBulkSearchV2Future(String json_bulk_list) {
        aggroBulkSearchV2(json_bulk_list);
    }

    public static void aggroBulkSearchV2(String json_bulk_list) {

        Map<String, String> headers = new Map<String, String> {
            'accept' => 'application/json',
            'content-type' => 'application/json',
            'Authorization' => 'Bearer ' + aggro_service_token.Aggro_Access_Token__c
        };

        HttpRequest request = buildRequest(aggro_service_token.Aggro_Service_URL__c, headers, 'POST',
                                           '/lookup/bulk/');

        request.setBody(json_bulk_list);
        if (Test.isRunningTest()) {
            System.debug(LoggingLevel.INFO, json_bulk_list);
            System.debug(LoggingLevel.INFO, aggro_service_token.Aggro_Service_URL__c);
        }

        Http http = new Http();
        String responseBody = null;
        try {
            HTTPResponse res = http.send(request);
            System.debug(LoggingLevel.INFO, res.getBody());
            if (res.getStatusCode() != 201 && res.getStatusCode() != 200) {
                System.debug(LoggingLevel.ERROR,
                             'Callout to Aggro Service Failed with code ' + String.valueOf(
                                 res.getStatusCode()) +
                             ' ' + res.getBody());
            } else {
                responseBody = res.getBody();
            }
        } catch (CalloutException e) {
            // Add an error event here
            System.debug('Callout to Aggro Service Failed: ' + e.getMessage());
        }
    }


    /*
     * *****************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com, 28 May 2019
     * @description initiates callout for synchronous bulk search. Do not call out with too many records.
     * @param JSON serialized list of Aggro_Match__c objects.
     * @return A list of search results as Aggro_Matche__c objects.
     */
    public static String aggroBulkSearchSyncV2(String json_bulk_list) {

        Map<String, String> headers = new Map<String, String> {
            'accept' => 'application/json',
            'content-type' => 'application/json',
            'Authorization' => 'Bearer ' + aggro_service_token.Aggro_Access_Token__c
        };

        HttpRequest request =
            buildRequest(aggro_service_token.Aggro_Service_URL__c, headers, 'POST', '/lookup/search/multi/');

        request.setBody(json_bulk_list);
        System.debug(LoggingLevel.INFO, request);
        if (Test.isRunningTest()) {
            System.debug(LoggingLevel.INFO, json_bulk_list);
            System.debug(LoggingLevel.INFO, aggro_service_token.Aggro_Service_URL__c);
        }

        Http http = new Http();
        String responseBody = null;
        HTTPResponse res = http.send(request);
        System.debug(LoggingLevel.INFO, res.getBody());
        if (res.getStatusCode() != 201 && res.getStatusCode() != 200) {
            System.debug(LoggingLevel.ERROR,
                         'Callout to Aggro Service Failed with code ' + String.valueOf(
                             res.getStatusCode()) + ' ' +
                         res.getBody());
            throw new Aggro_Service_Exception(
                      'Callout to Aggro Service Failed with code ' + String.valueOf(
                          res.getStatusCode()) + ' ' +
                      res.getBody());
        } else {
            responseBody = res.getBody();
            return responseBody;
        }
    }

    /*
     * *****************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com, 28 May 2019
     * @description initiates callout for synchronous bulk search. Do not call out with too many records.
     * @param JSON serialized list of Aggro_Match__c objects.
     * @return A list of search results as Aggro_Matche__c objects.
     */
    @future(callout = true)
    public static void postUpdatedAccounts(Set<Id> updatedAccountIds) {

        Map<String, String> headers = new Map<String, String> {
            'accept' => 'application/json',
            'content-type' => 'application/json',
            'Authorization' => 'Bearer ' + aggro_service_token.Aggro_Access_Token__c
        };

        HttpRequest request = buildRequest(aggro_service_token.Aggro_Service_URL__c, headers, 'POST',
                                           '/ingest/salesforce/');

        List<Account> myUpdatedAccounts =[
            SELECT
            Id,
            Name,
            Type,
            RecordType.DeveloperName,
            ParentId,
            BillingStreet,
            BillingCity,
            BillingState,
            BillingPostalCode,
            BillingCountry,
            BillingLatitude,
            BillingLongitude,
            BillingGeocodeAccuracy,
            ShippingStreet,
            ShippingCity,
            ShippingState,
            ShippingPostalCode,
            ShippingCountry,
            ShippingLatitude,
            ShippingLongitude,
            ShippingGeocodeAccuracy,
            Phone,
            Fax,
            AccountNumber,
            Website,
            PhotoUrl,
            Sic,
            Industry,
            AnnualRevenue,
            NumberOfEmployees,
            Ownership,
            TickerSymbol,
            Description,
            Site,
            CreatedDate,
            AccountSource,
            SicDesc,
            Primary_Site_ID__c,
            AOPS_Cust_Id__c,
            AOPS_Seq_ID__c,
            Account_Legal_Name__c,
            Address1__c,
            Address2__c,
            Consolidated_DUNS_ID__c,
            City__c,
            Country__c,
            County__c,
            Duns_Number__c,
            Account_Level__c,
            Disposition__c,
            Industry_OD_SIC_DB__c,
            Industry_OD_SIC_Rep__c,
            Sector__c,
            Segment__c,
            Source_System__c,
            State__c,
            Status__c,
            Zip__c,
            DNB_Status__c,
            Account_Type__c,
            EIN__c,
            Duns_Enrichment__c,
            Lead_Source__c
            FROM Account WHERE Id IN :updatedAccountIds
        ];

        List<Lead> myUpdatedLeads = [
            SELECT
            Id,
            LastName,
            FirstName,
            Name,
            RecordType.DeveloperName,
            Email,
            Company,
            Street,
            City,
            State,
            PostalCode,
            Phone,
            Website,
            LeadSource,
            Status,
            ConvertedAccountId,
            ConvertedContactId,
            Cust_Account_Number__c,
            Cust_ID__c,
            Address1__c,
            City__c,
            State__c,
            Zip__c,
            OD_Customer_ID__c
            FROM Lead WHERE ConvertedAccountId IN :updatedAccountIds AND Zip__c != ''
        ];


        List<SObject> objectsToPost = new List<SObject>();
        objectsToPost.addAll(myUpdatedAccounts);
        objectsToPost.addAll(myUpdatedLeads);
        request.setBody(JSON.serialize(objectsToPost));
        System.debug(LoggingLevel.INFO, request);
        System.debug(LoggingLevel.INFO, request.getBody());
        if (Test.isRunningTest()) {
            System.debug(LoggingLevel.INFO, updatedAccountIds);
            System.debug(LoggingLevel.INFO, aggro_service_token.Aggro_Service_URL__c);
        }

        Http http = new Http();
        HTTPResponse res = http.send(request);
        System.debug(LoggingLevel.INFO, res.getBody());
        if (res.getStatusCode() != 201 && res.getStatusCode() != 200) {
        }
    }


    /*
     * *****************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com, 28 May 2019
     * @description
     * @param
     * @return
     */
    @future(callout = true)
    public static void postUpdatedLeads(Set<Id> updatedLeadIds) {

        Map<String, String> headers = new Map<String, String> {
            'accept' => 'application/json',
            'content-type' => 'application/json',
            'Authorization' => 'Bearer ' + aggro_service_token.Aggro_Access_Token__c
        };

        HttpRequest request = buildRequest(aggro_service_token.Aggro_Service_URL__c, headers, 'POST',
                                           '/ingest/salesforce/');

        List<Lead> myUpdatedLeads =
        [SELECT
         Id,
         LastName,
         FirstName,
         Name,
         RecordType.DeveloperName,
         Email,
         Company,
         Street,
         City,
         State,
         PostalCode,
         Phone,
         Website,
         LeadSource,
         Status,
         ConvertedAccountId,
         ConvertedContactId,
         Cust_Account_Number__c,
         Cust_ID__c,
         Address1__c,
         City__c,
         State__c,
         Zip__c,
         OD_Customer_ID__c
         FROM Lead WHERE Id IN :updatedLeadIds AND Zip__c != ''];

        request.setBody(JSON.serialize(myUpdatedLeads));
        System.debug(LoggingLevel.INFO, request);
        System.debug(LoggingLevel.INFO, request.getBody());
        if (Test.isRunningTest()) {
            System.debug(LoggingLevel.INFO, updatedLeadIds);
            System.debug(LoggingLevel.INFO, aggro_service_token.Aggro_Service_URL__c);
        }

        Http http = new Http();
        HTTPResponse res = http.send(request);
        System.debug(LoggingLevel.INFO, res.getBody());
        if (res.getStatusCode() != 201 && res.getStatusCode() != 200) {
        }
    }

    public static String aggroBulkFileSync(String base64EncodedString) {

        Map<String, String> headers = new Map<String, String> {
            'accept' => 'application/json',
            'content-type' => 'application/json',
            'Authorization' => 'Bearer ' + aggro_service_token.Aggro_Access_Token__c
        };

        HttpRequest request =
            buildRequest(aggro_service_token.Aggro_Service_URL__c, headers, 'POST', '/lookup/file/');

        Map<String, String> body =new Map<String, String>{'file'=> base64EncodedString};
        System.debug(LoggingLevel.INFO, 'Request Body:' + JSON.serialize(body));

        request.setBody(JSON.serialize(body));
        
        if (Test.isRunningTest()) {
            System.debug(LoggingLevel.INFO, base64EncodedString);
            System.debug(LoggingLevel.INFO, aggro_service_token.Aggro_Service_URL__c);
        }

        Http http = new Http();
        HTTPResponse res = http.send(request);
        System.debug(LoggingLevel.INFO, res.getBody());
        if (res.getStatusCode() != 201 && res.getStatusCode() != 200) {
            System.debug(LoggingLevel.ERROR,
                         'Callout to Aggro Service Failed with code ' + String.valueOf(
                             res.getStatusCode()) + ' ' +
                         res.getBody());
            throw new Aggro_Service_Exception(
                      'Callout to Aggro Service Failed with code ' + String.valueOf(
                          res.getStatusCode()) + ' ' +
                      res.getBody());
        } else {
            String responseBody = res.getBody();
            return responseBody;
        }
    }
    
}