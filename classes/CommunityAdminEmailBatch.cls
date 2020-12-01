/*
=====================================================================================================
///Updating the related contact emailid with the GPO Super user record emailids before sending the emails
=====================================================================================================
 -- CLASS CREATED/EDITED BY - MADHAVI SIRIGIRI 2/26/2018 - JIRA NAIT-11742
=====================================================================================================
 Communties v2.2 - "An email notification is sent twice daily, including weekends, at 12:00pm EST and 
 4:00pm EST, to all Community Administrators (Super Users) 
 when one or more user registrations are submitted on a Private Community" - JIRA NAIT-11742
=====================================================================================================

*/

global class CommunityAdminEmailBatch implements Database.Batchable<sObject>, Schedulable
{
    Public String GPOQUERY ;
    
    //To collect accounts for each GPO Lead 
    Map<GPO_Lead__c, Id> GPOLeadAcc_map = New Map<GPO_Lead__c, Id>();
    
    //To collect all super users with GPO Admin profile Id linked
    List<User> GPOAdminUsers;
    Map<Id, User> GPOAdminUsers_map = New Map<Id, User>();
    
    //To collect contacts for each GPO Lead associated account
    Map<GPO_Lead__c, List<contact>> Acccontacts_map = New Map<GPO_Lead__c, List<contact>>();
    
    ////To collect group for each GPO Lead
    Map<GPO_Lead__c, GPO_Group__c> ldgrp_map = New Map<GPO_Lead__c, GPO_Group__c>();
   
    
    List<User> GPO_SendEmailAdmins_lst = New List<User>();
    
    global CommunityAdminEmailBatch(){
        
        this.GPOQUERY = 'SELECT id, first_name__c, last_name__c, Login_Name__c, GPO_Group__c, GPO_Group__r.Community_Name__c, ' + 
        'Account__c FROM GPO_Lead__c WHERE Status__c = \'Pending\' AND Private__c = true';
        
        system.debug('Started Constructor........');
        
    }
     
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(GPOQUERY);
    }
    
    global void execute(Database.BatchableContext bc, SObject[] scope) 
    {
        
        system.debug('Started Execute........');
        
        List<contact> Acccontacts = new List<Contact>();
        GPO_Group__c gpogrp;
        
        
        List <GPO_Lead__c> lead_recs = scope;
        for (GPO_Lead__c ld : lead_recs) {
            
            system.debug('GPO Lead:' + ld);
            GPOLeadAcc_map.put(ld, ld.Account__c);
            
            Acccontacts = [select id,FirstName,LastName,Email from contact where accountid =:ld.Account__c];
            Acccontacts_map.put(ld, Acccontacts);
            
            system.debug('Login_Name__c:' + ld + '--' + ld.Login_Name__c + '  ld.Account__c:' + ld.Account__c);
            
            gpogrp = [select id, name,Public_Page_View__c,account__c from GPO_Group__c where account__c =:ld.Account__c limit 1];
            ldgrp_map.put(ld, gpogrp);
            system.debug('GPO Lead:' + ld + '--' + ld.Login_Name__c + ' gpogrp:' + gpogrp.id );
            
            
        }
        system.debug('Collecting contacts for each GPO Lead/Acc: Acccontacts_map.size:' + Acccontacts_map.size());
        system.debug('Collecting GPO groups for each GPO Lead:  ldgrp_map.size:' + ldgrp_map.size());
        
        
        //Get the GPO Admin profileId
        GPO_Community_Setup__c commSetup = GPO_Community_Setup__c.getValues('com2Settings');
        GPOAdminUsers = [select id, ContactId, FirstName, LastName, Name, Email, MobilePhone, Phone FROM User WHERE ProfileId = :commSetup.Admin_ProfileId__c];
        //system.debug('GPOAdminUsers.size:' + GPOAdminUsers.size());
        
        for(User Usrrec: GPOAdminUsers){
            GPOAdminUsers_map.put(Usrrec.ContactId, Usrrec);
        }
        system.debug('Collecting all Community SUs: GPOAdminUsers_map.size:' + GPOAdminUsers_map.size());
        
        decimal i = 1;
        for (GPO_Lead__c ld : lead_recs) {
            
            if(Acccontacts_map.containskey(ld))//Check if the map has GPO Lead rec
            {
                
                system.debug('Loop counter: ' + i++);
                system.debug('Looking for the lead rec:' + ld.Login_Name__c + ' Lead Id:' + Ld.id);
                
                for(contact ct:Acccontacts_map.get(ld))//List of contact for each Lead related Acc
                {
                    if(GPOAdminUsers_map.containskey(ct.id))//Finding the Super user for each contact
                    {
                        system.debug('SuperUser Id:' + GPOAdminUsers_map.get(ct.id).id + ' SU FirstName:' + GPOAdminUsers_map.get(ct.id).FirstName +
                        ' SU LastName:' + GPOAdminUsers_map.get(ct.id).LastName);
                        system.debug('SU Contactid:' + ct.id + 'SU Contact Name:' + ct.FirstName + ' ' + ct.LastName + 'SU Contact Email:' + ct.Email);
                        
                        ///Updating the related contact emailid with the GPO Super user record emailids before sending the emails
                        contact cont = ct;
                        user usr = GPOAdminUsers_map.get(ct.id);
                        if(ct.email != usr.email)
                            ct.email = usr.email;
                        //update ct;
                        //================
                        
                        if(ldgrp_map.containskey(ld))
                        {
                            system.debug('Related GPO group:' + ldgrp_map.get(ld).name);
                            //Sending Email for each GPO lead
                            //GPO_SendEmailAdmins_lst.add(GPOAdminUsers_map.get(ct.id));
                            sendEmail(GPOAdminUsers_map.get(ct.id), ldgrp_map.get(ld) );
                        }
                        else{
                            //system.debug('Couldn\'t find GPO Group for GPO Lead:' + ld.Login_Name__c );
                            //continue;
                        }
                            
                    }
                    else{
                        //system.debug('Couldn\'t find SUser for GPO Lead:' + ld.Login_Name__c );
                        //continue;
                    }
                }//End of For
            }
            else{
                system.debug('Couldn\'t find Contacts for GPO Lead:' + ld.Login_Name__c );
                //continue;
            }
               
        }//End of for
        
        //Send Emails---For Testing EMAIL for single account
       /* user mr = [select id, ContactId, FirstName, LastName, Name, Email, MobilePhone, Phone from user where id = '00544000008LZWM'];
        account acc1= [select id,name, Account_Owner__c from account where id = '0011k000002HwQl' limit 1 ];
        GPO_Group__c grp = [select id, name,Public_Page_View__c from GPO_Group__c where account__c = '0011k000002HwQl' limit 1];
        GPO_SendEmailAdmins_lst.add(mr);
        for(user ur: GPO_SendEmailAdmins_lst){
            sendEmail(ur, grp );
        } */
        
    }
    
    global void execute(SchedulableContext sc) 
    {
        CommunityAdminEmailBatch thisjob = new CommunityAdminEmailBatch();
        Database.executeBatch(thisjob, 10);
    }
    
    Public static void sendEmail(user ur, GPO_Group__c gpogrp) {
   
        try{

            System.debug('&&&&&&&&&&Inside Send Email Method');
            
            EmailTemplate templateId = [Select id,body from EmailTemplate where name = 'GPO Admin Notification'];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            // Set the orgwide email - 
            OrgWideEmailAddress orgwideemail = [select Id from OrgWideEmailAddress where Address = 'community.request@officedepot.com'];
            mail.setOrgWideEmailAddressId(orgwideemail.id);
            
           // mail.setSubject('GPO Leads Waiting for your Approval');
            mail.setTemplateID(templateId.Id);
            mail.setTargetObjectId(ur.contactId);//this is required to use emailtemplate
            mail.setwhatId(gpogrp.id);
            
            mail.setSaveAsActivity(false);
            //mail.setToAddresses(new String[] {ur.email}); //add other emails here.
            //mail.setToAddresses(new String[] {}); //add other emails here.
            //mail.setCcAddresses(new String[] {});
            
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            //List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            //emails.add(mail);
            //Messaging.sendEmail(emails); 
            
            System.debug('&&&&&&&&&&End of Inside send email method');
            
            // we can then check for success
            /*if (results[0].success) {
                system.debug('Email sent successfully');
            } else {
                system.debug('Email failure');
            }*/
        }//end of try
        catch(System.EmailException ex){
            // Exceptions are passed to here.
            system.debug('Email failure is catched');
        }
            
        

    }
    
    global void finish(Database.BatchableContext bc) 
    {
        system.debug('Finishing the batch....');
    }
}

//