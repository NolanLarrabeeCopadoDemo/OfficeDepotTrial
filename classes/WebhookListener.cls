@RestResource(urlMapping='/postdata/*')
global class WebhookListener {
    @HttpPost
    global static void handlePost() {
        try {
            String webhookBody = RestContext.request.requestBody.toString();
            String remoteAddress=RestContext.request.remoteAddress;
            system.debug('remoteAddress: '+RestContext.request.remoteAddress);
            system.debug('webhookBody: '+webhookBody);
            String jiraip ='18.246.31.227';
            
           // if(remoteAddress == jiraip)
          //  {
            
             process_jira_webhook.processData( webhookBody );
          //   }
        
        } catch (Exception e) {
             System.debug('An exception occurred: ' + e.getMessage());

        }
    }
}