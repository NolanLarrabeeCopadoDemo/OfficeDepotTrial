public with sharing class AggroServiceRunner {

	public static List<AggroMatchResultV2> search_for_matches(String name,
															  String address,
															  String city,
															  String state,
															  String zip) {
		String results = AggroService.aggroSearchV2(name, address, city, state, zip);
		System.debug(LoggingLevel.DEBUG, results);

		return (List<AggroMatchResultV2>) JSON.deserialize(results, List<AggroMatchResultV2>.class);
	}

	public static String json_search_for_matches(String name, String address, String city, String state, String zip) {
		return AggroService.aggroSearchV2(name, address, city, state, zip);
	}

	public static List<Account> search_for_account_matches(String name,
														   String address,
														   String city,
														   String state,
														   String zip) {

		String results = AggroService.aggroAccountSearch(name, address, city, state, zip);
		List<Account> retrieved_account_matches = (List<Account>) JSON.deserialize(results, List<Account>.class);
		Set<Id> retrieved_account_ids = new Set<Id>();
		for (Account acc : retrieved_account_matches) {
			retrieved_account_ids.add(acc.Id);
		}
		retrieved_account_matches = [
				SELECT
						Id,
						Name,
						RecordType.Name,
						Aops_Cust_Id__c,
						OMX_Primary_Key__c,
						Owner.Full_Name__c,
						Address1__c,
						City__c,
						State__c,
						Zip__c,
						Status__c,
						YTD_Sales_Diff__c,
						Related_DML__c
				FROM Account
				WHERE Id IN :retrieved_account_ids
		];
		System.debug(LoggingLevel.INFO, retrieved_account_matches);
		return retrieved_account_matches;
	}

	public static String json_search_for_account_matches(String name,
														 String address,
														 String city,
														 String state,
														 String zip) {
		return AggroService.aggroAccountSearch(name, address, city, state, zip);
	}


	public static List<Account> getAccounts(String id_list, String recordtype_developername) {

		List<String> list_of_ids = id_list.split(',');
		System.debug(LoggingLevel.INFO, list_of_ids);
		return [
				SELECT
						Id,
						Name,
						RecordType.Name,
						Aops_Cust_Id__c,
						OMX_Primary_Key__c,
						Owner.Full_Name__c,
						Address1__c,
						City__c,
						State__c,
						Zip__c,
						Status__c,
						YTD_Sales_Diff__c,
						Related_DML__c
				FROM Account
				WHERE Id IN :list_of_ids AND RecordType.DeveloperName=:recordtype_developername
		];
	}

	public static List<Lead> getLeads(String id_list, String recordtype_developername) {
		List<String> list_of_ids = id_list.split(',');
		System.debug(LoggingLevel.INFO, list_of_ids);
		return [
				SELECT
						Id,
						Name,
						OwnerId,
						RecordType.Name
				FROM Lead
				WHERE Id IN :list_of_ids AND RecordType.DeveloperName=:recordtype_developername
		];
	}

	/*
	 * *****************************************************************************************************
	 *
	 * @author Adam Albright, adam.albright@officedepot.com, 28 May 2019
	 *
	 * @description
	 *
	 * @param
	 */
	public static Map<String, List<SObject>> full_search_for_matches(String name,
																	 String address,
																	 String city,
																	 String state,
																	 String zip) {

		Map<String, List<SObject>> search_results = new Map<String, List<SObject>> {
		'customers'=> new List<Account>(),
		'prospects'=> new List<Account>(),
		'sites'=> new List<Account>(),
		'leads'=>new List<Lead>()
		};

		String service_results = AggroService.aggroBulkSearchSyncV2(
				JSON.serialize(
						new List<Aggro_Match__c>{
								new Aggro_Match__c(
										Company_Name__c = name,
										StreetAddress__c = address,
										City__c = city,
										State__c = state,
										Zip_Code__c = zip
								)
								}
				)
		);


		System.debug(LoggingLevel.INFO, service_results);
		List<Aggro_Match__c> retrieved_matches =
				(List<Aggro_Match__c>) JSON.deserialize(service_results, List<Aggro_Match__c>.class);
		System.debug(LoggingLevel.INFO, retrieved_matches);
		if (String.isNotBlank(retrieved_matches[0].Account_Matches__c)) {
			search_results.get('customers').addAll(getAccounts(retrieved_matches[0].Account_Matches__c, 'Customer'));
			search_results.get('prospects').addAll(getAccounts(retrieved_matches[0].Account_Matches__c, 'Prospect'));
			search_results.get('sites').addAll(getAccounts(retrieved_matches[0].Account_Matches__c, 'Site'));
		}

		if (String.isNotBlank(retrieved_matches[0].Lead_Matches__c))
			search_results.get('leads').addAll(getLeads(retrieved_matches[0].Account_Matches__c, 'Lead_US'));
		return search_results;
	}
}