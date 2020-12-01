/*
 * @description This class is used to manage application licences for users.
 * This operation is completed using two sets. Set A is the set of Users who currently have access to Seismic. Set B is 
 * the set of Users who should have access to Seismic. From these two sets, we can get a delete set and an insert set. 
 * Delete set is equal to Set A - Set B
 * Insert set is equal to Set B - Set A
 * 
 * Querying on a Setup object, Ie Users means that SeeAllData=false flag does not matter. 

 * Heads Up!: If there is a situation where there are zero users who are supposed to be allocated licenses, then 
 * the batch class will not run. 
 * @author Adam Albright
 * @datecreated 2018-10-23 11:19:46.322851
 *
 * @changes Log any modifications here...
*/
global class SeismicLicenseDeleteBatch implements Database.Batchable<sObject>, Database.Stateful {
    global Integer totalRecordCount = 0;
    global Database.QueryLocator start(Database.BatchableContext BC) {

    /*
     * Here we get the batches of objects we want to change or update.
     * Only get what you need.
     */

        String query = SeismicLicenseManagement.buildDeleteQuery();


        if(Test.isRunningTest()){
            System.debug(LoggingLevel.INFO, 'Query:  ' + query);
            System.debug(LoggingLevel.INFO, 'Result:  ' + Database.query(query));
        }

        return Database.getQueryLocator(query);
    } 

    global void execute(Database.BatchableContext BC, List<UserPackageLicense> old_package_licenses) {

        if(Test.isRunningTest()){
            System.debug(LoggingLevel.INFO, 'Old Seismic Licenses: ' + old_package_licenses);
            System.debug(LoggingLevel.INFO, 'Size: ' + old_package_licenses.size());
        }
        
        totalRecordCount += old_package_licenses.size();

        try{
            Delete old_package_licenses;
        } catch (DmlException e){
            System.debug(LoggingLevel.ERROR, 'Packages failed to delete. ' + e);
        }
    }

    global void finish(Database.BatchableContext BC) {
    /*
     * Complete any action you need to take after processing like generating a report on the object processed.
     */
     System.debug(LoggingLevel.INFO, 'Total records processed in SeismicLicenseDeleteBatch: ' + totalRecordCount);
    }
}