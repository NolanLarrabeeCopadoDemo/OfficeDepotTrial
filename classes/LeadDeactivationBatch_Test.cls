/*
 * @description This class is used to test the lead deactivation batch job.
 * @author Adam
 * @datecreated 2018-11-12
 *
 * @changes Log any modifications here...
 */
@isTest(SeeAllData=false)
private class LeadDeactivationBatch_Test {
    @isTest
    static DateTime getDateTime() {
        Integer lastYear = Date.today().year() - 1;
        Integer lastDay = Date.today().day();
        Integer month = Date.today().month() - 1;

        if (month <= 0) {
            month = 1;
            lastYear = lastYear - 1;
        }

        Date myDate = Date.newInstance(lastYear, month, lastDay);
        Time myTime = Time.newInstance(3, 3, 3, 0);
        System.debug(
            LoggingLevel.INFO,
            'Old Date Time Is: ' +
            DateTime.newInstance(myDate, myTime).format(
                'yyyy-MM-dd\'T\'hh:mm:ss\'Z\''
            )
        );
        return DateTime.newInstance(myDate, myTime);
    }

    /***********************************************************************
     * @description This method sets up the test data for testing lead deactivation.
     * @author Adam Albright, 12-November-2018
     * @changes Log any modifications here...
     */
    @testSetup
    static void setup() {
        Integer leadCount = 10;
        List<Lead> myTestLeads = MyUtilsDataFactory.makeLeads(leadCount);

        insert myTestLeads;

        for (Integer i = 0; i < myTestLeads.size(); i++) {
            Test.setCreatedDate(myTestLeads[i].Id, getDateTime());
        }

        System.assert(
            myTestLeads.size() == leadCount,
            'User Not Set Up Correctly, Got ' + myTestLeads.size() +
            ', Expected ' +
            leadCount
        );
    }

    /*
     * @description
     * @author Adam Albright
     * @datecreated 2018-11-12
     *
     * @changes Log any modifications here...
     */
    @isTest
    static void deactivateOldLeads() {
        List<Lead> myLeads = [
            SELECT Id, Status, CreatedDate, FirstName
            FROM Lead
            WHERE (Status != 'Closed' AND FirstName = 'TestClassLead')
        ];

        Integer oldLeadCount = myLeads.size();

        System.debug(LoggingLevel.INFO, 'Lead with updated dates: ' + myLeads);


        //update myLeads;
        Test.startTest();
        LeadDeactivationBatch obj = new LeadDeactivationBatch();
        DataBase.executeBatch(obj);
        Test.stopTest();

        List<Lead> result = [
            SELECT Id, Status, CreatedDate, FirstName
            FROM Lead
            WHERE (Status = 'Closed' AND FirstName = 'TestClassLead')
        ];

        System.assertEquals(
            result.size(),
            oldLeadCount,
            'Inactive Lead incorrect. Got ' + result.size() + ', Expected ' +
            oldLeadCount
        );
    }

    /*
     * @description
     * @author Adam Albright
     * @datecreated 2018-11-12
     *
     * @changes Log any modifications here...
     */
    @isTest
    static void testScheduledRun() {
        List<Lead> myLeads = [
            SELECT Id, Status, CreatedDate, FirstName
            FROM Lead
            WHERE (Status != 'Closed' AND FirstName = 'TestClassLead')
        ];

        Integer oldLeadCount = myLeads.size();

        Test.startTest();
        LeadDeactivationBatchScheduler.execute(null);
        Test.stopTest();

        List<Lead> result = [
            SELECT Id, Status, CreatedDate, FirstName
            FROM Lead
            WHERE (Status = 'Closed' AND FirstName = 'TestClassLead')
        ];

        System.assertEquals(
            result.size(),
            oldLeadCount,
            'Inactive Lead incorrect. Got ' + result.size() + ', Expected ' +
            oldLeadCount
        );
    }
}