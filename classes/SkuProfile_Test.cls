@isTest
public class SkuProfile_Test {
    
    @isTest
    static void searchBySku() {
        Test.setMock(HttpCalloutMock.class, new SkuProfileMock('searchBySku'));
        Test.startTest();

        SkuProfile.searchBySku('999999');
        Test.stopTest();
    }
    
    @isTest
    static void findAlternates() {
        Test.setMock(HttpCalloutMock.class, new SkuProfileMock('findAlternates'));
        Test.startTest();

        SkuProfile.findAlternates('999999');
        Test.stopTest();
    }

    @isTest
    static void getStockingStrategy() {
        Test.setMock(HttpCalloutMock.class, new SkuProfileMock('getStockingStrategy'));
        Test.startTest();

        SkuProfile.getStockingStrategy('999999');
        Test.stopTest();
    }

    @isTest
    static void getCompPricing() {
        Test.setMock(HttpCalloutMock.class, new SkuProfileMock('getCompPricing'));
        Test.startTest();

        SkuProfile.getCompPricing('999999');
        Test.stopTest();
    }    

}