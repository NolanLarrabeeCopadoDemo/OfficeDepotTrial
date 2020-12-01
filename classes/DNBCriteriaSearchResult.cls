//
//Created By: Sandesh Ganjare
//

public class DNBCriteriaSearchResult{
    public cls_transactionDetail transactionDetail;
    public cls_inquiryDetail inquiryDetail;
    public Integer candidatesReturnedQuantity;  //10
    public Integer candidatesMatchedQuantity;   //4675
    public List<cls_searchCandidates> searchCandidates;
    public class cls_transactionDetail {
        public String transactionID;    //rrt-0aca93ce7256c8835-b-se-22058-588119-1
        public String transactionTimestamp; //2019-12-11T13:10:41.736Z
        public String inLanguage;   //en-US
        public String serviceVersion;   //1
    }
    public class cls_inquiryDetail {
        public cls_locationRadius locationRadius;
        public String postalCode;   //07078
    }
    public class cls_locationRadius {
        public Double lon;  //-74.362436
        public Double lat;  //40.742064
        public Integer radius;  //5
        public String unit; //km
    }
    public class cls_searchCandidates {
        public Integer displaySequence; //1
        public cls_organization organization;
    }
    public class cls_organization {
        public String duns; //004244377  ==> dunsNumber
        public cls_dunsControlStatus dunsControlStatus;
        public String primaryName;  //Dun & Bradstreet Deutschland GMBH ==>companyName
        public List<cls_tradeStyleNames> tradeStyleNames;
        public cls_primaryAddress primaryAddress;
        public List<cls_primaryIndustryCodes> primaryIndustryCodes;
        public cls_corporateLinkage corporateLinkage;
        public List<cls_financials> financials;
        public List<cls_numberOfEmployees> numberOfEmployees;
        public List<cls_industryCodes> industryCodes;
        public cls_telephone[] telephone;
        public cls_businessEntityType businessEntityType;
        public boolean isStandalone;
        public String domain;
    }
    public class cls_dunsControlStatus {
        public boolean isOutOfBusiness;
        public boolean isMarketable;
        public boolean isTelephoneDisconnected;
        public boolean isMailUndeliverable;
        public boolean isDelisted;
    }
    public class cls_tradeStyleNames {
        public String name; //D&B
        public Integer priority;    //1
    }
     public class cls_hrchyDuns {
        public String duns; //D&B
        public String primaryName;    //1
    }
    public class cls_primaryAddress {
        public cls_addressCountry addressCountry;
        public cls_addressLocality addressLocality;
        public cls_addressRegion addressRegion;
        public String postalCode;   //07078-2708
        public cls_streetAddress streetAddress;
        public Double latitude; //40.742064
        public Double longitude;    //-74.362436
    }
    public class cls_addressCountry {
        public String isoAlpha2Code;    //US
        public String name; //United States
    }
    public class cls_addressLocality {
        public String name; //Short Hills
    }
    public class cls_addressRegion {
        public String name; //New Jersey
        public String abbreviatedName;  //NJ
    }
    public class cls_streetAddress {
        public String line1;    //103 John F Kennedy Pkwy
    }
    public class cls_primaryIndustryCodes {
        public String usSicV4;  //6799
        public String usSicV4Description;   //Investor
    }
    public class cls_corporateLinkage {
        public boolean isBranch;
        public cls_hrchyDuns globalUltimate;
        public cls_hrchyDuns headQuarter;
    }
    public class cls_financials {
        public List<cls_yearlyRevenue> yearlyRevenue;
    }
    public class cls_yearlyRevenue {
        public Double value;   //396462
        //public String currency; //USD //Commented becuase the Currency keyword is reserve in Salesforce
    }
    public class cls_numberOfEmployees {
        public Integer value;   //8
        public String informationScopeDescription;  //Consolidated
        public Integer informationScopeDnBCode; //9067
        public String reliabilityDescription;   //Actual
        public Integer reliabilityDnBCode;  //9092
    }
    public class cls_industryCodes {
        public String code; //523910
        public String description;  //Miscellaneous Intermediation
        public String typeDescription;  //North American Industry Classification System 2017
        public Integer typeDnbCode; //30832
        public Integer priority;    //1
    }
    public class cls_telephone {
        public String telephoneNumber;  //9739215500
        public String isdCode;  //1
    }
    public class cls_businessEntityType {
        public Integer dnbCode; //451
        public String description;  //Corporation
    }
    public static DNBCriteriaSearchResult parse(String json){
        return (DNBCriteriaSearchResult) System.JSON.deserialize(json, DNBCriteriaSearchResult.class);
    }
}