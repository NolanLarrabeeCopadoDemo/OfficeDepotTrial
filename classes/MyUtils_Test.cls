/****************************************
 * @author Adam Albright, adam.albright@officedepot.com
 * @since 05-December-2018
 *
 * @description This class should provide coverage for the MyUtils utility classes.
 *
 */

@isTest
public class MyUtils_Test {
    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @since 05-December-2018
     * @description Runs coverage for the account utility methods.
     */
    @isTest
    static void runCoverageMyUtils_Account() {
        Id RecordId = MyUtils_Account.BizBoxProspectRecordTypeId;
        RecordId = MyUtils_Account.BizBoxCustomerRecordTypeId;
        RecordId = MyUtils_Account.BusProCustomerRecordTypeId;
        List<String> Template_Values = MyUtils_Account.AccountPricingTemplates();
    }

    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @since 18-December-2018
     *
     * @description
     * @param
     *
     */
    @isTest
    static void testCreateEventLog() {
        String criticality = 'INFO';
        String big_message = 'My big message test message 123';
        String class_name = 'MyUtils_Test_test';

        Test.startTest();

        MyUtils_Logger.createApexLogEvent(criticality, big_message, class_name);

        Test.stopTest();

        List<Log__c> myTestLog = [SELECT Id FROM Log__c];
        System.assertEquals(1, myTestLog.size());
    }

    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @since 18-December-2018
     *
     * @description
     * @param
     *
     */
    @isTest
    static void testCreateApexLog() {
        String criticality = 'INFO';
        String badCrit = 'bad';
        String big_message = 'My big message test message 123';
        String class_name = 'MyUtils_Test';

        Test.startTest();

        MyUtils_Logger.createApexLogEntry(
            criticality,
            big_message,
            big_message,
            big_message,
            class_name
        );

        try {
            MyUtils_Logger.createApexLogEntry(
                badCrit,
                big_message,
                big_message,
                big_message,
                class_name
            );
        } catch (DmlException e) {
            System.debug(LoggingLevel.INFO, 'It broke as expected.');
        }

        Test.stopTest();

        List<Log__c> myTestLog = [
            SELECT Id, Full_Message__c, Class_Name__c, Severity__c
            FROM Log__c
            WHERE Severity__c = :criticality
        ];
        System.AssertEquals(myTestLog[0].Full_Message__c, big_message);

        myTestLog = [
            SELECT Id, Full_Message__c, Class_Name__c, Severity__c
            FROM Log__c
            WHERE Severity__c = :badCrit
        ];

        System.assertEquals(myTestLog.size(), 0);
    }

    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com, 11 April 2019
     * @description Does test coverage for createApexJobLogEvent.
     * @param 
     */
    @isTest
    static void testcreateApexJobLogEvent() {
        String criticality = 'INFO';
        String badCrit = 'bad';
        String big_message = 'My big message test message 123';
        String class_name = 'MyUtils_Test';

        Test.startTest();

        MyUtils_Logger.createApexJobLogEvent(
            criticality,
            big_message,
            class_name,
            'JSON'
        );


        //Manually creates an event that has an invalid recordtype.
        LoggingEvent__e myEventLog = new LoggingEvent__e(
            Source__c = big_message,
            Full_Message__c = big_message,
            Log_Level__c = criticality,
            RecordType__c = 'Wrong',
            Format__c = 'TEXT',
            UserId__c = UserInfo.getUserId()
        );

        System.debug(LoggingLevel.INFO, myEventLog);
        Database.SaveResult sr = EventBus.publish(myEventLog);
        // Inspect publishing result
        if (sr.isSuccess()) {
            System.debug('Successfully published event.');
        } else {
            for (Database.Error err: sr.getErrors()) {
                System.debug(
                    'Error returned: ' + err.getStatusCode() + ' - ' +
                    err.getMessage()
                );
            }
        }
        
        Test.stopTest();
    }

    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @since 21-December-2018
     * @description Covers GetAvailableRecordTypeNamesForSObject which returns a map of values available for a picklist field.
     */
    @isTest
    static void coverGetAvailableRecordTypeNamesForSObject() {
        Map<String, Id> myRecordTypes;

        Test.StartTest();
        myRecordTypes = MyUtils.GetAvailableRecordTypeNamesForSObject(
            Account.SObjectType
        );
        Test.stopTest();
        System.assert(
            myRecordTypes.size() > 0,
            'Looks like no recordtypes were found....'
        );
    }

    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @since 21-December-2018
     * @description Covers GetSelectOptionsMap which returns a map of recordtypes availabe for the calling user.
     */
    @isTest
    static void coverGetSelectOptionsMap() {
        Lead myLead = new Lead();

        Test.startTest();
        Map<String, String> MySelectOption = MyUtils.GetSelectOptionsMap(
            myLead,
            'Products__c'
        );
        Test.stopTest();
        System.assert(
            MySelectOption.size() > 0,
            'Looks like no options were found....'
        );
    }

    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @since 21-December-2018
     * @description Covers SuperUser which returns dataloaders id.
     */
    @isTest
    static void coverSuperUser() {
        Test.startTest();
        User su = MyUtils.SuperUser();
        Test.stopTest();
        System.assert(su != null, 'Looks like SuperUser wasn\'t found....');
    }

    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @since 21-December-2018
     * @description Covers SuperUser_BizBox which returns dataloaders id.
     */
    @isTest
    static void coverSuperUser_BizBox() {
        Test.startTest();
        User su = MyUtils.SuperUser_BizBox();
        Test.stopTest();
        System.assert(su != null, 'Looks like SuperUser wasn\'t found....');
    }

    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com
     * @since 21-December-2018
     * @description Covers SuperUser_BusPro which returns dataloaders id.
     */
    @isTest
    static void coverSuperUser_BusPro() {
        Test.startTest();
        User su = MyUtils.SuperUser_BusPro();
        Test.stopTest();
        System.assert(su != null, 'Looks like SuperUser wasn\'t found....');
    }

    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com
    * @since 14 October 2019
    * @description Convert a number from base 10 to base62
    */
    @isTest
    static void test_base62_conversion() {
        Test.startTest();
            System.assertEquals('1ou', MyUtils.integer_to_base62(7000));
            System.assertEquals('-1ou', MyUtils.integer_to_base62(-7000));
            System.assertEquals('1', MyUtils.integer_to_base62(1));
            System.assertEquals('10', MyUtils.integer_to_base62(62));
            System.assertEquals('-10', MyUtils.integer_to_base62(-62));
        Test.stopTest();
    }

    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com
    * @since 29 April 2020
    * @description Get the External form of the instance URL.
    */
    @isTest
    static void test_getHostURL() {
        Test.startTest();
            System.assertEquals(URL.getSalesforceBaseUrl().toExternalForm(), MyUtils.getHostURL());
        Test.stopTest();
    }

    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com
    * @since 29 April 2020
    * @description Get the External form of the instance URL.
    */
    @isTest
    static void test_getRecordTypeInfo() {
        Test.startTest();
            System.assertEquals(Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName().get('Customer'), MyUtils.getRecordTypeInfo('Account', 'Customer'));
        Test.stopTest();
    }

    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com
    * @since 25 June 2020
    * @description Get the selected fields from the objects related to the Id and sobject name passed in.
    */
    @isTest
    static void test_getFieldsFromObject() {
        Test.startTest();
            // Create an object and insert it.
            Lead my_lead = new Lead(LastName='BobTest', Email='TestBob@BobTest.com', Company='The Foo Company');
            insert my_lead;
            System.assertEquals(my_lead.Id, MyUtils.getFieldsFromObject('Lead', my_lead.Id, new List<String>{'Id'}).Id);
            try{
                System.assertEquals(my_lead.Id, MyUtils.getFieldsFromObject('Lead', '729823492', new List<String>{'Id'}).Id);
            } catch(AuraHandledException e) {
                System.debug(e.getMessage());
                System.assert(e.getMessage().startsWith('Script-thrown exception'));
            }
            
        Test.stopTest();
    }
}