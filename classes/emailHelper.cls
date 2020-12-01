Global class emailHelper {

public static void sendEmail(ID recipient, ID sender , String senderName, ID template , String replyto) {

  //New instance of a single email message
 Messaging.SingleEmailMessage mail = 
            new Messaging.SingleEmailMessage();
 
// Who you are sending the email to
   mail.setTargetObjectId(recipient);

   // The email template ID used for the email
   mail.setTemplateId(template);
          
   mail.setWhatId(sender );    
   mail.setBccSender(false);
   mail.setUseSignature(false);
   mail.setReplyTo(replyto);
   mail.setSenderDisplayName(senderName);
   mail.setSaveAsActivity(true);  
 
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }  
}