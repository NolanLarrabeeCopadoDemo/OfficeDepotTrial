/*
 * @description This class is used to test the job to setclose-reason status of leads closed due to inactivity to Inactive.
 * @author Adam
 * @datecreated 2018-11-12
 *
 * @changes Log any modifications here...
 */
@isTest(SeeAllData=false)
private class LeadCleanUpBatch_Test {

    /***********************************************************************
     * @description This method sets up the test data for testing lead deactivation.
     * @author Adam Albright, 12-November-2018
     * @changes Log any modifications here...
     */
    @testSetup
    static void setup() {
        Integer leadCount = 10;
        List<Lead> myTestLeads = MyUtilsDataFactory.makeLeads(leadCount);

        

        for (Lead myLead: myTestLeads) {
            myLead.Inactive__c = true;
            myLead.Sub_Status__c = 'Other';
            myLead.Close_Reason__c = 'Other';
            myLead.Status = 'Closed';
            myLead.Closed_Date__c = Date.today();
        }

        insert myTestLeads;

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
    static void updateLeadsWithInactiveFlag() {
        List<Lead> myLeads = [
            SELECT Id, Status, Inactive__c, CreatedDate, FirstName
            FROM Lead
            WHERE Status = 'Closed' AND FirstName = 'TestClassLead' AND Close_Reason__c = 'Other'
        ];

        Integer oldLeadCount = myLeads.size();
        System.debug(LoggingLevel.INFO, 'Lead with Invalid Status and : ' + myLeads);


        //update myLeads;
        Test.startTest();
        LeadCleanUpBatch obj = new LeadCleanUpBatch();
        DataBase.executeBatch(obj);
        Test.stopTest();

        List<Lead> result = [
            SELECT Id, Status, Inactive__c, CreatedDate, FirstName
            FROM Lead
            WHERE Status = 'Closed' AND FirstName = 'TestClassLead' AND Close_Reason__c = 'Inactive'
        ];

        System.assertEquals(
            result.size(),
            oldLeadCount,
            'Leads incorrect.'
        );
    }
}