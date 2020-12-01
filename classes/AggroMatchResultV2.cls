public with sharing class AggroMatchResultV2 {
public String Id;
	public String duns_no;
	public String business_name;
	public String secondary_name;
	public String second_trade_name;
	public String street_addr;
	public String street_addr2;
	public String city;
	public String state;
	public String postal_cd;
	public String zip_code;
	public Decimal longitude;
	public Decimal latitude;
	public String global_ultimate_duns;
	public String global_ultimate_business_name; // Do not know match.
	public String ultimate_duns;
	public String ultimate_name;
	public String telephone_nbr;
	public String ceo_first_name;
	public String ceo_last_name;
	public String ceo_title;
	public Integer subsidiary_ind;
	public String small_business_ind;
	public String minority_bus_ind;
	public String public_private_ind;
	public String parent_duns;
	public String hqtr_duns;
	public String hqtr_business_name;
	public String hierarchy_cd;
	public Integer total_family_mem;
	public String lob;
	public String global_ultimate_duns_num;
	public Integer site_employee_cnt;
	public Integer global_ultimate_employee_cnt;
	public Integer employee_reliability_cd;
	public Decimal site_sales_amt;
	public Decimal global_ultimate_sales_amt;
	public Integer sales_reliability_cd;
	public Integer du_us87sic3dig_cd;
	public Integer gu_us87sic3dig_cd;
	public String s23_companyname;
	public String s33_companyname;
	public String zip;
	public String companykey_23;
	public String companykey_33;
	public String datasource;
	public Decimal score;


	public Org__c toOrg(){
		return new Org__c(
            Id=this.ID,
			Duns_Number__c = this.duns_no,
			Address_1__c = this.street_addr,
			Address_2__c = this.street_addr2,
			City__c = this.city,
			State__c = this.state,
			Zip__c = this.postal_cd,
			Location__Latitude__s = this.latitude,
			Location__Longitude__s = this.latitude,
			GLOBAL_ULTIMATE_DUNS_NUM__c = this.global_ultimate_duns,
			Ultimate_DUNS__c = this.ultimate_duns,
			Ultimate_Name__c = this.ultimate_name,
			Company_Phone__c = this.telephone_nbr,
			CEO_First_Name__c = this.ceo_first_name,
			CEO_Last_Name__c = this.ceo_last_name,
			CEO_Title__c = this.ceo_title,
			Subsidiary_Indicator__c = (this.subsidiary_ind != null ? String.valueOf(this.subsidiary_ind) : ''),
			// Small_Business_Indicator__c = Need to cast to boolean ?
			// Minority_Business_Indicator__c ''
			// Public_Private_Indicator__c ''
			Parent_DUNS__c = this.parent_duns,
			Headquarters_DUNS__c = this.hqtr_duns,
			Hierarchy_Code__c = (this.hierarchy_cd != null ? this.hierarchy_cd.left(1) : ''),
			LOB__c = this.lob,
			Employee_Count__c = this.global_ultimate_employee_cnt,
			Employee_Reliability_Code__c = (this.employee_reliability_cd != null ? String.valueOf(this.employee_reliability_cd) : ''),
		
			Business_Name__c = this.business_name,
			Alt_Business_Name_1__c = this.secondary_name,
			Alt_Business_Name_2__c = this.second_trade_name

		);
	}

	public static List<AggroMatchResultV2> parse(String json) {
		return (List<AggroMatchResultV2>) System.JSON.deserialize(json, List<AggroMatchResultV2>.class);
	}
}