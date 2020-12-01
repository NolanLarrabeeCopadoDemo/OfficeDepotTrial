@isTest
public class AventionFamilyJSON_TC {
    private static testMethod void MyunitTest() {
        AventionFamilyJSON.Addresses v = new AventionFamilyJSON.Addresses();
        v.addressType ='Home';
        v.city = 'Hyd';
        //v.state = FL;
        //v.country = USA;
        //
        AventionFamilyJSON.EntityType ent = new AventionFamilyJSON.EntityType();
        ent.name = 'test';
        AventionFamilyJSON.OwnershipType Ownr = new AventionFamilyJSON.OwnershipType();
        Ownr.id ='123456ff';
        Ownr.name ='t2';
        AventionFamilyJSON.State St = new AventionFamilyJSON.State();
        St.id ='4567kgh';
        St.name ='FL';
        St.abbreviation ='test2';
        AventionFamilyJSON.Country Contry = new AventionFamilyJSON.Country();
        Contry.id ='345678ert';
        Contry.name ='USA';
        Contry.iso2 ='sdfg';
        AventionFamilyJSON.PrimaryIndustry PI = new AventionFamilyJSON.PrimaryIndustry();
        PI.id ='34567sdfg';
        PI.shortDescription ='Private';
        AventionFamilyJSON.Results r = new AventionFamilyJSON.Results();
        r.resultType ='final';
        r.id ='34567dfghj';
        r.keyId =45;
        r.companyName ='WIPRO';
        r.primaryUrl ='w@c.com';
        r.numEmployees ='6';
        r.ultimateParentId ='5678dfgh';
        r.parentId ='4567rtyu';
        AventionFamilyJSON fZ = new AventionFamilyJSON();
        fZ.from_Z =5;
        fZ.size =3;
        fZ.total =12;
        fZ.consumedCredits =122;
        fZ.resultType ='final';
    }

}