/**
* @File Name   : Delegate_Approver_Batch.cls
* @Description : Controls setting delegate approvers.
                 Also starts and ends the delegate approver requests.
                 A Delegate_Approver_Request__c record simply needs to be created,
                 and it will get processed whenever this batch job runs (daily).
* @Author      : Mohanad Abu Sheikha
**/
//Mohit

global class Delegate_Approver_Batch implements Database.Batchable<SObject>, Schedulable
{
    private String query_requests_with_status;
    
    public Delegate_Approver_Batch()
    {
        query_requests_with_status =
            'SELECT '                            +
                'Id,'                            +
                'Start_Date__c,'                 +
                'End_Date__c,'                   +
                'User__c,'                       +
                'Delegate_Approver__c,'          +
                'Approved__c,'                   +
                'Status__c '                     +
            'FROM Delegate_Approver_Request__c ' +
            'WHERE Status__c != null AND Status__c != \'Ended\'';
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(query_requests_with_status);
    }
    
    global void execute(Database.BatchableContext bc, SObject[] scope)
    {
        // To keep track of Delegate_Approver_Request__c records that we need to update.
        // NOTE: I'm using a Map to avoid the 'Duplicate id in list' error with the List datatype.
        Map<Id, Delegate_Approver_Request__c> requests_to_update = new Map<Id, Delegate_Approver_Request__c>();
        Map<Id, User> users_to_update = new Map<Id, User>();
        
        for (Delegate_Approver_Request__c request :(List<Delegate_Approver_Request__c>)scope)
        {
            // Find the user who we will set the Delegated Approver on
            User original_approver = [SELECT Id, DelegatedApproverId
                                      FROM User
                                      WHERE Id = :request.User__c];
            
            // Check if the request should start
            if (request.Start_Date__c <= Date.today())
            {
                
                // If a request was submitted
                if (request.Status__c == 'Submitted')
                {
                    // And it was approved
                    if (request.Approved__c)
                    {
                        // Set the request to Started
                        request.Status__c = 'Started';
                        requests_to_update.put(request.Id, request);
                        
                        // Set the Delegate Approver for the person who sent this request.
                        original_approver.DelegatedApproverId = request.Delegate_Approver__c;
                        users_to_update.put(original_approver.Id, original_approver);
                    }
                }
            }
            
            // Check if the request should end
            if (request.End_Date__c < Date.today())
            {
                // Set the request to Ended
                request.Status__c = 'Ended';
                requests_to_update.put(request.Id, request);
                
                // Remove the Delegate Approver from this user
                original_approver.DelegatedApproverId = null;
                users_to_update.put(original_approver.Id, original_approver);
            }
        }
        
        update requests_to_update.values();
        update users_to_update.values();
    }
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
    
    global void execute(SchedulableContext sc)
    {
        Database.executeBatch(new Delegate_Approver_Batch());
    }
}