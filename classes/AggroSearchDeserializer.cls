public class AggroSearchDeserializer {

	public class Matches {
		public Integer company_site_id;
		public String site_duns_id;
		public String street_1;
		public String street_2;
		public String city;
		public String state;
		public String zip_5;
		public String parent_duns;
		public String headquarter_duns;
		public String global_ultimate_duns_2;
		public String global_ultimate_duns_1;
		public String hierarchy_code;
		public String name;
		public String du_us_87_sic_3dig_code;
		public String employee_reliability_code;
		public String gu_us_87_sic_3dig_code;
		public String minority_business_code;
		public String public_private_indicator;
		public String subsidiary_indicator;
		public Integer site_employee_count;
		public Double site_sales;
		public String sales_reliability_code;
		public String line_of_business;
		public String total_family_members;
		public String search_name;
		public Double weight;

		public Org__c toOrg(){
			Org__c org = new org__c();
			org.Address_1__c = this.street_1;
			org.Address_2__c = this.street_2;
			org.City__c = this.city;
			org.State__c = this.state;
			org.Zip__c = this.zip_5;
			org.DUNS_Number__c = this.site_duns_id;
			org.SITE_EMPLOYEE_CNT__c = this.site_employee_count;
			org.GLOBAL_ULTIMATE_DUNS_NUM__c = this.global_ultimate_duns_1;
			org.LOB__c = this.line_of_business;
			org.Business_Name__c = this.name;
			org.SITE_SALES_AMT__c = this.site_sales;
			org.D_B_ID__c = this.site_duns_id;
			return org;
		}
	}

	public String module;
	public Data data;

	public class Data {
		public List<Matches> matches;
	}

	public List<Org__c> toOrgList(){
		List<Org__c> myOrgs = new List<Org__c>();
		// If the data we retrieved is null or not parsable return an empty list of orgs.
		try {
			for(Matches match: data.matches){
				myOrgs.add(match.toOrg());
			}
			return myOrgs;
		} catch (NullPointerException e){
			System.debug(LoggingLevel.ERROR, 'No Result data to convert to org: ' + e.getMessage());
		}

		return myOrgs;
		
	}

	public static AggroSearchDeserializer parse(String json) {
		try{
			return (AggroSearchDeserializer) System.JSON.deserialize(json, AggroSearchDeserializer.class);
		} catch (JSONException e){
			System.debug('Failed to parse Aggro Service Result String to Object: ' + e.getMessage());
		} catch (NullPointerException e){
			System.debug('Recieved a null string for parsing: ' + e.getMessage());
		}
		return new AggroSearchDeserializer();
	}
}