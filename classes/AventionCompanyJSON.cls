public class AventionCompanyJSON {

    public class Industries {
        public Boolean isPrimary{get;set;}
        public Industry industry{get;set;}
    }

    public class Vendor_Z {
        public Integer vendorFeedId{get;set;}
    }

    public class Vendor {
        public Integer vendorFeedId{get;set;}
        public String vendorFeedName{get;set;}
        public String displayName{get;set;}
    }

    public class County {
        public String name{get;set;}
    }

    public class Result {
        public String entityTypev {get;set;}
        public String id{get;set;}
        public Integer keyId{get;set;}
        public String dunsNumber{get;set;}
        public String companyName{get;set;}
        public String areaCode{get;set;}
        public String phone{get;set;}
        public String currencyIso3{get;set;}
        public Boolean onFortune1000{get;set;}
        public Integer numEmployees{get;set;}
        public String primaryUrl{get;set;}
        public Boolean publicOrTopUK{get;set;}
        public Boolean publicUS{get;set;}
        public Boolean quotedStatus{get;set;}
        public Double sales{get;set;}
        public Double salesUsd{get;set;}
        public Double salesEur{get;set;}
        public Double salesGbp{get;set;}
        public Boolean topUK{get;set;}
        public Boolean onBritishDoNotCallList{get;set;}
        public Integer yearFounded{get;set;}
        public Boolean gazetteCode{get;set;}
        public Integer totalCorpFamilyMembers{get;set;}
        public Boolean hasCompanyLogo{get;set;}
        public List<String> altNames{get;set;}
        public String directMarketingStatus{get;set;}
        public List<Addresses> addresses{get;set;}
        public List<BusinessDescriptions> businessDescriptions{get;set;}
        public List<Industries> industries{get;set;}
        public List<String> securities{get;set;}
        public Industry primaryIndustry{get;set;}
        public EntityType1 ownershipType{get;set;}
        public Vendor_Z vendor{get;set;}
    }

    public class EntityType1 {
        public String id{get;set;}
        public String name{get;set;}
    }

    public class Addresses {
        public String addressType{get;set;}
        public String address1{get;set;}
        public String city{get;set;}
        public String postalCode{get;set;}
        public String postalCodePrefix{get;set;}
        public County county{get;set;}
        public State state{get;set;}
        public Country country{get;set;}
        public String zipPlus4Code{get;set;}
        public Integer msaCode{get;set;}
        public County nationalRegion{get;set;}
    }

    public class Industry {
        public String id{get;set;}
        public String source{get;set;}
        public String code{get;set;}
        public String shortDescription{get;set;}
    }

    public class State {
        public String name{get;set;}
        public String abbreviation{get;set;}
    }

    public class Country {
        public String name{get;set;}
        public String iso2{get;set;}
        public String iso3{get;set;}
        public Integer isoNumber{get;set;}
        public String intlCallingCode{get;set;}
        public County internationalRegion{get;set;}
    }

    public class BusinessDescriptions {
        public String description{get;set;}
        public Boolean isPrimary{get;set;}
        public Vendor vendor{get;set;}
    }

    public Integer consumedCredits{get;set;}
    public Integer consumedBusinessContactCredits{get;set;}
    public String resultType{get;set;}
    public Result result{get;set;}

  /*  public class Securities {
    }

    
    public static AventionCompanyJSON parse(String json) {
        return (AventionCompanyJSON) System.JSON.deserialize(json, AventionCompanyJSON.class);
    }*/
}