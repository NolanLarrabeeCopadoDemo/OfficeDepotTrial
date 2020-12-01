public class AventionFamilyJSON{
   public class Addresses {
		public String addressType {get;set;} 
		public String city {get;set;} 
		public State state {get;set;} 
		public Country country {get;set;} 
	}
	
	public class EntityType {
		public String name {get;set;} 
	}
	
	public class OwnershipType {
		public String id {get;set;} 
		public String name {get;set;} 
	}
	
	public Integer from_Z {get;set;} // in json: 

	public Integer size {get;set;} 
	public Integer total {get;set;} 
	public Integer consumedCredits {get;set;} 
	public String resultType {get;set;} 
	public List<Results> results {get;set;} 

	
	public class Results {
		public String resultType {get;set;} 
		public String id {get;set;} 
		public Integer keyId {get;set;} 
		public String companyName {get;set;} 
		public String primaryUrl {get;set;} 
		//public Long sales {get;set;} 
		//public Long salesUsd {get;set;} 
		//public Long salesEur {get;set;} 
		//public Long salesGbp {get;set;} 
		public String numEmployees {get;set;} 
		public List<Addresses> addresses {get;set;} 
		public PrimaryIndustry primaryIndustry {get;set;} 
		public EntityType entityType {get;set;} 
		public OwnershipType ownershipType {get;set;} 
		public String ultimateParentId {get;set;} 
		public String parentId {get;set;} 
		
	}
	
	public class State {
		public String id {get;set;} 
		public String name {get;set;} 
		public String abbreviation {get;set;} 
		
	}
	
	public class Country {
		public String id {get;set;} 
		public String name {get;set;} 
		public String iso2 {get;set;} 
	}
	
	public class PrimaryIndustry {
		public String id {get;set;} 
		public String shortDescription {get;set;} 
	}
	
}