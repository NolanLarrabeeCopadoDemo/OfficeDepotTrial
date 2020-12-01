public with sharing class ExternalServices implements Schedulable {
    public static String channel = 'rms';
    public static String job_name = 'rms_loader';
    public static String CRON_EXP = '0 0 1 * * ?'; 

    public static String GetAuthorizationToken() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SFDC_PRODUCT_SEARCH/api/v1/login/access-token');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setBody('username={!$Credential.Username}&password={!$Credential.Password}');
        HTTPResponse response = http.send(request);
        if (response.getStatusCode() > 204){
            System.debug(LoggingLevel.ERROR, response.getStatusCode() + ' ' + response.getBody());
			throw new AuraHandledException('Could not authenticate against product search service! Please create a case with subject Porduct Search is not available.');
        } else {
			System.debug(LoggingLevel.INFO, response.getStatusCode());
		}
        Map<String, String> token = (Map<String, String>)JSON.deserialize(response.getBody(), Map<String, String>.class);
        return token.get('access_token');
    }
    public static Map<String, String> startJob(String token, String channel, String job_name){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:SFDC_PRODUCT_SEARCH/api/jobs/' + channel + '/' + job_name);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        HTTPResponse response = http.send(request);
        if (response.getStatusCode() > 204){
            System.debug(LoggingLevel.ERROR, response.getStatusCode() + ' ' + response.getBody());
			throw new AuraHandledException('Could not authenticate against product search service! Please create a case with subject Porduct Search is not available.');
        } else {
			System.debug(LoggingLevel.INFO, response.getStatusCode());
		}
        return (Map<String, String>)JSON.deserialize(response.getBody(), Map<String, String>.class);
    }

    @future(callout=true)
    public static void startExternalJob(String channel, String job_name){
        String token = GetAuthorizationToken();
        Map<String, String> result = startJob(token, channel, job_name);
        System.debug(LoggingLevel.INFO, result);
        
    }

    public static void execute(SchedulableContext context){
        startExternalJob(channel, job_name);
    }

}