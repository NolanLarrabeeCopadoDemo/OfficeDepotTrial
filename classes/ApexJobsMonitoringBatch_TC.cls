@isTest
private class ApexJobsMonitoringBatch_TC {

	private static testMethod void test() {
	    MDR_Batch assignBatch = new MDR_Batch();
        database.executebatch(assignBatch, 1);
	    
        ApexJobsMonitoringBatch batch = new ApexJobsMonitoringBatch(); 
        Database.executebatch(batch, 100);
	}
}