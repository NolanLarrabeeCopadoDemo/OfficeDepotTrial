@isTest
class SandBoxSetup_Test {

    @isTest
    static void testSandBoxSetup() {
        // Insert logic here to create records of the objects that the class you’re testing
        // manipulates.

        Test.startTest();

        Test.testSandboxPostCopyScript(
            new SandBoxSetup(), UserInfo.getOrganizationId(),
                UserInfo.getOrganizationId(), UserInfo.getOrganizationName());

        Test.stopTest();

        List<OpportunityCompetitor__c> my_competitor = [SELECT Id FROM OpportunityCompetitor__c];
        List<Sales_Person__c> my_sales_persons = [SELECT Id FROM Sales_Person__c];
        List<Exchange_Rate__c> my_exchange_rate = [SELECT Id FROM Exchange_Rate__c];
        List<Pricing_Template__c> my_pricing_template = [SELECT Id FROM Pricing_Template__c];

        System.assertNotEquals(0, my_competitor.size());
        System.assertNotEquals(0, my_sales_persons.size());
        System.assertNotEquals(0, my_exchange_rate.size());
        System.assertNotEquals(0, my_pricing_template.size());

        // Insert assert statements here to check that the records you created above have
        // the values you expect.
    }
}