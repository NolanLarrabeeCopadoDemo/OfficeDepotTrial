/*
 * Created by Adam on 8/8/2018.
* @group Aggro
* @group-content /ApexDocContent/Index.htm
*
* @description This class is used to make an external request to the aggro for the token
*/
public with sharing class AventionCompanySearchJSON {
	
	public class Addresses {
		public String addressType;
		public String city;
		public State state;
		public Country country;
	}

	public class EntityType {
		public String id;
		public String name;
	}

	public Integer size;
	public Integer consumedCredits;
	public Integer consumedBusinessContactCredits;
	public String resultType;
	public List<Result> result;

	public class State {
		public String id;
		public String name;
		public String abbreviation;
	}

	public class Country {
		public String id;
		public String name;
		public String iso2;
	}

	public class PrimaryIndustry {
		public String id;
		public String shortDescription;
	}

	public class MatchDetails {
		public Integer matchScore;
		public String nameMatchQuality;
		public Integer nameMatchConfidence;
		public String addressMatchQuality;
		public Integer addressMatchConfidence;
	}

	public class Result {
		public String resultType;
		public String id;
		public Integer keyId;
		public String companyName;
		public String primaryUrl;
		public Double sales;
		public Double salesUsd;
		public Double salesEur;
		public Double salesGbp;
		public Integer numEmployees;
		public String directMarketingStatus;
		public List<Addresses> addresses;
		public PrimaryIndustry primaryIndustry;
		// Api Fix
		//public EntityType entityType;
		public EntityType ownershipType;
		public MatchDetails matchDetails;
	}

	
	public static AventionCompanySearchJSON parse(String json) {
		try{
			return (AventionCompanySearchJSON) System.JSON.deserialize(json, AventionCompanySearchJSON.class);
		}catch (JSONException e){
			System.debug(LoggingLevel.ERROR, 'Parsing JSON String Failed: ' + json);
		}
		return null;
	}
}