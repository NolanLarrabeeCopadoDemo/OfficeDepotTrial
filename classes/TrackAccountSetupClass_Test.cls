/*************************************************************
 * Name : TrackAccountSetupClass_Test
 * Created By : Himanshu Sharma
 * Created Date :30-04-2020
 * Purpose : Test class for TrackAccountSetupClass class
 * Author: Mohanad Abu Sheikha 5/1/2020
 * JIRA: NAIT-125250
 ****************************************************************/
@isTest
private class TrackAccountSetupClass_Test
{
	@TestSetup
	static void makeData()
	{
		Account acc1 = new Account(name = 'acc1');
		insert acc1;

		Account_Message__c accMessage1 = new Account_Message__c(ACCT_ID_SFDC_ACCOUNT_ID__c = acc1.Id);
		insert accMessage1;

		Account_Setup_Request__c asr1 = new Account_Setup_Request__c(Account__c = acc1.Id);
		insert asr1;
	}

	@isTest
	public static void testCallout()
	{
		Account account = [SELECT Id FROM Account WHERE Name = 'acc1'];

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_TrackAccSetup());
		Test.startTest();
		String jsonResponse = TrackAccountSetupClass.TrackAccountSetupRequest(account.Id);
		Test.stopTest();
		TrackAccountSetupClass.SetInfo parsedSetInfo = (TrackAccountSetupClass.SetInfo) JSON.deserialize(jsonResponse, TrackAccountSetupClass.SetInfo.class);

		system.assertEquals(4, parsedSetInfo.sets.size());
	}

	@isTest
	public static void testTracker()
	{
		Account account = [SELECT Id FROM Account WHERE Name = 'acc1'];

		Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator_TrackAccSetup());
		Test.startTest();
		String jsonResponse = TrackAccountSetupClass.getTrackAcctSetup(account.Id);
		Test.stopTest();
		TrackAccountSetupClass.Tracker parsedTracker = (TrackAccountSetupClass.Tracker) JSON.deserialize(jsonResponse, TrackAccountSetupClass.Tracker.class);

		// system.assertEquals(4, parsedTracker.Max_Step_Number);
		system.assertEquals('Request Sent to AOPS', parsedTracker.Step1_Description);
		system.assertEquals('AOPS Request Received', parsedTracker.Step2_Description);
		system.assertEquals('Request is added to Setup pool in AOPS', parsedTracker.Step3_Description);
		system.assertEquals('Customer created in AOPS', parsedTracker.Step4_Description);
	}
}