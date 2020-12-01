/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class UserLoginData_Batch_TC 
{

    static testMethod void myUnitTest() 
    {
        UserHelper.allUserData();
        
        Map<String, List<User>> string_user_map = new Map<String, List<User>> ();
        Set<String> setRegion = new Set<String> ();
        setRegion.add('Florida');
        setRegion.add('manufacturing'); 
        string_user_map= UserHelper.allActiveUsersByRegion(setRegion);
        
        string_user_map= UserHelper.allActiveUsersByMarket(setRegion);
        
        UserHelper.retrieveUserData(setRegion);
        
        UserHelper.retrieveUserDataFromNames(setRegion);
        
        Boolean boolean1;
        id urid ;
        boolean1 = UserHelper.isActiveUserId(urid);
        
        boolean1 = UserHelper.isValidUserId(urid);
        
        User usr = new User (); 
        usr = UserHelper.getUserRecord(urid);
        
        Map<Id,User> id_usr_map= new Map<Id,User>();
        Set<id> userIds = new Set<id>();
        id_usr_map = UserHelper.getUserRecords(userIds);
        
        Test.startTest();
        String strQuery = 'Select id, Name, UserName, Profile.Name, LastLoginDate, Second_Last_Login_Date__c, isActive, Training_Date__c, Week_1_Login__c, Week_2_Login__c, Week_3_Login__c, Week_4_Login__c FROM User where isActive = true and LastLoginDate != null and Training_Date__c != null limit 200';
        UserLoginData_Batch userBatch = new UserLoginData_Batch(strQuery);
        
        //assignBatch.strQuery = 'Select id, Name, UserName, Profile.Name, LastLoginDate, Second_Last_Login_Date__c, isActive, Training_Date__c, Week_1_Login__c, Week_2_Login__c, Week_3_Login__c, Week_4_Login__c FROM User where isActive = true and LastLoginDate != null limit 50';
        database.executebatch(userBatch, 200);
        Test.stopTest();

    }
}