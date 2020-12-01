public without sharing class Customer360Service
{
	@AuraEnabled
	public static Customer360Service.processResponse_element processMethod(Map<String, Object> params)
	{
		String recordId = (String) params.get('recordId');
		String aopsCustId = (String) params.get('aopsCustId');
		String employeeId = (String) params.get('employeeId');
		Account acc;

		if (recordId != null)
		{
			acc = [SELECT Id, AOPS_Cust_ID__c FROM Account WHERE Id =:recordId];
		}
		else if (aopsCustId != null)
		{
			acc = [SELECT Id, AOPS_Cust_ID__c FROM Account WHERE AOPS_Cust_ID__c =:aopsCustId LIMIT 1];
		}

		if (acc.AOPS_Cust_ID__c == null)
		{
			return null;
		}

		try
		{
			Customer360.GetCustomerInfoBPEL_pt obj = new Customer360.GetCustomerInfoBPEL_pt();
			obj.timeout_x = 13000;
			String JSONString = JSON.serialize(obj.process(acc.AOPS_Cust_ID__c));
			Customer360Service.processResponse_element customer_data = (Customer360Service.processResponse_element) System.JSON.deserialize(JSONString, Customer360Service.processResponse_element.class);
			return customer_data;
		}
		catch (Exception e)
		{
			throw new AuraHandledException('An error occured while retrieving the customer information.');
		}
	}

	@AuraEnabled
	public static Account getGrandParent(Map<String, Object> params)
	{
		Integer MAX_ITERATIONS = 6;
		RecordType gpRecordType = [SELECT Id, Name FROM RecordType WHERE Name = 'GrandParent'];
		Account currentAccount;
		String recordId = (String) params.get('recordId');
		String aopsCustId = (String) params.get('aopsCustId');
		String employeeId = (String) params.get('employeeId');

		try
		{
			if (recordId != null)
			{
				currentAccount = [SELECT Id, AOPS_Cust_ID__c, Name, RecordTypeId, ParentId FROM Account WHERE Id =:recordId];
			}
			else if (aopsCustId != null)
			{
				currentAccount = [SELECT Id, AOPS_Cust_ID__c, Name, RecordTypeId, ParentId FROM Account WHERE AOPS_Cust_ID__c =:aopsCustId LIMIT 1];
			}
		}
		catch (QueryException ex)
		{
			return null;
		}

		for (Integer iteration = 0; iteration < MAX_ITERATIONS; iteration++)
		{
			if (currentAccount.RecordTypeId == gpRecordType.Id)
			{
				return currentAccount;
			}
			else if (currentAccount.ParentId != null)
			{
				currentAccount = [SELECT Id, AOPS_Cust_Id__c, Name, RecordTypeId, ParentId FROM Account WHERE Id =:currentAccount.ParentId];
			}
			else
			{
				break;
			}
		}

		return null;
	}

	@AuraEnabled
	public static String getRecordType(Map<String, Object> params)
	{
		String recordId = (String) params.get('recordId');
		String aopsCustId = (String) params.get('aopsCustId');
		Account acc;

		if (recordId != null)
		{
			acc = [SELECT Id, AOPS_Cust_ID__c, RecordType.DeveloperName FROM Account WHERE Id =:recordId];
		}
		else if (aopsCustId != null)
		{
			acc = [SELECT Id, AOPS_Cust_ID__c, RecordType.DeveloperName FROM Account WHERE AOPS_Cust_ID__c =:aopsCustId LIMIT 1];
		}

		return acc.RecordType.DeveloperName;
	}

	public without sharing class process_element {
		@AuraEnabled  public String CustomerNumber;
		@AuraEnabled  public String[] CustomerNumber_type_info = new String[] {'CustomerNumber',
																			   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																			   '1', '1', 'false'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'CustomerNumber'};
	}
	public without sharing class AOPSCustInstructions_element {
		@AuraEnabled  public Customer360Service.DbSelectAOPSCustInstructionsOutput_element[] DbSelectAOPSCustInstructionsOutput;
		@AuraEnabled  public String[] DbSelectAOPSCustInstructionsOutput_type_info = new String[] {'DbSelectAOPSCustInstructionsOutput',
																								   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																								   '1', '-1',
																								   'false'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true', 'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'DbSelectAOPSCustInstructionsOutput'};
	}
	public without sharing class DbSelectEbizBillTermsOutput_element {
		@AuraEnabled  public String ab_billing_flag;
		@AuraEnabled  public String payment_term;
		@AuraEnabled  public String payterm_frequency;
		@AuraEnabled  public String payterm_reporting_day;
		@AuraEnabled  public String payterm_percentage;
		@AuraEnabled  public String billdocs_doc_type;
		@AuraEnabled  public String billdocs_delivery_meth;
		@AuraEnabled  public String billdocs_special_handling;
		@AuraEnabled  public String billdocs_sig_req;
		@AuraEnabled  public String billdocs_direct_flag;
		@AuraEnabled  public String billdocs_auto_reprint;
		@AuraEnabled  public String billdocs_comments1;
		@AuraEnabled  public String billdocs_comments2;
		@AuraEnabled  public String billdocs_comments3;
		@AuraEnabled  public String billdocs_comments4;
		@AuraEnabled  public String billdocs_mail_attention;
		@AuraEnabled  public String billdocs_eff_from_date;
		@AuraEnabled  public String billdocs_eff_to_date;
		@AuraEnabled  public String location_id;
		@AuraEnabled  public String address1;
		@AuraEnabled  public String address2;
		@AuraEnabled  public String city;
		@AuraEnabled  public String postal_code;
		@AuraEnabled  public String state;
		@AuraEnabled  public String province;
		@AuraEnabled  public String county;
		@AuraEnabled  public String country;
		@AuraEnabled  public String[] ab_billing_flag_type_info = new String[] {'ab_billing_flag',
																				'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				'1', '1', 'true'};
		@AuraEnabled  public String[] payment_term_type_info = new String[] {'payment_term',
																			 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			 null, '1', '1', 'true'};
		@AuraEnabled  public String[] payterm_frequency_type_info = new String[] {'payterm_frequency',
																				  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				  '1', '1', 'true'};
		@AuraEnabled  public String[] payterm_reporting_day_type_info = new String[] {'payterm_reporting_day',
																					  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					  '1', '1', 'true'};
		@AuraEnabled  public String[] payterm_percentage_type_info = new String[] {'payterm_percentage',
																				   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				   '1', '1', 'true'};
		@AuraEnabled  public String[] billdocs_doc_type_type_info = new String[] {'billdocs_doc_type',
																				  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				  '1', '1', 'true'};
		@AuraEnabled  public String[] billdocs_delivery_meth_type_info = new String[] {'billdocs_delivery_meth',
																					   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					   '1', '1', 'true'};
		@AuraEnabled  public String[] billdocs_special_handling_type_info = new String[] {'billdocs_special_handling',
																						  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																						  '1', '1', 'true'};
		@AuraEnabled  public String[] billdocs_sig_req_type_info = new String[] {'billdocs_sig_req',
																				 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				 '1', '1', 'true'};
		@AuraEnabled  public String[] billdocs_direct_flag_type_info = new String[] {'billdocs_direct_flag',
																					 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					 '1', '1', 'true'};
		@AuraEnabled  public String[] billdocs_auto_reprint_type_info = new String[] {'billdocs_auto_reprint',
																					  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					  '1', '1', 'true'};
		@AuraEnabled  public String[] billdocs_comments1_type_info = new String[] {'billdocs_comments1',
																				   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				   '1', '1', 'true'};
		@AuraEnabled  public String[] billdocs_comments2_type_info = new String[] {'billdocs_comments2',
																				   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				   '1', '1', 'true'};
		@AuraEnabled  public String[] billdocs_comments3_type_info = new String[] {'billdocs_comments3',
																				   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				   '1', '1', 'true'};
		@AuraEnabled  public String[] billdocs_comments4_type_info = new String[] {'billdocs_comments4',
																				   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				   '1', '1', 'true'};
		@AuraEnabled  public String[] billdocs_mail_attention_type_info = new String[] {'billdocs_mail_attention',
																						'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																						'1', '1', 'true'};
		@AuraEnabled  public String[] billdocs_eff_from_date_type_info = new String[] {'billdocs_eff_from_date',
																					   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					   '1', '1', 'true'};
		@AuraEnabled  public String[] billdocs_eff_to_date_type_info = new String[] {'billdocs_eff_to_date',
																					 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					 '1', '1', 'true'};
		@AuraEnabled  public String[] location_id_type_info = new String[] {'location_id',
																			'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			null, '1', '1', 'true'};
		@AuraEnabled  public String[] address1_type_info = new String[] {'address1',
																		 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																		 '1', '1', 'true'};
		@AuraEnabled  public String[] address2_type_info = new String[] {'address2',
																		 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																		 '1', '1', 'true'};
		@AuraEnabled  public String[] city_type_info = new String[] {'city', 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																	 null, '1',
																	 '1', 'true'};
		@AuraEnabled  public String[] postal_code_type_info = new String[] {'postal_code',
																			'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			null, '1', '1', 'true'};
		@AuraEnabled  public String[] state_type_info = new String[] {'state', 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																	  null,
																	  '1', '1', 'true'};
		@AuraEnabled  public String[] province_type_info = new String[] {'province',
																		 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																		 '1', '1', 'true'};
		@AuraEnabled  public String[] county_type_info = new String[] {'county',
																	   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																	   '1', '1', 'true'};
		@AuraEnabled  public String[] country_type_info = new String[] {'country',
																		'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																		'1', '1', 'true'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'ab_billing_flag', 'payment_term', 'payterm_frequency', 'payterm_reporting_day',
																			'payterm_percentage', 'billdocs_doc_type', 'billdocs_delivery_meth',
																			'billdocs_special_handling',
																			'billdocs_sig_req', 'billdocs_direct_flag', 'billdocs_auto_reprint',
																			'billdocs_comments1',
																			'billdocs_comments2', 'billdocs_comments3', 'billdocs_comments4',
																			'billdocs_mail_attention',
																			'billdocs_eff_from_date', 'billdocs_eff_to_date', 'location_id', 'address1',
																			'address2', 'city',
																			'postal_code', 'state', 'province', 'county', 'country'};
	}
	public without sharing class AOPSCustMstrDtls_element {
		@AuraEnabled  public Customer360Service.DbSelectCustMstrDtlsOutput_element DbSelectCustMstrDtlsOutput;
	}
	public without sharing class DbSelectAOPSCustInstructionsOutput_element {
		@AuraEnabled  public String comment_code;
		@AuraEnabled  public String comment;
		@AuraEnabled  public String code_description;
		@AuraEnabled  public String[] comment_code_type_info = new String[] {'comment_code',
																			 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			 null, '1', '1', 'true'};
		@AuraEnabled  public String[] comment_type_info = new String[] {'comment',
																		'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																		'1', '1', 'true'};
		@AuraEnabled  public String[] code_description_type_info = new String[] {'code_description',
																				 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				 '1', '1', 'true'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'comment_code', 'comment', 'code_description'};
	}
	public without sharing class DbSelectEbizARCollectorOutput_element {
		@AuraEnabled  public String collector_name;
		@AuraEnabled  public String collector_emp_number;
		@AuraEnabled  public String collector_email_address;
		@AuraEnabled  public String collector_supervisor_name;
		@AuraEnabled  public String collector_supervisor_email;
		@AuraEnabled  public String collector_phone_number;
		@AuraEnabled  public String collector_fax_number;
		@AuraEnabled  public String collector_sup_phone_number;
		@AuraEnabled  public String collector_sup_fax_number;
		@AuraEnabled  public String[] collector_name_type_info = new String[] {'collector_name',
																			   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																			   '1', '1', 'true'};
		@AuraEnabled  public String[] collector_emp_number_type_info = new String[] {'collector_emp_number',
																					 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					 '1', '1', 'true'};
		@AuraEnabled  public String[] collector_email_address_type_info = new String[] {'collector_email_address',
																						'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																						'1', '1', 'true'};
		@AuraEnabled  public String[] collector_supervisor_name_type_info = new String[] {'collector_supervisor_name',
																						  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																						  '1', '1', 'true'};
		@AuraEnabled  public String[] collector_supervisor_email_type_info = new String[] {'collector_supervisor_email',
																						   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																						   '1', '1', 'true'};
		@AuraEnabled  public String[] collector_phone_number_type_info = new String[] {'collector_phone_number',
																					   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					   '1', '1', 'true'};
		@AuraEnabled  public String[] collector_fax_number_type_info = new String[] {'collector_fax_number',
																					 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					 '1', '1', 'true'};
		@AuraEnabled  public String[] collector_sup_phone_number_type_info = new String[] {'collector_sup_phone_number',
																						   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																						   '1', '1', 'true'};
		@AuraEnabled  public String[] collector_sup_fax_number_type_info = new String[] {'collector_sup_fax_number',
																						 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																						 '1', '1', 'true'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'collector_name', 'collector_emp_number', 'collector_email_address',
																			'collector_supervisor_name', 'collector_supervisor_email', 'collector_phone_number',
																			'collector_fax_number', 'collector_sup_phone_number', 'collector_sup_fax_number'};
	}
	public without sharing class DbSelectAOPSPricingOutput_element {
		@AuraEnabled  public String core_item_price_list_id;
		@AuraEnabled  public String core_item_price_list_pri_code;
		@AuraEnabled  public String core_item_price_list_desc;
		@AuraEnabled  public Date start_date;
		@AuraEnabled  public Date end_date;
		@AuraEnabled  public String[] core_item_price_list_id_type_info = new String[] {'core_item_price_list_id',
																						'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																						'1', '1', 'true'};
		@AuraEnabled  public String[] core_item_price_list_pri_code_type_info = new String[] {'core_item_price_list_pri_code',
																							  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																							  '1', '1', 'true'};
		@AuraEnabled  public String[] core_item_price_list_desc_type_info = new String[] {'core_item_price_list_desc',
																						  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																						  '1', '1', 'true'};
		@AuraEnabled  public String[] start_date_type_info = new String[] {'start_date',
																		   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		   null, '1', '1', 'true'};
		@AuraEnabled  public String[] end_date_type_info = new String[] {'end_date',
																		 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																		 '1', '1', 'true'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'core_item_price_list_id', 'core_item_price_list_pri_code',
																			'core_item_price_list_desc',
																			'start_date', 'end_date'};
	}
	public without sharing class AOPSCustPrefs_element {
		@AuraEnabled  public Customer360Service.DbCallAOPSCustPrefsOutput_element[] DbCallAOPSCustPrefsOutput;
		@AuraEnabled  public String[] DbCallAOPSCustPrefsOutput_type_info = new String[] {'DbCallAOPSCustPrefsOutput',
																						  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																						  '1', '-1',
																						  'false'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'DbCallAOPSCustPrefsOutput'};
	}
	public without sharing class ErrorMessageOutput_element {
		@AuraEnabled  public String AdapterName;
		@AuraEnabled  public String ErrorCode;
		@AuraEnabled  public String ErrorSummary;
		@AuraEnabled  public String ErrorDetails;
		@AuraEnabled  public String ErrorType;
		@AuraEnabled  public String ErrorSeverity;
		@AuraEnabled  public DateTime ErrorDate;
		@AuraEnabled  public String[] AdapterName_type_info = new String[] {'AdapterName',
																			'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			null, '0', '1', 'true'};
		@AuraEnabled  public String[] ErrorCode_type_info = new String[] {'ErrorCode',
																		  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		  null, '0', '1', 'true'};
		@AuraEnabled  public String[] ErrorSummary_type_info = new String[] {'ErrorSummary',
																			 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			 null, '0', '1', 'true'};
		@AuraEnabled  public String[] ErrorDetails_type_info = new String[] {'ErrorDetails',
																			 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			 null, '0', '1', 'true'};
		@AuraEnabled  public String[] ErrorType_type_info = new String[] {'ErrorType',
																		  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		  null, '0', '1', 'true'};
		@AuraEnabled  public String[] ErrorSeverity_type_info = new String[] {'ErrorSeverity',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '0', '1', 'true'};
		@AuraEnabled  public String[] ErrorDate_type_info = new String[] {'ErrorDate',
																		  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		  null, '0', '1', 'true'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'AdapterName', 'ErrorCode', 'ErrorSummary', 'ErrorDetails', 'ErrorType',
																			'ErrorSeverity',
																			'ErrorDate'};
	}
	public without sharing class EbizARBalances_element {
		@AuraEnabled  public Customer360Service.DbSelectEbizARBalancesOutput_element DbSelectEbizARBalancesOutput;
		@AuraEnabled  public String[] DbSelectEbizARBalancesOutput_type_info = new String[] {'DbSelectEbizARBalancesOutput',
																							 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																							 '1', '1', 'false'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'DbSelectEbizARBalancesOutput'};
	}
	public without sharing class EbizGparent_element {
		@AuraEnabled  public Customer360Service.DbSelectEbizGparentOutput_element DbSelectEbizGparentOutput;
		@AuraEnabled  public String[] DbSelectEbizGparentOutput_type_info = new String[] {'DbSelectEbizGparentOutput',
																						  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																						  '1', '1', 'false'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'DbSelectEbizGparentOutput'};
	}
	public without sharing class AOPSUniversalPricing_element {
		@AuraEnabled  public Customer360Service.DbSelectUnivPricingOutput_element[] DbSelectUnivPricingOutput;
		@AuraEnabled  public String[] DbSelectUnivPricingOutput_type_info = new String[] {'DbSelectUnivPricingOutput',
																						  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																						  '1', '-1',
																						  'false'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'DbSelectUnivPricingOutput'};
	}
	public without sharing class EbizBillTerms_element {
		@AuraEnabled  public Customer360Service.DbSelectEbizBillTermsOutput_element DbSelectEbizBillTermsOutput;
		@AuraEnabled  public String[] DbSelectEbizBillTermsOutput_type_info = new String[] {'DbSelectEbizBillTermsOutput',
																							'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																							'1', '1', 'false'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'DbSelectEbizBillTermsOutput'};
	}
	public without sharing class DbCallAOPSCustPrefsOutput_element {
		@AuraEnabled  public String code;
		@AuraEnabled  public String public_x;
		@AuraEnabled  public String value;
		@AuraEnabled  public String[] code_type_info = new String[] {'code', 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																	 null, '1',
																	 '1', 'true'};
		@AuraEnabled  public String[] public_x_type_info = new String[] {'public',
																		 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																		 '1', '1', 'true'};
		@AuraEnabled  public String[] value_type_info = new String[] {'value', 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																	  null,
																	  '1', '1', 'true'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'code', 'public_x', 'value'};
	}
	public without sharing class SelectAOPSTaxInfoOutput_element {
		@AuraEnabled  public String address_state;
		@AuraEnabled  public String country_code;
		@AuraEnabled  public String exp_date;
		@AuraEnabled  public String tax_status;
		@AuraEnabled  public String federal_exempt_flag;
		@AuraEnabled  public String tax_certif_nbr;
		@AuraEnabled  public String[] address_state_type_info = new String[] {'address_state',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] country_code_type_info = new String[] {'country_code',
																			 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			 null, '1', '1', 'true'};
		@AuraEnabled  public String[] exp_date_type_info = new String[] {'exp_date',
																		 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																		 '1', '1', 'true'};
		@AuraEnabled  public String[] tax_status_type_info = new String[] {'tax_status',
																		   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		   null, '1', '1', 'true'};
		@AuraEnabled  public String[] federal_exempt_flag_type_info = new String[] {'federal_exempt_flag',
																					'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					'1', '1', 'true'};
		@AuraEnabled  public String[] tax_certif_nbr_type_info = new String[] {'tax_certif_nbr',
																			   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																			   '1', '1', 'true'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'address_state', 'country_code', 'exp_date', 'tax_status', 'federal_exempt_flag',
																			'tax_certif_nbr'};
	}
	public without sharing class ErrorMessage_element {
		@AuraEnabled  public Customer360Service.ErrorMessageOutput_element[] ErrorMessageOutput;
		@AuraEnabled  public String[] ErrorMessageOutput_type_info = new String[] {'ErrorMessageOutput',
																				   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				   '1', '-1',
																				   'false'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'ErrorMessageOutput'};
	}
	public without sharing class EbizARCollector_element {
		@AuraEnabled  public Customer360Service.DbSelectEbizARCollectorOutput_element DbSelectEbizARCollectorOutput;
		@AuraEnabled  public String[] DbSelectEbizARCollectorOutput_type_info = new String[] {'DbSelectEbizARCollectorOutput',
																							  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																							  '1', '1', 'false'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'DbSelectEbizARCollectorOutput'};
	}
	public without sharing class DbSelectUnivPricingOutput_element {
		@AuraEnabled  public String univ_pricing_prog_code;
		@AuraEnabled  public String univ_pricing_discount;
		@AuraEnabled  public String univ_pricing_exclude;
		@AuraEnabled  public String[] univ_pricing_prog_code_type_info = new String[] {'univ_pricing_prog_code',
																					   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					   '1', '1', 'true'};
		@AuraEnabled  public String[] univ_pricing_discount_type_info = new String[] {'univ_pricing_discount',
																					  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					  '1', '1', 'true'};
		@AuraEnabled  public String[] univ_pricing_exclude_type_info = new String[] {'univ_pricing_exclude',
																					 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					 '1', '1', 'true'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'univ_pricing_prog_code', 'univ_pricing_discount', 'univ_pricing_exclude'};
	}
	public without sharing class DbSelectAOPSCustVhclsOutput_element {
		@AuraEnabled  public String vhcl_code;
		@AuraEnabled  public String vhcl_desc;
		@AuraEnabled  public String[] vhcl_code_type_info = new String[] {'vhcl_code',
																		  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		  null, '1', '1', 'true'};
		@AuraEnabled  public String[] vhcl_desc_type_info = new String[] {'vhcl_desc',
																		  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		  null, '1', '1', 'true'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'vhcl_code', 'vhcl_desc'};
	}
	public without sharing class DbSelectCustMstrDtlsOutput_element {
		@AuraEnabled  public String business_name;
		@AuraEnabled  public String street_address1;
		@AuraEnabled  public String street_address2;
		@AuraEnabled  public String city;
		@AuraEnabled  public String state;
		@AuraEnabled  public String province;
		@AuraEnabled  public String zip;
		@AuraEnabled  public String country_code;
		@AuraEnabled  public String tax_geo_code;
		@AuraEnabled  public String addl_addr_ind;
		@AuraEnabled  public String cust_comm_ind;
		@AuraEnabled  public String addr_comm_ind;
		@AuraEnabled  public String deliver_charge_code;
		@AuraEnabled  public String furn_dlvry_fee;
		@AuraEnabled  public String minimum_order_value;
		@AuraEnabled  public String freight_chg_req_flag;
		@AuraEnabled  public String tax_exempt_type;
		@AuraEnabled  public String tax_certif_ind;
		@AuraEnabled  public String duns_nbr;
		@AuraEnabled  public String credit_ind;
		@AuraEnabled  public String cust_type;
		@AuraEnabled  public String cont_retail_code;
		@AuraEnabled  public String po_ind;
		@AuraEnabled  public String brand;
		@AuraEnabled  public String less_mail_flag;
		@AuraEnabled  public String reporting_loc;
		@AuraEnabled  public String salesperson_id;
		@AuraEnabled  public String salesperson_name;
		@AuraEnabled  public String reporting_ind;
		@AuraEnabled  public String buying_group_ind;
		@AuraEnabled  public String backorder_allow_flag;
		@AuraEnabled  public String po_required_code;
		@AuraEnabled  public String release_required_code;
		@AuraEnabled  public String location_req_code;
		@AuraEnabled  public String ship_to_required_code;
		@AuraEnabled  public String location_ind;
		@AuraEnabled  public String department_ind;
		@AuraEnabled  public String release_ind;
		@AuraEnabled  public String field_header_ind;
		@AuraEnabled  public String rebate_ind;
		@AuraEnabled  public String signature_req;
		@AuraEnabled  public String customer_comm;
		@AuraEnabled  public String contract_code;
		@AuraEnabled  public String price_plan;
		@AuraEnabled  public String price_plan_seq;
		@AuraEnabled  public String price_plan_descr;
		@AuraEnabled  public String off_contract_price_code;
		@AuraEnabled  public String off_contrat_prct;
		@AuraEnabled  public String wholesaler_price_code;
		@AuraEnabled  public String wholesaler_price_discount_prct;
		@AuraEnabled  public String minimum_discount;
		@AuraEnabled  public String gp_floor;
		@AuraEnabled  public String cost_code;
		@AuraEnabled  public String substitute_allowed;
		@AuraEnabled  public String fax_ship_confirmation;
		@AuraEnabled  public String fax_po_code;
		@AuraEnabled  public String fax_reorder_code;
		@AuraEnabled  public String fax_inv_code;
		@AuraEnabled  public String commission_flag;
		@AuraEnabled  public String take_back_flag;
		@AuraEnabled  public string product_xref_nbr;
		@AuraEnabled  public String rest_key_code;
		@AuraEnabled  public String reporting_contact;
		@AuraEnabled  public String order_rest_ind;
		@AuraEnabled  public String dept_required_code;
		@AuraEnabled  public String spc_services_flag;
		@AuraEnabled  public String ar_flag;
		@AuraEnabled  public String hedberg_flag;
		@AuraEnabled  public String registered_on_time;
		@AuraEnabled  public String addl_salesperson_ind;
		@AuraEnabled  public String report_dist_flag;
		@AuraEnabled  public String cust_legal_agreement_flag;
		@AuraEnabled  public String parent_name;
		@AuraEnabled  public Date createdate;
		@AuraEnabled  public String status;
		@AuraEnabled  public String sic_code;
		@AuraEnabled  public String segmentation;
		@AuraEnabled  public String sector;
		@AuraEnabled  public String cust_comment1;
		@AuraEnabled  public String cust_comment2;
		@AuraEnabled  public String cust_comment3;
		@AuraEnabled  public Date comments_createdate;
		@AuraEnabled  public String customer_id;
		@AuraEnabled  public String parent_id;
		@AuraEnabled  public String prmry_cntct_salutation;
		@AuraEnabled  public String prmry_cntct_fname;
		@AuraEnabled  public String prmry_cntct_lname;
		@AuraEnabled  public String prmry_phn_ctry_cd;
		@AuraEnabled  public String prmry_phn_area_cd;
		@AuraEnabled  public String prmry_phn_pfx;
		@AuraEnabled  public String prmry_phn_nbr;
		@AuraEnabled  public String prmry_phn_ext;
		@AuraEnabled  public String prmry_cntct_auth_buyer;
		@AuraEnabled  public String hold_retrn_ind;
		@AuraEnabled  public String allow_prnt_on_dmnd;
		@AuraEnabled  public String tech_block;
		@AuraEnabled  public String line_limit;
		@AuraEnabled  public String order_limit;
		@AuraEnabled  public String pricing_tier;
		@AuraEnabled  public String bsdfin_block;
		@AuraEnabled  public String pro_cards;
		@AuraEnabled  public String spc_cards;
		@AuraEnabled  public String[] business_name_type_info = new String[] {'business_name',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] street_address1_type_info = new String[] {'street_address1',
																				'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				'1', '1', 'true'};
		@AuraEnabled  public String[] street_address2_type_info = new String[] {'street_address2',
																				'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				'1', '1', 'true'};
		@AuraEnabled  public String[] city_type_info = new String[] {'city', 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																	 null, '1',
																	 '1', 'true'};
		@AuraEnabled  public String[] state_type_info = new String[] {'state', 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																	  null,
																	  '1', '1', 'true'};
		@AuraEnabled  public String[] province_type_info = new String[] {'province',
																		 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																		 '1', '1', 'true'};
		@AuraEnabled  public String[] zip_type_info = new String[] {'zip', 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																	null, '1',
																	'1', 'true'};
		@AuraEnabled  public String[] country_code_type_info = new String[] {'country_code',
																			 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			 null, '1', '1', 'true'};
		@AuraEnabled  public String[] tax_geo_code_type_info = new String[] {'tax_geo_code',
																			 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			 null, '1', '1', 'true'};
		@AuraEnabled  public String[] addl_addr_ind_type_info = new String[] {'addl_addr_ind',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] cust_comm_ind_type_info = new String[] {'cust_comm_ind',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] addr_comm_ind_type_info = new String[] {'addr_comm_ind',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] deliver_charge_code_type_info = new String[] {'deliver_charge_code',
																					'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					'1', '1', 'true'};
		@AuraEnabled  public String[] furn_dlvry_fee_type_info = new String[] {'furn_dlvry_fee',
																			   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																			   '1', '1', 'true'};
		@AuraEnabled  public String[] minimum_order_value_type_info = new String[] {'minimum_order_value',
																					'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					'1', '1', 'true'};
		@AuraEnabled  public String[] freight_chg_req_flag_type_info = new String[] {'freight_chg_req_flag',
																					 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					 '1', '1', 'true'};
		@AuraEnabled  public String[] tax_exempt_type_type_info = new String[] {'tax_exempt_type',
																				'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				'1', '1', 'true'};
		@AuraEnabled  public String[] tax_certif_ind_type_info = new String[] {'tax_certif_ind',
																			   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																			   '1', '1', 'true'};
		@AuraEnabled  public String[] duns_nbr_type_info = new String[] {'duns_nbr',
																		 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																		 '1', '1', 'true'};
		@AuraEnabled  public String[] credit_ind_type_info = new String[] {'credit_ind',
																		   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		   null, '1', '1', 'true'};
		@AuraEnabled  public String[] cust_type_type_info = new String[] {'cust_type',
																		  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		  null, '1', '1', 'true'};
		@AuraEnabled  public String[] cont_retail_code_type_info = new String[] {'cont_retail_code',
																				 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				 '1', '1', 'true'};
		@AuraEnabled  public String[] po_ind_type_info = new String[] {'po_ind',
																	   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																	   '1', '1', 'true'};
		@AuraEnabled  public String[] brand_type_info = new String[] {'brand', 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																	  null,
																	  '1', '1', 'true'};
		@AuraEnabled  public String[] less_mail_flag_type_info = new String[] {'less_mail_flag',
																			   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																			   '1', '1', 'true'};
		@AuraEnabled  public String[] reporting_loc_type_info = new String[] {'reporting_loc',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] salesperson_id_type_info = new String[] {'salesperson_id',
																			   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																			   '1', '1', 'true'};
		@AuraEnabled  public String[] salesperson_name_type_info = new String[] {'salesperson_name',
																				 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				 '1', '1', 'true'};
		@AuraEnabled  public String[] reporting_ind_type_info = new String[] {'reporting_ind',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] buying_group_ind_type_info = new String[] {'buying_group_ind',
																				 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				 '1', '1', 'true'};
		@AuraEnabled  public String[] backorder_allow_flag_type_info = new String[] {'backorder_allow_flag',
																					 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					 '1', '1', 'true'};
		@AuraEnabled  public String[] po_required_code_type_info = new String[] {'po_required_code',
																				 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				 '1', '1', 'true'};
		@AuraEnabled  public String[] release_required_code_type_info = new String[] {'release_required_code',
																					  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					  '1', '1', 'true'};
		@AuraEnabled  public String[] location_req_code_type_info = new String[] {'location_req_code',
																				  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				  '1', '1', 'true'};
		@AuraEnabled  public String[] ship_to_required_code_type_info = new String[] {'ship_to_required_code',
																					  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					  '1', '1', 'true'};
		@AuraEnabled  public String[] location_ind_type_info = new String[] {'location_ind',
																			 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			 null, '1', '1', 'true'};
		@AuraEnabled  public String[] department_ind_type_info = new String[] {'department_ind',
																			   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																			   '1', '1', 'true'};
		@AuraEnabled  public String[] release_ind_type_info = new String[] {'release_ind',
																			'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			null, '1', '1', 'true'};
		@AuraEnabled  public String[] field_header_ind_type_info = new String[] {'field_header_ind',
																				 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				 '1', '1', 'true'};
		@AuraEnabled  public String[] rebate_ind_type_info = new String[] {'rebate_ind',
																		   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		   null, '1', '1', 'true'};
		@AuraEnabled  public String[] signature_req_type_info = new String[] {'signature_req',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] customer_comm_type_info = new String[] {'customer_comm',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] contract_code_type_info = new String[] {'contract_code',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] price_plan_type_info = new String[] {'price_plan',
																		   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		   null, '1', '1', 'true'};
		@AuraEnabled  public String[] price_plan_seq_type_info = new String[] {'price_plan_seq',
																			   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																			   '1', '1', 'true'};
		@AuraEnabled  public String[] price_plan_descr_type_info = new String[] {'price_plan_descr',
																				 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				 '1', '1', 'true'};
		@AuraEnabled  public String[] off_contract_price_code_type_info = new String[] {'off_contract_price_code',
																						'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																						'1', '1', 'true'};
		@AuraEnabled  public String[] off_contrat_prct_type_info = new String[] {'off_contrat_prct',
																				 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				 '1', '1', 'true'};
		@AuraEnabled  public String[] wholesaler_price_code_type_info = new String[] {'wholesaler_price_code',
																					  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					  '1', '1', 'true'};
		@AuraEnabled  public String[] wholesaler_price_discount_prct_type_info = new String[] {'wholesaler_price_discount_prct',
																							   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																							   '1', '1', 'true'};
		@AuraEnabled  public String[] minimum_discount_type_info = new String[] {'minimum_discount',
																				 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				 '1', '1', 'true'};
		@AuraEnabled  public String[] gp_floor_type_info = new String[] {'gp_floor',
																		 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																		 '1', '1', 'true'};
		@AuraEnabled  public String[] cost_code_type_info = new String[] {'cost_code',
																		  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		  null, '1', '1', 'true'};
		@AuraEnabled  public String[] substitute_allowed_type_info = new String[] {'substitute_allowed',
																				   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				   '1', '1', 'true'};
		@AuraEnabled  public String[] fax_ship_confirmation_type_info = new String[] {'fax_ship_confirmation',
																					  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					  '1', '1', 'true'};
		@AuraEnabled  public String[] fax_po_code_type_info = new String[] {'fax_po_code',
																			'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			null, '1', '1', 'true'};
		@AuraEnabled  public String[] fax_reorder_code_type_info = new String[] {'fax_reorder_code',
																				 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				 '1', '1', 'true'};
		@AuraEnabled  public String[] fax_inv_code_type_info = new String[] {'fax_inv_code',
																			 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			 null, '1', '1', 'true'};
		@AuraEnabled  public String[] commission_flag_type_info = new String[] {'commission_flag',
																				'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				'1', '1', 'true'};
		@AuraEnabled  public String[] take_back_flag_type_info = new String[] {'take_back_flag',
																			   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																			   '1', '1', 'true'};
		@AuraEnabled  public String[] product_xref_nbr_type_info = new String[] {'product_xref_nbr',
																				 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				 '1', '1', 'true'};
		@AuraEnabled  public String[] rest_key_code_type_info = new String[] {'rest_key_code',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] reporting_contact_type_info = new String[] {'reporting_contact',
																				  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				  '1', '1', 'true'};
		@AuraEnabled  public String[] order_rest_ind_type_info = new String[] {'order_rest_ind',
																			   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																			   '1', '1', 'true'};
		@AuraEnabled  public String[] dept_required_code_type_info = new String[] {'dept_required_code',
																				   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				   '1', '1', 'true'};
		@AuraEnabled  public String[] spc_services_flag_type_info = new String[] {'spc_services_flag',
																				  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				  '1', '1', 'true'};
		@AuraEnabled  public String[] ar_flag_type_info = new String[] {'ar_flag',
																		'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																		'1', '1', 'true'};
		@AuraEnabled  public String[] hedberg_flag_type_info = new String[] {'hedberg_flag',
																			 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			 null, '1', '1', 'true'};
		@AuraEnabled  public String[] registered_on_time_type_info = new String[] {'registered_on_time',
																				   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				   '1', '1', 'true'};
		@AuraEnabled  public String[] addl_salesperson_ind_type_info = new String[] {'addl_salesperson_ind',
																					 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					 '1', '1', 'true'};
		@AuraEnabled  public String[] report_dist_flag_type_info = new String[] {'report_dist_flag',
																				 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				 '1', '1', 'true'};
		@AuraEnabled  public String[] cust_legal_agreement_flag_type_info = new String[] {'cust_legal_agreement_flag',
																						  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																						  '1', '1', 'true'};
		@AuraEnabled  public String[] parent_name_type_info = new String[] {'parent_name',
																			'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			null, '1', '1', 'true'};
		@AuraEnabled  public String[] createdate_type_info = new String[] {'createdate',
																		   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		   null, '1', '1', 'true'};
		@AuraEnabled  public String[] status_type_info = new String[] {'status',
																	   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																	   '1', '1', 'true'};
		@AuraEnabled  public String[] sic_code_type_info = new String[] {'sic_code',
																		 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																		 '1', '1', 'true'};
		@AuraEnabled  public String[] segmentation_type_info = new String[] {'segmentation',
																			 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			 null, '1', '1', 'true'};
		@AuraEnabled  public String[] sector_type_info = new String[] {'sector',
																	   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																	   '1', '1', 'true'};
		@AuraEnabled  public String[] cust_comment1_type_info = new String[] {'cust_comment1',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] cust_comment2_type_info = new String[] {'cust_comment2',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] cust_comment3_type_info = new String[] {'cust_comment3',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] comments_createdate_type_info = new String[] {'comments_createdate',
																					'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					'1', '1', 'true'};
		@AuraEnabled  public String[] customer_id_type_info = new String[] {'customer_id',
																			'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			null, '1', '1', 'true'};
		@AuraEnabled  public String[] parent_id_type_info = new String[] {'parent_id',
																		  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		  null, '1', '1', 'true'};
		@AuraEnabled  public String[] prmry_cntct_salutation_type_info = new String[] {'prmry_cntct_salutation',
																					   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					   '1', '1', 'true'};
		@AuraEnabled  public String[] prmry_cntct_fname_type_info = new String[] {'prmry_cntct_fname',
																				  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				  '1', '1', 'true'};
		@AuraEnabled  public String[] prmry_cntct_lname_type_info = new String[] {'prmry_cntct_lname',
																				  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				  '1', '1', 'true'};
		@AuraEnabled  public String[] prmry_phn_ctry_cd_type_info = new String[] {'prmry_phn_ctry_cd',
																				  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				  '1', '1', 'true'};
		@AuraEnabled  public String[] prmry_phn_area_cd_type_info = new String[] {'prmry_phn_area_cd',
																				  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				  '1', '1', 'true'};
		@AuraEnabled  public String[] prmry_phn_pfx_type_info = new String[] {'prmry_phn_pfx',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] prmry_phn_nbr_type_info = new String[] {'prmry_phn_nbr',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] prmry_phn_ext_type_info = new String[] {'prmry_phn_ext',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] prmry_cntct_auth_buyer_type_info = new String[] {'prmry_cntct_auth_buyer',
																					   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					   '1', '1', 'true'};
		@AuraEnabled  public String[] hold_retrn_ind_type_info = new String[] {'hold_retrn_ind',
																			   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																			   '1', '1', 'true'};
		@AuraEnabled  public String[] allow_prnt_on_dmnd_type_info = new String[] {'allow_prnt_on_dmnd',
																				   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				   '1', '1', 'true'};
		@AuraEnabled  public String[] tech_block_type_info = new String[] {'tech_block',
																		   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		   null, '1', '1', 'true'};
		@AuraEnabled  public String[] line_limit_type_info = new String[] {'line_limit',
																		   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		   null, '1', '1', 'true'};
		@AuraEnabled  public String[] order_limit_type_info = new String[] {'order_limit',
																			'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			null, '1', '1', 'true'};
		@AuraEnabled  public String[] pricing_tier_type_info = new String[] {'pricing_tier',
																			 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			 null, '1', '1', 'true'};
		@AuraEnabled  public String[] bsdfin_block_type_info = new String[] {'bsdfin_block',
																			 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			 null, '1', '1', 'true'};
		@AuraEnabled  public String[] pro_cards_type_info = new String[] {'pro_cards',
																		  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		  null, '1', '1', 'true'};
		@AuraEnabled  public String[] spc_cards_type_info = new String[] {'spc_cards',
																		  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		  null, '1', '1', 'true'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'business_name', 'street_address1', 'street_address2', 'city', 'state', 'province',
																			'zip',
																			'country_code', 'tax_geo_code', 'addl_addr_ind', 'cust_comm_ind', 'addr_comm_ind',
																			'deliver_charge_code', 'furn_dlvry_fee', 'minimum_order_value',
																			'freight_chg_req_flag',
																			'tax_exempt_type', 'tax_certif_ind', 'duns_nbr', 'credit_ind', 'cust_type',
																			'cont_retail_code',
																			'po_ind', 'brand', 'less_mail_flag', 'reporting_loc', 'salesperson_id',
																			'salesperson_name',
																			'reporting_ind', 'buying_group_ind', 'backorder_allow_flag', 'po_required_code',
																			'release_required_code', 'location_req_code', 'ship_to_required_code',
																			'location_ind',
																			'department_ind', 'release_ind', 'field_header_ind', 'rebate_ind', 'signature_req',
																			'customer_comm',
																			'contract_code', 'price_plan', 'price_plan_seq', 'price_plan_descr',
																			'off_contract_price_code',
																			'off_contrat_prct', 'wholesaler_price_code', 'wholesaler_price_discount_prct',
																			'minimum_discount',
																			'gp_floor', 'cost_code', 'substitute_allowed', 'fax_ship_confirmation', 'fax_po_code',
																			'fax_reorder_code', 'fax_inv_code', 'commission_flag', 'take_back_flag',
																			'product_xref_nbr',
																			'rest_key_code', 'reporting_contact', 'order_rest_ind', 'dept_required_code',
																			'spc_services_flag',
																			'ar_flag', 'hedberg_flag', 'registered_on_time', 'addl_salesperson_ind',
																			'report_dist_flag',
																			'cust_legal_agreement_flag', 'parent_name', 'createdate', 'status', 'sic_code',
																			'segmentation',
																			'sector', 'cust_comment1', 'cust_comment2', 'cust_comment3', 'comments_createdate',
																			'customer_id',
																			'parent_id', 'prmry_cntct_salutation', 'prmry_cntct_fname', 'prmry_cntct_lname',
																			'prmry_phn_ctry_cd', 'prmry_phn_area_cd', 'prmry_phn_pfx', 'prmry_phn_nbr',
																			'prmry_phn_ext',
																			'prmry_cntct_auth_buyer', 'hold_retrn_ind', 'allow_prnt_on_dmnd', 'tech_block',
																			'line_limit',
																			'order_limit', 'pricing_tier', 'bsdfin_block', 'pro_cards', 'spc_cards'};
	}
	public without sharing class DbSelectAOPSCustTierDiscOutput_element {
		@AuraEnabled  public String from_amt;
		@AuraEnabled  public String to_amt;
		@AuraEnabled  public String percent_disc;
		@AuraEnabled  public String[] from_amt_type_info = new String[] {'from_amt',
																		 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																		 '1', '1', 'true'};
		@AuraEnabled  public String[] to_amt_type_info = new String[] {'to_amt',
																	   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																	   '1', '1', 'true'};
		@AuraEnabled  public String[] percent_disc_type_info = new String[] {'percent_disc',
																			 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			 null, '1', '1', 'true'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'from_amt', 'to_amt', 'percent_disc'};
	}
	public without sharing class EbizBillContacts_element {
		@AuraEnabled  public Customer360Service.DbSelectEbizBillContactsOutput_element[] DbSelectEbizBillContactsOutput;
		@AuraEnabled  public String[] DbSelectEbizBillContactsOutput_type_info = new String[] {'DbSelectEbizBillContactsOutput',
																							   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																							   '1', '-1',
																							   'false'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'DbSelectEbizBillContactsOutput'};
	}
	public without sharing class AOPSTaxInfo_element {
		@AuraEnabled  public Customer360Service.SelectAOPSTaxInfoOutput_element[] SelectAOPSTaxInfoOutput;
		@AuraEnabled  public String[] SelectAOPSTaxInfoOutput_type_info = new String[] {'SelectAOPSTaxInfoOutput',
																						'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																						'1', '-1',
																						'false'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'SelectAOPSTaxInfoOutput'};
	}
	public without sharing class AOPSCustTierDisc_element {
		@AuraEnabled  public Customer360Service.DbSelectAOPSCustTierDiscOutput_element[] DbSelectAOPSCustTierDiscOutput;
		@AuraEnabled  public String[] DbSelectAOPSCustTierDiscOutput_type_info = new String[] {'DbSelectAOPSCustTierDiscOutput',
																							   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																							   '1', '-1',
																							   'false'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'DbSelectAOPSCustTierDiscOutput'};
	}
	public without sharing class EbizCreditLimits_element {
		@AuraEnabled  public Customer360Service.DbSelectEbizCreditLimitsOutput_element[] DbSelectEbizCreditLimitsOutput;
		@AuraEnabled  public String[] DbSelectEbizCreditLimitsOutput_type_info = new String[] {'DbSelectEbizCreditLimitsOutput',
																							   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																							   '1', '-1',
																							   'false'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'DbSelectEbizCreditLimitsOutput'};
	}
	public without sharing class DbSelectEbizGparentOutput_element {
		@AuraEnabled  public String gp_id;
		@AuraEnabled  public String gp_name;
		@AuraEnabled  public String[] gp_id_type_info = new String[] {'gp_id', 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																	  null,
																	  '1', '1', 'true'};
		@AuraEnabled  public String[] gp_name_type_info = new String[] {'gp_name',
																		'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																		'1', '1', 'true'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'gp_id', 'gp_name'};
	}
	public without sharing class AOPSCorePricing_element {
		@AuraEnabled  public Customer360Service.DbSelectAOPSPricingOutput_element[] DbSelectAOPSPricingOutput;
		//@AuraEnabled  public String[] DbSelectAOPSPricingOutput_type_info = new String[]{'DbSelectAOPSPricingOutput','http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',null,'1','-1','false'};
		//@AuraEnabled  public String[] apex_schema_type_info = new String[]{'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL','true','false'};
		//@AuraEnabled  public String[] field_order_type_info = new String[]{'DbSelectAOPSPricingOutput'};
	}
	public without sharing class DbSelectEbizBillContactsOutput_element {
		@AuraEnabled  public String resp_type;
		@AuraEnabled  public String contact_point_id;
		@AuraEnabled  public String salutation;
		@AuraEnabled  public String party_id;
		@AuraEnabled  public String first_name;
		@AuraEnabled  public String last_name;
		@AuraEnabled  public String job_title;
		@AuraEnabled  public String contact_point_type;
		@AuraEnabled  public String email_address;
		@AuraEnabled  public String phone_ln_type;
		@AuraEnabled  public String phone_ln_type_desc;
		@AuraEnabled  public String phone_country_code;
		@AuraEnabled  public String phone_area_code;
		@AuraEnabled  public String phone_number;
		@AuraEnabled  public String extension;
		@AuraEnabled  public String primary_contact_point;
		@AuraEnabled  public String preferred_flag;
		@AuraEnabled  public String[] resp_type_type_info = new String[] {'resp_type',
																		  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		  null, '1', '1', 'true'};
		@AuraEnabled  public String[] contact_point_id_type_info = new String[] {'contact_point_id',
																				 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				 '1', '1', 'true'};
		@AuraEnabled  public String[] salutation_type_info = new String[] {'salutation',
																		   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		   null, '1', '1', 'true'};
		@AuraEnabled  public String[] party_id_type_info = new String[] {'party_id',
																		 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																		 '1', '1', 'true'};
		@AuraEnabled  public String[] first_name_type_info = new String[] {'first_name',
																		   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		   null, '1', '1', 'true'};
		@AuraEnabled  public String[] last_name_type_info = new String[] {'last_name',
																		  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		  null, '1', '1', 'true'};
		@AuraEnabled  public String[] job_title_type_info = new String[] {'job_title',
																		  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		  null, '1', '1', 'true'};
		@AuraEnabled  public String[] contact_point_type_type_info = new String[] {'contact_point_type',
																				   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				   '1', '1', 'true'};
		@AuraEnabled  public String[] email_address_type_info = new String[] {'email_address',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] phone_ln_type_type_info = new String[] {'phone_ln_type',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] phone_ln_type_desc_type_info = new String[] {'phone_ln_type_desc',
																				   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				   '1', '1', 'true'};
		@AuraEnabled  public String[] phone_country_code_type_info = new String[] {'phone_country_code',
																				   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				   '1', '1', 'true'};
		@AuraEnabled  public String[] phone_area_code_type_info = new String[] {'phone_area_code',
																				'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				'1', '1', 'true'};
		@AuraEnabled  public String[] phone_number_type_info = new String[] {'phone_number',
																			 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			 null, '1', '1', 'true'};
		@AuraEnabled  public String[] extension_type_info = new String[] {'extension',
																		  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		  null, '1', '1', 'true'};
		@AuraEnabled  public String[] primary_contact_point_type_info = new String[] {'primary_contact_point',
																					  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					  '1', '1', 'true'};
		@AuraEnabled  public String[] preferred_flag_type_info = new String[] {'preferred_flag',
																			   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																			   '1', '1', 'true'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'resp_type', 'contact_point_id', 'salutation', 'party_id', 'first_name', 'last_name',
																			'job_title', 'contact_point_type', 'email_address', 'phone_ln_type',
																			'phone_ln_type_desc',
																			'phone_country_code', 'phone_area_code', 'phone_number', 'extension',
																			'primary_contact_point',
																			'preferred_flag'};
	}
	public without sharing class DbSelectEbizARBalancesOutput_element {
		@AuraEnabled  public String current_bal;
		@AuraEnabled  public String Days_1_30;
		@AuraEnabled  public String Days_31_60;
		@AuraEnabled  public String Days_61_90;
		@AuraEnabled  public String Days_91_180;
		@AuraEnabled  public String Days_181_365;
		@AuraEnabled  public String Days_366_plus;
		@AuraEnabled  public String[] current_bal_type_info = new String[] {'current_bal',
																			'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			null, '1', '1', 'true'};
		@AuraEnabled  public String[] Days_1_30_type_info = new String[] {'Days_1_30',
																		  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		  null, '1', '1', 'true'};
		@AuraEnabled  public String[] Days_31_60_type_info = new String[] {'Days_31_60',
																		   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		   null, '1', '1', 'true'};
		@AuraEnabled  public String[] Days_61_90_type_info = new String[] {'Days_61_90',
																		   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																		   null, '1', '1', 'true'};
		@AuraEnabled  public String[] Days_91_180_type_info = new String[] {'Days_91_180',
																			'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			null, '1', '1', 'true'};
		@AuraEnabled  public String[] Days_181_365_type_info = new String[] {'Days_181_365',
																			 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			 null, '1', '1', 'true'};
		@AuraEnabled  public String[] Days_366_plus_type_info = new String[] {'Days_366_plus',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'current_bal', 'Days_1_30', 'Days_31_60', 'Days_61_90', 'Days_91_180', 'Days_181_365',
																			'Days_366_plus'};
	}
	public without sharing class DbSelectEbizCreditLimitsOutput_element {
		@AuraEnabled  public String currency_code;
		@AuraEnabled  public String overall_credit_limit;
		@AuraEnabled  public String trx_credit_limit;
		@AuraEnabled  public String[] currency_code_type_info = new String[] {'currency_code',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'true'};
		@AuraEnabled  public String[] overall_credit_limit_type_info = new String[] {'overall_credit_limit',
																					 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					 '1', '1', 'true'};
		@AuraEnabled  public String[] trx_credit_limit_type_info = new String[] {'trx_credit_limit',
																				 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				 '1', '1', 'true'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'currency_code', 'overall_credit_limit', 'trx_credit_limit'};
	}
	public without sharing class AOPSCustVhcls_element {
		@AuraEnabled  public Customer360Service.DbSelectAOPSCustVhclsOutput_element[] DbSelectAOPSCustVhclsOutput;
		@AuraEnabled  public String[] DbSelectAOPSCustVhclsOutput_type_info = new String[] {'DbSelectAOPSCustVhclsOutput',
																							'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																							'1', '-1',
																							'false'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'DbSelectAOPSCustVhclsOutput'};
	}
	public without sharing class processResponse_element {
		@AuraEnabled  public String customer_name;
		@AuraEnabled  public Customer360Service.ErrorMessage_element ErrorMessage;
		@AuraEnabled  public Customer360Service.AOPSTaxInfo_element AOPSTaxInfo;
		@AuraEnabled  public Customer360Service.AOPSCustMstrDtls_element AOPSCustMstrDtls;
		@AuraEnabled  public Customer360Service.AOPSCorePricing_element AOPSCorePricing;
		@AuraEnabled  public Customer360Service.AOPSUniversalPricing_element AOPSUniversalPricing;
		@AuraEnabled  public Customer360Service.AOPSCustInstructions_element AOPSCustInstructions;
		@AuraEnabled  public Customer360Service.EbizBillContacts_element EbizBillContacts;
		@AuraEnabled  public Customer360Service.EbizARBalances_element EbizARBalances;
		@AuraEnabled  public Customer360Service.EbizARCollector_element EbizARCollector;
		@AuraEnabled  public Customer360Service.EbizCreditLimits_element EbizCreditLimits;
		@AuraEnabled  public Customer360Service.EbizBillTerms_element EbizBillTerms;
		@AuraEnabled  public Customer360Service.AOPSCustVhcls_element AOPSCustVhcls;
		@AuraEnabled  public Customer360Service.AOPSCustTierDisc_element AOPSCustTierDisc;
		@AuraEnabled  public Customer360Service.AOPSCustPrefs_element AOPSCustPrefs;
		@AuraEnabled  public Customer360Service.EbizGparent_element EbizGparent;
		@AuraEnabled  public String[] customer_name_type_info = new String[] {'customer_name',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '0', '1', 'false'};
		@AuraEnabled  public String[] ErrorMessage_type_info = new String[] {'ErrorMessage',
																			 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			 null, '0', '1', 'false'};
		@AuraEnabled  public String[] AOPSTaxInfo_type_info = new String[] {'AOPSTaxInfo',
																			'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			null, '0', '1', 'false'};
		@AuraEnabled  public String[] AOPSCustMstrDtls_type_info = new String[] {'AOPSCustMstrDtls',
																				 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				 '0', '1', 'false'};
		@AuraEnabled  public String[] AOPSCorePricing_type_info = new String[] {'AOPSCorePricing',
																				'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				'1', '1', 'false'};
		@AuraEnabled  public String[] AOPSUniversalPricing_type_info = new String[] {'AOPSUniversalPricing',
																					 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					 '1', '1', 'false'};
		@AuraEnabled  public String[] AOPSCustInstructions_type_info = new String[] {'AOPSCustInstructions',
																					 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																					 '1', '1', 'false'};
		@AuraEnabled  public String[] EbizBillContacts_type_info = new String[] {'EbizBillContacts',
																				 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				 '1', '1', 'false'};
		@AuraEnabled  public String[] EbizARBalances_type_info = new String[] {'EbizARBalances',
																			   'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																			   '1', '1', 'false'};
		@AuraEnabled  public String[] EbizARCollector_type_info = new String[] {'EbizARCollector',
																				'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				'1', '1', 'false'};
		@AuraEnabled  public String[] EbizCreditLimits_type_info = new String[] {'EbizCreditLimits',
																				 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				 '1', '1', 'false'};
		@AuraEnabled  public String[] EbizBillTerms_type_info = new String[] {'EbizBillTerms',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'false'};
		@AuraEnabled  public String[] AOPSCustVhcls_type_info = new String[] {'AOPSCustVhcls',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'false'};
		@AuraEnabled  public String[] AOPSCustTierDisc_type_info = new String[] {'AOPSCustTierDisc',
																				 'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', null,
																				 '1', '1', 'false'};
		@AuraEnabled  public String[] AOPSCustPrefs_type_info = new String[] {'AOPSCustPrefs',
																			  'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			  null, '1', '1', 'false'};
		@AuraEnabled  public String[] EbizGparent_type_info = new String[] {'EbizGparent',
																			'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL',
																			null, '1', '1', 'false'};
		@AuraEnabled  public String[] apex_schema_type_info = new String[] {'http://xmlns.oracle.com/Customer360/GetCustomerInfo/GetCustomerInfoBPEL', 'true',
																			'false'};
		@AuraEnabled  public String[] field_order_type_info = new String[] {'customer_name', 'ErrorMessage', 'AOPSTaxInfo', 'AOPSCustMstrDtls', 'AOPSCorePricing',
																			'AOPSUniversalPricing', 'AOPSCustInstructions', 'EbizBillContacts', 'EbizARBalances',
																			'EbizARCollector', 'EbizCreditLimits', 'EbizBillTerms', 'AOPSCustVhcls',
																			'AOPSCustTierDisc',
																			'AOPSCustPrefs', 'EbizGparent'};
	}
}