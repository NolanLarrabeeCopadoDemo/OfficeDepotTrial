global class LatticeHighestPlaySelector implements Database.Batchable<AggregateResult>, Database.Stateful, Schedulable {

    // Constants
    final static String DEFAULT_QUERY = 'SELECT Header_Account__c ' +
                                        'FROM Lattice_Play__c ' +
                                        'GROUP BY Header_Account__c ' +
                                        'HAVING MAX(Processed_Integer__c) = 0 ' +
                                        'LIMIT 3000';
    final static integer CONTROL_GROUP_PERCENTAGE = 25;
    final static String CONTROL_GROUP_ASSIGNMENT = 'CONTROL';
    final static String TEST_GROUP_ASSIGNMENT = 'TEST';
    final static integer PLAYS_TO_UPDATE = 10;

    // Class variables
    public integer controlCount;
    public integer testGroupLimit;
    
    global Iterable<AggregateResult> start(Database.BatchableContext BC) {
        controlCount = 1; 
        testGroupLimit = 100/CONTROL_GROUP_PERCENTAGE;
        
        return new AggregateResultIterable();
    }
    
    global void execute(Database.BatchableContext BC, List<sObject>scope) { 

        // For each header account id 
        for (sObject headerPlay : scope) {
            AggregateResult currentHeaderPlay = (AggregateResult)headerPlay;
            String headerAcctId = (String)currentHeaderPlay.get('Header_Account__c');
            
            // Get all plays under the same header
            List<Lattice_Play__c> plays = [SELECT Account_ID__c, Play_Score__c, Highest_Play_Flag__c, Product_Category__c, Test_Control__c, Offer_Flag__c, 
                                           Opt_In_Out_Flag__c, Legal_WA_Flag__c, Processed__c
                                           FROM Lattice_Play__c
                                           WHERE Header_Account__c = :headerAcctId];
                                           
            // Create and populate sets for Account IDs and product categories
            Set<String> accounts = new Set<String>();
            Set<String> prodCats = new Set<String>();
            
            for (Lattice_Play__c play : plays) {
                accounts.add(play.Account_ID__c);
                prodCats.add(play.Product_Category__c);
            }
            
            // Get tasks for plays
            List<Task> tasks = [SELECT Product_Category__c, Disposition_Code__c, CreatedDate, WhatID
                                FROM Task
                                WHERE WhatId IN :accounts
                                AND Product_Category__c IN :prodCats
                                AND Status = 'Completed'
                                AND Disposition_Code__c LIKE 'Salesprism%'
                                ALL ROWS];
                                
            // Get most recent disposition code (Task) per product at site level
            Map<String, Task> latestTasks = new Map<String, Task>();
            
            for (Task t : tasks) {
                String uniqueKey = t.WhatID + '~' + t.Product_Category__c;
                
                // Keep most recent task (by created date) in map
                if (!latestTasks.containsKey(uniqueKey)) {
                    latestTasks.put(uniqueKey, t);
                }
                else {
                    Datetime tDate = t.CreatedDate;
                    Datetime mapTaskDate = latestTasks.get(uniqueKey).CreatedDate;
                    
                    if (tDate > mapTaskDate) {
                        latestTasks.put(uniqueKey, t);
                    }
                }
            }
            
            // Traverse most recent tasks map to determine which product categories to drop from max score calculation
            List<Lattice_Disposition_Codes__c> dispositionCodes = [SELECT Code__c
                                                                   FROM Lattice_Disposition_Codes__c
                                                                   WHERE Description__c = 'Exclude'];
            
            Set<String> dispositionsToDrop = new Set<String>();
            Set<String> droppedProductCat = new Set<String>();
            
            for (Lattice_Disposition_Codes__c dc: dispositionCodes) {
                dispositionsToDrop.add(dc.code__c.toUpperCase());
            }
            
            for (String key : latestTasks.keySet()) {
                Task t = latestTasks.get(key);
                
                if (dispositionsToDrop.contains(t.Disposition_Code__c.toUpperCase())) {
                    droppedProductCat.add(t.Product_Category__c.toUpperCase());
                }
            }
            
            // Traverse original list and find highest score, ignoring the dispositions to drop
            double maxScore = 0;
            integer maxScoreIndex = -1;
            
            for (integer i = 0; i < plays.size(); i++) {
                Lattice_Play__c play = plays[i];

                if (!droppedProductCat.contains(play.Product_Category__c.toUpperCase()) && play.Play_Score__c > maxScore) {
                    maxScore = play.Play_Score__c;
                    maxScoreIndex = i;
                }
            }
            
            // Mark record with highest score
            Set<Lattice_Play__c> updatedPlays = new Set<Lattice_Play__c>();
            
            if (maxScoreIndex != -1) {
                Lattice_Play__c maxPlay = plays[maxScoreIndex];
                maxPlay.Highest_Play_Flag__c = true;
                

                // Mark play as processed
                maxPlay.processed__c = true;
                
                // Assign to test/control group
                if (controlCount == testGroupLimit) {
                    maxPlay.Test_Control__c = CONTROL_GROUP_ASSIGNMENT;
                }
                else {
                    maxPlay.Test_Control__c = TEST_GROUP_ASSIGNMENT;
                }
                    
                // Assign monetate campaign names and email intro codes
                assignMonetateCampaignEmailCodes(maxPlay);
                
                updatedPlays.add(maxPlay);
            }
            
            // Mark some plays as updated
            for (integer i = 0; i < PLAYS_TO_UPDATE && i < plays.size(); i++) {
                Lattice_Play__c p = plays[i];
                p.processed__c = true;
                updatedPlays.add(p);
            }
            
            // Update plays
            List<Lattice_Play__c> updatedPlaysList = new List<Lattice_Play__c>();
            updatedPlaysList.addAll(updatedPlays);
            update updatedPlaysList;
            
            // Update control group count
            if (controlCount == testGroupLimit) {
                controlCount = 1;
            }
            else {
                controlCount++;
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        execute((SchedulableContext)null);
    }
    
    // Helper method to hold all the logic for Monetate Campaign Names and Email Intro Codes assignment
    private void assignMonetateCampaignEmailCodes(Lattice_Play__c p) {
        // use vars for case/switch block
        String pc = p.Product_Category__c;
        String tc = p.Test_Control__c;
        String off = p.Offer_Flag__c;
        String opt = p.Opt_In_Out_Flag__c;
        String leg = p.Legal_WA_Flag__c;
        
        
        if (tc == 'CONTROL') {
            if (pc == 'CBS') {
                // Offer
                if (off == 'Y' && (leg == 'N' || leg == null)) {
                    p.Monetate_Campaign_Name__c = 'CONTROL_CBS_Offer';
                    
                    if (opt == 'Y') {
                        p.Email_Intro_Code__c = 'N/A';
                    }
                }
                // Non Offer
                else if (off == 'N' || (off == 'Y' && leg == 'Y')) {
                    p.Monetate_Campaign_Name__c = 'CONTROL_CBS_NonOffer';   
                    
                    if (opt == 'Y') {
                        p.Email_Intro_Code__c = 'N/A'; 
                    }                   
                }
            }
            else if (pc == 'Technology') {
                // Offer
                if (off == 'Y' && (leg == 'N' || leg == null)) {
                    p.Monetate_Campaign_Name__c = 'CONTROL_Tech_Offer';
                    
                    if (opt == 'Y') {
                        p.Email_Intro_Code__c = 'N/A';
                    }
                }
                // Non Offer
                else if (off == 'N' || (off == 'Y' && leg == 'Y')) {
                    p.Monetate_Campaign_Name__c = 'CONTROL_Tech_NonOffer';  
                    
                    if (opt == 'Y') {
                        p.Email_Intro_Code__c = 'N/A';
                    }                   
                }                       
            }
            else if (pc == 'Furniture') {
                // Offer
                if (off == 'Y' && (leg == 'N' || leg == null)) {
                    p.Monetate_Campaign_Name__c = 'CONTROL_Furn_Offer';
                    
                    if (opt == 'Y') {
                        p.Email_Intro_Code__c = 'N/A';
                    }
                }
                // Non Offer
                else if (off == 'N' || (off == 'Y' && leg == 'Y')) {
                    p.Monetate_Campaign_Name__c = 'CONTROL_Furn_NonOffer';  
                    
                    if (opt == 'Y') {
                        p.Email_Intro_Code__c = 'N/A';
                    }                   
                }                       
            }
            else if (pc == 'Supplies') {
                // Offer
                if (off == 'Y' && (leg == 'N' || leg == null)) {
                    p.Monetate_Campaign_Name__c = 'CONTROL_Supp_Offer';
                    
                    if (opt == 'Y') {
                        p.Email_Intro_Code__c = 'N/A';
                    }
                }
                // Non Offer
                else if (off == 'N' || (off == 'Y' && leg == 'Y')) {
                    p.Monetate_Campaign_Name__c = 'CONTROL_Supp_NonOffer';  
                    
                    if (opt == 'Y') {
                        p.Email_Intro_Code__c = 'N/A';
                    }                   
                }
            }
        }
        else if (tc == 'TEST') {
            if (pc == 'CBS') {
                // Offer
                if (off == 'Y' && (leg == 'N' || leg == null)) {
                    p.Monetate_Campaign_Name__c = 'TEST_CBS_Offer';
                    
                    if (opt == 'Y') {
                        p.Email_Intro_Code__c = 'COF';
                    }
                }
                // Non Offer
                else if (off == 'N' || (off == 'Y' && leg == 'Y')) {
                    p.Monetate_Campaign_Name__c = 'TEST_CBS_NonOffer';  
                    
                    if (opt == 'Y') {
                        p.Email_Intro_Code__c = 'CNO';
                    }                   
                }
            }
            else if (pc == 'Technology') {
                // Offer
                if (off == 'Y' && (leg == 'N' || leg == null)) {
                    p.Monetate_Campaign_Name__c = 'TEST_Tech_Offer';
                    
                    if (opt == 'Y') {
                        p.Email_Intro_Code__c = 'TOF';
                    }
                }
                // Non Offer
                else if (off == 'N' || (off == 'Y' && leg == 'Y')) {
                    p.Monetate_Campaign_Name__c = 'TEST_Tech_NonOffer'; 
                    
                    if (opt == 'Y') {
                        p.Email_Intro_Code__c = 'TNO';
                    }                   
                }                       
            }
            else if (pc == 'Furniture') {
                // Offer
                if (off == 'Y' && (leg == 'N' || leg == null)) {
                    p.Monetate_Campaign_Name__c = 'TEST_Furn_Offer';
                    
                    if (opt == 'Y') {
                        p.Email_Intro_Code__c = 'FOF';
                    }
                }
                // Non Offer
                else if (off == 'N' || (off == 'Y' && leg == 'Y')) {
                    p.Monetate_Campaign_Name__c = 'TEST_Furn_NonOffer'; 
                    
                    if (opt == 'Y') {
                        p.Email_Intro_Code__c = 'FNO';
                    }                   
                }                       
            }
            else if (pc == 'Supplies') {
                // Offer
                if (off == 'Y' && (leg == 'N' || leg == null)) {
                    p.Monetate_Campaign_Name__c = 'TEST_Supp_Offer';
                    
                    if (opt == 'Y') {
                        p.Email_Intro_Code__c = 'OOF';
                    }
                }
                // Non Offer
                else if (off == 'N' || (off == 'Y' && leg == 'Y')) {
                    p.Monetate_Campaign_Name__c = 'TEST_Supp_NonOffer'; 
                    
                    if (opt == 'Y') {
                        p.Email_Intro_Code__c = 'ONO';
                    }                   
                }
            }   
        }  
    }
    
    // Iterable inner class
    global class AggregateResultIterable implements Iterable<AggregateResult> {
        global Iterator<AggregateResult> Iterator(){
            return new AggregateResultIterator();
       }
    }
    
    // Iterator inner class
    global class AggregateResultIterator implements Iterator<AggregateResult> {
        AggregateResult [] results {get;set;}
        // tracks which result item is returned
        Integer index {get; set;} 
             
        global AggregateResultIterator() {
           index = 0;
           // Fire query here to load the results
           results = Database.query(DEFAULT_QUERY);            
        } 
       
        global boolean hasNext(){ 
           return results != null && !results.isEmpty() && index < results.size(); 
        }    
       
        global AggregateResult next(){        
           return results[index++];            
        }       
    }
    
    global void execute(SchedulableContext SC) {
        List<AggregateResult> remaining = [SELECT Header_Account__c
                                           FROM Lattice_Play__c
                                           GROUP BY Header_Account__c
                                           HAVING MAX(Processed_Integer__c) = 0
                                           LIMIT 1];
        if (remaining.size() > 0) {
            LatticeHighestPlaySelector latticeBatch = new LatticeHighestPlaySelector(); 
            Database.executebatch(latticeBatch, 50);
        }
    
    }    
}