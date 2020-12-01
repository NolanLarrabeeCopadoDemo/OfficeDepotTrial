/*
 * @description This class is used to manage application licences for users.
 * @author Adam
 * @datecreated 2018-11-08
 * @coverage Provided by SeismicLicenseManagementBatch_Test
 *
 * @changes Log any modifications here...
 */
global class SeismicUserLicenseInsertScheduler implements Schedulable {
    
    global static void execute(SchedulableContext sc){
        SeismicLicenseInsertBatch seismicBatch = new SeismicLicenseInsertBatch();
        Database.executeBatch(seismicBatch);
    }
}