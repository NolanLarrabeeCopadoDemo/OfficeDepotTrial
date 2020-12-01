/**
 * Created by Adam-Albright on 2/8/2018.
 */

@isTest()
public class Lead_Form_TC {

	public static Lead_Form myLeadForm = new Lead_Form();

	static String GoodInput = '[{ "employee_ID": "7463947394", "biz_Box_Services": [' +
	'"Logo_Design",' +
	'"Web_Design_Hosting"],' +
	'"first_Name": "John", "last_Name": "Abernathy", "employee_Location": "Retail Stores", ' +
	'"business_Name": "Super Biz Inc", ' +
	'"customer_State": "FL", "customer_First_Name": "Bob", "customer_Last_Name": "Awesome", "customer_Phone": "9274893623",' +
	'"contact_Time": "Afternoon", "customer_Email": "Awesome@Awesome.biz", "customer_Relationship": "Friend",' +
	'"additional_Info": "Lorem Ipsom Hallo WhoAre youn, really awesome",  "customer_Permission": true, "marketing_optin":true, '+
	' "contact_Time_frame":"Within 1-2 weeks"}]';

	static String BadInput = '[{ "employee_ID": "2342212", "biz_Box_Services": [' +
	'"Logo_Design",' +
	'"Web_Design_Hosting"],' +
	'"first_Name": "John", "last_Name": "Abernathy", ' +
	'"business_Name": "Super Biz Inc", ' +
	'"customer_State": "FL", "customer_First_Name": "Bob", "customer_Phone": "9274893623",' +
	'"contact_Time": "Afternoon", "customer_Email": "Awesome@Awesome.biz", "customer_Relationship": "Friend",' +
	'"additional_Info": "Lorem Ipsom Hallo WhoAre youn, really awesome",  "customer_Permission": true}]';

	static String NoInputJSON = '[{}]';

	static String WrongFormat = '{ "employee_ID": "2342212"}';

	static String JustID = '[{ "employee_ID": "2342212"}]';

	static String JustSomeOptional = '[{"additional_Info": "Lorem Ipsom Hallo WhoAre youn, really awesome",  "first_Name": "John"}]';



	// Test for Good Input
	@isTest()
	static void CheckForGoodInput(){
		Integer result = 0;
		Test.startTest();
		Lead_Form.Init();
		result = Lead_Form.request.Submit(GoodInput);
		Test.stopTest();
		// Do Asserts
		System.Assert(result == 0);
	}

	// Test for Invalid Input
	@isTest()
	static void CheckForBadInput(){
		Integer result = 0;
		Test.startTest();
		Lead_Form.Init();
		result = Lead_Form.request.Submit(BadInput);
		Test.stopTest();
		System.Assert(result == -1);
	}

	// Test for Invalid Input
	@isTest()
	static void CheckForEmpty(){
		Integer result = 0;
		Test.startTest();
		Lead_Form.Init();
		result = Lead_Form.request.Submit(NoInputJSON);
		Test.stopTest();
		System.Assert(result == -1);
	}

	// Test for Invalid Input with several missing fields.
	@isTest()
	static void CheckForManyMissing(){
		Integer result = 0;
		Test.startTest();
		Lead_Form.Init();
		result = Lead_Form.request.Submit(JustID);
		Test.stopTest();
		System.Assert(result == -1);
	}

	// Test for another variation of missing input.
	@isTest()
	static void CheckForManyMoreMissing(){
		Integer result = 0;
		Test.startTest();
		Lead_Form.Init();
		result = Lead_Form.request.Submit(JustSomeOptional);
		Test.stopTest();
		System.Assert(result == -1);
	}

	// Test for another variation of missing input.
	@isTest()
	static void CheckForWrongFormat(){
		Integer result = 0;
		Test.startTest();
		Lead_Form.Init();
		result = Lead_Form.request.Submit(WrongFormat);
		System.debug(LoggingLevel.ERROR, Lead_Form.request.GetErrorMessage());
		Test.stopTest();
		System.Assert(result == -1);
	}

	// Test for DB Save
	@isTest()
	static void CheckDBSubmit(){
		Integer result = 0;
		Test.startTest();
		Lead_Form.Init();
		Lead_Form.request.Submit(GoodInput);
		result = Lead_Form.request.SaveToDatabase();

		Test.stopTest();
		LeadStaging__c myLead = [SELECT id, employee_ID__c FROM LeadStaging__c WHERE employee_ID__c='7463947394' LIMIT 1];

		System.assert(myLead.employee_ID__c == '7463947394');

	}

	// Test for DB Save
	@isTest()
	static void CheckSubmitFromAura(){
		Integer result = 0;
		Test.startTest();
		Lead_Form.Init();
		Lead_Form.CreateLead(GoodInput);
		result = Lead_Form.request.GetErrorStatus();
		Test.stopTest();
		LeadStaging__c myLead = [SELECT id, employee_ID__c FROM LeadStaging__c WHERE employee_ID__c='7463947394' LIMIT 1];

		System.assert(myLead.employee_ID__c == '7463947394');

	}

	@isTest()
	static void CheckCheckStoreNumberTrue(){
		Store__c myStore = new Store__c();
		myStore.ID__c = '001234';
		insert myStore;

		Test.startTest();
		Boolean result = Lead_Form.CheckStoreNumber(myStore.ID__c);
		System.assert(result,true);

	}

	@isTest()
	static void CheckCheckStoreNumberTruePad(){
		Store__c myStore = new Store__c();
		myStore.ID__c = '001234';
		insert myStore;

		Test.startTest();
		Boolean result = Lead_Form.CheckStoreNumber('1234');
		System.assert(result,true);

	}

	@isTest()
	static void CheckCheckStoreNumberFalse(){
		Test.startTest();
		Boolean result = Lead_Form.CheckStoreNumber('test');
		System.assertEquals(result,false);
	}


	//


}