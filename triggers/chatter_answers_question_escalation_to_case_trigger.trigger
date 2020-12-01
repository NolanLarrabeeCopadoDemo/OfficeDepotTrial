trigger chatter_answers_question_escalation_to_case_trigger on Question (after update) {
/*
final String template = 't1';
Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
      message.setTemplateId([select id from EmailTemplate where Name =:template limit 1].id);
      for (Question q: Trigger.new) {
         String subjectText =  q.Title ;

             String rep= q.LastReplyid;
             Reply rp= [select body from reply where id=:rep];
             
            String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + rep;
             
             String bodyText =  '<html><body><b>Question: </b><i>' +q.title+ '-- </i>' + q.body +'<br><br><b>Most Recent Response: </b>"' 
             +  rp.body + '"<br><br><b>Find more details and select the Best Answer at: </b><a href=' + fullRecordURL + 
             '>Salesforce.com Answers</a></body></html>';
              
              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
              
              String crtid =q.createdByid;
              User u1= [select email from user where id=:crtid ];
              
              
              system.debug(u1.email);
            String[] toAddresses = new String[] {u1.email};

            mail.setReplyTo('no-reply@salesforce.com');
            mail.setSenderDisplayName('Salesforce Chatter Answers');

            // The default sender is the portal user causing this trigger to run, to change this, set an organization-wide address for
            // the portal user profile, and set the ID in the following line.
            // mail.setOrgWideEmailAddressId(orgWideEmailAddressId);
            mail.setToAddresses(toAddresses);
            mail.setSubject(subjectText);
            mail.setHTMLBody(bodyText);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
*/
}