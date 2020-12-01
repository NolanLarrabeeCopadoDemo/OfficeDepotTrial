/**
 * Created by Adam-Albright on 2/6/2018.
 This class handles the inputs from lead form.
 */

public class Lead_Form {


	// TODO: Add Field Limits
	// Convert the list of JSON String objects to semicolon delimited Apex string.
	public static String ConvertStringObject(List<Object> objs) {
		String strs;
		for(Object obj: objs) {
			if(strs == null){
				strs = (String) obj;
			}else {
				strs = strs + (';' +(String) obj);
			}
		}
		return strs;
	}

	// The class for parsing and validating the json object sent from the form.
	public class LeadTools {

		// The Fields we get from the form.
		String employee_ID;	// employee_ID__c, required
		String biz_Box_Services;	// Product__c, required
		String employee_First_Name = '';	// employee_First_Name__c
		String employee_Last_Name;	// employee_Last_Name__c, required
		String employee_Location;	// employee_Location__c, required
		String customer_Business_Name;	// Company__c, required
		String customer_State;	// State__c, required
		String store_number;
		String customer_First_Name = '';	// First_Name__c
		String customer_Last_Name;	// Last_Name__c, required
		String customer_Phone;	// Phone__c, required
		String customer_Best_Contact_Time;	// Contact_Time__c, required
		String customer_Email;	// Email__c, required
		String employee_Relationship_Customer;	// Relationship__c, required
		String additional_Information = '';	// additional_Info__c
		Boolean customer_Contact_Permission;	// Contact_Permission__c, required
		Boolean Marketing_Opt_In; // Contact_Permission__c, required
		Integer ErrorStatus = 0;
		String contact_Time_frame;
		String ErrorMessage = 'No Errors detected.';
		List<String> MissingFields = new List<String>();

		// String productsAvailable = '';

		LeadStaging__c myLead = new LeadStaging__c();


		public Integer Submit(String data){

			this.employee_First_Name = '';
			this.customer_First_Name = '';
			this.additional_Information = '';

			List<Object> JsonData;
			try{
				JsonData = (List<Object>)Json.deserializeUntyped(data);
			}catch(System.TypeException e){
				this.ErrorStatus = -1;
				this.ErrorMessage = 'JSON Format problem. is your JSON formatted correctly?';
				return this.ErrorStatus;
			}

			System.debug(LoggingLevel.INFO, 'The Size is ' + ((Map<string,Object>)JsonData[0]).size());
			if (((Map<string,Object>)JsonData[0]).size() == 0) {
				this.ErrorStatus = -1;
				return this.ErrorStatus;
			}

			Map<String,Object> formDataMap = (Map<string,Object>)JsonData[0];

			if(formDataMap.get('employee_ID') == null) {
				this.ErrorStatus = -1;
				this.MissingFields.add('Employee ID');
			}
			this.employee_ID = (String) formDataMap.get('employee_ID');

			if(formDataMap.get('biz_Box_Services') != null){
				this.biz_Box_Services = ConvertStringObject((List<Object>) formDataMap.get('biz_Box_Services'));
			}else{
				this.ErrorStatus = -1;
				this.MissingFields.add('BizBox Services');
			}


			if(formDataMap.get('last_Name') == null) {
				this.ErrorStatus = -1;
				this.MissingFields.add('Employee Last Name');
			}else{
				this.employee_Last_Name = (String) formDataMap.get('last_Name');
			}


			if(formDataMap.get('employee_Location') == null) {
				this.ErrorStatus = -1;
				this.MissingFields.add('Employee Location');
			}else {
				this.employee_Location = (String) formDataMap.get('employee_Location');
			}



			if(formDataMap.get('customer_State') == null) {
				this.ErrorStatus = -1;
				this.MissingFields.add('Customer State');
			}else{
				this.customer_State = (String) formDataMap.get('customer_State');
			}


			if(formDataMap.get('customer_Last_Name') == null) {
				this.ErrorStatus = -1;
				this.MissingFields.add('Customer Last Name');
			}else{
				this.customer_Last_Name = (String) formDataMap.get('customer_Last_Name');
			}


			if(formDataMap.get('customer_Phone') == null) {
				this.ErrorStatus = -1;
				this.MissingFields.add('Customer Phone');
			}else{
				this.customer_Phone = (String) formDataMap.get('customer_Phone');
			}


			if(formDataMap.get('customer_Email') == null) {
				this.ErrorStatus = -1;
				this.MissingFields.add('Customer Email');
			}else{
				this.customer_Email = (String) formDataMap.get('customer_Email');
			}


			if(formDataMap.get('customer_Permission') == null) {
				this.ErrorStatus = -1;
				this.MissingFields.add('Customer Contact Permission');
			}else{
				this.customer_Contact_Permission = (Boolean) formDataMap.get('customer_Permission');
			}


			if(formDataMap.get('contact_Time') == null) {
				this.ErrorStatus = -1;
				this.MissingFields.add('Best Time to Contact');
			}else{
				this.customer_Best_Contact_Time = (String) formDataMap.get('contact_Time');
			}

			if(formDataMap.get('customer_Relationship') == null) {
				this.ErrorStatus = -1;
				this.MissingFields.add('Relationship To Customer');
			}else {
				this.employee_Relationship_Customer = (String) formDataMap.get('customer_Relationship');
			}

			if(formDataMap.get('marketing_optin') == null) {
				this.ErrorStatus = -1;
				this.MissingFields.add('Marketing Opt In');
			}else {
				this.Marketing_Opt_In = (Boolean) formDataMap.get('marketing_optin');
			}

			if(formDataMap.get('contact_Time_frame') == null) {
				this.ErrorStatus = -1;
				this.MissingFields.add('Contact Time Frame');
			}else {
				this.contact_Time_frame = (String) formDataMap.get('contact_Time_frame');
			}


			// Optional Values
			if(formDataMap.get('first_Name') != null){
				this.employee_First_Name = (String) formDataMap.get('first_Name');
			}
			if(formDataMap.get('customer_First_Name') != null){
				this.customer_First_Name = (String) formDataMap.get('customer_First_Name');
			}
			if(formDataMap.get('additional_Info') != null){
				this.additional_Information = (String) formDataMap.get('additional_Info');
			}

			if(formDataMap.get('business_Name') != null) {
				this.customer_Business_Name = (String) formDataMap.get('business_Name');
			}

			if(formDataMap.get('storenumber') != null)
			{
				this.store_number =(String) formDataMap.get('storenumber');
			}

			return this.ErrorStatus;
		}

		public Integer SaveToDatabase(){
			if(this.ErrorStatus != 0){
				return this.ErrorStatus;
			}

			this.myLead.employee_ID__c = this.employee_ID;
			this.myLead.Product__c = this.biz_Box_Services;
			this.myLead.employee_First_Name__c = this.employee_First_Name;
			this.myLead.employee_Last_Name__c = this.employee_Last_Name;
			this.myLead.employee_Location__c = this.employee_Location;
			this.myLead.Company__c = this.customer_Business_Name;
			this.myLead.State__c = this.customer_State;
			this.myLead.First_Name__c = this.customer_First_Name;
			this.myLead.Last_Name__c = this.customer_Last_Name;
			this.myLead.Phone__c = this.customer_Phone;
			this.myLead.Contact_Time__c = this.customer_Best_Contact_Time;
			this.myLead.Email__c = this.customer_Email;
			this.myLead.Relationship__c = this.employee_Relationship_Customer;
			this.myLead.additional_Info__c = this.additional_Information;
			this.myLead.Contact_Permission__c = this.customer_Contact_Permission;
			this.myLead.Source__c = 'Employee Referral';
			this.mylead.Marketing_Opt_In__c = this.Marketing_Opt_In;
			this.mylead.Contact_Timeframe__c = this.contact_Time_frame;
			this.myLead.Store_Number__c = this.store_number;

			Database.SaveResult sr = Database.insert(this.myLead);

			if(sr.isSuccess()) {
				return 0;
			}
			else {
				this.ErrorMessage = 'Insert to DB failed.';
				this.ErrorStatus = -2;
				return this.ErrorStatus;
			}
		}

		public Integer getErrorStatus() {
			return this.ErrorStatus;
		}

		public String GetMissingFields(){
			if(this.ErrorStatus == 0){
				return '';
			}
			String temp;
			for(String str : this.MissingFields){
				if(temp==null){
					temp=str;
					continue;
				}else {
					temp = temp + ', ' + str;
				}
			}
			return temp;
		}

		public String getErrorMessage() {
			if(this.ErrorStatus == 0) {
				return this.ErrorMessage;
			}else if(this.ErrorStatus == -1){
				return 'Init Failed, required fields missing: ' + this.GetMissingFields();
			}
			else{
				return this.ErrorMessage;
			}
		}

		public String GenerateStringResponse(){
			JSONGenerator gen = JSON.createGenerator(false);
			gen.writeStartObject();
			gen.writeNumberField('ErrorStatus', this.ErrorStatus);
			gen.writeStringField('Message', this.ErrorMessage);

			String response = '[' + gen.getAsString() + ']';

			return response;
		}

		/*public String SizeLimitedString(Integer strLimit, Object Obj) {
			String temp = (String) Obj;
			if(temp.length() <= strLimit) {
				return temp;
			}else {
				return temp.substring(0, strLimit);
			}
		} */

		/*	public String GetServices(){

				// Only get the product list if we need it.
				if(this.productsAvailable == ''){
					JSONGenerator gen = JSON.createGenerator(false);
					gen.writeStartObject();

					Schema.DescribeFieldResult bizBoxServices = Lead.Products__c.getDescribe();
					List<Schema.PicklistEntry> ple = bizBoxServices.getPicklistValues();
					System.debug(LoggingLevel.INFO, ple);
					System.debug(LoggingLevel.INFO, ple.size());
					for( Schema.PicklistEntry val : ple){
						gen.writeStringField(val.getLabel() + '_Name', val.getLabel());
					}

					this.productsAvailable = gen.getAsString();
					return this.productsAvailable;
				}

				// Otherwise, just send what we already got.
				return this.productsAvailable;
			} */


	}


	public static LeadTools request;

	@AuraEnabled
	public static String CreateLead(String data) {

		/*if(request == null) {
			return '{"Error":"Request Handler Not initialized."}';
		}*/
		request = new LeadTools();
		if (request!=null) {
			request.Submit(data);
			if(request.getErrorStatus() != -1) {
				request.SaveToDatabase();
				return request.GenerateStringResponse();
			}
		}
		System.debug(System.LoggingLevel.ERROR, 'Error ' + request.getErrorStatus() + ': ' + request.getErrorMessage());
		return request.GenerateStringResponse();

	}

	@AuraEnabled
	public static Boolean CheckStoreNumber(String iStoreNumber) {

		iStoreNumber = iStoreNumber.leftPad(6, '0');
		System.debug(iStoreNumber);
		List<Store__c> myStore = new List<Store__C>();
		myStore = [Select ID from Store__c where id__c = :iStoreNumber limit 1];
		System.debug(myStore);
		if (myStore.size() >= 1)
		{
			System.debug('Im true');
			return true;

		} else
		{
			System.debug('Im not true');
			return false;
		}
	}

	// TODO: Add employee Locations
	@AuraEnabled
	public static String Init() {
		// Going into LeadStaging__c
		request = new LeadTools();

		return '{"Status": "All Systems Go..."}';
	}
}