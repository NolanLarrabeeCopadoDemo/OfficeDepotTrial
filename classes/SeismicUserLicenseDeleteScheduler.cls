/*
 * @description This class is used to manage application licences for users on a schedule.
 * @author Adam
 * @datecreated 2018-11-08
 * @coverage Provided by SeismicLicenseManagementBatch_Test
 *
 * @changes Log any modifications here...
 */
global class SeismicUserLicenseDeleteScheduler implements Schedulable {
    
    global static void execute(SchedulableContext sc){
        SeismicLicenseDeleteBatch seismicBatch = new SeismicLicenseDeleteBatch();
        Database.executeBatch(seismicBatch);
    }
}