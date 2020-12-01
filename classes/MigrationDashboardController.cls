public class MigrationDashboardController {
    // Instance vars
    public MigrationDashboardWrapper migrationStatus {get; set;}
    
    // Method to query all children and standalone customer transitions
    public void populatePurchasingLevel() {
        Map<String, String> statusesToBuckets = getStatuses();
    
        // Get customer transitions
        List<AggregateResult> statusCounts = [SELECT Status__c, Count(Id) recordCount
                                              FROM Customer_Transition__c 
                                              WHERE Customer_Transition_Type2__c IN ('Child','Standalone') 
                                              AND Status__c IN :statusesToBuckets.keySet()
											  AND (NOT omx_primary_key__c LIKE '%-%')
                                              GROUP BY Status__c];
               
        populateWrapper(statusCounts, statusesToBuckets);
    }
    
    // Method to query customer transitions where written agreement = true
    public void pupulateWrittenAgreement() {
        Map<String, String> statusesToBuckets = getStatuses();
    
        // Get customer transitions
        List<AggregateResult> statusCounts = [SELECT Status__c, Count(Id) recordCount
                                              FROM Customer_Transition__c 
                                              WHERE Status__c IN :statusesToBuckets.keySet()
                                              AND Written_Agreement_Customer_Id__c = null
                                              AND Written_Agreement__c = true
                                              AND (NOT omx_primary_key__c LIKE '%-%')
                                              GROUP BY Status__c];              
        populateWrapper(statusCounts, statusesToBuckets);
    }
    
    // Helper method to get a map of statuses and buckets
   @testvisible private Map<String, String> getStatuses() {
        Map<String, String> statusesToBuckets = new Map<String, String>();
        
        for (CM_Dashboard_Status__mdt st : [SELECT MasterLabel, Bucket__c FROM CM_Dashboard_Status__mdt]) {
            statusesToBuckets.put(st.MasterLabel, st.Bucket__c);
        }
        
        return statusesToBuckets;
    }
    
    // Helper method to populate the wrapper with the values from the SOQL queries
    @testvisible private void populateWrapper(List<AggregateResult> statusCounts, Map<String, String> statusesToBuckets) {
        migrationStatus = new MigrationDashboardWrapper();
        
        for (AggregateResult ar : statusCounts) { String status = (String)ar.get('Status__c');
           
            Integer count = ((decimal)ar.get('recordCount')).intValue();
            
            // Put in the correct bucket
            system.debug('@@status'+ status);
            String bucket = statusesToBuckets.get(status);
            system.debug('@@bucket' + bucket);
            if (bucket.equalsIgnoreCase('Scheduled')) {
                migrationStatus.scheduled += count;
            }
            else if (bucket.equalsIgnoreCase('Pricing')) {
                migrationStatus.pricing += count;
            }
            else if (bucket.equalsIgnoreCase('Launched')) {
                migrationStatus.launched += count;            
            }
            else if (bucket.equalsIgnoreCase('Complete')) {
                migrationStatus.complete += count;
            }
        }
            
        // Calculate total and percentages
        migrationStatus.total = migrationStatus.scheduled + migrationStatus.pricing + migrationStatus.launched + 
            migrationStatus.complete;
        migrationStatus.totalPercent = 100;
        
        if (migrationStatus.total != 0) {
            migrationStatus.scheduledPercent = migrationStatus.totalPercent * migrationStatus.scheduled / migrationStatus.total;
            migrationStatus.pricingPercent = migrationStatus.totalPercent * migrationStatus.pricing / migrationStatus.total;
            migrationStatus.launchedPercent = migrationStatus.totalPercent * migrationStatus.launched / migrationStatus.total;
            migrationStatus.completePercent = migrationStatus.totalPercent * migrationStatus.complete / migrationStatus.total;
        }
    }
    
    // Wrapper inner class to help display the values on the VF page
    public class MigrationDashboardWrapper {
        public Integer scheduled {get; set;}
        public Integer pricing {get; set;}
        public Integer launched {get; set;}
        public Integer complete {get; set;}
        public Integer total {get; set;}
        
        public Decimal scheduledPercent {get; set;}
        public Decimal pricingPercent {get; set;}
        public Decimal launchedPercent {get; set;}
        public Decimal completePercent {get; set;}
        public Decimal totalPercent {get; set;}
        
        public MigrationDashboardWrapper() {
            this.scheduled = 0;
            this.pricing = 0;
            this.launched = 0;
            this.complete = 0;
            this.total = 0;
        
            this.scheduledPercent = 0;
            this.pricingPercent = 0;
            this.launchedPercent = 0;
            this.completePercent = 0;
            this.totalPercent = 0;
        }
    }
}