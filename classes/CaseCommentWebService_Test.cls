@isTest
public with sharing class CaseCommentWebService_Test
{
    @TestSetup
    static void setup_data()
	{
		Case caseTest = new Case(Subject = '441PMOct17');
		insert caseTest;
    }

    /*
     * @author Adam Albright, adam.albright@officedepot.com, 02 October 2019
     * @description Validates the correct example schema gets generated for the get request.
     */
	// I disliked running all the tests in two functions.


	// Test the GET method
	// Accepts XML
	@isTest
	public static void test_doGet_xml()
	{
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

		req.httpMethod 			= 'GET';
		req.addHeader('Accept', 'application/xml');
		RestContext.request 	= req;
		RestContext.response 	= res;
		CaseCommentWebService.doGet();
		res = RestContext.response;

		String xmlResponseContent 	= res.responseBody.toString();
		String caseId 				= xmlResponseContent.substringBetween('<case_id>', 					'</case_id>');
		String freshdeskId 			= xmlResponseContent.substringBetween('<freshdesk_id>', 			'</freshdesk_id>');
		String oracleCxId 			= xmlResponseContent.substringBetween('<oraclecx_id>', 			'</oraclecx_id>');
		String commentPaylod 		= xmlResponseContent.substringBetween('<comment_payload_base64>', 	'</comment_payload_base64>');

		System.assert(res.headers.get('Content-Type') 	== 'application/xml');
		System.assert(caseId 							== 'OPTIONAL_SALESFORCE_CASE_ID_ONLY_ONE_ID_PARAMATER_MAY_BE_SPECIFIED_IN_EACH_REQUEST_OBJECT');
		System.assert(freshdeskId 						== '-1');
		System.assert(oracleCxId 						== '-1');
		System.assert(commentPaylod 					== 'REQUIRED_COMMENT_BODY_IN_BASE64');
	}

	// Tests the GET method
	// Accepts JSON
	@isTest
	public static void test_doGet_json()
	{
        RestRequest req 		= new RestRequest();
        RestResponse res 		= new RestResponse();

		req.httpMethod 			= 'GET';
		req.addHeader('Accept', 'application/json');
		RestContext.request 	= req;
		RestContext.response 	= res;
		CaseCommentWebService.doGet();
		res = RestContext.response;

		CaseCommentSchema jsonResponseContent 	= (CaseCommentSchema) JSON.deserialize(res.responseBody.toString(), CaseCommentSchema.class);
		String caseId 							= jsonResponseContent.case_id;
		Integer freshdeskId 					= jsonResponseContent.freshdesk_id;
		Integer oracleCxId 						= jsonResponseContent.oraclecx_id;
		String commentPaylod 					= jsonResponseContent.comment_payload_base64;

		System.assert(res.headers.get('Content-Type') 	== 'application/json');
		System.assert(res.statusCode 					== 200);
		System.assert(caseId 							== 'OPTIONAL_SALESFORCE_CASE_ID_ONLY_ONE_ID_PARAMATER_MAY_BE_SPECIFIED_IN_EACH_REQUEST_OBJECT');
		System.assert(freshdeskId 						== -1);
		System.assert(oracleCxId 						== -1);
		System.assert(commentPaylod 					== 'REQUIRED_COMMENT_BODY_IN_BASE64');
	}
	
	// Tests the POST method
	// Sends XML content
	// Accepts XML
	@isTest
	public static void test_doPost_xml()
	{
		Case caseTest = [SELECT Id FROM Case WHERE Subject = '441PMOct17'];

		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();

		//String commentTest = 'Testing the Case Comment Web Service...';
		String commentTest = 'VGVzdGluZyB0aGUgQ2FzZSBDb21tZW50IFdlYiBTZXJ2aWNl';
		String xmlTest1 =
			'<case_id>' + caseTest.Id + '</case_id>' +
			'<comment_payload_base64>' + commentTest + '</comment_payload_base64>';

		req.addHeader('Content-Type', 	'application/xml');
		req.addHeader('Accept', 		'application/xml');
		req.httpMethod 			= 'POST';
		req.requestBody 		= Blob.valueOf(xmlTest1);
		RestContext.request 	= req;
		RestContext.response 	= res;
		CaseCommentWebService.doPost();
		res = RestContext.Response;

		String xmlResponseContent 	= res.responseBody.toString();
		String caseId 				= xmlResponseContent.substringBetween('<case_id>', 					'</case_id>');
		String freshdeskId 			= xmlResponseContent.substringBetween('<freshdesk_id>', 			'</freshdesk_id>');
		String oracleCxId 			= xmlResponseContent.substringBetween('<oraclecx_id>', 				'</oraclecx_id>');
		String commentPaylod 		= xmlResponseContent.substringBetween('<comment_payload_base64>', 	'</comment_payload_base64>');

		System.assert(res.headers.get('Content-Type') 	== 'application/xml');
		System.assert(res.statusCode 					== 201);
		System.assert(caseId 							== caseTest.Id);
		System.assert(freshdeskId 						== 'null');
		System.assert(oracleCxId 						== 'null');
		System.assert(commentPaylod 					== commentTest);
	}

	// Tests the POST method
	// Sends XML content
	// Sets the accepted content type to something unexpected
	@isTest
	public static void test_doPost_xml_bad_request()
	{
		Case caseTest = [SELECT Id FROM Case WHERE Subject = '441PMOct17'];

		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();

		//String commentTest = 'Testing the Case Comment Web Service...';
		String commentTest = 'VGVzdGluZyB0aGUgQ2FzZSBDb21tZW50IFdlYiBTZXJ2aWNl';
		String xmlTest1 =
			'<case_id>' + caseTest.Id + '</case_id>' +
			'<comment_payload_base64>' + commentTest + '</comment_payload_base64>';

		req.addHeader('Content-Type', 	'application/xml');
		req.addHeader('Accept', 		'application/theworld');
		req.httpMethod 			= 'POST';
		req.requestBody 		= Blob.valueOf(xmlTest1);
		RestContext.request 	= req;
		RestContext.response 	= res;
		CaseCommentWebService.doPost();
		res = RestContext.Response;

		System.assert(res.statusCode == 204);
	}

	// Tests the POST method
	// Sets the content type to something unexpected
	// Doesn't specify what it accepts
	@isTest
	public static void test_doPost_json()
	{
		Case caseTest = [SELECT Id FROM Case WHERE Subject = '441PMOct17'];

		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();

		req.addHeader('Content-Type', 	'application/theworld');
		req.httpMethod 			= 'POST';
		RestContext.request 	= req;
		RestContext.response 	= res;
		CaseCommentWebService.doPost();
		res = RestContext.Response;

		System.assert(res.statusCode 				== 400);
		System.assert(res.responseBody.toString() 	== 'bad request, accepted content types include application/json and application/xml');
	}

	// Tests the POST method
	// Sets the content type to JSON
	// Accepts JSON
	@isTest
	public static void test_doPost_json_bad_request()
	{
		Case caseTest = [SELECT Id FROM Case WHERE Subject = '441PMOct17'];

		RestRequest req = new RestRequest();
		RestResponse res = new RestResponse();

		CaseCommentSchema caseCommentSchemaTest = new CaseCommentSchema();
		caseCommentSchemaTest.oraclecx_id = null;
		caseCommentSchemaTest.freshdesk_id = null;
		caseCommentSchemaTest.case_id = caseTest.Id;
		caseCommentSchemaTest.comment_payload_base64 = 'VGVzdGluZyB0aGUgQ2FzZSBDb21tZW50IFdlYiBTZXJ2aWNl';

		req.addHeader('Content-Type', 	'application/json');
		req.addHeader('Accept', 		'application/json');
		req.httpMethod 			= 'POST';
		req.requestBody 		= Blob.valueOf(JSON.serialize(caseCommentSchemaTest));
		RestContext.request 	= req;
		RestContext.response 	= res;
		CaseCommentWebService.doPost();
		res = RestContext.Response;

		List<CaseComment> caseCommentsPosted 	= (List<CaseComment>) JSON.deserialize(res.responseBody.toString(), List<CaseComment>.class);
		for (CaseComment caseCommentPosted : caseCommentsPosted)
		{
			System.assert(caseCommentPosted.ParentId == caseTest.Id);
			System.assert(caseCommentPosted.CommentBody == EncodingUtil.base64Decode(caseCommentSchemaTest.comment_payload_base64).toString());
		}

		System.assert(res.headers.get('Content-Type') 	== 'application/json');
	}
}