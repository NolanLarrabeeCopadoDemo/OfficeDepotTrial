public class BatchUpdateRecommendationOwnerSchedule implements System.Schedulable {
    
    public void execute (System.SchedulableContext SC) {
    	// 200 here is the number of records to include in each chunk of the batch.
    	// Generally I tie this to a custom setting so I can update the size without updating code.  Up to you.
    	// Just make sure the custom setting is also used in the unit test
    	Database.executeBatch(new BatchUpdateRecommendationOwner(), 200);
    }
    
}