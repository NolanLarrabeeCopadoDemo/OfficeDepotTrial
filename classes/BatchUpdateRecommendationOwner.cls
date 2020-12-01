public without sharing class BatchUpdateRecommendationOwner implements Database.Batchable<sObject> {
    
// Optional definition to make batch stateful, aka forces batch to run in serial.  This slows it down, but reduces risk of row locking
//public without sharing class BatchUpdateRecommendationOwner implements Database.Batchable<sObject>, Database.Stateful {
    
    public BatchUpdateRecommendationOwner () {
        // No Construction Needed
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id';
                query += ' , LBI__Account__r.OwnerId';
                query += ' FROM LBI__Recommendation__c';
                // This formula only evaluates to true if both account relationship exists, and account's owner is different than recommendaiton's owner
                // Right now this is not indexed, but you can request from SFDC to build a custom index on this field for fast querying, if this ends up being slow  
                query += ' WHERE MatchesAccountOwner__c = false and LBI__Account__r.owner.isactive=true'; 
        
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<sObject> recommendationsChunk) {
        
        // Loop over the records in this scope and set their owner to match the parent account owner
        for (LBI__Recommendation__c rec : (List<LBI__Recommendation__c>)recommendationsChunk) {
            // We did all of our conditional checking in the formula here, we know this is safe since the formula evaluated to false
            rec.OwnerId = rec.LBI__Account__r.OwnerId;
        }
        
        // Not checking for list.size() > 0 here, since we're only feeding this job recommendations whose account owners are mismatched
        // Also not using try/catch here or rollbacks since this is scheduled.  It will just re-run on next schedule.
        // This ensures the errors show up in the apex logs at the very least.  Other options are running with Database.update and allornothing=false
        // or a try/catch to log errors using existing error logging service (if it exists)
        update recommendationsChunk;
    }
    
    public void finish(Database.BatchableContext BC) {
        // the following code grabbed out of apex documentation.  I recommend replacing w/ email services you have in place, sending to user groups with interested parties
        
        String email = 'someone@1234abcdef.com';
                
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {email});
        mail.setReplyTo('batch@acme.com');
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Process Completed');
        mail.setPlainTextBody('Batch Process has completed');
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }

}