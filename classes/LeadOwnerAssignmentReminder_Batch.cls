/*
* @description Intended to run daily. Sends out reminder emails for Leads. After 3 business days of inactivity
* for a Lead, reassigns them to the Lead Triage Queue and sends a notification email to the Lead owner.
* 
* @author Ryan Tocco
* @datecreated 2019-05-22
*
* @changes Log any modifications here...
* Support Number: 02629992 => Leads are being reassigned to the Lead Triage queue after 72 hours instead of the ‘Leads Reassigned after 72 Hours’ queue. //Sandesh Ganjare //2019-11-18
*/
global class LeadOwnerAssignmentReminder_Batch implements Database.Batchable<Sobject>, Database.Stateful, Schedulable {
    
    //private QueueSobject leadTriageQueue;
    private QueueSobject lead72HoursQueue;
    private Reminder_Settings__mdt reminderSettings;
    private EmailTemplate et3;
    private EmailTemplate et4;
    private EmailTemplate aet3;
    private EmailTemplate aet4;
    private Utils_Time.TimeUnit unit;
    private Set<String> vpAndAboveJobCodes;
    private String query;
    
    global Set<Id> reminderUserIds;
    global Set<Id> leadReassignedUserIds;
    global Set<Id> altReminderUserIds;
    global Set<Id> altReassignedUserIds;
    
    // Used for testing.
    @TestVisible static Integer emailsSent = 0;

    global LeadOwnerAssignmentReminder_Batch() {
        // Set the instance variables.
        loadData();
        // Create the query.
        query = createQuery(reminderSettings.Record_Types__c);
    }
    
    global LeadOwnerAssignmentReminder_Batch(String query) {
        // Set the instance variables.
        loadData();
        this.query = query;
    }
    
    /*
     * @description Helper method for the constructors. Loads in necessary peripheral data.
     * @author Ryan Tocco
     * @datecreated 2019-05-22
     */
    private void loadData() {
        // Some leads may need to be assigned to the Leads Reassigned After 72 Hours Queue, so we need to get its Id
        //leadTriageQueue = [SELECT Id, QueueId FROM QueueSobject WHERE SObjectType = 'Lead' AND Queue.Name = 'Lead Triage' LIMIT 1];
        lead72HoursQueue = [SELECT Id, QueueId FROM QueueSobject WHERE SObjectType = 'Lead' AND Queue.Name = 'Leads Reassigned After 72 Hours' LIMIT 1];
        
        // Retrieve the Reminder Settings metadata object.
        reminderSettings = [SELECT Id, Email_Template_Name_3__c, Email_Template_Name_4__c, Alternate_Email_Template_Name_3__c,
                                        Alternate_Email_Template_Name_4__c, Interval_Length_1__c, Interval_Length_2__c,
                                        Interval_Unit__c, Record_Types__c, Alternate_Record_Types__c, Lead_Sources__c,
                                        Should_Reassign__c, Alternate_RT_Should_Reassign__c
                                        FROM Reminder_Settings__mdt WHERE Label = 'Lead Reminders'];
        
        // Use the Reminder Settings object to set the correct email templates.
        et3 = [SELECT Id FROM EmailTemplate WHERE Name =: reminderSettings.Email_Template_Name_3__c];
        et4 = [SELECT Id FROM EmailTemplate WHERE Name =: reminderSettings.Email_Template_Name_4__c];
        aet3 = [SELECT Id FROM EmailTemplate WHERE Name =: reminderSettings.Alternate_Email_Template_Name_3__c];
        aet4 = [SELECT Id FROM EmailTemplate WHERE Name =: reminderSettings.Alternate_Email_Template_Name_4__c];
        // Use the Reminder Settings object to set the correct time interval units.
        switch on reminderSettings.Interval_Unit__c {
            when 'Business Days' {
                unit = Utils_Time.TimeUnit.BUSINESS_DAYS;
            } when 'Days' {
                unit = Utils_Time.TimeUnit.DAYS;
            } when 'Hours' {
                unit = Utils_Time.TimeUnit.HOURS;
            } when 'Minutes' {
                unit = Utils_Time.TimeUnit.MINUTES;
            }
        }
        
        // Create a set (vpAndAboveJobCodes) of job codes that are VP and above.
        vpAndAboveJobCodes = new Set<String>();
        List<User_Setting__c> userSettings = [SELECT Id, Name FROM User_Setting__c WHERE Job_Code_Level__c IN ('VP', 'SVP', 'President', 'CEO')];
        for(User_Setting__c userSetting : userSettings) {
            vpAndAboveJobCodes.add(userSetting.Name);
        }
    }
    
    /*
     * @description Query the leads so that they can be sent to the execute method. This runs first.
     * @author Ryan Tocco
     * @datecreated 2019-05-22
     */
    global Database.QueryLocator start(Database.BatchableContext BC) {
        reminderUserIds = new Set<Id>();
        leadReassignedUserIds = new Set<Id>();
        altReminderUserIds = new Set<Id>();
        altReassignedUserIds = new Set<Id>();
        return Database.getQueryLocator(query);
    }
    
    /*
     * @description Goes through the leads that were queried and, based on the Reminder Settings
     * metadata object and the last time the leads' owner was changed, either places the owner
     * in one of the userId sets, places the lead into the Lead Triage Queue, or does nothing.
     * @author Ryan Tocco
     * @datecreated 2019-05-22
     */
    global void execute(Database.BatchableContext BC, SObject[] scope) {
        List<Lead> lds = scope;
        List<Lead> leadsToUpdate = new List<Lead>();
        for(Lead ld : lds) {
            if(passesNotificationCriteria(ld) == false) continue;
            
            // How much time has passed since the lead's owner was last updated.
            Integer timePassed = Utils_Time.getTimeDifference(unit, ld.Owner_Modified_Date__c, DateTime.now());
            // True if the lead owner is VP or above.
            Boolean vpAndAbove = ld.Owner.Title != NULL &&
                        ((ld.Owner.Title.length() >= 13 && vpAndAboveJobCodes.contains(ld.Owner.Title.substring(0, 13)))
                        || ld.Owner.Title.contains('VP') || ld.Owner.Title.contains('President') || ld.Owner.Title.contains('CEO'));
            Boolean hasAlternateRecordType = reminderSettings.Alternate_Record_Types__c != null && reminderSettings.Alternate_Record_Types__c.split(',').contains(ld.RecordType.Name);
            // If the lead has passed the first time interval and the owner is of rank < VP, send a reminder email.
            if(timePassed >= reminderSettings.Interval_Length_1__c && timePassed < reminderSettings.Interval_Length_2__c && !vpAndAbove) {
                if(hasAlternateRecordType == true) {
                    altReminderUserIds.add(ld.OwnerId);
                } else {
                    reminderUserIds.add(ld.OwnerId);
                }
            // If the second time interval has been passed and the lead still hasn't been contacted or converted, reassign it to the Lead Triage Queue.
            } else if(timePassed >= reminderSettings.Interval_Length_2__c == true && ld.OwnerId != lead72HoursQueue.QueueId) {
                if(hasAlternateRecordType == true && reminderSettings.Alternate_RT_Should_Reassign__c && !vpAndAbove) {
                    altReassignedUserIds.add(ld.OwnerId);
                    ld.OwnerId = lead72HoursQueue.QueueId;
                    leadsToUpdate.add(ld);
                } else if(reminderSettings.Should_Reassign__c == true && !vpAndAbove) {
                    leadReassignedUserIds.add(ld.OwnerId);
                    ld.OwnerId = lead72HoursQueue.QueueId;
                    leadsToUpdate.add(ld);
                }
            }
        }
        
        update leadsToUpdate; // Update the leads that are being reassigned to the Lead Triage Queue.
    }

    /**
     * Contains a check for criteria that could not be specified in the initial query.
     * This criteria is intended to specify if a particular Lead should be sent
     * notifications and reassigned after the assigned time period.
     */
    private Boolean passesNotificationCriteria(Lead ld) {
        // We don't send reminders or change the Owner for Leads where the current Owner is the same User that created the Lead.
        if(ld.OwnerId == ld.CreatedById) return false;

        Boolean hasAlternateRecordType = reminderSettings.Alternate_Record_Types__c != null && reminderSettings.Alternate_Record_Types__c.split(',').contains(ld.RecordType.Name);
        Boolean hasSpecifiedLeadSource = reminderSettings.Lead_Sources__c != null && reminderSettings.Lead_Sources__c.split(',').contains(ld.LeadSource);
        // For a non-alternate Record Type Lead, we only send notifications if it has one of the specified Lead Sources.
        if(hasAlternateRecordType == false && hasSpecifiedLeadSource == false) return false;

        return true;
    }
    
    /*
     * @description Sends out the notification emails, both the reminders and the notifications of Lead reassignment.
     * @author Ryan Tocco
     * @datecreated 2019-05-22
     */
    global void finish(Database.BatchableContext BC) {
        // Send out reminder emails to users.
        sendEmails(reminderUserIds, et3.Id);
        
        // Send out alternate reminder emails to users.
        sendEmails(altReminderUserIds, aet3.Id);
        
        // Send out notification emails to users who have had Leads reassigned.
        if(reminderSettings.Should_Reassign__c) sendEmails(leadReassignedUserIds, et4.Id);
        
        // Send out alternate notification emails to users who have Leads reassigned
        if(reminderSettings.Alternate_RT_Should_Reassign__c) sendEmails(altReassignedUserIds, aet4.Id);
        
        // Used for testing.
        LeadOwnerAssignmentReminder_Batch.emailsSent = reminderUserIds.size() + altReminderUserIds.size() + leadReassignedUserIds.size() + altReassignedUserIds.size();
    }
    
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new LeadOwnerAssignmentReminder_Batch(), 10000);
    }
    
    private void sendEmails(Set<Id> objectIds, Id emailTemplateId) {
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        for(Id objectId : objectIds) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(objectId);
            mail.setTemplateId(emailTemplateId);
            mail.saveAsActivity = False;
            messages.add(mail);
        }
        Messaging.sendEmail(messages);
    }
    
    /*
     * @description Puts together a query for the leads that need to be looked at.
     * @author Ryan Tocco
     * @datecreated 2019-05-22
     */
    public String createQuery(String recordTypes) {
        String query = 'SELECT Id, Owner_Modified_Date__c, Status, Email_Notification_Off__c, LeadSource, OwnerId, CreatedById, Owner.Email, Owner.Title, RecordType.Name FROM Lead WHERE Owner_Modified_Date__c >= LAST_N_DAYS:7 AND Status=\'Open\' AND Owner.Type = \'User\'';
        
        // Put together record type criteria based on the reminder settings. We include all record types specified.
        query = addRecordTypesToQuery(query, recordTypes);
        
        return query;
    }
    
    /*
     * @description Adds the record types to the query.
     * @author Ryan Tocco
     * @datecreated 2019-05-22
     */
    private String addRecordTypesToQuery(String query, String recordTypes) {
        if(recordTypes != null && recordTypes != '') {
            query = query + ' AND (';
            List<String> recordTypeList = recordTypes.split(',');
            for(Integer i = 0; i < recordTypeList.size(); i++) {
                
                String recordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get(recordTypeList[i].trim()).getRecordTypeId();
                if(i == 0) {
                    query = query + 'RecordTypeId = \'' + recordTypeId.trim() + '\'';
                } else {
                    query = query + ' OR RecordTypeId = \'' + recordTypeId.trim() + '\'';
                }
            }
            query = query + ')';
        }
        return query;
    }
    
}