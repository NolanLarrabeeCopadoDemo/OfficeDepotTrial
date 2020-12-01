/*************************************************************
 * Name : MockHttpResponseGenerator_TrackAccSetup
 * Created By : Himanshu Sharma
 * Created Date :20-03-2020
 * Purpose : Mock class for the testing of TrackAccountSetupClass class
 * JIRA: NAIT-125221
 ****************************************************************/
@isTest
global class MockHttpResponseGenerator_TrackAccSetup implements HttpCalloutMock {
	// Implement this interface method
	global HTTPResponse respond(HTTPRequest req)
	{
		HttpResponse res = new HttpResponse();
		res.setHeader('Content-Type', 'application/json');
		res.setBody('{"set": [{"Step_Number": 1,"Step_Description": "1-SFDC Request (SFD200/201/..F)","Request_Id": "000000000288667","SFDC_Id": "0011k00000UsAslAAF","AOPS_Account_Id": "04688227","B_Name": "Parent Account","Message": "Request on AS400 - Request Received and Posted","Posted_Timestamp": "2019-10-15-12.27.00.352000","Operation": "E"},{"Step_Number": 2,"Step_Description": "GET  2- EXPRESS POOL (CRM20..F)","Request_Id": "000000000288667","SFDC_Id": "0011k00000UsAslAAF","AOPS_Account_Id": "04688227","B_Name": "PARENT ACCOUNT","Message": "Request data added to the setup Pool File","Posted_Timestamp": "20191015 at 1227","Operation": "E"},{"Step_Number": 3,"Step_Description": "GET  3- CUSTOMER CREATED (FCU000P)","Request_Id": "000000000288667","SFDC_Id": "0011k00000UsAslAAF","AOPS_Account_Id": "04688227","B_Name": "PARENT ACCOUNT","Message": "Customer Created in AOPS","Posted_Timestamp": "2019-10-22","Operation": ""},{"Step_Number": 4,"Step_Description": "4- SFDC EXTRACT (SFDEXTMST)","Request_Id": "000000000288667","SFDC_Id": "0011k00000UsAslAAF","AOPS_Account_Id": "04688227","B_Name": "PARENT ACCOUNT","Message": "Customer in SFDC Extract File","Posted_Timestamp": "2019-12-24-07.56.55.839031","Operation": ""}],"o_Rtn_Msg": ""}');
		res.setStatusCode(200);
		return res;

		/*
		   {
		   "set": [
		   {
		    "Step_Number": 1,
		    "Step_Description": "1-SFDC Request (SFD200/201/..F)",
		    "Request_Id": "000000000288667",
		    "SFDC_Id": "0011k00000UsAslAAF",
		    "AOPS_Account_Id": "04688227",
		    "B_Name": "Parent Account",
		    "Message": "Request on AS400 - Request Received and Posted",
		    "Posted_Timestamp": "2019-10-15-12.27.00.352000",
		    "Operation": "E"
		   },
		   {
		    "Step_Number": 2,
		    "Step_Description": "GET  2- EXPRESS POOL (CRM20..F)",
		    "Request_Id": "000000000288667",
		    "SFDC_Id": "0011k00000UsAslAAF",
		    "AOPS_Account_Id": "04688227",
		    "B_Name": "PARENT ACCOUNT",
		    "Message": "Request data added to the setup Pool File",
		    "Posted_Timestamp": "20191015 at 1227",
		    "Operation": "E"
		   },
		   {
		    "Step_Number": 3,
		    "Step_Description": "GET  3- CUSTOMER CREATED (FCU000P)",
		    "Request_Id": "000000000288667",
		    "SFDC_Id": "0011k00000UsAslAAF",
		    "AOPS_Account_Id": "04688227",
		    "B_Name": "PARENT ACCOUNT",
		    "Message": "Customer Created in AOPS",
		    "Posted_Timestamp": "2019-10-22",
		    "Operation": ""
		   },
		   {
		    "Step_Number": 4,
		    "Step_Description": "4- SFDC EXTRACT (SFDEXTMST)",
		    "Request_Id": "000000000288667",
		    "SFDC_Id": "0011k00000UsAslAAF",
		    "AOPS_Account_Id": "04688227",
		    "B_Name": "PARENT ACCOUNT",
		    "Message": "Customer in SFDC Extract File",
		    "Posted_Timestamp": "2019-12-24-07.56.55.839031",
		    "Operation": ""
		   }
		   ],
		   "o_Rtn_Msg": ""
		   }
		 */
	}
}