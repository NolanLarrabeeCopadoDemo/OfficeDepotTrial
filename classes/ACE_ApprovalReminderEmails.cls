global class ACE_ApprovalReminderEmails implements Database.Batchable<sObject>,Database.Stateful,Schedulable
{
     
     // this method is used to get all reocrds that will be processed by execute method
     global Database.QueryLocator start(Database.BatchableContext bc)
     {
          //String query = 'SELECT Id, TargetObject.Name, TargetObjectID, TargetObject.Type, (SELECT Id, ActorID,Actor.email, Actor.Name FROM WorkItems) FROM ProcessInstance WHERE Status = \'Pending\' AND IsDeleted = False '; // AND SystemModStamp < Today';  //targetObjectID= \'a1xM00000026lPR\' and
          String query = 'SELECT Id, TargetObject.Name, TargetObjectID, TargetObject.Type, (SELECT Id, ActorID,Actor.email, Actor.Name FROM WorkItems) FROM ProcessInstance WHERE Status = \'Pending\' AND IsDeleted = False and id=\'04gE0000004snQtIAI\''; 
          
          if (test.IsRunningTest() == true) 
          {
              query = 'SELECT Id, TargetObject.Name, TargetObjectID, TargetObject.Type, (SELECT Id, Actor.email, Actor.Name FROM WorkItems) FROM ProcessInstance WHERE Status = \'Pending\' AND IsDeleted = False';   
          } 
          return  Database.getQueryLocator(query);
     } // querylocator start
    
     global Map<ID,User> map_ID_User {get;set;}
     global Map<ID,String> map_Reminder {get;set;}
     global Map<ID,Boolean> map_mgrEscalation {get;set;} 
     global ACE_Settings__c accSett;
     
     global ACE_ApprovalReminderEmails ()
     {
         map_Reminder = new Map<ID,String>();
         map_mgrEscalation = new Map<ID,Boolean> ();
     }
     
     global void execute(Database.BatchableContext BC, List<sObject> scope) 
     {
          // loop thru results  
          Set<ID> sIDs = new Set<ID>();
          Set<ID> sUserID = new Set<ID>();
          Map<ID,String> map_Reminder_l = new Map<ID,String> ();
          
          Map<String,String> emailOverrideMap = new Map<String,String>();
          
          for (ACE_Email_Exception__mdt e:[SELECT Original_Email__c, Replacement_Email__c from ACE_Email_Exception__mdt])
            emailOverrideMap.put(e.Original_Email__c,e.Replacement_Email__c);
          
          for (SObject s : scope) 
          {
              ProcessInstance PI = (ProcessInstance)s;
              sIDs.add(PI.TargetObjectID);
              for(ProcessInstanceWorkitem WI : PI.WorkItems) 
              {
                sUserID.add(WI.ActorID);
              }
          }  
          
          System.debug('>>>>>>>>>>>>>>>>> Step 1' + sIDs);
          system.debug('Reminder Check:' + map_Reminder);
          map_ID_User = new Map<ID,User>([Select id, name,email, manager.Name,managerID,manager.email from User where id in: sUserID]);
          accSett = [Select id,PendingApprovalDays__c,Tab_Url__c,Escalation_time_frame__c, ApprovalDays__c,EsclationDays__c from ACE_Settings__c];
          
          Map<ID,Ace_Customer_SKU_Changes__c> map_ID_SKU = new Map<ID,Ace_Customer_SKU_Changes__c>([Select id,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Reschduled_For_Reminder__c,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.SFDC_Notification_Flag__c,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Sales_Price_Change_Effective_Date__c,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Customer_Notification_Date_Approved__c,L3_Mgr_AppReject_Time_c__c,L2_Mgr_AppReject_Time_c__c,L1_Mgr_AppReject_Time_c__c,name,Approval_Type__c from Ace_Customer_SKU_Changes__c where iD in:sIDs]);
          
          Map<ID,Ace_Customer_Price_Changes__c> map_ID_Cust = new Map<ID,Ace_Customer_Price_Changes__c>([Select id,Reschduled_For_Reminder__c,SFDC_Notification_Flag__c,Sales_Price_Change_Effective_Date__c,Customer_Notification_Date_Approved__c,name from Ace_Customer_Price_Changes__c where iD in:sIDs]);
          //Map<ID,String> map_Reminder = new Map<ID,String>();
          
          Map<ID,Set<ID>> map_MngrID_UserID_Stat = new Map<ID,Set<ID>>();
          
          // Map of Manager ID and list of subordinates under him
          Map<ID,List<User>> map_escalate = new Map<ID,List<User>>();
          
          // Map of User ID and Release coming soon
          Map<ID,Boolean> map_UsrID_CSStat = new Map<ID,Boolean>();
          
          // Map of User ID and Overdue
          Map<ID,Boolean> map_UsrID_OVStat = new Map<ID,Boolean>();
          
          for (SObject s : scope) 
          { 
                   ProcessInstance PI = (ProcessInstance)s;
                   Ace_Customer_SKU_Changes__c ace = map_ID_SKU.get(PI.TargetObjectID);
                   Ace_Customer_Price_Changes__c acePrice = map_ID_Cust.get(PI.TargetObjectID);
                   
                   if(ace != null || acePrice != null)
                   {
                       
                       for(ProcessInstanceWorkitem WI : PI.WorkItems) 
                       {
                           // Reminder code
                           
                           if(!map_Reminder.containsKey(WI.ActorID))
                           {
                               map_Reminder.put(WI.ActorID,'Reminder');
                               map_Reminder_l.put(WI.ActorID,'Reminder');
                           }
                           // Reminder code ends here

                           // Escalation Logic
                           
                           // Map of Manager ID and its subordinates
                           User userrec = map_ID_User.get(WI.ActorID);  
                           if(userrec.managerID != null && !map_mgrEscalation.containskey(userrec.managerID)) 
                           {
                               sendMgrMail(userrec.managerID,emailOverrideMap);
                               
                           }  // Check Manager ID 

                           // Map of Approver ID and release coming soon or overdue
                           
                      }  // loop thru WorkItems
                   
                  }    
 
          } // scope loop
          
          
          sUserID.addALL(map_Reminder.keySet());
          sUserID.addALL(map_MngrID_UserID_Stat.keySet());
          map_ID_User = new Map<ID,User>([Select id, name,email, manager.Name,managerID,manager.email from User where id in: sUserID]);
           
          if(map_reminder_l.size() > 0)
          {
              for(ID userid: map_Reminder_l.keySet())
              {
                  Set<ID> sUsr = new Set<ID>();
                  User userrec = map_ID_User.get(userid);  
                  SendEmail('Reminder',userRec.ID, userRec.Email, userrec.Name,sUsr,map_UsrID_CSStat,map_UsrID_OVStat,emailOverrideMap);
              }
          }
          
        
     /*     if(map_MngrID_UserID_Stat.size() > 0)
          {
              for(ID userid: map_MngrID_UserID_Stat.keySet())
              {
                  Set<ID> sUsr = new Set<ID>();
                  sUsr = map_MngrID_UserID_Stat.get(userid);
                  System.debug('>>>>>>>>>>>>>value of map' + sUsr);  
                                  
                  User userrec = map_ID_User.get(userid);  
                  System.debug('>>>>>>>>>>>>>value of user' + userrec + 'test' + userid);
                  SendEmail('Escalation',userRec.ID, userRec.Email, userrec.Name,sUsr,map_UsrID_CSStat,map_UsrID_OVStat,emailOverrideMap);
              }
          }*/
          
     } 
 
     global void finish(Database.BatchableContext info) { 
     } // finish
     
    private void sendMgrMail (ID mgrid,Map<String,String> emailOverrideMap) {
        
        set<id> userid = new Set<id>();
        Set<ID> sIDs = new Set<ID>();
        Set<ID> sUserID = new Set<ID>();
        String mgrName = null,mgrEmail = null;
        Set<ID> sUsr = new Set<ID>();
        
        // Map of User ID and Release coming soon
          Map<ID,Boolean> map_UsrID_CSStat = new Map<ID,Boolean>();
        // Map of User ID and Overdue
          Map<ID,Boolean> map_UsrID_OVStat = new Map<ID,Boolean>();
        
        for (user u : [select id,name,email,managerid,manager.email,manager.name from user where managerid = :mgrid])  {
            userid.add(u.id);
            map_ID_User.put(u.id,u);
            if (mgrEmail == null) { mgrEmail = u.manager.email;mgrName = u.manager.name;}
              
        }
          
        list<ProcessInstance> ProcessList = [SELECT Id, TargetObject.Name, TargetObjectID, TargetObject.Type, (SELECT Id, ActorID,Actor.email, Actor.Name FROM WorkItems where actorID = :userId) FROM ProcessInstance WHERE Status = 'Pending' AND IsDeleted = False and TargetObject.Type in ('ACE_Customer_Price_Changes__c','ACE_Customer_SKU_Changes__c')];
        
        for (ProcessInstance P : ProcessList) {
          for(ProcessInstanceWorkitem WI : P.WorkItems) 
            {
             if (WI.ActorId != null) {
                 sUserID.add(WI.ActorID);
                 sIDs.add(P.TargetObjectID);
              }
            }
        }
        

        Map<ID,Ace_Customer_SKU_Changes__c> map_ID_SKU = new Map<ID,Ace_Customer_SKU_Changes__c>([Select id,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Reschduled_For_Reminder__c,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.SFDC_Notification_Flag__c,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Sales_Price_Change_Effective_Date__c,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Customer_Notification_Date_Approved__c,L3_Mgr_AppReject_Time_c__c,L2_Mgr_AppReject_Time_c__c,L1_Mgr_AppReject_Time_c__c,name,Approval_Type__c from Ace_Customer_SKU_Changes__c where iD in:sIDs]);
        Map<ID,Ace_Customer_Price_Changes__c> map_ID_Cust = new Map<ID,Ace_Customer_Price_Changes__c>([Select id,Reschduled_For_Reminder__c,SFDC_Notification_Flag__c,Sales_Price_Change_Effective_Date__c,Customer_Notification_Date_Approved__c,name from Ace_Customer_Price_Changes__c where iD in:sIDs]);
          
        for (ProcessInstance PI : ProcessList) {
          for(ProcessInstanceWorkitem WI : PI.WorkItems) 
            {
             if (WI.ActorId != null) {
                
                Ace_Customer_SKU_Changes__c ace = map_ID_SKU.get(PI.TargetObjectID);
                Ace_Customer_Price_Changes__c acePrice = map_ID_Cust.get(PI.TargetObjectID);
                
                integer numberDaysDue = 0;
                integer numberDaysDueEFF = 0;
                String notificationflag = '1';
                Boolean reminderflag = false;
                Boolean escalationRequired = false;

                   if (ace != null)
                       {
                        if(ace.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Customer_Notification_Date_Approved__c != null)
                             numberDaysDue = System.now().date().daysBetween(ace.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Customer_Notification_Date_Approved__c);
                        if(ace.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Sales_Price_Change_Effective_Date__c != null)
                           numberDaysDueEFF = System.now().date().daysBetween(ace.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Sales_Price_Change_Effective_Date__c);
                        
                        notificationFlag = ace.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.SFDC_Notification_Flag__c;
                        reminderflag = ace.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Reschduled_For_Reminder__c;
                        
                       }
                       else {
                         if(acePrice.Customer_Notification_Date_Approved__c != null)
                             numberDaysDue = System.now().date().daysBetween(acePrice.Customer_Notification_Date_Approved__c);
                         if(acePrice.Sales_Price_Change_Effective_Date__c != null)
                           numberDaysDueEFF = System.now().date().daysBetween(acePrice.Sales_Price_Change_Effective_Date__c);
                         
                         notificationflag = acePrice.sfdc_notification_flag__c;
                         reminderflag = acePrice.Reschduled_For_Reminder__c;
                       }            
                   
                   Integer daysdiff = 0;
                   
                   if((notificationFlag == '2' || notificationFlag == '3')) 
                      daysdiff = numberDaysDue;
                   else
                      daysdiff = numberDaysDueEFF; 
  
                   if(!map_UsrID_CSStat.containsKey(WI.ActorID))
                   {
                       if((reminderFlag == false) && (daysdiff <= 2 && daysdiff > 0)) {
                          map_UsrID_CSStat.put(WI.ActorID,true);
                          escalationRequired = true; 
                       } 
                        else
                          map_UsrID_CSStat.put(WI.ActorID,false); 
                    }
                    else {
                       if (!map_UsrID_CSStat.get(WI.ActorID) && (reminderFlag == false) && (daysdiff <= 2 && daysdiff > 0)) {                    
                          map_UsrID_CSStat.put(WI.ActorID,true);
                          escalationRequired = true;     
                       }
                    } 
                    
                    if (!map_UsrID_OVStat.containskey(WI.ActorID))  {
                       if(reminderFlag == true || daysdiff <= 0) {
                            map_UsrID_OVStat.put(WI.ActorID,true);
                            escalationRequired = true;
                       }
                       else
                           map_UsrID_OVStat.put(WI.ActorID,false);  
                    }
                    else {
                      if (!map_UsrID_OVStat.get(WI.ActorID) && (reminderFlag == true || daysdiff <= 0)) {
                          map_UsrID_OVStat.put(WI.ActorID,true);
                          escalationRequired = true; 
                      }
                    } 
                   
                   if (escalationRequired)
                     sUsr.add(WI.ActorId);
             }
            }
        }
         map_mgrEscalation.put(mgrID,true);
         
         if (sUsr.size() > 0)
           SendEmail('Escalation',mgrID, mgrEmail, mgrName,sUsr,map_UsrID_CSStat,map_UsrID_OVStat,emailOverrideMap);
     
     }
     
     private void SendEmail(String Type,Id ActorID, string ActorEmailAddress, string ActorName, Set<ID> sUsr,Map<ID,Boolean> map_UsrID_CSStat,Map<ID,Boolean> map_UsrID_OVStat,Map<String,String> emailOverrideMap) 
     {    
            System.debug('>>>>>>>>' + type + ' ' + actorID + ' ' +  ActorEmailAddress + ' ' + ActorName);
            id EmailTemplateID;
                if((Type == 'Reminder') || (Type == 'Escalation'))
                {
                    EmailTemplateID = null ; // FindEmailTemplateIDByDeveloperName('testname Reminder');
                }
                
            // Make sure this transaction won't fail due to lack of daily capacity
            Messaging.reserveSingleEmailCapacity(1);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();     
         
            String[] toAddresses;
            String toEmail;
            
            if (emailOverrideMap.containskey(ActorEmailAddress)) {
               toEmail = emailOverrideMap.get(ActorEmailAddress);
            }
            else
               toEmail = ActorEmailAddress;
         
            // email will be null during testing ...
            if (test.IsRunningTest() == true) 
            {
                toAddresses = new String[] {'no-reply@salesforce.com'};
            } 
            else
            {            
                  toAddresses = new String[] {toEmail}; 
            } 
         
            if (EmailTemplateID != null) 
            {
             // use our template
             email.setTemplateId(EmailTemplateID);
             email.saveAsActivity = false;
               
             // populate the template w/ object data
             email.setTargetObjectId(ActorID);
             // email.setWhatId(TargetID);
            } 
            else 
            {
             // use a generic HTML email when no template is setup / found
             // get the current salesforce instance to build the link with
             
              string domain = URL.getSalesforceBaseUrl().toExternalForm();
              string TargetLink = accSett.tab_url__c;
                   
             email.setToAddresses(toAddresses);
             
             if(Type == 'Reminder')
             {  
                 // set the subject on the email
                 email.setSubject('Price Changes – Action Needed: Review Requests');
                  
                 // set the body of the email
                 email.setHTMLBody('Dear ' + ActorName + ',<br/><br/>' +
                                   'You have price change process exception requests pending your review. Please ' + 
                                   '<a href=\'' + TargetLink + '\'>click here</a> to review and disposition these requests. Your timely response reduces Office Depot’s margin erosion, so please review your team’s requests ASAP.<br/><br/>Thank you!<br/>Office Depot Contract Division<br/></br><br/></br>' +
                                   '<i>Note: This is a system generated Email. Please DO NOT reply to this email.</i>'                     
                 );
             }
             else if(Type == 'Escalation')
             {  
                 // set the subject on the email
                 email.setSubject('Escalation: Item pending approval');
                  
                 // set the body of the email
                 
                 String EmailBody = '' + 'Dear ' + ActorName + ',<br/><br/> ' +
                                   'You currently have price change exception requests pending your review and disposition in SFDC.'
+' Please log in to SFDC, click on the Customer Price Changes tab, and click on the Pending Approvals subtab to review the pending requests.'
+' For additional resources, please view the "Approver\'s Guide" and/or the "Approver Video Demos" posted on the Customer Price Changes (ACE)'
+' Resources page in SAVO.'
                                  + ' <br/><br/> Below is the list of users whose requests are pending with you:  <br/>' +
                                  // '<br/> <table style="border:1px solid black;border-collapse:collapse"> <tr> <th style="border:1px solid black;border-collapse:collapse" bgcolor="#D8D8D8" > User Name </th> <th style="border:1px solid black;border-collapse:collapse" bgcolor="#D8D8D8" > User Email </th> <th style="border:1px solid black;border-collapse:collapse" bgcolor="#D8D8D8"> Release Coming Soon </th> <th style="border:1px solid black;border-collapse:collapse" bgcolor="#D8D8D8"> Release Overdue </th> </tr/>';
                                  +   '<br/> <table style="border:1px solid black;border-collapse:collapse"> <tr> <th style="border:1px solid black;border-collapse:collapse" bgcolor="#D8D8D8" > User Name </th> <th style="border:1px solid black;border-collapse:collapse" bgcolor="#D8D8D8"> Overdue </th> </tr/>';
                                    for(ID  userid : sUsr)
                                    {
                                        User usr = map_ID_User.get(userid);
                                        Boolean cs = map_UsrID_CSStat.get(userID);
                                        Boolean ov = map_UsrID_OVStat.get(userID);
                                        String cs_s,ov_s;
                                        if (cs)
                                          cs_s = 'Yes';
                                        else
                                          cs_s = 'No';
                                        if (ov)
                                          ov_s = 'Yes';
                                        else
                                          ov_s = 'No';
                                        //EmailBody = EmailBody + '<tr> <td><a href=\'' + usr.id + '\'>' + usr.name + '</a> </td> <td> ' + cs + ' </td> <td> ' + ov + ' </td> </tr>' ;
                                        //EmailBody = EmailBody + '<tr> <td style="border:1px solid black;border-collapse:collapse">'+usr.name + '</td> <td style="border:1px solid black;border-collapse:collapse"><a href="mailto:'+usr.Email + '">'+usr.Email+'</a></td><td style="border:1px solid black;border-collapse:collapse"> ' + cs_s + ' </td> <td style="border:1px solid black;border-collapse:collapse"> ' + ov_s + ' </td> </tr>' ;
                                        EmailBody = EmailBody + '<tr> <td style="border:1px solid black;border-collapse:collapse">'+usr.name + '</td> <td style="border:1px solid black;border-collapse:collapse"> ' + ov_s + ' </td> </tr>' ;
                                    } 
                                    
                                    
                                    
                                  // for(User l :lUser)
                                  // {
                                  //     EmailBody = EmailBody + '<tr> <td><a href=\'' + l.id + '\'>' + l.name + '</a> </td></tr>' ;
                                  // }
                                   EmailBody = EmailBody +  ' </table> <br/> <i>Note: This is a system generated Email. Please DO NOT reply to this email.</i>' ;
                 
                email.setHTMLBody(EmailBody);
             }
             
             
            } // check for template id
          
         
             
            // send our email by creating an array of emails and calling the send email method.
            try
            {
            Messaging.SingleEmailMessage[] EmailsToSend = new Messaging.SingleEmailMessage[] { email };
            Messaging.sendEmail(EmailsToSend);
            }
            catch(Exception e)
            {
                SYstem.debug('>>>>>>>> Value of exception' + e);
            }
     } // end send reminder email
  
     
    
     // this method could be moved to a utility class and made public . . . . 
     public static ID FindEmailTemplateIDByDeveloperName(string DeveloperName) 
     {
      id EmailTemplateID;
      List<EmailTemplate> EmailTemplateResults = new List<EmailTemplate>(); 
      if (DeveloperName != null) {
       EmailTemplateResults = [SELECT Id, Name, DeveloperName, IsActive FROM EmailTemplate WHERE DeveloperName = :DeveloperName];
       if (EmailTemplateResults.size() > 0) {
        if (EmailTemplateResults[0].IsActive == true) {
         EmailTemplateID = EmailTemplateResults[0].id;
        } // check for active email template
       } // check for null search results  
      } // check for blank name
     
      return EmailTemplateID;
     } 
  
    global void execute(SchedulableContext sc)
    {
     //Batch size set for each iteration
     integer batch_size = 5;
     ACE_ApprovalReminderEmails aceBatch = new ACE_ApprovalReminderEmails();
     database.executebatch(aceBatch,batch_size);
    }

 
} // end class