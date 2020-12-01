public class AventionMatchJSON{
        public String resultType{get;set;}
        public Integer consumedBusinessContactCredits{get;set;}
        public Integer consumedCredits{get;set;}
        public list<result> result{get;set;}
        public Integer size{get;set;}
    public class state{
        public String abbreviation{get;set;}
        public String name{get;set;}
        public String id{get;set;}
    }
    public class result{
        public list<addresses> addresses{get;set;}
        public Decimal salesEur{get;set;}
        public Decimal salesGbp{get;set;}
        public Decimal salesUsd{get;set;}
        public Integer numEmployees{get;set;}
        public Decimal sales{get;set;}
        public String directMarketingStatus{get;set;}
        public String primaryUrl{get;set;}
        public primaryIndustry primaryIndustry{get;set;}
        public String companyName{get;set;}
        public entityType entityType{get;set;}
        public Integer keyId{get;set;}
        public ownershipType ownershipType{get;set;}
        public String id{get;set;}
        public matchDetails matchDetails{get;set;}
        public String resultType{get;set;}
    }
    public class primaryIndustry{
        public String id{get;set;}
        public String shortDescription{get;set;}
    }
    public class ownershipType{
        public String id{get;set;}
        public String name{get;set;}
    }
    public class matchDetails{
        public Integer matchScore{get;set;}
        public String nameMatchQuality{get;set;}
        public Integer nameMatchConfidence{get;set;}
        public Integer addressMatchConfidence{get;set;}
        public String addressMatchQuality{get;set;}
    }
    public class entityType{
        public String name{get;set;}
        public String id{get;set;}
    }
    public class country{
        public String id{get;set;}
        public String name{get;set;}
        public String iso2{get;set;}
    }
    public class addresses{
        public state state{get;set;}
        public String city{get;set;}
        public country country{get;set;}
        public String addressType{get;set;}
    }
}