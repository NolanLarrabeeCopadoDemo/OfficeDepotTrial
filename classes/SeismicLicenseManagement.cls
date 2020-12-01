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
 * The Profiles that are used to allocate licenses are located in the License Manager Custom Metadat object under seismic licenses. 
 * @author Adam Albright
 * @datecreated 2018-10-23 11:19:46.322851
 *
 * @changes Log any modifications here...
*/
global class SeismicLicenseManagement {

    /*
     * @description This method retrieves the package license id for seismic.
     * @author Adam Albright
     * @datecreated 2018-11-08
     *
     * @changes Log any modifications here...
     */
    static Id getSeismicPackageId(){

        PackageLicense seismicPL;
        
        try{
            seismicPL = [SELECT Id, NamespacePrefix, AllowedLicenses, UsedLicenses, 
            ExpirationDate,Status FROM PackageLicense WHERE 
            NamespacePrefix = 'seismic'];
        } catch (QueryException e){
            System.debug(LoggingLevel.ERROR, 'Seismic Package Coule Not Be Found.');
            System.debug(LoggingLevel.ERROR, e);
        }

        return seismicPL.Id;
    }

    /*
     * @description This method retrieves the profileIds for user profiles that should a seismic license.
     * @author Adam Albright
     * @datecreated 2018-11-08
     *
     * @changes Log any modifications here...
     */
    static Set<Id> getProfileIds(){
        
        License_Manager__mdt license_profiles;
        Set<Id> profileIds = new Set<Id>();

        try{
            license_profiles = [SELECT User_Profile_API_Names__c FROM License_Manager__mdt WHERE Package_Namespace__c='seismic'];
        } catch(QueryException e){
            System.debug(LoggingLevel.ERROR, 'Getting Seismic package data failed. ' + e);
        }

        List<String> profile_names = new List<String>(license_profiles.User_Profile_API_Names__c.split(','));

        for(Integer i = 0; i < profile_names.size(); i++){
            profile_names[i] = profile_names[i].trim();
        }

        System.debug(LoggingLevel.DEBUG, 'Getting Profile Ids with the following names: ' + profile_names);

        Set<Id> userProfiles = new Set<Id>();
        for(Profile prof: [Select Id, Name FROM Profile WHERE Name IN :profile_names]){
            userProfiles.add(prof.Id);
        }
        System.debug(LoggingLevel.INFO, 'Got the following profile Ids: ' + userProfiles);

        return userProfiles;
    }


    /*
     * @description This method turns a set object in a query set string that can be used in a dynamic query.
     * @author Adam Albright
     * @datecreated 2018-11-08
     *
     * @changes Log any modifications here...
     */
    static String buildQuerySet(Set<Id> idSet){
        // Build Query Set based on profile Ids.
        String set_ids = '';
        for(String my_id: idSet){
            set_ids += '\'' + my_id + '\',';
        }

        // Remove Trailing comma from the generated Id set.
        set_ids = set_ids.removeEnd(',');

        return set_ids;
    }

    /*
     * @description This method retrieves userId for users in testing.
     * @author Adam Albright
     * @datecreated 2018-11-08
     *
     * @changes Log any modifications here...
     */
    static Set<Id> getTestUserIds(){
        List<User> myTestUsers = [Select Id FROM User WHERE Alias = 'tuserfct'];
        Set<Id> testUserIDs = new Set<Id>();
        for(User usr: myTestUsers){
            testUserIDs.add(usr.Id);
        }
        return testUserIDs;
    }

    /*
     * @description This method retrieves userId for users that should have a seismic license. 
     * @author Adam Albright
     * @datecreated 2018-11-08
     *
     * @changes Log any modifications here...
     */
    static Set<Id> getUsersWhoShouldHaveSeismic(){
        Set<Id> validSeismicUserIdSet = new Set<Id>();

        // Get Users who should have a seismic license.
        String query = 'SELECT Id, IsActive, IsSeismicUser__c, Alias, ProfileId FROM User WHERE IsActive=true '+ (Test.isRunningTest()?' AND Alias = \'tuserfct\'': '') +' AND (IsSeismicUser__c = true OR ProfileId IN (';
        String query_end = '))';

        // Rebuild Query
        query = query + buildQuerySet(getProfileIds()) + query_end;

        System.debug(LoggingLevel.DEBUG, 'Query is ' + query);

        List<User> validSeismicUsers = Database.query(query);

        for(User usr : validSeismicUsers) {
            validSeismicUserIdSet.add(usr.Id);
        }

        return validSeismicUserIdSet;
    }

    /*
     * @description This method retrieves user Ids of those who already have a seismic license
     * @author Adam Albright
     * @datecreated 2018-11-08
     *
     * @changes Log any modifications here...
     */
    static Set<Id> getUsersWhoHaveSeismic(Id packageId){
        Set<Id> currentSeismicUserIds = new Set<Id>();
        List<UserPackageLicense> seismicUserPackages = new List<UserPackageLicense>();
        try{ // If we are testing, we need to ensure we are only touching the test users. 
            if(Test.isRunningTest()){
                seismicUserPackages = [SELECT Id, UserId FROM UserPackageLicense WHERE PackageLicenseId=:packageId AND UserId IN :getTestUserIds()];
            }else {
                seismicUserPackages = [SELECT Id, UserId FROM UserPackageLicense WHERE PackageLicenseId=:packageId];
            }
        } catch(QueryException e){
            System.debug(LoggingLevel.ERROR, 'User License Package Query Failed.');
            System.debug(LoggingLevel.ERROR, e);
        }

        for(UserPackageLicense lic: seismicUserPackages){
            currentSeismicUserIds.add(lic.UserId);
        }

        return currentSeismicUserIds;
    }

    /*
     * @description This method builds the query to get package licenses that should be deleted. 
     * @author Adam Albright
     * @datecreated 2018-11-08
     *
     * @changes Log any modifications here...
     */
    public static String buildDeleteQuery(){
        Id seismicPackageId = getSeismicPackageId();
        Set<Id> usersWhoShouldHaveSeismic = getUsersWhoShouldHaveSeismic();
        Set<Id> usersWhoHaveSeismic = getUsersWhoHaveSeismic(seismicPackageId);
        System.debug('Users Who Should have: ' + usersWhoShouldHaveSeismic);
        System.debug('Users Who have: ' + usersWhoHaveSeismic);

        if(Test.isRunningTest()){
            System.debug(LoggingLevel.INFO, 'Users Who Have Seismic Count: ' + usersWhoHaveSeismic.size());
            System.debug(LoggingLevel.INFO, 'Users Who Should Have Seismic Count: ' + usersWhoShouldHaveSeismic.size());
        }
        usersWhoHaveSeismic.removeAll(usersWhoShouldHaveSeismic);
        System.debug(LoggingLevel.INFO, 'Users to delete: ' + usersWhoHaveSeismic);

        // Handles the case where there are no records to update.
        if(usersWhoHaveSeismic.size() == 0)
            return 'SELECT Id, UserId FROM UserPackageLicense WHERE PackageLicenseId=\'' + seismicPackageId +'\' AND ID=\'\'';
        
        String licenseQuery = 'SELECT Id, UserId FROM UserPackageLicense WHERE PackageLicenseId=\'' + seismicPackageId + '\' AND UserId IN (';

        licenseQuery  = licenseQuery + buildQuerySet(usersWhoHaveSeismic) + ')';

        System.debug(LoggingLevel.INFO, 'Delete Query: ' + licenseQuery);


        return licenseQuery;
    }

    /*
     * @description This method builds the query to get users that need to be allocated a Seismic user license.
     * @author Adam Albright
     * @datecreated 2018-11-08
     *
     * @changes Log any modifications here...
     */
    public static String buildInsertQuery(){
        Id seismicPackageId = getSeismicPackageId();
        Set<Id> usersWhoShouldHaveSeismic = getUsersWhoShouldHaveSeismic();
        Set<Id> usersWhoHaveSeismic = getUsersWhoHaveSeismic(seismicPackageId);

        if(Test.isRunningTest()){
            System.debug(LoggingLevel.INFO, 'Users Who Have Seismic Count: ' + usersWhoHaveSeismic.size());
            System.debug(LoggingLevel.INFO, 'Users Who Should Have Seismic Count: ' + usersWhoShouldHaveSeismic.size());
        }
        usersWhoShouldHaveSeismic.removeAll(usersWhoHaveSeismic);
        System.debug(LoggingLevel.INFO, 'Users to give license: ' + usersWhoShouldHaveSeismic);

        // Handles the case where there are no records to update.
        if(usersWhoShouldHaveSeismic.size() == 0)
            return 'SELECT Id FROM User WHERE Id=\'\'';
        
        String userQuery = 'SELECT Id FROM User WHERE Id IN (';

        userQuery  = userQuery + buildQuerySet(usersWhoShouldHaveSeismic) + ')';

        System.debug(LoggingLevel.INFO, 'User Query: ' + userQuery);


        return userQuery;
    }

    /*
     * @description This method generates new package licenses.
     * @author Adam Albright
     * @datecreated 2018-11-08
     *
     * @changes Log any modifications here...
     */
    public static List<UserPackageLicense> generateNewLicenses(List<User> new_seismic_users){
        Id seismicPackageId = getSeismicPackageId();
        List<UserPackageLicense> newLicenses = new List<UserPackageLicense>();
        for(User usr: new_seismic_users){
            newLicenses.add(new UserPackageLicense(PackageLicenseId=seismicPackageId, UserId=usr.Id));
        }
        return newLicenses;
    }

}