/*
* This batch job maintains the Email Update Status field on the Medallia Feedback object and
* the Medallia Opted Out field on the Contact object. It works with Medallia Feedback from
* the last 6 months and the associated Contacts.
*/
global class Medallia_Batch implements Database.Batchable<Sobject>, Schedulable {

    private string query;

    public Medallia_Batch() {
        query = 'SELECT Id, Record_Status__c, Email_Update_Status__c, Contact_Email__c, Contact_Id__c, Contact_Id__r.Email '
                + 'FROM Medallia_Feedback__c WHERE CreatedDate >= LAST_N_MONTHS:6';
    }

    global Medallia_Batch(String query) {
        this.query = query;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, SObject[] scope) {
        List<Medallia_Feedback__c> feedbackList = scope;

        // Create a list of Ids of Contacts that have opted out and of Feedback objects that had 
        List<Id> optedOutContactIds = new List<Id>();
        List<Medallia_Feedback__c> feedbackWithUpdatedEmails = new List<Medallia_Feedback__c>();
        for(Medallia_Feedback__c feedback : feedbackList) {
            if(feedback.Record_Status__c == 'Opted Out' && feedback.Contact_Id__c != null) {
                optedOutContactIds.add(feedback.Contact_Id__c);
            // If the delivery was bounced and the Email has been updated (is different on the Contact).
            } else if(feedback.Record_Status__c == 'Delivery bounced (Hard bounce)' && feedback.Contact_Id__r.Email != feedback.Contact_Email__c) {
                feedbackWithUpdatedEmails.add(feedback);
            }
        }

        // If there are Contacts to be marked as opted out, mark them and update.
        if(optedOutContactIds.size() > 0) {
            List<Contact> optedOutContacts = [SELECT Id, Medallia_Opted_Out__c FROM Contact WHERE Id IN :optedOutContactIds];
            for(Contact c : optedOutContacts) {
                c.Medallia_Opted_Out__c = True;
            }
            update optedOutContacts;
        }

        // If there is Medallia Feedback that needs to be marked as having updated a bad email, mark it and update.
        if(feedbackWithUpdatedEmails.size() > 0) {
            for(Medallia_Feedback__c mf : feedbackWithUpdatedEmails) {
                mf.Email_Update_Status__c = True;
            }
            update feedbackWithUpdatedEmails;
        }
    }

    global void finish(Database.BatchableContext bc) {}

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new Medallia_Batch(), 2000);
    }
}