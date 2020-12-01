public without sharing class ODP_TaskCreation {
    @future
    public static void createTasks(set<id> LatticeActivityIDs){
        
        list<LBI__Activity__c> activities = [select id, name, LBI__Status__c, LBI__ActivityType__c, LBI__ActivityID__c, (select id, 
                LBI__Account__c, LBI__DisqualificationReason__c, LBI__Recommendation__r.LBI__LinkedToOpportunity__c, LBI__Recommendation__r.LBI__Campaign__c, 
                LBI__PlayName__c , LBI__DisqualificationReasonDetails__c from LBI__ActivityRecommendations__r) from LBI__Activity__c where id in: LatticeActivityIDs];
        map<id,Task> newTasks = new map<id,Task>();
        
        Schema.DescribeSObjectResult R = Task.SObjectType.getDescribe();
        Map<String, Schema.RecordTypeInfo> RTs = R.getRecordTypeInfosByName();
        system.debug('RTs   ' + RTs);
        Id taskRecordType = RTs.get('Retention Cadence Task').getRecordTypeId();
        system.debug(taskRecordType);
        

        list<LBI__Recommendation__c> recsToUpdate = new list<LBI__Recommendation__c>();
        for(LBI__Activity__c a: activities){
            system.debug(a);
            String status;

            Task t = new Task();
                t.Task_Type__c = 'salesPRISM';
                t.RecordTypeID=taskRecordType;
                t.ActivityDate=System.Today();
               
         
            
            LBI__ActivityRecommendation__c detail = a.LBI__ActivityRecommendations__r[0];
            
            // For status of disqualified - create tasks based on the reason:
            if(a.LBI__Status__c=='Disqualified' && a.LBI__ActivityType__c != 'Task'){
                // Split reason based on the "-" character
                t.Description = detail.LBI__DisqualificationReasonDetails__c;
                
                if(detail.LBI__DisqualificationReason__c.contains('-')){
                    string[] dispReason = detail.LBI__DisqualificationReason__c.split('-');
                    status = dispReason[0];
                    system.debug(status);
                    t.Call_Disposition__c = dispReason[1];
                    
                        system.debug(a.LBI__ActivityRecommendations__r);
                        for(LBI__ActivityRecommendation__c recHistory : a.LBI__ActivityRecommendations__r){
                            LBI__Recommendation__c rec = new LBI__Recommendation__c();
                                rec.id = recHistory.LBI__Recommendation__c;
                                if(status.contains('In Progress') || status.contains('Interested')){
                                    rec.LBI__Status__c = 'In Progress';
                                    rec.LBI__LastTaskDatetime__c = System.Today();
                                   // rec.LBI__DisqualificationDate__c = null;
                                }
                                else if (status.contains('Qualified')){
                                    rec.LBI__Status__c = 'Qualified';
                                    //rec.LBI__DisqualificationDate__c = null;
                                }
                                
                                rec.ODP_Status__c = 'salesPRISM – ' + status;
                                recsToUpdate.add(rec);
                        }   
                    
                }
                
            }else if(a.LBI__Status__c == 'Qualified'){
                // For status of Qualified - create a New Opportunity task
                // if linked, then create Interested - Recently Ordered/Existing Opportunity
                system.debug(detail.LBI__Recommendation__r.LBI__LinkedToOpportunity__c);
                 LBI__Recommendation__c rec = new LBI__Recommendation__c();
                 rec.id = detail.LBI__Recommendation__c;
                 rec.LBI__DisqualificationReason__c = 'New Opportunity';
                 rec.LBI__DisqualificationDate__c = system.now();
                if(detail.LBI__Recommendation__r.LBI__LinkedToOpportunity__c==true){
                   
                    status = 'Interested';
                }else{
                    status = 'New Opportunity';
                }
                
                rec.ODP_Status__c = 'salesPRISM – ' + status;
                recsToUpdate.add(rec);
            }
            
             if(detail.LBI__Recommendation__r.LBI__Campaign__c!=null)
                t.Primary_Campaign_Source__c = detail.LBI__Recommendation__r.LBI__Campaign__c;
            
            t.WhatId = detail.LBI__Account__c;
            t.Status = 'Completed';
            //t.State__c = 'Closed';
            t.Subject = detail.LBI__PlayName__c;
            t.Disposition_Code__c = 'salesPRISM - ' + status;
            newTasks.put(a.id, t);
           
            
        }
        
        system.debug(newTasks.values());
        if(newTasks.keyset().size()>0) insert newTasks.values();
        
        // Story ID back on the activity
        for(LBI__Activity__c a: activities){
            Task t = newTasks.get(a.id);
            a.LBI__ActivityID__c = t.id;
        }
        
        //update activities;
        
        system.debug(recsToUpdate);
        update recsToUpdate;
        
        
        
    }
}