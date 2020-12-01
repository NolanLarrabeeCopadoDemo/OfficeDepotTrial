@isTest
public class AventionMatchJSON_TC {
    private static testMethod void MyunitTest() {
        AventionMatchJSON obj = new AventionMatchJSON();
        obj.resultType ='company';
        obj.consumedBusinessContactCredits= 34;
        obj.consumedCredits= 34;
        obj.size= 34;
        AventionMatchJSON.state v = new AventionMatchJSON.state();
        v.name = 'California';
        v.id = '5d3ce39b-0a1c-3804-a38a-ddd8166ab9a2';
        v.abbreviation = 'CA';
        AventionMatchJSON.result r = new AventionMatchJSON.result();
        r.salesEur = 348600.0;
        r.salesGbp = 308766.19;
        r.salesUsd = 308766.19;
        r.sales = 8.01;
        r.directMarketingStatus = 'Has Not Opted Out of Direct Marketing';
        r.numEmployees = 3;
        r.primaryUrl ='http://www.4wtmedia.com';
        r.companyName = 'tst';
        r.keyId = 34;
        r.id = 'wetr4';
        r.resultType = 'company';
        
         AventionMatchJSON.primaryIndustry PI=new AventionMatchJSON.primaryIndustry();
        PI.id = 'fgt';
        PI.shortDescription = 'Hello';
        
        AventionMatchJSON.ownershipType O=new AventionMatchJSON.ownershipType();
        O.id = '56767';
        O.name = 'test';
        
         AventionMatchJSON.matchDetails m=new AventionMatchJSON.matchDetails();
        m.matchScore = 6;
        m.nameMatchQuality ='good';
        m.nameMatchConfidence =3;
        m.addressMatchConfidence = 5;
        m.addressMatchQuality = 'high';
        
        AventionMatchJSON.entityType e=new AventionMatchJSON.entityType();
        e.name = 'test2';
        e.id = '3456k';
        
        AventionMatchJSON.country c = new AventionMatchJSON.country();
        c.id ='3456g';
        c.name = 'tre';
        c.iso2 = 'shree';
        
        AventionMatchJSON.addresses Adds = new AventionMatchJSON.addresses();
        Adds.city ='Hyd';
        Adds.addressType ='Permanent';
            
    }

}