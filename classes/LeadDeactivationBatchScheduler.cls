global class LeadDeactivationBatchScheduler implements Schedulable {
    global static void execute(SchedulableContext sc) {
        LeadDeactivationBatch leadBatch = new LeadDeactivationBatch();
        Database.executeBatch(leadBatch);
    }
}