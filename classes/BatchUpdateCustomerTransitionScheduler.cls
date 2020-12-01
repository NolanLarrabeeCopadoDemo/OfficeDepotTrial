// (c) 2016 Appirio, Inc.
//
// Batch class scheduler to run the batch class that
// will update three fields on the Customer Transition Object each day
//
// 6 Oct 2016     Luke Slevin       Original S-440213/S-440215

global class BatchUpdateCustomerTransitionScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        BatchUpdateCustomerTransition b = new BatchUpdateCustomerTransition();
        database.executebatch(b);
    }
}