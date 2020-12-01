public class AventionCompanyResultJSON {

	public Integer consumedCredits;
	public Integer consumedBusinessContactCredits;
	public String resultType;
	public Result result;

	public class Industries {
		public Boolean isPrimary;
		public Industry industry;
	}
	public class Vendor_Z {
		public Integer vendorFeedId;
	}

	public class GrossProfit {
		public Double value;
		public Double gbp;
		public Double eur;
		public Double usd;
		public String statementDate;
		public String currencyISO3;
	}

	public class CurrentRatio {
		public Double value;
		public String statementDate;
	}

	public class Vendor {
		public Integer vendorFeedId;
		public String vendorFeedName;
		public String displayName;
	}

	public class County {
		public String name;
	}

	public class Result {
		// API Fix Avention included two fields mapped to entityType
		// public String entityType;
		public String id;
		public Integer keyId;
		public String dunsNumber;
		public String companyName;
		public String areaCode;
		public String phone;
		public String fiscalYearEnd;
		public Double assets;
		public Double assetsUsd;
		public Double assetsEur;
		public Double assetsGbp;
		public String currencyIso3;
		public Boolean onFortune1000;
		public Integer fortune1000Ranking;
		public Integer numEmployees;
		public Integer numOneSourceContacts;
		public String primaryUrl;
		public Boolean publicOrTopUK;
		public Boolean publicUS;
		public Boolean quotedStatus;
		public Double sales;
		public Double salesUsd;
		public Double salesEur;
		public Double salesGbp;
		public Double sales1YearGrowth;
		public Boolean topUK;
		public Boolean onBritishDoNotCallList;
		public Integer yearFounded;
		public String auditor;
		public String bank;
		public Double marketValue;
		public Double marketValueUsd;
		public Double marketValueEur;
		public Double marketValueGbp;
		public String marketValueDate;
		public Boolean gazetteCode;
		public String leId;
		public List<CurrentRatio> currentRatio;
		public List<CurrentRatio> quickRatio;
		public List<CurrentRatio> netProfitMargin;
		public List<GrossProfit> grossProfit;
		public List<CurrentRatio> grossMargin;
		public List<CurrentRatio> operatingMargin;
		public List<CurrentRatio> returnOnAssets;
		public List<CurrentRatio> returnOnEquity;
		public List<GrossProfit> cashEquivalents;
		public List<GrossProfit> leaseHirePurchaseShortTerm;
		public List<GrossProfit> totalCurrentAssets;
		public List<GrossProfit> totalCurrentLiabilities;
		public List<GrossProfit> totalShareholdersEquity;
		public List<GrossProfit> netIncome;
		public List<GrossProfit> totalDebt;
		public List<GrossProfit> longTermDebt;
		public List<GrossProfit> longTermLiabilities;
		public List<GrossProfit> totalExpenses;
		public List<GrossProfit> normalizedEBIT;
		public List<GrossProfit> normalizedEBITDA;
		public List<String> competitorIds;
		public Integer totalCorpFamilyMembers;
		public Boolean hasCompanyLogo;
		// API Fix, the \ in the result break the json parser...
		// public List<String> altNames;
		public String directMarketingStatus;
		public List<Addresses> addresses;
		public List<BusinessDescriptions> businessDescriptions;
		public List<Industries> industries;
		public List<Securities> securities;
		public Industry primaryIndustry;
		public EntityType ownershipType;
		public Vendor_Z vendor;
	}

	public class EntityType {
		public String id;
		public String name;
	}

	public class Addresses {
		public String addressType;
		public String address1;
		public String city;
		public String postalCode;
		public String postalCodePrefix;
		public County county;
		public State state;
		public Country country;
		public String zipPlus4Code;
		public Integer msaCode;
		public County nationalRegion;
	}

	public class Industry {
		public String id;
		public String source;
		public String code;
		public String shortDescription;
	}

	public class Exchange {
		public String stockExchange;
		public String quoteExchangeCode;
	}

	public class State {
		public String name;
		public String abbreviation;
	}

	public class Country {
		public String name;
		public String iso2;
		public String iso3;
		public Integer isoNumber;
		public String intlCallingCode;
		public County internationalRegion;
	}

	public class BusinessDescriptions {
		public String description;
		public Boolean isPrimary;
		public Vendor vendor;
	}

	public class Securities {
		public String tickerSymbol;
		public Exchange exchange;
	}

	
	public static AventionCompanyResultJSON parse(String json) {
		// API Fix, the \ in the result break the json parser...
		String cleaned = json.replaceAll('"\\"', '"');
		cleaned = cleaned.replaceAll('\\""', '"');
		cleaned = cleaned.replaceAll('""', '"');
		try{
			return (AventionCompanyResultJSON)System.JSON.deserialize(cleaned, AventionCompanyResultJSON.class);
		}catch (JSONException e){
			System.debug(LoggingLevel.ERROR, 'Parsing JSON String to AventionJSON Failed: ' + cleaned);
			System.debug(LoggingLevel.ERROR, e);
		}
		return null;

	}

	public Org__c toOrg(){
		Org__c org = new org__c();
		org.DUNS_Number__c = this.result.dunsNumber;
		org.D_B_ID__c = this.result.dunsNumber;
		org.Business_Name__c = this.result.companyName;
		
		for(Addresses address: this.result.addresses){
			if(address.addressType=='primary'){
				org.Address_1__c = address.address1;
				org.City__c = address.city;
				org.State__c = address.state.abbreviation;
				org.Zip__c = address.postalCode;
				break;
			}
		}
		org.Employee_Count__c = this.result.numEmployees;
		org.Annual_sales__c = this.result.salesUsd;
		org.LOB__c = this.result.primaryIndustry.shortDescription;
		org.Website__c = this.result.primaryUrl;
		return org;
	}
}