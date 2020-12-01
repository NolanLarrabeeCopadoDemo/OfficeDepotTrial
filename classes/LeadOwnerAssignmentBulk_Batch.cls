/*
* @description Intended to run often (hourly or so). Sends notifications to Lead
* owners if one or more Leads were assigned to them through Data Loader.
* @author Ryan Tocco
* @datecreated 2019-05-22
*
* @changes Log any modifications here...
*/
global class LeadOwnerAssignmentBulk_Batch implements Database.Batchable<Sobject>, Database.Stateful, Schedulable {
    
    private String query;
    private Reminder_Settings__mdt reminderSettings;
    private EmailTemplate et2;
    private EmailTemplate aet2;
    private Set<String> vpAndAboveJobCodes;
    
    global Set<Id> userIds;
    global Set<Id> altTemplateUserIds;
    
    // Used for testing.
    @TestVisible static Integer emailsSent = 0;
    
	global LeadOwnerAssignmentBulk_Batch() {
        loadData();
        query = 'SELECT Id, Owner.Email, Owner.Title, RecordType.Name FROM Lead WHERE Owner.Type = \'User\' AND Send_Lead_Notification_Email__c = True';
    }
    
    global LeadOwnerAssignmentBulk_Batch(String query) {
        loadData();
        this.query = query;
    }
    
    /*
     * @description Helper method for the constructors, loads in peripheral data.
     * @author Ryan Tocco
     * @datecreated 2019-05-22
     *
     * @changes Log any modifications here...
     */
    private void loadData() {
        // Load Custom Metadata.
        reminderSettings = [SELECT Id, Email_Template_Name_2__c, Alternate_Email_Template_Name_2__c, Alternate_Record_Types__c FROM Reminder_Settings__mdt WHERE Label = 'Lead Reminders'];
        et2 = [SELECT Id FROM EmailTemplate WHERE Name =: reminderSettings.Email_Template_Name_2__c];
        aet2 = [SELECT Id FROM EmailTemplate WHERE Name =: reminderSettings.Alternate_Email_Template_Name_2__c];
        
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
	 *
	 * @changes Log any modifications here...
	 */
    global Database.QueryLocator start(Database.BatchableContext BC) {
        userIds = new Set<Id>();
        altTemplateUserIds = new Set<Id>();
        return Database.getQueryLocator(query);
    }
    
    /*
     * @description Goes through the Leads queried (note that their Send Lead Notification Email flag
     * is set to true) and adds their owners to the userIds set. Note that it also turns the flag off.
     * @author Ryan Tocco
     * @datecreated 2019-05-22
     *
     * @changes Log any modifications here...
     */
    global void execute(Database.BatchableContext BC, SObject[] scope) {
        List<Lead> lds = scope;
        
        for(Lead ld : lds) {
            ld.Send_Lead_Notification_Email__c = False; // Update the lead so that the email isn't sent again later.
            // If the owner is not VP or above, we will send them an email.
            Boolean vpAndAbove = ld.Owner.Title != NULL &&
                		((ld.Owner.Title.length() >= 13 && vpAndAboveJobCodes.contains(ld.Owner.Title.substring(0, 13)))
               			|| ld.Owner.Title.contains('VP') || ld.Owner.Title.contains('President') || ld.Owner.Title.contains('CEO'));
            Boolean hasAlternateRecordType = reminderSettings.Alternate_Record_Types__c != null && reminderSettings.Alternate_Record_Types__c.split(',').contains(ld.RecordType.Name);
            if(!vpAndAbove) {
                if(hasAlternateRecordType == true) {
                    altTemplateUserIds.add(ld.OwnerId); // Specify that this lead's owner needs an email sent to them.
                } else {
            		userIds.add(ld.OwnerId); // Specify that this lead's owner needs an email sent to them.
                }
            }
        }
        
        update lds;
    }
    
    /*
     * @description Sends notification emails to Users in the userIds set.
     * @author Ryan Tocco
     * @datecreated 2019-05-22
     *
     * @changes Log any modifications here...
     */
    global void finish(Database.BatchableContext BC) {
        // Send emails to the users.
        sendEmails(userIds, et2.Id);
        sendEmails(altTemplateUserIds, aet2.Id);
        
        // Used for testing.
        LeadOwnerAssignmentBulk_Batch.emailsSent = userIds.size() + altTemplateUserIds.size();
    }
    
    /*
     * @description This implements the Schedulable interface, and will what is called by the Salesforce scheduler.
     * @author Ryan Tocco
     * @datecreated 2019-05-22
     *
     * @changes Log any modifications here...
     */
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new LeadOwnerAssignmentBulk_Batch(), 10000);
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
}