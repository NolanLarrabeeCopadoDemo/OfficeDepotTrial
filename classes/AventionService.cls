/*
 * Created by Adam on 9/03/2018.
* @group Avention
* @group-content /ApexDocContent/Index.htm
*
* @description This class is used to make an external request to the aggro for the token
*/
public with sharing class AventionService {

	public class NullResultException extends Exception{}

	static Avention_Connection_Setting__mdt aventionDetails = [
		SELECT Avention_Search_URL__c, Avention_Company_URL__c, Avention_Access_Token__c 
		FROM Avention_Connection_Setting__mdt WHERE DeveloperName='ConnectionInfo'];
	
	/**
	 * @description Searches for orgs using Aventions API Service
	 * @param name The business name used to filter orgs....
	 * @param address The address used to filter orgs
	 * @param address_2 The secondary portion of the address, ie #1800, Ste 1
	 * @param city The city name code used to filter orgs
	 * @param state The state name code used to filter orgs
	 * @param zip_5 The zip code used to filter orgs
	 * @return List The list of orgs found via SOSL Search
	 */
	public static List<Org__c> searchAvention(String name, String address, String address_2, String city, String state, String zip_5){
		System.debug(LoggingLevel.INFO, 'Starting Avention Search...');
		List<Org__c> searchResults = new List<Org__c>();

		try{
			String business_json ='';
			String address_json ='';
			String address_2_json ='';
			String city_json ='';
			String state_json ='';
			String zip_5_json ='';
			
			String response_status;
			String response_status_code;
			AventionCompanySearchJSON companyRes;

			if(String.isNotBlank(name))
				business_json= '{"field": "company.companyName", "value":"'+ name +'" }';

			if(String.isNotBlank(address))
				address_json = '{"field": "company.addresses.address1","value": "'+ address +'" }';
			
			if(String.isNotBlank(address_2))
				address_2_json= '{"field": "company.addresses.address2","value": "'+ address_2 +'" }';
				
			if(String.isNotBlank(city))
				city_json= '{"field": "company.addresses.cityName", "value": "'+ city +'" }';
			
			if(String.isNotBlank(state))
				state_json= '{"field": "company.addresses.stateOrProvinceName", "value": "'+ state +'" }';  
				
			if(String.isNotBlank(zip_5))
				zip_5_json = '{"field":"company.addresses.postalCode","value": "'+ zip_5 +'" }';  

			String search_json = '{ "size": 50, "matchBy": [   ';
			if(business_json !='')
				search_json=  search_json + business_json +',';
			if(address_json !='')
				search_json =  search_json + address_json + ',';
			if(city_json != '')
				search_json = search_json + city_json + ',';
			if(state_json != '')
				search_json = search_json + state_json + ',';
			if(zip_5_json != '')
				search_json = search_json + zip_5_json + ',';
			search_json =  search_json + '{"field": "company.addresses.countryName","value": "United States"}]}';
			System.debug('content----' + search_json);
			String url = aventionDetails.Avention_Search_URL__c +'?api_key=' + aventionDetails.Avention_Access_Token__c;
			
			HTTPRequest req = new HTTPRequest();
			HTTP aventionHttp = new HTTP();

			req.setEndPoint(url);
			req.setHeader('Content-Type', 'application/json');
			req.setHeader('Accept', 'application/json');
			req.setMethod('POST');
			req.setBody(search_json);
			req.setTimeout(10000);
	
			HTTPResponse resp = aventionHttp.send(req);
			response_status = resp.getStatus();
			System.debug('resp-------'+resp);
			response_status_code = String.ValueOf(resp.getStatusCode());
			System.debug('resp.getBody()-------' + resp.getBody());
			AventionCompanySearchJSON companyResult = AventionCompanySearchJSON.parse(resp.getBody());

			if (companyResult.result == null || resp.getStatusCode() == 404){
				throw new NullResultException('Avention Match Results failed to parse.');
			}

			response_status  = String.ValueOf(companyResult.size);
			System.debug('response_status......'+response_status);
			
			for(AventionCompanySearchJSON.result result : companyResult.result){
				searchResults.add(companySearchRequest(String.valueOf(result.keyId)));
			}
			System.debug('searchResults..'+searchResults.size());
		} catch (CalloutException e) {
			System.debug(LoggingLevel.ERROR, 'Avention Service Search Failed...');
			System.debug(LoggingLevel.ERROR, e.getMessage());
		} catch (NullPointerException e){
			System.debug(LoggingLevel.ERROR, 'Avention Service Search Failed...');
			System.debug(LoggingLevel.ERROR, e.getMessage());
		}

		return searchResults;
	}


	
	/**
	 * @description Performs a lookup in avention service with the supplied avention look-up key
	 * @param companyKey A key for looking up the associated company information in Avention
	 * @return An Org for the company information retrieved.
	 */
	public static Org__c companySearchRequest(String companyKey) {
		String companyUrl = aventionDetails.Avention_Company_URL__c + companyKey +'?api_key=' + aventionDetails.Avention_Access_Token__c;
		Http http = new Http();
		HTTPRequest request = new HTTPRequest();
		request.setEndPoint(companyUrl);
		request.setHeader('Content-Type', 'application/json');
		request.setHeader('Accept', 'application/json');
		request.setMethod('GET');
		request.setTimeout(10000);
		try{
			HTTPResponse response = http.send(request);
			AventionCompanyResultJSON company = new AventionCompanyResultJSON();
			company = AventionCompanyResultJSON.parse(response.getBody());
			System.debug(company);
			return company.toOrg();
		} catch (CalloutException e) {
			System.debug(LoggingLevel.ERROR, 'Callout Failed, ' + e.getMessage());
		}
		return null;
	}


}