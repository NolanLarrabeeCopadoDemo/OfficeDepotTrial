/*
 * @description This class is used to manage application licences for users.
 * The SeismicLicenseManagement class is used to build the insert and delete sets for the licenses.
 * Heads Up!: If there is a situation where there are zero users who are supposed to be allocated licenses, then 
 * the batch class will not run. 
 * @author Adam Albright
 * @datecreated 2018-10-23 11:19:46.322851
 *
 * @changes Log any modifications here...
*/
global class SeismicLicenseInsertBatch implements Database.Batchable<sObject>, Database.Stateful {
    global Integer totalRecordCount = 0;
    global Database.QueryLocator start(Database.BatchableContext BC) {

    /*
     * Here we get the batches of objects we want to change or update.
     * Only get what you need.
     */

        String query = SeismicLicenseManagement.buildInsertQuery();

        return Database.getQueryLocator(query);
    } 

    global void execute(Database.BatchableContext BC, List<User> newSeismicUSers) {

        List<UserPackageLicense> newSeismicLicenses = SeismicLicenseManagement.generateNewLicenses(newSeismicUSers);

        totalRecordCount += newSeismicLicenses.size();
        try{
            Insert newSeismicLicenses;
        } catch (DmlException e){
            System.debug(LoggingLevel.ERROR, 'Packages failed to insert. ' + e);
        }
    }

    global void finish(Database.BatchableContext BC) {
    /*
     * Complete any action you need to take after processing like generating a report on the object processed.
     */
     System.debug(LoggingLevel.INFO, 'Total records processed in SeismicLicenseDeleteBatch: ' + totalRecordCount);
    }
}