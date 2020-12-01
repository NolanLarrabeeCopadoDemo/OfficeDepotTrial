@IsTest
public class AventionCompanyJSON_TC {
    
    /*static testMethod void testParse() {
        String json = '{\"consumedCredits\":1,\"consumedBusinessContactCredits\":0,\"resultType\":\"company\",\"result\":{\"entityType\":\"company\",\"id\":\"3ebe54e4-0462-3c86-8c53-0e86de195df0\",\"keyId\":51375084,\"dunsNumber\":\"962754128\",\"companyName\":\"Target Stores, Inc.\",\"parentId\":\"1215b0cc-707c-34d5-b162-da0e74aaafcc\",\"ultimateParentId\":\"1215b0cc-707c-34d5-b162-da0e74aaafcc\",\"areaCode\":\"612\",\"phone\":\"612-354-5914\",\"fax\":\"612-304-0730\",\"currencyIso3\":\"USD\",\"onFortune1000\":false,\"numEmployees\":321000,\"numOneSourceContacts\":1,\"primaryUrl\":\"http://www.target.com\",\"publicOrTopUK\":false,\"publicUS\":false,\"quotedStatus\":false,\"sales\":2.0208635E10,\"salesUsd\":2.0208635E10,\"salesEur\":1.7899436E10,\"salesGbp\":1.5686364E10,\"topUK\":false,\"onBritishDoNotCallList\":false,\"yearFounded\":1962,\"smFacebookPage\":\"TargetStyle\",\"smTwitterHandle\":\"target\",\"gazetteCode\":false,\"totalCorpFamilyMembers\":1984,\"hasCompanyLogo\":false,\"altNames\":[\"\\\"Target Stores\\\"\"],\"directMarketingStatus\":\"Has Not Opted Out of Direct Marketing\",\"addresses\":[{\"addressType\":\"primary\",\"address1\":\"1000 Nicollet Mall\",\"city\":\"Minneapolis\",\"postalCode\":\"55403-2542\",\"postalCodePrefix\":\"554\",\"county\":{\"name\":\"Hennepin\"},\"state\":{\"name\":\"Minnesota\",\"abbreviation\":\"MN\"},\"country\":{\"name\":\"United States\",\"iso2\":\"US\",\"iso3\":\"USA\",\"isoNumber\":840,\"intlCallingCode\":\"+1\",\"internationalRegion\":{\"name\":\"North America\"}},\"zipPlus4Code\":\"2542\",\"msaCode\":33460,\"nationalRegion\":{\"name\":\"West North Central\"}}],\"businessDescriptions\":[{\"description\":\"Target Stores, Inc. is a supermarket/grocery store, primarily engaged in the retail sale of all sorts of canned foods and dry goods, such as tea, coffee, spices, sugar, and flour; fresh fruits and vegetables; and fresh and prepared meats, fish, and poultry.\",\"isPrimary\":true,\"vendor\":{\"vendorFeedId\":110,\"vendorFeedName\":\"DirectPlusUS\",\"displayName\":\"D&B\"}}],\"industries\":[{\"isPrimary\":true},{\"isPrimary\":false,\"industry\":{\"id\":\"405b92ca-c415-39c3-93fd-e8bb0a46daef\",\"source\":\"ANZSIC\",\"code\":\"4129\",\"shortDescription\":\"Other Specialised Food Retailing\"}},{\"isPrimary\":false,\"industry\":{\"id\":\"2813461b-53f0-3131-b45e-0a06d45de398\",\"source\":\"ANZSIC\",\"code\":\"4260\",\"shortDescription\":\"Department Stores\"}},{\"isPrimary\":false,\"industry\":{\"id\":\"958cf61b-16e3-3f8d-acd6-7c9757970a37\",\"source\":\"GDSSIC\",\"code\":\"53119901\",\"shortDescription\":\"Department stores, discount\"}},{\"isPrimary\":false,\"industry\":{\"id\":\"885ee267-8e0c-3569-992d-03ff21feadef\",\"source\":\"GDSSIC\",\"code\":\"54610000\",\"shortDescription\":\"Retail bakeries\"}},{\"isPrimary\":false,\"industry\":{\"id\":\"972e1688-56cc-35c9-b642-91d1008199d5\",\"source\":\"ISICRev4\",\"code\":\"4719\",\"shortDescription\":\"Other retail sale in non-specialized stores\"}},{\"isPrimary\":false,\"industry\":{\"id\":\"7735de1e-42c0-304e-a0f7-ec78d3601262\",\"source\":\"ISICRev4\",\"code\":\"4721\",\"shortDescription\":\"Retail sale of food in specialized stores\"}},{\"isPrimary\":false},{\"isPrimary\":false},{\"isPrimary\":false,\"industry\":{\"id\":\"c245a084-2827-33b6-93ea-8379ba89d6a6\",\"source\":\"NACERev2\",\"code\":\"4719\",\"shortDescription\":\"Other retail sale in non-specialised stores\"}},{\"isPrimary\":false,\"industry\":{\"id\":\"2de3bc19-50de-3092-b492-ab01177d65d8\",\"source\":\"NACERev2\",\"code\":\"4724\",\"shortDescription\":\"Retail sale of bread, cakes, flour confectionery and sugar confectionery in specialised stores\"}},{\"isPrimary\":false},{\"isPrimary\":false},{\"isPrimary\":false,\"industry\":{\"id\":\"afa5f51b-88e5-3296-b31c-a39fbfc5b56f\",\"source\":\"NAICS2012\",\"code\":\"311811\",\"shortDescription\":\"Retail Bakeries\"}},{\"isPrimary\":false,\"industry\":{\"id\":\"6d9b00c2-94d3-3e52-8c50-ebe7d23d4280\",\"source\":\"NAICS2012\",\"code\":\"452112\",\"shortDescription\":\"Discount Department Stores\"}},{\"isPrimary\":false,\"industry\":{\"id\":\"fd811094-490e-3265-bb9b-23224451f788\",\"source\":\"UK2003\",\"code\":\"5212\",\"shortDescription\":\"Other retail sale in non-specialised stores\"}},{\"isPrimary\":false,\"industry\":{\"id\":\"58a04f6d-41c9-3036-bdb2-3dacc3b06ddc\",\"source\":\"UK2003\",\"code\":\"5224\",\"shortDescription\":\"Retail sale of bread, cakes, flour confectionery and sugar confectionery\"}},{\"isPrimary\":false,\"industry\":{\"id\":\"4017e940-3363-31d0-84ef-42a027745a8f\",\"source\":\"UK2007\",\"code\":\"4719\",\"shortDescription\":\"Other retail sale in non-specialised stores\"}},{\"isPrimary\":false,\"industry\":{\"id\":\"34d5b93d-a725-304d-8e85-5deb0e03a48d\",\"source\":\"UK2007\",\"code\":\"4724\",\"shortDescription\":\"Retail sale of bread, cakes, flour confectionery and sugar confectionery in specialised stores\"}},{\"isPrimary\":false,\"industry\":{\"id\":\"ddd1cbd2-41cc-334c-b71d-e0ec6eb79364\",\"source\":\"US87\",\"code\":\"5311\",\"shortDescription\":\"Department Stores\"}},{\"isPrimary\":false,\"industry\":{\"id\":\"9483a464-2a77-307d-b3d0-ea15888869e5\",\"source\":\"US87\",\"code\":\"5461\",\"shortDescription\":\"Retail Bakeries\"}},{\"isPrimary\":true,\"industry\":{\"id\":\"0137ee3d-025e-327a-8a94-90297eaff8ef\",\"source\":\"ANZSIC\",\"code\":\"4110\",\"shortDescription\":\"Supermarket and Grocery Stores\"}},{\"isPrimary\":true,\"industry\":{\"id\":\"f9aacff3-cfca-33b3-aca3-823f96f5121e\",\"source\":\"GDSSIC\",\"code\":\"54110100\",\"shortDescription\":\"Supermarkets\"}},{\"isPrimary\":true,\"industry\":{\"id\":\"ce02922c-0182-3ee2-adcc-6d4a96ac288d\",\"source\":\"ISICRev4\",\"code\":\"4711\",\"shortDescription\":\"Retail sale in non-specialized stores with food, beverages or tobacco predominating\"}},{\"isPrimary\":true},{\"isPrimary\":true,\"industry\":{\"id\":\"5645ac7f-ec44-3a4e-ad37-fec87eae5fa3\",\"source\":\"NACERev2\",\"code\":\"4711\",\"shortDescription\":\"Retail sale in non-specialised stores with food, beverages or tobacco predominating\"}},{\"isPrimary\":true},{\"isPrimary\":true,\"industry\":{\"id\":\"934ba7bd-cfd5-362e-9740-9da372e43a13\",\"source\":\"NAICS2012\",\"code\":\"445110\",\"shortDescription\":\"Supermarkets and Other Grocery (except Convenience) Stores\"}},{\"isPrimary\":true,\"industry\":{\"id\":\"818f591d-3fb1-3c2d-8697-ef25bd8ca027\",\"source\":\"UK2003\",\"code\":\"5211\",\"shortDescription\":\"Retail sale in non-specialised stores with food, beverages or tobacco predominating\"}},{\"isPrimary\":true,\"industry\":{\"id\":\"785941f2-3c28-3422-9eb1-3a5bba8580b8\",\"source\":\"UK2007\",\"code\":\"4711\",\"shortDescription\":\"Retail sale in non-specialised stores with food, beverages or tobacco predominating\"}},{\"isPrimary\":true,\"industry\":{\"id\":\"b9e23094-343a-3c50-9b5c-05aaa416a04b\",\"source\":\"US87\",\"code\":\"5411\",\"shortDescription\":\"Grocery Stores\"}}],\"securities\":[],\"primaryIndustry\":{\"id\":\"dbf6190e-c811-3355-a0a8-73356e43db04\",\"shortDescription\":\"Grocery Stores\",\"source\":\"OS2010\",\"code\":\"73\"},\"ownershipType\":{\"id\":\"2f5c1b1d-50e0-3139-a223-cca768a59caf\",\"name\":\"Private\"},\"entityType\":{\"id\":\"7d45d9a3-8ecd-3a3f-bcf7-a02523e781de\",\"name\":\"Subsidiary\"},\"vendor\":{\"vendorFeedId\":110}}}';
        AventionCompanyJSON obj = AventionCompanyJSON.parse(json);
        System.assert(obj != null);
    }*/
    private static testMethod void MyunitTest() {
        AventionCompanyJSON.Industries Ind = new AventionCompanyJSON.Industries();
        Ind.isPrimary = true;
        
        AventionCompanyJSON.Vendor_Z V = new AventionCompanyJSON.Vendor_Z();
        V.vendorFeedId =4;
        AventionCompanyJSON.Vendor Ven = new AventionCompanyJSON.Vendor();
        Ven.vendorFeedId =3;
        Ven.vendorFeedName ='test';
        Ven.displayName ='test2';
        AventionCompanyJSON.County Coun = new AventionCompanyJSON.County();
        Coun.name ='Ind';
        AventionCompanyJSON.Result res = new AventionCompanyJSON.Result();
        res.entityTypev ='module';
        res.id ='2345678sd';
        res.keyId=2;
        res.dunsNumber='wer3456789';
        res.companyName='App';
        res.areaCode ='we';
        res.phone='346';
        res.currencyIso3='iso';
        res.onFortune1000=false;
        res.numEmployees=2;
        res.primaryUrl='url';
        res.publicOrTopUK=true;
        res.publicUS=true;
        res.quotedStatus=false;
        res.topUK=true;
        res.onBritishDoNotCallList=false;
        res.yearFounded=67;
        res.gazetteCode=true;
        res.totalCorpFamilyMembers=45;
        res.hasCompanyLogo=true;
        res.directMarketingStatus='yes';
        res.sales=567;
        res.salesUsd=87;
        res.salesEur=56;
        res.salesGbp=45678;
        
        AventionCompanyJSON.EntityType1 ent = new AventionCompanyJSON.EntityType1();
        ent.id='4567';
        ent.name='tesr';
        
        AventionCompanyJSON.Addresses address = new AventionCompanyJSON.Addresses();
        address.addressType='temporary';
        address.address1='Avenue';
        address.city='Hyd';
        address.postalCode='345345';
        address.postalCodePrefix='3568';
        address.zipPlus4Code='3456';
        address.msaCode=23;
        
        AventionCompanyJSON.Industry I = new AventionCompanyJSON.Industry();
        I.id='fgh345';
        I.source='Add';
        I.code='df';
        I.shortDescription='des';
        
        AventionCompanyJSON.State St = new AventionCompanyJSON.State();
        St.name='ter';
        St.abbreviation='abbr';
        
        AventionCompanyJSON.Country Cn = new AventionCompanyJSON.Country();
        Cn.name='test';
        Cn.iso2='iso2';
        Cn.iso3='iso3';
        Cn.isoNumber=3;
        Cn.intlCallingCode='ryu';
        
        AventionCompanyJSON.BusinessDescriptions BusDes = new AventionCompanyJSON.BusinessDescriptions();
        BusDes.description='des';
        BusDes.isPrimary=true;
        AventionCompanyJSON obj= new AventionCompanyJSON();
        obj.consumedCredits=45;
        obj.consumedBusinessContactCredits=56;
        obj.resultType='success';
        
            
    }
}